//
//  SetCard.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/10/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

+ (uint)MAX_VARIATION {  //changed from a const to a function so that the SetDeck class can access this
    return 3; // Each feature of a set card is one of '3' possible values
}

- (void)setNumber:(uint)number {
    if (number > 0 && number <= [SetCard MAX_VARIATION]) {
        _number = number;
    }
}

- (void)setSymbol:(uint)symbol {
    if (symbol > 0 && symbol <= [SetCard MAX_VARIATION]) {
        _symbol = symbol;
    }
}

- (void)setShading:(uint)shading {
    if (shading > 0 && shading <= [SetCard MAX_VARIATION]) {
        _shading = shading;
    }
}

- (void)setColor:(uint)color {
    if (color > 0 && color <= [SetCard MAX_VARIATION]) {
        _color = color;
    }
}


- (NSString *)contents {
    //temp approach
    NSString *contentRep = [NSString stringWithFormat:@"N%d S%d s%d C%d", self.number, self.symbol, self.shading, self.color];

    return contentRep;
}

// helper method to check number of identical values
+ (uint)isAllDifferentOrAllSameNumber1:(uint)num1 number2:(uint)num2 number3:(uint)num3 {
    uint matchCount = 0;
    if (num1 == num2) matchCount++;
    if (num1 == num3) matchCount++;
    if (num2 == num3) matchCount++;

    BOOL isAllDifferentOrAllSame = (matchCount == 3) || (matchCount == 0);
    return isAllDifferentOrAllSame;
}

- (int)match:(NSArray *)otherCards {
    int score = 0;

    //ASSERT MAX_VARIATION == 3

    if (otherCards.count == 2) // right number of cards to do a match check
    {
        SetCard *setCard2 = (SetCard *) otherCards[0];
        SetCard *setCard3 = (SetCard *) otherCards[1];

        if ([self.class isAllDifferentOrAllSameNumber1:self.number number2:setCard2.number number3:setCard3.number]
                && [self.class isAllDifferentOrAllSameNumber1:self.symbol number2:setCard2.symbol number3:setCard3.symbol]
                && [self.class isAllDifferentOrAllSameNumber1:self.shading number2:setCard2.shading number3:setCard3.shading]
                && [self.class isAllDifferentOrAllSameNumber1:self.color number2:setCard2.color number3:setCard3.color])
            score = 1; //match
    }

    return score;
}


@end
