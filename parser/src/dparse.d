module dparser;

import core.stdc.signal;
import std.stdio;

import dparse.lexer;
import dparse.parser;
import dparse.ast;

import astWrapper;

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

class Visitor : ASTVisitor
{
	alias visit = ASTVisitor.visit;
	
	override void visit(const ModuleDeclaration moduleDeclaration)
	{
		moduleDeclaration.accept(this);
	}
}

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
	try
	{
		import core.memory;
		import core.thread;
		import std.string;
		
		GC.disable(); //FIXME: Make it work with GC!
		
		writefln("parseSourceFile(%s)", fromStringz(sourceFile));
		
		thread_attachThis();
		
		LexerConfig config;
		config.fileName = fromStringz(sourceFile).idup;
		auto source = cast(ubyte[])fromStringz(sourceData);
		auto tokens = getTokensForParser(source, config, new StringCache(StringCache.defaultBucketCount));
		keepAlive[config.fileName] = new CModule(parseModule(tokens, config.fileName));
		return keepAlive[config.fileName];
	}
	catch(Throwable e)
	{
		writefln("e: %s", e);
		raise(SIGSEGV);
	}
	assert(0);
}

__gshared CModule[string] keepAlive;
