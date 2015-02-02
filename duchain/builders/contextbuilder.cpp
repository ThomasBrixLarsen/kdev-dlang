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
#include "goducontext.h"
#include "duchaindebug.h"

using namespace KDevelop;

ContextBuilder::ContextBuilder()
{
    m_mapAst = false;
}


ContextBuilder::~ContextBuilder()
{

}

KDevelop::ReferencedTopDUContext ContextBuilder::build(const KDevelop::IndexedString& url, INode* node, KDevelop::ReferencedTopDUContext updateContext)
{
    return KDevelop::AbstractContextBuilder< INode, IIdentifier >::build(url, node, updateContext);
}

void ContextBuilder::visitModule(IModule* node)
{
	for(int i=0; i<node->numDeclarations(); i++)
		startVisiting(node->getDeclaration(i));
}

//This is really visitDeclaration.
void ContextBuilder::startVisiting(INode* node)
{
	if(!node || node == (INode*)0x1)
		return;
	//qCDebug(DUCHAIN) << "Start visiting";
	//visitNode(node);
	printf("startVisiting\n");
	switch(node->getKind())
	{
		case Kind::module_:
		{
			printf("node is a module\n");
			auto module = (IModule*)node;
			visitModule(module);
			break;
		}
		case Kind::moduleDeclaration:
			printf("node is a moduledecl\n");
			break;
		case Kind::functionDeclaration:
		{
			printf("node is a fdecl\n");
			auto f = (IFunctionDeclaration*)node;
			visitFuncDeclaration(f);
			//startVisiting(f->getFunctionBody());
			break;
		}
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
			//go::DefaultVisitor::visitBlock(node);
			closeContext();
			break;
		}*/
		default:
			printf("node is not matched\n");
	}
	printf("return startVisiting\n");
}

KDevelop::DUContext* ContextBuilder::contextFromNode(INode* node)
{
    return nodeContext[node];
}

KDevelop::RangeInRevision ContextBuilder::editorFindRange(INode* fromNode, INode* toNode)
{
    if(!fromNode)
		return KDevelop::RangeInRevision();
    return m_session->findRange(fromNode, toNode? toNode : fromNode);
}

KDevelop::QualifiedIdentifier ContextBuilder::identifierForNode(IIdentifier* node)
{
    if(!node)
		return QualifiedIdentifier();
	return QualifiedIdentifier(node->getString());
}

KDevelop::QualifiedIdentifier ContextBuilder::identifierForIndex(qint64 index)
{
    //return QualifiedIdentifier(m_session->symbol(index));
	printf("TODO: Implement indentifierForIndex\n");
	return QualifiedIdentifier();
}

void ContextBuilder::setContextOnNode(INode* node, KDevelop::DUContext* context)
{
    nodeContext.insert(node, context);
}

void ContextBuilder::setParseSession(ParseSession* session)
{
	m_session = session;
}

TopDUContext* ContextBuilder::newTopContext(const RangeInRevision& range, ParsingEnvironmentFile* file)
{
    if(!file)
	{
        file = new ParsingEnvironmentFile(m_session->currentDocument());
        file->setLanguage(m_session->languageString());
    }
    //return ContextBuilderBase::newTopContext(range, file);
    return new go::GoDUContext<TopDUContext>(m_session->currentDocument(), range, file);
}

DUContext* ContextBuilder::newContext(const RangeInRevision& range)
{
    return new go::GoDUContext<DUContext>(range, currentContext());
}


QualifiedIdentifier ContextBuilder::createFullName(IIdentifier* package, IIdentifier* typeName)
{
    QualifiedIdentifier id(QString::fromLocal8Bit(package->getString()) + "." + QString::fromLocal8Bit(typeName->getString()));
    return id;
}

ParseSession* ContextBuilder::parseSession()
{
	return m_session;
}

/*go::IdentifierAst* ContextBuilder::identifierAstFromExpressionAst(go::ExpressionAst* node)
{
    if(node && node->unaryExpression && node->unaryExpression->primaryExpr)
        return node->unaryExpression->primaryExpr->id;
    return nullptr;
}


void ContextBuilder::visitIfStmt(go::IfStmtAst* node)
{
    //we need variables, declared in if pre-condition(if any) be available in if-block
    //and else-block, but not in parent context. We deal with it by opening another context
    //containing both if-block and else-block.
    openContext(node, editorFindRange(node, 0), DUContext::Other);
    DefaultVisitor::visitIfStmt(node);
    closeContext();
}*/

void ContextBuilder::visitFuncDeclaration(IFunctionDeclaration* node)
{
	//Overriden in declaration.
}

void ContextBuilder::visitBody(IFunctionBody* node)
{
	if(node->getBlockStatement())
		visitBlock(node->getBlockStatement());
}

void ContextBuilder::visitBlock(IBlockStatement* node)
{
    openContext(node, editorFindRange(node, 0), DUContext::Other);
    //visit decls.
	visitDeclarationsAndStatements(node->getDeclarationsAndStatements());
    closeContext();
}

void ContextBuilder::visitDeclarationsAndStatements(IDeclarationsAndStatements* node)
{
	for(int i=0; i<node->numDeclarationOrStatements(); i++)
		visitDeclarationOrStatement(node->getDeclarationOrStatement(i));
}

void ContextBuilder::visitDeclarationOrStatement(INode* node)
{
	if(!node)
		return;
	if(node->getKind() == Kind::declaration)
		visitDeclaration((IDeclaration*)node);
}

void ContextBuilder::visitDeclaration(IDeclaration* node)
{
	if(node->getVariableDeclaration())
		visitVarDeclaration(node->getVariableDeclaration());
}

void ContextBuilder::visitVarDeclaration(IVariableDeclaration* node)
{
	//Overriden in declaration.
}

void ContextBuilder::visitParameter(IParameter* node)
{
	
}
