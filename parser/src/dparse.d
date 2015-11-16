module dparser;

import core.stdc.signal;
import std.stdio;

import dparse.lexer;
import dparse.parser;
import dparse.ast;


void writeln(string text)
{
	try
	{
		//std.stdio.writeln(text);
	}
	catch(Throwable e)
	{
		
	}
}

enum Kind
{
	unknown,
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
	declarator,
	classDeclaration,
	structDeclaration,
	structBody,
	statement,
	statementNoCaseNoDefault,
	expressionStatement,
	expressionNode,
	primaryExpression,
	addExpression,
	unaryExpression,
	assignExpression,
	initializer,
	singleImport,
	functionCallExpression,
	module_ = 100101
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
	IDeclaration getDeclaration(int i);
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
	IClassDeclaration getClassDeclaration();
	// ConditionalDeclaration conditionalDeclaration;
	// Constructor constructor;
	// DebugSpecification debugSpecification;
	// Declaration[] declarations;
	// Destructor destructor;
	// EnumDeclaration enumDeclaration;
	// EponymousTemplateDeclaration eponymousTemplateDeclaration;
	IFunctionDeclaration getFunctionDeclaration();
	IImportDeclaration getImportDeclaration();
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
	IStructDeclaration getStructDeclaration();
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
	IInitializer getInitializer();
}

extern(C++) interface IClassDeclaration : INode
{
	IIdentifier getName();
	IStructBody getStructBody();
	IIdentifier getComment();
}

extern(C++) interface IStructDeclaration : INode
{
	IIdentifier getName();
	IStructBody getStructBody();
	IIdentifier getComment();
}

extern(C++) interface IStructBody : INode
{
	ulong numDeclarations();
	IDeclaration getDeclaration(int i);
	ulong startLine();
	ulong startColumn();
	ulong endLine();
	ulong endColumn();
}

extern(C++) interface IStatement : INode
{
	IStatementNoCaseNoDefault getStatementNoCaseNoDefault();
	// ICaseStatement caseStatement();
	// ICaseRangeStatement caseRangeStatement();
	// IDefaultStatement defaultStatement();
}

class CStatement : IStatement
{
	this(const Statement statement)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			this.statement = statement;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CStatement.getKind()");
			return Kind.statement;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IStatementNoCaseNoDefault getStatementNoCaseNoDefault()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!statementNoCaseNoDefault)
				statementNoCaseNoDefault = new CStatementNoCaseNoDefault(statement.statementNoCaseNoDefault);
			return statementNoCaseNoDefault;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const Statement statement;
	IStatementNoCaseNoDefault statementNoCaseNoDefault;
}

extern(C++) interface IStatementNoCaseNoDefault : INode
{
	// LabeledStatement labeledStatement;
	// BlockStatement blockStatement;
	// IfStatement ifStatement;
	// WhileStatement whileStatement;
	// DoStatement doStatement;
	// ForStatement forStatement;
	// ForeachStatement foreachStatement;
	// SwitchStatement switchStatement;
	// FinalSwitchStatement finalSwitchStatement;
	// ContinueStatement continueStatement;
	// BreakStatement breakStatement;
	// ReturnStatement returnStatement;
	// GotoStatement gotoStatement;
	// WithStatement withStatement;
	// SynchronizedStatement synchronizedStatement;
	// TryStatement tryStatement;
	// ThrowStatement throwStatement;
	// ScopeGuardStatement scopeGuardStatement;
	// AsmStatement asmStatement;
	// ConditionalStatement conditionalStatement;
	// StaticAssertStatement staticAssertStatement;
	// VersionSpecification versionSpecification;
	// DebugSpecification debugSpecification;
	IExpressionStatement getExpressionStatement();
	// size_t startLocation;
	// size_t endLocation;
}

class CStatementNoCaseNoDefault : IStatementNoCaseNoDefault
{
	this(const StatementNoCaseNoDefault statement)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			this.statement = statement;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CStatementNoCaseNoDefault.getKind()");
			return Kind.statementNoCaseNoDefault;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IExpressionStatement getExpressionStatement()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writefln("blockStatement: %s", statement.blockStatement !is null);
			if(!expression && statement.expressionStatement)
				expression = new CExpressionStatement(statement.expressionStatement);
			return expression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const StatementNoCaseNoDefault statement;
	IExpressionStatement expression;
}

