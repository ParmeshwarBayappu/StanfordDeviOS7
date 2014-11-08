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
        cardView.tag = cardIndex;
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

    [self redeal];
}

- (void)loadView {
    [super loadView];
    self.cardsBoundaryView.cellAspectRatio = self.cellAspectRatio;
}

- (void)swipeCard:(UISwipeGestureRecognizer *)gestureRecognizer {
    SetCardView *cardSwiped = (SetCardView *) gestureRecognizer.view;
    cardSwiped.faceUp = !cardSwiped.faceUp;
}

- (void)tapCard:(UITapGestureRecognizer *)gestureRecognizer {
    SetCardView *cardSwiped = (SetCardView *) gestureRecognizer.view;
    cardSwiped.faceUp = !cardSwiped.faceUp;

    if (!self.matchStarted) { //Once a card is selected - disable options available at start such as match mode
        self.matchStarted = true;
        self.matchModeSegControl.enabled = false;
        self.game.matchMode = self.numberOfCardsToMatch;
    }

    NSInteger chosenButtonIndex = cardSwiped.tag;
    NSLog(@"Chosen card button index: %ld", (long)chosenButtonIndex);
    [self.game chooseCardAtIndex:chosenButtonIndex] ;
    [self updateScore];
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

@end
