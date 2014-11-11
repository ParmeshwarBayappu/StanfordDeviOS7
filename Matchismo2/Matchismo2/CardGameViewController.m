//
//  CardGameViewController.m
//  Matchismo2
//
//  Created by Parmesh Bayappu on 11/5/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardView.h"
#import "SetCardView.h"
#import "GridView.h"
#import "PlayingCard.h"
#import "PlayingCardDeck.h"
#import "SetCard.h"
#import "SetCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

//UI Properties
@property (weak, nonatomic) IBOutlet UISegmentedControl *matchModeSegControl;
@property (weak, nonatomic) IBOutlet UIButton *redealButton;
@property(weak, nonatomic) IBOutlet GridView *cardsBoundaryView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;

@property (strong, nonatomic) CardMatchingGame * game;
//@property (nonatomic, readonly) uint matchMode;

@property (nonatomic, readwrite) BOOL matchStarted;
@property (nonatomic, readonly) NSInteger score;

//TODO: Can we rely on self.cardsBoundaryView.subviews? Probably keep independent - ex
//  - iterating and removing subviews
//  - gridview enhanced to have other sub views (decorations)
@property(strong, nonatomic) NSMutableArray *cardSubViewsActive;
@property (strong, nonatomic) PlayingCardDeck *playingCardDeck;
@property (strong, nonatomic) SetCardDeck *setCardDeck;

@end

@implementation CardGameViewController {
}

#pragma mark -- Properties

- (uint)numberOfCardsToDeal {
    assert(false); //Subclass must implement
    return 0;
}

- (CGFloat)cellAspectRatio {
    //assert(false); //Subclass must implement
    return 0;
}
- (CardMatchingGame *)game
{
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.numberOfCardsToDeal usingDeck:[self createDeck]];
    }
    return _game;
}

- (uint)selectedMatchModeIndex{
    assert(self.matchModeSegControl.selectedSegmentIndex>=0);
    return (uint) self.matchModeSegControl.selectedSegmentIndex;
}

- (NSMutableArray *)cardSubViewsActive {
    if(!_cardSubViewsActive) {
        _cardSubViewsActive = [NSMutableArray new];
    }
    return _cardSubViewsActive;
}

#pragma mark -- Abstract

- (Deck *)createDeck {
    assert(false); //Subclass must implement
    return nil;
}

- (uint)numberOfCardsToMatch {
    assert(false); //Subclass must implement
    return 0;
}

- (UIView *)createCardViewWith: (Card *)card {
    assert(false); //Subclass must implement
    return nil;
}

+ (NSArray *)matchModeTitles {
    return @[@"Mode 1", @"Mode 2"];
}
#pragma mark -- Others

- (void)redeal {

    if (self.matchStarted) {
        //Any last minute activities on old game - like save high scores, releasing existing
    }

    [self.cardSubViewsActive makeObjectsPerformSelector:@selector(removeFromSuperview)];
//        for(UIView *cardView in self.cardSubViewsActive) {
//            [cardView removeFromSuperview];
//        }
    [self.cardSubViewsActive removeAllObjects];

    //reset game
    self.matchStarted = false;

    //Question: Is a call to release necessary for memory management?
    //CardMatchingGame * prevGame = self.game;
    //[prevGame release];
    self.game = nil;
    [self updateScore];

    //Game reset - enable options available at start such as match mode
    self.matchModeSegControl.enabled = true;

    //Deal the cards
    for (int cardIndex = 0; cardIndex < self.numberOfCardsToDeal; ++cardIndex) {
       Card * card = [self.game cardAtIndex:cardIndex];
       UIView * cardView = [self createCardViewWith:card];
        cardView.tag = (NSInteger) card;//cardIndex; //TODO: Store (address of) the Card object itself
        [self.cardSubViewsActive addObject:cardView];
        [self.cardsBoundaryView addSubview:cardView];

        //TODO: Could this result in a self -reference? or does the implementation use a weak ref?
        [cardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:cardView action:@selector(pinch:)]];
        [cardView addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCard:)]];

        [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];
    }
}

- (IBAction)onTouchRedeal:(UIButton *)sender {
    [self redeal];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray * matchModeTitles = [self.class matchModeTitles];
    for (int titleIndex = 0; titleIndex < matchModeTitles.count; ++titleIndex) {
        [self.matchModeSegControl setTitle:matchModeTitles[titleIndex] forSegmentAtIndex:titleIndex];
    }
    [self redeal];
}

- (void)loadView {
    [super loadView];
    self.cardsBoundaryView.cellAspectRatio = self.cellAspectRatio;
}

- (void)swipeCard:(UISwipeGestureRecognizer *)gestureRecognizer {
    SetCardView *cardSwiped = (SetCardView *) gestureRecognizer.view;
    [cardSwiped resetFaceCardScaleFactor];

    //cardSwiped.contentScaleFactor = 3.5; //TODO: Experimenting  - what impact this has?
}

- (void)tapCard:(UITapGestureRecognizer *)gestureRecognizer {
    SetCardView *cardSwiped = (SetCardView *) gestureRecognizer.view;

    if (!self.matchStarted) { //Once a card is selected - disable options available at start such as match mode
        self.matchStarted = true;
        self.matchModeSegControl.enabled = false;
        self.game.matchMode = self.numberOfCardsToMatch;
    }

    Card * card = [self cardFromTag:cardSwiped.tag];
    //Card * card = (id ) (void*)cardSwiped.tag;

    NSInteger chosenButtonIndex = [self.game indexOfCard:card];//cardSwiped.tag;
    NSLog(@"Chosen card button index: %ld", (long)chosenButtonIndex);
    //[self.game chooseCardAtIndex:chosenButtonIndex withNotification:self] ;
    [self.game chooseCard:card withNotification:self] ;
    [self updateUI];
    //[self animateViewTransitionByFlip:cardSwiped animations:nil];
}

