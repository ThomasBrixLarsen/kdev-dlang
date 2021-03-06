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

#include "declarationbuilder.h"

#include <interfaces/icore.h>
#include <interfaces/ilanguagecontroller.h>
#include <language/backgroundparser/backgroundparser.h>
#include <language/duchain/duchainlock.h>
#include <language/duchain/duchain.h>
#include <language/duchain/types/integraltype.h>
#include <language/duchain/types/arraytype.h>
#include <language/duchain/types/enumerationtype.h>
#include <language/duchain/types/enumeratortype.h>
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


DeclarationBuilder::DeclarationBuilder(ParseSession *session, bool forExport) : m_export(forExport), inClassScope(false), m_preBuilding(false), m_ownPriority(0)
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
	for(int i=0; i<node->numDeclarators(); i++)
		declareVariable(node->getDeclarator(i)->getName(), lastType());
}

void DeclarationBuilder::declareVariable(IToken *id, const AbstractType::Ptr &type)
{
	DUChainWriteLocker lock;
	Declaration *dec = openDefinition<Declaration>(identifierForNode(id), editorFindRange(id, id));
	dec->setType(type);
	dec->setKind(Declaration::Instance);
	closeDeclaration();
}

void DeclarationBuilder::visitClassDeclaration(IClassDeclaration *node)
{
	inClassScope = true;
	DeclarationBuilderBase::visitClassDeclaration(node);
	if(node->getComment())
		setComment(node->getComment());
	DUChainWriteLocker lock;
	ClassDeclaration *dec = openDefinition<ClassDeclaration>(identifierForNode(node->getName()), editorFindRange(node->getName(), 0));
	dec->setType(lastType());
	dec->setKind(KDevelop::Declaration::Type);
	dec->setInternalContext(lastContext());
	dec->setClassType(ClassDeclarationData::Class);
	closeDeclaration();
	inClassScope = false;
}

void DeclarationBuilder::visitStructDeclaration(IStructDeclaration *node)
{
	inClassScope = true;
	DeclarationBuilderBase::visitStructDeclaration(node);
	if(node->getComment())
		setComment(node->getComment());
	DUChainWriteLocker lock;
	ClassDeclaration *dec = openDefinition<ClassDeclaration>(identifierForNode(node->getName()), editorFindRange(node->getName(), 0));
	dec->setType(lastType());
	dec->setKind(KDevelop::Declaration::Type);
	dec->setInternalContext(lastContext());
	dec->setClassType(ClassDeclarationData::Struct);
	closeDeclaration();
	inClassScope = false;
}

void DeclarationBuilder::visitInterfaceDeclaration(IInterfaceDeclaration *node)
{
	inClassScope = true;
	DeclarationBuilderBase::visitInterfaceDeclaration(node);
	if(node->getComment())
		setComment(node->getComment());
	DUChainWriteLocker lock;
	ClassDeclaration *dec = openDefinition<ClassDeclaration>(identifierForNode(node->getName()), editorFindRange(node->getName(), 0));
	dec->setType(lastType());
	dec->setKind(KDevelop::Declaration::Type);
	dec->setInternalContext(lastContext());
	dec->setClassType(ClassDeclarationData::Interface);
	closeDeclaration();
	inClassScope = false;
}

void DeclarationBuilder::visitParameter(IParameter *node)
{
	TypeBuilder::visitParameter(node);
	DUChainWriteLocker lock;
	Declaration *parameter = openDeclaration<Declaration>(node->getName(), node);
	parameter->setKind(Declaration::Instance);
	parameter->setAbstractType(lastType());
	closeDeclaration();
}

void DeclarationBuilder::visitFuncDeclaration(IFunctionDeclaration *node)
{
	TypeBuilder::visitFuncDeclaration(node);
	DUChainWriteLocker lock;
	if(inClassScope)
	{
		ClassFunctionDeclaration *newMethod = openDefinition<ClassFunctionDeclaration>(node->getName(), node);
		if(node->getComment())
			newMethod->setComment(QString::fromUtf8(node->getComment()));
		newMethod->setKind(KDevelop::Declaration::Type);
		lock.unlock();
		ContextBuilder::visitFuncDeclaration(node);
		lock.lock();
		closeDeclaration();
		newMethod->setInternalContext(lastContext());
		newMethod->setType(currentFunctionType);
	}
	else
	{
		FunctionDeclaration *newMethod = openDefinition<FunctionDeclaration>(node->getName(), node);
		if(node->getComment())
			newMethod->setComment(QString::fromUtf8(node->getComment()));
		newMethod->setKind(KDevelop::Declaration::Type);
		lock.unlock();
		ContextBuilder::visitFuncDeclaration(node);
		lock.lock();
		closeDeclaration();
		newMethod->setInternalContext(lastContext());
		newMethod->setType(currentFunctionType);
	}
}

void DeclarationBuilder::visitConstructor(IConstructor *node)
{
	TypeBuilder::visitConstructor(node);
	DUChainWriteLocker lock;
	ClassFunctionDeclaration *newMethod = openDefinition<ClassFunctionDeclaration>(QualifiedIdentifier("this"), editorFindRange(node, node));
	if(node->getComment())
		newMethod->setComment(QString::fromUtf8(node->getComment()));
	newMethod->setKind(KDevelop::Declaration::Type);
	lock.unlock();
	ContextBuilder::visitConstructor(node);
	lock.lock();
	closeDeclaration();
	newMethod->setInternalContext(lastContext());
	newMethod->setType(currentFunctionType);
}

