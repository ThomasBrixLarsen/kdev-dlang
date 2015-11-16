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

#include "usebuilder.h"

#include "helper.h"
#include "duchaindebug.h"

using namespace KDevelop;

namespace dlang
{

UseBuilder::UseBuilder(ParseSession *session)
{
	setParseSession(session);
}

ReferencedTopDUContext UseBuilder::build(const IndexedString &url, INode *node, ReferencedTopDUContext updateContext)
{
	qCDebug(DUCHAIN) << "Uses builder run";
	printf("Finding uses ---------------------------\n");
	return UseBuilderBase::build(url, node, updateContext);
}

void UseBuilder::startVisiting(INode *node)
{
	ContextBuilder::startVisiting(node);
}

void UseBuilder::visitTypeName(IType *node)
{
	if(!node)
		return;
	QualifiedIdentifier id(identifierForNode(node->getName()));
	//if(node->type_resolve->fullName)
	//	id.push(identifierForNode(node->type_resolve->fullName));
	DUContext *context = nullptr;
	{
		DUChainReadLocker lock;
		context = currentContext()->findContextIncluding(editorFindRange(node, 0));
		printf("--context: %p\n", context);
	}
	DeclarationPointer decl = getTypeDeclaration(id, context);
	if(decl)
	{
		printf("--New use: %s of %s\n", node->getName()->getString(), decl.data()->toString().toLocal8Bit().constData());
		newUse(node, decl);
	}
	else
		printf("--Failed to find declaration for use: %s\n", node->getName()->getString());
}

void UseBuilder::visitVarDeclaration(IVariableDeclaration *node)
{
	UseBuilderBase::visitVarDeclaration(node);
}

void UseBuilder::visitDeclarator(IDeclarator *node, IType *type)
{
	QualifiedIdentifier id(identifierForNode(node->getName()));
	DUContext *context;
	{
		DUChainReadLocker lock;
		context = currentContext()->findContextIncluding(editorFindRange(node->getName(), 0));
	}
	DeclarationPointer decl = getTypeDeclaration(id, context);
	if(decl)
	{
		printf("--New use: %s of %s\n", node->getName()->getString(), decl.data()->toString().toLocal8Bit().constData());
		newUse(node, decl);
	}
}

/*void UseBuilder::visitPrimaryExpr(PrimaryExprAst* node)
{
	DUContext* context;
	{
		DUChainReadLocker lock;
		//context = currentContext()->findContextAt(editorFindRange(node, 0).start);
		context = currentContext()->findContextIncluding(editorFindRange(node, 0));
	}
	if(!context) return;
	ExpressionVisitor visitor(m_session, context);
	visitor.visitPrimaryExpr(node);
	auto ids = visitor.allIds();
	auto decls = visitor.allDeclarations();
	if(ids.size() != decls.size())
		return;
	for(int i=0; i<ids.size(); ++i)
	newUse(ids.at(i), decls.at(i));
	//build uses in subexpressions
	dlang::DefaultVisitor::visitPrimaryExpr(node);
}
*/

void UseBuilder::visitBlock(IBlockStatement *node)
{
	ContextBuilder::visitBlock(node);
	//if(node->getDeclarationsAndStatements())
	//	visitDeclarationsAndStatements(node->getDeclarationsAndStatements());
}

void UseBuilder::visitPrimaryExpression(IPrimaryExpression *node)
{
	ContextBuilder::visitPrimaryExpression(node);
	if(!node->getIdentifier())
		return;
	
	printf("primaryExpression: %s\n", node->getIdentifier()->getString());
	
	QualifiedIdentifier id(identifierForNode(node->getIdentifier()));
	DUContext *context = nullptr;
	{
		DUChainReadLocker lock;
		context = currentContext()->findContextIncluding(editorFindRange(node->getIdentifier(), 0));
		printf("--context: %p\n", context);
	}
	DeclarationPointer decl = getDeclaration(id, context);
	if(decl)
	{
		printf("--New primary use: %s of %s\n", node->getIdentifier()->getString(), decl.data()->toString().toLocal8Bit().constData());
		newUse(node, decl);
	}
}

void UseBuilder::visitUnaryExpression(IUnaryExpression *node)
{
	ContextBuilder::visitUnaryExpression(node);
	if(!node->getIdentifier())
		return;
	
	printf("unaryExpression: %s\n", node->getIdentifier()->getString());
	
	QualifiedIdentifier id(identifierForNode(node->getIdentifier()));
	DUContext *context = nullptr;
	{
		DUChainReadLocker lock;
		context = currentContext()->findContextIncluding(editorFindRange(node->getIdentifier(), 0));
		printf("--context: %p\n", context);
	}
	DeclarationPointer decl = getDeclaration(id, context);
	if(decl)
	{
		printf("--New unary use: %s of %s\n", node->getIdentifier()->getString(), decl.data()->toString().toLocal8Bit().constData());
		newUse(node, decl);
	}
}

void UseBuilder::visitSingleImport(ISingleImport *node)
{
	
}

}
