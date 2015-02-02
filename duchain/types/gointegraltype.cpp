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

#include "gointegraltype.h"

#include <language/duchain/types/typeregister.h>

using namespace KDevelop;

namespace go
{

REGISTER_TYPE(GoIntegralType);

GoIntegralType::GoIntegralType(const GoIntegralType& rhs) : IntegralType(copyData<GoIntegralType>(*rhs.d_func()))
{
}

GoIntegralType::GoIntegralType(GoIntegralTypeData& data) : IntegralType(data)
{
}

GoIntegralType::GoIntegralType(uint type) : IntegralType(createData<GoIntegralType>())
{
	setDataType(type);
	setModifiers(ConstModifier);
}

QString GoIntegralType::toString() const
{
	TYPE_D(GoIntegralType);
	
	QString name;
	
	switch(d->m_dataType)
	{
		case TypeUbyte:
			name = "ubyte";
			break;
		case TypeUshort:
			name = "ushort";
			break;
		case TypeUint:
			name = "uint";
			break;
		case TypeUlong:
			name = "ulong";
			break;
		case TypeByte:
			name = "byte";
			break;
		case TypeShort:
			name = "short";
			break;
		case TypeInt:
			name = "int";
			break;
		case TypeLong:
			name = "long";
			break;
		case TypeFloat:
			name = "float";
			break;
		case TypeDouble:
			name = "double";
			break;
		case TypeReal:
			name = "real";
			break;
		case TypeBool:
			name = "bool";
			break;
		case TypeChar:
			name = "char";
			break;
		case TypeWchar:
			name = "wchar";
			break;
		case TypeDchar:
			name = "dchar";
			break;
	}
	
	return /*AbstractType::toString() + */name;
}


KDevelop::AbstractType* GoIntegralType::clone() const
{
	return new GoIntegralType(*this);
}

uint GoIntegralType::hash() const
{
	return 4 * KDevelop::IntegralType::hash();
}

bool GoIntegralType::equals(const KDevelop::AbstractType* rhs) const
{
	if(this == rhs )
		return true;
	
	if(!IntegralType::equals(rhs))
		return false;
	
	Q_ASSERT(fastCast<const GoIntegralType*>(rhs));
	
	const GoIntegralType* type = static_cast<const GoIntegralType*>(rhs);
	
	return d_func()->m_dataType == type->d_func()->m_dataType;
}

}
