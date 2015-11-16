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

#include "declarationbuilder.h"

#include <interfaces/icore.h>
#include <interfaces/ilanguagecontroller.h>
#include <language/backgroundparser/backgroundparser.h>
#include <language/duchain/duchainlock.h>
#include <language/duchain/duchain.h>
#include <language/duchain/types/integraltype.h>
#include <language/duchain/types/arraytype.h>
#include <language/duchain/types/functiontype.h>
#include <language/duchain/types/identifiedtype.h>
#include <language/duchain/types/pointertype.h>
#include <language/duchain/classdeclaration.h>
#include <language/duchain/topducontext.h>
#include <language/duchain/namespacealiasdeclaration.h>
#include <language/duchain/duchainutils.h>

#include "helper.h"
#include "duchaindebug.h"

using namespace KDevelop;


DeclarationBuilder::DeclarationBuilder(ParseSession *session, bool forExport) : m_export(forExport), m_preBuilding(false), m_lastTypeComment(), m_lastConstComment(), m_ownPriority(0)
{
	setParseSession(session);
}

KDevelop::ReferencedTopDUContext DeclarationBuilder::build(const KDevelop::IndexedString &url, INode *node, KDevelop::ReferencedTopDUContext updateContext)
{
	qCDebug(DUCHAIN) << "DeclarationBuilder start";
	if(!m_preBuilding)
	{
		qCDebug(DUCHAIN) << "Running prebuilder";
		DeclarationBuilder preBuilder(m_session, m_export);
		preBuilder.m_preBuilding = true;
		updateContext = preBuilder.build(url, node, updateContext);
	}
	return DeclarationBuilderBase::build(url, node, updateContext);
}

void DeclarationBuilder::startVisiting(INode *node)
{
	{
		DUChainWriteLocker lock;
		topContext()->clearImportedParentContexts();
		topContext()->updateImportsCache();
	}
	
	return DeclarationBuilderBase::startVisiting(node);
}

void DeclarationBuilder::visitVarDeclaration(IVariableDeclaration *node)
{
	DeclarationBuilderBase::visitVarDeclaration(node);
	if(!lastType())
		injectType(AbstractType::Ptr(new IntegralType(IntegralType::TypeNone)));
	//lastType()->setModifiers(declareConstant ? AbstractType::ConstModifier : AbstractType::NoModifiers);
	for(int i=0; i<node->numDeclarators(); i++)
	{
		declareVariable(node->getDeclarator(i)->getName(), lastType());
		//if(declareConstant) m_constAutoTypes.append(lastType());
	}
}

/*void DeclarationBuilder::visitShortVarDecl(dlang::ShortVarDeclAst* node)
{
    declareVariables(node->id, node->idList, node->expression, node->expressionList, false);
}

void DeclarationBuilder::declareVariablesWithType(dlang::IdentifierAst* id, dlang::IdListAst* idList, dlang::TypeAst* type, bool declareConstant)
{
	m_contextIdentifier = identifierForNode(id);
	visitType(type);
	if(!lastType())
		injectType(AbstractType::Ptr(new IntegralType(IntegralType::TypeNone)));
	lastType()->setModifiers(declareConstant ? AbstractType::ConstModifier : AbstractType::NoModifiers);
	if(identifierForNode(id).toString() != "_")
	{
		declareVariable(id, lastType());
	}
	if(declareConstant) m_constAutoTypes.append(lastType());

	if(idList)
	{
		auto iter = idList->idSequence->front(), end = iter;
		do
		{
				if(identifierForNode(iter->element).toString() != "_")
				{
					declareVariable(iter->element, lastType());
				}
			if(declareConstant)
					m_constAutoTypes.append(lastType());
			iter = iter->next;
		}
		while (iter != end);
	}
}


void DeclarationBuilder::declareVariables(dlang::IdentifierAst* id, dlang::IdListAst* idList, dlang::ExpressionAst* expression,
					    dlang::ExpressionListAst* expressionList, bool declareConstant)
{
    m_contextIdentifier = identifierForNode(id);
    QList<AbstractType::Ptr> types;
    if(!expression)
	return;
    dlang::ExpressionVisitor exprVisitor(m_session, currentContext(), this);
    exprVisitor.visitExpression(expression);
    Q_ASSERT(exprVisitor.lastTypes().size() != 0);
    if(!expressionList)
	types = exprVisitor.lastTypes();
    else
    {
	types.append(exprVisitor.lastTypes().first());
	auto iter = expressionList->expressionsSequence->front(), end = iter;
	do
	{
	    exprVisitor.clearAll();
	    exprVisitor.visitExpression(iter->element);
	    Q_ASSERT(exprVisitor.lastTypes().size() != 0);
	    types.append(exprVisitor.lastTypes().first());
	    iter = iter->next;
	}
	while (iter != end);
    }

    if(types.size() == 0)
	return;
    for(AbstractType::Ptr& type : types)
	type->setModifiers(declareConstant ? AbstractType::ConstModifier : AbstractType::NoModifiers);
    if(declareConstant)
	m_constAutoTypes = types;

    if(identifierForNode(id).toString() != "_")
    {
        declareVariable(id, types.first());
    }

    if(idList)
    {
	int typeIndex = 1;
        auto iter = idList->idSequence->front(), end = iter;
        do
	{
	    if(typeIndex >= types.size()) //not enough types to declare all variables
		return;
            if(identifierForNode(iter->element).toString() != "_")
            {
                declareVariable(iter->element, types.at(typeIndex));
            }
            iter = iter->next;
	    typeIndex++;
	}
	while (iter != end);
    }
}*/

