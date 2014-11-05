//
//  HighScoresViewController.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 11/3/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "HighScoresViewController.h"
#import "PlayingCard.h"
#import "SetCard.h"
#import "FormatPlayingCard.h"
#import "FormatSetCard.h"
#import "HighScoresManager.h"


@interface HighScoresViewController ()

@property (weak, nonatomic) IBOutlet UITextView *scoresTextView;
@property (weak, nonatomic) IBOutlet UISegmentedControl *sortBySegmentedControl;

@property (nonatomic, strong) NSAttributedString *titleRow;
@property ScoreEntry *highestScore;
@property ScoreEntry *leastDuration;
@property ScoreEntry *latestWhen;

@end

@implementation HighScoresViewController

- (uint) selectedSortOderIndex {
    assert(self.sortBySegmentedControl.selectedSegmentIndex>=0);
    return (uint) self.sortBySegmentedControl.selectedSegmentIndex;
}

- (IBAction)sortByChanged:(UISegmentedControl *)sender {
    [self updateScores];
}

+ (PlayingCard *)stdPlayingCard {
    static PlayingCard *_stdPlayingCard = nil;
    if(!_stdPlayingCard){
        _stdPlayingCard = [[PlayingCard alloc] init];
        _stdPlayingCard.suit = @"♠️";
        _stdPlayingCard.rank = 13;
    }
    return _stdPlayingCard;
}

- (void)viewWillAppear:(BOOL)animated {
    [self updateScores];
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

+ (SetCard *)stdSetCard {
    static SetCard *_stdSetCard = nil;
    if(!_stdSetCard) {
        _stdSetCard = [SetCard new];
        _stdSetCard.number = 2;
        _stdSetCard.shading = 2;
        _stdSetCard.symbol = 2;
        _stdSetCard.color = 2;

    }
    return _stdSetCard;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    }

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateScores {

    NSMutableAttributedString * attrStr = [self.titleRow mutableCopy];
    [attrStr appendAttributedString:[self.class newLineAttr]];
    [attrStr appendAttributedString:[self highScoresAsAttributedStr]];

    [self.scoresTextView setAttributedText:attrStr];
}

//Create Title Row

- (NSAttributedString *)titleRow
{
    if(!_titleRow){
        NSDictionary *attribs = @{ NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleBody],//UIFontTextStyleSubheadline],
                                   NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.5],

                                   NSStrokeWidthAttributeName:@-3
                                   ,NSStrokeColorAttributeName:[UIColor orangeColor]
                                   };
        _titleRow = [[NSMutableAttributedString alloc] initWithString:@"Game\t\t Score\t\t Duration\t\t When" attributes:attribs];
    }
    return _titleRow;
}

+ (NSDictionary *)standardTextAttribs
{
    static NSDictionary *attribs;
    if (!attribs) {
        attribs = @{ NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline],
                               NSForegroundColorAttributeName: [[UIColor blackColor] colorWithAlphaComponent:0.5],

                               NSStrokeWidthAttributeName:@-3
                               ,NSStrokeColorAttributeName:[UIColor orangeColor]
                               };
    }
    return attribs;
}

+ (NSDictionary *)specialTextAttribs
{
    static NSDictionary *attribs;
    if (!attribs) {
        attribs = @{ NSFontAttributeName:[UIFont preferredFontForTextStyle:UIFontTextStyleSubheadline],
                                   NSForegroundColorAttributeName: [[UIColor greenColor] colorWithAlphaComponent:1.0],

                                   NSStrokeWidthAttributeName:@-3
                                   ,NSStrokeColorAttributeName:[UIColor greenColor]
                                   };
    }
    return attribs;
}

- (NSMutableAttributedString *)formatScores:(NSArray *)iHighScores {
    NSMutableAttributedString *attrStr = [NSMutableAttributedString new];

    HighScoresManager *highScoresManager = [HighScoresManager instance];
    self.highestScore = [highScoresManager highestScore];
    self.leastDuration = [highScoresManager leastDuration];
    self.latestWhen = [highScoresManager latestWhen];

    for (ScoreEntry *item in iHighScores) {
        [attrStr appendAttributedString:[self.class newLineAttr]];
        [attrStr appendAttributedString:[self formatScoreLine:item.score duration:item.duration when:item.when isPlayingCard:item.isPlayingCard]];
    }
    return attrStr;
}

