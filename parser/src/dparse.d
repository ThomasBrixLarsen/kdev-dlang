module dparser;

import core.stdc.signal;
import std.stdio;

import dparse.lexer;
import dparse.parser;
import dparse.ast;

import astWrapper;

class ASTPrinter : ASTVisitor
{
	this(File file, bool traverse)
	{
		this.file = file;
		this.traverse = traverse;
	}
	File file;
	int indentation;
	string indentationLevel()
	{
		string indent;
		foreach(i; 0..indentation)
			indent ~= " ";
		return indent;
	}
	bool traverse;
	alias visit = ASTVisitor.visit;
	/** */ override void visit(const AddExpression addExpression) { file.writefln("%sAddExpression", indentationLevel()); if(traverse) { indentation++; addExpression.accept(this); indentation--; } }
    /** */ override void visit(const AliasDeclaration aliasDeclaration) { file.writefln("%sAliasDeclaration", indentationLevel()); if(traverse) { indentation++; aliasDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const AliasInitializer aliasInitializer) { file.writefln("%sAliasInitializer", indentationLevel()); if(traverse) { indentation++; aliasInitializer.accept(this); indentation--; } }
    /** */ override void visit(const AliasThisDeclaration aliasThisDeclaration) { file.writefln("%sAliasThisDeclaration", indentationLevel()); if(traverse) { indentation++; aliasThisDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const AlignAttribute alignAttribute) { file.writefln("%sAlignAttribute", indentationLevel()); if(traverse) { indentation++; alignAttribute.accept(this); indentation--; } }
    /** */ override void visit(const AndAndExpression andAndExpression) { file.writefln("%sAndAndExpression", indentationLevel()); if(traverse) { indentation++; andAndExpression.accept(this); indentation--; } }
    /** */ override void visit(const AndExpression andExpression) { file.writefln("%sAndExpression", indentationLevel()); if(traverse) { indentation++; andExpression.accept(this); indentation--; } }
    /** */ override void visit(const AnonymousEnumDeclaration anonymousEnumDeclaration) { file.writefln("%sAnonymousEnumDeclaration", indentationLevel()); if(traverse) { indentation++; anonymousEnumDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const AnonymousEnumMember anonymousEnumMember) { file.writefln("%sAnonymousEnumMember", indentationLevel()); if(traverse) { indentation++; anonymousEnumMember.accept(this); indentation--; } }
    /** */ override void visit(const ArgumentList argumentList) { file.writefln("%sArgumentList", indentationLevel()); if(traverse) { indentation++; argumentList.accept(this); indentation--; } }
    /** */ override void visit(const Arguments arguments) { file.writefln("%sArguments", indentationLevel()); if(traverse) { indentation++; arguments.accept(this); indentation--; } }
    /** */ override void visit(const ArrayInitializer arrayInitializer) { file.writefln("%sArrayInitializer", indentationLevel()); if(traverse) { indentation++; arrayInitializer.accept(this); indentation--; } }
    /** */ override void visit(const ArrayLiteral arrayLiteral) { file.writefln("%sArrayLiteral", indentationLevel()); if(traverse) { indentation++; arrayLiteral.accept(this); indentation--; } }
    /** */ override void visit(const ArrayMemberInitialization arrayMemberInitialization) { file.writefln("%sArrayMemberInitialization", indentationLevel()); if(traverse) { indentation++; arrayMemberInitialization.accept(this); indentation--; } }
    /** */ override void visit(const AssertExpression assertExpression) { file.writefln("%sAssertExpression", indentationLevel()); if(traverse) { indentation++; assertExpression.accept(this); indentation--; } }
    /** */ override void visit(const AssignExpression assignExpression) { file.writefln("%sAssignExpression", indentationLevel()); if(traverse) { indentation++; assignExpression.accept(this); indentation--; } }
    /** */ override void visit(const AssocArrayLiteral assocArrayLiteral) { file.writefln("%sAssocArrayLiteral", indentationLevel()); if(traverse) { indentation++; assocArrayLiteral.accept(this); indentation--; } }
    /** */ override void visit(const AtAttribute atAttribute) { file.writefln("%sAtAttribute", indentationLevel()); if(traverse) { indentation++; atAttribute.accept(this); indentation--; } }
    /** */ override void visit(const Attribute attribute) { file.writefln("%sAttribute", indentationLevel()); if(traverse) { indentation++; attribute.accept(this); indentation--; } }
    /** */ override void visit(const AttributeDeclaration attributeDeclaration) { file.writefln("%sAttributeDeclaration", indentationLevel()); if(traverse) { indentation++; attributeDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const AutoDeclaration autoDeclaration) { file.writefln("%sAutoDeclaration", indentationLevel()); if(traverse) { indentation++; autoDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const BlockStatement blockStatement) { file.writefln("%sBlockStatement", indentationLevel()); if(traverse) { indentation++; blockStatement.accept(this); indentation--; } }
    /** */ override void visit(const BodyStatement bodyStatement) { file.writefln("%sBodyStatement", indentationLevel()); if(traverse) { indentation++; bodyStatement.accept(this); indentation--; } }
    /** */ override void visit(const BreakStatement breakStatement) { file.writefln("%sBreakStatement", indentationLevel()); if(traverse) { indentation++; breakStatement.accept(this); indentation--; } }
    /** */ override void visit(const BaseClass baseClass) { file.writefln("%sBaseClass", indentationLevel()); if(traverse) { indentation++; baseClass.accept(this); indentation--; } }
    /** */ override void visit(const BaseClassList baseClassList) { file.writefln("%sBaseClassList", indentationLevel()); if(traverse) { indentation++; baseClassList.accept(this); indentation--; } }
    /** */ override void visit(const CaseRangeStatement caseRangeStatement) { file.writefln("%sCaseRangeStatement", indentationLevel()); if(traverse) { indentation++; caseRangeStatement.accept(this); indentation--; } }
    /** */ override void visit(const CaseStatement caseStatement) { file.writefln("%sCaseStatement", indentationLevel()); if(traverse) { indentation++; caseStatement.accept(this); indentation--; } }
    /** */ override void visit(const CastExpression castExpression) { file.writefln("%sCastExpression", indentationLevel()); if(traverse) { indentation++; castExpression.accept(this); indentation--; } }
    /** */ override void visit(const CastQualifier castQualifier) { file.writefln("%sCastQualifier", indentationLevel()); if(traverse) { indentation++; castQualifier.accept(this); indentation--; } }
    /** */ override void visit(const Catch catch_) { file.writefln("%sCatch", indentationLevel()); if(traverse) { indentation++; catch_.accept(this); indentation--; } }
    /** */ override void visit(const Catches catches) { file.writefln("%sCatches", indentationLevel()); if(traverse) { indentation++; catches.accept(this); indentation--; } }
    /** */ override void visit(const ClassDeclaration classDeclaration) { file.writefln("%sClassDeclaration", indentationLevel()); if(traverse) { indentation++; classDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const CmpExpression cmpExpression) { file.writefln("%sCmpExpression", indentationLevel()); if(traverse) { indentation++; cmpExpression.accept(this); indentation--; } }
    /** */ override void visit(const CompileCondition compileCondition) { file.writefln("%sCompileCondition", indentationLevel()); if(traverse) { indentation++; compileCondition.accept(this); indentation--; } }
    /** */ override void visit(const ConditionalDeclaration conditionalDeclaration) { file.writefln("%sConditionalDeclaration", indentationLevel()); if(traverse) { indentation++; conditionalDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const ConditionalStatement conditionalStatement) { file.writefln("%sConditionalStatement", indentationLevel()); if(traverse) { indentation++; conditionalStatement.accept(this); indentation--; } }
    /** */ override void visit(const Constraint constraint) { file.writefln("%sConstraint", indentationLevel()); if(traverse) { indentation++; constraint.accept(this); indentation--; } }
    /** */ override void visit(const Constructor constructor) { file.writefln("%sConstructor", indentationLevel()); if(traverse) { indentation++; constructor.accept(this); indentation--; } }
    /** */ override void visit(const ContinueStatement continueStatement) { file.writefln("%sContinueStatement", indentationLevel()); if(traverse) { indentation++; continueStatement.accept(this); indentation--; } }
    /** */ override void visit(const DebugCondition debugCondition) { file.writefln("%sDebugCondition", indentationLevel()); if(traverse) { indentation++; debugCondition.accept(this); indentation--; } }
    /** */ override void visit(const DebugSpecification debugSpecification) { file.writefln("%sDebugSpecification", indentationLevel()); if(traverse) { indentation++; debugSpecification.accept(this); indentation--; } }
    /** */ override void visit(const Declaration declaration) { file.writefln("%sDeclaration", indentationLevel()); if(traverse) { indentation++; declaration.accept(this); indentation--; } }
    /** */ override void visit(const DeclarationOrStatement declarationsOrStatement) { file.writefln("%sDeclarationOrStatement", indentationLevel()); if(traverse) { indentation++; declarationsOrStatement.accept(this); indentation--; } }
    /** */ override void visit(const DeclarationsAndStatements declarationsAndStatements) { file.writefln("%sDeclarationsAndStatements", indentationLevel()); if(traverse) { indentation++; declarationsAndStatements.accept(this); indentation--; } }
    /** */ override void visit(const Declarator declarator) { file.writefln("%sDeclarator", indentationLevel()); if(traverse) { indentation++; declarator.accept(this); indentation--; } }
    /** */ override void visit(const DefaultStatement defaultStatement) { file.writefln("%sDefaultStatement", indentationLevel()); if(traverse) { indentation++; defaultStatement.accept(this); indentation--; } }
    /** */ override void visit(const DeleteExpression deleteExpression) { file.writefln("%sDeleteExpression", indentationLevel()); if(traverse) { indentation++; deleteExpression.accept(this); indentation--; } }
    /** */ override void visit(const DeleteStatement deleteStatement) { file.writefln("%sDeleteStatement", indentationLevel()); if(traverse) { indentation++; deleteStatement.accept(this); indentation--; } }
    /** */ override void visit(const Deprecated deprecated_) { file.writefln("%sDeprecated", indentationLevel()); if(traverse) { indentation++; deprecated_.accept(this); indentation--; } }
    /** */ override void visit(const Destructor destructor) { file.writefln("%sDestructor", indentationLevel()); if(traverse) { indentation++; destructor.accept(this); indentation--; } }
    /** */ override void visit(const DoStatement doStatement) { file.writefln("%sDoStatement", indentationLevel()); if(traverse) { indentation++; doStatement.accept(this); indentation--; } }
    /** */ override void visit(const EnumBody enumBody) { file.writefln("%sEnumBody", indentationLevel()); if(traverse) { indentation++; enumBody.accept(this); indentation--; } }
    /** */ override void visit(const EnumDeclaration enumDeclaration) { file.writefln("%sEnumDeclaration", indentationLevel()); if(traverse) { indentation++; enumDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const EnumMember enumMember) { file.writefln("%sEnumMember", indentationLevel()); if(traverse) { indentation++; enumMember.accept(this); indentation--; } }
    /** */ override void visit(const EponymousTemplateDeclaration eponymousTemplateDeclaration) { file.writefln("%sEponymousTemplateDeclaration", indentationLevel()); if(traverse) { indentation++; eponymousTemplateDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const EqualExpression equalExpression) { file.writefln("%sEqualExpression", indentationLevel()); if(traverse) { indentation++; equalExpression.accept(this); indentation--; } }
    /** */ override void visit(const Expression expression) { file.writefln("%sExpression", indentationLevel()); if(traverse) { indentation++; expression.accept(this); indentation--; } }
    /** */ override void visit(const ExpressionStatement expressionStatement) { file.writefln("%sExpressionStatement", indentationLevel()); if(traverse) { indentation++; expressionStatement.accept(this); indentation--; } }
    /** */ override void visit(const FinalSwitchStatement finalSwitchStatement) { file.writefln("%sFinalSwitchStatement", indentationLevel()); if(traverse) { indentation++; finalSwitchStatement.accept(this); indentation--; } }
    /** */ override void visit(const Finally finally_) { file.writefln("%sFinally", indentationLevel()); if(traverse) { indentation++; finally_.accept(this); indentation--; } }
    /** */ override void visit(const ForStatement forStatement) { file.writefln("%sForStatement", indentationLevel()); if(traverse) { indentation++; forStatement.accept(this); indentation--; } }
    /** */ override void visit(const ForeachStatement foreachStatement) { file.writefln("%sForeachStatement", indentationLevel()); if(traverse) { indentation++; foreachStatement.accept(this); indentation--; } }
    /** */ override void visit(const ForeachType foreachType) { file.writefln("%sForeachType", indentationLevel()); if(traverse) { indentation++; foreachType.accept(this); indentation--; } }
    /** */ override void visit(const ForeachTypeList foreachTypeList) { file.writefln("%sForeachTypeList", indentationLevel()); if(traverse) { indentation++; foreachTypeList.accept(this); indentation--; } }
    /** */ override void visit(const FunctionAttribute functionAttribute) { file.writefln("%sFunctionAttribute", indentationLevel()); if(traverse) { indentation++; functionAttribute.accept(this); indentation--; } }
    /** */ override void visit(const FunctionBody functionBody) { file.writefln("%sFunctionBody", indentationLevel()); if(traverse) { indentation++; functionBody.accept(this); indentation--; } }
    /** */ override void visit(const FunctionCallExpression functionCallExpression) { file.writefln("%sFunctionCallExpression", indentationLevel()); if(traverse) { indentation++; functionCallExpression.accept(this); indentation--; } }
    /** */ override void visit(const FunctionDeclaration functionDeclaration) { file.writefln("%sFunctionDeclaration", indentationLevel()); if(traverse) { indentation++; functionDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const FunctionLiteralExpression functionLiteralExpression) { file.writefln("%sFunctionLiteralExpression", indentationLevel()); if(traverse) { indentation++; functionLiteralExpression.accept(this); indentation--; } }
    /** */ override void visit(const GotoStatement gotoStatement) { file.writefln("%sGotoStatement", indentationLevel()); if(traverse) { indentation++; gotoStatement.accept(this); indentation--; } }
    /** */ override void visit(const IdentifierChain identifierChain) { file.writefln("%sIdentifierChain", indentationLevel()); if(traverse) { indentation++; identifierChain.accept(this); indentation--; } }
    /** */ override void visit(const IdentifierList identifierList) { file.writefln("%sIdentifierList", indentationLevel()); if(traverse) { indentation++; identifierList.accept(this); indentation--; } }
    /** */ override void visit(const IdentifierOrTemplateChain identifierOrTemplateChain) { file.writefln("%sIdentifierOrTemplateChain", indentationLevel()); if(traverse) { indentation++; identifierOrTemplateChain.accept(this); indentation--; } }
    /** */ override void visit(const IdentifierOrTemplateInstance identifierOrTemplateInstance) { file.writefln("%sIdentifierOrTemplateInstance", indentationLevel()); if(traverse) { indentation++; identifierOrTemplateInstance.accept(this); indentation--; } }
    /** */ override void visit(const IdentityExpression identityExpression) { file.writefln("%sIdentityExpression", indentationLevel()); if(traverse) { indentation++; identityExpression.accept(this); indentation--; } }
    /** */ override void visit(const IfStatement ifStatement) { file.writefln("%sIfStatement", indentationLevel()); if(traverse) { indentation++; ifStatement.accept(this); indentation--; } }
    /** */ override void visit(const ImportBind importBind) { file.writefln("%sImportBind", indentationLevel()); if(traverse) { indentation++; importBind.accept(this); indentation--; } }
    /** */ override void visit(const ImportBindings importBindings) { file.writefln("%sImportBindings", indentationLevel()); if(traverse) { indentation++; importBindings.accept(this); indentation--; } }
    /** */ override void visit(const ImportDeclaration importDeclaration) { file.writefln("%sImportDeclaration", indentationLevel()); if(traverse) { indentation++; importDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const ImportExpression importExpression) { file.writefln("%sImportExpression", indentationLevel()); if(traverse) { indentation++; importExpression.accept(this); indentation--; } }
    /** */ override void visit(const IndexExpression indexExpression) { file.writefln("%sIndexExpression", indentationLevel()); if(traverse) { indentation++; indexExpression.accept(this); indentation--; } }
    /** */ override void visit(const InExpression inExpression) { file.writefln("%sInExpression", indentationLevel()); if(traverse) { indentation++; inExpression.accept(this); indentation--; } }
    /** */ override void visit(const InStatement inStatement) { file.writefln("%sInStatement", indentationLevel()); if(traverse) { indentation++; inStatement.accept(this); indentation--; } }
    /** */ override void visit(const Initialize initialize) { file.writefln("%sInitialize", indentationLevel()); if(traverse) { indentation++; initialize.accept(this); indentation--; } }
    /** */ override void visit(const Initializer initializer) { file.writefln("%sInitializer", indentationLevel()); if(traverse) { indentation++; initializer.accept(this); indentation--; } }
    /** */ override void visit(const InterfaceDeclaration interfaceDeclaration) { file.writefln("%sInterfaceDeclaration", indentationLevel()); if(traverse) { indentation++; interfaceDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const Invariant invariant_) { file.writefln("%sInvariant", indentationLevel()); if(traverse) { indentation++; invariant_.accept(this); indentation--; } }
    /** */ override void visit(const IsExpression isExpression) { file.writefln("%sIsExpression", indentationLevel()); if(traverse) { indentation++; isExpression.accept(this); indentation--; } }
    /** */ override void visit(const KeyValuePair keyValuePair) { file.writefln("%sKeyValuePair", indentationLevel()); if(traverse) { indentation++; keyValuePair.accept(this); indentation--; } }
    /** */ override void visit(const KeyValuePairs keyValuePairs) { file.writefln("%sKeyValuePairs", indentationLevel()); if(traverse) { indentation++; keyValuePairs.accept(this); indentation--; } }
    /** */ override void visit(const LabeledStatement labeledStatement) { file.writefln("%sLabeledStatement", indentationLevel()); if(traverse) { indentation++; labeledStatement.accept(this); indentation--; } }
    /** */ override void visit(const LambdaExpression lambdaExpression) { file.writefln("%sLambdaExpression", indentationLevel()); if(traverse) { indentation++; lambdaExpression.accept(this); indentation--; } }
    /** */ override void visit(const LastCatch lastCatch) { file.writefln("%sLastCatch", indentationLevel()); if(traverse) { indentation++; lastCatch.accept(this); indentation--; } }
    /** */ override void visit(const LinkageAttribute linkageAttribute) { file.writefln("%sLinkageAttribute", indentationLevel()); if(traverse) { indentation++; linkageAttribute.accept(this); indentation--; } }
    /** */ override void visit(const MemberFunctionAttribute memberFunctionAttribute) { file.writefln("%sMemberFunctionAttribute", indentationLevel()); if(traverse) { indentation++; memberFunctionAttribute.accept(this); indentation--; } }
    /** */ override void visit(const MixinDeclaration mixinDeclaration) { file.writefln("%sMixinDeclaration", indentationLevel()); if(traverse) { indentation++; mixinDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const MixinExpression mixinExpression) { file.writefln("%sMixinExpression", indentationLevel()); if(traverse) { indentation++; mixinExpression.accept(this); indentation--; } }
    /** */ override void visit(const MixinTemplateDeclaration mixinTemplateDeclaration) { file.writefln("%sMixinTemplateDeclaration", indentationLevel()); if(traverse) { indentation++; mixinTemplateDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const MixinTemplateName mixinTemplateName) { file.writefln("%sMixinTemplateName", indentationLevel()); if(traverse) { indentation++; mixinTemplateName.accept(this); indentation--; } }
    /** */ override void visit(const Module module_) { file.writefln("%sModule", indentationLevel()); if(traverse) { indentation++; module_.accept(this); indentation--; } }
    /** */ override void visit(const ModuleDeclaration moduleDeclaration) { file.writefln("%sModuleDeclaration", indentationLevel()); if(traverse) { indentation++; moduleDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const MulExpression mulExpression) { file.writefln("%sMulExpression", indentationLevel()); if(traverse) { indentation++; mulExpression.accept(this); indentation--; } }
    /** */ override void visit(const NewAnonClassExpression newAnonClassExpression) { file.writefln("%sNewAnonClassExpression", indentationLevel()); if(traverse) { indentation++; newAnonClassExpression.accept(this); indentation--; } }
    /** */ override void visit(const NewExpression newExpression) { file.writefln("%sNewExpression", indentationLevel()); if(traverse) { indentation++; newExpression.accept(this); indentation--; } }
    /** */ override void visit(const NonVoidInitializer nonVoidInitializer) { file.writefln("%sNonVoidInitializer", indentationLevel()); if(traverse) { indentation++; nonVoidInitializer.accept(this); indentation--; } }
    /** */ override void visit(const Operands operands) { file.writefln("%sOperands", indentationLevel()); if(traverse) { indentation++; operands.accept(this); indentation--; } }
    /** */ override void visit(const OrExpression orExpression) { file.writefln("%sOrExpression", indentationLevel()); if(traverse) { indentation++; orExpression.accept(this); indentation--; } }
    /** */ override void visit(const OrOrExpression orOrExpression) { file.writefln("%sOrOrExpression", indentationLevel()); if(traverse) { indentation++; orOrExpression.accept(this); indentation--; } }
    /** */ override void visit(const OutStatement outStatement) { file.writefln("%sOutStatement", indentationLevel()); if(traverse) { indentation++; outStatement.accept(this); indentation--; } }
    /** */ override void visit(const Parameter parameter) { file.writefln("%sParameter", indentationLevel()); if(traverse) { indentation++; parameter.accept(this); indentation--; } }
    /** */ override void visit(const Parameters parameters) { file.writefln("%sParameters", indentationLevel()); if(traverse) { indentation++; parameters.accept(this); indentation--; } }
    /** */ override void visit(const Postblit postblit) { file.writefln("%sPostblit", indentationLevel()); if(traverse) { indentation++; postblit.accept(this); indentation--; } }
    /** */ override void visit(const PowExpression powExpression) { file.writefln("%sPowExpression", indentationLevel()); if(traverse) { indentation++; powExpression.accept(this); indentation--; } }
    /** */ override void visit(const PragmaDeclaration pragmaDeclaration) { file.writefln("%sPragmaDeclaration", indentationLevel()); if(traverse) { indentation++; pragmaDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const PragmaExpression pragmaExpression) { file.writefln("%sPragmaExpression", indentationLevel()); if(traverse) { indentation++; pragmaExpression.accept(this); indentation--; } }
    /** */ override void visit(const PrimaryExpression primaryExpression) { file.writefln("%sPrimaryExpression", indentationLevel()); if(traverse) { indentation++; primaryExpression.accept(this); indentation--; } }
    /** */ override void visit(const Register register) { file.writefln("%sRegister", indentationLevel()); if(traverse) { indentation++; register.accept(this); indentation--; } }
    /** */ override void visit(const RelExpression relExpression) { file.writefln("%sRelExpression", indentationLevel()); if(traverse) { indentation++; relExpression.accept(this); indentation--; } }
    /** */ override void visit(const ReturnStatement returnStatement) { file.writefln("%sReturnStatement", indentationLevel()); if(traverse) { indentation++; returnStatement.accept(this); indentation--; } }
    /** */ override void visit(const ScopeGuardStatement scopeGuardStatement) { file.writefln("%sScopeGuardStatement", indentationLevel()); if(traverse) { indentation++; scopeGuardStatement.accept(this); indentation--; } }
    /** */ override void visit(const SharedStaticConstructor sharedStaticConstructor) { file.writefln("%sSharedStaticConstructor", indentationLevel()); if(traverse) { indentation++; sharedStaticConstructor.accept(this); indentation--; } }
    /** */ override void visit(const SharedStaticDestructor sharedStaticDestructor) { file.writefln("%sSharedStaticDestructor", indentationLevel()); if(traverse) { indentation++; sharedStaticDestructor.accept(this); indentation--; } }
    /** */ override void visit(const ShiftExpression shiftExpression) { file.writefln("%sShiftExpression", indentationLevel()); if(traverse) { indentation++; shiftExpression.accept(this); indentation--; } }
    /** */ override void visit(const SingleImport singleImport) { file.writefln("%sSingleImport", indentationLevel()); if(traverse) { indentation++; singleImport.accept(this); indentation--; } }
    /** */ //override void visit(const SliceExpression sliceExpression) { file.writefln("%sSliceExpression", indentationLevel()); if(traverse) { indentation++; sliceExpression.accept(this); indentation--; } }
    /** */ override void visit(const Statement statement) { file.writefln("%sStatement", indentationLevel()); if(traverse) { indentation++; statement.accept(this); indentation--; } }
    /** */ override void visit(const StatementNoCaseNoDefault statementNoCaseNoDefault) { file.writefln("%sStatementNoCaseNoDefault", indentationLevel()); if(traverse) { indentation++; statementNoCaseNoDefault.accept(this); indentation--; } }
    /** */ override void visit(const StaticAssertDeclaration staticAssertDeclaration) { file.writefln("%sStaticAssertDeclaration", indentationLevel()); if(traverse) { indentation++; staticAssertDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const StaticAssertStatement staticAssertStatement) { file.writefln("%sStaticAssertStatement", indentationLevel()); if(traverse) { indentation++; staticAssertStatement.accept(this); indentation--; } }
    /** */ override void visit(const StaticConstructor staticConstructor) { file.writefln("%sStaticConstructor", indentationLevel()); if(traverse) { indentation++; staticConstructor.accept(this); indentation--; } }
    /** */ override void visit(const StaticDestructor staticDestructor) { file.writefln("%sStaticDestructor", indentationLevel()); if(traverse) { indentation++; staticDestructor.accept(this); indentation--; } }
    /** */ override void visit(const StaticIfCondition staticIfCondition) { file.writefln("%sStaticIfCondition", indentationLevel()); if(traverse) { indentation++; staticIfCondition.accept(this); indentation--; } }
    /** */ override void visit(const StorageClass storageClass) { file.writefln("%sStorageClass", indentationLevel()); if(traverse) { indentation++; storageClass.accept(this); indentation--; } }
    /** */ override void visit(const StructBody structBody) { file.writefln("%sStructBody", indentationLevel()); if(traverse) { indentation++; structBody.accept(this); indentation--; } }
    /** */ override void visit(const StructDeclaration structDeclaration) { file.writefln("%sStructDeclaration", indentationLevel()); if(traverse) { indentation++; structDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const StructInitializer structInitializer) { file.writefln("%sStructInitializer", indentationLevel()); if(traverse) { indentation++; structInitializer.accept(this); indentation--; } }
    /** */ override void visit(const StructMemberInitializer structMemberInitializer) { file.writefln("%sStructMemberInitializer", indentationLevel()); if(traverse) { indentation++; structMemberInitializer.accept(this); indentation--; } }
    /** */ override void visit(const StructMemberInitializers structMemberInitializers) { file.writefln("%sStructMemberInitializers", indentationLevel()); if(traverse) { indentation++; structMemberInitializers.accept(this); indentation--; } }
    /** */ override void visit(const SwitchStatement switchStatement) { file.writefln("%sSwitchStatement", indentationLevel()); if(traverse) { indentation++; switchStatement.accept(this); indentation--; } }
    /** */ override void visit(const Symbol symbol) { file.writefln("%sSymbol", indentationLevel()); if(traverse) { indentation++; symbol.accept(this); indentation--; } }
    /** */ override void visit(const SynchronizedStatement synchronizedStatement) { file.writefln("%sSynchronizedStatement", indentationLevel()); if(traverse) { indentation++; synchronizedStatement.accept(this); indentation--; } }
    /** */ override void visit(const TemplateAliasParameter templateAliasParameter) { file.writefln("%sTemplateAliasParameter", indentationLevel()); if(traverse) { indentation++; templateAliasParameter.accept(this); indentation--; } }
    /** */ override void visit(const TemplateArgument templateArgument) { file.writefln("%sTemplateArgument", indentationLevel()); if(traverse) { indentation++; templateArgument.accept(this); indentation--; } }
    /** */ override void visit(const TemplateArgumentList templateArgumentList) { file.writefln("%sTemplateArgumentList", indentationLevel()); if(traverse) { indentation++; templateArgumentList.accept(this); indentation--; } }
    /** */ override void visit(const TemplateArguments templateArguments) { file.writefln("%sTemplateArguments", indentationLevel()); if(traverse) { indentation++; templateArguments.accept(this); indentation--; } }
    /** */ override void visit(const TemplateDeclaration templateDeclaration) { file.writefln("%sTemplateDeclaration", indentationLevel()); if(traverse) { indentation++; templateDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const TemplateInstance templateInstance) { file.writefln("%sTemplateInstance", indentationLevel()); if(traverse) { indentation++; templateInstance.accept(this); indentation--; } }
    /** */ override void visit(const TemplateMixinExpression templateMixinExpression) { file.writefln("%sTemplateMixinExpression", indentationLevel()); if(traverse) { indentation++; templateMixinExpression.accept(this); indentation--; } }
    /** */ override void visit(const TemplateParameter templateParameter) { file.writefln("%sTemplateParameter", indentationLevel()); if(traverse) { indentation++; templateParameter.accept(this); indentation--; } }
    /** */ override void visit(const TemplateParameterList templateParameterList) { file.writefln("%sTemplateParameterList", indentationLevel()); if(traverse) { indentation++; templateParameterList.accept(this); indentation--; } }
    /** */ override void visit(const TemplateParameters templateParameters) { file.writefln("%sTemplateParameters", indentationLevel()); if(traverse) { indentation++; templateParameters.accept(this); indentation--; } }
    /** */ override void visit(const TemplateSingleArgument templateSingleArgument) { file.writefln("%sTemplateSingleArgument", indentationLevel()); if(traverse) { indentation++; templateSingleArgument.accept(this); indentation--; } }
    /** */ override void visit(const TemplateThisParameter templateThisParameter) { file.writefln("%sTemplateThisParameter", indentationLevel()); if(traverse) { indentation++; templateThisParameter.accept(this); indentation--; } }
    /** */ override void visit(const TemplateTupleParameter templateTupleParameter) { file.writefln("%sTemplateTupleParameter", indentationLevel()); if(traverse) { indentation++; templateTupleParameter.accept(this); indentation--; } }
    /** */ override void visit(const TemplateTypeParameter templateTypeParameter) { file.writefln("%sTemplateTypeParameter", indentationLevel()); if(traverse) { indentation++; templateTypeParameter.accept(this); indentation--; } }
    /** */ override void visit(const TemplateValueParameter templateValueParameter) { file.writefln("%sTemplateValueParameter", indentationLevel()); if(traverse) { indentation++; templateValueParameter.accept(this); indentation--; } }
    /** */ override void visit(const TemplateValueParameterDefault templateValueParameterDefault) { file.writefln("%sTemplateValueParameterDefault", indentationLevel()); if(traverse) { indentation++; templateValueParameterDefault.accept(this); indentation--; } }
    /** */ override void visit(const TernaryExpression ternaryExpression) { file.writefln("%sTernaryExpression", indentationLevel()); if(traverse) { indentation++; ternaryExpression.accept(this); indentation--; } }
    /** */ override void visit(const ThrowStatement throwStatement) { file.writefln("%sThrowStatement", indentationLevel()); if(traverse) { indentation++; throwStatement.accept(this); indentation--; } }
    /** */ override void visit(const Token token) {file.writefln("%sToken: %s", indentationLevel(), token.text); }
    /** */ override void visit(const TraitsExpression traitsExpression) { file.writefln("%sTraitsExpression", indentationLevel()); if(traverse) { indentation++; traitsExpression.accept(this); indentation--; } }
    /** */ override void visit(const TryStatement tryStatement) { file.writefln("%sTryStatement", indentationLevel()); if(traverse) { indentation++; tryStatement.accept(this); indentation--; } }
    /** */ override void visit(const Type type) { file.writefln("%sType", indentationLevel()); if(traverse) { indentation++; type.accept(this); indentation--; } }
    /** */ override void visit(const Type2 type2) { file.writefln("%sType2", indentationLevel()); if(traverse) { indentation++; type2.accept(this); indentation--; } }
    /** */ override void visit(const TypeSpecialization typeSpecialization) { file.writefln("%sTypeSpecialization", indentationLevel()); if(traverse) { indentation++; typeSpecialization.accept(this); indentation--; } }
    /** */ override void visit(const TypeSuffix typeSuffix) { file.writefln("%sTypeSuffix", indentationLevel()); if(traverse) { indentation++; typeSuffix.accept(this); indentation--; } }
    /** */ override void visit(const TypeidExpression typeidExpression) { file.writefln("%sTypeidExpression", indentationLevel()); if(traverse) { indentation++; typeidExpression.accept(this); indentation--; } }
    /** */ override void visit(const TypeofExpression typeofExpression) { file.writefln("%sTypeofExpression", indentationLevel()); if(traverse) { indentation++; typeofExpression.accept(this); indentation--; } }
    /** */ override void visit(const UnaryExpression unaryExpression) { file.writefln("%sUnaryExpression", indentationLevel()); if(traverse) { indentation++; unaryExpression.accept(this); indentation--; } }
    /** */ override void visit(const UnionDeclaration unionDeclaration) { file.writefln("%sUnionDeclaration", indentationLevel()); if(traverse) { indentation++; unionDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const Unittest unittest_) { file.writefln("%sUnittest", indentationLevel()); if(traverse) { indentation++; unittest_.accept(this); indentation--; } }
    /** */ override void visit(const VariableDeclaration variableDeclaration) { file.writefln("%sVariableDeclaration", indentationLevel()); if(traverse) { indentation++; variableDeclaration.accept(this); indentation--; } }
    /** */ override void visit(const Vector vector) { file.writefln("%sVector", indentationLevel()); if(traverse) { indentation++; vector.accept(this); indentation--; } }
    /** */ override void visit(const VersionCondition versionCondition) { file.writefln("%sVersionCondition", indentationLevel()); if(traverse) { indentation++; versionCondition.accept(this); indentation--; } }
    /** */ override void visit(const VersionSpecification versionSpecification) { file.writefln("%sVersionSpecification", indentationLevel()); if(traverse) { indentation++; versionSpecification.accept(this); indentation--; } }
    /** */ override void visit(const WhileStatement whileStatement) { file.writefln("%sWhileStatement", indentationLevel()); if(traverse) { indentation++; whileStatement.accept(this); indentation--; } }
    /** */ override void visit(const WithStatement withStatement) { file.writefln("%sWithStatement", indentationLevel()); if(traverse) { indentation++; withStatement.accept(this); indentation--; } }
    /** */ override void visit(const XorExpression xorExpression) { file.writefln("%sXorExpression", indentationLevel()); if(traverse) { indentation++; xorExpression.accept(this); indentation--; } }
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
		
		auto file = File((fromStringz(sourceFile).replace("/", ".")~".ast").idup, "w");
		
		thread_attachThis();
		
		LexerConfig config;
		config.fileName = fromStringz(sourceFile).idup;
		auto source = cast(ubyte[])fromStringz(sourceData);
		auto tokens = getTokensForParser(source, config, new StringCache(StringCache.defaultBucketCount));
		auto mod = parseModule(tokens, config.fileName);
		//new ASTPrinter(file, true).visit(mod);
		keepAlive[config.fileName] = new CModule(mod);
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