extern(C++) interface IExpressionStatement : INode
{
	ulong numItems();
	IExpressionNode getItem(int i);
	//size_t line;
	//size_t column;
}

class CExpressionStatement : IExpressionStatement
{
	this(const ExpressionStatement expressionStatement)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			this.expressionStatement = expressionStatement;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CExpressionStatement.getKind()");
			return Kind.expressionStatement;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong numItems()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!expressionStatement.expression)
				return 0;
			return expressionStatement.expression.items.length;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IExpressionNode getItem(int i)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writefln("CExpressionStatement.getItem(%s) of %s", i, expressionStatement.expression.items.length);
			if(i !in cache)
			{
				if(expressionStatement.expression.items[i])
					cache[i] = new CExpressionNode(expressionStatement.expression.items[i]);
			}
			return cache[i];
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const ExpressionStatement expressionStatement;
	IExpressionNode[int] cache;
}

extern(C++) interface IExpressionNode : INode
{
	IPrimaryExpression getPrimaryExpression();
	IAddExpression getAddExpression();
	//IAndAndExpression();
	//IAndExpression();
	//IAssertExpression();
	IAssignExpression getAssignExpression();
	//ICmpExpression();
	//IDeleteExpression();
	//IEqualExpression();
	IFunctionCallExpression getFunctionCallExpression();
	//IFunctionLiteralExpression();
	//IIdentityExpression();
	//IImportExpression getImportExpression();
	//IIndexExpression();
	//IInExpression();
	//IIsExpression();
	//ILambdaExpression();
	//IMixinExpression();
	//IMulExpression();
	//INewAnonClassExpression();
	//INewExpression();
	//IOrExpression();
	//IOrOrExpression();
	//IPowExpression();
	//IPragmaExpression();
	//IPrimaryExpression();
	//IRelExpression();
	//IShiftExpression();
	//ISliceExpression();
	//ITemplateMixinExpression();
	//ITernaryExpression();
	//ITraitsExpression();
	//ITypeidExpression();
	//ITypeofExpression();
	IUnaryExpression getUnaryExpression();
	//IXorExpression();
}

class CExpressionNode : IExpressionNode
{
	this(const ExpressionNode expressionNode)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			this.expressionNode = expressionNode;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CExpressionNode.getKind()");
			return Kind.expressionNode;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IPrimaryExpression getPrimaryExpression()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writefln("AssignExpression: %s", cast(AssignExpression)expressionNode);
			writefln("Expression: %s", cast(Expression)expressionNode);
			writefln("FunctionCallExpression: %s", cast(FunctionCallExpression)expressionNode);
			writefln("IdentityExpression: %s", cast(IdentityExpression)expressionNode);
			writefln("PrimaryExpression: %s", cast(PrimaryExpression)expressionNode);
			writefln("TypeId: %s", cast(TypeidExpression)expressionNode);
			writefln("TypeofExpression: %s", cast(TypeofExpression)expressionNode);
			writefln("UnaryExpression: %s", cast(UnaryExpression)expressionNode);
			if(!primaryExpression && cast(PrimaryExpression)expressionNode)
				primaryExpression = new CPrimaryExpression(cast(PrimaryExpression)expressionNode);
			return primaryExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IAddExpression getAddExpression()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!addExpression && cast(AddExpression)expressionNode)
				addExpression = new CAddExpression(cast(AddExpression)expressionNode);
			return addExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IAssignExpression getAssignExpression()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!assignExpression && cast(AssignExpression)expressionNode)
				assignExpression = new CAssignExpression(cast(AssignExpression)expressionNode);
			return assignExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IFunctionCallExpression getFunctionCallExpression()
	{
		try
		{
			if(!functionCallExpression && cast(FunctionCallExpression)expressionNode)
				functionCallExpression = new CFunctionCallExpression(cast(FunctionCallExpression)expressionNode);
			return functionCallExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IUnaryExpression getUnaryExpression()
	{
		try
		{
			if(!unaryExpression && cast(UnaryExpression)expressionNode)
				unaryExpression = new CUnaryExpression(cast(UnaryExpression)expressionNode);
			return unaryExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const ExpressionNode expressionNode;
	IPrimaryExpression primaryExpression;
	IAddExpression addExpression;
	IAssignExpression assignExpression;
	IFunctionCallExpression functionCallExpression;
	IUnaryExpression unaryExpression;
}

extern(C++) interface IPrimaryExpression : INode
{
	IIdentifier getIdentifier();
}

class CPrimaryExpression : IPrimaryExpression
{
	this(const PrimaryExpression primaryExpression)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			this.primaryExpression = primaryExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CPrimaryExpression.getKind()");
			return Kind.primaryExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getIdentifier()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!identifier && primaryExpression.identifierOrTemplateInstance)
				identifier = new CIdentifier(primaryExpression.identifierOrTemplateInstance.identifier);
			return identifier;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const PrimaryExpression primaryExpression;
	IIdentifier identifier;
}

extern(C++) interface IAddExpression : INode
{
	IExpressionNode getLeft();
	IExpressionNode getRight();
}

class CAddExpression : IAddExpression
{
	this(const AddExpression addExpression)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			this.addExpression = addExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("AddExpression.getKind()");
			return Kind.addExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IExpressionNode getLeft()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!left)
				left = new CExpressionNode(addExpression.left);
			return left;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IExpressionNode getRight()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!right)
				right = new CExpressionNode(addExpression.right);
			return right;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const AddExpression addExpression;
	IExpressionNode left, right;
}

