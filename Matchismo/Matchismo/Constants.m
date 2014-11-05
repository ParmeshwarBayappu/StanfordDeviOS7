//
//  Constants.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 11/4/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "Constants.h"

@implementation Constants

NSString * const kScoreKey = @"score";

+ (NSString *)kDurationKey
{
    return @"duration";
}

- (NSString *)kWhenKey
{
    return @"when";
}

@end

//Constants * const TheConstants = [Constants new]; //Error: initializer element is not a compile-time constant

NSString *const kIsPlayingCardGameKey = @"isPlayingCardGame";