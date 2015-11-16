#pragma once

#include <kdemacros.h>

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
};

class IDeclaration;
class IExpressionNode;

class KDE_EXPORT INode
{
public:
	virtual Kind getKind();
};

class KDE_EXPORT IIdentifier : public INode
{
public:
	virtual char *getString();
	virtual ulong getLine();
	virtual ulong getColumn();
};

class KDE_EXPORT IType : public INode
{
public:
	virtual IIdentifier *getName();
	virtual bool isArray();
	virtual bool isPointer();
};

class KDE_EXPORT IModuleDeclaration : public INode
{
public:
	virtual IIdentifier *getName();
	virtual ulong getStart();
	virtual ulong getEnd();
	virtual IIdentifier *getComment();
};

class KDE_EXPORT IModule : public INode
{
public:
	virtual IModuleDeclaration *getModuleDeclaration();
	virtual ulong numDeclarations();
	virtual IDeclaration *getDeclaration(int i);
};

class KDE_EXPORT IDeclarationsAndStatements : public INode
{
public:
	virtual ulong numDeclarationOrStatements();
	virtual INode *getDeclarationOrStatement(int i);
};

class KDE_EXPORT IInitializer : public INode
{
public:
	virtual IExpressionNode *getAssignedExpression();
};

class KDE_EXPORT IDeclarator : public INode
{
public:
	virtual IIdentifier *getName();
	virtual IIdentifier *getComment();
	virtual IInitializer *getInitializer();
};

class KDE_EXPORT IBlockStatement : public INode
{
public:
	virtual IDeclarationsAndStatements *getDeclarationsAndStatements();
	virtual ulong getStart();
	virtual ulong getEnd();
	virtual ulong startLine();
	virtual ulong startColumn();
	virtual ulong endLine();
	virtual ulong endColumn();
};

class KDE_EXPORT IFunctionBody : public INode
{
public:
	virtual IBlockStatement *getBlockStatement();
};

class KDE_EXPORT IParameter : public INode
{
public:
	virtual IIdentifier *getName();
	virtual IType *getType();
};

class KDE_EXPORT IParameters : public INode
{
public:
	virtual ulong startLine();
	virtual ulong startColumn();
	virtual ulong endLine();
	virtual ulong endColumn();
	virtual ulong getNumParameters();
	virtual IParameter *getParameter(int i);
	virtual bool hasVarargs();
};

class KDE_EXPORT IFunctionDeclaration : public INode
{
public:
	virtual IIdentifier *getName();
	virtual IParameters *getParameters();
	virtual IFunctionBody *getFunctionBody();
	virtual IType *getReturnType();
	virtual IIdentifier *getComment();
};

class KDE_EXPORT IStructBody : public INode
{
public:
	virtual ulong numDeclarations();
	virtual IDeclaration *getDeclaration(int i);
	virtual ulong startLine();
	virtual ulong startColumn();
	virtual ulong endLine();
	virtual ulong endColumn();
};

class KDE_EXPORT IClassDeclaration : public INode
{
public:
	virtual IIdentifier *getName();
	virtual IStructBody *getStructBody();
	virtual IIdentifier *getComment();
};

class KDE_EXPORT IStructDeclaration : public INode
{
public:
	virtual IIdentifier *getName();
	virtual IStructBody *getStructBody();
	virtual IIdentifier *getComment();
};

class KDE_EXPORT IVariableDeclaration : public INode
{
public:
	virtual IType *getType();
	virtual ulong numDeclarators();
	virtual IDeclarator *getDeclarator(int i);
	virtual IIdentifier *getComment();
};

class KDE_EXPORT ISingleImport : public INode
{
public:
	virtual IIdentifier *getRename();
	virtual IIdentifier *getModuleName();
};

class KDE_EXPORT IImportDeclaration : public INode
{
public:
	virtual ulong numImports();
	virtual ISingleImport *getImport(int i);
};

class KDE_EXPORT IDeclaration : public INode
{
public:
	virtual IClassDeclaration *getClassDeclaration();
	virtual IFunctionDeclaration *getFunctionDeclaration();
	virtual IImportDeclaration *getImportDeclaration();
	virtual IStructDeclaration *getStructDeclaration();
	virtual IVariableDeclaration *getVariableDeclaration();
};

class KDE_EXPORT IAddExpression : public INode
{
public:
	virtual IExpressionNode *getLeft();
	virtual IExpressionNode *getRight();
};

class KDE_EXPORT IPrimaryExpression : public INode
{
public:
	virtual IIdentifier *getIdentifier();
};

class KDE_EXPORT IAssignExpression : public INode
{
public:
	virtual IExpressionNode *getAssignedExpression();
	virtual IExpressionNode *getTernaryExpression();
};

class IUnaryExpression;

class KDE_EXPORT IFunctionCallExpression : public INode
{
public:
	virtual IType *getType();
	virtual IUnaryExpression *getUnaryExpression();
};

class KDE_EXPORT IExpressionNode : public INode
{
public:
	virtual IPrimaryExpression *getPrimaryExpression();
	virtual IAddExpression *getAddExpression();
	virtual IAssignExpression *getAssignExpression();
	virtual IFunctionCallExpression *getFunctionCallExpression();
	virtual IUnaryExpression *getUnaryExpression();
};

class KDE_EXPORT IExpressionStatement : public INode
{
public:
	virtual ulong numItems();
	virtual IExpressionNode *getItem(int i);
};

class KDE_EXPORT IStatementNoCaseNoDefault : public INode
{
public:
	virtual IExpressionStatement *getExpressionStatement();
};

class KDE_EXPORT IStatement : public INode
{
public:
	virtual IStatementNoCaseNoDefault *getStatementNoCaseNoDefault();
};

class KDE_EXPORT IUnaryExpression : public INode
{
public:
	virtual IPrimaryExpression *getPrimaryExpression();
	virtual IIdentifier *getIdentifier();
	virtual IUnaryExpression *getUnaryExpression();
	virtual IFunctionCallExpression *getFunctionCallExpression();
};

KDE_EXPORT void initDParser();
KDE_EXPORT void deinitDParser();

KDE_EXPORT IModule *parseSourceFile(char *sourceFile, char *sourceData);