void DeclarationBuilder::declareVariable(IIdentifier *id, const AbstractType::Ptr &type)
{
	if(type->modifiers() & AbstractType::ConstModifier)
		setComment(m_lastConstComment);
	DUChainWriteLocker lock;
	Declaration *dec = openDeclaration<Declaration>(identifierForNode(id), editorFindRange(id, 0));
	dec->setType<AbstractType>(type);
	dec->setKind(Declaration::Instance);
	closeDeclaration();
}

void DeclarationBuilder::visitClassDeclaration(IClassDeclaration *node)
{
	DeclarationBuilderBase::visitClassDeclaration(node);
	if(node->getComment())
		setComment(node->getComment()->getString());
	DUChainWriteLocker lock;
	Declaration *dec = openDeclaration<Declaration>(identifierForNode(node->getName()), editorFindRange(node->getName(), 0));
	dec->setType<AbstractType>(lastType());
	dec->setKind(KDevelop::Declaration::Type);
	closeDeclaration();
}

void DeclarationBuilder::visitStructDeclaration(IStructDeclaration *node)
{
	DeclarationBuilderBase::visitStructDeclaration(node);
	if(node->getComment())
		setComment(node->getComment()->getString());
	DUChainWriteLocker lock;
	Declaration *dec = openDeclaration<Declaration>(identifierForNode(node->getName()), editorFindRange(node->getName(), 0));
	dec->setType<AbstractType>(lastType());
	dec->setKind(KDevelop::Declaration::Type);
	closeDeclaration();
}

/*void DeclarationBuilder::visitConstDecl(dlang::ConstDeclAst* node)
{
    m_constAutoTypes.clear();
    m_lastConstComment = m_session->commentBeforeToken(node->startToken);
    //adding const declaration code, just like in GoDoc
    m_lastConstComment.append(m_session->textForNode(node).toUtf8());
    dlang::DefaultVisitor::visitConstDecl(node);
    m_lastConstComment = QByteArray();
}


void DeclarationBuilder::visitConstSpec(dlang::ConstSpecAst* node)
{
    if(node->type)
    {
	declareVariablesWithType(node->id, node->idList, node->type, true);
    }else if(node->expression)
    {
	declareVariables(node->id, node->idList, node->expression, node->expressionList, true);
    }else
    {//this can only happen after a previous constSpec with some expressionList
	//in this case identifiers assign same types as previous constSpec(http://golang.org/ref/spec#Constant_declarations)
	if(m_constAutoTypes.size() == 0)
	    return;
	{
            declareVariable(node->id, m_constAutoTypes.first());
	}

	if(node->idList)
	{
	    int typeIndex = 1;
	    auto iter = node->idList->idSequence->front(), end = iter;
	    do
	    {
		if(typeIndex >= m_constAutoTypes.size()) //not enough types to declare all constants
		    return;

                declareVariable(iter->element, m_constAutoTypes.at(typeIndex));
		iter = iter->next;
		typeIndex++;
	    }
	    while (iter != end);
	}
    }
}*/

