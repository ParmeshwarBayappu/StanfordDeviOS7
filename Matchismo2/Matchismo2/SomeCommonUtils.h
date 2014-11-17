//
//  SomeCommonUtils.h
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/14/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#ifndef Matchismo_SomeCommonUtils_h
#define Matchismo_SomeCommonUtils_h

//Macro to cast an objective c object to Type T or assert if O is not kind of type T
#define SAFE_CAST_TO_TYPE_OR_ASSERT(O, T) (assert([O isKindOfClass: [T class]]), (T *) O)

#endif
