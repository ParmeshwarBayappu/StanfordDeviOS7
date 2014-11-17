//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/3/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "CardGameNotifications.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *) deck NS_DESIGNATED_INITIALIZER;

- (void)chooseCardAtIndex:(NSUInteger)index;
- (void)chooseCardAtIndex:(NSUInteger)index withNotification:(id<CardGameNotifications>) requestor;
- (void)chooseCard:(Card *)card withNotification:(id <CardGameNotifications>)requestor;
- (uint)drawAdditionalCards: (uint)cardCount;

- (Card *)cardAtIndex:(NSUInteger)index;
- (NSArray *)currentChosenCards;
//- (int) currentChosenCardsScore;
- (NSUInteger)indexOfCard:(Card *)card;

@property (nonatomic, readonly) NSArray *cards; //Of Card
@property (nonatomic, readonly) NSInteger score;
@property (nonatomic) NSUInteger matchMode;
@property (nonatomic, weak) id<CardGameNotifications> notificationsDelegate;
@property (nonatomic, readonly) BOOL additionalCardsAvailable;
@end
