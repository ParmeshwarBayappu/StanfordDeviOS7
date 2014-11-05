//
//  Constants.h
//  Matchismo
//
//  Created by Parmesh Bayappu on 11/4/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Constants : NSObject

extern NSString * const kScoreKey;

+ (NSString *)kDurationKey;

@property (readonly) NSString *kWhenKey;

//TODO isPlayingCardGame
@end

//extern Constants * const TheConstants;  //Error: initializer element is not a compile-time constant

extern NSString *const kIsPlayingCardGameKey;