void DeclarationBuilder::visitFuncDeclaration(IFunctionDeclaration *node)
{
	auto name = node->getName();
	printf("name: %s\n", name->getString());
	if(node->getComment())
		printf("comment: %s\n", node->getComment()->getString());
	KDevelop::FunctionDeclaration *decl = parseSignature(node, true, node->getName(), node->getComment()? node->getComment()->getString() : "");
	DeclarationBuilderBase::setEncountered(decl);
	if(!node->getFunctionBody())
		return;
	//a context will be opened when visiting block, but we still open another one here
	//so we can import arguments into it.(same goes for methodDeclaration)
	DUContext *bodyContext = openContext(node->getFunctionBody(), DUContext::ContextType::Function, node->getName());
	{
		//import parameters into body context
		DUChainWriteLocker lock;
		if(decl->internalContext())
			currentContext()->addImportedParentContext(decl->internalContext());
		//if(decl->returnArgsContext())
		//	currentContext()->addImportedParentContext(decl->returnArgsContext());
	}
	
	DeclarationBuilderBase::visitFuncDeclaration(node);
	{
		DUChainWriteLocker lock;
		lastContext()->setType(DUContext::Function);
		decl->setInternalFunctionContext(lastContext()); //inner block context
		decl->setKind(Declaration::Instance);
	}
	closeContext(); //body wrapper context
}

/*void DeclarationBuilder::visitMethodDeclaration(dlang::MethodDeclarationAst* node)
{
    Declaration* declaration=0;
    if(node->methodRecv)
    {
	dlang::IdentifierAst* actualtype=0;
	if(node->methodRecv->ptype)
	    actualtype = node->methodRecv->ptype;
	else if(node->methodRecv->type)
	    actualtype = node->methodRecv->type;
	else
	    actualtype = node->methodRecv->nameOrType;
	DUChainWriteLocker lock;
	declaration = openDeclaration<Declaration>(identifierForNode(actualtype), editorFindRange(actualtype, 0));
	declaration->setKind(Declaration::Namespace);
	openContext(node, editorFindRange(node, 0), DUContext::Namespace, identifierForNode(actualtype));
	declaration->setInternalContext(currentContext());
    }
    dlang::GoFunctionDeclaration* decl = parseSignature(node->signature, true, node->methodName, m_session->commentBeforeToken(node->startToken-1));

    if(!node->body)
	return;

    DUContext* bodyContext = openContext(node->body, DUContext::ContextType::Function, node->methodName);

    {//import parameters into body context
        DUChainWriteLocker lock;
        if(decl->internalContext())
            currentContext()->addImportedParentContext(decl->internalContext());
        if(decl->returnArgsContext())
            currentContext()->addImportedParentContext(decl->returnArgsContext());
    }

    if(node->methodRecv->type)
    {//declare method receiver variable('this' or 'self' analog in Go)
        buildTypeName(node->methodRecv->type);
	if(node->methodRecv->star!= -1)
	{
	    PointerType* ptype = new PointerType();
	    ptype->setBaseType(lastType());
	    injectType(PointerType::Ptr(ptype));
	}
	DUChainWriteLocker n;
	Declaration* thisVariable = openDeclaration<Declaration>(identifierForNode(node->methodRecv->nameOrType), editorFindRange(node->methodRecv->nameOrType, 0));
	thisVariable->setAbstractType(lastType());
	closeDeclaration();
    }

    visitBlock(node->body);
    {
	DUChainWriteLocker lock;
        lastContext()->setType(DUContext::Function);
	decl->setInternalFunctionContext(lastContext()); //inner block context
	decl->setKind(Declaration::Instance);
    }

    closeContext(); //body wrapper context
    closeContext();	//namespace
    closeDeclaration();	//namespace declaration
}

void DeclarationBuilder::visitTypeSpec(dlang::TypeSpecAst* node)
{
    //first try setting comment before type name
    //if it doesn't exists, set comment before type declaration
    QByteArray comment = m_session->commentBeforeToken(node->startToken);
    if(comment.size() == 0)
        comment = m_lastTypeComment;
    setComment(comment);
    Declaration* decl;
    {
	DUChainWriteLocker lock;
	decl = openDeclaration<Declaration>(identifierForNode(node->name), editorFindRange(node->name, 0));
	//decl->setKind(Declaration::Namespace);
	decl->setKind(Declaration::Type);
	//force direct here because otherwise DeclarationId will mess up actual type declaration and method declarations
	//TODO perhaps we can do this with specialization or additional identity?
	decl->setAlwaysForceDirect(true);
    }
    m_contextIdentifier = identifierForNode(node->name);
    visitType(node->type);
    DUChainWriteLocker lock;
    //qCDebug(DUCHAIN) << lastType()->toString();
    decl->setType(lastType());

    decl->setIsTypeAlias(true);
    closeDeclaration();
    //qCDebug(DUCHAIN) << "Type" << identifierForNode(node->name) << " exit";
}*/

#include <language/duchain/duchaindumper.h>

