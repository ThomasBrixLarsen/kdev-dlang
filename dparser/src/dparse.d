module dparse;

import std.stdio;

import std.d.lexer;
import std.d.parser;
import std.d.ast;

enum Kind
{
	module_,
	moduleDeclaration,
	functionDeclaration,
	importDeclaration,
	functionBody,
	blockStatement,
	parameters,
	parameter,
	identifier,
	type,
	declarationsAndStatements,
	declaration,
	variableDeclaration,
	declarator
}

extern(C++) interface INode
{
	Kind getKind();
}

extern(C++) interface IIdentifier : INode
{
	char* getString();
	ulong getLine();
	ulong getColumn();
}

extern(C++) interface IModule : INode
{
	IModuleDeclaration getModuleDeclaration();
	ulong numDeclarations();
	INode getDeclaration(int i);
}

extern(C++) interface IModuleDeclaration : INode
{
	IIdentifier getName();
	ulong getStart();
	ulong getEnd();
	IIdentifier getComment();
}

extern(C++) interface IBlockStatement : INode
{
	IDeclarationsAndStatements getDeclarationsAndStatements();
	ulong getStart();
	ulong getEnd();
	ulong startLine();
	ulong startColumn();
	ulong endLine();
	ulong endColumn();
}

extern(C++) interface IFunctionBody : INode
{
	IBlockStatement getBlockStatement();
}

extern(C++) interface IFunctionDeclaration : INode
{
	IIdentifier getName();
	IParameters getParameters();
	IFunctionBody getFunctionBody();
	IType getReturnType();
	IIdentifier getComment();
}

extern(C++) interface IImportDeclaration : INode
{
	ulong numSingleImports();
	INode getSingleImport(int i);
	INode getImportBindings();
}

extern(C++) interface IParameter : INode
{
	IIdentifier getName();
	IType getType();
}

extern(C++) interface IParameters : INode
{
	ulong startLine();
	ulong startColumn();
	ulong endLine();
	ulong endColumn();
	ulong getNumParameters();
	IParameter getParameter(int i);
	bool hasVarargs();
}

extern(C++) interface IType : INode
{
	IIdentifier getName();
	bool isArray();
	bool isPointer();
}

extern(C++) interface IDeclarationsAndStatements : INode
{
	ulong numDeclarationOrStatements();
	INode getDeclarationOrStatement(int i);
}

extern(C++) interface IDeclaration : INode
{
	// AliasDeclaration aliasDeclaration;
	// AliasThisDeclaration aliasThisDeclaration;
	// AnonymousEnumDeclaration anonymousEnumDeclaration;
	// Attribute[] attributes;
	// AttributeDeclaration attributeDeclaration;
	// ClassDeclaration classDeclaration;
	// ConditionalDeclaration conditionalDeclaration;
	// Constructor constructor;
	// DebugSpecification debugSpecification;
	// Declaration[] declarations;
	// Destructor destructor;
	// EnumDeclaration enumDeclaration;
	// EponymousTemplateDeclaration eponymousTemplateDeclaration;
	// FunctionDeclaration functionDeclaration;
	// ImportDeclaration importDeclaration;
	// InterfaceDeclaration interfaceDeclaration;
	// Invariant invariant_;
	// MixinDeclaration mixinDeclaration;
	// MixinTemplateDeclaration mixinTemplateDeclaration;
	// Postblit postblit;
	// PragmaDeclaration pragmaDeclaration;
	// SharedStaticConstructor sharedStaticConstructor;
	// SharedStaticDestructor sharedStaticDestructor;
	// StaticAssertDeclaration staticAssertDeclaration;
	// StaticConstructor staticConstructor;
	// StaticDestructor staticDestructor;
	// StructDeclaration structDeclaration;
	// TemplateDeclaration templateDeclaration;
	// UnionDeclaration unionDeclaration;
	// Unittest unittest_;
	IVariableDeclaration getVariableDeclaration();
	// VersionSpecification versionSpecification;
}

extern(C++) interface IVariableDeclaration : INode
{
	IType getType();
	ulong numDeclarators();
	IDeclarator getDeclarator(int i); //Like int a, b, c;
	IIdentifier getComment();
}

extern(C++) interface IDeclarator : INode
{
	IIdentifier getName();
	IIdentifier getComment();
}

class CIdentifier : IIdentifier
{
	this(const Token token)
	{
		writefln("token: %s", token.text);
		this.text = token.text;
		this.line = token.line;
		this.column = token.column;
	}
	
	this(string text)
	{
		writefln("text: %s", text);
		this.text = text;
	}
	
	this(const Symbol symbol)
	{
		if(symbol.identifierOrTemplateChain && symbol.identifierOrTemplateChain.identifiersOrTemplateInstances.length >= 1)
		{
			if(symbol.dot)
				this.text = ".";
			this.text ~= symbol.identifierOrTemplateChain.identifiersOrTemplateInstances[0].identifier.text;
			if(symbol.identifierOrTemplateChain.identifiersOrTemplateInstances.length > 1)
			{
				foreach(identifier; symbol.identifierOrTemplateChain.identifiersOrTemplateInstances[1..$])
					this.text = format("%s.%s", this.text, identifier.identifier.text);
			}
		}
	}
	
	this(const IdentifierChain identifierChain)
	{
		if(identifierChain.identifiers.length >= 1)
		{
			this.line = identifierChain.identifiers[0].line;
			this.column = identifierChain.identifiers[0].column;
			this.text = identifierChain.identifiers[0].text;
			foreach(identifier; identifierChain.identifiers[1..$])
				this.text = format("%s.%s", this.text, identifier.text);
		}
	}
	
	extern(C++) Kind getKind()
	{
		return Kind.identifier;
	}
	
	extern(C++) char* getString()
	{
		writefln("getString: \"%s\"", text);
		import std.string;
		if(!cstring)
			cstring = toStringz(text);
		return cast(char*)cstring;
	}
	
