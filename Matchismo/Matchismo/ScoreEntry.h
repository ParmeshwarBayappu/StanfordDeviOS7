//
//  ScoreEntry.h
//  Matchismo
//
//  Created by Parmesh Bayappu on 11/3/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ScoreEntry : NSObject

@property(nonatomic) int score;
@property int duration;
@property NSDate *when;
@property BOOL isPlayingCard;

- (NSDictionary *) toDictionary;
- (void) fromDictionary: (NSDictionary *) dict;

- (instancetype)initWithDictionary:(NSDictionary *)dictionary;

- (instancetype)initWithScore:(int)iScore duration:(int)iDuration when:(NSDate *)iWhen isPlayingCard:(BOOL)iIsPlayingCard;

- (NSInteger)compareScore:(ScoreEntry *)otherItem;
- (NSInteger)compareDuration:(ScoreEntry *)otherItem;
- (NSInteger)compareWhen:(ScoreEntry *)otherItem;

@end