void DeclarationBuilder::visitSingleImport(ISingleImport *node)
{
	//prevent recursive imports
	//without preventing recursive imports. importing standart go library(2000+ files) takes minutes and sometimes never stops
	//thankfully go import mechanism doesn't need recursive imports(I think)
	//if(m_export)
	//return;
	
	QString import = node->getModuleName()->getString();
	QList<ReferencedTopDUContext> contexts = m_session->contextForImport(import);
	if(contexts.empty())
	{
		qDebug() << "No context for import" << import;
		return;
	}
	
	//Usually package name matches directory, so try searching for that first.
	QualifiedIdentifier packageName(import/*.mid(1, import.length()-2)*/);
	qDebug() << "packageName:" << packageName.toString(false) << contexts.length();
	bool firstContext = true;
	for(const ReferencedTopDUContext &context : contexts)
	{
		//Don't import itself.
		if(context.data() == topContext())
			continue;
		DeclarationPointer decl = dlang::checkPackageDeclaration(packageName.last(), context);
		if(!decl && firstContext)
		{
			decl = dlang::getFirstDeclaration(context); //Package name differs from directory, so get the real name.
			if(!decl)
				continue;
			DUChainReadLocker lock;
			packageName = decl->qualifiedIdentifier();
		}
		if(!decl) //Contexts belongs to a different package.
			continue;
		qDebug() << "Got decl." << packageName.toString(false);
		DUChainWriteLocker lock;
		if(firstContext) //Only open declarations once per import(others are redundant).
		{
			setComment(decl->comment());
			currentContext()->addImportedParentContext(context, CursorInRevision(node->getModuleName()->getLine(), node->getModuleName()->getColumn()));
			NamespaceAliasDeclaration *importDecl = openDeclaration<NamespaceAliasDeclaration>(QualifiedIdentifier(globalImportIdentifier()), editorFindRange(node->getModuleName(), 0));
			importDecl->setKind(Declaration::NamespaceAlias);
			//importDecl->setKind(Declaration::Import);
			importDecl->setImportIdentifier(packageName);
			//importDecl->setType(decl->abstractType());
			closeDeclaration();
			
			qDebug() << "Added imported parent context:";
			DUChainDumper dumper;
			dumper.dump(context);
			firstContext = false;
		}
	}
	DUChainWriteLocker lock;
	topContext()->updateImportsCache();
}

void DeclarationBuilder::visitModule(IModule *node)
{
	if(node->getModuleDeclaration())
	{
		if(node->getModuleDeclaration()->getComment())
			setComment(node->getModuleDeclaration()->getComment()->getString());
		
		DUChainWriteLocker lock;
		KDevelop::RangeInRevision range = editorFindRange(node->getModuleDeclaration()->getName(), node->getModuleDeclaration()->getName());
		m_thisPackage = identifierForNode(node->getModuleDeclaration()->getName());
		
		Declaration *packageDeclaration = openDeclaration<Declaration>(m_thisPackage, range);
		packageDeclaration->setKind(Declaration::Namespace);
		openContext(node, editorFindRange(node, 0), DUContext::Namespace, m_thisPackage);
		packageDeclaration->setInternalContext(currentContext());
		lock.unlock();
		//importThisPackage();
		//importBuiltins();
		DeclarationBuilderBase::visitModule(node);
		closeContext();
		closeDeclaration();
	}
}

void DeclarationBuilder::importThisPackage()
{
	QList<ReferencedTopDUContext> contexts = m_session->contextForThisPackage(document());
	if(contexts.empty())
		return;
	
	for(const ReferencedTopDUContext &context : contexts)
	{
		if(context.data() == topContext())
			continue;
		//Only import contexts with the same package name.
		DeclarationPointer decl = dlang::checkPackageDeclaration(m_thisPackage.last(), context);
		qDebug() << "Trying to import" << m_thisPackage.last() << decl;
		if(!decl)
			continue;
		//If our package doesn't have comment, but some file in our package does, copy it.
		if(currentDeclaration<Declaration>()->comment().size() == 0 && decl->comment().size() != 0)
			currentDeclaration<Declaration>()->setComment(decl->comment());
		
		DUChainWriteLocker lock;
		//TODO: Since package names are identical duchain should find declarations without namespace alias, right?
		
		//NamespaceAliasDeclaration* import = openDeclaration<NamespaceAliasDeclaration>(QualifiedIdentifier(globalImportIdentifier()), RangeInRevision());
		//import->setKind(Declaration::NamespaceAlias);
		//import->setImportIdentifier(packageName); //this needs to be actual package name
		//closeDeclaration();
		topContext()->addImportedParentContext(context.data());
	}
	DUChainWriteLocker lock;
	//topContext()->updateImportsCache();
}

