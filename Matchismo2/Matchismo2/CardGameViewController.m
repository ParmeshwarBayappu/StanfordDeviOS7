//
//  CardGameViewController.m
//  Matchismo2
//
//  Created by Parmesh Bayappu on 11/5/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "CardGameViewController.h"
#import "PlayingCardView.h"
#import "GridView.h"

@interface CardGameViewController ()

@property (strong, nonatomic) NSMutableArray *cardSubViewsActive;
//@property (strong, nonatomic) NSArray *cardSubViewsAll;

@property (weak, nonatomic) IBOutlet GridView *cardsBoundaryView;

@end

@implementation CardGameViewController {
    NSArray *_cardSubViewsAll;
}

- (IBAction)onTouchRedeal:(UIButton *)sender {
    if(self.cardSubViewsActive.count) {
        UIView *viewToRemove = self.cardSubViewsActive[arc4random_uniform((uint)self.cardSubViewsActive.count)];
        //[self.cardsBoundaryView removeCardSubView:viewToRemove];
        [viewToRemove removeFromSuperview];
        [self.cardSubViewsActive removeObject:viewToRemove];
    } else {
        self.cardSubViewsActive = [_cardSubViewsAll mutableCopy];
        //[self.cardsBoundaryView setCellSubViews:self.cardSubViewsActive];
        for(UIView *cardView in self.cardSubViewsActive) {
            [self.cardsBoundaryView addSubview:cardView];
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
}

- (void)loadView {
    [super loadView];

    uint numberOfCells = 9;
    NSMutableArray *cardViews = [[NSMutableArray alloc] initWithCapacity:numberOfCells];
    for (uint viewIndex =0; viewIndex < numberOfCells; viewIndex++) {
        PlayingCardView * card = [[PlayingCardView alloc] init];  //initWithFrame?
        card.rank = viewIndex%3+11;//viewIndex%13+1;
        card.suit = @"♥";
        card.faceUp = true;
        [cardViews addObject:card];

        //TODO: Could this result in a self -reference? or does the implementation use a weak ref?
        [card addGestureRecognizer:[[UIPinchGestureRecognizer alloc] initWithTarget:card action:@selector(pinch:)]];
        [card addGestureRecognizer:[[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(swipeCard:)]];
    }
    _cardSubViewsAll = [cardViews copy];//returns immutable copy
    self.cardsBoundaryView.cellAspectRatio = 9.0/16;
}

- (void)swipeCard: (UISwipeGestureRecognizer *)gestureRecognizer  {
    PlayingCardView * cardSwiped = (PlayingCardView *) gestureRecognizer.view;
    cardSwiped.faceUp = !cardSwiped.faceUp;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
