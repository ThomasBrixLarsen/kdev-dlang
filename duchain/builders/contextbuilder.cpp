/*************************************************************************************
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
#include "dducontext.h"
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

void ContextBuilder::visitModule(IModule *node)
{
	printf("ContextBuilder::visitModule\n");
	/*if(compilingContexts())
	{
		if(node->getModuleDeclaration())
		{
			DUChainWriteLocker lock;
			openContext(node, editorFindRange(node, 0), DUContext::Global, identifierForNode(node->getModuleDeclaration()->getName()));
			//openContext(node, editorFindRange(node, 0), DUContext::Namespace, identifierForNode(node->getModuleDeclaration()->getName()));
			lock.unlock();
		}
	}*/
	
	for(int i=0; i<node->numDeclarations(); i++)
	{
		if(node->getDeclaration(i))
			visitDeclaration(node->getDeclaration(i));
	}
	
	/*if(compilingContexts())
	{
		if(node->getModuleDeclaration())
		{
			closeContext();
			//closeContext();
		}
	}*/
}

void ContextBuilder::startVisiting(INode *node)
{
	if(!node || node == (INode *)0x1)
		return;
	//qCDebug(DUCHAIN) << "Start visiting";
	//visitNode(node);
	printf("startVisiting\n");
	switch(node->getKind())
	{
		case Kind::module_:
		{
			printf("node is a module\n");
			auto module = (IModule *)node;
			visitModule(module);
			break;
		}
		/*case Kind::moduleDeclaration:
			printf("node is a moduledecl\n");
			break;
		case Kind::functionDeclaration:
		{
			printf("node is a fdecl\n");
			auto f = (IFunctionDeclaration*)node;
			visitFuncDeclaration(f);
			//startVisiting(f->getFunctionBody());
			break;
		}*/
		/*case Kind::functionBody:
		{
			printf("node is a fbody\n");
			auto f = (IFunctionBody*)node;
			startVisiting(f->getBlockStatement());
			break;
		}
		case Kind::blockStatement:
		{
			printf("node is a block\n");
			auto f = (IBlockStatement*)node;
			openContext(node, editorFindRange(f, 0), DUContext::Other);
			//dlang::DefaultVisitor::visitBlock(node);
			closeContext();
			break;
		}*/
		default:
			printf("node kind %d is not matched\n", node->getKind());
	}
	printf("return startVisiting\n");
}

KDevelop::DUContext *ContextBuilder::contextFromNode(INode *node)
{
	return nodeContext[node];
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
	//return QualifiedIdentifier(m_session->symbol(index));
	printf("TODO: Implement indentifierForIndex\n");
	return QualifiedIdentifier();
}

void ContextBuilder::setContextOnNode(INode *node, KDevelop::DUContext *context)
{
	nodeContext.insert(node, context);
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
	//return ContextBuilderBase::newTopContext(range, file);
	return new dlang::DDUContext<TopDUContext>(m_session->currentDocument(), range, file);
}

