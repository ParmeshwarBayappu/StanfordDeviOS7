//
// Created by Parmesh Bayappu on 11/7/14.
// Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface CardView : UIView

@property (nonatomic) CGFloat faceCardScaleFactor;  // later rename to cardImageScaleFactor
@property (nonatomic, readonly) CGFloat cornerRadius;
@property (nonatomic, readonly) CGFloat cornerOffset;
@property (nonatomic) BOOL faceUp;

+ (NSString *)backgroundImageName; //override in subclass if different image desired

- (CGFloat)cornerScaleFactor;

- (void)drawCardBackgroundAndSetClip;

- (CGRect)scaledCardContentsRect;

- (void)drawCardContents:(CGRect)rect;  //override in derived class

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end