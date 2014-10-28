//
//  MyBezierPathView.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/28/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "MyBezierPathView.h"

@implementation MyBezierPathView

- (void)setBezierPath:(UIBezierPath *)bezierPath
{
    _bezierPath = bezierPath;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect {
    // Drawing code
    //if(self.bezierPath)
        [self.bezierPath stroke];
}

@end
