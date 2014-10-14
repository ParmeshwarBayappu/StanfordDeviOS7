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
+ (NSString *)formatCardContent:(SetCard *) card
{
    //number, symbol
    NSString * formattedCardContent = @"";
    
    for (int i=0; i<card.number; i++) {
        formattedCardContent = [formattedCardContent stringByAppendingString:[self shapesInSet][card.symbol-1]];
    }
    
    //color as text
    formattedCardContent = [formattedCardContent stringByAppendingString:[self colorNamesInSet][card.color -1]];
    
    //shade as text
    formattedCardContent = [formattedCardContent stringByAppendingString:[self shadeNamesInSet][card.shading -1]];

    return formattedCardContent;
}

+ (NSAttributedString *)formatCardContentAttr:(SetCard *) card
{
    //number, symbol
    NSString * cardContent = @"";
    for (int i=0; i<card.number; i++) {
        cardContent = [cardContent stringByAppendingString:[self shapesInSet][card.symbol-1]];
    }
    
    //color, shade
    NSDictionary *attribs = @{ NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline],
                              NSForegroundColorAttributeName: [self.class shadesInSet][card.shading -1],
                            
                              NSStrokeWidthAttributeName:@-8,
                              NSStrokeColorAttributeName:[self.class colorsInSet][card.color -1] };
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:cardContent];// attributes:<#(NSDictionary *)#>];
    [attrString setAttributes:attribs range:NSMakeRange(0, cardContent.length)];
    
    
    return attrString;
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
