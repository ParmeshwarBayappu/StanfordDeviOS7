//
//  CardGameNotifications.h
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/7/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@protocol CardGameNotifications <NSObject>

-(void)selectionImpactOfCard:(Card *)card chosen:(BOOL)isChosen otherChosenCards:(NSArray *)otherChosenCards impact:(int)chosenCardsScoreImpact;

@end
