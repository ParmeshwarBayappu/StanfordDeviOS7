//
//  CardGameViewController.h
//  Matchismo2
//
//  Created by Parmesh Bayappu on 11/5/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"
#import "CardView.h"
#import "CardGameNotifications.h"

@interface CardGameViewController : UIViewController <CardGameNotifications>

@property (nonatomic, readonly) uint numberOfCardsToDeal; //abstract to be implemented by subclasses
@property (nonatomic, readonly) CGFloat cellAspectRatio; //abstract to be implemented by subclasses

@property (nonatomic, readonly) BOOL matchActionStarted;
@property (nonatomic, readonly) uint selectedMatchModeIndex;

+ (NSArray *)matchModeTitles;

- (CardStateType)getCardViewState:(Card *)card;

// abstract
// protected - for subclass to implement
- (Deck *)createDeck;
- (uint) numberOfCardsToMatch;
- (CardView *)createCardViewWith:(Card *)card;

@end

