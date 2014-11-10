//
// Created by Parmesh Bayappu on 11/7/14.
// Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCardView.h"
#import "PlayingCard.h"
#import "SomeCommonUtils.h"


@implementation PlayingCardGameViewController {

}

#pragma mark -- Overrides

// override base class abstract impl
- (uint)numberOfCardsToDeal {
    return 9;
}

// override base class abstract impl
- (CGFloat)cellAspectRatio {
    return 9.0/16.0;
}

//AppCode does not seem to recognize that this is an override and keeps suggesting to declare in interface!! TODO: verify after initial build.
// override base class abstract impl
- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}

// override base class abstract impl
-(uint) numberOfCardsToMatch
{
    return [self selectedMatchModeIndex]==0 ? 2 : 3;
}

// override base class abstract impl
- (UIView *)createCardViewWith: (Card *)card {
    PlayingCard * playingCard = SAFE_CAST_TO_TYPE_OR_ASSERT(card, PlayingCard );
    PlayingCardView * cardView = [[PlayingCardView alloc] initWithFrame:CGRectZero];
    cardView.rank = playingCard.rank;
    cardView.suit = playingCard.suit;
    return cardView;
}

+ (NSArray *)matchModeTitles {
    return @[@"2 Card", @"3 Card"];
}
@end