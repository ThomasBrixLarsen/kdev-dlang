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
	return UseBuilderBase::build(url, node, updateContext);
}

void UseBuilder::startVisiting(INode *node)
{
	UseBuilderBase::startVisiting(node);
}

void UseBuilder::visitTypeName(IType *node)
{
	/*if(!node || !currentContext())
		return;
	QualifiedIdentifier id(identifierForNode(node->getName()));
	//if(node->type_resolve->fullName)
	//	id.push(identifierForNode(node->type_resolve->fullName));
	DUContext *context = nullptr;
	{
		DUChainReadLocker lock;
		context = currentContext()->findContextIncluding(editorFindRange(node, 0));
	}
	if(!context)
	{
		qDebug() << "No context found for" << id;
		return;
	}
	DeclarationPointer decl = getTypeDeclaration(id, context);
	if(decl)
	{
		printf("--New use: %s of %s, context: %s\n", node->getName()->getString(), decl.data()->toString().toLocal8Bit().constData(), decl->context()->scopeIdentifier(true).toString().toLocal8Bit().constData());
		//newUse(node, decl);
	}
	else
		printf("--Failed to find declaration for typeName use: %s\n", node->getName()->getString());*/
}

void UseBuilder::visitVarDeclaration(IVariableDeclaration *node)
{
	UseBuilderBase::visitVarDeclaration(node);
}

void UseBuilder::visitDeclarator(IDeclarator *node)
{
	if(!node || !currentContext())
		return;
	UseBuilderBase::visitDeclarator(node);
}

void UseBuilder::visitBlock(IBlockStatement *node)
{
	UseBuilderBase::visitBlock(node);
}

void UseBuilder::visitPrimaryExpression(IPrimaryExpression *node)
{
	UseBuilderBase::visitPrimaryExpression(node);
	if(!node->getIdentifier() || !currentContext())
		return;
	
	QualifiedIdentifier id(identifierForNode(node->getIdentifier()));
	DUContext *context = nullptr;
	{
		DUChainReadLocker lock;
		context = currentContext()->findContextIncluding(editorFindRange(node->getIdentifier(), 0));
	}
	if(!context)
	{
		qDebug() << "No context found for" << id;
		return;
	}
	DeclarationPointer decl = getDeclaration(id, context);
	if(decl)
		newUse(node, editorFindRange(node->getIdentifier(), node->getIdentifier()), decl);
}

void UseBuilder::visitUnaryExpression(IUnaryExpression *node)
{
	UseBuilderBase::visitUnaryExpression(node);
	if(!node->getIdentifier() || !currentContext())
		return;
	
	QualifiedIdentifier id(identifierForNode(node->getIdentifier()));
	DUContext *context = nullptr;
	{
		DUChainReadLocker lock;
		context = currentContext()->findContextIncluding(editorFindRange(node->getIdentifier(), 0));
	}
	if(!context)
	{
		qDebug() << "No context found for" << id;
		return;
	}
	DeclarationPointer decl = getDeclaration(id, context);
	//if(decl)
		//newUse(node, decl);
}

}
