//
//  PlayingCardView.h
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/21/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlayingCardView : UIView

@property (nonatomic) NSUInteger rank;
@property (nonatomic) NSString *suit;
@property (nonatomic) BOOL faceUp;
@end
