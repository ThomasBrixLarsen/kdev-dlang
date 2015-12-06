/*************************************************************************************
 *  Copyright (C) 2015 by Thomas Brix Larsen <brix@brix-verden.dk>                   *
 *  Copyright (C) 2014 by Pavel Petrushkov <onehundredof@gmail.com>                  *
 *                                                                                   *
 *  This program is free software; you can redistribute it and/or                    *
 *  modify it under the terms of the GNU General Public License                      *
 *  as published by the Free Software Foundation; either version 2                   *
 *  of the License, or (at your option) any later version.                           *
 *                                                                                   *
 *  This program is distributed in the hope that it will be useful,                  *
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of                   *
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the                    *
 *  GNU General Public License for more details.                                     *
 *                                                                                   *
 *  You should have received a copy of the GNU General Public License                *
 *  along with this program; if not, write to the Free Software                      *
 *  Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA   *
 *************************************************************************************/

#include <language/duchain/types/delayedtype.h>

#include "contextbuilder.h"
#include "duchaindebug.h"

using namespace KDevelop;

ContextBuilder::ContextBuilder()
{
	m_mapAst = false;
}

ContextBuilder::~ContextBuilder()
{
	
}

KDevelop::ReferencedTopDUContext ContextBuilder::build(const KDevelop::IndexedString &url, INode *node, KDevelop::ReferencedTopDUContext updateContext)
{
	return KDevelop::AbstractContextBuilder<INode, IToken>::build(url, node, updateContext);
}

void ContextBuilder::startVisiting(INode *node)
{
	if(!node || node == (INode *)0x1)
		return;
	
	if(node->getKind() == Kind::module_)
	{
		auto module = (IModule *)node;
		visitModule(module);
	}
}

void ContextBuilder::visitModule(IModule *node)
{
	for(int i=0; i<node->numDeclarations(); i++)
	{
		if(auto n = node->getDeclaration(i))
			visitDeclaration(n);
	}
}

KDevelop::DUContext *ContextBuilder::contextFromNode(INode *node)
{
	return (KDevelop::DUContext *)node->getContext();
}

KDevelop::RangeInRevision ContextBuilder::editorFindRange(INode *fromNode, INode *toNode)
{
	if(!fromNode)
		return KDevelop::RangeInRevision();
	return m_session->findRange(fromNode, toNode? toNode : fromNode);
}

KDevelop::QualifiedIdentifier ContextBuilder::identifierForNode(IToken *node)
{
	if(!node || node == (IToken *)0x1)
		return QualifiedIdentifier();
	return QualifiedIdentifier(node->getText());
}

KDevelop::QualifiedIdentifier ContextBuilder::identifierForNode(IIdentifierChain *node)
{
	if(!node)
		return QualifiedIdentifier();
	QualifiedIdentifier ident;
	for(int i=0; i<node->numIdentifiers(); i++)
		ident.push(Identifier(node->getIdentifier(i)->getText()));
	return ident;
}

KDevelop::QualifiedIdentifier ContextBuilder::identifierForNode(IIdentifierOrTemplateChain *node)
{
	if(!node)
		return QualifiedIdentifier();
	QualifiedIdentifier ident;
	for(int i=0; i<node->numIdentifiersOrTemplateInstances(); i++)
		ident.push(Identifier(node->getIdentifiersOrTemplateInstance(i)->getIdentifier()->getText()));
	return ident;
}

KDevelop::QualifiedIdentifier ContextBuilder::identifierForNode(ISymbol *node)
{
	if(!node)
		return QualifiedIdentifier();
	return identifierForNode(node->getIdentifierOrTemplateChain());
}

KDevelop::QualifiedIdentifier ContextBuilder::identifierForIndex(qint64 index)
{
	Q_UNUSED(index)
	printf("TODO: Implement indentifierForIndex\n");
	return QualifiedIdentifier();
}

void ContextBuilder::setContextOnNode(INode *node, KDevelop::DUContext *context)
{
	node->setContext(context);
}

void ContextBuilder::setParseSession(ParseSession *session)
{
	m_session = session;
}

TopDUContext *ContextBuilder::newTopContext(const RangeInRevision &range, ParsingEnvironmentFile *file)
{
	if(!file)
	{
		file = new ParsingEnvironmentFile(m_session->currentDocument());
		file->setLanguage(m_session->languageString());
	}
	return new KDevelop::TopDUContext(m_session->currentDocument(), range, file);
}

