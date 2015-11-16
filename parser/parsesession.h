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

#pragma once

#include <language/editor/rangeinrevision.h>
#include <language/duchain/topducontext.h>
#include <serialization/indexedstring.h>

#include <kdemacros.h>

#include "parser/dparser.h"

typedef QPair<KDevelop::DUContextPointer, KDevelop::RangeInRevision> SimpleUse;

class KDE_EXPORT ParseSession
{
public:
	ParseSession(const QByteArray &contents, int priority, bool appendWithNewline=true);
	
	virtual ~ParseSession();
	
	static KDevelop::IndexedString languageString();
	
	//bool startParsing();
	
	//bool parseExpression(dlang::ExpressionAst **node);
	
	//dlang::StartAst* ast();
	
	QString symbol(qint64 index);
	
	KDevelop::RangeInRevision findRange(INode *from, INode *to);
	
	KDevelop::IndexedString currentDocument();
	
	void setCurrentDocument(const KDevelop::IndexedString &document);
	
	KDevelop::IndexedString url();
	
	QList<KDevelop::ReferencedTopDUContext> contextForImport(QString package);
	
	QList<KDevelop::ReferencedTopDUContext> contextForThisPackage(KDevelop::IndexedString package);
	
	bool scheduleForParsing(const KDevelop::IndexedString &url, int priority, KDevelop::TopDUContext::Features features);
	
	void reparseImporters(KDevelop::DUContext *context);
	
	void setFeatures(KDevelop::TopDUContext::Features features);
	
	QString textForNode(INode *node);
	
	void setIncludePaths(const QList<QString> &paths);
	
	void setCanonicalImports(QHash<QString, QString> *imports);
	
	/**
	 * Returns doc comment preceding given token.
	 * GoDoc comments are multilined / *-style comments
	 * or several consecutive single-lined //-style comments
	 * with no empty line between them.
	 * Comment must start on a new line and end a line before given declaration.
	 **/
	QByteArray commentBeforeToken(qint64 token);
	
	/**
	 *	Don't use this function!
	 *  Most of the times you don't need to access lexer of parseSession directly,
	 *  This only exists, because parser test application uses DebugVisitor, which needs a lexer
	 */
	//friend dlang::Lexer* getLexer(const ParseSession& session) { return session.m_lexer; }
	
	void mapAstUse(INode *node, const SimpleUse &use)
	{
		Q_UNUSED(node);
		Q_UNUSED(use);
	}

private:
	QByteArray m_contents;
	
	int m_priority;
	KDevelop::IndexedString m_document;
	KDevelop::TopDUContext::Features m_features;
	bool forExport;
	QList<QString> m_includePaths;
	QHash<QString, QString> *m_canonicalImports;
	QMap<long, QString> m_lines;
};
