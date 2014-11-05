//
//  ScoreEntry.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 11/3/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "ScoreEntry.h"
#import "Constants.h"

@implementation ScoreEntry {

}

//- (instancetype)init {
//    return [super init];
//}
//
//- (instancetype)initWithCapacity:(NSUInteger)numItems {
//    //return [super initWithCapacity:numItems];
//    return [super init];
//}
//
//- (instancetype)initWithCoder:(NSCoder *)coder {
//    return [super initWithCoder:coder];
//}

//
//- (int)score {
//    return [[self objectForKey:kScoreKey] intValue];
//}
//
//- (void)setScore:(int)score {
//    [self setObject:[NSNumber numberWithInt:score] forKey:kScoreKey];
//}
//
//- (int)duration {
//    return [[self objectForKey:[Constants kDurationKey]] intValue];
//
//}
//- (void)setDuration:(int)duration {
//    [self setObject:[NSNumber numberWithInt:duration] forKey:[Constants kDurationKey]];
//}
//
//- (NSDate *)when {
//    return [self objectForKey:[Constants new].kWhenKey];
//}
//
//- (void)setWhen:(NSDate *)when {
//    [self setObject:when forKey:[Constants new].kWhenKey];
//}
//
//- (BOOL)isPlayingCard {
//    return [[self objectForKey:kIsPlayingCardGameKey] boolValue];
//}
//
//- (void)setIsPlayingCard:(BOOL)isPlayingCard {
//    [self setObject:[NSNumber numberWithBool:isPlayingCard] forKey:kIsPlayingCardGameKey];
//}

- (NSDictionary *)toDictionary
{
    NSDictionary * dict= @{
                           kScoreKey: @(self.score)
                           , [Constants kDurationKey]: @(self.duration)
                           , [Constants new].kWhenKey: self.when
                           , kIsPlayingCardGameKey: @(self.isPlayingCard)
                           };
    return dict;
}

- (void)fromDictionary:(NSDictionary *)dict
{
    self.score = [(NSNumber *)[dict valueForKey:kScoreKey] intValue];
    self.duration = [(NSNumber *)[dict valueForKey:[Constants kDurationKey]] intValue];
    self.when = (NSDate *)[dict valueForKey:[Constants new].kWhenKey];
    self.isPlayingCard = [(NSNumber *)[dict valueForKey:kIsPlayingCardGameKey] boolValue];

    //[self setDictionary:dict];
}


- (NSInteger)compareScore: (ScoreEntry *)otherItem {
    if(self.score < otherItem.score) return NSOrderedAscending;
    else if(self.score == otherItem.score) return NSOrderedSame;
    else return NSOrderedDescending;
}

- (NSInteger)compareDuration: (ScoreEntry *)otherItem {
    //return [self compareInteger:otherItem withField:@selector(duration)];
    if(self.duration < otherItem.duration) return NSOrderedAscending;
    else if(self.duration == otherItem.duration) return NSOrderedSame;
    else return NSOrderedDescending;
}

- (NSInteger) compareInteger: (ScoreEntry *)otherItem withField:(SEL)getField {
    int value1 = (int) [self performSelector:getField]; //Warning: performSelector may cause a leak because its selector is unknown
    int value2 = (int) [otherItem performSelector:getField];

    if(value1 < value2) return NSOrderedAscending;
    else if(value1 == value2) return NSOrderedSame;
    else return NSOrderedDescending;
}


- (NSInteger)compareWhen: (ScoreEntry *)otherItem {
    if(self.when < otherItem.when) return NSOrderedAscending;
    else if(self.score == otherItem.score) return NSOrderedSame;
    else return NSOrderedDescending;
}

#pragma mark --initializer
- (instancetype)initWithDictionary:(NSDictionary *)dictionary {
    self = [super init];
    if(self) {
        [self fromDictionary:dictionary];
    }
    return self;
}

- (instancetype)initWithScore:(int)iScore duration:(int)iDuration when:(NSDate *)iWhen isPlayingCard:(BOOL)iIsPlayingCard {
    self = [super init];
    if(self) {
        self.score = iScore;
        self.duration = iDuration;
        self.when = iWhen;
        self.isPlayingCard = iIsPlayingCard;
    }
    return self;
}

@end