DUContext *ContextBuilder::newContext(const RangeInRevision &range)
{
	return new KDevelop::DUContext(range, currentContext());
}

QualifiedIdentifier ContextBuilder::createFullName(IToken *package, IToken *typeName)
{
	QualifiedIdentifier id(QString::fromLocal8Bit(package->getText()) + "." + QString::fromLocal8Bit(typeName->getText()));
	return id;
}

ParseSession *ContextBuilder::parseSession()
{
	return m_session;
}

void ContextBuilder::visitSingleImport(ISingleImport *node)
{
	DUChainWriteLocker lock;
	QList<ReferencedTopDUContext> contexts = m_session->contextForImport(identifierForNode(node->getIdentifierChain()));
	if(contexts.length() > 0 && node->getIdentifierChain()->numIdentifiers() > 0)
		currentContext()->addImportedParentContext(contexts[0], CursorInRevision(node->getIdentifierChain()->getIdentifier(0)->getLine(), node->getIdentifierChain()->getIdentifier(0)->getColumn()));
	topContext()->updateImportsCache();
}

void ContextBuilder::visitFuncDeclaration(IFunctionDeclaration *node)
{
	openContext(node, editorFindRange(node->getReturnType(), node->getFunctionBody()), DUContext::Function, node->getName());
	
	if(node->getParameters())
	{
		for(int i=0; i<node->getParameters()->numParameters(); i++)
		{
			if(auto n = node->getParameters()->getParameter(i))
				visitParameter(n);
		}
	}
	
	if(auto n = node->getFunctionBody())
		visitBody(n);
	closeContext();
}

void ContextBuilder::visitBody(IFunctionBody *node)
{
	openContext(node, DUContext::Other);
	if(auto n = node->getBlockStatement())
		visitBlock(n, false);
	closeContext();
}

void ContextBuilder::visitBlock(IBlockStatement *node, bool openContext)
{
	if(openContext)
		ContextBuilder::openContext(node, DUContext::Other);
	if(node->getDeclarationsAndStatements())
		visitDeclarationsAndStatements(node->getDeclarationsAndStatements());
	if(openContext)
		closeContext();
}

void ContextBuilder::visitDeclarationsAndStatements(IDeclarationsAndStatements *node)
{
	for(int i=0; i<node->numDeclarationsAndStatements(); i++)
	{
		if(node->getDeclarationsAndStatement(i))
		{
			if(node->getDeclarationsAndStatement(i)->getDeclaration())
				visitDeclaration(node->getDeclarationsAndStatement(i)->getDeclaration());
			if(node->getDeclarationsAndStatement(i)->getStatement())
				visitStatement(node->getDeclarationsAndStatement(i)->getStatement());
		}
	}
}

void ContextBuilder::visitDeclaration(IDeclaration *node)
{
	if(auto n = node->getClassDeclaration())
		visitClassDeclaration(n);
	else if(auto n = node->getFunctionDeclaration())
		visitFuncDeclaration(n);
	else if(auto n = node->getImportDeclaration())
		visitImportDeclaration(n);
	else if(auto n = node->getStructDeclaration())
		visitStructDeclaration(n);
	else if(auto n = node->getVariableDeclaration())
		visitVarDeclaration(n);
	else if(auto n = node->getDebugSpecification())
		visitDebugSpecification(n);
	else if(auto n = node->getVersionSpecification())
		visitVersionSpecification(n);
	
	for(int i=0; i<node->numDeclarations(); i++)
		visitDeclaration(node->getDeclaration(i));
}

void ContextBuilder::visitClassDeclaration(IClassDeclaration *node)
{
	if(auto n = node->getStructBody())
		visitStructBody(n);
}

void ContextBuilder::visitStructDeclaration(IStructDeclaration *node)
{
	if(auto n = node->getStructBody())
		visitStructBody(n);
}

void ContextBuilder::visitStructBody(IStructBody *node)
{
	openContext(node, editorFindRange(node, 0), DUContext::Class);
	for(int i=0; i<node->numDeclarations(); i++)
	{
		if(auto n = node->getDeclaration(i))
			visitDeclaration(n);
	}
	closeContext();
}

void ContextBuilder::visitVarDeclaration(IVariableDeclaration *node)
{
	if(node->getType())
		visitTypeName(node->getType());
	for(int i=0; i<node->numDeclarators(); i++)
		visitDeclarator(node->getDeclarator(i));
}

