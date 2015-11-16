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

#include "typebuilder.h"

#include <language/duchain/types/arraytype.h>
#include <language/duchain/types/pointertype.h>
#include <language/duchain/types/structuretype.h>

#include "types/gointegraltype.h"
#include "types/gostructuretype.h"
#include "types/gomaptype.h"
#include "types/gochantype.h"
#include "helper.h"

using namespace KDevelop;

namespace dlang
{

void TypeBuilder::visitTypeName(IType *node)
{
	if(!node)
	{
		injectType<AbstractType>(AbstractType::Ptr(new IntegralType(IntegralType::TypeNone)));
		return;
	}
	buildTypeName(node->getName(), nullptr);
	if(node->isArray())
	{
		KDevelop::ArrayType::Ptr array(new KDevelop::ArrayType());
		array->setElementType(lastType());
		array->setDimension(0);
		injectType(array);
	}
	if(node->isPointer())
	{
		KDevelop::PointerType::Ptr pointer(new KDevelop::PointerType());
		pointer->setBaseType(lastType());
		injectType(pointer);
	}
}

void TypeBuilder::buildTypeName(IIdentifier *typeName, IIdentifier *fullName)
{
	uint type = IntegralType::TypeNone;
	QualifiedIdentifier id = identifierForNode(typeName);
	QString name = id.toString();
	//Builtin types
	if(name == "void")
		type = dlang::GoIntegralType::TypeVoid;
	else if(name == "ubyte")
		type = dlang::GoIntegralType::TypeUbyte;
	else if(name == "ushort")
		type = dlang::GoIntegralType::TypeUshort;
	else if(name == "uint")
		type = dlang::GoIntegralType::TypeUint;
	else if(name == "ulong")
		type = dlang::GoIntegralType::TypeUlong;
	else if(name == "byte")
		type = dlang::GoIntegralType::TypeUbyte;
	else if(name == "short")
		type = dlang::GoIntegralType::TypeShort;
	else if(name == "int")
		type = dlang::GoIntegralType::TypeInt;
	else if(name == "long")
		type = dlang::GoIntegralType::TypeLong;
	else if(name == "float")
		type = dlang::GoIntegralType::TypeFloat;
	else if(name == "double")
		type = dlang::GoIntegralType::TypeDouble;
	else if(name == "real")
		type = dlang::GoIntegralType::TypeReal;
	else if(name == "char")
		type = dlang::GoIntegralType::TypeChar;
	else if(name == "wchar")
		type = dlang::GoIntegralType::TypeWchar;
	else if(name == "dchar")
		type = dlang::GoIntegralType::TypeDchar;
	else if(name == "bool")
		type = dlang::GoIntegralType::TypeBool;
	
	if(type == IntegralType::TypeNone)
	{
		QualifiedIdentifier id(identifierForNode(typeName));
		if(fullName)
			id.push(identifierForNode(fullName));
		DeclarationPointer decl = dlang::getTypeDeclaration(id, currentContext());
		if(decl)
		{
			DUChainReadLocker lock;
			StructureType *type = new StructureType();
			type->setDeclaration(decl.data());
			injectType<AbstractType>(AbstractType::Ptr(type));
			//kDebug() << decl->range();
			return;
		}
		DelayedType *unknown = new DelayedType();
		unknown->setIdentifier(IndexedTypeIdentifier(id));
		injectType<AbstractType>(AbstractType::Ptr(unknown));
		return;
	}
	if(type != IntegralType::TypeNone)
		injectType<AbstractType>(AbstractType::Ptr(new dlang::GoIntegralType(type)));
}

/*void TypeBuilder::visitArrayOrSliceType(dlang::ArrayOrSliceTypeAst* node)
{
    if(node->arrayOrSliceResolve->array)
        visitType(node->arrayOrSliceResolve->array);
    else if(node->arrayOrSliceResolve->slice)
        visitType(node->arrayOrSliceResolve->slice);
    else //error
        injectType<AbstractType>(AbstractType::Ptr());

    //TODO create custom classes GoArrayType and GoSliceType
    //to properly distinguish between go slices and arrays
    ArrayType* array = new ArrayType();
    //kDebug() << lastType()->toString();
    array->setElementType(lastType());
    injectType<ArrayType>(ArrayType::Ptr(array));
}

void TypeBuilder::visitPointerType(dlang::PointerTypeAst* node)
{
    PointerType* type = new PointerType();
    visitType(node->type);
    type->setBaseType(lastType());
    injectType<PointerType>(PointerType::Ptr(type));
}

void TypeBuilder::visitStructType(dlang::StructTypeAst* node)
{
    openType<dlang::GoStructureType>(dlang::GoStructureType::Ptr(new dlang::GoStructureType));
    {
        DUChainWriteLocker lock;
        openContext(node, editorFindRange(node, 0), DUContext::ContextType::Class, m_contextIdentifier);
    }
    TypeBuilderBase::visitStructType(node);
    {
        DUChainWriteLocker lock;
        currentType<dlang::GoStructureType>()->setContext(currentContext());
        closeContext();
    }
    currentType<dlang::GoStructureType>()->setPrettyName(m_session->textForNode(node));
    currentType<dlang::GoStructureType>()->setStructureType();
    closeType();
}

void TypeBuilder::visitFieldDecl(dlang::FieldDeclAst* node)
{
    StructureType::Ptr structure = currentType<StructureType>();
    QList<dlang::IdentifierAst*> names;
    if(node->anonFieldStar)
    {
        PointerType* type = new PointerType();
        visitTypeName(node->anonFieldStar->typeName);
        type->setBaseType(lastType());
        dlang::IdentifierAst* id = node->anonFieldStar->typeName->type_resolve->fullName ?
                            node->anonFieldStar->typeName->type_resolve->fullName :
                            node->anonFieldStar->typeName->name;

        injectType<PointerType>(PointerType::Ptr(type));
        names.append(id);
    }else if(node->type)
    {
        visitType(node->type);
        names.append(node->varid);
        if(node->idList)
        {
            auto elem = node->idList->idSequence->front();
            while(true)
            {
                names.append(elem->element);
                if(elem->hasNext())
                    elem = elem->next;
                else break;
            }
        }
    }else
    {
        buildTypeName(node->varid, node->fullname);
        dlang::IdentifierAst* id = node->fullname ? node->fullname : node->varid;
        names.append(id);
    }

    for(auto name : names)
    {
        declareVariable(name, lastType());
    }
}


void TypeBuilder::visitInterfaceType(dlang::InterfaceTypeAst* node)
{
    openType<dlang::GoStructureType>(dlang::GoStructureType::Ptr(new dlang::GoStructureType));
    //ClassDeclaration* decl;
    {
        DUChainWriteLocker lock;
        //decl = openDeclaration<ClassDeclaration>(QualifiedIdentifier(), RangeInRevision());
        openContext(node, editorFindRange(node, 0), DUContext::ContextType::Class, m_contextIdentifier);
    }

    TypeBuilderBase::visitInterfaceType(node);
    {
        DUChainWriteLocker lock;
        //decl->setInternalContext(currentContext());
        //decl->setClassType(ClassDeclarationData::Interface);
        currentType<dlang::GoStructureType>()->setContext(currentContext());
        closeContext();
        //closeDeclaration();
        //currentType<dlang::GoStructureType>()->setDeclaration(decl);
        //decl->setIdentifier(Identifier(QString("interface type")));
    }
    currentType<dlang::GoStructureType>()->setPrettyName(m_session->textForNode(node));
    currentType<dlang::GoStructureType>()->setInterfaceType();
    closeType();
}

void TypeBuilder::visitMethodSpec(dlang::MethodSpecAst* node)
{
    if(node->signature)
    {
        parseSignature(node->signature, true, node->methodName);
    }else{
        buildTypeName(node->methodName, node->fullName);
        dlang::IdentifierAst* id = node->fullName ? node->fullName : node->methodName;
        {
            declareVariable(id, lastType());
        }
    }
}

void TypeBuilder::visitMapType(dlang::MapTypeAst* node)
{
    dlang::GoMapType* type = new dlang::GoMapType();
    visitType(node->keyType);
    type->setKeyType(lastType());
    visitType(node->elemType);
    type->setValueType(lastType());

    injectType(AbstractType::Ptr(type));
}

void TypeBuilder::visitChanType(dlang::ChanTypeAst* node)
{
    visitType(node->rtype ? node->rtype : node->stype);
    dlang::GoChanType::Ptr type(new dlang::GoChanType());
    if(node->stype)
        type->setKind(dlang::GoChanType::Receive);
    else if(node->send != -1)
        type->setKind(dlang::GoChanType::Send);
    else
        type->setKind(dlang::GoChanType::SendAndReceive);
    DUChainReadLocker lock;
    type->setValueType(lastType());
    injectType(type);
}

void TypeBuilder::visitFunctionType(dlang::FunctionTypeAst* node)
{
    parseSignature(node->signature, false);
}*/

void TypeBuilder::visitParameter(IParameter *node)
{
	//if(node->idOrType && node->fulltype)
	TypeBuilderBase::visitParameter(node);
}

void TypeBuilder::visitClassDeclaration(IClassDeclaration *node)
{
	openType<dlang::GoStructureType>(dlang::GoStructureType::Ptr(new dlang::GoStructureType));
	{
		DUChainWriteLocker lock;
		openContext(node, editorFindRange(node, 0), DUContext::ContextType::Class, node->getName());
	}
	TypeBuilderBase::visitClassDeclaration(node);
	{
		DUChainWriteLocker lock;
		currentType<dlang::GoStructureType>()->setContext(currentContext());
		closeContext();
	}
	currentType<dlang::GoStructureType>()->setPrettyName(node->getName()->getString());
	currentType<dlang::GoStructureType>()->setStructureType();
	closeType();
}

void TypeBuilder::visitStructDeclaration(IStructDeclaration *node)
{
	openType<dlang::GoStructureType>(dlang::GoStructureType::Ptr(new dlang::GoStructureType));
	{
		DUChainWriteLocker lock;
		openContext(node, editorFindRange(node, 0), DUContext::ContextType::Class, node->getName());
	}
	TypeBuilderBase::visitStructDeclaration(node);
	{
		DUChainWriteLocker lock;
		currentType<dlang::GoStructureType>()->setContext(currentContext());
		closeContext();
	}
	currentType<dlang::GoStructureType>()->setPrettyName(node->getName()->getString());
	currentType<dlang::GoStructureType>()->setStructureType();
	closeType();
}

KDevelop::FunctionDeclaration *TypeBuilder::parseSignature(IFunctionDeclaration *node, bool declareParameters, IIdentifier *name, const QByteArray &comment)
{
	KDevelop::FunctionType::Ptr type(new KDevelop::FunctionType());
	openType<KDevelop::FunctionType>(type);
	
	DUContext *parametersContext;
	if(declareParameters)
		parametersContext = openContext(node->getParameters(), editorFindRange(node->getParameters(), 0), DUContext::ContextType::Function, name);
	parseParameters(node->getParameters(), true, declareParameters);
	if(declareParameters)
		closeContext();
	
	DUContext *returnArgsContext=0;
	
	/*if(node->result)
	{
	    visitResult(node->result);
	    if(node->result->parameters)
	    {
	        if(declareParameters) returnArgsContext = openContext(node->result,
	                                            editorFindRange(node->result, 0),
	                                            DUContext::ContextType::Function,
	                                            name);
	        parseParameters(node->result->parameters, false, declareParameters);
	        if(declareParameters) closeContext();
	
	    }
	    if(!node->result->parameters && lastType())
	        type->addReturnArgument(lastType());
	}*/
	visitTypeName(node->getReturnType());
	addArgumentHelper(type, lastType(), false);
	//type->addReturnArgument(lastType());
	closeType();
	
	if(declareParameters)
		return declareFunction(name, type, parametersContext, returnArgsContext, comment);
	return 0;
}

void TypeBuilder::parseParameters(IParameters *node, bool parseArguments, bool declareParameters)
{
	KDevelop::FunctionType::Ptr function;
	function = currentType<KDevelop::FunctionType>();
	for(int i=0; i<node->getNumParameters(); i++)
	{
		auto parameter = node->getParameter(i);
		visitParameter(parameter);
		if(declareParameters)
			declareVariable(parameter->getName(), lastType());
		addArgumentHelper(function, lastType(), parseArguments);
	}
	/*if(node->parameter)
	{
	    QList<dlang::IdentifierAst*> paramNames;
	    dlang::ParameterAst* param=node->parameter;
	    visitParameter(param);
	    //variadic arguments
	    if(param->unnamedvartype || param->vartype)
	    {
	        function->setModifiers(dlang::GoFunctionType::VariadicArgument);
	        ArrayType* atype = new ArrayType();
	        atype->setElementType(lastType());
	        injectType(AbstractType::Ptr(atype));
	    }
	    if(!param->complexType && !param->parenType && !param->unnamedvartype &&
	        !param->type && !param->vartype && !param->fulltype)
	        paramNames.append(param->idOrType); //we only have an identifier
	    else
	    {
	        addArgumentHelper(function, lastType(), parseArguments);
	        //if we have a parameter name(but it's not part of fullname) open declaration
	        if(param->idOrType && !param->fulltype && declareParameters)
	            declareVariable(param->idOrType, lastType());
	    }
	
	    if(node->parameterListSequence)
	    {
	        auto elem = node->parameterListSequence->front();
	        while(true)
	        {
	            dlang::ParameterAst* param=elem->element;
	            visitParameter(param);
	            //variadic arguments
	            if(param->unnamedvartype || param->vartype)
	            {
	                function->setModifiers(dlang::GoFunctionType::VariadicArgument);
	                ArrayType* atype = new ArrayType();
	                atype->setElementType(lastType());
	                injectType(AbstractType::Ptr(atype));
	            }
	            if(param->complexType || param->parenType || param->unnamedvartype || param->fulltype)
	            {//we have a unnamed parameter list of types
	                AbstractType::Ptr lType = lastType();
	                for(auto id : paramNames)
	                {
	                    buildTypeName(id);
	                    addArgumentHelper(function, lastType(), parseArguments);
	                }
	                addArgumentHelper(function, lType, parseArguments);
	                paramNames.clear();
	            }else if(!param->complexType && !param->parenType && !param->unnamedvartype &&
	                !param->type && !param->vartype && !param->fulltype)
	            {//just another identifier
	                paramNames.append(param->idOrType);
	            }else
	            {//identifier with type, all previous identifiers are of the same type
	                for(auto id : paramNames)
	                {
	                    addArgumentHelper(function, lastType(), parseArguments);
	                    if(declareParameters) declareVariable(id, lastType());
	                }
	                addArgumentHelper(function, lastType(), parseArguments);
	                if(declareParameters) declareVariable(param->idOrType, lastType());
	                paramNames.clear();
	            }
	            if(elem->hasNext())
	                elem = elem->next;
	            else break;
	
	        }
	        if(!paramNames.empty())
	        {//we have only identifiers which means they are all type names
	            //foreach(auto id, paramNames)
	            for(auto id : paramNames)
	            {
	                buildTypeName(id);
	                addArgumentHelper(function, lastType(), parseArguments);
	            }
	            paramNames.clear();
	        }
	
	    }else if(!paramNames.empty())
	    {
	        //one identifier that we have is a type
	        buildTypeName(param->idOrType);
	        addArgumentHelper(function, lastType(), parseArguments);
	    }
	}*/
}

void TypeBuilder::addArgumentHelper(KDevelop::FunctionType::Ptr function, AbstractType::Ptr argument, bool parseArguments)
{
	DUChainWriteLocker lock;
	if(argument)
	{
		if(parseArguments)
			function->addArgument(argument);
		else
			function->setReturnType(argument);
	}
}

//TODO call this from DeclarationBuilder::visitFunctionDecl
/*void TypeBuilder::buildFunction(SignatureAst* node, BlockAst* block)
{
    dlang::GoFunctionDeclaration* decl = parseSignature(node, true);
    AbstractType::Ptr type = lastType();
    if(block)
    {
        DUContext* bodyContext = openContext(block, DUContext::ContextType::Function);
        {//import parameters into body context
            DUChainWriteLocker lock;
            if(decl->internalContext())
                currentContext()->addImportedParentContext(decl->internalContext());
            if(decl->returnArgsContext())
                currentContext()->addImportedParentContext(decl->returnArgsContext());
        }
        visitBlock(block);
        closeContext(); //wrapper context
        injectType(type);
    }
}*/

}
