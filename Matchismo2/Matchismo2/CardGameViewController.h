//
//  CardGameViewController.h
//  Matchismo2
//
//  Created by Parmesh Bayappu on 11/5/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Deck.h"

@interface CardGameViewController : UIViewController

@property (nonatomic, readonly) uint numberOfCardsToDeal; //abstract to be implemented by subclasses
@property (nonatomic, readonly) CGFloat cellAspectRatio; //abstract to be implemented by subclasses

@property (nonatomic, readonly) BOOL matchStarted;
@property (nonatomic, readonly) uint selectedMatchModeIndex;

// abstract
// protected - for subclass to implement
- (Deck *)createDeck;
- (uint) numberOfCardsToMatch;
- (UIView *)createCardViewWith:(Card *)card;

@end