- (Card *)cardFromTag: (NSInteger)tag {
    void *card1 =  (void*)tag;
    __unsafe_unretained Card * card = (__bridge id) card1;
    return card;
}

- (void) updateUI {
    [self updateCardViewsState];
    [self updateScore];
}

- (CardStateType) getCardViewState: (Card *)card {
    CardStateType cardState;
    if (card.isMatched) cardState = CardStateDisabled;
    else if (card.isChosen) cardState = CardStateHighlighted;
    else cardState = CardStateFaceDown;
    return cardState;
}

- (void) updateCardViewsState {
    for(CardView *cardView in self.cardSubViewsActive) {
        //Card * card = [self.game cardAtIndex:cardView.tag];
        Card * card = [self cardFromTag: cardView.tag];
        cardView.cardState = [self getCardViewState:card];
    }
}
- (void)updateScore {
    [self.scoreLabel setAttributedText:[self getScoreText]];
}

- (NSAttributedString *)getScoreText {
    NSMutableAttributedString * attrScoreText = [[NSMutableAttributedString alloc] initWithString:@"Score: "];
    NSDictionary *scoreAttribs = @{ NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
            NSForegroundColorAttributeName: (self.game.score<0)? [UIColor redColor] : [UIColor blackColor]
    };
    NSString * score = [NSString stringWithFormat:@"%ld", (long)self.game.score];
    NSAttributedString * attrScore = [[NSMutableAttributedString alloc] initWithString:score attributes:scoreAttribs];
    [attrScoreText appendAttributedString:attrScore];

    return attrScoreText;

}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Animation

- (void)animateViewTransitionByFlip:(UIView *)view animations:(void (^)()) animations onCompletion:(void (^)())completionBlock
{
    [UIView transitionWithView:view duration:1.0 options: (UIViewAnimationOptionCurveLinear | UIViewAnimationOptionTransitionFlipFromLeft) animations:^{
        if (animations) animations();
    } completion:^(BOOL finished) {
        if(completionBlock) completionBlock();
    }];
}

- (void)animateViewByScaling:(NSArray *)iViews animations:(void (^)()) animations onCompletion:(void (^)())completionBlock
{
    //scale up and down
    UIView * firstView = [iViews firstObject];
    CGSize currBoundsSize = firstView.bounds.size;
    CGSize newBoundsSize = currBoundsSize;
    newBoundsSize.width *= 0.8;//1.20;
    newBoundsSize.height *= 0.8;//1.20;

    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear /*UIViewAnimationOptionAutoreverse*/ animations:^{
        if (animations)
            animations();
        for(UIView * aView in iViews) {
            CGRect newBounds = aView.bounds;
            newBounds.size = newBoundsSize;
            [aView setBounds:newBounds];
        }
    } completion:^(BOOL finished) {
          //        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionAutoreverse animations:^{
//        for(UIView * aView in iViews) {
//            CGRect oldBounds = aView.bounds;
//            oldBounds.size = currBoundsSize;
//            [aView setBounds:oldBounds];
//        }
        //[self updateUI];
        //        } completion:^(BOOL finished) {
        //        }];
        if(completionBlock)
            completionBlock();
    }];
}

- (void)selectionImpactOfCard:(Card *)card chosen:(BOOL)isChosen otherChosenCards:(NSArray *)otherChosenCards impact:(NSInteger)chosenCardsScoreImpact {

    if (!card.isMatched) {
        if (isChosen && chosenCardsScoreImpact > 0) {
            NSMutableArray *selectedCardViews = [NSMutableArray new];
            [selectedCardViews addObject:self.cardSubViewsActive[[self.game indexOfCard:card]]];
            //[self.game indexOfCard:card]];
            for (Card *otherChosenCard in otherChosenCards) {
                [selectedCardViews addObject:self.cardSubViewsActive[[self.game indexOfCard:otherChosenCard]]];
            }
            [self animateViewByScaling:selectedCardViews animations:^{[self updateUI];} onCompletion:nil];
        } else {
            [self animateViewTransitionByFlip:self.cardSubViewsActive[[self.game indexOfCard:card]] animations:^{[self updateUI];} onCompletion:nil];
        }
    }
}

- (void)animateRemovingCards:(NSArray *)cardViewsToRemove {
    [UIView animateWithDuration:1.0 animations:^{
                for (UIView *aView in cardViewsToRemove) {
                    int x = (arc4random() % (int) (self.view.bounds.size.width * 5)) - (int) self.view.bounds.size.width * 2;
                    int y = self.view.bounds.size.height;
                    aView.center = CGPointMake(x, -y);
                }
            }
                     completion:^(BOOL finished) {
                         [cardViewsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                     }];
}

- (void)cardsMatched:(NSArray *)matchedCards {
    NSMutableArray *cardViewsForMatchedCards = [NSMutableArray arrayWithCapacity:matchedCards.count];
    for (Card *card in matchedCards) {
        //[cardViewsForMatchedCards addObject:self.cardSubViewsActive[[self.game indexOfCard:card]]];
        CardView * cardView = [self.cardsBoundaryView viewWithTag:(NSInteger)card];
        [cardViewsForMatchedCards addObject:cardView];
    }
    [self animateViewByScaling:cardViewsForMatchedCards animations:^{
        [self updateUI];
    }             onCompletion:^{[self animateRemovingCards:cardViewsForMatchedCards];}];
}

@end
