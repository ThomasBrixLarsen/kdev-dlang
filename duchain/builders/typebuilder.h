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

#pragma once

#include <language/duchain/builders/abstracttypebuilder.h>
#include "contextbuilder.h"
#include "duchain/dduchainexport.h"
#include "duchain/declarations/functiondeclaration.h"
#include "duchain/types/gofunctiontype.h"
#include "parser/dparser.h"

namespace dlang
{

typedef KDevelop::AbstractTypeBuilder<INode, IIdentifier, ContextBuilder> TypeBuilderBase;

class KDEVDDUCHAIN_EXPORT TypeBuilder : public TypeBuilderBase
{
public:
	virtual void visitTypeName(IType *node);
	/*virtual void visitArrayOrSliceType(dlang::ArrayOrSliceTypeAst* node);
	virtual void visitPointerType(dlang::PointerTypeAst* node);
	virtual void visitStructType(dlang::StructTypeAst* node);
	virtual void visitFieldDecl(dlang::FieldDeclAst* node);
	virtual void visitInterfaceType(dlang::InterfaceTypeAst* node);
	virtual void visitMethodSpec(dlang::MethodSpecAst* node);
	virtual void visitMapType(dlang::MapTypeAst* node);
	virtual void visitChanType(dlang::ChanTypeAst* node);
	virtual void visitFunctionType(dlang::FunctionTypeAst* node);*/
	virtual void visitParameter(IParameter *node);
	virtual void visitClassDeclaration(IClassDeclaration *node);
	virtual void visitStructDeclaration(IStructDeclaration *node);
	
	/**
	 * When building named types we often have IdentifierAst instead of TypeNameAst,
	 * so it makes sense to have this convenience function
	 **/
	void buildTypeName(IIdentifier *typeName, IIdentifier *fullName = 0);
	
	/**
	 * A shortcut for ExpressionVisitor to build function type
	 **/
	//void buildFunction(dlang::SignatureAst* node, dlang::BlockAst* block=0);
	
	/**
	 * Used by external classes like ExpressionVisitor after building a type.
	 */
	AbstractType::Ptr getLastType()
	{
		return lastType();
	}

protected:
	//when building some types we need to open declarations
	//so next methods are placeholders for that, which will be implemented in DeclarationBuilder
	//that way we can keep type building logic in TypeBuilder
	
	/**
	 * declared here as pure virtual so we can use that when building functions, structs and interfaces.
	 **/
	virtual void declareVariable(IIdentifier *id, const KDevelop::AbstractType::Ptr &type) = 0;
	
	/**
	 * declared here as pure virtual so we can use that when building functions
	 **/
	virtual KDevelop::FunctionDeclaration *declareFunction(IIdentifier *id, const KDevelop::FunctionType::Ptr &type,
	        DUContext *paramContext, DUContext *retparamContext, const QByteArray &comment=QByteArray()) = 0;
	
	/**
	 * opens FunctionType, parses it's parameters and return declaration if @param declareParameters is true.
	 **/
	KDevelop::FunctionDeclaration *parseSignature(IFunctionDeclaration *node, bool declareParameters, IIdentifier *name=0, const QByteArray &comment=QByteArray());
	
	/**
	 * Convenience function that parses function parameters.
	 * @param parseParameters if true - add parameter to function arguments, otherwise add it to return params
	 * @param declareParameters open parameter declarations if true
	 **/
	void parseParameters(IParameters *node, bool parseParameters=true, bool declareParameters=false);
	
	/**
	 * Convenience function that adds argument to function params or output params
	 **/
	void addArgumentHelper(KDevelop::FunctionType::Ptr function, KDevelop::AbstractType::Ptr argument, bool parseArguments);
	
	KDevelop::QualifiedIdentifier m_contextIdentifier;
};

}
