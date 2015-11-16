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

#include "dducontext.h"

#include <language/duchain/topducontext.h>
#include <language/duchain/duchainregister.h>
#include <language/duchain/topducontextdata.h>
#include <language/util/includeitem.h>

#include "navigation/navigationwidget.h"
#include "duchaindebug.h"

using namespace KDevelop;

namespace dlang
{

typedef DDUContext<TopDUContext> DTopDUContext;
REGISTER_DUCHAIN_ITEM_WITH_DATA(DTopDUContext, TopDUContextData);

typedef DDUContext<DUContext> DNormalDUContext;
REGISTER_DUCHAIN_ITEM_WITH_DATA(DNormalDUContext, DUContextData);

template<>
QWidget *DTopDUContext::createNavigationWidget(Declaration *decl, TopDUContext *topContext, const QString &htmlPrefix, const QString &htmlSuffix) const
{
	if(!decl)
	{
		qCDebug(DUCHAIN) << "no declaration, not returning navigationwidget";
		return 0;
	}
	return new NavigationWidget(decl, topContext, htmlPrefix, htmlSuffix);
}

template<>
QWidget *DNormalDUContext::createNavigationWidget(Declaration *decl, TopDUContext *topContext, const QString &htmlPrefix, const QString &htmlSuffix) const
{
	if(!decl)
	{
		qCDebug(DUCHAIN) << "no declaration, not returning navigationwidget";
		return 0;
	}
	return new NavigationWidget(decl, topContext, htmlPrefix, htmlSuffix);
}

}
