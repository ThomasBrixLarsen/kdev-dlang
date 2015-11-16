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

#include <language/duchain/builders/abstractdeclarationbuilder.h>
#include <language/duchain/builders/abstracttypebuilder.h>

#include "duchain/dduchainexport.h"
#include "contextbuilder.h"
#include "typebuilder.h"
#include "parser/dparser.h"

typedef KDevelop::AbstractDeclarationBuilder<INode, IIdentifier, dlang::TypeBuilder> DeclarationBuilderBase;

class KDEVDDUCHAIN_EXPORT DeclarationBuilder : public DeclarationBuilderBase
{
public:
	DeclarationBuilder(ParseSession *session, bool forExport);
	
	virtual KDevelop::ReferencedTopDUContext build(const KDevelop::IndexedString &url, INode *node, KDevelop::ReferencedTopDUContext updateContext = KDevelop::ReferencedTopDUContext());
	virtual void startVisiting(INode *node);
	
	virtual void visitVarDeclaration(IVariableDeclaration *node);
	/*virtual void visitShortVarDecl(dlang::ShortVarDeclAst* node);
	virtual void visitConstSpec(dlang::ConstSpecAst* node);
	virtual void visitConstDecl(dlang::ConstDeclAst* node);*/
	virtual void visitFuncDeclaration(IFunctionDeclaration *node);
	/*virtual void visitMethodDeclaration(dlang::MethodDeclarationAst* node);
	virtual void visitTypeSpec(dlang::TypeSpecAst* node);
	virtual void visitImportSpec(dlang::ImportSpecAst* node);
	virtual void visitSourceFile(dlang::SourceFileAst* node);
	virtual void visitForStmt(dlang::ForStmtAst* node);
	virtual void visitSwitchStmt(dlang::SwitchStmtAst* node);
	virtual void visitTypeCaseClause(dlang::TypeCaseClauseAst* node);
	virtual void visitExprCaseClause(dlang::ExprCaseClauseAst* node);
	
	virtual void visitTypeDecl(dlang::TypeDeclAst* node);*/
	virtual void visitClassDeclaration(IClassDeclaration *node);
	virtual void visitStructDeclaration(IStructDeclaration *node);
	virtual void visitSingleImport(ISingleImport *node);
	
	virtual void visitModule(IModule *node);
	
	/*struct GoImport{
	GoImport(bool anon, KDevelop::TopDUContext* ctx) : anonymous(anon), context(ctx) {}
	bool anonymous;
	KDevelop::TopDUContext* context;
	};*/

private:
	/**
	 * Deduces types of expression with ExpressionVisitor and declares variables
	 * from idList with respective types. If there is a single expression, returning multiple types
	 * idList will get assigned those types. Otherwise we get only first type no matter how many of them
	 * expression returns.(I believe this is how it works in Go, correct it if I'm wrong)
	 * @param declareConstant whether to declare usual variables or constants
	 */
	//void declareVariables(IIdentifier* id, dlang::IdListAst* idList, dlang::ExpressionAst* expression,
	//		    dlang::ExpressionListAst* expressionList, bool declareConstant);
	/**
	 * declares variables or constants with names from id and idList of type type.
	 */
	//void declareVariablesWithType(IIdentifier* id, dlang::IdListAst* idList, dlang::TypeAst* type, bool declareConstant);
	
	/**
	 * Declares variable with identifier @param id of type @param type
	 **/
	virtual void declareVariable(IIdentifier *id, const AbstractType::Ptr &type) override;
	
	/**
	 * Declares GoFunction and assigns contexts to it.
	 * Called from typebuilder when building functions and methods
	 **/
	virtual KDevelop::FunctionDeclaration *declareFunction(IIdentifier *id, const KDevelop::FunctionType::Ptr &type,
	        DUContext *paramContext, DUContext *retparamContext, const QByteArray &comment=QByteArray()) override;
	
	void importThisPackage();
	bool m_export;
	
	//QHash<QString, TopDUContext*> m_anonymous_imports;
	
	bool m_preBuilding;
	QList<AbstractType::Ptr> m_constAutoTypes;
	QualifiedIdentifier m_thisPackage;
	QualifiedIdentifier m_switchTypeVariable;
	QByteArray m_lastTypeComment, m_lastConstComment;
	int m_ownPriority;
};