DUContext *ContextBuilder::newContext(const RangeInRevision &range)
{
	return new dlang::DDUContext<DUContext>(range, currentContext());
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

/*dlang::IdentifierAst* ContextBuilder::identifierAstFromExpressionAst(dlang::ExpressionAst* node)
{
    if(node && node->unaryExpression && node->unaryExpression->primaryExpr)
        return node->unaryExpression->primaryExpr->id;
    return nullptr;
}

void ContextBuilder::visitIfStmt(dlang::IfStmtAst* node)
{
    //we need variables, declared in if pre-condition(if any) be available in if-block
    //and else-block, but not in parent context. We deal with it by opening another context
    //containing both if-block and else-block.
    openContext(node, editorFindRange(node, 0), DUContext::Other);
    DefaultVisitor::visitIfStmt(node);
    closeContext();
}*/

void ContextBuilder::visitFuncDeclaration(IFunctionDeclaration *node)
{
	if(node->getFunctionBody())
		visitBody(node->getFunctionBody());
}

void ContextBuilder::visitBody(IFunctionBody *node)
{
	if(node->getBlockStatement())
		visitBlock(node->getBlockStatement());
}

void ContextBuilder::visitBlock(IBlockStatement *node)
{
	//if(compilingContexts())
	//	openContext(node, editorFindRange(node, 0), DUContext::Other);
	if(node->getDeclarationsAndStatements())
		visitDeclarationsAndStatements(node->getDeclarationsAndStatements());
	//if(compilingContexts())
	//	closeContext();
}

void ContextBuilder::visitDeclarationsAndStatements(IDeclarationsAndStatements *node)
{
	printf("Visiting %d statements.\n", node->numDeclarationOrStatements());
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
	if(node->getKind() == Kind::statement)
		visitStatement((IStatement *)node);
}

void ContextBuilder::visitDeclaration(IDeclaration *node)
{
	if(node->getClassDeclaration())
		visitClassDeclaration(node->getClassDeclaration());
	if(node->getFunctionDeclaration())
		visitFuncDeclaration(node->getFunctionDeclaration());
	if(node->getImportDeclaration())
		visitImportDeclaration(node->getImportDeclaration());
	if(node->getStructDeclaration())
		visitStructDeclaration(node->getStructDeclaration());
	if(node->getVariableDeclaration())
		visitVarDeclaration(node->getVariableDeclaration());
}

void ContextBuilder::visitClassDeclaration(IClassDeclaration *node)
{
	if(node->getStructBody())
		visitStructBody(node->getStructBody());
}

void ContextBuilder::visitStructDeclaration(IStructDeclaration *node)
{
	if(node->getStructBody())
		visitStructBody(node->getStructBody());
}

void ContextBuilder::visitStructBody(IStructBody *node)
{
	printf("ContextBuilder::visitStructBody\n");
	if(compilingContexts())
		openContext(node, editorFindRange(node, 0), DUContext::Class);
	for(int i=0; i<node->numDeclarations(); i++)
	{
		if(node->getDeclaration(i))
			visitDeclaration(node->getDeclaration(i));
	}
	if(compilingContexts())
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
	if(node->getType())
		visitTypeName(node->getType());
}

void ContextBuilder::visitStatement(IStatement *node)
{
	if(node->getStatementNoCaseNoDefault())
		visitStatementNoCaseNoDefault(node->getStatementNoCaseNoDefault());
}

void ContextBuilder::visitStatementNoCaseNoDefault(IStatementNoCaseNoDefault *node)
{
	if(node->getExpressionStatement())
		visitExpressionStatement(node->getExpressionStatement());
}

void ContextBuilder::visitExpressionStatement(IExpressionStatement *node)
{
	for(int i=0; i<node->numItems(); i++)
		visitExpressionNode(node->getItem(i));
}

void ContextBuilder::visitExpressionNode(IExpressionNode *node)
{
	if(node->getPrimaryExpression())
		visitPrimaryExpression(node->getPrimaryExpression());
	if(node->getAddExpression())
		visitAddExpression(node->getAddExpression());
	if(node->getAssignExpression())
		visitAssignExpression(node->getAssignExpression());
	if(node->getFunctionCallExpression())
		visitFunctionCallExpression(node->getFunctionCallExpression());
	if(node->getUnaryExpression())
		visitUnaryExpression(node->getUnaryExpression());
}

void ContextBuilder::visitPrimaryExpression(IPrimaryExpression *node)
{
	
}

void ContextBuilder::visitAddExpression(IAddExpression *node)
{
	if(node->getLeft())
		visitExpressionNode(node->getLeft());
	if(node->getRight())
		visitExpressionNode(node->getRight());
}

void ContextBuilder::visitUnaryExpression(IUnaryExpression *node)
{
	if(node->getPrimaryExpression())
		visitPrimaryExpression(node->getPrimaryExpression());
	if(node->getFunctionCallExpression())
		visitFunctionCallExpression(node->getFunctionCallExpression());
	if(node->getUnaryExpression())
		visitUnaryExpression(node->getUnaryExpression());
}

void ContextBuilder::visitAssignExpression(IAssignExpression *node)
{
	printf("Assign expression!\n");
	if(node->getAssignedExpression())
		visitExpressionNode(node->getAssignedExpression());
	if(node->getTernaryExpression())
		visitExpressionNode(node->getTernaryExpression());
}

void ContextBuilder::visitDeclarator(IDeclarator *node)
{
	if(node->getInitializer())
		visitInitializer(node->getInitializer());
}

void ContextBuilder::visitInitializer(IInitializer *node)
{
	if(node->getAssignedExpression())
		visitExpressionNode(node->getAssignedExpression());
}

void ContextBuilder::visitImportDeclaration(IImportDeclaration *node)
{
	for(int i=0; i<node->numImports(); i++)
	{
		if(node->getImport(i))
			visitSingleImport(node->getImport(i));
	}
}

void ContextBuilder::visitFunctionCallExpression(IFunctionCallExpression *node)
{
	if(node->getUnaryExpression())
		visitUnaryExpression(node->getUnaryExpression());
	if(node->getType())
		visitTypeName(node->getType());
}
