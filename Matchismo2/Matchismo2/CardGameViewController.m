//
//  CardGameViewController.m
//  Matchismo2
//
//  Created by Parmesh Bayappu on 11/5/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "CardGameViewController.h"
#import "SetCardView.h"
#import "GridView.h"
#import "PlayingCardDeck.h"
#import "SetCardDeck.h"
#import "CardMatchingGame.h"

@interface CardGameViewController ()

//UI Properties
@property(weak, nonatomic) IBOutlet UISegmentedControl *matchModeSegControl;
@property(weak, nonatomic) IBOutlet UIButton *redealButton;
@property(weak, nonatomic) IBOutlet GridView *cardsBoundaryView;
@property(weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property(weak, nonatomic) IBOutlet UIButton *moreCardsButton;

@property(strong, nonatomic) CardMatchingGame *game;

@property(nonatomic, readwrite) BOOL matchActionStarted; //Tracks if any action started in game - to determine options that should be enabled/disabled
@property(nonatomic, readonly) NSInteger score;

@property(nonatomic) NSMutableDictionary *dictionaryOfCardsWithAddressAsKey;
@property(strong, nonatomic) PlayingCardDeck *playingCardDeck;
@property(strong, nonatomic) SetCardDeck *setCardDeck;
@property (strong, nonatomic) UIDynamicAnimator *animator;
@property (strong, nonatomic) UIPushBehavior *pushBehavior;
@property (strong, nonatomic) UICollisionBehavior *collisionBehavior;
@property (strong, nonatomic) UIAttachmentBehavior *attachmentBehavior;
@property(strong, nonatomic)  UIPanGestureRecognizer *panGestureRecognizer;
@property(nonatomic) BOOL panGestureEnabled;

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

- (CardMatchingGame *)game {
    if (!_game) {
        _game = [[CardMatchingGame alloc] initWithCardCount:self.numberOfCardsToDeal usingDeck:[self createDeck]];
        _game.notificationsDelegate = self;
    }
    return _game;
}

- (NSMutableDictionary *)dictionaryOfCardsWithAddressAsKey {
    if (!_dictionaryOfCardsWithAddressAsKey) {
        _dictionaryOfCardsWithAddressAsKey = [NSMutableDictionary new];
    }
    return _dictionaryOfCardsWithAddressAsKey;
}

- (UIDynamicAnimator *)animator {
    if(!_animator) {
        _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardsBoundaryView];
        _animator.delegate = self;
    }
    return _animator;
}

- (UIPushBehavior *)pushBehavior {
    if(!_pushBehavior) {
        _pushBehavior = [[UIPushBehavior alloc] initWithItems:nil mode:UIPushBehaviorModeInstantaneous];
        [self.animator addBehavior:_pushBehavior];
    }
    return _pushBehavior;
}

- (UICollisionBehavior *)collisionBehavior {
    if(!_collisionBehavior) {
        _collisionBehavior = [[UICollisionBehavior alloc] init];
        _collisionBehavior.collisionMode = UICollisionBehaviorModeBoundaries;
        [self.animator addBehavior:_collisionBehavior];
        [_collisionBehavior setTranslatesReferenceBoundsIntoBoundary:TRUE];
    }
    return _collisionBehavior;
}

- (uint)selectedMatchModeIndex {
    assert(self.matchModeSegControl.selectedSegmentIndex >= 0);
    return (uint) self.matchModeSegControl.selectedSegmentIndex;
}


- (void)setMatchActionStarted:(BOOL)matchActionStarted {
    if (matchActionStarted) {
        //Game started - disable options available at start such as match mode
        self.matchModeSegControl.enabled = false;
        self.game.matchMode = self.numberOfCardsToMatch;

    } else {
        //Game reset - enable options available at start such as match mode
        self.matchModeSegControl.enabled = true;
    }
    _matchActionStarted = matchActionStarted;
}

- (UIPanGestureRecognizer *)panGestureRecognizer {
    if( !_panGestureRecognizer) {
        _panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panCards:)];
    }
    return _panGestureRecognizer;
}