	extern(C++) ulong getLine()
	{
		writeln("CIdentifier.getLine()");
		return line;
	}
	
	extern(C++) ulong getColumn()
	{
		writeln("CIdentifier.getColumn()");
		return column;
	}

private:
	string text;
	immutable(char)* cstring;
	ulong line;
	ulong column;
}

class CModule : IModule
{
	this(const Module mod)
	{
		this.mod = mod;
	}
	
	extern(C++) Kind getKind()
	{
		return Kind.module_;
	}
	
	extern(C++) ulong numDeclarations()
	{
		return mod.declarations.length;
	}
	
	extern(C++) IModuleDeclaration getModuleDeclaration()
	{
		if(!moduleDeclaration)
			moduleDeclaration = new CModuleDeclaration(mod.moduleDeclaration);
		return moduleDeclaration;
	}
	
	extern(C++) INode getDeclaration(int i)
	{
		if(i in nodeCache)
			return nodeCache[i];
		
		if(auto f = mod.declarations[i].functionDeclaration)
			nodeCache[i] = new CFunctionDeclaration(f);
		else if(auto f = mod.declarations[i].importDeclaration)
			nodeCache[i] = new CImportDeclaration(f);
		else
		{
			mod.declarations[i].accept(new ASTPrinter(false));
			nodeCache[i] = null;
		}
		return nodeCache[i];
	}

private:
	const Module mod;
	IModuleDeclaration moduleDeclaration;
	INode[int] nodeCache;
}

class CModuleDeclaration : IModuleDeclaration
{
	this(const ModuleDeclaration moduleDeclaration)
	{
		this.moduleDeclaration = moduleDeclaration;
	}
	
	extern(C++) Kind getKind()
	{
		return Kind.moduleDeclaration;
	}
	
	extern(C++) IIdentifier getName()
	{
		if(!name)
			name = new CIdentifier(moduleDeclaration.moduleName);
		return name;
	}
	
	extern(C++) IIdentifier getComment()
	{
		if(!comment)
			comment = new CIdentifier(moduleDeclaration.comment);
		return comment;
	}
	
	extern(C++) ulong getStart()
	{
		return moduleDeclaration.startLocation;
	}
	
	extern(C++) ulong getEnd()
	{
		return moduleDeclaration.endLocation;
	}

private:
	const ModuleDeclaration moduleDeclaration;
	IIdentifier name, comment;
}

class CBlockStatement : IBlockStatement
{
	this(const BlockStatement blockStatement)
	{
		this.blockStatement = blockStatement;
	}
	
	extern(C++) Kind getKind()
	{
		writeln("CBlockStatement.kind()");
		return Kind.blockStatement;
	}
	
	extern(C++) IDeclarationsAndStatements getDeclarationsAndStatements()
	{
		if(!declarationsAndStatements)
			declarationsAndStatements = new CDeclarationsAndStatements(blockStatement.declarationsAndStatements);
		return declarationsAndStatements;
	}
	
	extern(C++) ulong getStart()
	{
		writeln("CBlockStatement.getStart()");
		return blockStatement.startLocation;
	}
	
	extern(C++) ulong getEnd()
	{
		writeln("CBlockStatement.getEnd()");
		return blockStatement.endLocation;
	}
	
	extern(C++) ulong startLine()
	{
		writeln("CBlockStatement.startLine()");
		return blockStatement.startLine;
	}
	
	extern(C++) ulong startColumn()
	{
		writeln("CBlockStatement.startColumn()");
		return blockStatement.startColumn;
	}
	
	extern(C++) ulong endLine()
	{
		writeln("CBlockStatement.endLine()");
		return blockStatement.endLine;
	}
	
	extern(C++) ulong endColumn()
	{
		writeln("CBlockStatement.endColumn()");
		return blockStatement.endColumn;
	}

private:
	const BlockStatement blockStatement;
	IDeclarationsAndStatements declarationsAndStatements;
}

class CFunctionBody : IFunctionBody
{
	this(const FunctionBody functionBody)
	{
		this.functionBody = functionBody;
	}
	
	extern(C++) Kind getKind()
	{
		writeln("CFunctionBody.getKind()");
		return Kind.functionBody;
	}
	
	extern(C++) IBlockStatement getBlockStatement()
	{
		writeln("CFunctionBody.getBlockStatement()");
		if(!functionBody.blockStatement)
			return null;
		if(!blockStatement)
			blockStatement = new CBlockStatement(functionBody.blockStatement);
		return blockStatement;
	}

private:
	const FunctionBody functionBody;
	IBlockStatement blockStatement;
}

class CFunctionDeclaration : IFunctionDeclaration
{
	this(const FunctionDeclaration functionDeclaration)
	{
		this.functionDeclaration = functionDeclaration;
	}
	
	extern(C++) Kind getKind()
	{
		writeln("CFunctionDeclaration.getKind()");
		return Kind.functionDeclaration;
	}
	
	extern(C++) IIdentifier getName()
	{
		writeln("CFunctionDeclaration.getName()");
		if(!name)
			name = new CIdentifier(functionDeclaration.name);
		return name;
	}
	
	extern(C++) IParameters getParameters()
	{
		writeln("CFunctionDeclaration.getParameters()");
		if(!parameters)
			parameters = new CParameters(functionDeclaration.parameters);
		return parameters;
	}
	
	extern(C++) IFunctionBody getFunctionBody()
	{
		writeln("CFunctionDeclaration.getFunctionBody()");
		if(!functionDeclaration.functionBody)
			return null;
		if(!functionBody)
			functionBody = new CFunctionBody(functionDeclaration.functionBody);
		return functionBody;
	}
	
	extern(C++) IType getReturnType()
	{
		writeln("CFunctionDeclaration.getReturnType()");
		if(!type)
		{
			writefln("new CType");
			type = new CType(functionDeclaration.returnType);
			writefln("string: %s", type.getName().getString());
		}
		return type;
	}
	
