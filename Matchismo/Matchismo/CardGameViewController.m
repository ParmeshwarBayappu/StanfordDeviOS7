//
//  ViewController.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/1/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "CardGameViewController.h"
#import "CardMatchingGame.h"
//@import Foundation;
#import "SomeCommonUtils.h"
#import "SelectionImpactHistoryViewController.h"

@interface CardGameViewController ()

//UI property bindings
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *cardButtons;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (weak, nonatomic) IBOutlet UILabel *lastSelStatusLabel;
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModeLabel;

@property (nonatomic) int flipCount;
@property (strong, nonatomic) CardMatchingGame * game;
//@property (nonatomic, readonly) uint matchMode;
@property (nonatomic, strong) NSAttributedString * selectionImpactStringAttr;
@property (nonatomic, strong) NSMutableArray * selectionImpactHistory; //of NSAttributedString

@end

@implementation CardGameViewController

- (uint)selectedMatchModeIndex
{
    assert(self.matchModeLabel.selectedSegmentIndex>=0);
    return (uint) self.matchModeLabel.selectedSegmentIndex;
}

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"ShowHistory"]) {
        SelectionImpactHistoryViewController * historyVC = (SelectionImpactHistoryViewController *)segue.destinationViewController;
        historyVC.attributedSelectionHistory = self.selectionImpactHistory;
    }
}

- (NSMutableArray *)selectionImpactHistory
{
    if(!_selectionImpactHistory) _selectionImpactHistory = [[NSMutableArray alloc] init];
    return _selectionImpactHistory;
}

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

+ (NSAttributedString *)formatCardContentAttrWhenNotChosen:(Card *) card
{
    return nil;
}

//abstract implement in subclass
- (uint) numberOfCardsToMatch
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
        
        NSAttributedString * attrTitle = card.isChosen? [self.class formatCardContentAttr:card] : [self.class formatCardContentAttrWhenNotChosen:card];
        [cardButton setAttributedTitle:attrTitle forState:UIControlStateNormal];
        
        [cardButton setBackgroundImage:[self backgroundImageForCard:card]forState:UIControlStateNormal];
        cardButton.enabled = !card.isMatched;
    }
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld", (long)self.game.score];
    [self.lastSelStatusLabel setAttributedText:self.selectionImpactStringAttr];
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

- (IBAction)touchRedealButton:(id)sender {
    
    //reset game
    //Question: Is a call to release necessary for memory management?
    //CardMatchingGame * prevGame = self.game;
    //[prevGame release];
    self.game = nil;
    
    //Game reset - enable options available at start such as match mode
    self.selectionImpactStringAttr = nil;
    self.selectionImpactHistory = nil;
    
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

NSAttributedString * cardSeparatorInAttributedString = nil;

+ (NSAttributedString *)separatorForAttributedStringFromCardsArray
{
    if(!cardSeparatorInAttributedString) cardSeparatorInAttributedString = [[NSAttributedString alloc] initWithString:@", "];
    return cardSeparatorInAttributedString;
}

+ (NSAttributedString *)attributedStringFromCardsArray:(NSArray *)cards
{
    NSMutableAttributedString * cardsAttrString = [[NSMutableAttributedString alloc] init];
    BOOL firstTimeInLoop = true;

    for (Card *card in cards) {
        // Add separator between cards
        if (firstTimeInLoop) firstTimeInLoop = false;
        else [cardsAttrString appendAttributedString:[self separatorForAttributedStringFromCardsArray]];
        
        [cardsAttrString appendAttributedString: [self formatCardContentAttr:card]];
    }
    
    return cardsAttrString;
}

- (void)selectionImpactOfCard:(Card *)card chosen:(BOOL)isChosen otherChosenCards:(NSArray *)otherChosenCards impact:(NSInteger)chosenCardsScoreImpact
{
    //NSString * otherChoseCardsStr = [self.class stringFromCardsArray:otherChosenCards];
    //NSString * cardContents = card.contents;
    NSAttributedString *cardContentsAttr = [self.class formatCardContentAttr:card];
    NSAttributedString * otherChoseCardsStrAttr = [self.class attributedStringFromCardsArray:otherChosenCards];
    
    NSMutableAttributedString * strBuilder = [[NSMutableAttributedString alloc] init];
    
    if (isChosen) {
        if (chosenCardsScoreImpact>0) { //card matched
            //@"%@ matched [%@] for %ld points!"
            [strBuilder appendAttributedString:cardContentsAttr];
            [strBuilder appendAttributedString:[[NSAttributedString alloc] initWithString:@" matched ["]];
            [strBuilder appendAttributedString:otherChoseCardsStrAttr];
            [strBuilder appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"] for %ld points!", (long)chosenCardsScoreImpact]]];
            
        } else if (chosenCardsScoreImpact<0) { //card mismatch penatly
            //@"%@  did not match [%@]. %ld points penalty!"
            [strBuilder appendAttributedString:cardContentsAttr];
            [strBuilder appendAttributedString:[[NSAttributedString alloc] initWithString:@" did not match ["]];
            [strBuilder appendAttributedString:otherChoseCardsStrAttr];
            [strBuilder appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"]. %ld points penalty!", (long)chosenCardsScoreImpact]]];
            
        } else { //card selected - no match yet
            if (otherChosenCards.count>0) { // other selected cards exist
                //@"%@  did not match [%@]."
                [strBuilder appendAttributedString:cardContentsAttr];
                [strBuilder appendAttributedString:[[NSAttributedString alloc] initWithString:@" did not match ["]];
                [strBuilder appendAttributedString:otherChoseCardsStrAttr];
                [strBuilder appendAttributedString:[[NSAttributedString alloc] initWithString:@"] yet."]];
            } else { //first card selected
                //@"%@ selected."
                [strBuilder appendAttributedString:cardContentsAttr];
                [strBuilder appendAttributedString:[[NSAttributedString alloc] initWithString:@" selected."]];
            }
        }
    } else { // card unselected
        if (chosenCardsScoreImpact<0) { //card was matching something
            //@"%@  unselected was matching [%@] for %ld points!"
            [strBuilder appendAttributedString:cardContentsAttr];
            [strBuilder appendAttributedString:[[NSAttributedString alloc] initWithString:@" unselected was matching ["]];
            [strBuilder appendAttributedString:otherChoseCardsStrAttr];
            [strBuilder appendAttributedString:[[NSAttributedString alloc] initWithString:[[NSString alloc] initWithFormat:@"] for %ld points!", (long)chosenCardsScoreImpact]]];
        } else { //card was not matching anything
            //@"%@ unselected."
            [strBuilder appendAttributedString:cardContentsAttr];
            [strBuilder appendAttributedString:[[NSAttributedString alloc] initWithString:@" unselected."]];
        }
    }
    
    self.selectionImpactStringAttr = strBuilder;
    [self.selectionImpactHistory addObject:self.selectionImpactStringAttr];
    NSLog(@"%@", self.selectionImpactStringAttr.string);
}

@end