- (void)setPanGestureEnabled:(BOOL)panGestureEnabled {
    if(panGestureEnabled) {
        [self.cardsBoundaryView addGestureRecognizer:self.panGestureRecognizer];
    } else {
        [self.cardsBoundaryView removeGestureRecognizer:self.panGestureRecognizer];
    }
    _panGestureEnabled = panGestureEnabled;
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

- (CardView *)createCardViewWith:(Card *)card {
    assert(false); //Subclass must implement
    return nil;
}

+ (NSArray *)matchModeTitles {
    return @[@"Mode 1", @"Mode 2"];
}

#pragma mark -- Others

//Cleanup current game and start new game
- (void)startNewGame {
    if (self.matchActionStarted) {
        //Perform any last minute activities on old game - like save high scores, releasing existing
    }

    self.game = nil; //Reset - Game
    [self cardsRemoved:[self.dictionaryOfCardsWithAddressAsKey allValues]
          onCompletion:^{
              [self startGame];
          }
    ];
}

//Deal all the cards and enable initial options
- (void)startGame {
    self.matchActionStarted = false;  // no action yet

    [self updateScore];
    //[UIView transitionWithView:self.cardsBoundaryView duration:1.0 options:UIViewAnimationOptionTransitionFlipFromRight
    //                animations:^{
                        [self cardsAdded:[self.game cards]];
    //                }
    //                completion:^(BOOL finished){}
    //];
}

#pragma  mark -- Dictionary Card<-->CardView

- (void)addCardToDictionary:(Card *)card {
    NSInteger cardAddressAsInteger = (NSInteger) card;
    [self.dictionaryOfCardsWithAddressAsKey setObject:card forKey:@(cardAddressAsInteger)];
}

- (void)removeCardFromDictionary:(Card *)card {
    NSInteger cardAddressAsInteger = (NSInteger) card;
    [self.dictionaryOfCardsWithAddressAsKey removeObjectForKey:@(cardAddressAsInteger)];
}

- (CardView *)viewForCard:(Card *)card {
    NSInteger cardAddressAsInteger = (NSInteger) card;
    return (CardView *) [self.cardsBoundaryView viewWithTag:cardAddressAsInteger];
}

- (Card *)cardForView:(CardView *)cardView {
    NSNumber *cardAddressAsNumber = @(cardView.tag);
    return [self.dictionaryOfCardsWithAddressAsKey objectForKey:cardAddressAsNumber];
}

- (void)linkCard:(Card *)card toCardView:(CardView *)cardView {
    cardView.tag = (NSInteger) card;
    [self addCardToDictionary:card];
}

- (void)unLinkCardFromCardView:(CardView *)cardView {
    Card *card = [self cardForView:cardView];
    [self removeCardFromDictionary:card];
}

- (IBAction)onTouchRedeal:(UIButton *)sender {
    [self startNewGame];
}

- (IBAction)onTouchMoreCards:(UIButton *)sender {
    uint const addlCardsDrawn = [self.game drawAdditionalCards:self.numberOfCardsToMatch];
    assert(addlCardsDrawn > 0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    NSArray *matchModeTitles = [self.class matchModeTitles];
    for (int titleIndex = 0; titleIndex < matchModeTitles.count; ++titleIndex) {
        [self.matchModeSegControl setTitle:matchModeTitles[titleIndex] forSegmentAtIndex:titleIndex];
    }
    //add pinch gesture recognizer to initiate piling together cards
    [self.cardsBoundaryView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)]];

    [self startNewGame];
}

- (IBAction)panCards:(UIPanGestureRecognizer *)sender {
    CGPoint gesturePoint = [sender locationInView:self.cardsBoundaryView];

    if (sender.state == UIGestureRecognizerStateBegan) {
        [self attachCardsToPoint:gesturePoint];
    } else if (sender.state == UIGestureRecognizerStateChanged) {
        self.attachmentBehavior.anchorPoint = gesturePoint;
    } else if (sender.state == UIGestureRecognizerStateEnded) {
        [self.animator removeAllBehaviors];
    }
}

- (void)attachCardsToPoint:(CGPoint)anchorPoint {
    NSArray *cardViews = self.cardsBoundaryView.subviews;
    assert(cardViews.count>0);    // Convert to if

    UIView * firstView = [cardViews firstObject];
    //Create an attachment behaviour for the first card
    self.attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:firstView attachedToAnchor:anchorPoint];
    [self.animator addBehavior:self.attachmentBehavior];

    //Attach the other cards
    for(UIView *cardView in self.cardsBoundaryView.subviews) {
        if( cardView != firstView) {
            UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:firstView attachedToItem:cardView];
            [self.animator addBehavior:attachmentBehavior];
        }
    }
}

- (void)pinch:(UIPinchGestureRecognizer *)gestureRecognizer {
    [self pinch1:gestureRecognizer];
}