void ContextBuilder::visitParameter(IParameter *node)
{
	if(auto n = node->getType())
		visitTypeName(n);
}

void ContextBuilder::visitStatement(IStatement *node)
{
	if(auto n = node->getStatementNoCaseNoDefault())
		visitStatementNoCaseNoDefault(n);
	if(auto n = node->getCaseStatement())
		visitCaseStatement(n);
	if(auto n = node->getCaseRangeStatement())
		visitCaseRangeStatement(n);
	if(auto n = node->getDefaultStatement())
		visitDefaultStatement(n);
}

void ContextBuilder::visitStatementNoCaseNoDefault(IStatementNoCaseNoDefault *node)
{
	if(auto n = node->getExpressionStatement())
		visitExpressionStatement(n);
	if(auto n = node->getIfStatement())
		visitIfStatement(n);
	if(auto n = node->getConditionalStatement())
		visitConditionalStatement(n);
	if(auto n = node->getBlockStatement())
		visitBlock(n, true);
	if(auto n = node->getReturnStatement())
		visitReturnStatement(n);
	if(auto n = node->getWhileStatement())
		visitWhileStatement(n);
	if(auto n = node->getForStatement())
		visitForStatement(n);
	if(auto n = node->getForeachStatement())
		visitForeachStatement(n);
	if(auto n = node->getDoStatement())
		visitDoStatement(n);
	if(auto n = node->getSwitchStatement())
		visitSwitchStatement(n);
	if(auto n = node->getFinalSwitchStatement())
		visitFinalSwitchStatement(n);
	if(auto n = node->getLabeledStatement())
		visitLabeledStatement(n);
	if(auto n = node->getBreakStatement())
		visitBreakStatement(n);
	if(auto n = node->getContinueStatement())
		visitContinueStatement(n);
	if(auto n = node->getGotoStatement())
		visitGotoStatement(n);
}

void ContextBuilder::visitIfStatement(IIfStatement *node)
{
	if(node->getThenStatement())
	{
		visitExpression(node->getExpression());
		if(auto n = node->getThenStatement()->getDeclaration())
			visitDeclaration(n);
		if(auto n = node->getThenStatement()->getStatement())
			visitStatement(n);
	}
	if(node->getElseStatement())
	{
		if(auto n = node->getElseStatement()->getDeclaration())
			visitDeclaration(n);
		if(auto n = node->getElseStatement()->getStatement())
			visitStatement(n);
	}
}

void ContextBuilder::visitConditionalStatement(IConditionalStatement *node)
{
	if(auto n = node->getCompileCondition())
		visitCompileCondition(n);
	//TODO: Open context.
	if(auto n = node->getTrueStatement())
		visitDeclarationOrStatement(n);
	//TODO: Open context.
	if(auto n = node->getFalseStatement())
		visitDeclarationOrStatement(n);
}

void ContextBuilder::visitCompileCondition(ICompileCondition *node)
{
	if(auto n = node->getDebugCondition())
		visitDebugCondition(n);
	if(auto n = node->getStaticIfCondition())
		visitStaticIfCondition(n);
	if(auto n = node->getVersionCondition())
		visitVersionCondition(n);
}

void ContextBuilder::visitDebugSpecification(IDebugSpecification *node)
{
	Q_UNUSED(node)
}

void ContextBuilder::visitDebugCondition(IDebugCondition *node)
{
	if(auto n = node->getIdentifierOrInteger())
		visitToken(n);
}

void ContextBuilder::visitStaticIfCondition(IStaticIfCondition *node)
{
	if(auto n = node->getAssignExpression())
		visitExpressionNode(n);
}

void ContextBuilder::visitVersionSpecification(IVersionSpecification *node)
{
	Q_UNUSED(node)
}

void ContextBuilder::visitVersionCondition(IVersionCondition *node)
{
	if(auto n = node->getToken())
		visitToken(n);
}

void ContextBuilder::visitExpressionStatement(IExpressionStatement *node)
{
	visitExpression(node->getExpression());
}

