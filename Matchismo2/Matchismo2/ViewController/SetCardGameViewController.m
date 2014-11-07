//
// Created by Parmesh Bayappu on 11/7/14.
// Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "SetCardGameViewController.h"
#import "SetCardDeck.h"
#import "SetCard.h"
#import "SomeCommonUtils.h"
#import "SetCardView.h"


@implementation SetCardGameViewController {

}

#pragma mark -- Overrides

// override base class abstract impl
- (uint)numberOfCardsToDeal {
    return 12;
}

// override base class abstract impl
- (Deck *)createDeck {
    return [[SetCardDeck alloc] init];
}

// override base class abstract impl
- (uint)numberOfCardsToMatch {
    return 3;
}

// override base class abstract impl
- (UIView *)createCardViewWith: (Card *)card {
    SetCard * setCard = SAFE_CAST_TO_TYPE_OR_ASSERT(card, SetCard );
    SetCardView * cardView = [[SetCardView alloc] initWithFrame:CGRectZero];
    cardView.color = setCard.color;
    cardView.number = setCard.number;
    cardView.shading = setCard.shading;
    cardView.shape = setCard.symbol;
    cardView.faceUp = true;
    return cardView;
}

@end