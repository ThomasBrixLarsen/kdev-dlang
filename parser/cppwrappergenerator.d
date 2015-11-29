module cppwrappergenerator;

import std.stdio;
import std.uni;

import dparse.lexer;
import dparse.parser;
import dparse.ast;

private enum keywords = [
    "abstract", "alias", "align", "asm", "assert", "auto", "body", "bool",
    "break", "byte", "case", "cast", "catch", "cdouble", "cent", "cfloat",
    "char", "class", "const", "continue", "creal", "dchar", "debug", "default",
    "delegate", "delete", "deprecated", "do", "double", "else", "enum",
    "export", "extern", "false", "final", "finally", "float", "for", "foreach",
    "foreach_reverse", "function", "goto", "idouble", "if", "ifloat",
    "immutable", "import", "in", "inout", "int", "interface", "invariant",
    "ireal", "is", "lazy", "long", "macro", "mixin", "module", "new", "nothrow",
    "null", "out", "override", "package", "pragma", "private", "protected",
    "public", "pure", "real", "ref", "register", "return", "scope", "shared", "short",
    "static", "struct", "super", "switch", "synchronized", "template", "this",
    "throw", "true", "try", "typedef", "typeid", "typeof", "ubyte", "ucent",
    "uint", "ulong", "union", "unittest", "ushort", "version", "void",
    "volatile", "wchar", "while", "with", "__DATE__", "__EOF__", "__FILE__",
    "__FUNCTION__", "__gshared", "__LINE__", "__MODULE__", "__parameters",
    "__PRETTY_FUNCTION__", "__TIME__", "__TIMESTAMP__", "__traits", "__vector",
    "__VENDOR__", "__VERSION__"
];

struct ClassVariable
{
	string type, name, args;
	bool isArray;
}

struct Class
{
	string name;
	bool isExpression;
}

ClassVariable[][Class] classes;

string escapeName(string name)
{
	import std.algorithm;
	return keywords.canFind(name)? name ~ "_" : name;
}

string escapeAndLowerName(string name)
{
	return escapeName(format("%s%s", name[0].toLower(), name[1..$]));
}

string getString(const Token token)
{
	return token.text;
}

string getString(const IdentifierOrTemplateChain identifierOrTemplateChain)
{
	string str;
	foreach(i,instance; identifierOrTemplateChain.identifiersOrTemplateInstances)
	{
		str ~= getString(instance.identifier);
		if(i+1 < identifierOrTemplateChain.identifiersOrTemplateInstances.length)
			str ~= ".";
	}
	return str;
}

string getString(const Symbol symbol)
{
	auto str = getString(symbol.identifierOrTemplateChain);
	if(symbol.dot)
		str = format(".%s", str);
	return str;
}

