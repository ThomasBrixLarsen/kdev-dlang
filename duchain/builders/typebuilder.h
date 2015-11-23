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

typedef KDevelop::AbstractTypeBuilder<INode, IIdentifier, ContextBuilder> TypeBuilderBase;

class KDEVDDUCHAIN_EXPORT TypeBuilder : public TypeBuilderBase
{
public:
	virtual void visitTypeName(IType *node);
	virtual void visitParameter(IParameter *node);
	virtual void visitClassDeclaration(IClassDeclaration *node);
	virtual void visitStructDeclaration(IStructDeclaration *node);
	virtual void visitFuncDeclaration(IFunctionDeclaration *node);
	
	void buildTypeName(IIdentifier *typeName, IIdentifier *fullName = 0);
	
	KDevelop::AbstractType::Ptr getLastType()
	{
		return lastType();
	}

protected:
	virtual void declareVariable(IIdentifier *id, const KDevelop::AbstractType::Ptr &type) = 0;
	
	KDevelop::QualifiedIdentifier m_contextIdentifier;
	
	KDevelop::FunctionType::Ptr currentFunctionType;
};

}
