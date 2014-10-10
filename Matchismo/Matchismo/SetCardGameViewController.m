//
//  PlayingCardGame2ViewController.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/10/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController

// override base class abstract impl
- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

// override base class abstract impl
-(uint)matchMode
{
    return 3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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
