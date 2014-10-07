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
//@property (nonatomic) NSInteger chosenCardsScore; //match score of currently chosen but not yet matched cards - intermediate score
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

static const int MISMATCH_PENALTY = 1;//2;
static const int MATCH_BONUS = 1;//4;
static const int COST_TO_CHOOSE = 1;


- (void)chooseCardAtIndex:(NSUInteger)index
{
    Card * card = [self cardAtIndex:index];
    
    if (!card.isMatched) {
        if (card.isChosen) {
            //flip it back if previosuly chosen
            card.chosen = NO;
            //update current choosen score
//            NSArray *prevChosenCards = [self currentChosenCards];
//            self.chosenCardsScore -= [card match:prevChosenCards];
        } else {
            //Identify chosen cards and match all chosen cards including current chosen.
            NSArray *prevChosenCards = [self currentChosenCards];
            
            //Prevent choosing more than current match mode cards
            if (prevChosenCards.count < self.matchMode)
            {
                if ((int)(prevChosenCards.count) < ((int)(self.matchMode))) {
                    card.chosen = YES;
                    self.score -= COST_TO_CHOOSE; //for choosing to view a card
                }
                
                //update current choosen score
//                self.chosenCardsScore += [card match:prevChosenCards];
                
                if (prevChosenCards.count == (self.matchMode -1)) {
                    //selection complete so update overall score with score of chosen cards
//                    self.chosenCardsScore = [self currentChosenCardsScore];
//                    int matchScore = self.chosenCardsScore;
                    int matchScore = [self currentChosenCardsScore];
                    if (matchScore) {
                        // increase score and mark cards as matched
                        self.score += matchScore * MATCH_BONUS * self.matchMode;
                        card.matched = true;
                        for (Card * chosenCard in prevChosenCards) {
                            chosenCard.matched = true;
                        }
                    } else {
                        // decrease score and mark cards (other than current card) as unchosen.
                        self.score -= MISMATCH_PENALTY * self.matchMode; //for choosing mismatchng cards
                        for (Card * chosenCard in prevChosenCards) {
                            chosenCard.chosen = false;
                        }
                    }
//                    self.chosenCardsScore = 0; //reset chosen cards score
                }
            }
        }
    }
}

//current chosen cards
- (NSArray *)currentChosenCards
{
    NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
    
    for (Card * otherCard in self.cards) {
        if (!otherCard.isMatched && otherCard.isChosen) {
            [chosenCards addObject:otherCard];
        }
    }
    return chosenCards;
}

//helper function - current chosen cards score
- (int) currentChosenCardsScore
{
    int score = 0;
    NSArray * chosenCards = [self currentChosenCards];
    int chosenCount = chosenCards.count;
    //match each card against the other cards and sum their matching scores
    for (int i=chosenCount-1; i>0; i--) {
        //NSArray * otherCards = [NSArray arrayWithObjects:[(const id[])chosenCards count:i];
        //score += [chosenCards[i] match:otherCards];
        for (int j=i-1; j>=0; j--) {
            score += [chosenCards[i] match:@[chosenCards[j]]];
        }
    }
    
    return score;
}

//Helper fucntion - mark cards as not chosen
- (void)markCardsAsNotChosen:(NSArray *)cards
{
    for (Card * card in cards) {
        card.chosen = NO;
    }
}


// Helper function - mark a card as chosen and update score
- (void)markCardAsChosenAnd:(Card *) card
{
    if (!card.isChosen) {
        card.chosen = YES;
        self.score -= COST_TO_CHOOSE; //for choosing to viewe a card
    }
}

@end
