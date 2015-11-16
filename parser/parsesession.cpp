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

#include "parsesession.h"

#include <language/duchain/duchain.h>
#include <language/duchain/duchainlock.h>
#include <interfaces/icore.h>
#include <language/backgroundparser/backgroundparser.h>
#include <interfaces/ilanguagecontroller.h>
#include <QProcess>
#include <QUrl>

using namespace KDevelop;

ParseSession::ParseSession(const QByteArray &contents, int priority, bool appendWithNewline) : m_contents(contents), m_priority(priority), m_features(TopDUContext::AllDeclarationsAndContexts)
{
	forExport = false;
}

ParseSession::~ParseSession()
{
	
}

KDevelop::IndexedString ParseSession::languageString()
{
	static const KDevelop::IndexedString langString("d");
	return langString;
}

/*bool ParseSession::parseExpression(dlang::ExpressionAst** node)
{
    if(!lex())
		return false;

    return m_parser->parseExpression(node);
}*/

QString ParseSession::symbol(qint64 index)
{
	/*if(index >= m_lexer->size())
		return QString();
	return QString(m_contents.mid(m_lexer->at(index).begin, m_lexer->at(index).end - m_lexer->at(index).begin+1));*/
	printf("ParseSession::symbol - Not implemented!\n");
	return "";
}

