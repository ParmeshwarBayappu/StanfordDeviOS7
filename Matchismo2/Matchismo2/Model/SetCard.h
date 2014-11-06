//
//  SetCard.h
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/10/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "Card.h"

@interface SetCard : Card

// TODO: later add conversions to other symbols of have that as part of dervied class or separate decode/representation class
@property (nonatomic) uint number;
@property (nonatomic) uint symbol;
@property (nonatomic) uint shading;
@property (nonatomic) uint color;

+(uint) MAX_VARIATION; // Each feature of a set card is one of '3' possible values

@end
