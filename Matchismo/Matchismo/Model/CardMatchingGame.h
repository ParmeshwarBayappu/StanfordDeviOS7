//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/3/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"

@interface CardMatchingGame : NSObject

// desginated initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *) deck;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (Card *)cardAtIndex:(NSUInteger)index;
- (NSArray *)currentChosenCards;
- (int) currentChosenCardsScore;

@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger matchMode;
@end
