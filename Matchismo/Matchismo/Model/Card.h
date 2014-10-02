//
//  Card.h
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/2/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject

@property   (strong, nonatomic) NSString * contents;

@property (nonatomic) BOOL chosen;
@property (nonatomic) BOOL matched;

-(int)match: (NSArray *)otherCards;

@end
