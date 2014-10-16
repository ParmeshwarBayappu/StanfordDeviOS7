//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/10/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "SetCardDeck.h"
#import "SetCard.h"

@implementation SetCardDeck

- (instancetype) init
{
    self = [super init];
    
    if (self) {
        for (uint number =1; number <= [SetCard MAX_VARIATION]; number++) {
            for (uint symbol =1; symbol <= [SetCard MAX_VARIATION]; symbol++) {
                for (uint shading =1; shading <= [SetCard MAX_VARIATION]; shading++) {
                    for (uint color =1; color <= [SetCard MAX_VARIATION]; color++) {
                        SetCard * card = [[SetCard alloc] init];
                        card.number = number;
                        card.symbol = symbol;
                        card.shading = shading;
                        card.color = color;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}

@end