extern(C++) interface IUnaryExpression : INode
{
	IPrimaryExpression getPrimaryExpression();
	IIdentifier getIdentifier();
	IUnaryExpression getUnaryExpression();
	IFunctionCallExpression getFunctionCallExpression();
}

class CUnaryExpression : IUnaryExpression
{
	this(const UnaryExpression unaryExpression)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			this.unaryExpression = unaryExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CUnaryExpression.getKind()");
			return Kind.unaryExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IPrimaryExpression getPrimaryExpression()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!primaryExpression && unaryExpression.primaryExpression)
				primaryExpression = new CPrimaryExpression(unaryExpression.primaryExpression);
			return primaryExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getIdentifier()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!identifier && unaryExpression.identifierOrTemplateInstance)
				identifier = new CIdentifier(unaryExpression.identifierOrTemplateInstance.identifier);
			return identifier;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IUnaryExpression getUnaryExpression()
	{
		try
		{
			if(!unaryExpression_ && unaryExpression.unaryExpression)
				unaryExpression_ = new CUnaryExpression(unaryExpression.unaryExpression);
			return unaryExpression_;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IFunctionCallExpression getFunctionCallExpression()
	{
		try
		{
			if(!functionCallExpression && unaryExpression.functionCallExpression)
				functionCallExpression = new CFunctionCallExpression(unaryExpression.functionCallExpression);
			return functionCallExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const UnaryExpression unaryExpression;
	IPrimaryExpression primaryExpression;
	IIdentifier identifier;
	IUnaryExpression unaryExpression_;
	IFunctionCallExpression functionCallExpression;
}

extern(C++) interface IAssignExpression : INode
{
	IExpressionNode getAssignedExpression();
	IExpressionNode getTernaryExpression();
}

class CAssignExpression : IAssignExpression
{
	this(const AssignExpression assignExpression)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			this.assignExpression = assignExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CAssignExpression.getKind()");
			return Kind.assignExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IExpressionNode getAssignedExpression()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!assignedExpression && assignExpression.expression)
				assignedExpression = new CExpressionNode(assignExpression.expression);
			return assignedExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IExpressionNode getTernaryExpression()
	{
		try
		{
			if(!ternaryExpression && assignExpression.ternaryExpression)
				ternaryExpression = new CExpressionNode(assignExpression.ternaryExpression);
			return ternaryExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const AssignExpression assignExpression;
	IExpressionNode assignedExpression;
	IExpressionNode ternaryExpression;
}

extern(C++) interface IInitializer : INode
{
	IExpressionNode getAssignedExpression();
}

class CInitializer : IInitializer
{
	this(const Initializer initializer)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			this.initializer = initializer;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CInitializer.getKind()");
			return Kind.initializer;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IExpressionNode getAssignedExpression()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!assignedExpression && initializer.nonVoidInitializer && initializer.nonVoidInitializer.assignExpression)
				assignedExpression = new CExpressionNode(initializer.nonVoidInitializer.assignExpression);
			return assignedExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const Initializer initializer;
	IExpressionNode assignedExpression;
}

extern(C++) interface IImportDeclaration : INode
{
	ulong numImports();
	ISingleImport getImport(int i);
}

class CImportDeclaration : IImportDeclaration
{
	this(const ImportDeclaration importDeclaration)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			this.importDeclaration = importDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CImportDeclaration.getKind()");
			return Kind.importDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong numImports()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			return importDeclaration.singleImports.length;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ISingleImport getImport(int i)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(i !in imports)
				imports[i] = new CSingleImport(importDeclaration.singleImports[i]);
			return imports[i];
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const ImportDeclaration importDeclaration;
	ISingleImport[int] imports;
}

extern(C++) interface ISingleImport : INode
{
	IIdentifier getRename();
	IIdentifier getModuleName();
}

class CSingleImport : ISingleImport
{
	this(const SingleImport singleImport)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			this.singleImport = singleImport;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CSingleImport.getKind()");
			return Kind.singleImport;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getRename()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!rename)
				rename = new CIdentifier(singleImport.rename);
			return rename;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getModuleName()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!moduleName)
				moduleName = new CIdentifier(singleImport.identifierChain);
			return moduleName;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const SingleImport singleImport;
	IIdentifier rename, moduleName;
}

extern(C++) interface IFunctionCallExpression : INode
{
	IType getType();
	IUnaryExpression getUnaryExpression();
	//IArguments getArguments();
}

class CFunctionCallExpression : IFunctionCallExpression
{
	this(const FunctionCallExpression functionCallExpression)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			this.functionCallExpression = functionCallExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("FunctionCallExpression.getKind()");
			return Kind.functionCallExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IType getType()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!type && functionCallExpression.type)
				type = new CType(functionCallExpression.type);
			return type;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IUnaryExpression getUnaryExpression()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!unaryExpression && functionCallExpression.unaryExpression)
				unaryExpression = new CUnaryExpression(functionCallExpression.unaryExpression);
			return unaryExpression;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const FunctionCallExpression functionCallExpression;
	IType type;
	IUnaryExpression unaryExpression;
}