	extern(C++) IIdentifier getComment()
	{
		writeln("CFunctionDeclaration.getComment()");
		if(!comment)
			comment = new CIdentifier(functionDeclaration.comment);
		return comment;
	}

private:
	const FunctionDeclaration functionDeclaration;
	IIdentifier name;
	IFunctionBody functionBody;
	IType type;
	IParameters parameters;
	IIdentifier comment;
}

class CParameters : IParameters
{
	this(const Parameters parameters)
	{
		this.parameters = parameters;
	}
	
	extern(C++) Kind getKind()
	{
		writeln("CParameters.getKind()");
		return Kind.parameters;
	}
	
	extern(C++) ulong startLine()
	{
		writeln("CParameters.startLine()");
		return parameters.startLine;
	}
	
	extern(C++) ulong startColumn()
	{
		writeln("CParameters.startColumn()");
		return parameters.startColumn;
	}
	
	extern(C++) ulong endLine()
	{
		writeln("CParameters.endLine()");
		return parameters.endLine;
	}
	
	extern(C++) ulong endColumn()
	{
		writeln("CParameters.endColumn()");
		return parameters.endColumn;
	}
	
	extern(C++) ulong getNumParameters()
	{
		return parameters.parameters.length;
	}
	
	extern(C++) IParameter getParameter(int i)
	{
		if(i !in parameter)
			parameter[i] = new CParameter(parameters.parameters[i]);
		return parameter[i];
	}
	
	extern(C++) bool hasVarargs()
	{
		return parameters.hasVarargs;
	}

private:
	const Parameters parameters;
	IParameter[int] parameter;
}

class CParameter : IParameter
{
	this(const Parameter parameter)
	{
		this.parameter = parameter;
	}
	
	extern(C++) Kind getKind()
	{
		writeln("CParameter.getKind()");
		return Kind.parameter;
	}
	
	extern(C++) IIdentifier getName()
	{
		writeln("CParameter.getName()");
		if(!name)
			name = new CIdentifier(parameter.name);
		return name;
	}
	
	extern(C++) IType getType()
	{
		writeln("CParameter.getType()");
		if(!type)
			type = new CType(parameter.type);
		return type;
	}

private:
	const Parameter parameter;
	IIdentifier name;
	IType type;
}

class CImportDeclaration : IImportDeclaration
{
	this(const ImportDeclaration importDeclaration)
	{
		this.importDeclaration = importDeclaration;
	}
	
	extern(C++) Kind getKind()
	{
		writeln("CImportDeclaration.getKind()");
		return Kind.importDeclaration;
	}
	
	extern(C++) ulong numSingleImports()
	{
		return importDeclaration.singleImports.length;
	}
	
	extern(C++) INode getSingleImport(int i)
	{
		return null;
	}
	
	extern(C++) INode getImportBindings()
	{
		return null;
	}

private:
	const ImportDeclaration importDeclaration;
}

class CType : IType
{
	this(const Type type)
	{
		this.type = type;
	}
	
	extern(C++) Kind getKind()
	{
		writeln("CType.getKind()");
		return Kind.type;
	}
	
	extern(C++) IIdentifier getName()
	{
		writefln("CType.getName()");
		if(!name)
		{
			//typeCons: const, immutable, inout, shared
			//suffix: [], *, delegate, function
			//symbol: identifier/.indentifier
			//builtInType: IdType
			//typeof: typeof(other)
			if(type.type2 && type.type2.symbol)
			{
				writefln("CType.getName(): symbol");
				name = new CIdentifier(type.type2.symbol);
			}
			else
			{
				writefln("CType.getName(): builtin");
				name = new CIdentifier(str(type.type2.builtinType));
			}
		}
		return name;
	}
	
	extern(C++) bool isArray()
	{
		foreach(suf; type.typeSuffixes)
		{
			if(suf.array)
				return true;
		}
		return false;
	}
	
	extern(C++) bool isPointer()
	{
		foreach(suf; type.typeSuffixes)
		{
			if(suf.star != tok!"")
				return true;
		}
		return false;
	}

private:
	const Type type;
	IIdentifier name;
}

class CDeclarationsAndStatements : IDeclarationsAndStatements
{
	this(const DeclarationsAndStatements declarationsAndStatements)
	{
		this.declarationsAndStatements = declarationsAndStatements;
	}
	
	extern(C++) Kind getKind()
	{
		writeln("DeclarationsAndStatements.getKind()");
		return Kind.declarationsAndStatements;
	}
	
	extern(C++) ulong numDeclarationOrStatements()
	{
		return declarationsAndStatements.declarationsAndStatements.length;
	}
	
	extern(C++) INode getDeclarationOrStatement(int i)
	{
		if(i !in cache)
		{
			if(declarationsAndStatements.declarationsAndStatements[i].declaration)
				cache[i] = new CDeclaration(declarationsAndStatements.declarationsAndStatements[i].declaration);
			else //TODO: Statement.
				cache[i] = null;
		}
		return cache[i];
	}

private:
	const DeclarationsAndStatements declarationsAndStatements;
	INode[int] cache;
}

class CDeclaration : IDeclaration
{
	this(const Declaration declaration)
	{
		this.declaration = declaration;
	}
	
	extern(C++) Kind getKind()
	{
		writeln("CDeclaration.getKind()");
		return Kind.declaration;
	}
	
	extern(C++) IVariableDeclaration getVariableDeclaration()
	{
		if(!declaration.variableDeclaration)
			return null;
		if(!variableDeclaration)
			variableDeclaration = new CVariableDeclaration(declaration.variableDeclaration);
		return variableDeclaration;
	}

private:
	const Declaration declaration;
	IVariableDeclaration variableDeclaration;
}