KDevelop::RangeInRevision ParseSession::findRange(INode *from, INode *to)
{
	qint64 line = 1, column = 1, lineEnd = 1, columnEnd = 1;
	//m_lexer->locationTable()->positionAt(m_lexer->at(from->startToken).begin, &line, &column);
	//m_lexer->locationTable()->positionAt(m_lexer->at(to->endToken).end+1, &lineEnd, &columnEnd);
	//Location: Constructor, SharedStaticConstructor, SharedStaticDestructor, StaticConstructor, StaticDestructor.
	//Locations: ArgumentList, AtAttribute, BlockStatement, EnumBody, ModuleDeclaration, StatementNoCaseNoDefault, ReturnStatement, StructBody, TemplateDeclaration.
	//Line/col: AsmBrExp, AssignExpression, DeleteExpression, Constructor, Destructor, IfStatement, LastCatch.
	printf("findRange: from\n");
	switch(from->getKind())
	{
		case Kind::module_:
			printf("kind is module\n");
			break;
		case Kind::moduleDeclaration:
			printf("kind is moduleDeclaration\n");
			break;
		case Kind::functionBody:
		{
			printf("kind is functionBody\n");
			auto f = (IFunctionBody *)from;
			if(f->getBlockStatement())
			{
				auto g = (IBlockStatement *)f->getBlockStatement();
				line = g->startLine();
				column = g->startColumn()+1;
			}
			break;
		}
		case Kind::blockStatement:
		{
			printf("kind is blockStatement\n");
			auto f = (IBlockStatement *)from;
			line = f->startLine();
			column = f->startColumn()+1;
			break;
		}
		case Kind::identifier:
		{
			printf("kind is identifier\n");
			auto f = (IIdentifier *)from;
			line = f->getLine();
			column = f->getColumn();
			break;
		}
		case Kind::parameters:
		{
			printf("kind is parameters\n");
			auto f = (IParameters *)from;
			line = f->startLine();
			column = f->startColumn();
			break;
		}
		case Kind::classDeclaration:
		{
			printf("kind is classDeclaration\n");
			auto f = (IClassDeclaration *)from;
			if(f->getStructBody())
			{
				auto g = (IStructBody *)f->getStructBody();
				line = g->startLine();
				column = g->startColumn()+1;
			}
			break;
		}
		case Kind::structBody:
		{
			printf("kind is structBody\n");
			auto f = (IStructBody *)from;
			line = f->startLine();
			column = f->startColumn()+1;
			break;
		}
		case Kind::type:
		{
			printf("kind is type\n");
			auto f = (IType *)from;
			line = f->getName()->getLine();
			column = f->getName()->getColumn();
			break;
		}
		case Kind::primaryExpression:
		{
			printf("kind is primaryExpression\n");
			auto f = ((IPrimaryExpression *)from)->getIdentifier();
			line = f->getLine();
			column = f->getColumn();
			break;
		}
		case Kind::unaryExpression:
		{
			printf("kind is unaryExpression\n");
			auto f = ((IUnaryExpression *)from)->getIdentifier();
			if(f)
			{
				line = f->getLine();
				column = f->getColumn();
			}
			break;
		}
		default:
			printf("Unhandled from kind: %d\n", from->getKind());
	}
	
	printf("findRange: to\n");
	switch(to->getKind())
	{
		case Kind::module_:
		{
			printf("kind is module\n");
			auto lines = m_contents.split('\n');
			lineEnd = lines.length()+1;
			columnEnd = lines[lines.length()-1].length();
			break;
		}
		case Kind::moduleDeclaration:
		{
			printf("kind is moduleDeclaration\n");
			auto lines = m_contents.split('\n');
			lineEnd = lines.length()+1;
			columnEnd = lines[lines.length()-1].length()+1;
			break;
		}
		case Kind::functionBody:
		{
			printf("kind is functionBody\n");
			auto f = (IFunctionBody *)to;
			if(f->getBlockStatement())
			{
				auto g = (IBlockStatement *)f->getBlockStatement();
				lineEnd = g->endLine();
				columnEnd = g->endColumn()+1;
			}
			break;
		}
		case Kind::blockStatement:
		{
			printf("kind is blockStatement\n");
			auto f = (IBlockStatement *)to;
			lineEnd = f->endLine();
			columnEnd = f->endColumn()+1;
			break;
		}
		case Kind::identifier:
		{
			printf("kind is identifier\n");
			auto f = (IIdentifier *)to;
			lineEnd = f->getLine();
			columnEnd = f->getColumn() + strlen(f->getString());
			break;
		}
		case Kind::parameters:
		{
			printf("kind is parameters\n");
			auto f = (IParameters *)to;
			lineEnd = f->endLine();
			columnEnd = f->endColumn();
			break;
		}
		case Kind::classDeclaration:
		{
			printf("kind is classDeclaration\n");
			auto f = (IClassDeclaration *)to;
			if(f->getStructBody())
			{
				auto g = (IStructBody *)f->getStructBody();
				lineEnd = g->endLine();
				columnEnd = g->endColumn()+1;
			}
			break;
		}
		case Kind::structBody:
		{
			printf("kind is structBody\n");
			auto f = (IStructBody *)to;
			lineEnd = f->endLine();
			columnEnd = f->endColumn()+1;
			break;
		}
		case Kind::type:
		{
			printf("kind is type\n");
			auto f = (IType *)to;
			lineEnd = f->getName()->getLine();
			columnEnd = f->getName()->getColumn() + strlen(f->getName()->getString());
			break;
		}
		case Kind::primaryExpression:
		{
			printf("kind is primaryExpression\n");
			auto f = ((IPrimaryExpression *)to)->getIdentifier();
			lineEnd = f->getLine();
			columnEnd = f->getColumn() + strlen(f->getString());
			break;
		}
		case Kind::unaryExpression:
		{
			printf("kind is unaryExpression\n");
			auto f = ((IUnaryExpression *)to)->getIdentifier();
			if(f)
			{
				line = f->getLine();
				column = f->getColumn() + strlen(f->getString());
			}
			break;
		}
		default:
			printf("Unhandled to kind: %d\n", to->getKind());
	}
	
	printf("lineStart: %lld\n", line);
	printf("columnStart: %lld\n", column);
	printf("lineEnd: %lld\n", lineEnd);
	printf("columnEnd: %lld\n", columnEnd);
	
	line -= 1;
	column -= 1;
	lineEnd -= 1;
	columnEnd -= 1;
	
	//for some reason I need to shift columns when not on a first line
	/*if(line != 0)
		column++;
	if(lineEnd != 0)
		columnEnd++;*/
	
	return KDevelop::RangeInRevision(KDevelop::CursorInRevision(line, column), KDevelop::CursorInRevision(lineEnd, columnEnd));
}

