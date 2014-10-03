//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/3/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame ()
@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, strong) NSMutableArray * cards; // of Card
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) {
        _cards = [[NSMutableArray alloc] init];
    }
    return _cards;
}


- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        for (int i=0; i<count; i++) {
            Card * card =[deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            } else {
                self = nil;
                break;
            }
        }
    }
    return self;
}

- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<self.cards.count) ? [self.cards objectAtIndex:index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;


- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card * card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            //flip it back if previosuly chosen
            card.chosen = NO;
        } else {
            //match against other chosen cards
            for (Card * otherCard in self.cards) {
                if (!otherCard.isMatched && otherCard.isChosen) {
                    int matchScore = [card match:@[otherCard]];
                    if (matchScore) {
                        self.score += matchScore * MATCH_BONUS;
                        card.matched = true;
                        otherCard.matched = true;
                    } else {
                        otherCard.chosen = false;
                        self.score -= MISMATCH_PENALTY; //for choosing mismatchng cards
                    }
                    break;
                }
            }
            card.chosen = true;
            self.score -= COST_TO_CHOOSE; //for choosing (viewing) the card
        }
    }
}

@end
