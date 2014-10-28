//
//  SetCardView.h
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/23/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SetCardView : UIView

// Properties: Number, Shape, Color, Shading
@property (nonatomic) uint number;
@property (nonatomic) uint shape;
@property (nonatomic) uint shading;
@property (nonatomic) uint color;

@property (nonatomic) BOOL faceUp;

@end
