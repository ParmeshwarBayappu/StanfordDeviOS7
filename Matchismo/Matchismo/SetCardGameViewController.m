//
//  PlayingCardGame2ViewController.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/10/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SomeCommonUtils.h"

NSArray * SHAPES_IN_SET ;
NSArray * COLORS_IN_SET;
NSArray * SHADES_IN_SET;
NSArray * COLORNAMES_IN_SET;
NSArray * SHADENAMES_IN_SET;

@interface SetCardGameViewController ()

@end

@implementation SetCardGameViewController


+ (NSArray *)shapesInSet
{
    if(!SHAPES_IN_SET) SHAPES_IN_SET = @[@"▲", @"●", @"■"];
    return SHAPES_IN_SET;
}

+ (NSArray *)colorsInSet
{
    if(!COLORS_IN_SET) COLORS_IN_SET = @[[UIColor redColor], [UIColor blackColor], [UIColor blueColor]];
    return COLORS_IN_SET;
}

//No longer used
+ (NSArray *)shadesInSet
{
    if(!SHADES_IN_SET) SHADES_IN_SET = @[[UIColor yellowColor], [UIColor greenColor], [UIColor whiteColor]];
    return SHADES_IN_SET;
}


+ (NSArray *)colorNamesInSet
{
    if(!COLORNAMES_IN_SET) COLORNAMES_IN_SET =  @[ @"redColor", @"blackColor", @"blueColor"];
    return COLORNAMES_IN_SET;
}

//No longer used
+ (NSArray *)shadeNamesInSet
{
    if(!SHADENAMES_IN_SET) SHADENAMES_IN_SET = @[ @"yellowColor", @"greenColor", @"whiteColor"];
    return SHADENAMES_IN_SET;
}

//not essential
- (NSString *)formatCardContent:(Card *) card
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


- (NSAttributedString *)formatCardContentAttr:(Card *) card
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

-(BOOL)isEasyModeEnabled
{
    return [self selectedMatchModeIndex]==1;
}

- (NSAttributedString *)formatCardContentAttrWhenNotChosen:(Card *)card
{
    if (self.matchStarted && self.isEasyModeEnabled && !card.isChosen)
        return [self formatCardContentAttr:card];
    else
        return [super formatCardContentAttrWhenNotChosen:card];
}

- (UIImage *)backgroundImageForCard:(Card *)card
{
    if (self.matchStarted && self.isEasyModeEnabled && !card.isChosen)
        return [UIImage imageNamed:@"cardsemi"];
    else
        return [super backgroundImageForCard:card];
}

// override base class abstract impl
- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

// override base class abstract impl
-(uint)numberOfCardsToMatch
{
    return 3;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
