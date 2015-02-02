#ifndef DPARSER_H
#define DPARSER_H

#include <kdemacros.h>

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
};

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
	virtual INode *getDeclaration(int i);
};

class KDE_EXPORT IDeclarationsAndStatements : public INode
{
public:
	virtual ulong numDeclarationOrStatements();
	virtual INode *getDeclarationOrStatement(int i);
};

class KDE_EXPORT IDeclarator : public INode
{
public:
	virtual IIdentifier *getName();
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

class KDE_EXPORT IDeclaration : public INode
{
public:
	virtual IVariableDeclaration *getVariableDeclaration();
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

KDE_EXPORT void initDParser();
KDE_EXPORT void deinitDParser();

KDE_EXPORT IModule *parseSourceFile(char *sourceFile, char* sourceData);

#endif
