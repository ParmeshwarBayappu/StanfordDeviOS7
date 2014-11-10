//
// Created by Parmesh Bayappu on 11/7/14.
// Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "PlayingCardView.h"
#import "CardView.h"


@interface CardView ()
@end

@implementation CardView {

}

#pragma mark - Properties

- (BOOL)faceUp {
    return (self.cardState != CardStateFaceDown);
}

- (void)setCardState:(CardStateType)cardState {
    if (_cardState != cardState) {
        _cardState = cardState;
        [self setNeedsDisplay];
    }
}

@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90
- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

- (void)setFaceCardScaleFactor:(CGFloat)faceCardScaleFactor
{
    _faceCardScaleFactor = faceCardScaleFactor;
    [self setNeedsDisplay];
}

- (void) resetFaceCardScaleFactor {
    _faceCardScaleFactor =0;
}

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }

- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }

- (CGFloat)cornerOffset { return (CGFloat)([self cornerRadius] / 3.0); }

static NSString *BACKGROUND_IMAGE_NAME = nil;

+ (NSString *)backgroundImageName {
    if(!BACKGROUND_IMAGE_NAME) {
        BACKGROUND_IMAGE_NAME = @"cardback";
    }
    return BACKGROUND_IMAGE_NAME;
}

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (void)awakeFromNib
{
    [self setup];
}

#pragma mark - Drawing

- (void)drawCardBackgroundAndSetClip {
    // Draw card outline and background and set clipping to this area
    UIBezierPath *roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    [roundedRect addClip];

    [[self backgroundColorForFill] setFill];
    UIRectFill(self.bounds);

    [[self backgroundColorForStroke] setStroke];
    [roundedRect stroke];
}

 - (UIColor *)backgroundColorForFill {
     UIColor *backgroundColorForFill = nil;
     return [UIColor whiteColor];
     switch (self.cardState)
     {
         case CardStateFaceDown:
             break;
         case CardStateNormal:
             backgroundColorForFill = [[UIColor yellowColor] colorWithAlphaComponent:1.0];
             break;
         case CardStateHighlighted:
             backgroundColorForFill = [[UIColor redColor] colorWithAlphaComponent:1.0];
             break;
         case CardStateDisabled:
             backgroundColorForFill = [[UIColor whiteColor] colorWithAlphaComponent:1.0];
     }
     return backgroundColorForFill;
 }

- (UIColor *)backgroundColorForStroke {
    UIColor *backgroundColorForStroke = nil;
    switch (self.cardState)
    {
        case CardStateFaceDown:
        case CardStateNormal:
        case CardStateDisabled:
            backgroundColorForStroke = nil;
            break;
        case CardStateHighlighted:
            backgroundColorForStroke = [UIColor orangeColor];
    }
    return backgroundColorForStroke;
}

- (UIColor *)colorForOverlay {
    UIColor *colorForOverlay = nil;
    switch (self.cardState)
    {
        case CardStateFaceDown:
        case CardStateNormal:
            break;
        case CardStateHighlighted:
            colorForOverlay = [[UIColor redColor] colorWithAlphaComponent:0.2];
            break;
        case CardStateDisabled:
            colorForOverlay = [[UIColor blackColor] colorWithAlphaComponent:0.7];
            break;
    }
    return colorForOverlay;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
    [self drawCardBackgroundAndSetClip];

    if (self.faceUp) {
        [self drawCardContents:rect];

        UIColor *colorForOverlay = [self colorForOverlay];
        if(colorForOverlay ) {
            CGContextRef cgRef = UIGraphicsGetCurrentContext();
            CGContextSaveGState (cgRef);
            CGContextBeginTransparencyLayer(cgRef, nil);
            //CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeMultiply);
            [[self colorForOverlay] setFill];
            UIRectFill(self.bounds);
            CGContextEndTransparencyLayer(cgRef);
            CGContextRestoreGState(cgRef);
        }
    } else {
        [[UIImage imageNamed:[self.class backgroundImageName]] drawInRect:self.bounds];
    }
}

- (CGRect)scaledCardContentsRect {
    CGRect imageRect = CGRectInset(self.bounds,
            self.bounds.size.width * (1.0-self.faceCardScaleFactor),
            self.bounds.size.height * (1.0-self.faceCardScaleFactor));
    return imageRect;
}

- (void)drawCardContents:(CGRect)rect {
    assert(false); //Expect subclass to draw content specific to each card type
}

#pragma mark - Gesture Handling

- (void)pinch:(UIPinchGestureRecognizer *)gesture
{
    if ((gesture.state == UIGestureRecognizerStateChanged) ||
        (gesture.state == UIGestureRecognizerStateEnded)) {
        self.faceCardScaleFactor *= gesture.scale;
        gesture.scale = 1.0;
    }
}

@end