class CVariableDeclaration : IVariableDeclaration
{
	this(const VariableDeclaration variableDeclaration)
	{
		this.variableDeclaration = variableDeclaration;
	}
	
	extern(C++) Kind getKind()
	{
		writeln("CVariableDeclaration.getKind()");
		return Kind.variableDeclaration;
	}
	
	extern(C++) IType getType()
	{
		if(!variableDeclaration.type)
			return null;
		if(!type)
			type = new CType(variableDeclaration.type);
		return type;
	}
	
	extern(C++) ulong numDeclarators()
	{
		return variableDeclaration.declarators.length;
	}
	
	extern(C++) IDeclarator getDeclarator(int i)
	{
		if(i !in declarators)
			declarators[i] = new CDeclarator(variableDeclaration.declarators[i]);
		return declarators[i];
	}
	
	extern(C++) IIdentifier getComment()
	{
		if(!comment)
			comment = new CIdentifier(variableDeclaration.comment);
		return comment;
	}

private:
	const VariableDeclaration variableDeclaration;
	IType type;
	IDeclarator[int] declarators;
	IIdentifier comment;
}

class CDeclarator : IDeclarator
{
	this(const Declarator declarator)
	{
		this.declarator = declarator;
	}
	
	extern(C++) Kind getKind()
	{
		writeln("CDeclarator.getKind()");
		return Kind.declarator;
	}
	
	extern(C++) IIdentifier getName()
	{
		if(!name)
			name = new CIdentifier(declarator.name);
		return name;
	}
	extern(C++) IIdentifier getComment()
	{
		if(!comment)
			comment = new CIdentifier(declarator.comment);
		return comment;
	}

private:
	const Declarator declarator;
	IIdentifier name;
	IIdentifier comment;
}

