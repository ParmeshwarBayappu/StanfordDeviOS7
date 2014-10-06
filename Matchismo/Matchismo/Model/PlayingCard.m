//
//  PlayingCard.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/2/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

+ (NSArray *)validSuits
{
    return @[@"♠️", @"♣️", @"♥️", @"♦️"];
}

+ (NSArray *)rankStrings
{
    return @[@"?", @"A", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", @"10", @"J", @"Q", @"K"];
}

@synthesize suit = _suit;
+ (NSUInteger)maxRank
{
    return [self rankStrings].count -1;
}

- (void)setSuit:(NSString *)suit
{
    if ([[self.class validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit? _suit: @"?";
}

- (NSString *) contents
{
    NSArray * rankStrings = [self.class rankStrings];
    //return [NSString stringWithFormat:@"%@%@", rankString, self.suit ];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

- (void) setRank:(NSUInteger)rank
{
    if (rank <= [self.class maxRank])
    {
        _rank = rank;
    }
}

- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if (otherCards.count == 1) {
        PlayingCard *otherCard = [otherCards firstObject];
        if (self.rank == otherCard.rank) {
            score = 4;
        } else if ([self.suit isEqualToString:otherCard.suit]) {
            score = 1;
        }
    }
    
    return score;
}

@end
