//
//  HighScoresPlaceHolderViewController.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/21/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "HighScoresViewController.h"
#import "PlayingCardView.h"

@interface HighScoresViewController ()

@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;

@end

@implementation HighScoresViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.playingCardView.rank = 10;
    self.playingCardView.suit = @"♥︎";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
