//
// Created by Parmesh Bayappu on 11/7/14.
// Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, CardStateType) {
  CardStateFaceDown, CardStateNormal, CardStateHighlighted, CardStateDisabled
};

@interface CardView : UIView

@property (nonatomic) CGFloat faceCardScaleFactor;  // later rename to cardImageScaleFactor
@property (nonatomic, readonly) CGFloat cornerRadius;
@property (nonatomic, readonly) CGFloat cornerOffset;
@property (nonatomic, readonly) BOOL faceUp;
@property (nonatomic) CardStateType cardState;

+ (NSString *)backgroundImageName; //override in subclass if different image desired

- (void)resetFaceCardScaleFactor;

- (CGFloat)cornerScaleFactor;

- (void)drawCardBackgroundAndSetClip;

- (CGRect)scaledCardContentsRect;

- (void)drawCardContents:(CGRect)rect;  //override in derived class

- (void)pinch:(UIPinchGestureRecognizer *)gesture;

@end