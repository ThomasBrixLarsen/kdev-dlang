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

#include <language/duchain/abstractfunctiondeclaration.h>
#include <language/duchain/duchainutils.h>
#include <language/duchain/types/functiontype.h>
#include <language/duchain/types/structuretype.h>
#include <interfaces/icore.h>
#include <interfaces/idocumentationcontroller.h>

#include <language/duchain/types/typealiastype.h>
#include <language/duchain/types/structuretype.h>
#include <language/duchain/classdeclaration.h>
#include <typeinfo>
#include "language/duchain/functiondeclaration.h"
#include "language/duchain/functiondefinition.h"
#include "language/duchain/classfunctiondeclaration.h"
#include "language/duchain/namespacealiasdeclaration.h"
#include "language/duchain/forwarddeclaration.h"
#include "language/duchain/types/enumeratortype.h"
#include "language/duchain/types/enumerationtype.h"
#include "language/duchain/types/functiontype.h"
#include "language/duchain/duchainutils.h"
#include "language/duchain/types/pointertype.h"
#include "language/duchain/types/referencetype.h"
#include "language/duchain/types/typeutils.h"
#include "language/duchain/persistentsymboltable.h"
#include "language/duchain/types/arraytype.h"

#include <QtGui/QTextDocument>

#include "navigation/declarationnavigationcontext.h"
#include "declarations/functiondeclaration.h"
#include "types/gofunctiontype.h"
#include "../duchaindebug.h"

using namespace KDevelop;

DeclarationNavigationContext::DeclarationNavigationContext(DeclarationPointer decl, KDevelop::TopDUContextPointer topContext, AbstractNavigationContext *previousContext)
    : AbstractDeclarationNavigationContext(decl, topContext, previousContext)
{

}

QString DeclarationNavigationContext::html(bool shorten)
{
	return KDevelop::AbstractDeclarationNavigationContext::html(shorten);
}

void DeclarationNavigationContext::htmlFunction()
{
	KDevelop::AbstractDeclarationNavigationContext::htmlFunction();
}

void DeclarationNavigationContext::eventuallyMakeTypeLinks(AbstractType::Ptr type)
{
	KDevelop::AbstractDeclarationNavigationContext::eventuallyMakeTypeLinks(type);
}