class CIdentifier : IIdentifier
{
	this(const Token token)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writefln("token: %s", token.text);
			this.text = (token.text ~ '\0').idup;
			this.line = token.line;
			this.column = token.column;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	this(string text)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writefln("text: %s", text);
			this.text = (text ~ '\0').idup;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	this(const Symbol symbol)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CIdentifier.this(symbol)");
			if(symbol.identifierOrTemplateChain && symbol.identifierOrTemplateChain.identifiersOrTemplateInstances.length >= 1)
			{
				if(symbol.dot)
					this.text = ".";
				this.text ~= symbol.identifierOrTemplateChain.identifiersOrTemplateInstances[0].identifier.text;
				writefln("text: %s", this.text);
				if(symbol.identifierOrTemplateChain.identifiersOrTemplateInstances.length > 1)
				{
					foreach(identifier; symbol.identifierOrTemplateChain.identifiersOrTemplateInstances[1..$])
						this.text = format("%s.%s", this.text, identifier.identifier.text);
				}
				writefln("more text: %s", this.text);
				this.line = symbol.identifierOrTemplateChain.identifiersOrTemplateInstances[0].identifier.line;
				this.column = symbol.identifierOrTemplateChain.identifiersOrTemplateInstances[0].identifier.column;
				writefln("line: %s, column: %s", this.line, this.column);
				this.text = (this.text ~ '\0').idup;
			}
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	this(const IdentifierChain identifierChain)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CIdentifier.this(id)");
			if(identifierChain.identifiers.length >= 1)
			{
				this.line = identifierChain.identifiers[0].line;
				this.column = identifierChain.identifiers[0].column;
				this.text = identifierChain.identifiers[0].text;
				foreach(identifier; identifierChain.identifiers[1..$])
					this.text = format("%s.%s", this.text, identifier.text);
				this.text = (this.text ~ '\0').idup;
			}
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CIdentifier.getKind()");
			return Kind.identifier;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) char* getString()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CIdentifier.getString()");
			writefln("getString: \"%s\"", text);
			return cast(char*)text.ptr;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong getLine()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CIdentifier.getLine()");
			return line;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong getColumn()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CIdentifier.getColumn()");
			return column;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
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
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!mod)
				writeln("!mod");
			writefln("ptr: %s", &mod);
			this.mod = mod;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CModule.getKind()");
			return Kind.module_;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong numDeclarations()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CModule.numDeclarations()");
			writefln("numDecls: %s", mod.declarations.length);
			return mod.declarations.length;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IModuleDeclaration getModuleDeclaration()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CModule.getModuleDeclaration()");
			if(!mod.moduleDeclaration)
				return null;
			if(!moduleDeclaration)
				moduleDeclaration = new CModuleDeclaration(mod.moduleDeclaration);
			return moduleDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IDeclaration getDeclaration(int i)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CModule.getDeclaration()");
			writefln("%s of %s", i, mod.declarations.length);
			if(i !in nodeCache)
				nodeCache[i] = new CDeclaration(mod.declarations[i]);
			return nodeCache[i];
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const Module mod;
	IModuleDeclaration moduleDeclaration;
	IDeclaration[int] nodeCache;
}

