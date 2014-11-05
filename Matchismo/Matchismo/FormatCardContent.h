//
//  FormatCardContent.h
//  Matchismo
//
//  Created by Parmesh Bayappu on 11/3/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#include "Card.h"

@protocol FormatCardContent <NSObject>

+ (NSString *)formatContent:(Card *) card;
+ (NSAttributedString *)formatContentAttr:(Card *) card;

@end
