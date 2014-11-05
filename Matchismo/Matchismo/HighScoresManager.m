//
//  HighScoresManager.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 11/3/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "HighScoresManager.h"

@interface HighScoresManager()

@property (nonatomic,readonly) NSUserDefaults *userDefaults;
@property (nonatomic,strong) NSMutableArray *internalHighScores;

@end

@implementation HighScoresManager

- (NSUserDefaults *) userDefaults
{
    return [NSUserDefaults standardUserDefaults];
}

- (NSArray *)highScores
{
    return self.internalHighScores; //TODO: Is it Ok to retun?
}

- (ScoreEntry *)highestScore {
    ScoreEntry * aHighestScoreEntry = nil;

    for (ScoreEntry * aEachEntry in self.internalHighScores) {
        if(!aHighestScoreEntry || aHighestScoreEntry.score < aEachEntry.score) {
            aHighestScoreEntry = aEachEntry;
        }
    }
    return aHighestScoreEntry;
}

- (ScoreEntry *)leastDuration {
    ScoreEntry * aLeastDurationEntry = nil;

    for (ScoreEntry * aEachEntry in self.internalHighScores) {
        if(!aLeastDurationEntry || aLeastDurationEntry.duration > aEachEntry.duration) {
            aLeastDurationEntry = aEachEntry;
        }
    }
    return aLeastDurationEntry;
}

- (ScoreEntry *)latestWhen {
    ScoreEntry * aLatestWhenEntry = nil;

    for (ScoreEntry * aEachEntry in self.internalHighScores) {
        if(!aLatestWhenEntry || aLatestWhenEntry.when < aEachEntry.when) {
            aLatestWhenEntry = aEachEntry;
        }
    }
    return aLatestWhenEntry;
}


- (NSMutableArray *)internalHighScores
{
    if(!_internalHighScores) {
        _internalHighScores = [NSMutableArray new];
        
    }
    return _internalHighScores;
}

- (NSMutableArray *)internalHighScoresForStorage
{
    NSMutableArray * highScoresStorage = [NSMutableArray new];
    for (ScoreEntry *aScoreEntry in self.highScores) {
        [highScoresStorage addObject:[aScoreEntry toDictionary]];
    }
    return highScoresStorage;

    //return _internalHighScores;
}

- (void)updateToUserDefaults
{
    [[self userDefaults] setObject:[self internalHighScoresForStorage] forKey:@"High Scores"];
}

-(void)addScore:(ScoreEntry *) iScoreEntry
{
    // if not too many items add this entry
    // if too many items and this entry score higher than any existing
    //   remove least
    //   add entry

    u_long currentItemCount = self.internalHighScores.count;
    if ( currentItemCount >= 10) {
//        //Option1
//        [self.internalHighScores sortUsingComparator:^(ScoreEntry *obj1, ScoreEntry *obj2) {
//            return [obj1 compareScore:obj2];
//        }];
        //Option2
        [self.internalHighScores sortUsingSelector:@selector(compareScore:)];
        ScoreEntry *aLeastScoreEntry = [self leastScoreEntry];
        if(iScoreEntry.score > aLeastScoreEntry.score) {
            [self.internalHighScores removeLastObject];
        } else { // score lower so ignore
            return;
        };
    }
    [self.internalHighScores addObject:iScoreEntry];
    [self updateToUserDefaults];
}

- (NSArray *)highScoresSortedByScore {
    NSArray * sortedArray = [self.internalHighScores sortedArrayUsingComparator:^(ScoreEntry *obj1, ScoreEntry *obj2) {
        return -1 * [obj1 compareScore:obj2];
    }];
    return sortedArray;
}

- (NSArray *)highScoresSortedByDuration {
    NSArray * sortedArray = [self.internalHighScores sortedArrayUsingComparator:^(ScoreEntry *obj1, ScoreEntry *obj2) {
        return [obj1 compareDuration:obj2];
    }];
    return sortedArray;}

- (NSArray *)highScoresSortedByWhen {
    NSArray * sortedArray = [self.internalHighScores sortedArrayUsingComparator:^(ScoreEntry *obj1, ScoreEntry *obj2) {
        return -1 * [obj1 compareWhen:obj2];
    }];
    return sortedArray;}


- (ScoreEntry *)leastScoreEntry {
    ScoreEntry * aLeastScoreEntry = nil;

    for (ScoreEntry * aEachEntry in self.internalHighScores) {
        if(!aLeastScoreEntry || aLeastScoreEntry.score > aEachEntry.score) {
            aLeastScoreEntry = aEachEntry;
        }
    }
    return aLeastScoreEntry;
}


- (instancetype)init
{
    self = [super init];
    if (self) {
        NSArray * highScoresFromUserDefaults = [[self userDefaults] objectForKey:@"High Scores"];
        if (highScoresFromUserDefaults) {
            for (NSDictionary * aDict in highScoresFromUserDefaults) {
                ScoreEntry * scoreEntry = [[ScoreEntry alloc] initWithDictionary:aDict];
                //[scoreEntry fromDictionary:aDict];
                [self.internalHighScores addObject:scoreEntry];
            }
        }
    }
    return self;
}

+ (HighScoresManager *)instance {
    static HighScoresManager *_instance = nil;

    @synchronized (self) {
        if (_instance == nil) {
            _instance = [[self alloc] init];
        }
    }

    return _instance;
}

@end