class CModuleDeclaration : IModuleDeclaration
{
	this(const ModuleDeclaration moduleDeclaration)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!moduleDeclaration)
				writeln("!moduleDeclaration");
			this.moduleDeclaration = moduleDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CModuleDeclaration.getKind()");
			return Kind.moduleDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getName()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CModuleDeclaration.getName()");
			if(!moduleDeclaration.moduleName)
				return null;
			if(!name)
				name = new CIdentifier(moduleDeclaration.moduleName);
			return name;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getComment()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CModuleDeclaration.getComment()");
			if(!moduleDeclaration || !moduleDeclaration.comment)
				return null;
			if(!comment)
				comment = new CIdentifier(moduleDeclaration.comment);
			return comment;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong getStart()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CModuleDeclaration.getStart()");
			return moduleDeclaration.startLocation;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong getEnd()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CModuleDeclaration.getEnd()");
			return moduleDeclaration.endLocation;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const ModuleDeclaration moduleDeclaration;
	IIdentifier name, comment;
}

class CBlockStatement : IBlockStatement
{
	this(const BlockStatement blockStatement)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!blockStatement)
				writeln("!blockStatement");
			this.blockStatement = blockStatement;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CBlockStatement.getKind()");
			return Kind.blockStatement;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IDeclarationsAndStatements getDeclarationsAndStatements()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CBlockStatement.getDeclarationsAndStatements()");
			if(!blockStatement.declarationsAndStatements)
				return null;
			if(!declarationsAndStatements)
				declarationsAndStatements = new CDeclarationsAndStatements(blockStatement.declarationsAndStatements);
			return declarationsAndStatements;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong getStart()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CBlockStatement.getStart()");
			return blockStatement.startLocation;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong getEnd()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CBlockStatement.getEnd()");
			return blockStatement.endLocation;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong startLine()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CBlockStatement.startLine()");
			return blockStatement.startLine;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong startColumn()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CBlockStatement.startColumn()");
			return blockStatement.startColumn;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong endLine()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CBlockStatement.endLine()");
			return blockStatement.endLine;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong endColumn()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CBlockStatement.endColumn()");
			return blockStatement.endColumn;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const BlockStatement blockStatement;
	IDeclarationsAndStatements declarationsAndStatements;
}

class CFunctionBody : IFunctionBody
{
	this(const FunctionBody functionBody)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!functionBody)
				writeln("!functionBody");
			this.functionBody = functionBody;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CFunctionBody.getKind()");
			return Kind.functionBody;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IBlockStatement getBlockStatement()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CFunctionBody.getBlockStatement()");
			if(!functionBody.blockStatement)
				return null;
			if(!blockStatement)
				blockStatement = new CBlockStatement(functionBody.blockStatement);
			return blockStatement;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const FunctionBody functionBody;
	IBlockStatement blockStatement;
}