void ContextBuilder::visitExpressionNode(IExpressionNode *node)
{
	if(!node)
		return;
	if(auto n = node->getPrimaryExpression())
		visitPrimaryExpression(n);
	else if(auto n = node->getAddExpression())
		visitAddExpression(n);
	else if(auto n = node->getAssignExpression())
		visitAssignExpression(n);
	else if(auto n = node->getFunctionCallExpression())
		visitFunctionCallExpression(n);
	else if(auto n = node->getUnaryExpression())
		visitUnaryExpression(n);
	else if(auto n = node->getExpression())
		visitExpression(n);
	else if(auto n = node->getCmpExpression())
		visitCmpExpression(n);
	else if(auto n = node->getRelExpression())
		visitRelExpression(n);
	else if(auto n = node->getEqualExpression())
		visitEqualExpression(n);
	else if(auto n = node->getShiftExpression())
		visitShiftExpression(n);
	else if(auto n = node->getIdentityExpression())
		visitIdentityExpression(n);
	else if(auto n = node->getInExpression())
		visitInExpression(n);
}

void ContextBuilder::visitExpression(IExpression *node)
{
	for(int i=0; i<node->numItems(); i++)
		visitExpressionNode(node->getItem(i));
}

void ContextBuilder::visitInExpression(IInExpression *node)
{
	visitExpressionNode(node->getLeft());
	visitExpressionNode(node->getRight());
}

void ContextBuilder::visitIdentityExpression(IIdentityExpression *node)
{
	visitExpressionNode(node->getLeft());
	visitExpressionNode(node->getRight());
}

void ContextBuilder::visitShiftExpression(IShiftExpression *node)
{
	visitExpressionNode(node->getLeft());
	visitExpressionNode(node->getRight());
}

void ContextBuilder::visitEqualExpression(IEqualExpression *node)
{
	visitExpressionNode(node->getLeft());
	visitExpressionNode(node->getRight());
}

void ContextBuilder::visitRelExpression(IRelExpression *node)
{
	visitExpressionNode(node->getLeft());
	visitExpressionNode(node->getRight());
}

void ContextBuilder::visitCmpExpression(ICmpExpression *node)
{
	visitExpressionNode(node->getShiftExpression());
	visitExpressionNode(node->getEqualExpression());
	visitExpressionNode(node->getIdentityExpression());
	visitExpressionNode(node->getRelExpression());
	visitExpressionNode(node->getInExpression());
}

void ContextBuilder::visitPrimaryExpression(IPrimaryExpression *node)
{
	if(node->getIdentifierOrTemplateInstance())
		identifierChain.append(QString::fromUtf8(node->getIdentifierOrTemplateInstance()->getIdentifier()->getText()));
	Q_UNUSED(node)
}

void ContextBuilder::visitAddExpression(IAddExpression *node)
{
	if(auto n = node->getLeft())
		visitExpressionNode(n);
	if(auto n = node->getRight())
		visitExpressionNode(n);
}

void ContextBuilder::visitUnaryExpression(IUnaryExpression *node)
{
	if(auto n = node->getPrimaryExpression())
		visitPrimaryExpression(n);
	else if(auto n = node->getFunctionCallExpression())
		visitFunctionCallExpression(n);
	else if(auto n = node->getUnaryExpression())
		visitUnaryExpression(n);
}

void ContextBuilder::visitAssignExpression(IAssignExpression *node)
{
	if(auto n = node->getExpression())
		visitExpressionNode(n);
	if(auto n = node->getTernaryExpression())
		visitExpressionNode(n);
}

void ContextBuilder::visitDeclarator(IDeclarator *node)
{
	if(auto n = node->getInitializer())
		visitInitializer(n);
}

void ContextBuilder::visitInitializer(IInitializer *node)
{
	if(!node->getNonVoidInitializer())
		return;
	if(auto n = node->getNonVoidInitializer()->getAssignExpression())
		visitExpressionNode(n);
}

void ContextBuilder::visitImportDeclaration(IImportDeclaration *node)
{
	for(int i=0; i<node->numSingleImports(); i++)
	{
		if(auto n = node->getSingleImport(i))
			visitSingleImport(n);
	}
}

void ContextBuilder::visitFunctionCallExpression(IFunctionCallExpression *node)
{
	identifierChain.clear();
	if(auto n = node->getUnaryExpression())
		visitUnaryExpression(n);
	if(auto n = node->getType())
		visitTypeName(n);
	if(auto n = node->getArguments())
		visitArguments(n);
	identifierChain.clear();
}

void ContextBuilder::visitArguments(IArguments *node)
{
	auto list = node->getArgumentList();
	if(!list)
		return;
	for(int i=0; i<list->numItems(); i++)
		visitExpressionNode(list->getItem(i));
}

