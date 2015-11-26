/*************************************************************************************
 *  Copyright (C) 2015 by Thomas Brix Larsen <brix@brix-verden.dk>                   *
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

#include "helper.h"

#include <language/duchain/duchainlock.h>
#include <language/duchain/declaration.h>
#include <language/duchain/topducontext.h>

#include <QReadLocker>
#include <QProcess>

namespace dlang
{

QList<QString> Helper::getSearchPaths(QUrl document)
{
	QList<QString> paths;
	if(QFileInfo("/usr/include/dlang/dmd").exists())
		paths.append("/usr/include/dlang/dmd");
	else if(QFileInfo("/usr/include/dlang/ldc").exists())
		paths.append("/usr/include/dlang/ldc");
	else if(QFileInfo("/usr/include/dlang/gdc").exists())
		paths.append("/usr/include/dlang/gcd");
	else if(QFileInfo("/usr/include/d/dmd").exists())
		paths.append("/usr/include/d/dmd");
	else if(QFileInfo("/usr/include/d").exists())
		paths.append("/usr/include/d");
	if(document != QUrl())
	{
		//Try to find path automatically for opened documents.
		QDir currentDir(document.adjusted(QUrl::RemoveFilename).path());
		while(currentDir.exists() && (currentDir.dirName() != "src" || currentDir.dirName() != "source"))
		{
			if(!currentDir.cdUp())
				break;
		}
		if(currentDir.exists() && (currentDir.dirName() == "src" || currentDir.dirName() == "source"))
			paths.append(currentDir.absolutePath());
		paths.append(document.adjusted(QUrl::RemoveFilename).path());
	}
	return paths;
}

DeclarationPointer getDeclaration(QualifiedIdentifier id, DUContext *context, bool searchInParent)
{
	DUChainReadLocker lock;
	if(context)
	{
		auto declarations = context->findDeclarations(id, CursorInRevision(INT_MAX, INT_MAX));
		for(Declaration *decl : declarations)
		{
			//Import declarations are just decorations and need not be returned.
			if(decl->kind() == Declaration::Import)
				continue;
			return DeclarationPointer(decl);
		}
	}
	return DeclarationPointer();
}

DeclarationPointer getTypeOrVarDeclaration(QualifiedIdentifier id, DUContext *context, bool searchInParent)
{
	DUChainReadLocker lock;
	if(context)
	{
		auto declarations = context->findDeclarations(id, CursorInRevision(INT_MAX, INT_MAX));
		for(Declaration *decl : declarations)
		{
			if(decl->kind() == Declaration::Import || decl->kind() == Declaration::Namespace || decl->kind() == Declaration::NamespaceAlias)
				continue;
			return DeclarationPointer(decl);
		}
	}
	return DeclarationPointer();
}

DeclarationPointer getTypeDeclaration(QualifiedIdentifier id, DUContext *context, bool searchInParent)
{
	DUChainReadLocker lock;
	if(context)
	{
		auto declarations = context->findDeclarations(id, CursorInRevision(INT_MAX, INT_MAX));
		for(Declaration *decl : declarations)
		{
			if(decl->kind() != Declaration::Type)
				continue;
			return DeclarationPointer(decl);
		}
	}
	return DeclarationPointer();
}

QList<Declaration *> getDeclarations(QualifiedIdentifier id, DUContext *context, bool searchInParent)
{
	DUChainReadLocker lock;
	if(context)
	{
		QList<Declaration *> decls;
		auto declarations = context->findDeclarations(id, CursorInRevision(INT_MAX, INT_MAX));
		for(Declaration *decl: declarations)
		{
			if(decl->kind() == Declaration::Import)
				continue;
			decls << decl;
		}
		return decls;
	}
	return QList<Declaration *>();
}

DeclarationPointer getFirstDeclaration(DUContext *context, bool searchInParent)
{
	DUChainReadLocker lock;
	auto declarations = context->allDeclarations(CursorInRevision::invalid(), context->topContext(), searchInParent);
	if(declarations.size() > 0)
		return DeclarationPointer(declarations.first().first);
	return DeclarationPointer();
}

DeclarationPointer checkPackageDeclaration(Identifier id, TopDUContext *context)
{
	DUChainReadLocker lock;
	auto declarations = context->findLocalDeclarations(id);
	if(declarations.size() > 0)
		return DeclarationPointer(declarations.first());
	return DeclarationPointer();
}

}
