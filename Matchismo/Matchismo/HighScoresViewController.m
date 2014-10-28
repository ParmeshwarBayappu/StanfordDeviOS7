//
//  HighScoresPlaceHolderViewController.m
//  Matchismo
//
//  Created by Parmesh Bayappu on 10/21/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "HighScoresViewController.h"
#import "PlayingCardView.h"
#import "SetCardView.h"


@interface HighScoresViewController () <UIDynamicAnimatorDelegate>

@property (weak, nonatomic) IBOutlet PlayingCardView *playingCardView;
@property (weak, nonatomic) IBOutlet SetCardView *setCardView;
@property (weak, nonatomic) IBOutlet UIView *boundaryView;

@property (strong, nonatomic) UIDynamicAnimator *dynamicAnimator;
@property (strong, nonatomic) UIGravityBehavior *gravityBehaviour;
@property (strong, nonatomic) UICollisionBehavior *collisionBehaviour;

@property (nonatomic) float angle;
@property (strong, nonatomic) UILabel * textlabel;

@end

@implementation HighScoresViewController


- (void) dynamicAnimatorDidPause:(UIDynamicAnimator *)animator
{
    if (_textlabel) {
        [self.gravityBehaviour removeItem:self.textlabel];
        [self.collisionBehaviour removeItem:self.textlabel];
        self.textlabel = nil;
    }
}

- (int)angleInDegrees
{
    int degrees = (int)(self.angle*360/(2*M_PI));
    return degrees;
}

- (IBAction)swipe:(UISwipeGestureRecognizer *)sender {
    if (sender.view == self.setCardView) {
        self.setCardView.shape = (self.setCardView.shape%3)+1;
        [self animateViewTransitionByFlip:sender.view animations:^{
        //    self.setCardView.shape = (self.setCardView.shape%3)+1;
        } ];
    } else {
        assert(false);//This code branch should never be reached. Check this recoqnizer is associatd with only one view!
        self.playingCardView.faceUp = !self.playingCardView.faceUp;
    }
}
- (IBAction)swipePlayingCard:(UISwipeGestureRecognizer *)sender {
    
    self.playingCardView.faceUp = !self.playingCardView.faceUp;
    //self.gravityBehaviour.magnitude *= -1;
    self.gravityBehaviour.angle = M_2_PI;//0.5;
    NSLog(@"Gravity Angle Rad:%f  Deg:%f", self.gravityBehaviour.angle, self.gravityBehaviour.angle*360/M_1_PI/10);

    //[self animateViewTransitionByFlip:self.playingCardView animations:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.playingCardView.rank = 10;
    self.playingCardView.suit = @"♥︎";
    UIPinchGestureRecognizer * pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self.playingCardView action:@selector(pinch:)];
    [self.playingCardView addGestureRecognizer:pinchRecognizer];
    
    self.setCardView.number = 1;
    self.setCardView.shape = 1;
    self.setCardView.shading = 1;
    self.setCardView.color = 1;
 
    [self.collisionBehaviour addItem:self.playingCardView];
    [self.gravityBehaviour addItem:self.playingCardView];
    self.angle =0.0;
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

- (UILabel *) textlabel
{
    if( !_textlabel)
    {
        _textlabel = [UILabel new];
        [self.boundaryView addSubview:_textlabel];
        _textlabel.center = CGPointMake(self.boundaryView.bounds.size.width/2, self.boundaryView.bounds.size.height/2);
    }
    return _textlabel;
}

- (void)addLabel
{
    UILabel * textlabel = self.textlabel;
    textlabel.text = [NSString stringWithFormat:@"R %.2f %d", self.angle, [self angleInDegrees]];
    [_textlabel sizeToFit];
    self.textlabel.center = CGPointMake(self.boundaryView.bounds.size.width/2, self.boundaryView.bounds.size.height/2);

    UIGravityBehavior * gravityBehaviour = self.gravityBehaviour;
    gravityBehaviour.angle = self.angle;
    [gravityBehaviour addItem:textlabel];
    [self.collisionBehaviour addItem:textlabel];
    
    [self.dynamicAnimator updateItemUsingCurrentState:textlabel];
    
    self.angle += 1.571;
}

- (IBAction)tapSetCard:(UITapGestureRecognizer *)sender {
    
    [self addLabel];
    
    //[self animateViewByScaling:sender.view];
    
    //CGRect frame = [self.setCardView frame];
    //[self.setCardView setFrame:CGRectMake(50, 100, self.setCardView.bounds.size.width*1.2, self.setCardView.bounds.size.height*1.2)];
    //[self.setCardView setBounds:CGRectMake(50, 100, self.setCardView.bounds.size.width*1.2, self.setCardView.bounds.size.height*1.2)]; //- Not working. Why?
    //CGRect currBounds = self.setCardView.bounds;
    //[self animateViewByScaling:self.setCardView animations:^{
    //    self.setCardView.number = (self.setCardView.number%3) +1;
    //}];
}

#pragma mark -- Animation

- (void)animateViewTransitionByFlip:(UIView *)view animations:(void (^)()) animations
{
    [UIView transitionWithView:view duration:3.0 options:UIViewAnimationOptionTransitionFlipFromLeft animations:^{
        if (animations) animations();
    } completion:^(BOOL finished) {
        //
    }];
}

- (void)animateViewByScaling:(UIView *)iView animations:(void (^)()) animations
{
    //scale up and down
    CGRect currBounds = iView.bounds;
    CGRect newBounds = currBounds;
    newBounds.size.width *= 1.20;
    newBounds.size.height *= 1.20;
    
    //newBounds.origin = CGPointMake(50, 100);
    
    [iView setBackgroundColor:[UIColor orangeColor]];
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionAutoreverse animations:^{
        if (animations)
            animations();
        [iView setBounds:newBounds];
    } completion:^(BOOL finished) {
        //        [UIView animateWithDuration:1.0 delay:1.0 options:UIViewAnimationOptionAutoreverse animations:^{
        [iView setBounds:currBounds];
        //        } completion:^(BOOL finished) {
        [iView setBackgroundColor:nil];
        //        }];
    }];
}

-(UIGravityBehavior *)gravityBehaviour
{
    if(!_gravityBehaviour)
    {
        _gravityBehaviour = [[UIGravityBehavior alloc] init];
        _gravityBehaviour.magnitude = 0.1;
        _gravityBehaviour.angle = 0;//M_1_PI-1.7;
        [self.dynamicAnimator addBehavior:_gravityBehaviour];
    }
    return _gravityBehaviour;
}

-(UICollisionBehavior *)collisionBehaviour
{
    if(!_collisionBehaviour)
    {
        _collisionBehaviour = [[UICollisionBehavior alloc] init];
        _collisionBehaviour.translatesReferenceBoundsIntoBoundary = true;
        [self.dynamicAnimator addBehavior:_collisionBehaviour];
    }
    return _collisionBehaviour;
}

- (UIDynamicAnimator *)dynamicAnimator
{
    if (!_dynamicAnimator) {
        _dynamicAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.boundaryView];
        _dynamicAnimator.delegate = self;

    }
    return _dynamicAnimator;
}


@end
