//
//  HighScoresManager.h
//  Matchismo
//
//  Created by Parmesh Bayappu on 11/3/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ScoreEntry.h"


@interface HighScoresManager : NSObject

@property (nonatomic, readonly) NSArray *highScores;
@property (readonly) ScoreEntry * highestScore;
@property (readonly) ScoreEntry * leastDuration;
@property (readonly) ScoreEntry * latestWhen;

- (void)addScore:(ScoreEntry *)iScoreEntry;
- (NSArray *)highScoresSortedByScore;

+ (HighScoresManager *)instance;

- (NSArray *)highScoresSortedByDuration;
- (NSArray *)highScoresSortedByWhen;

@end
