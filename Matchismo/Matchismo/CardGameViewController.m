//
//  ViewController.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/1/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

//UI property bindings
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastSelStatusLabel;

@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame * game;
@property (nonatomic, readonly) uint matchMode;
@property (nonatomic, strong) NSString * selectionImpactString;
@end

@implementation CardGameViewController

+ (NSString *)formatCardContent:(Card *) card
{
    NSString * formattedCardContent = card.contents;
    
    return formattedCardContent;
}

+ (NSAttributedString *)formatCardContentAttr:(Card *) card
{
    NSString * cardContent = [self formatCardContent:card];
    
    NSDictionary *attribs = @{ NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
                               NSForegroundColorAttributeName: [UIColor blackColor],
                               NSStrokeWidthAttributeName:@-5,
                               NSStrokeColorAttributeName:[UIColor redColor]
                               };
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:cardContent];// attributes:<#(NSDictionary *)#>];
    [attrString setAttributes:attribs range:NSMakeRange(0, cardContent.length)];
    
    
    return attrString;
}

//abstract implement in subclass
- (uint) matchMode
{
    //ASSERT FAILURE
    return 0;
}

- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.cardButtons.count usingDeck:[self createDeck]];
        _game.matchMode = self.matchMode;
    }
    
    return _game;
}

// abstract
- (Deck *)createDeck
{
    return nil;
}

- (IBAction)touchCardButton:(UIButton *)sender {
    
    NSInteger chosenButtonIndex = [self.cardButtons indexOfObject:sender];
    [self.game chooseCardAtIndex:chosenButtonIndex withNotification:self];
    [self updateUI];
}

- (void)updateUI
{
    for (UIButton *cardButton in self.cardButtons) {
        NSInteger cardButtonIndex = [self.cardButtons indexOfObject:cardButton];
        Card * card = [self.game cardAtIndex:cardButtonIndex];
        //[cardButton setTitle:[self titleForCard:card] forState:UIControlStateNormal];
        
        NSAttributedString * attrTitle = card.isChosen? [self.class formatCardContentAttr:card] : nil;
        [cardButton setAttributedTitle:attrTitle forState:UIControlStateNormal];
        
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    self.lastSelStatusLabel.text = self.selectionImpactString;
}

- (NSString *)titleForCard:(Card *)card
{
    //return card.isChosen? card.contents : @"";
    return card.isChosen? [self.class formatCardContent:card] : @"";
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    return [UIImage imageNamed:card.isChosen? @"cardfront" : @"cardback"];
}

- (IBAction)touchRedealButton:(UIButton *)sender {
    
    //reset game
    //Question: Is a call to release necessary for memory management?
    //CardMatchingGame * prevGame = self.game;
    //[prevGame release];
    self.game = nil;
    
    //Game reset - enable options available at start such as match mode
    self.selectionImpactString = @"";
    
    [self updateUI];
}


+ (NSString *)stringFromCardsArray:(NSArray *)cards
{
    NSString * cardsString = @"";
    for (Card *card in cards) {
        cardsString = [cardsString stringByAppendingFormat:@"%@ ", card.contents];
    }
    
    return cardsString;
}

- (void)selectionImpactOfCard:(Card *)card chosen:(BOOL)isChosen otherChosenCards:(NSArray *)otherChosenCards impact:(NSInteger)chosenCardsScoreImpact
{
    NSString * otherChoseCardsStr = [self.class stringFromCardsArray:otherChosenCards];
    if (isChosen) {
        if (chosenCardsScoreImpact>0) { //card matched
            self.selectionImpactString = [NSString stringWithFormat:@"%@ matched [%@] for %ld points!",
                                          card.contents, otherChoseCardsStr, (long)chosenCardsScoreImpact];
        } else if (chosenCardsScoreImpact<0) { //card mismatch penatly
            self.selectionImpactString = [NSString stringWithFormat:@"%@  did not match [%@]. %ld points penalty!",
                                          card.contents, otherChoseCardsStr, (long)-chosenCardsScoreImpact];
        } else { //card selected - no match yet
            if (otherChosenCards.count>0) { // other selected cards exist
                self.selectionImpactString = [NSString stringWithFormat:@"%@  did not match [%@].",
                                          card.contents, otherChoseCardsStr];
            } else { //first card selected
                self.selectionImpactString = [NSString stringWithFormat:@"%@ selected.",
                                              card.contents];
            }
        }
    } else { // card unselected
        if (chosenCardsScoreImpact<0) { //card was matching something
            self.selectionImpactString = [NSString stringWithFormat:@"%@  unselected was matching [%@] for %ld points!",
                                          card.contents, otherChoseCardsStr, (long)chosenCardsScoreImpact];
        } else { //card was not matching anything
            self.selectionImpactString = [NSString stringWithFormat:@"%@ unselected.",
                                          card.contents];
        }
    }
    
    NSLog(@"%@", self.selectionImpactString);
}

@end