void ContextBuilder::visitReturnStatement(IReturnStatement *node)
{
	if(auto n = node->getExpression())
		visitExpression(n);
}

void ContextBuilder::visitWhileStatement(IWhileStatement *node)
{
	ContextBuilder::openContext(node, DUContext::Other);
	if(auto n = node->getDeclarationOrStatement())
		visitDeclarationOrStatement(n);
	if(auto n = node->getExpression())
		visitExpression(n);
	closeContext();
}

void ContextBuilder::visitForStatement(IForStatement *node)
{
	ContextBuilder::openContext(node, DUContext::Other);
	if(auto n = node->getInitialization())
		visitDeclarationOrStatement(n);
	if(auto n = node->getTest())
		visitExpression(n);
	if(auto n = node->getIncrement())
		visitExpression(n);
	if(auto n = node->getDeclarationOrStatement())
		visitDeclarationOrStatement(n);
	closeContext();
}

void ContextBuilder::visitForeachStatement(IForeachStatement *node)
{
	ContextBuilder::openContext(node, DUContext::Other);
	if(auto n = node->getForeachType())
		visitForeachType(n);
	if(auto n = node->getForeachTypeList())
	{
		for(int i=0; i<n->numItems(); i++)
			visitForeachType(n->getItem(i));
	}
	if(auto n = node->getLow())
		visitExpression(n);
	if(auto n = node->getHigh())
		visitExpression(n);
	if(auto n = node->getDeclarationOrStatement())
		visitDeclarationOrStatement(n);
	closeContext();
}

void ContextBuilder::visitDeclarationOrStatement(IDeclarationOrStatement *node)
{
	if(auto n = node->getDeclaration())
		visitDeclaration(n);
	if(auto n = node->getStatement())
		visitStatement(n);
}

void ContextBuilder::visitDoStatement(IDoStatement *node)
{
	//Do.
	ContextBuilder::openContext(node, DUContext::Other);
	if(auto n = node->getStatementNoCaseNoDefault())
		visitStatementNoCaseNoDefault(n);
	closeContext();
	//While.
	if(auto n = node->getExpression())
		visitExpression(n);
}

void ContextBuilder::visitSwitchStatement(ISwitchStatement *node)
{
	if(auto n = node->getExpression())
		visitExpression(n);
	if(auto n = node->getStatement())
		visitStatement(n);
}

void ContextBuilder::visitFinalSwitchStatement(IFinalSwitchStatement *node)
{
	if(auto n = node->getSwitchStatement())
		visitSwitchStatement(n);
}

void ContextBuilder::visitCaseStatement(ICaseStatement *node)
{
	for(int i=0; i<node->getArgumentList()->numItems(); i++)
		visitExpressionNode(node->getArgumentList()->getItem(i));
	if(auto n = node->getDeclarationsAndStatements())
		visitDeclarationsAndStatements(n);
}

void ContextBuilder::visitCaseRangeStatement(ICaseRangeStatement *node)
{
	if(auto n = node->getLow())
		visitExpressionNode(n);
	if(auto n = node->getHigh())
		visitExpressionNode(n);
	if(auto n = node->getDeclarationsAndStatements())
		visitDeclarationsAndStatements(n);
}

void ContextBuilder::visitDefaultStatement(IDefaultStatement *node)
{
	if(auto n = node->getDeclarationsAndStatements())
		visitDeclarationsAndStatements(n);
}

void ContextBuilder::visitLabeledStatement(ILabeledStatement *node)
{
	if(auto n = node->getDeclarationOrStatement())
		visitDeclarationOrStatement(n);
}

void ContextBuilder::visitBreakStatement(IBreakStatement *node)
{
	if(auto n = node->getLabel())
		visitToken(n);
}

void ContextBuilder::visitContinueStatement(IContinueStatement *node)
{
	if(auto n = node->getLabel())
		visitToken(n);
}

void ContextBuilder::visitGotoStatement(IGotoStatement *node)
{
	if(auto n = node->getLabel())
		visitToken(n);
	if(auto n = node->getExpression())
		visitExpression(n);
}

void ContextBuilder::visitToken(IToken *node)
{
	Q_UNUSED(node)
}

void ContextBuilder::visitForeachType(IForeachType *node)
{
	if(auto n = node->getType())
		visitTypeName(n);
}