void main(string[] args)
{
	import std.string;
	LexerConfig config;
	config.fileName = args[1];
	
	auto file = File(args[1], "r");
	auto source = new ubyte[](file.size());
	file.rawRead(source);
	auto tokens = getTokensForParser(source, config, new StringCache(StringCache.defaultBucketCount));
	auto mod = parseModule(tokens, config.fileName);
	
	foreach(declaration; mod.declarations)
	{
		if(!declaration.classDeclaration)
			continue;
		Class classType;
		classType.name = declaration.classDeclaration.name.text;
		if(declaration.classDeclaration.baseClassList)
		{
			foreach(baseClass; declaration.classDeclaration.baseClassList.items)
			{
				if(getString(baseClass.type2.symbol) == "ExpressionNode")
					classType.isExpression = true;
			}
		}
		foreach(innerDeclaration; declaration.classDeclaration.structBody.declarations)
		{
			ClassVariable cv;
			if(innerDeclaration.mixinDeclaration && innerDeclaration.mixinDeclaration.templateMixinExpression && innerDeclaration.mixinDeclaration.templateMixinExpression.mixinTemplateName)
			{
				auto mixinSymbol = innerDeclaration.mixinDeclaration.templateMixinExpression.mixinTemplateName.symbol;
				if(mixinSymbol && getString(mixinSymbol) == "BinaryExpressionBody")
				{
					cv.type = "ExpressionNode";
					cv.name = "left";
					classes[classType] ~= cv;
					cv.name = "right";
					classes[classType] ~= cv;
					cv.type = "size_t";
					cv.name = "line";
					classes[classType] ~= cv;
					cv.name = "column";
					classes[classType] ~= cv;
				}
			}
			if(!innerDeclaration.variableDeclaration)
				continue;
			auto var = innerDeclaration.variableDeclaration;
			if(auto symbol = var.type.type2.symbol)
				cv.type = getString(var.type.type2.symbol);
			else if(auto chain = var.type.type2.identifierOrTemplateChain)
				cv.type = getString(var.type.type2.symbol);
			else
				cv.type = str(var.type.type2.builtinType);
			foreach(suffix; var.type.typeSuffixes)
			{
				if(suffix.array)
					cv.isArray = true;
			}
			
			foreach(declarator; var.declarators)
			{
				cv.name = declarator.name.text;
				classes[classType] ~= cv;
			}
		}
	}
	
	//Add mixed in variables from Declaration.
	{
		Class newClassType;
		newClassType.name = "Declaration";
		ClassVariable cv;
		cv.type = "AliasDeclaration";
		cv.name = "aliasDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "AliasThisDeclaration";
		cv.name = "aliasThisDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "AnonymousEnumDeclaration";
		cv.name = "anonymousEnumDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "AttributeDeclaration";
		cv.name = "attributeDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "ClassDeclaration";
		cv.name = "classDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "ConditionalDeclaration";
		cv.name = "conditionalDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "Constructor";
		cv.name = "constructor";
		classes[newClassType] ~= cv;
		cv.type = "DebugSpecification";
		cv.name = "debugSpecification";
		classes[newClassType] ~= cv;
		cv.type = "Destructor";
		cv.name = "destructor";
		classes[newClassType] ~= cv;
		cv.type = "EnumDeclaration";
		cv.name = "enumDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "EponymousTemplateDeclaration";
		cv.name = "eponymousTemplateDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "FunctionDeclaration";
		cv.name = "functionDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "ImportDeclaration";
		cv.name = "importDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "InterfaceDeclaration";
		cv.name = "interfaceDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "Invariant";
		cv.name = "invariant_";
		classes[newClassType] ~= cv;
		cv.type = "MixinDeclaration";
		cv.name = "mixinDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "MixinTemplateDeclaration";
		cv.name = "mixinTemplateDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "Postblit";
		cv.name = "postblit";
		classes[newClassType] ~= cv;
		cv.type = "PragmaDeclaration";
		cv.name = "pragmaDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "SharedStaticConstructor";
		cv.name = "sharedStaticConstructor";
		classes[newClassType] ~= cv;
		cv.type = "SharedStaticDestructor";
		cv.name = "sharedStaticDestructor";
		classes[newClassType] ~= cv;
		cv.type = "StaticAssertDeclaration";
		cv.name = "staticAssertDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "StaticConstructor";
		cv.name = "staticConstructor";
		classes[newClassType] ~= cv;
		cv.type = "StaticDestructor";
		cv.name = "staticDestructor";
		classes[newClassType] ~= cv;
		cv.type = "StructDeclaration";
		cv.name = "structDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "TemplateDeclaration";
		cv.name = "templateDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "UnionDeclaration";
		cv.name = "unionDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "Unittest";
		cv.name = "unittest_";
		classes[newClassType] ~= cv;
		cv.type = "VariableDeclaration";
		cv.name = "variableDeclaration";
		classes[newClassType] ~= cv;
		cv.type = "VersionSpecification";
		cv.name = "versionSpecification";
		classes[newClassType] ~= cv;
	}
	
	//Add expressionNode.
	{
		Class newClassType;
		newClassType.name = "ExpressionNode";
		foreach(classType,declarations; classes)
		{
			if(!classType.isExpression)
				continue;
			ClassVariable cv;
			cv.type = classType.name;
			cv.name = escapeAndLowerName(classType.name);
			classes[newClassType] ~= cv;
		}
	}
	
	//Add token.
	{
		Class newClassType;
		newClassType.name = "Token";
		ClassVariable cv;
		cv.type = "string";
		cv.name = "text";
		classes[newClassType] ~= cv;
		cv.type = "size_t";
		cv.name = "line";
		classes[newClassType] ~= cv;
		cv.type = "size_t";
		cv.name = "column";
		classes[newClassType] ~= cv;
	}
	
	if(args.length > 2 && args[2] == "-h")
	{
		writefln("#pragma once");
		writefln("");
		
		writefln("#include <kdemacros.h>");
		writefln("");
		
		//Forward declarations.
		foreach(classType,declarations; classes)
			writefln("class I%s;", classType.name);
		writefln("");
		
		//Functions.
		writefln("KDE_EXPORT void initDParser();");
		writefln("KDE_EXPORT void deinitDParser();");
		writefln("");

		writefln("KDE_EXPORT IModule *parseSourceFile(char *sourceFile, char *sourceData);");
		writefln("");
		
		//Kind enum.
		writefln("enum class Kind");
		writefln("{");
		foreach(classType,declarations; classes)
			writefln("\t%s,", escapeAndLowerName(classType.name));
		writefln("};");
		writefln("");
		
		//INode.
		writefln("class KDE_EXPORT INode");
		writefln("{");
		writefln("public: //Methods.");
		writefln("	virtual Kind getKind();");
		writefln("	virtual void *getContext();");
		writefln("	virtual void setContext(void *context);");
		writefln("\t");
		writefln("protected: //Methods.");
		writefln("	~INode() {}");
		writefln("};");
		writefln("");
		
		//Interfaces.
		foreach(classType,declarations; classes)
		{
			writefln("class KDE_EXPORT I%s : public INode", classType.name);
			writefln("{");
			writefln("public: //Methods.");
			foreach(declaration; declarations)
			{
				if(declaration.type == "")
				{
					writefln("\t//Skipping %s.", declaration.name);
					continue;
				}
				string type = declaration.type == "IdType"? "string" : (declaration.type[0].isUpper()? "I"~declaration.type : declaration.type);
				if(declaration.isArray)
				{
					writefln("\tvirtual size_t num%s%s();", declaration.name[0].toUpper(), declaration.name[1..$].replace("_", ""));
					string name = format("%s%s", declaration.name[0].toUpper(), declaration.name[1..$].replace("_", ""));
					if(name.endsWith("ses"))
						name = name[0..$-3];
					else if(name.endsWith("xes"))
						name = name[0..$-2];
					else if(name.endsWith("s"))
						name = name[0..$-1];
					writefln("\tvirtual %s %sget%s(size_t index);", type == "string"? "const char" : type, declaration.type[0].isUpper() || type == "string"? "*" : "", name);
				}
				else
					writefln("\tvirtual %s %sget%s%s(%s);", type == "string"? "const char" : type, declaration.type[0].isUpper() || type == "string"? "*" : "", declaration.name[0].toUpper(), declaration.name[1..$].replace("_", ""), declaration.args);
			}
			writefln("\t");
			writefln("protected: //Methods.");
			writefln("	~I%s() {}", classType.name);
			writefln("};");
			writefln("");
		}
		return;
	}
	
	writefln("module astWrapper;");
	writefln("");
	writefln("import std.string;");
	writefln("");
	writefln("import dparse.lexer;");
	writefln("import dparse.parser;");
	writefln("import dparse.ast;");
	writefln("");
	
	writefln("template ContextMethods()");
	writefln("{");
	writefln("	extern(C++) void* getContext()");
	writefln("	{");
	writefln("		return context;");
	writefln("	}");
	writefln("	extern(C++) void setContext(void* context)");
	writefln("	{");
	writefln("		this.context = context;");
	writefln("	}");
	writefln("	__gshared void* context;");
	writefln("}");
	writefln("");
	
	//Kind enum.
	writefln("enum Kind");
	writefln("{");
	foreach(classType,declarations; classes)
		writefln("\t%s,", escapeAndLowerName(classType.name));
	writefln("}");
	writefln("");
	
	//INode.
	writefln("extern(C++) interface INode");
	writefln("{");
	writefln("	Kind getKind();");
	writefln("	void* getContext();");
	writefln("	void setContext(void* context);");
	writefln("}");
	writefln("");
	
	//Interfaces.
	foreach(classType,declarations; classes)
	{
		writefln("extern(C++) interface I%s : INode", classType.name);
		writefln("{");
		foreach(declaration; declarations)
		{
			if(declaration.type == "")
			{
				writefln("\t//Skipping %s.", declaration.name);
				continue;
			}
			string type = declaration.type == "IdType"? "string" : (declaration.type[0].isUpper()? "I"~declaration.type : declaration.type);
			if(declaration.isArray)
			{
				writefln("\tsize_t num%s%s();", declaration.name[0].toUpper(), declaration.name[1..$].replace("_", ""));
				string name = format("%s%s", declaration.name[0].toUpper(), declaration.name[1..$].replace("_", ""));
				if(name.endsWith("ses"))
					name = name[0..$-3];
				else if(name.endsWith("xes"))
					name = name[0..$-2];
				else if(name.endsWith("s"))
					name = name[0..$-1];
				writefln("\t%s get%s(size_t index);", type == "string"? "const(char)*" : type, name);
			}
			else
				writefln("\t%s get%s%s(%s);", type == "string"? "const(char)*" : type, declaration.name[0].toUpper(), declaration.name[1..$].replace("_", ""), declaration.args);
		}
		writefln("}");
		writefln("");
	}
	
	//Classes.
	foreach(classType,declarations; classes)
	{
		writefln("class C%s : I%s", classType.name, classType.name);
		writefln("{");
		writefln("public: //Methods.");
		writefln("\tthis(const %s dclass)", classType.name);
		writefln("\t{");
		writefln("\t\tthis.dclass = dclass;");
		writefln("\t}");
		writefln("\t");
		writefln("\textern(C++) Kind getKind()");
		writefln("\t{");
		writefln("\t\treturn Kind.%s;", escapeAndLowerName(classType.name));
		writefln("\t}");
		writefln("\t");
		writefln("\tmixin ContextMethods;");
		foreach(declaration; declarations)
		{
			if(declaration.type == "")
			{
				writefln("\t//Skipping %s.", declaration.name);
				continue;
			}
			writefln("\t");
			string type = declaration.type == "IdType"? "string" : (declaration.type[0].isUpper()? "I"~declaration.type : declaration.type);
			if(declaration.isArray)
			{
				writefln("\textern(C++) size_t num%s%s()", declaration.name[0].toUpper(), declaration.name[1..$].replace("_", ""));
				writefln("\t{");
				writefln("\t\tif(!dclass.%s)", escapeName(declaration.name));
				writefln("\t\t\treturn 0;");
				writefln("\t\treturn dclass.%s.length;", declaration.name);
				writefln("\t}");
				string name = format("%s%s", declaration.name[0].toUpper(), declaration.name[1..$].replace("_", ""));
				if(name.endsWith("ses"))
					name = name[0..$-3];
				else if(name.endsWith("xes"))
					name = name[0..$-2];
				else if(name.endsWith("s"))
					name = name[0..$-1];
				writefln("\textern(C++) %s get%s(size_t index)", type == "string"? "const(char)*" : type, name);
			}
			else
				writefln("\textern(C++) %s get%s%s(%s)", type == "string"? "const(char)*" : type, declaration.name[0].toUpper(), declaration.name[1..$].replace("_", ""), declaration.args);
			writefln("\t{");
			string typePostfix = declaration.isArray? "[index]" : "";
			if(classType.name == "ExpressionNode")
			{
				writefln("\t\tif(!%s && cast(%s)dclass)", escapeName(declaration.name), declaration.type);
				writefln("\t\t\t%s = new C%s(cast(%s)dclass);", escapeName(declaration.name), declaration.type, declaration.type);
			}
			else
			{
				if(declaration.isArray)
					writefln("\t\tif(index !in %s)", escapeName(declaration.name));
				else
					writefln("\t\tif(!%s%s)", escapeName(declaration.name), declaration.type == "Token" || declaration.type == "string"? "" : format(" && dclass.%s", declaration.name));
				if(declaration.type == "IdType")
					writefln("\t\t\t%s%s = toStringz(str(dclass.%s%s));", escapeName(declaration.name), typePostfix, declaration.name, typePostfix);
				else if(declaration.type[0].isUpper())
					writefln("\t\t\t%s%s = new C%s(dclass.%s%s);", escapeName(declaration.name), typePostfix, declaration.type, declaration.name, typePostfix);
				else if(type == "string")
					writefln("\t\t\t%s%s = toStringz(dclass.%s%s);", escapeName(declaration.name), typePostfix, declaration.name, typePostfix);
				else
					writefln("\t\t\t%s%s = dclass.%s%s;", escapeName(declaration.name), typePostfix, declaration.name, typePostfix);
			}
			writefln("\t\treturn %s%s;", escapeName(declaration.name), typePostfix);
			writefln("\t}");
		}
		writefln("");
		writefln("private: //Variables.");
		writefln("\tconst %s dclass;", classType.name);
		foreach(declaration; declarations)
		{
			if(declaration.type == "")
			{
				writefln("\t//Skipping %s.", declaration.name);
				continue;
			}
			string typePostfix = declaration.isArray? "[size_t]" : "";
			if(declaration.type == "IdType")
				writefln("\tconst(char)*%s %s;", typePostfix, escapeName(declaration.name));
			else if(declaration.type[0].isUpper())
				writefln("\tI%s%s %s;", declaration.type, typePostfix, escapeName(declaration.name));
			else
				writefln("\t%s%s %s;", declaration.type == "string"? "const(char)*" : declaration.type, typePostfix, escapeName(declaration.name));
		}
		writefln("}");
		writefln("");
	}
}
