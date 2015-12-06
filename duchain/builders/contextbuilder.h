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

#include <language/duchain/builders/abstractcontextbuilder.h>

#include "parser/parsesession.h"
#include "duchain/dduchainexport.h"

typedef KDevelop::AbstractContextBuilder<INode, IToken> ContextBuilderBase;

class Editor
{
public:
	Editor(ParseSession **session) : m_session(session)
	{
		
	}
	
	ParseSession *parseSession() const
	{
		return *m_session;
	}

private:
	ParseSession **m_session;
};


class KDEVDDUCHAIN_EXPORT ContextBuilder : public ContextBuilderBase
{
public:
	ContextBuilder();
	virtual ~ContextBuilder();
	
	virtual KDevelop::ReferencedTopDUContext build(const KDevelop::IndexedString &url, INode *node, KDevelop::ReferencedTopDUContext updateContext = KDevelop::ReferencedTopDUContext()) override;
	
	virtual void startVisiting(INode *node) override;
	virtual void visitBlock(IBlockStatement *node, bool openContext);
	virtual void visitBody(IFunctionBody *node);
	virtual void visitFuncDeclaration(IFunctionDeclaration *node);
	virtual void visitParameter(IParameter *node);
	virtual void visitModule(IModule *node);
	virtual void visitDeclarationsAndStatements(IDeclarationsAndStatements *node);
	virtual void visitDeclaration(IDeclaration *node);
	virtual void visitVarDeclaration(IVariableDeclaration *node);
	virtual void visitClassDeclaration(IClassDeclaration *node);
	virtual void visitStructDeclaration(IStructDeclaration *node);
	virtual void visitStructBody(IStructBody *node);
	virtual void visitStatement(IStatement *node);
	virtual void visitStatementNoCaseNoDefault(IStatementNoCaseNoDefault *node);
	virtual void visitExpressionStatement(IExpressionStatement *node);
	virtual void visitExpressionNode(IExpressionNode *node);
	virtual void visitExpression(IExpression *node);
	virtual void visitPrimaryExpression(IPrimaryExpression *node);
	virtual void visitAddExpression(IAddExpression *node);
	virtual void visitUnaryExpression(IUnaryExpression *node);
	virtual void visitAssignExpression(IAssignExpression *node);
	virtual void visitDeclarator(IDeclarator *node);
	virtual void visitInitializer(IInitializer *node);
	virtual void visitImportDeclaration(IImportDeclaration *node);
	virtual void visitFunctionCallExpression(IFunctionCallExpression *node);
	virtual void visitSingleImport(ISingleImport *node);
	virtual void visitTypeName(IType *node) = 0;
	virtual void visitIfStatement(IIfStatement *node);
	virtual void visitCmpExpression(ICmpExpression *node);
	virtual void visitRelExpression(IRelExpression *node);
	virtual void visitEqualExpression(IEqualExpression *node);
	virtual void visitShiftExpression(IShiftExpression *node);
	virtual void visitIdentityExpression(IIdentityExpression *node);
	virtual void visitInExpression(IInExpression *node);
	virtual void visitArguments(IArguments *node);
	virtual void visitReturnStatement(IReturnStatement *node);
	virtual void visitWhileStatement(IWhileStatement *node);
	virtual void visitForStatement(IForStatement *node);
	virtual void visitForeachStatement(IForeachStatement *node);
	virtual void visitDeclarationOrStatement(IDeclarationOrStatement *node);
	virtual void visitForeachType(IForeachType *node);
	virtual void visitDoStatement(IDoStatement *node);
	virtual void visitSwitchStatement(ISwitchStatement *node);
	virtual void visitFinalSwitchStatement(IFinalSwitchStatement *node);
	virtual void visitCaseStatement(ICaseStatement *node);
	virtual void visitCaseRangeStatement(ICaseRangeStatement *node);
	virtual void visitDefaultStatement(IDefaultStatement *node);
	virtual void visitLabeledStatement(ILabeledStatement *node);
	virtual void visitBreakStatement(IBreakStatement *node);
	virtual void visitContinueStatement(IContinueStatement *node);
	virtual void visitGotoStatement(IGotoStatement *node);
	virtual void visitToken(IToken *node);
	virtual KDevelop::DUContext *contextFromNode(INode *node) override;
	
	virtual void setContextOnNode(INode *node, KDevelop::DUContext *context) override;
	
	virtual KDevelop::RangeInRevision editorFindRange(INode *fromNode, INode *toNode) override;
	
	virtual KDevelop::QualifiedIdentifier identifierForNode(IToken *node) override;
	virtual KDevelop::QualifiedIdentifier identifierForNode(IIdentifierChain *node);
	virtual KDevelop::QualifiedIdentifier identifierForNode(IIdentifierOrTemplateChain *node);
	virtual KDevelop::QualifiedIdentifier identifierForNode(ISymbol *node);
	
	KDevelop::QualifiedIdentifier identifierForIndex(qint64 index);
	
	void setParseSession(ParseSession *session);
	
	virtual KDevelop::TopDUContext *newTopContext(const KDevelop::RangeInRevision &range, KDevelop::ParsingEnvironmentFile *file=0) override;
	
	virtual KDevelop::DUContext *newContext(const KDevelop::RangeInRevision &range) override;
	
	KDevelop::QualifiedIdentifier createFullName(IToken *package, IToken *typeName);
	
	ParseSession *parseSession();
	
	Editor *editor() const
	{
		return m_editor.data();
	}

protected:
	ParseSession *m_session;
	QStringList identifierChain;
	
	bool m_mapAst; //Make KDevelop::AbstractContextBuilder happy.
	QScopedPointer<Editor> m_editor; //Make KDevelop::AbstractUseBuilder happy.
};