KDevelop::IndexedString ParseSession::currentDocument()
{
	return m_document;
}

void ParseSession::setCurrentDocument(const KDevelop::IndexedString &document)
{
	m_document = document;
}

/**
 * Currently priority order works in this way
 * 	-1: Direct imports of opened file
 * 	 0: opened files
 * 	...
 * 	 99... imports of imports of imports....
 * 	 99998: Imports of direct imports(needed to resolve types of some function)
 * 	 99999: Reparse of direct imports, after its imports are finished
 * 	 100000: reparse of opened file, after all recursive imports
 * layers higher than 99998 are NOT parsed right now because its too slow
 */
QList<ReferencedTopDUContext> ParseSession::contextForImport(QString package)
{
	printf("ParseSession::contextForImport (%s)\n", package.toLocal8Bit().data());
	QStringList files;
	//try canonical paths first
	if(m_canonicalImports && m_canonicalImports->contains(package))
	{
		QDir path((*m_canonicalImports)[package]);
		if(path.exists())
		{
			for(const QString &file : path.entryList(QStringList("*.d"), QDir::Files | QDir::NoSymLinks))
				files.append(path.filePath(file));
		}
	}
	if(files.empty())
	{
		printf("Include paths:\n%s\n", QStringList(m_includePaths).join("\n").toLocal8Bit().data());
		QStringList packages = package.split(".");
		for(const QString &pathname : m_includePaths)
		{
			QDir path(pathname);
			if(path.exists())
			{
				bool canFind = true;
				for(int i=0; i<packages.length()-1; i++)
				{
					if(!path.cd(packages[i]))
					{
						canFind = false;
						break;
					}
				}
				if(packages.length() == 1)
					canFind = path.exists(packages[0]+".d") || path.exists(packages[0]+".di");
				printf("Testing: %s^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ %d\n", path.absoluteFilePath(packages[packages.length()-1]+".d").toLocal8Bit().data(), canFind);
				if(canFind)
				{
					//for(const QString& file : path.entryList(QStringList("*.d"), QDir::Files | QDir::NoSymLinks))
					//	files.append(path.filePath(file));
					if(path.exists(packages[packages.length()-1]+".d"))
					{
						files.append(path.filePath(packages[packages.length()-1]+".d"));
						printf("Added path: %s\n", path.filePath(packages[packages.length()-1]+".d").toLocal8Bit().data());
					}
					else if(path.exists(packages[packages.length()-1]+".di"))
						files.append(path.filePath(packages[packages.length()-1]+".di"));
					break;
				}
			}
		}
	}
	QList<ReferencedTopDUContext> contexts;
	bool shouldReparse = false;
	//reduce priority if it is recursive import
	//int priority = forExport ? m_priority + 2 : m_priority - 1;
	int priority = BackgroundParser::WorstPriority;
	if(!forExport)
		priority = -1; //parse direct imports as soon as possible
	else if(m_priority <= -1)
		priority = BackgroundParser::WorstPriority-2; //imports of direct imports to the stack bottom
	else
		priority = m_priority - 2; //currently parsejob does not get created in this cases to reduce recursion
	for(QString filename : files)
	{
		QFile file(filename);
		if(!file.exists())
			continue;
		//test files are not part of binary package, so we can exclude them
		//we parse test files only if we open them in KDevelop
		if(filename.endsWith("_test.go"))
			continue;
		
		IndexedString url(filename);
		DUChainReadLocker lock;
		ReferencedTopDUContext context = KDevelop::DUChain::self()->chainForDocument(url);
		lock.unlock();
		if(context)
			contexts.append(context);
		else
		{
			if(scheduleForParsing(url, priority, (TopDUContext::Features)(TopDUContext::ForceUpdate | TopDUContext::AllDeclarationsAndContexts)))
				shouldReparse = true;
		}
	}
	if(shouldReparse)
		//reparse this file after its imports are done
		scheduleForParsing(m_document, priority+1, (TopDUContext::Features)(m_features | TopDUContext::ForceUpdate));
	
	if(!forExport && m_priority != BackgroundParser::WorstPriority)//always schedule last reparse after all recursive imports are done
		scheduleForParsing(m_document, BackgroundParser::WorstPriority, (TopDUContext::Features)(m_features | TopDUContext::ForceUpdate));
	return contexts;
}