class CFunctionDeclaration : IFunctionDeclaration
{
	this(const FunctionDeclaration functionDeclaration)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!functionDeclaration)
				writeln("!functionDeclaration");
			this.functionDeclaration = functionDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CFunctionDeclaration.getKind()");
			return Kind.functionDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getName()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CFunctionDeclaration.getName()");
			if(!name)
				name = new CIdentifier(functionDeclaration.name);
			return name;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IParameters getParameters()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CFunctionDeclaration.getParameters()");
			if(!functionDeclaration.parameters)
				return null;
			if(!parameters)
				parameters = new CParameters(functionDeclaration.parameters);
			return parameters;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IFunctionBody getFunctionBody()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CFunctionDeclaration.getFunctionBody()");
			if(!functionDeclaration.functionBody)
				return null;
			if(!functionBody)
				functionBody = new CFunctionBody(functionDeclaration.functionBody);
			return functionBody;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IType getReturnType()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CFunctionDeclaration.getReturnType()");
			if(!functionDeclaration.returnType)
				return null;
			if(!type)
				type = new CType(functionDeclaration.returnType);
			return type;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getComment()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CFunctionDeclaration.getComment()");
			if(!functionDeclaration.comment)
				return null;
			if(!comment)
				comment = new CIdentifier(functionDeclaration.comment);
			return comment;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
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
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!parameters)
				writeln("!parameters");
			this.parameters = parameters;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CParameters.getKind()");
			return Kind.parameters;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong startLine()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CParameters.startLine()");
			return parameters.startLine;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong startColumn()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CParameters.startColumn()");
			return parameters.startColumn;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong endLine()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CParameters.endLine()");
			return parameters.endLine;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong endColumn()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CParameters.endColumn()");
			return parameters.endColumn;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong getNumParameters()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CParameters.getNumParameters()");
			return parameters.parameters.length;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IParameter getParameter(int i)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writefln("CParameters.getParameter(%s) of %s", i, parameters.parameters.length);
			if(i !in parameter)
				parameter[i] = new CParameter(parameters.parameters[i]);
			return parameter[i];
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) bool hasVarargs()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CParameters.hasVarargs()");
			return parameters.hasVarargs;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const Parameters parameters;
	IParameter[int] parameter;
}

class CParameter : IParameter
{
	this(const Parameter parameter)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!parameter)
				writeln("!parameter");
			this.parameter = parameter;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CParameter.getKind()");
			return Kind.parameter;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getName()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CParameter.getName()");
			if(!name)
				name = new CIdentifier(parameter.name);
			return name;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IType getType()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CParameter.getType()");
			if(!parameter.type)
				return null;
			if(!type)
				type = new CType(parameter.type);
			return type;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const Parameter parameter;
	IIdentifier name;
	IType type;
}

class CType : IType
{
	this(const Type type)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!type)
				writeln("!type");
			this.type = type;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CType.getKind()");
			return Kind.type;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getName()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writefln("CType.getName()");
			if(!name)
			{
				//typeCons: const, immutable, inout, shared
				//suffix: [], *, delegate, function
				//symbol: identifier/.indentifier
				//builtInType: IdType
				//typeof: typeof(other)
				if(type && type.type2)
				{
					if(type.type2.symbol)
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
			}
			return name;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) bool isArray()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CType.isArray()");
			foreach(suf; type.typeSuffixes)
			{
				if(suf.array)
					return true;
			}
			return false;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) bool isPointer()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CType.isPointer()");
			foreach(suf; type.typeSuffixes)
			{
				if(suf.star != tok!"")
					return true;
			}
			return false;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const Type type;
	IIdentifier name;
}

