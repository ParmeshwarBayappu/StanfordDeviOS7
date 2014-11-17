//
//  GridView.h
//  Matchismo2
//
//  Created by Parmesh Bayappu on 11/5/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GridView : UIView

@property (nonatomic) CGFloat cellAspectRatio;

- (void)setupSubViewFrames;  //Created to expose behaviour directly for animation purpose in controller
@end
