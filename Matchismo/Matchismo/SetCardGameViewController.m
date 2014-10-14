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

+ (NSArray *)shadeNamesInSet
{
    if(!SHADENAMES_IN_SET) SHADENAMES_IN_SET = @[ @"yellowColor", @"greenColor", @"whiteColor"];
    return SHADENAMES_IN_SET;
}

//not essential
+ (NSString *)formatCardContent:(Card *) card
{
    SetCard * setCard = SAFE_CAST_TO_TYPE_OR_ASSERT(card, SetCard);
    
    //number, symbol
    NSString * formattedCardContent = @"";
    
    for (int i=0; i<setCard.number; i++) {
        formattedCardContent = [formattedCardContent stringByAppendingString:[self shapesInSet][setCard.symbol-1]];
    }
    
    //color as text
    formattedCardContent = [formattedCardContent stringByAppendingString:[self colorNamesInSet][setCard.color -1]];
    
    //shade as text
    formattedCardContent = [formattedCardContent stringByAppendingString:[self shadeNamesInSet][setCard.shading -1]];

    return formattedCardContent;
}


+ (NSAttributedString *)formatCardContentAttr:(Card *) card
{
    //SetCard setCard = (assert([card isKindOfClass:[SetCard class]]),((SetCard * ) card ));
    SetCard * setCard = SAFE_CAST_TO_TYPE_OR_ASSERT(card, SetCard);


    //number, symbol
    NSString * cardContent = @"";
    for (int i=0; i<setCard.number; i++) {
        cardContent = [cardContent stringByAppendingString:[self shapesInSet][setCard.symbol-1]];
    }
    
    //color, shade
    NSDictionary *attribs = @{ NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline],
                              NSForegroundColorAttributeName: [self.class shadesInSet][setCard.shading -1],
                            
                              NSStrokeWidthAttributeName:@-8,
                              NSStrokeColorAttributeName:[self.class colorsInSet][setCard.color -1] };
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:cardContent];// attributes:<#(NSDictionary *)#>];
    [attrString setAttributes:attribs range:NSMakeRange(0, cardContent.length)];
    
    
    return attrString;
}

+ (NSAttributedString *)formatCardContentAttrWhenNotChosen:(Card *)card
{
    return [self formatCardContentAttr:card];
}

// override base class abstract impl
- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

// override base class abstract impl
-(uint)matchMode
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
