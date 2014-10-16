//
//  ViewController.h
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/1/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardGameNotifications.h"
#import "Deck.h"

@interface CardGameViewController : UIViewController <CardGameNotifications>

// abstract
// protected - for subclass to implement
- (Deck *)createDeck;
- (uint) numberOfCardsToMatch;

@property (nonatomic, readonly) BOOL matchStarted;
- (uint)selectedMatchModeIndex;

- (NSAttributedString *)formatCardContentAttr:(Card *) card;
- (NSAttributedString *)formatCardContentAttrWhenNotChosen:(Card *) card;

- (UIImage *)backgroundImageForCard:(Card *)card;

@end