class CDeclarationsAndStatements : IDeclarationsAndStatements
{
	this(const DeclarationsAndStatements declarationsAndStatements)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!declarationsAndStatements)
				writeln("!declarationsAndStatements");
			this.declarationsAndStatements = declarationsAndStatements;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CDeclarationsAndStatements.getKind()");
			return Kind.declarationsAndStatements;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong numDeclarationOrStatements()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CDeclarationsAndStatements.numDeclarationOrStatements()");
			if(!declarationsAndStatements || !declarationsAndStatements.declarationsAndStatements)
				return 0;
			return declarationsAndStatements.declarationsAndStatements.length;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) INode getDeclarationOrStatement(int i)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writefln("CDeclarationsAndStatements.getDeclarationOrStatement(%s) of %s", i, declarationsAndStatements.declarationsAndStatements.length);
			if(i !in cache)
			{
				if(declarationsAndStatements.declarationsAndStatements[i].declaration)
					cache[i] = new CDeclaration(declarationsAndStatements.declarationsAndStatements[i].declaration);
				else if(declarationsAndStatements.declarationsAndStatements[i].statement)
					cache[i] = new CStatement(declarationsAndStatements.declarationsAndStatements[i].statement);
			}
			return cache[i];
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const DeclarationsAndStatements declarationsAndStatements;
	INode[int] cache;
}

class CDeclaration : IDeclaration
{
	this(const Declaration declaration)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!declaration)
				writeln("!declaration");
			this.declaration = declaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CDeclaration.getKind()");
			return Kind.declaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IClassDeclaration getClassDeclaration()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CDeclaration.getClassDeclaration()");
			if(!declaration.classDeclaration)
				return null;
			if(!classDeclaration)
				classDeclaration = new CClassDeclaration(declaration.classDeclaration);
			return classDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IFunctionDeclaration getFunctionDeclaration()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CDeclaration.getFunctionDeclaration()");
			if(!declaration.functionDeclaration)
				return null;
			if(!functionDeclaration)
				functionDeclaration = new CFunctionDeclaration(declaration.functionDeclaration);
			return functionDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IImportDeclaration getImportDeclaration()
	{
		try
		{
			writeln("CDeclaration.getImportDeclaration()");
			if(!declaration.importDeclaration)
				return null;
			if(!importDeclaration)
				importDeclaration = new CImportDeclaration(declaration.importDeclaration);
			return importDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IStructDeclaration getStructDeclaration()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CDeclaration.getStructDeclaration()");
			if(!declaration.structDeclaration)
				return null;
			if(!structDeclaration)
				structDeclaration = new CStructDeclaration(declaration.structDeclaration);
			return structDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IVariableDeclaration getVariableDeclaration()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CDeclaration.getVariableDeclaration()");
			if(!declaration.variableDeclaration)
				return null;
			if(!variableDeclaration)
				variableDeclaration = new CVariableDeclaration(declaration.variableDeclaration);
			return variableDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const Declaration declaration;
	IClassDeclaration classDeclaration;
	IFunctionDeclaration functionDeclaration;
	IImportDeclaration importDeclaration;
	IStructDeclaration structDeclaration;
	IVariableDeclaration variableDeclaration;
}

class CVariableDeclaration : IVariableDeclaration
{
	this(const VariableDeclaration variableDeclaration)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!variableDeclaration)
				writeln("!variableDeclaration");
			this.variableDeclaration = variableDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CVariableDeclaration.getKind()");
			return Kind.variableDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IType getType()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CVariableDeclaration.getType()");
			if(!variableDeclaration.type)
				return null;
			if(!type)
				type = new CType(variableDeclaration.type);
			return type;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong numDeclarators()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CVariableDeclaration.numDeclarators()");
			return variableDeclaration.declarators.length;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IDeclarator getDeclarator(int i)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writefln("CVariableDeclaration.getDeclarator(%s) of %s", i, variableDeclaration.declarators.length);
			if(i !in declarators)
				declarators[i] = new CDeclarator(variableDeclaration.declarators[i]);
			return declarators[i];
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getComment()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CVariableDeclaration.getComment()");
			if(!variableDeclaration.comment)
				return null;
			if(!comment)
				comment = new CIdentifier(variableDeclaration.comment);
			return comment;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
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
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!declarator)
				writeln("!declarator");
			this.declarator = declarator;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CDeclarator.getKind()");
			return Kind.declarator;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getName()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CDeclarator.getName()");
			if(!name)
				name = new CIdentifier(declarator.name);
			return name;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getComment()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CDeclarator.getComment()");
			if(!declarator.comment)
				return null;
			if(!comment)
				comment = new CIdentifier(declarator.comment);
			return comment;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IInitializer getInitializer()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CDeclarator.getInitializer()");
			if(!initializer && declarator.initializer)
				initializer = new CInitializer(declarator.initializer);
			return initializer;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const Declarator declarator;
	IIdentifier name;
	IIdentifier comment;
	IInitializer initializer;
}

