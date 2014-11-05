//
//  FormatSetCard.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 11/3/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FormatSetCard.h"
#import "SomeCommonUtils.h"
#import "SetCard.h"


@implementation FormatSetCard

//not essential
+ (NSString *)formatContent:(Card *) card
{
    SetCard * setCard = SAFE_CAST_TO_TYPE_OR_ASSERT(card, SetCard);
    
    //number, symbol
    NSString * formattedCardContent = @"";
    
    for (int i=0; i<setCard.number; i++) {
        formattedCardContent = [formattedCardContent stringByAppendingString:[self.class shapesInSet][setCard.symbol-1]];
    }
    
    //color as text
    formattedCardContent = [formattedCardContent stringByAppendingString:[self.class colorNamesInSet][setCard.color -1]];
    
    //shade as text
    formattedCardContent = [formattedCardContent stringByAppendingString:[self.class shadeNamesInSet][setCard.shading -1]];
    
    return formattedCardContent;
}


+ (NSAttributedString *)formatContentAttr:(Card *) card
{
    //SetCard setCard = (assert([card isKindOfClass:[SetCard class]]),((SetCard * ) card ));
    SetCard * setCard = SAFE_CAST_TO_TYPE_OR_ASSERT(card, SetCard);
    
    
    //number, symbol
    NSString * cardContent = @"";
    for (int i=0; i<setCard.number; i++) {
        cardContent = [cardContent stringByAppendingString:[self.class shapesInSet][setCard.symbol-1]];
    }
    
    //color, shade
    NSDictionary *attribs = @{ NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline], // UIFontTextStyleSubheadline],
                               NSForegroundColorAttributeName: [[self.class colorsInSet][setCard.color -1] colorWithAlphaComponent:(setCard.shading-1)*0.5], // TODO: Use Font's alpha value for shade, instead of ForegroundColor.
                               
                               NSStrokeWidthAttributeName:@-3
                               ,NSStrokeColorAttributeName:[self.class colorsInSet][setCard.color -1]
                               };
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:cardContent];// attributes:<#(NSDictionary *)#>];
    [attrString setAttributes:attribs range:NSMakeRange(0, cardContent.length)];
    
    //NSAttributedString * shadingNumberAttr = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"%d", setCard.shading]];
    //[attrString appendAttributedString:shadingNumberAttr];
    
    return attrString;
}


+ (NSArray *)shapesInSet
{
    static NSArray * SHAPES_IN_SET ; //= @[@"▲", @"●", @"■"]; TODO: Try this line
    if(!SHAPES_IN_SET) SHAPES_IN_SET = @[@"▲", @"●", @"■"];
    return SHAPES_IN_SET;
}

+ (NSArray *)colorsInSet
{
    static NSArray * COLORS_IN_SET;
    if(!COLORS_IN_SET) COLORS_IN_SET = @[[UIColor redColor], [UIColor blackColor], [UIColor blueColor]];
    return COLORS_IN_SET;
}

//No longer used
+ (NSArray *)shadesInSet
{
    static NSArray * SHADES_IN_SET;
    if(!SHADES_IN_SET) SHADES_IN_SET = @[[UIColor yellowColor], [UIColor greenColor], [UIColor whiteColor]];
    return SHADES_IN_SET;
}


+ (NSArray *)colorNamesInSet
{
    static NSArray * COLORNAMES_IN_SET;
    if(!COLORNAMES_IN_SET) COLORNAMES_IN_SET =  @[ @"redColor", @"blackColor", @"blueColor"];
    return COLORNAMES_IN_SET;
}

//No longer used
+ (NSArray *)shadeNamesInSet
{
    static NSArray * SHADENAMES_IN_SET;
    if(!SHADENAMES_IN_SET) SHADENAMES_IN_SET = @[ @"yellowColor", @"greenColor", @"whiteColor"];
    return SHADENAMES_IN_SET;
}

@end
