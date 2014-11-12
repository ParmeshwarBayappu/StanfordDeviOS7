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
@property (nonatomic, strong) NSMutableArray *internalCards; // of Card
@property (nonatomic) NSInteger currChosenCardsScore; //match score of currently chosen but not yet matched cards - intermediate score
@property (nonatomic, readonly) BOOL persistLastChosenCard;
@property (nonatomic,strong) Deck *deck;
@end

@implementation CardMatchingGame

- (NSMutableArray *)internalCards
{
    if (!_internalCards) {
        _internalCards = [[NSMutableArray alloc] init];
    }
    return _internalCards;
}

- (NSArray *)cards {
    return [self.internalCards copy];
}

 -(BOOL)persistLastChosenCard {
     return true;
 }

// consider adding match mode to this initializer
- (instancetype)initWithCardCount:(NSUInteger)count usingDeck:(Deck *)deck
{
    self = [super init];
    if (self) {
        self.deck = deck;
        for (int i=0; i<count; i++) {
            Card * card =[deck drawRandomCard];
            if (card) {
                [self.internalCards addObject:card];
                NSLog(@"Card at %d: %@", i, card.contents );
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
    return (index<self.internalCards.count) ? [self.internalCards objectAtIndex:index] : nil;
}

static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index
{
    [self chooseCardAtIndex:index withNotification:nil];
}

- (int)indexOfCard:(Card *)card {
    return [self.internalCards indexOfObject:card];
}

- (void)chooseCardAtIndex:(NSUInteger)index withNotification:(id<CardGameNotifications>) requestor {
    Card * card = [self cardAtIndex:index];
    [self chooseCard:card withNotification:requestor];
}

- (void)chooseCard:(Card *)card withNotification:(id<CardGameNotifications>) requestor
{
    if (!card.isMatched) {
        if (card.isChosen) { // if previously chosen flip it back
            card.chosen = NO;
            //calculate impact, update selected score and notify
            NSArray *prevChosenCards = [self currentChosenCards];
            int cardMatchImpact = -[self weightedMatchCard:card toOtherCards:prevChosenCards];
            self.currChosenCardsScore += cardMatchImpact;
            [requestor selectionImpactOfCard:card chosen:NO otherChosenCards:prevChosenCards impact:cardMatchImpact];
        } else { // if not previously chosen
            
            NSArray *prevChosenCards = [self currentChosenCards];
            if (prevChosenCards.count >= self.matchMode) return; //Prevent choosing more than current match mode cards  - currently not feasible as prev sel cards are unselected automatically
            
            //calculate impact, update selected score
            card.chosen = YES;
            self.score -= COST_TO_CHOOSE; //for choosing to view a card
            NSInteger cardMatchImpact = [self weightedMatchCard:card toOtherCards:prevChosenCards];
            self.currChosenCardsScore += cardMatchImpact;

            if (prevChosenCards.count < (self.matchMode-1)) { // match mode requires more cards to be selected
                //notify impact
                [requestor selectionImpactOfCard:card chosen:YES otherChosenCards:prevChosenCards impact:cardMatchImpact];
            } else { // match mode - all required cards selected
                if (self.currChosenCardsScore) { //something matched
                    // increase score with match score of chosen cards and mark cards as matched
                    self.score += self.currChosenCardsScore;
                    card.matched = true;
                    for (Card * chosenCard in prevChosenCards) {
                        chosenCard.matched = true;
                    }
                    NSArray *matchedCards = [prevChosenCards arrayByAddingObject:card];
                    [requestor cardsMatched:matchedCards];
                    [self removeCards:matchedCards];
                } else { //no match at all
                    // //apply penalty to score and mark cards (other than current card) as unchosen.
                    cardMatchImpact = self.currChosenCardsScore = -MISMATCH_PENALTY * self.matchMode; //for choosing mismatchng cards
                    self.score += self.currChosenCardsScore;
                    if(!self.persistLastChosenCard)card.chosen = false;
                    for (Card * chosenCard in prevChosenCards) {
                        chosenCard.chosen = false;
                    }
                }
                //notify
                [requestor selectionImpactOfCard:card chosen:YES otherChosenCards:prevChosenCards impact:cardMatchImpact];
                self.currChosenCardsScore = 0; //reset chosen cards score
            }
        }
    }
}

//current chosen cards
- (NSArray *)currentChosenCards
{
    NSMutableArray *chosenCards = [[NSMutableArray alloc] init];
    for (Card * otherCard in self.internalCards) {
        if (!otherCard.isMatched && otherCard.isChosen) {
            [chosenCards addObject:otherCard];
        }
    }
    return chosenCards;
}

//helper function - current chosen cards score
- (int) currentChosenCardsWeightedScore
{
    int score = 0;
    NSArray * chosenCards = [self currentChosenCards];
    NSInteger chosenCount = chosenCards.count;
    //match each card against the other cards and sum their matching scores
    for (NSInteger i=chosenCount-1; i>0; i--) {
        //NSArray * otherCards = [NSArray arrayWithObjects:[(const id[])chosenCards count:i];
        //score += [chosenCards[i] match:otherCards];
        for (NSInteger j=i-1; j>=0; j--) {
            score += [self weightedMatchCard:chosenCards[i] toOtherCards:@[chosenCards[j]]];
        }
    }
    
    return score;
}

//helper function match a Card to previously chosen cards and return match score including weights
- (int)weightedMatchCard:(Card *)card toOtherCards:(NSArray *)otherCards
{
    int matchScore = [card match:otherCards];
    matchScore *=  MATCH_BONUS * self.matchMode;
    return matchScore;
}

//Helper function - mark cards as not chosen
- (void)markCardsAsNotChosen:(NSArray *)cards
{
    for (Card * card in cards) {
        card.chosen = NO;
    }
}

- (uint)drawAdditionalCards:(uint)cardCount {
    uint addedCardCount = 0;  NSMutableArray * addedCards = [NSMutableArray arrayWithCapacity:cardCount];
    for( addedCardCount=0; addedCardCount < cardCount; addedCardCount++) {
        Card * card = [self.deck drawRandomCard];
        if(card) {
            [self.internalCards addObject:card];
        } else
            break;
    }
    if (addedCardCount > 0 && self.notificationsDelegate) {
        [self.notificationsDelegate cardsAdded:addedCards];
    }
    return addedCardCount;
}

- (void)removeCards:(NSArray *)cardsToRemove {
    [self.internalCards removeObjectsInArray:cardsToRemove];

    if(self.notificationsDelegate) {
        [self.notificationsDelegate cardsRemoved:cardsToRemove];
    }
}

@end
