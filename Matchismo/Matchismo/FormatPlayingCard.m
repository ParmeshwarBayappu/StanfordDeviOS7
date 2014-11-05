//
//  FormatPlayingCard.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 11/3/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FormatPlayingCard.h"

@implementation FormatPlayingCard

+ (NSString *)formatContent:(Card *) card
{
    NSString * formattedCardContent = card.contents;
    
    return formattedCardContent;
}

+ (NSAttributedString *)formatContentAttr:(Card *) card
{
    NSString * cardContent = [self formatContent:card];
    
    NSDictionary *attribs = @{ NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleHeadline],
                               NSForegroundColorAttributeName: [UIColor blackColor],
                               NSStrokeWidthAttributeName:@-5,
                               NSStrokeColorAttributeName:[UIColor redColor]
                               };
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:cardContent];// attributes:attribs];// attributes:<#(NSDictionary *)#>];
    [attrString setAttributes:attribs range:NSMakeRange(0, cardContent.length)];
    
    
    return attrString;
}

@end
