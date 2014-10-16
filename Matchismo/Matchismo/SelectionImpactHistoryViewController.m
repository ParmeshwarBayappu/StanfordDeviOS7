//
//  SelectionImpactHistoryViewController.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/14/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "SelectionImpactHistoryViewController.h"

@interface SelectionImpactHistoryViewController ()
@property (weak, nonatomic) IBOutlet UITextView *historyTextView;
@end

@implementation SelectionImpactHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSMutableAttributedString * combinedAttrStr = [[NSMutableAttributedString alloc] init];
    
    for (NSAttributedString * attrStr in self.attributedSelectionHistory) {
        [combinedAttrStr appendAttributedString:attrStr];
        [combinedAttrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n"]];
    }
    
    [self.historyTextView setAttributedText:combinedAttrStr];
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