bool ParseSession::scheduleForParsing(const IndexedString &url, int priority, TopDUContext::Features features)
{
	printf("ParseSession::scheduleForParsing\n");
	BackgroundParser *bgparser = KDevelop::ICore::self()->languageController()->backgroundParser();
	//TopDUContext::Features features = (TopDUContext::Features)(TopDUContext::ForceUpdate | TopDUContext::VisibleDeclarationsAndContexts);//(TopDUContext::Features)
	//(TopDUContext::ForceUpdate | TopDUContext::AllDeclarationsContextsAndUses);
	
	//currently recursive imports work really slow, nor they usually needed
	//so disallow recursive imports
	int levels=1; //allowed levels of recursion
	if(forExport && priority >= BackgroundParser::InitialParsePriority && priority < BackgroundParser::WorstPriority - 2*levels)
		return false;
	
	if(bgparser->isQueued(url))
	{
		if(bgparser->priorityForDocument(url) > priority)
			//Remove the document and re-queue it with a greater priority
			bgparser->removeDocument(url);
		else
			return true;
	}
	bgparser->addDocument(url, features, priority, 0, ParseJob::FullSequentialProcessing);
	return true;
}

/**
 * Reparse files that import current context.
 * Only works for opened files, so another opened files get notified of changed context.
 */
void ParseSession::reparseImporters(DUContext *context)
{
	printf("ParseSession::reparseImporters\n");
	DUChainReadLocker lock;
	
	if(forExport || m_priority!=0)
		return;
	for(DUContext *importer : context->importers())
		scheduleForParsing(importer->url(), BackgroundParser::WorstPriority, (TopDUContext::Features)(importer->topContext()->features() | TopDUContext::ForceUpdate));
}

QList< ReferencedTopDUContext > ParseSession::contextForThisPackage(IndexedString package)
{
	printf("ParseSession::contextForThisPackage\n");
	QList<ReferencedTopDUContext> contexts;
	QUrl url = package.toUrl();
	QDir path(url.adjusted(QUrl::RemoveFilename).path());
	if(path.exists())
	{
		int priority = BackgroundParser::WorstPriority;
		if(!forExport)
			priority = -1; //Import this package as soon as possible.
		else if(m_priority<=-1)
			priority = BackgroundParser::WorstPriority-2; //All needed files should be scheduled already.
		else
			priority = m_priority; //Currently parsejob does not get created in this cases to reduce recursion.
		QStringList files = path.entryList(QStringList("*.d"), QDir::Files | QDir::NoSymLinks);
		bool shouldReparse = false;
		for(QString filename : files)
		{
			filename = path.filePath(filename);
			QFile file(filename);
			if(!file.exists())
				continue;
			if(forExport && filename.endsWith("_test.d"))
				continue;
			
			IndexedString url(filename);
			DUChainReadLocker lock;
			ReferencedTopDUContext context = DUChain::self()->chainForDocument(url);
			lock.unlock();
			if(context)
				contexts.append(context);
			else
			{
				if(scheduleForParsing(url, priority, (TopDUContext::Features)(TopDUContext::ForceUpdate | TopDUContext::AllDeclarationsAndContexts)))
					shouldReparse=true;
			}
			
		}
		if(shouldReparse)
			scheduleForParsing(m_document, priority+1, (TopDUContext::Features)(m_features | TopDUContext::ForceUpdate));
	}
	return contexts;
}

