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

#include <language/duchain/types/integraltype.h>

#include "dduchainexport.h"

namespace dlang
{

typedef KDevelop::IntegralTypeData GoIntegralTypeData;

class KDEVDDUCHAIN_EXPORT GoIntegralType : public KDevelop::IntegralType
{
public:
	typedef KDevelop::TypePtr<GoIntegralType> Ptr;
	
	///Default constructor.
	GoIntegralType(uint type = TypeNone);
	///Copy constructor. \param rhs type to copy.
	GoIntegralType(const GoIntegralType &rhs);
	///Constructor using raw data. \param data internal data.
	GoIntegralType(GoIntegralTypeData &data);
	
	virtual KDevelop::AbstractType *clone() const;
	
	virtual QString toString() const;
	
	virtual bool equals(const KDevelop::AbstractType *rhs) const;
	
	virtual uint hash() const;
	
	enum GoIntegralTypes
	{
		TypeVoid=201,
		TypeUbyte,
		TypeUshort,
		TypeUint,
		TypeUlong,
		TypeByte,
		TypeShort,
		TypeInt,
		TypeLong,
		TypeFloat,
		TypeDouble,
		TypeReal,
		TypeBool,
		TypeChar,
		TypeWchar,
		TypeDchar
	};
	
	enum
	{
		///TODO: is that value OK?
		Identity = 78
	};
	
	//GoIntegralType(uint type = TypeNone) : IntegralType(type) {}
	
	typedef KDevelop::IntegralTypeData Data;
	typedef KDevelop::IntegralType BaseType;
	
protected:
	TYPE_DECLARE_DATA(GoIntegralType);
	
};

}


namespace KDevelop
{

template<>
inline dlang::GoIntegralType *fastCast<dlang::GoIntegralType *>(AbstractType *from)
{
	if(!from || from->whichType() != AbstractType::TypeIntegral)
		return 0;
	return dynamic_cast<dlang::GoIntegralType *>(from);
}

}