void DeclarationBuilder::visitDestructor(IDestructor *node)
{
	TypeBuilder::visitDestructor(node);
	DUChainWriteLocker lock;
	ClassFunctionDeclaration *newMethod = openDefinition<ClassFunctionDeclaration>(QualifiedIdentifier("~this"), editorFindRange(node, node));
	if(node->getComment())
		newMethod->setComment(QString::fromUtf8(node->getComment()));
	newMethod->setKind(KDevelop::Declaration::Type);
	lock.unlock();
	ContextBuilder::visitDestructor(node);
	lock.lock();
	closeDeclaration();
	newMethod->setInternalContext(lastContext());
	newMethod->setType(currentFunctionType);
}

void DeclarationBuilder::visitSingleImport(ISingleImport *node)
{
	DUChainWriteLocker lock;
	QualifiedIdentifier import = identifierForNode(node->getIdentifierChain());
	NamespaceAliasDeclaration *importDecl = openDefinition<NamespaceAliasDeclaration>(QualifiedIdentifier(globalImportIdentifier()), editorFindRange(node->getIdentifierChain(), 0));
	importDecl->setImportIdentifier(import);
	closeDeclaration();
	DeclarationBuilderBase::visitSingleImport(node);
}

void DeclarationBuilder::visitModule(IModule *node)
{
	if(node->getModuleDeclaration())
	{
		if(node->getModuleDeclaration()->getComment())
			setComment(node->getModuleDeclaration()->getComment());
		
		DUChainWriteLocker lock;
		
		auto m_thisPackage = identifierForNode(node->getModuleDeclaration()->getModuleName());
		KDevelop::RangeInRevision range = editorFindRange(node->getModuleDeclaration()->getModuleName(), node->getModuleDeclaration()->getModuleName());
		
		Declaration *packageDeclaration = openDeclaration<Declaration>(m_thisPackage, range);
		packageDeclaration->setKind(Declaration::Namespace);
		openContext(node, editorFindRange(node, 0), DUContext::Namespace, m_thisPackage);
		packageDeclaration->setInternalContext(currentContext());
		lock.unlock();
		DeclarationBuilderBase::visitModule(node);
		closeContext();
		closeDeclaration();
		topContext()->updateImportsCache();
	}
}

void DeclarationBuilder::visitForeachType(IForeachType *node)
{
	TypeBuilder::visitForeachType(node);
	DUChainWriteLocker lock;
	Declaration *argument = openDeclaration<Declaration>(node->getIdentifier(), node);
	argument->setKind(Declaration::Instance);
	argument->setAbstractType(lastType());
	closeDeclaration();
}

void DeclarationBuilder::visitLabeledStatement(ILabeledStatement *node)
{
	DeclarationBuilderBase::visitLabeledStatement(node);
	DUChainWriteLocker lock;
	Declaration *label = openDeclaration<Declaration>(node->getIdentifier(), node);
	label->setKind(Declaration::Type);
	closeDeclaration();
}

void DeclarationBuilder::visitDebugSpecification(IDebugSpecification *node)
{
	DeclarationBuilderBase::visitDebugSpecification(node);
	DUChainWriteLocker lock;
	Declaration *label = openDeclaration<Declaration>(node->getIdentifierOrInteger(), node);
	label->setKind(Declaration::Type);
	closeDeclaration();
}

void DeclarationBuilder::visitVersionSpecification(IVersionSpecification *node)
{
	DeclarationBuilderBase::visitVersionSpecification(node);
	DUChainWriteLocker lock;
	Declaration *label = openDeclaration<Declaration>(node->getToken(), node);
	label->setKind(Declaration::Type);
	closeDeclaration();
}

void DeclarationBuilder::visitCatch(ICatch *node)
{
	TypeBuilder::visitCatch(node);
	DUChainWriteLocker lock;
	Declaration *parameter = openDeclaration<Declaration>(node->getIdentifier(), node);
	parameter->setKind(Declaration::Instance);
	parameter->setAbstractType(lastType());
	closeDeclaration();
}

void DeclarationBuilder::visitEnumDeclaration(IEnumDeclaration *node)
{
	DUChainWriteLocker lock;
	Declaration *e = openDeclaration<Declaration>(node->getName(), node);
	e->setKind(Declaration::Type);
	lock.unlock();
	DeclarationBuilderBase::visitEnumDeclaration(node);
	lock.lock();
	e->setInternalContext(lastContext());
	//e->setAbstractType(lastType());
	closeDeclaration();
}

void DeclarationBuilder::visitEnumMember(IEnumMember *node)
{
	DeclarationBuilderBase::visitEnumMember(node);
	DUChainWriteLocker lock;
	ClassMemberDeclaration *e = openDeclaration<ClassMemberDeclaration>(node->getName(), node);
	e->setStatic(true);
	EnumeratorType::Ptr enumeratorType = lastType().cast<EnumeratorType>();
	if(enumeratorType)
	{
		enumeratorType->setDeclaration(e);
		e->setAbstractType(enumeratorType.cast<AbstractType>());
	}
	closeDeclaration();
}