// Moves the cards closer to the center of the pinch and at the end of the pinch enables the pan gesture
- (void)pinch1:(UIPinchGestureRecognizer *)gestureRecognizer {
    if( gestureRecognizer.state == UIGestureRecognizerStateChanged) {
        CGFloat scale = gestureRecognizer.scale;
        CGPoint gestureCenter =  [gestureRecognizer locationInView:self.cardsBoundaryView];
        //CGSize boundsSize = self.cardsBoundaryView.bounds.size;

        NSArray *cardViews = self.cardsBoundaryView.subviews;
        for(CardView *cardView in cardViews) {
            CGPoint viewCurrCenter = cardView.center;
            CGFloat viewX = gestureCenter.x+(viewCurrCenter.x - gestureCenter.x)*scale;
            CGFloat viewY = gestureCenter.y+(viewCurrCenter.y - gestureCenter.y)*scale;

            //viewX = MIN(MAX(0, viewX), boundsSize.width);
            //viewY = MIN(MAX(0, viewY), boundsSize.height);

            cardView.center = CGPointMake(viewX, viewY);
        }
        gestureRecognizer.scale = 1;

    } else if( gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        //Enable pan gesture
        self.panGestureEnabled = true;
    } else if (gestureRecognizer.state == UIGestureRecognizerStateCancelled) {
        [self.cardsBoundaryView setNeedsLayout];
    }
}

// All cards moved to the center of the enclosing view
- (void)pinch2:(UIPinchGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        [UIView animateWithDuration:3.0
                         animations:^{
                             CGPoint superViewCenter = CGPointMake(self.cardsBoundaryView.bounds.size.width/2, self.cardsBoundaryView.bounds.size.height/2);
                             NSArray *cardViews = self.cardsBoundaryView.subviews;
                             for(CardView *cardView in cardViews) {
                                cardView.center = superViewCenter;
                             }
                         }
        ];
        //Enable pan gesture
        self.panGestureEnabled = true;
    }
}

