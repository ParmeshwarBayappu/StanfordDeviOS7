//
//  ViewController.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/1/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "CardGameViewController.h"
#import "model/PlayingCardDeck.h"

@interface CardGameViewController ()
@property (weak, nonatomic) IBOutlet UILabel *flipLabel;
@property (nonatomic) int flipCount;
@property (strong, nonatomic) PlayingCardDeck *deck;
@end

@implementation CardGameViewController

- (PlayingCardDeck *)deck
{
    if(!_deck) _deck = [self createDeck];
    return _deck;
}

- (PlayingCardDeck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}
- (IBAction)touchCardButton:(UIButton *)sender {
 

    if (sender.currentTitle.length) {
        UIImage * cardImage = [UIImage imageNamed:@"cardback"];
        [sender setBackgroundImage:cardImage forState:UIControlStateNormal];
        [sender setTitle:@"" forState:UIControlStateNormal];
        self.flipCount++;
        self.flipLabel.text = [NSString stringWithFormat:@"Flips:%d", self.flipCount];
    }
    else {
        Card * card = [self.deck drawRandomCard];
        NSLog(@"Drew card %@", card.contents);

        if (card) {
            UIImage * cardImage = [UIImage imageNamed:@"cardfront"];
            [sender setBackgroundImage:cardImage forState:UIControlStateNormal];
            
            [sender setTitle:card.contents
                    forState:UIControlStateNormal];
            
            self.flipCount++;
            self.flipLabel.text = [NSString stringWithFormat:@"Flips:%d", self.flipCount];
        } else {
            [sender setEnabled:FALSE];
        }
    }
    NSLog(@"Flip Count %d", self.flipCount);
    
}

@end