/*void DeclarationBuilder::visitForStmt(dlang::ForStmtAst* node)
{
    openContext(node, editorFindRange(node, 0), DUContext::Other); //wrapper context
    if(node->range != -1 && node->autoassign != -1)
    {//manually infer types
        dlang::ExpressionVisitor exprVisitor(m_session, currentContext(), this);
        exprVisitor.visitRangeClause(node->rangeExpression);
        auto types = exprVisitor.lastTypes();
        if(!types.empty())
        {
            declareVariable(identifierAstFromExpressionAst(node->expression), types.first());
            if(types.size() > 1 && node->expressionList)
            {
                int typeIndex = 1;
                auto iter = node->expressionList->expressionsSequence->front(), end = iter;
                do
                {
                    if(typeIndex >= types.size()) //not enough types to declare all variables
                        break;
                    declareVariable(identifierAstFromExpressionAst(iter->element), types.at(typeIndex));
                    iter = iter->next;
                    typeIndex++;
                }
                while (iter != end);
            }
        }
    }
    DeclarationBuilderBase::visitForStmt(node);
    closeContext();
}

void DeclarationBuilder::visitSwitchStmt(dlang::SwitchStmtAst* node)
{
    openContext(node, editorFindRange(node, 0), DUContext::Other); //wrapper context
    if(node->typeSwitchStatement && node->typeSwitchStatement->typeSwitchGuard)
    {
        dlang::TypeSwitchGuardAst* typeswitch = node->typeSwitchStatement->typeSwitchGuard;
        dlang::ExpressionVisitor expVisitor(m_session, currentContext(), this);
        expVisitor.visitPrimaryExpr(typeswitch->primaryExpr);
        if(!expVisitor.lastTypes().empty())
        {
            declareVariable(typeswitch->ident, expVisitor.lastTypes().first());
            m_switchTypeVariable = identifierForNode(typeswitch->ident);
        }
    }
    DeclarationBuilderBase::visitSwitchStmt(node);
    closeContext(); //wrapper context
    m_switchTypeVariable.clear();
}

void DeclarationBuilder::visitTypeCaseClause(dlang::TypeCaseClauseAst* node)
{
    openContext(node, editorFindRange(node, 0), DUContext::Other);
    const KDevPG::ListNode<dlang::TypeAst*>* typeIter = 0;
    if(node->typelistSequence)
        typeIter = node->typelistSequence->front();
    if(node->defaultToken == -1 && typeIter && typeIter->next == typeIter)
    {//if default is not specified and only one type is listed
        //we open another declaration of listed type
        visitType(typeIter->element);
        lastType()->setModifiers(AbstractType::NoModifiers);
        DUChainWriteLocker lock;
        if(lastType()->toString() != "nil" && !m_switchTypeVariable.isEmpty())
        {//in that case we also don't open declaration
            Declaration* decl = openDeclaration<Declaration>(m_switchTypeVariable, editorFindRange(typeIter->element, 0));
            decl->setAbstractType(lastType());
            closeDeclaration();
        }
    }
    dlang::DefaultVisitor::visitTypeCaseClause(node);
    closeContext();
}

void DeclarationBuilder::visitExprCaseClause(dlang::ExprCaseClauseAst* node)
{
    openContext(node, editorFindRange(node, 0), DUContext::Other);
    dlang::DefaultVisitor::visitExprCaseClause(node);
    closeContext();
}

void DeclarationBuilder::visitTypeDecl(dlang::TypeDeclAst* node)
{
    m_lastTypeComment = m_session->commentBeforeToken(node->startToken);
    dlang::DefaultVisitor::visitTypeDecl(node);
    m_lastTypeComment = QByteArray();
}*/


KDevelop::FunctionDeclaration *DeclarationBuilder::declareFunction(IIdentifier *id, const KDevelop::FunctionType::Ptr &type, DUContext *paramContext, DUContext *retparamContext, const QByteArray &comment)
{
	printf("Definition: %s\n", id->getString());
	setComment(comment);
	DUChainWriteLocker lock;
	KDevelop::FunctionDeclaration *dec = openDefinition<KDevelop::FunctionDeclaration>(identifierForNode(id), editorFindRange(id, 0));
	dec->setType<KDevelop::FunctionType>(type);
	dec->setKind(Declaration::Type);
	//dec->setKind(Declaration::Instance);
	dec->setInternalContext(paramContext);
	//if(retparamContext)
	//	dec->setReturnArgsContext(retparamContext);
	//dec->setInternalFunctionContext(bodyContext);
	closeDeclaration();
	return dec;
}