// The idea was to get each card to get an individual push force towards the center of the pinch - but this has not
// worked well so far
- (void)pinch3:(UIPinchGestureRecognizer *)gestureRecognizer {
      self.scoreLabel.text = @"pinch recog";
    if (/*(gestureRecognizer.state == UIGestureRecognizerStateChanged) ||*/
            (gestureRecognizer.state == UIGestureRecognizerStateEnded)) {

        //CardView *cardView = [self viewForCard:[self.dictionaryOfCardsWithAddressAsKey allValues][0]];
        //Identify amount and direction of push
        //CGPoint gestureCenter = [gestureRecognizer locationInView:self.cardsBoundaryView];
        //CGPoint cardViewCenter = cardView.center;
        //CGFloat gestureSlopeSum =  ABS(gestureCenter.x - cardViewCenter.x) + ABS( gestureCenter.y - cardViewCenter.y);
        //[self.pushBehavior setAngle:M_PI_4 magnitude:0.1];
        //[self.pushBehavior setMagnitude:1];
        //[self.pushBehavior setPushDirection:CGVectorMake(gestureCenter.x - cardViewCenter.x, gestureCenter.y - cardViewCenter.y)];

        CGFloat velocity = [gestureRecognizer velocity];
        CGFloat magnitude = velocity/35;
        //pushBehavior.pushDirection = CGVectorMake((velocity.x / 10) , (velocity.y / 10));
        self.pushBehavior.magnitude = magnitude;

        [self.pushBehavior setPushDirection:CGVectorMake(-1.0, -1.0)];

        for(CardView *cardView in [self cardViewsForCards:[self.dictionaryOfCardsWithAddressAsKey allValues]]) {

            [self.collisionBehavior addItem:cardView];
            [self.pushBehavior addItem:cardView];

            //[self.animator updateItemUsingCurrentState:cardView];
        }
        [self.animator addBehavior:self.collisionBehavior];
        [self.animator addBehavior:self.pushBehavior];
        self.pushBehavior.active = true;
        //Enable pan gesture
        self.panGestureEnabled = true;
    }
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

-(void)animateCardViewsRestoration {
    [UIView animateWithDuration:2.0 delay:0.0 options:UIViewAnimationOptionCurveLinear /*UIViewAnimationOptionAutoreverse*/
                     animations:^{
                         //[self.cardsBoundaryView setNeedsLayout];
                         [self.cardsBoundaryView setupSubViewFrames];
                     }
                     completion:^(BOOL finished) {
                     }
    ];

}

- (void)tapCard:(UITapGestureRecognizer *)gestureRecognizer {
    
    if(self.panGestureEnabled){
        self.panGestureEnabled = false;
        [self animateCardViewsRestoration];
        return;
    }
    
    SetCardView *cardSwiped = (SetCardView *) gestureRecognizer.view;

    if (!self.matchActionStarted) { //Once a card is selected - disable options available at start such as match mode
        self.matchActionStarted = true;
    }

    Card *card = [self cardForView:cardSwiped];

    //Debug code - begin
    NSInteger chosenButtonIndex = [self.game indexOfCard:card];//cardSwiped.tag;
    NSLog(@"Chosen card button index: %ld", (long) chosenButtonIndex);
    //Debug code - end

    //[self.game chooseCardAtIndex:chosenButtonIndex withNotification:self] ;
    [self.game chooseCard:card withNotification:self];
    [self updateUI];
    //[self animateViewTransitionByFlip:cardSwiped animations:nil];
}

- (void)updateUI {
    [self updateCardViewsState];
    [self updateScore];
}

- (CardStateType)getCardViewState:(Card *)card {
    CardStateType cardState;
    if (card.isMatched) cardState = CardStateDisabled;
    else if (card.isChosen) cardState = CardStateHighlighted;
    else cardState = CardStateFaceDown;
    return cardState;
}

- (void)updateCardViewsState {
    for (Card *card in [self.dictionaryOfCardsWithAddressAsKey allValues]) {
        CardView *cardView = [self viewForCard:card];
        cardView.cardState = [self getCardViewState:card];
    }
}

- (void)updateScore {
    [self.scoreLabel setAttributedText:[self getScoreText]];
}

- (NSAttributedString *)getScoreText {
    NSMutableAttributedString *attrScoreText = [[NSMutableAttributedString alloc] initWithString:@"Score: "];
    NSDictionary *scoreAttribs = @{NSFontAttributeName : [UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
            NSForegroundColorAttributeName : (self.game.score < 0) ? [UIColor redColor] : [UIColor blackColor]
    };
    NSString *score = [NSString stringWithFormat:@"%ld", (long) self.game.score];
    NSAttributedString *attrScore = [[NSMutableAttributedString alloc] initWithString:score attributes:scoreAttribs];
    [attrScoreText appendAttributedString:attrScore];

    return attrScoreText;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -- Animation

- (void)animateViewTransitionByFlip:(UIView *)view animations:(void (^)())animations onCompletion:(void (^)())completionBlock {
    [UIView transitionWithView:view duration:1.0 options:(UIViewAnimationOptionCurveLinear | UIViewAnimationOptionTransitionFlipFromLeft) animations:^{
        if (animations) animations();
    }               completion:^(BOOL finished) {
        if (completionBlock) completionBlock();
    }];
}

+ (void)animateViewByScaling:(NSArray *)iViews animations:(void (^)())animations onCompletion:(void (^)())completionBlock {
    //scale up and down
    UIView *firstView = [iViews firstObject];
    CGSize currBoundsSize = firstView.bounds.size;
    CGSize newBoundsSize = currBoundsSize;
    newBoundsSize.width *= 0.8;//1.20;
    newBoundsSize.height *= 0.8;//1.20;

    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear /*UIViewAnimationOptionAutoreverse*/
                     animations:^{
                         if (animations)
                             animations();
                         for (UIView *aView in iViews) {
                             CGRect newBounds = aView.bounds;
                             newBounds.size = newBoundsSize;
                             [aView setBounds:newBounds];
                         }
                     }
                     completion:^(BOOL finished) {
                         if (completionBlock)
                             completionBlock();
                     }
    ];
}

- (void)animateRemovingCards:(NSArray *)cardViewsToRemove onCompletion:(void (^)(BOOL finished))completionBlock {
    [UIView animateWithDuration:1.0 delay:0.0 options:0
                     animations:^{
                         //TODO: This animation was previously moving cards out of the visible view thru animation - but is doing the reverse
                         // now - unexpected. Compare with previous code. Now it is working again. A mystery!
                         //TODO: Checkout implode option too
                         for (UIView *aView in cardViewsToRemove) {
                             int x = (arc4random() % (int) (self.view.bounds.size.width * 5)) - (int) self.view.bounds.size.width * 2;
                             int y = self.view.bounds.size.height;
                             aView.center = CGPointMake(x, -y);
                         }
                     }
                     completion:^(BOOL finished) {
                         [cardViewsToRemove enumerateObjectsUsingBlock:^(CardView *cardViewToRemove, NSUInteger idx, BOOL *stop) {
                             [self unLinkCardFromCardView:cardViewToRemove];
                             [cardViewToRemove removeFromSuperview];
                         }];
                         //[cardViewsToRemove makeObjectsPerformSelector:@selector(removeFromSuperview)];
                         if (completionBlock) completionBlock(finished);
                     }];
}

 -(void)dynamicAnimatorDidPause:(UIDynamicAnimator *)animator {

     NSArray *cardViews = [self.pushBehavior items];
     for(UIView * cardView in cardViews) [self.pushBehavior removeItem:cardView];
     self.pushBehavior.active = false;

     NSArray *cardViews1 = [self.collisionBehavior items];
     for(UIView * cardView in cardViews1) [self.collisionBehavior removeItem:cardView];

     self.panGestureEnabled = true;

 }

#pragma mark -- CardGameNotifications

- (void)selectionImpactOfCard:(Card *)card chosen:(BOOL)isChosen otherChosenCards:(NSArray *)otherChosenCards impact:(NSInteger)chosenCardsScoreImpact {
    if (!card.isMatched) {
        if (isChosen && chosenCardsScoreImpact > 0) {
            NSMutableArray *selectedCardViews = [NSMutableArray new];
            [selectedCardViews addObject:[self viewForCard:card]];
            //[self.game indexOfCard:card]];
            for (Card *otherChosenCard in otherChosenCards) {
                [selectedCardViews addObject:[self viewForCard:otherChosenCard]];
            }
            [self.class animateViewByScaling:selectedCardViews animations:^{
                [self updateUI];
            }                   onCompletion:nil];
        } else {
            [self animateViewTransitionByFlip:[self viewForCard:card] animations:^{
                [self updateUI];
            }                    onCompletion:nil];
        }
    }
}

- (void)cardsMatched:(NSArray *)matchedCards {
    NSMutableArray *cardViewsForMatchedCards = [NSMutableArray arrayWithCapacity:matchedCards.count];
    for (Card *card in matchedCards) {
        //[cardViewsForMatchedCards addObject:self.cardSubViewsActive[[self.game indexOfCard:card]]];
        CardView *cardView = (CardView *) [self.cardsBoundaryView viewWithTag:(NSInteger) card];
        [cardViewsForMatchedCards addObject:cardView];
    }
    [self.class animateViewByScaling:cardViewsForMatchedCards animations:^{
        [self updateUI];
    }                   onCompletion:nil/*^{[self animateRemovingCards:cardViewsForMatchedCards];}*/];
}

- (void)cardsRemoved:(NSArray *)removedCards {
    [self cardsRemoved:removedCards onCompletion:nil];
}

- (void)cardsRemoved:(NSArray *)removedCards onCompletion:(void (^)())completionBlock {
    NSArray *cardViewsForRemovedCards = [self cardViewsForCards:removedCards];
    [self.class animateViewByScaling:cardViewsForRemovedCards animations:^{
        [self updateUI];
    }                   onCompletion:^{
        [self animateRemovingCards:cardViewsForRemovedCards onCompletion:^(BOOL completed) {
            if (completionBlock) completionBlock();
        }];

    }];
}

- (void)cardsAdded:(NSArray *)addedCards {

    //Deal the added cards
    for (Card *card in addedCards) {
        CardView *cardView = [self createCardViewWith:card];
        cardView.cardState = [self getCardViewState:card];
        [self linkCard:card toCardView:cardView];
        [self.cardsBoundaryView addSubview:cardView];
        //TODO: Could this result in a self -reference? or does the implementation use a weak ref?
        //[cardView addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:cardView action:@selector(pinch:)]];
        [cardView addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCard:)]];

        [cardView addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCard:)]];

        [UIView animateWithDuration:2.0 delay:0.0 options:0
                         animations:^{
                             int x = arc4random_uniform(self.cardsBoundaryView.bounds.size.width);//(arc4random() % (int) (self.view.bounds.size.width * 5)) - (int) self.view.bounds.size.width * 2;
                             int y = -self.cardsBoundaryView.bounds.size.height;//self.view.bounds.size.height;
                             cardView.center = CGPointMake(x, y);
                         }
                         completion:nil];
    }

    [self.moreCardsButton setEnabled:self.game.additionalCardsAvailable];
}

- (NSArray *)cardViewsForCards:(NSArray *)cards {
    NSMutableArray *cardViews = [NSMutableArray arrayWithCapacity:cards.count];
    for (Card *card in cards) {
        [cardViews addObject:[self viewForCard:card]];
    }
    return [cardViews copy]; //Non-mutable copy?
}

@end
