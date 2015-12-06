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

#include <language/duchain/builders/abstractdeclarationbuilder.h>
#include <language/duchain/builders/abstracttypebuilder.h>
#include <language/duchain/types/abstracttype.h>
#include <language/duchain/types/functiontype.h>

#include "duchain/dduchainexport.h"
#include "contextbuilder.h"
#include "typebuilder.h"
#include "parser/dparser.h"

typedef KDevelop::AbstractDeclarationBuilder<INode, IToken, dlang::TypeBuilder> DeclarationBuilderBase;

class KDEVDDUCHAIN_EXPORT DeclarationBuilder : public DeclarationBuilderBase
{
public:
	DeclarationBuilder(ParseSession *session, bool forExport);
	
	virtual KDevelop::ReferencedTopDUContext build(const KDevelop::IndexedString &url, INode *node, KDevelop::ReferencedTopDUContext updateContext = KDevelop::ReferencedTopDUContext()) override;
	
	virtual void startVisiting(INode *node) override;
	virtual void visitModule(IModule *node) override;
	virtual void visitVarDeclaration(IVariableDeclaration *node) override;
	virtual void visitFuncDeclaration(IFunctionDeclaration *node) override;
	virtual void visitClassDeclaration(IClassDeclaration *node) override;
	virtual void visitStructDeclaration(IStructDeclaration *node) override;
	virtual void visitInterfaceDeclaration(IInterfaceDeclaration *node) override;
	virtual void visitSingleImport(ISingleImport *node) override;
	virtual void visitParameter(IParameter *node) override;
	virtual void visitForeachType(IForeachType *node) override;
	virtual void visitLabeledStatement(ILabeledStatement *node) override;
	virtual void visitDebugSpecification(IDebugSpecification *node) override;
	virtual void visitVersionSpecification(IVersionSpecification *node) override;
	virtual void visitCatch(ICatch *node) override;

private:
	/**
	 * Declares variable with identifier @param id of type @param type.
	 **/
	virtual void declareVariable(IToken *id, const KDevelop::AbstractType::Ptr &type) override;

private:
	bool m_export;
	bool inClassScope;
	
	bool m_preBuilding;
	int m_ownPriority;
};