void ParseSession::setFeatures(TopDUContext::Features features)
{
	printf("ParseSession::setFeatures\n");
	m_features = features;
	if((m_features & TopDUContext::AllDeclarationsContextsAndUses) == TopDUContext::AllDeclarationsAndContexts)
		forExport = true;
}

QString ParseSession::textForNode(INode *node)
{
	//return QString(m_contents.mid(m_lexer->at(node->startToken).begin, m_lexer->at(node->endToken).end - m_lexer->at(node->startToken).begin+1));
	printf("ParseSession::textForNode - Not implemented!\n");
	return "";
}

void ParseSession::setIncludePaths(const QList<QString> &paths)
{
	m_includePaths = paths;
}

QByteArray ParseSession::commentBeforeToken(qint64 token)
{
	printf("ParseSession::commentBeforeToken\n");
	int commentEnd = 0;//m_lexer->at(token).begin;
	int commentStart = 0;
	if(token - 1 >= 0)
		commentStart = 0;//m_lexer->at(token-1).end+1;
	QString comment = m_contents.mid(commentStart, commentEnd-commentStart);
	
	//in lexer, when we insert semicolons after newline
	//inserted token's end contains '\n' position
	//so in order not to lose this newline we prepend it
	if(commentStart > 0 && m_contents[commentStart-1] == '\n')
		comment.prepend('\n');
	
	//any comment must have at least single '/'
	if(comment.indexOf('/') == -1)
		return QByteArray();
	int i = 0;
	int start=-1, end=-1, lineStart=-1, lineEnd=-1;
	int currentLine = 0;
	//this flag is true when multiple single-lined comments have been encountered in a row
	bool contigiousComments = false;
	while(i < comment.length())
	{
		if(comment[i] == '\n')
		{
			contigiousComments = false;
			currentLine++;
			i++;
		}
		else if(comment[i].isSpace())
			i++;
		else if(comment[i] == '/')
		{
			if(i + 1 < comment.length() && comment[i+1] == '/')
			{
				if(!contigiousComments)
				{
					start = i+2;
					lineStart = currentLine;
					contigiousComments = true;
				}
				i += 2;
				while(i<comment.length() && comment[i] != '\n')
					++i;
				end = i;
				lineEnd = currentLine;
				currentLine++;
				++i;
				//if comment does not start at first line in a file but it is a first line in comment
				//then this comment is not a documentation
				if(commentStart!= 0 && lineStart == 0)
				{
					start = -1;
					end = -1, lineStart = -1;
					lineEnd = -1;
					contigiousComments = false;
				}
			}
			else if(i + 1 < comment.length() && comment[i+1] == '*')
			{
				start = i+2;
				lineStart = currentLine;
				contigiousComments = false;
				i += 2;
				while(i+1<comment.length() && !(comment[i] == '*' && comment[i+1] == '/'))
				{
					if(comment[i] == '\n')
						currentLine++;
					++i;
				}
				end = i-1;
				lineEnd = currentLine;
				i += 2;
				if(commentStart!= 0 && lineStart == 0)
				{
					start = -1;
					end = -1, lineStart = -1;
					lineEnd = -1;
					contigiousComments = false;
				}
			}
			else //This shouldn't happen.
				return QByteArray();
		}
		else
			return QByteArray();
	}
	if(start != -1 && end != -1 && lineStart  != -1 && lineEnd != -1 && lineEnd == currentLine - 1)
		return comment.mid(start, end-start+1).replace(QRegExp("\n\\s*//"), "\n").toUtf8();
	return QByteArray();
}

void ParseSession::setCanonicalImports(QHash<QString, QString> *imports)
{
	m_canonicalImports = imports;
}
