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

#include "dlangparsejob.h"

#include <language/backgroundparser/urlparselock.h>
#include <language/backgroundparser/parsejob.h>
#include <language/duchain/duchainlock.h>
#include <language/duchain/duchainutils.h>
#include <language/duchain/duchain.h>
#include <language/duchain/parsingenvironment.h>
#include <language/duchain/problem.h>
#include <language/duchain/duchaindumper.h>

#include <QReadLocker>
#include <QProcess>
#include <QDirIterator>

#include "parser/parsesession.h"
#include "duchain/builders/declarationbuilder.h"
#include "duchain/builders/usebuilder.h"
#include "duchain/helper.h"
#include "ddebug.h"

#include "parser/dparser.h"

using namespace KDevelop;

QHash<QString, QString> DParseJob::canonicalImports;

DParseJob::DParseJob(const KDevelop::IndexedString &url, KDevelop::ILanguageSupport *languageSupport) : ParseJob(url, languageSupport)
{
	
}

void DParseJob::run(ThreadWeaver::JobPointer self, ThreadWeaver::Thread *thread)
{
	qCDebug(D) << "DParseJob succesfully created for document " << document();
	
	UrlParseLock urlLock(document());
	if(abortRequested()) //|| !isUpdateRequired(ParseSession::languageString()))
		return;
	
	ProblemPointer p = readContents();
	if(p)
		return abortJob();
	
	QByteArray code = contents().contents;
	while(code.endsWith('\0'))
		code.chop(1);
	
	ParseSession session(code, parsePriority());
	session.setCurrentDocument(document());
	
	if(abortRequested())
		return;
	
	ReferencedTopDUContext context;
	{
		DUChainReadLocker lock;
		context = DUChainUtils::standardContextForUrl(document().toUrl());
	}
	
	TopDUContext::Features newFeatures = minimumFeatures();
	if(context)
	{
		//translateDUChainToRevision(context);
		//context->setRange(RangeInRevision(0, 0, INT_MAX, INT_MAX));
		newFeatures = (TopDUContext::Features)(newFeatures | context->features());
	}
	
	newFeatures = static_cast<TopDUContext::Features>(newFeatures & TopDUContext::AllDeclarationsContextsUsesAndAST);
	
	session.setFeatures(newFeatures);
	
	qCDebug(D) << "Job features: " << newFeatures;
	qCDebug(D) << "Job priority: " << parsePriority();
	
	qCDebug(D) << document();
	auto module = parseSourceFile((char *)document().c_str(), code.data());
	
	//When switching between files(even if they are not modified) KDevelop decides they need to be updated
	//and calls parseJob with VisibleDeclarations feature
	//so for now feature, identifying import will be AllDeclarationsAndContexts, without Uses
	bool forExport = false;
	//if((minimumFeatures() & TopDUContext::AllDeclarationsContextsAndUses) == TopDUContext::AllDeclarationsAndContexts)
	//	forExport = true;
	//qCDebug(D) << contents().contents;
	
	if(!forExport)
		session.setIncludePaths(dlang::Helper::getSearchPaths(document().toUrl()));
	else
		session.setIncludePaths(dlang::Helper::getSearchPaths());
	
	if(canonicalImports.empty())
		parseCanonicalImports();
	session.setCanonicalImports(&canonicalImports);
	
	if(module)
	{
		QReadLocker parseLock(languageSupport()->parseLock());
		
		if(abortRequested())
			return abortJob();
		//qCDebug(D) << QString(contents().contents);
		DeclarationBuilder builder(&session, forExport);
		context = builder.build(document(), module, context);
		
		setDuChain(context);
		
		if(!forExport)
		{
			printf("Building uses-------------\n");
			dlang::UseBuilder useBuilder(&session);
			useBuilder.setContextOnNode(module, context);
			//useBuilder.build(document(), module, context);
			useBuilder.buildUses(module);
			printf("Building uses ended-------------\n");
		}
		//this notifies other opened files of changes
		//session.reparseImporters(context);
	}
	if(!context)
	{
		DUChainWriteLocker lock;
		ParsingEnvironmentFile *file = new ParsingEnvironmentFile(document());
		file->setLanguage(ParseSession::languageString());
		context = new TopDUContext(document(), RangeInRevision(0, 0, INT_MAX, INT_MAX), file);
		DUChain::self()->addDocumentChain(context);
		setDuChain(context);
	}
	
	{
		DUChainWriteLocker lock;
		context->setFeatures(newFeatures);
		ParsingEnvironmentFilePointer file = context->parsingEnvironmentFile();
		Q_ASSERT(file);
		file->setModificationRevision(contents().modification);
		DUChain::self()->updateContextEnvironment(context->topContext(), file.data());
	}
	highlightDUChain();
	
	DUChainDumper dumper;
	dumper.dump(context);
	
	if(module)
		qCDebug(D) << "===Success===" << document().str();
	else
		qCDebug(D) << "===Failed===" << document().str();
}

void DParseJob::parseCanonicalImports()
{
	QList<QString> importPaths = dlang::Helper::getSearchPaths();
	for(const QString &path : importPaths)
	{
		QDirIterator iterator(path, QDir::Dirs | QDir::NoDotAndDotDot, QDirIterator::Subdirectories);
		while(iterator.hasNext())
		{
			iterator.next();
			QDir dir(iterator.filePath());
			for(const QString &file : dir.entryList(QStringList("*.d"), QDir::Files | QDir::NoSymLinks))
			{
				QFile f(dir.filePath(file));
				f.open(QIODevice::ReadOnly);
				QByteArray contents = f.readAll();
				f.close();
				QString canonicalImport = extractCanonicalImport(QString(contents));
				if(canonicalImport.length() != 0)
				{
					qCDebug(D) << "Found canonical import for package " << iterator.filePath() << " import: " << canonicalImport;
					canonicalImports[canonicalImport] = iterator.filePath();
					break;
				}
			}
		}
	}
	//If no canonical imports were found add stab value to map
	//so we won't search for them again.
	if(canonicalImports.empty())
		canonicalImports["<?>"] = QString("none");
}

QString DParseJob::extractCanonicalImport(QString string)
{
	/*int i = 0;
	while(i < string.length())
	{
		if(string[i].isSpace())
			i++;
		else if(string[i] == '/')
		{
			if(i + 1 < string.length() && string[i+1] == '/')
			{
				i += 2;
				while(i<string.length() && string[i] != '\n')
					++i;
				++i;
			}
			else if(i + 1 < string.length() && string[i+1] == '*')
			{
				i += 2;
				while(i+1<string.length() && !(string[i] == '*' && string[i+1] == '/'))
					++i;
				i+=2;
			}
			else if(i + 1 < string.length() && string[i+1] == '+')
			{
				i += 2;
				while(i+1<string.length() && !(string[i] == '+' && string[i+1] == '/'))
					++i;
				i+=2;
			}
			else
				return QString("");
		}
		else if(string[i] == 'm')
		{
			string = string.mid(i);
			//match "module name // or / * import "
			if(string.indexOf(QRegExp("^module\\s*\\w*\\s*(//|/\\*)\\s*import\\s*")) == 0)
			{
				int nameStart = string.indexOf("\"")+1;
				int nameEnd = string.indexOf("\"", nameStart);
				if(nameStart != -1 && nameEnd != -1)
					return string.mid(nameStart, nameEnd - nameStart);
			}
			return QString("");
		}
		else
			return QString("");
	}*/
	return QString("");
}