- (NSAttributedString *)highScoresAsAttributedStr
{
    HighScoresManager * highScoresManager = [HighScoresManager instance];
    NSArray * sortedScoresArray;
    switch (self.selectedSortOderIndex)
    {
        case 0: sortedScoresArray = [highScoresManager highScoresSortedByScore];
            break;
        case 1: sortedScoresArray = [highScoresManager highScoresSortedByDuration];
            break;
        case 2: sortedScoresArray = [highScoresManager highScoresSortedByWhen];
            break;
    }
    
    NSMutableAttributedString *attrStr = [self formatScores:sortedScoresArray];
    
    return attrStr;
}

- (NSAttributedString *)formatScoreLine:(int)score duration:(int)duration when:(NSDate *)when isPlayingCard:(BOOL)isPlayingCard
{
    NSMutableAttributedString * attrStr = [NSMutableAttributedString new];
    [attrStr appendAttributedString:[self.class formatGameType:isPlayingCard]];
    [attrStr appendAttributedString:[self.class separatorForFields]];
    [attrStr appendAttributedString:[self.class formatScore:score isHighScore:(self.highestScore.score == score)]];
    [attrStr appendAttributedString:[self.class separatorForFields]];
    [attrStr appendAttributedString:[self.class formatDuration:duration isLowestDuration:(self.leastDuration.duration == duration)]];
    [attrStr appendAttributedString:[self.class separatorForFields]];
    [attrStr appendAttributedString:[self.class formatDate:when isLatest:(self.latestWhen.when == when)]];

    return attrStr;
}

+ (NSAttributedString *)formatScore:(int)score isHighScore:(BOOL)isHighScore
{
    NSString * scoreAsString = [NSString stringWithFormat:@"%.8d", score];
    NSDictionary * attribs = isHighScore? [self.class specialTextAttribs] : [self.class standardTextAttribs];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:scoreAsString attributes:attribs];
    return attrStr;
}

+ (NSAttributedString *)formatDuration:(int)duration isLowestDuration:(BOOL)isLowestDuration
{
    NSString * durationAsString = [NSString stringWithFormat:@"%0.8d", duration];
    NSDictionary * attribs = isLowestDuration? [self.class specialTextAttribs] : [self.class standardTextAttribs];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:durationAsString attributes:attribs];
    return attrStr;
}

+ (NSAttributedString *)formatDate:(NSDate *)date isLatest:(BOOL)isLatest
{
    NSString * dateAsString = [self.class dateFormatted:date];
    NSDictionary * attribs = isLatest? [self.class specialTextAttribs] : [self.class standardTextAttribs];
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:dateAsString attributes:attribs];
    return attrStr;
}


+ (NSAttributedString *)formatGameType:(BOOL)isPlayingCard
{
    NSMutableAttributedString *attrStr;
    if (isPlayingCard) {
        attrStr = [[FormatPlayingCard formatContentAttr:self.stdPlayingCard] mutableCopy];
        [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"  "]];
    } else {
        attrStr = [[FormatSetCard formatContentAttr:self.stdSetCard] mutableCopy];
        [attrStr appendAttributedString:[[NSAttributedString alloc] initWithString:@"\t\t"]];
    }
    
    return attrStr;
}

+ (NSAttributedString *)separatorForFields
{
    static NSAttributedString *SEPARATOR_FOR_FIELDS;
    if(!SEPARATOR_FOR_FIELDS) SEPARATOR_FOR_FIELDS = [[NSAttributedString alloc] initWithString:@"\t"]; // \t\t
    return SEPARATOR_FOR_FIELDS;
}

   + (NSAttributedString *)newLineAttr
{
    static NSAttributedString *SEPARATOR_NEW_LINE;
    if(!SEPARATOR_NEW_LINE) SEPARATOR_NEW_LINE = [[NSAttributedString alloc] initWithString:@"\n"];
    return SEPARATOR_NEW_LINE;
}

+ (NSString *)dateFormatted: (NSDate *)date
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    //NSString *localeFormatString = [NSDateFormatter dateFormatFromTemplate:@"YYYY-MM-dd" options:0 locale:dateFormatter.locale];
    dateFormatter.dateFormat = @"YYYY-MM-dd";// localeFormatString;
    NSString *formattedDate = [dateFormatter stringFromDate:date];
    return formattedDate;
}

+ (NSAttributedString *)attributedStringFromStr:(NSString *)str
{
    return [[NSAttributedString alloc] initWithString:str];
}

@end