class ASTPrinter : ASTVisitor
{
	this(bool traverse)
	{
		this.traverse = traverse;
	}
	bool traverse;
	alias visit = ASTVisitor.visit;
	/** */ override void visit(const AddExpression addExpression) { writeln("AddExpression"); if(traverse) addExpression.accept(this); }
    /** */ override void visit(const AliasDeclaration aliasDeclaration) { writeln("AliasDeclaration"); if(traverse) aliasDeclaration.accept(this); }
    /** */ override void visit(const AliasInitializer aliasInitializer) { writeln("AliasInitializer"); if(traverse) aliasInitializer.accept(this); }
    /** */ override void visit(const AliasThisDeclaration aliasThisDeclaration) { writeln("AliasThisDeclaration"); if(traverse) aliasThisDeclaration.accept(this); }
    /** */ override void visit(const AlignAttribute alignAttribute) { writeln("AlignAttribute"); if(traverse) alignAttribute.accept(this); }
    /** */ override void visit(const AndAndExpression andAndExpression) { writeln("AndAndExpression"); if(traverse) andAndExpression.accept(this); }
    /** */ override void visit(const AndExpression andExpression) { writeln("AndExpression"); if(traverse) andExpression.accept(this); }
    /** */ override void visit(const AnonymousEnumDeclaration anonymousEnumDeclaration) { writeln("AnonymousEnumDeclaration"); if(traverse) anonymousEnumDeclaration.accept(this); }
    /** */ override void visit(const AnonymousEnumMember anonymousEnumMember) { writeln("AnonymousEnumMember"); if(traverse) anonymousEnumMember.accept(this); }
    /** */ override void visit(const ArgumentList argumentList) { writeln("ArgumentList"); if(traverse) argumentList.accept(this); }
    /** */ override void visit(const Arguments arguments) { writeln("Arguments"); if(traverse) arguments.accept(this); }
    /** */ override void visit(const ArrayInitializer arrayInitializer) { writeln("ArrayInitializer"); if(traverse) arrayInitializer.accept(this); }
    /** */ override void visit(const ArrayLiteral arrayLiteral) { writeln("ArrayLiteral"); if(traverse) arrayLiteral.accept(this); }
    /** */ override void visit(const ArrayMemberInitialization arrayMemberInitialization) { writeln("ArrayMemberInitialization"); if(traverse) arrayMemberInitialization.accept(this); }
    /** */ override void visit(const AssertExpression assertExpression) { writeln("AssertExpression"); if(traverse) assertExpression.accept(this); }
    /** */ override void visit(const AssignExpression assignExpression) { writeln("AssignExpression"); if(traverse) assignExpression.accept(this); }
    /** */ override void visit(const AssocArrayLiteral assocArrayLiteral) { writeln("AssocArrayLiteral"); if(traverse) assocArrayLiteral.accept(this); }
    /** */ override void visit(const AtAttribute atAttribute) { writeln("AtAttribute"); if(traverse) atAttribute.accept(this); }
    /** */ override void visit(const Attribute attribute) { writeln("Attribute"); if(traverse) attribute.accept(this); }
    /** */ override void visit(const AttributeDeclaration attributeDeclaration) { writeln("AttributeDeclaration"); if(traverse) attributeDeclaration.accept(this); }
    /** */ override void visit(const AutoDeclaration autoDeclaration) { writeln("AutoDeclaration"); if(traverse) autoDeclaration.accept(this); }
    /** */ override void visit(const BlockStatement blockStatement) { writeln("BlockStatement"); if(traverse) blockStatement.accept(this); }
    /** */ override void visit(const BodyStatement bodyStatement) { writeln("BodyStatement"); if(traverse) bodyStatement.accept(this); }
    /** */ override void visit(const BreakStatement breakStatement) { writeln("BreakStatement"); if(traverse) breakStatement.accept(this); }
    /** */ override void visit(const BaseClass baseClass) { writeln("BaseClass"); if(traverse) baseClass.accept(this); }
    /** */ override void visit(const BaseClassList baseClassList) { writeln("BaseClassList"); if(traverse) baseClassList.accept(this); }
    /** */ override void visit(const CaseRangeStatement caseRangeStatement) { writeln("CaseRangeStatement"); if(traverse) caseRangeStatement.accept(this); }
    /** */ override void visit(const CaseStatement caseStatement) { writeln("CaseStatement"); if(traverse) caseStatement.accept(this); }
    /** */ override void visit(const CastExpression castExpression) { writeln("CastExpression"); if(traverse) castExpression.accept(this); }
    /** */ override void visit(const CastQualifier castQualifier) { writeln("CastQualifier"); if(traverse) castQualifier.accept(this); }
    /** */ override void visit(const Catch catch_) { writeln("Catch"); if(traverse) catch_.accept(this); }
    /** */ override void visit(const Catches catches) { writeln("Catches"); if(traverse) catches.accept(this); }
    /** */ override void visit(const ClassDeclaration classDeclaration) { writeln("ClassDeclaration"); if(traverse) classDeclaration.accept(this); }
    /** */ override void visit(const CmpExpression cmpExpression) { writeln("CmpExpression"); if(traverse) cmpExpression.accept(this); }
    /** */ override void visit(const CompileCondition compileCondition) { writeln("CompileCondition"); if(traverse) compileCondition.accept(this); }
    /** */ override void visit(const ConditionalDeclaration conditionalDeclaration) { writeln("ConditionalDeclaration"); if(traverse) conditionalDeclaration.accept(this); }
    /** */ override void visit(const ConditionalStatement conditionalStatement) { writeln("ConditionalStatement"); if(traverse) conditionalStatement.accept(this); }
    /** */ override void visit(const Constraint constraint) { writeln("Constraint"); if(traverse) constraint.accept(this); }
    /** */ override void visit(const Constructor constructor) { writeln("Constructor"); if(traverse) constructor.accept(this); }
    /** */ override void visit(const ContinueStatement continueStatement) { writeln("ContinueStatement"); if(traverse) continueStatement.accept(this); }
    /** */ override void visit(const DebugCondition debugCondition) { writeln("DebugCondition"); if(traverse) debugCondition.accept(this); }
    /** */ override void visit(const DebugSpecification debugSpecification) { writeln("DebugSpecification"); if(traverse) debugSpecification.accept(this); }
    /** */ override void visit(const Declaration declaration) { writeln("Declaration"); if(traverse) declaration.accept(this); }
    /** */ override void visit(const DeclarationOrStatement declarationsOrStatement) { writeln("DeclarationOrStatement"); if(traverse) declarationsOrStatement.accept(this); }
    /** */ override void visit(const DeclarationsAndStatements declarationsAndStatements) { writeln("DeclarationsAndStatements"); if(traverse) declarationsAndStatements.accept(this); }
    /** */ override void visit(const Declarator declarator) { writeln("Declarator"); if(traverse) declarator.accept(this); }
    /** */ override void visit(const DefaultStatement defaultStatement) { writeln("DefaultStatement"); if(traverse) defaultStatement.accept(this); }
    /** */ override void visit(const DeleteExpression deleteExpression) { writeln("DeleteExpression"); if(traverse) deleteExpression.accept(this); }
    /** */ override void visit(const DeleteStatement deleteStatement) { writeln("DeleteStatement"); if(traverse) deleteStatement.accept(this); }
    /** */ override void visit(const Deprecated deprecated_) { writeln("Deprecated"); if(traverse) deprecated_.accept(this); }
    /** */ override void visit(const Destructor destructor) { writeln("Destructor"); if(traverse) destructor.accept(this); }
    /** */ override void visit(const DoStatement doStatement) { writeln("DoStatement"); if(traverse) doStatement.accept(this); }
    /** */ override void visit(const EnumBody enumBody) { writeln("EnumBody"); if(traverse) enumBody.accept(this); }
    /** */ override void visit(const EnumDeclaration enumDeclaration) { writeln("EnumDeclaration"); if(traverse) enumDeclaration.accept(this); }
    /** */ override void visit(const EnumMember enumMember) { writeln("EnumMember"); if(traverse) enumMember.accept(this); }
    /** */ override void visit(const EponymousTemplateDeclaration eponymousTemplateDeclaration) { writeln("EponymousTemplateDeclaration"); if(traverse) eponymousTemplateDeclaration.accept(this); }
    /** */ override void visit(const EqualExpression equalExpression) { writeln("EqualExpression"); if(traverse) equalExpression.accept(this); }
    /** */ override void visit(const Expression expression) { writeln("Expression"); if(traverse) expression.accept(this); }
    /** */ override void visit(const ExpressionStatement expressionStatement) { writeln("ExpressionStatement"); if(traverse) expressionStatement.accept(this); }
    /** */ override void visit(const FinalSwitchStatement finalSwitchStatement) { writeln("FinalSwitchStatement"); if(traverse) finalSwitchStatement.accept(this); }
    /** */ override void visit(const Finally finally_) { writeln("Finally"); if(traverse) finally_.accept(this); }
    /** */ override void visit(const ForStatement forStatement) { writeln("ForStatement"); if(traverse) forStatement.accept(this); }
    /** */ override void visit(const ForeachStatement foreachStatement) { writeln("ForeachStatement"); if(traverse) foreachStatement.accept(this); }
    /** */ override void visit(const ForeachType foreachType) { writeln("ForeachType"); if(traverse) foreachType.accept(this); }
    /** */ override void visit(const ForeachTypeList foreachTypeList) { writeln("ForeachTypeList"); if(traverse) foreachTypeList.accept(this); }
    /** */ override void visit(const FunctionAttribute functionAttribute) { writeln("FunctionAttribute"); if(traverse) functionAttribute.accept(this); }
    /** */ override void visit(const FunctionBody functionBody) { writeln("FunctionBody"); if(traverse) functionBody.accept(this); }
    /** */ override void visit(const FunctionCallExpression functionCallExpression) { writeln("FunctionCallExpression"); if(traverse) functionCallExpression.accept(this); }
    /** */ override void visit(const FunctionDeclaration functionDeclaration) { writeln("FunctionDeclaration"); if(traverse) functionDeclaration.accept(this); }
    /** */ override void visit(const FunctionLiteralExpression functionLiteralExpression) { writeln("FunctionLiteralExpression"); if(traverse) functionLiteralExpression.accept(this); }
    /** */ override void visit(const GotoStatement gotoStatement) { writeln("GotoStatement"); if(traverse) gotoStatement.accept(this); }
    /** */ override void visit(const IdentifierChain identifierChain) { writeln("IdentifierChain"); if(traverse) identifierChain.accept(this); }
    /** */ override void visit(const IdentifierList identifierList) { writeln("IdentifierList"); if(traverse) identifierList.accept(this); }
    /** */ override void visit(const IdentifierOrTemplateChain identifierOrTemplateChain) { writeln("IdentifierOrTemplateChain"); if(traverse) identifierOrTemplateChain.accept(this); }
    /** */ override void visit(const IdentifierOrTemplateInstance identifierOrTemplateInstance) { writeln("IdentifierOrTemplateInstance"); if(traverse) identifierOrTemplateInstance.accept(this); }
    /** */ override void visit(const IdentityExpression identityExpression) { writeln("IdentityExpression"); if(traverse) identityExpression.accept(this); }
    /** */ override void visit(const IfStatement ifStatement) { writeln("IfStatement"); if(traverse) ifStatement.accept(this); }
    /** */ override void visit(const ImportBind importBind) { writeln("ImportBind"); if(traverse) importBind.accept(this); }
    /** */ override void visit(const ImportBindings importBindings) { writeln("ImportBindings"); if(traverse) importBindings.accept(this); }
    /** */ override void visit(const ImportDeclaration importDeclaration) { writeln("ImportDeclaration"); if(traverse) importDeclaration.accept(this); }
    /** */ override void visit(const ImportExpression importExpression) { writeln("ImportExpression"); if(traverse) importExpression.accept(this); }
    /** */ override void visit(const IndexExpression indexExpression) { writeln("IndexExpression"); if(traverse) indexExpression.accept(this); }
    /** */ override void visit(const InExpression inExpression) { writeln("InExpression"); if(traverse) inExpression.accept(this); }
    /** */ override void visit(const InStatement inStatement) { writeln("InStatement"); if(traverse) inStatement.accept(this); }
    /** */ override void visit(const Initialize initialize) { writeln("Initialize"); if(traverse) initialize.accept(this); }
    /** */ override void visit(const Initializer initializer) { writeln("Initializer"); if(traverse) initializer.accept(this); }
    /** */ override void visit(const InterfaceDeclaration interfaceDeclaration) { writeln("InterfaceDeclaration"); if(traverse) interfaceDeclaration.accept(this); }
    /** */ override void visit(const Invariant invariant_) { writeln("Invariant"); if(traverse) invariant_.accept(this); }
    /** */ override void visit(const IsExpression isExpression) { writeln("IsExpression"); if(traverse) isExpression.accept(this); }
    /** */ override void visit(const KeyValuePair keyValuePair) { writeln("KeyValuePair"); if(traverse) keyValuePair.accept(this); }
    /** */ override void visit(const KeyValuePairs keyValuePairs) { writeln("KeyValuePairs"); if(traverse) keyValuePairs.accept(this); }
    /** */ override void visit(const LabeledStatement labeledStatement) { writeln("LabeledStatement"); if(traverse) labeledStatement.accept(this); }
    /** */ override void visit(const LambdaExpression lambdaExpression) { writeln("LambdaExpression"); if(traverse) lambdaExpression.accept(this); }
    /** */ override void visit(const LastCatch lastCatch) { writeln("LastCatch"); if(traverse) lastCatch.accept(this); }
    /** */ override void visit(const LinkageAttribute linkageAttribute) { writeln("LinkageAttribute"); if(traverse) linkageAttribute.accept(this); }
    /** */ override void visit(const MemberFunctionAttribute memberFunctionAttribute) { writeln("MemberFunctionAttribute"); if(traverse) memberFunctionAttribute.accept(this); }
    /** */ override void visit(const MixinDeclaration mixinDeclaration) { writeln("MixinDeclaration"); if(traverse) mixinDeclaration.accept(this); }
    /** */ override void visit(const MixinExpression mixinExpression) { writeln("MixinExpression"); if(traverse) mixinExpression.accept(this); }
    /** */ override void visit(const MixinTemplateDeclaration mixinTemplateDeclaration) { writeln("MixinTemplateDeclaration"); if(traverse) mixinTemplateDeclaration.accept(this); }
    /** */ override void visit(const MixinTemplateName mixinTemplateName) { writeln("MixinTemplateName"); if(traverse) mixinTemplateName.accept(this); }
    /** */ override void visit(const Module module_) { writeln("Module"); if(traverse) module_.accept(this); }
    /** */ override void visit(const ModuleDeclaration moduleDeclaration) { writeln("ModuleDeclaration"); if(traverse) moduleDeclaration.accept(this); }
    /** */ override void visit(const MulExpression mulExpression) { writeln("MulExpression"); if(traverse) mulExpression.accept(this); }
    /** */ override void visit(const NewAnonClassExpression newAnonClassExpression) { writeln("NewAnonClassExpression"); if(traverse) newAnonClassExpression.accept(this); }
    /** */ override void visit(const NewExpression newExpression) { writeln("NewExpression"); if(traverse) newExpression.accept(this); }
    /** */ override void visit(const NonVoidInitializer nonVoidInitializer) { writeln("NonVoidInitializer"); if(traverse) nonVoidInitializer.accept(this); }
    /** */ override void visit(const Operands operands) { writeln("Operands"); if(traverse) operands.accept(this); }
    /** */ override void visit(const OrExpression orExpression) { writeln("OrExpression"); if(traverse) orExpression.accept(this); }
    /** */ override void visit(const OrOrExpression orOrExpression) { writeln("OrOrExpression"); if(traverse) orOrExpression.accept(this); }
    /** */ override void visit(const OutStatement outStatement) { writeln("OutStatement"); if(traverse) outStatement.accept(this); }
    /** */ override void visit(const Parameter parameter) { writeln("Parameter"); if(traverse) parameter.accept(this); }
    /** */ override void visit(const Parameters parameters) { writeln("Parameters"); if(traverse) parameters.accept(this); }
    /** */ override void visit(const Postblit postblit) { writeln("Postblit"); if(traverse) postblit.accept(this); }
    /** */ override void visit(const PowExpression powExpression) { writeln("PowExpression"); if(traverse) powExpression.accept(this); }
    /** */ override void visit(const PragmaDeclaration pragmaDeclaration) { writeln("PragmaDeclaration"); if(traverse) pragmaDeclaration.accept(this); }
    /** */ override void visit(const PragmaExpression pragmaExpression) { writeln("PragmaExpression"); if(traverse) pragmaExpression.accept(this); }
    /** */ override void visit(const PrimaryExpression primaryExpression) { writeln("PrimaryExpression"); if(traverse) primaryExpression.accept(this); }
    /** */ override void visit(const Register register) { writeln("Register"); if(traverse) register.accept(this); }
    /** */ override void visit(const RelExpression relExpression) { writeln("RelExpression"); if(traverse) relExpression.accept(this); }
    /** */ override void visit(const ReturnStatement returnStatement) { writeln("ReturnStatement"); if(traverse) returnStatement.accept(this); }
    /** */ override void visit(const ScopeGuardStatement scopeGuardStatement) { writeln("ScopeGuardStatement"); if(traverse) scopeGuardStatement.accept(this); }
    /** */ override void visit(const SharedStaticConstructor sharedStaticConstructor) { writeln("SharedStaticConstructor"); if(traverse) sharedStaticConstructor.accept(this); }
    /** */ override void visit(const SharedStaticDestructor sharedStaticDestructor) { writeln("SharedStaticDestructor"); if(traverse) sharedStaticDestructor.accept(this); }
    /** */ override void visit(const ShiftExpression shiftExpression) { writeln("ShiftExpression"); if(traverse) shiftExpression.accept(this); }
    /** */ override void visit(const SingleImport singleImport) { writeln("SingleImport"); if(traverse) singleImport.accept(this); }
    /** */ override void visit(const SliceExpression sliceExpression) { writeln("SliceExpression"); if(traverse) sliceExpression.accept(this); }
    /** */ override void visit(const Statement statement) { writeln("Statement"); if(traverse) statement.accept(this); }
    /** */ override void visit(const StatementNoCaseNoDefault statementNoCaseNoDefault) { writeln("StatementNoCaseNoDefault"); if(traverse) statementNoCaseNoDefault.accept(this); }
    /** */ override void visit(const StaticAssertDeclaration staticAssertDeclaration) { writeln("StaticAssertDeclaration"); if(traverse) staticAssertDeclaration.accept(this); }
    /** */ override void visit(const StaticAssertStatement staticAssertStatement) { writeln("StaticAssertStatement"); if(traverse) staticAssertStatement.accept(this); }
    /** */ override void visit(const StaticConstructor staticConstructor) { writeln("StaticConstructor"); if(traverse) staticConstructor.accept(this); }
    /** */ override void visit(const StaticDestructor staticDestructor) { writeln("StaticDestructor"); if(traverse) staticDestructor.accept(this); }
    /** */ override void visit(const StaticIfCondition staticIfCondition) { writeln("StaticIfCondition"); if(traverse) staticIfCondition.accept(this); }
    /** */ override void visit(const StorageClass storageClass) { writeln("StorageClass"); if(traverse) storageClass.accept(this); }
    /** */ override void visit(const StructBody structBody) { writeln("StructBody"); if(traverse) structBody.accept(this); }
    /** */ override void visit(const StructDeclaration structDeclaration) { writeln("StructDeclaration"); if(traverse) structDeclaration.accept(this); }
    /** */ override void visit(const StructInitializer structInitializer) { writeln("StructInitializer"); if(traverse) structInitializer.accept(this); }
    /** */ override void visit(const StructMemberInitializer structMemberInitializer) { writeln("StructMemberInitializer"); if(traverse) structMemberInitializer.accept(this); }
    /** */ override void visit(const StructMemberInitializers structMemberInitializers) { writeln("StructMemberInitializers"); if(traverse) structMemberInitializers.accept(this); }
    /** */ override void visit(const SwitchStatement switchStatement) { writeln("SwitchStatement"); if(traverse) switchStatement.accept(this); }
    /** */ override void visit(const Symbol symbol) { writeln("Symbol"); if(traverse) symbol.accept(this); }
    /** */ override void visit(const SynchronizedStatement synchronizedStatement) { writeln("SynchronizedStatement"); if(traverse) synchronizedStatement.accept(this); }
    /** */ override void visit(const TemplateAliasParameter templateAliasParameter) { writeln("TemplateAliasParameter"); if(traverse) templateAliasParameter.accept(this); }
    /** */ override void visit(const TemplateArgument templateArgument) { writeln("TemplateArgument"); if(traverse) templateArgument.accept(this); }
    /** */ override void visit(const TemplateArgumentList templateArgumentList) { writeln("TemplateArgumentList"); if(traverse) templateArgumentList.accept(this); }
    /** */ override void visit(const TemplateArguments templateArguments) { writeln("TemplateArguments"); if(traverse) templateArguments.accept(this); }
    /** */ override void visit(const TemplateDeclaration templateDeclaration) { writeln("TemplateDeclaration"); if(traverse) templateDeclaration.accept(this); }
    /** */ override void visit(const TemplateInstance templateInstance) { writeln("TemplateInstance"); if(traverse) templateInstance.accept(this); }
    /** */ override void visit(const TemplateMixinExpression templateMixinExpression) { writeln("TemplateMixinExpression"); if(traverse) templateMixinExpression.accept(this); }
    /** */ override void visit(const TemplateParameter templateParameter) { writeln("TemplateParameter"); if(traverse) templateParameter.accept(this); }
    /** */ override void visit(const TemplateParameterList templateParameterList) { writeln("TemplateParameterList"); if(traverse) templateParameterList.accept(this); }
    /** */ override void visit(const TemplateParameters templateParameters) { writeln("TemplateParameters"); if(traverse) templateParameters.accept(this); }
    /** */ override void visit(const TemplateSingleArgument templateSingleArgument) { writeln("TemplateSingleArgument"); if(traverse) templateSingleArgument.accept(this); }
    /** */ override void visit(const TemplateThisParameter templateThisParameter) { writeln("TemplateThisParameter"); if(traverse) templateThisParameter.accept(this); }
    /** */ override void visit(const TemplateTupleParameter templateTupleParameter) { writeln("TemplateTupleParameter"); if(traverse) templateTupleParameter.accept(this); }
    /** */ override void visit(const TemplateTypeParameter templateTypeParameter) { writeln("TemplateTypeParameter"); if(traverse) templateTypeParameter.accept(this); }
    /** */ override void visit(const TemplateValueParameter templateValueParameter) { writeln("TemplateValueParameter"); if(traverse) templateValueParameter.accept(this); }
    /** */ override void visit(const TemplateValueParameterDefault templateValueParameterDefault) { writeln("TemplateValueParameterDefault"); if(traverse) templateValueParameterDefault.accept(this); }
    /** */ override void visit(const TernaryExpression ternaryExpression) { writeln("TernaryExpression"); if(traverse) ternaryExpression.accept(this); }
    /** */ override void visit(const ThrowStatement throwStatement) { writeln("ThrowStatement"); if(traverse) throwStatement.accept(this); }
    /** */ override void visit(const Token) { }
    /** */ override void visit(const TraitsExpression traitsExpression) { writeln("TraitsExpression"); if(traverse) traitsExpression.accept(this); }
    /** */ override void visit(const TryStatement tryStatement) { writeln("TryStatement"); if(traverse) tryStatement.accept(this); }
    /** */ override void visit(const Type type) { writeln("Type"); if(traverse) type.accept(this); }
    /** */ override void visit(const Type2 type2) { writeln("Type2"); if(traverse) type2.accept(this); }
    /** */ override void visit(const TypeSpecialization typeSpecialization) { writeln("TypeSpecialization"); if(traverse) typeSpecialization.accept(this); }
    /** */ override void visit(const TypeSuffix typeSuffix) { writeln("TypeSuffix"); if(traverse) typeSuffix.accept(this); }
    /** */ override void visit(const TypeidExpression typeidExpression) { writeln("TypeidExpression"); if(traverse) typeidExpression.accept(this); }
    /** */ override void visit(const TypeofExpression typeofExpression) { writeln("TypeofExpression"); if(traverse) typeofExpression.accept(this); }
    /** */ override void visit(const UnaryExpression unaryExpression) { writeln("UnaryExpression"); if(traverse) unaryExpression.accept(this); }
    /** */ override void visit(const UnionDeclaration unionDeclaration) { writeln("UnionDeclaration"); if(traverse) unionDeclaration.accept(this); }
    /** */ override void visit(const Unittest unittest_) { writeln("Unittest"); if(traverse) unittest_.accept(this); }
    /** */ override void visit(const VariableDeclaration variableDeclaration) { writeln("VariableDeclaration"); if(traverse) variableDeclaration.accept(this); }
    /** */ override void visit(const Vector vector) { writeln("Vector"); if(traverse) vector.accept(this); }
    /** */ override void visit(const VersionCondition versionCondition) { writeln("VersionCondition"); if(traverse) versionCondition.accept(this); }
    /** */ override void visit(const VersionSpecification versionSpecification) { writeln("VersionSpecification"); if(traverse) versionSpecification.accept(this); }
    /** */ override void visit(const WhileStatement whileStatement) { writeln("WhileStatement"); if(traverse) whileStatement.accept(this); }
    /** */ override void visit(const WithStatement withStatement) { writeln("WithStatement"); if(traverse) withStatement.accept(this); }
    /** */ override void visit(const XorExpression xorExpression) { writeln("XorExpression"); if(traverse) xorExpression.accept(this); }
}

/*class Visitor : ASTVisitor
{
	alias visit = ASTVisitor.visit;
	
	override void visit(const ModuleDeclaration moduleDeclaration)
	{
		writefln("start: %s, end: %s", moduleDeclaration.startLocation, moduleDeclaration.endLocation);
		moduleDeclaration.accept(this);
	}
}*/

import core.thread;

extern(C++) void initDParser()
{
	import core.runtime;
	Runtime.initialize();
}

extern(C++) void deinitDParser()
{
	import core.runtime;
	Runtime.terminate();
}

extern(C++) IModule parseSourceFile(char* sourceFile, char* sourceData)
{
	import std.string;
	
	thread_attachThis();
	
	LexerConfig config;
	config.fileName = fromStringz(sourceFile).idup;
	
	if(config.fileName !in moduleCache)
	{
		auto source = cast(ubyte[])fromStringz(sourceData);
		auto tokens = getTokensForParser(source, config, new StringCache(StringCache.defaultBucketCount));
		
		auto mod = parseModule(tokens, config.fileName);
		
		//auto visitor = new Visitor;
		//mod.accept(visitor);
		moduleCache[config.fileName] = new CModule(mod);
	}
	return moduleCache[config.fileName];
}

__gshared CModule[string] moduleCache;