class CClassDeclaration : IClassDeclaration
{
	this(const ClassDeclaration classDeclaration)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!classDeclaration)
				writeln("!classDeclaration");
			this.classDeclaration = classDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CClassDeclaration.getKind()");
			return Kind.classDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getName()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CClassDeclaration.getName()");
			if(!name)
				name = new CIdentifier(classDeclaration.name);
			return name;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IStructBody getStructBody()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CClassDeclaration.getStructBody()");
			writefln("%s %s", classDeclaration is null, classDeclaration.structBody is null);
			if(!classDeclaration.structBody)
				return null;
			if(!structBody)
				structBody = new CStructBody(classDeclaration.structBody);
			return structBody;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getComment()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CClassDeclaration.getComment()");
			if(!classDeclaration)
				writeln("OMG No ClassDecl!");
			if(!classDeclaration.comment)
				return null;
			if(!comment)
				comment = new CIdentifier(classDeclaration.comment);
			return comment;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const ClassDeclaration classDeclaration;
	IIdentifier name;
	IStructBody structBody;
	IIdentifier comment;
}

class CStructDeclaration : IStructDeclaration
{
	this(const StructDeclaration structDeclaration)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!structDeclaration)
				writeln("!structDeclaration");
			this.structDeclaration = structDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CStructDeclaration.getKind()");
			return Kind.structDeclaration;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IIdentifier getName()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CStructDeclaration.getName()");
			if(!name)
				name = new CIdentifier(structDeclaration.name);
			return name;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IStructBody getStructBody()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CStructDeclaration.getStructBody()");
			if(!structDeclaration.structBody)
				return null;
			if(!structBody)
				structBody = new CStructBody(structDeclaration.structBody);
			return structBody;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	
	extern(C++) IIdentifier getComment()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CStructDeclaration.getComment()");
			if(!structDeclaration.comment)
				return null;
			if(!comment)
				comment = new CIdentifier(structDeclaration.comment);
			return comment;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const StructDeclaration structDeclaration;
	IIdentifier name;
	IStructBody structBody;
	IIdentifier comment;
}

class CStructBody : IStructBody
{
	this(const StructBody structBody)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			if(!structBody)
				writeln("!structBody");
			this.structBody = structBody;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
	}
	
	extern(C++) Kind getKind()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CStructBody.getKind()");
			return Kind.structBody;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong numDeclarations()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CStructBody.numDeclarations()");
			return structBody.declarations.length;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) IDeclaration getDeclaration(int i)
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writefln("CStructBody.getDeclaration(%s) or %s", i, structBody.declarations.length);
			if(i !in declaration)
				declaration[i] = new CDeclaration(structBody.declarations[i]);
			return declaration[i];
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong startLine()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CStructBody.startLine()");
			return structBody.startLine;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong startColumn()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CStructBody.startColumn()");
			return structBody.startColumn;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong endLine()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CStructBody.endLine()");
			return structBody.endLine;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}
	
	extern(C++) ulong endColumn()
	{
		//scope(failure) writefln("fffff %s", __LINE__);
		try
		{
			writeln("CStructBody.endColumn()");
			return structBody.endColumn;
		}
		catch(Throwable e)
		{
			writefln("e: %s", e);
			raise(SIGSEGV);
		}
		assert(0);
	}

private:
	const StructBody structBody;
	IDeclaration[int] declaration;
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
    /** */ //override void visit(const SliceExpression sliceExpression) { writeln("SliceExpression"); if(traverse) sliceExpression.accept(this); }
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
	writeln("initDParser()");
}

extern(C++) void deinitDParser()
{
	writeln("deinitDParser()");
	import core.runtime;
	Runtime.terminate();
}

extern(C++) IModule parseSourceFile(char* sourceFile, char* sourceData)
{
	//scope(failure) writefln("fffff %s", __LINE__);
	try
	{
		import std.string;
		writefln("parseSourceFile(%s)", fromStringz(sourceFile));
		
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
	catch(Throwable e)
	{
		writefln("e: %s", e);
		raise(SIGSEGV);
	}
	assert(0);
}

__gshared CModule[string] moduleCache;
