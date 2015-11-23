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
	return KDevelop::AbstractContextBuilder< INode, IIdentifier >::build(url, node, updateContext);
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

KDevelop::QualifiedIdentifier ContextBuilder::identifierForNode(IIdentifier *node)
{
	if(!node || node == (IIdentifier *)0x1)
		return QualifiedIdentifier();
	return QualifiedIdentifier(node->getString());
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

QualifiedIdentifier ContextBuilder::createFullName(IIdentifier *package, IIdentifier *typeName)
{
	QualifiedIdentifier id(QString::fromLocal8Bit(package->getString()) + "." + QString::fromLocal8Bit(typeName->getString()));
	return id;
}

ParseSession *ContextBuilder::parseSession()
{
	return m_session;
}

void ContextBuilder::visitSingleImport(ISingleImport *node)
{
	DUChainWriteLocker lock;
	QList<ReferencedTopDUContext> contexts = m_session->contextForImport(node->getModuleName()->getString());
	if(contexts.length() > 0)
		currentContext()->addImportedParentContext(contexts[0], CursorInRevision(node->getModuleName()->getLine(), node->getModuleName()->getColumn()));
	topContext()->updateImportsCache();
}

void ContextBuilder::visitFuncDeclaration(IFunctionDeclaration *node)
{
	openContext(node, editorFindRange(node->getReturnType(), node->getFunctionBody()), DUContext::Function, node->getName());
	
	if(node->getParameters())
	{
		for(int i=0; i<node->getParameters()->getNumParameters(); i++)
		{
			if(auto n = node->getParameters()->getParameter(i))
				visitParameter(n);
		}
	}
	
	if(auto n = node->getFunctionBody())
	{
		openContext(node->getFunctionBody(), DUContext::Other);
		visitBody(n);
		closeContext();
	}
	closeContext();
}

void ContextBuilder::visitBody(IFunctionBody *node)
{
	if(auto n = node->getBlockStatement())
		visitBlock(n);
}

void ContextBuilder::visitBlock(IBlockStatement *node)
{
	if(node->getDeclarationsAndStatements())
		visitDeclarationsAndStatements(node->getDeclarationsAndStatements());
}

void ContextBuilder::visitDeclarationsAndStatements(IDeclarationsAndStatements *node)
{
	for(int i=0; i<node->numDeclarationOrStatements(); i++)
	{
		if(node->getDeclarationOrStatement(i))
			visitDeclarationOrStatement(node->getDeclarationOrStatement(i));
	}
}

void ContextBuilder::visitDeclarationOrStatement(INode *node)
{
	if(!node)
		return;
	if(node->getKind() == Kind::declaration)
		visitDeclaration((IDeclaration *)node);
	else if(node->getKind() == Kind::statement)
		visitStatement((IStatement *)node);
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
}

void ContextBuilder::visitStatementNoCaseNoDefault(IStatementNoCaseNoDefault *node)
{
	if(auto n = node->getExpressionStatement())
		visitExpressionStatement(n);
}

void ContextBuilder::visitExpressionStatement(IExpressionStatement *node)
{
	for(int i=0; i<node->numItems(); i++)
		visitExpressionNode(node->getItem(i));
}

void ContextBuilder::visitExpressionNode(IExpressionNode *node)
{
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
}

void ContextBuilder::visitPrimaryExpression(IPrimaryExpression *node)
{
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
	if(auto n = node->getAssignedExpression())
		visitExpressionNode(n);
	else if(auto n = node->getTernaryExpression())
		visitExpressionNode(n);
}

void ContextBuilder::visitDeclarator(IDeclarator *node)
{
	if(auto n = node->getInitializer())
		visitInitializer(n);
}

void ContextBuilder::visitInitializer(IInitializer *node)
{
	if(auto n = node->getAssignedExpression())
		visitExpressionNode(n);
}

void ContextBuilder::visitImportDeclaration(IImportDeclaration *node)
{
	for(int i=0; i<node->numImports(); i++)
	{
		if(auto n = node->getImport(i))
			visitSingleImport(n);
	}
}

void ContextBuilder::visitFunctionCallExpression(IFunctionCallExpression *node)
{
	if(auto n = node->getUnaryExpression())
		visitUnaryExpression(n);
	else if(auto n = node->getType())
		visitTypeName(n);
}
