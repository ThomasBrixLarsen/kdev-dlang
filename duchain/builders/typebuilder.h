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

#pragma once

#include <language/duchain/builders/abstracttypebuilder.h>
#include <language/duchain/types/abstracttype.h>
#include <language/duchain/types/functiontype.h>

#include "contextbuilder.h"
#include "duchain/dduchainexport.h"
#include "parser/dparser.h"

namespace dlang
{

typedef KDevelop::AbstractTypeBuilder<INode, IToken, ContextBuilder> TypeBuilderBase;

class KDEVDDUCHAIN_EXPORT TypeBuilder : public TypeBuilderBase
{
public:
	virtual void visitTypeName(IType *node) override;
	virtual void visitParameter(IParameter *node) override;
	virtual void visitClassDeclaration(IClassDeclaration *node) override;
	virtual void visitStructDeclaration(IStructDeclaration *node) override;
	virtual void visitInterfaceDeclaration(IInterfaceDeclaration *node) override;
	virtual void visitFuncDeclaration(IFunctionDeclaration *node) override;
	virtual void visitEnumDeclaration(IEnumDeclaration *node) override;
	virtual void visitEnumMember(IEnumMember *node) override;
	
	void buildTypeName(KDevelop::QualifiedIdentifier typeName);
	
	KDevelop::AbstractType::Ptr getLastType()
	{
		return lastType();
	}

protected:
	virtual void declareVariable(IToken *id, const KDevelop::AbstractType::Ptr &type) = 0;
	
	KDevelop::QualifiedIdentifier m_contextIdentifier;
	
	KDevelop::FunctionType::Ptr currentFunctionType;

private:
	int enumValueCounter;
};

}
