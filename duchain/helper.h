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

#pragma once

#include <language/duchain/ducontext.h>
#include <QUrl>

#include "dduchainexport.h"

using namespace KDevelop;

namespace dlang
{

class KDEVDDUCHAIN_EXPORT Helper
{
public:
	static QList<QString> getSearchPaths(QUrl document=QUrl());

private:
	static QList<QString> m_CachedSearchPaths;
};

KDEVDDUCHAIN_EXPORT DeclarationPointer getDeclaration(QualifiedIdentifier id, DUContext *context, bool searchInParent=true);

/**
 * This tries to find declaration which has a real type, like Instance and Type
 * but skips declarations like Namespace, NamespaceAlias and Import which can be
 * packages or type methods(but not the actual type declarations).
 */
KDEVDDUCHAIN_EXPORT DeclarationPointer getTypeOrVarDeclaration(QualifiedIdentifier id, DUContext *context, bool searchInParent=true);

/**
 * This only looks for type declarations.
 */
KDEVDDUCHAIN_EXPORT DeclarationPointer getTypeDeclaration(QualifiedIdentifier id, DUContext *context, bool searchInParent=true);

KDEVDDUCHAIN_EXPORT QList<Declaration *> getDeclarations(QualifiedIdentifier id, DUContext *context, bool searchInParent=true);


KDEVDDUCHAIN_EXPORT DeclarationPointer getFirstDeclaration(DUContext *context, bool searchInParent=true);

/**
 * Checks if topContext declares package @param id.
 */
KDEVDDUCHAIN_EXPORT DeclarationPointer checkPackageDeclaration(Identifier id, TopDUContext *context);

}
