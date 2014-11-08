//
// Created by Parmesh Bayappu on 11/6/14.
// Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView ()

@property (nonatomic) CGFloat faceCardScaleFactor;

@end

@implementation SetCardView

#pragma mark - Properties

- (void)setNumber:(uint)number
{
    _number = number;
    [self setNeedsDisplay];
}

- (void)setShape:(uint)shape
{
    _shape = shape;
    [self setNeedsDisplay];
}

- (void)setShading:(uint)shading
{
    _shading = shading;
    [self setNeedsDisplay];
}

- (void)setColor:(uint)color
{
    _color = color;
    [self setNeedsDisplay];
}

- (void)setFaceUp:(BOOL)faceUp
{
    _faceUp = faceUp;
    [self setNeedsDisplay];
}

static NSArray * COLORS_IN_SET = nil;
+ (NSArray *)colorsInSet
{
    if(!COLORS_IN_SET) COLORS_IN_SET = @[[UIColor greenColor], [UIColor redColor], [UIColor purpleColor]];
    return COLORS_IN_SET;
}

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

- (void)awakeFromNib
{
    [self setup];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self setup];
    }
    return self;
}


#pragma mark - Drawing

#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS_STANDARD 12.0

- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS_STANDARD * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; } //not sure of this calc

//@synthesize faceCardScaleFactor = _faceCardScaleFactor;

#define DEFAULT_FACE_CARD_SCALE_FACTOR 0.90
- (CGFloat)faceCardScaleFactor
{
    if (!_faceCardScaleFactor) _faceCardScaleFactor = DEFAULT_FACE_CARD_SCALE_FACTOR;
    return _faceCardScaleFactor;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    //Drawing code
    UIBezierPath * roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];

    [roundedRect addClip];

    if(self.faceUp) {
        [[UIColor whiteColor] setFill];
        UIRectFill(self.bounds);

        [[UIColor blackColor] setStroke];
        [roundedRect stroke];

        CGRect imageRect = CGRectInset(self.bounds, self.bounds.size.width * (1.0-self.faceCardScaleFactor), self.bounds.size.height * (1.0-self.faceCardScaleFactor));

        [self drawPips: imageRect];
    }
    else {
        UIImage *faceImage = [UIImage imageNamed:@"cardback"];
        [faceImage drawInRect:self.bounds];
    }
}

- (UIColor *)colorOfCard {
    return [self.class colorsInSet][self.color-1];
}

- (CGFloat)alphaOfCard {
    return (self.shading - 1)*0.5;
}

- (void)drawPips:(CGRect) imageRect
{
    CGContextSaveGState (UIGraphicsGetCurrentContext());

    [[[self colorOfCard] colorWithAlphaComponent:[self alphaOfCard]] setFill];
    [[self colorOfCard] setStroke];

    int itemCount = self.number;
    const int ITEM_MAX_COUNT = 3;

    bool placeShapesVertical = imageRect.size.height > imageRect.size.width;
    if (itemCount >0)
    {
        //Note: Another option would be : Assume height is the larger dimension, draw and then rotate by 90 if width
        // is the larger dimension.

        int itemsCountVertical =  (placeShapesVertical ? itemCount : 1);
        int itemsCountVerticalMAX =  (placeShapesVertical ? ITEM_MAX_COUNT : 1);

        int itemsCountHorizontal =  (!placeShapesVertical ? itemCount : 1);
        int itemsCountHorizontalMAX =  (!placeShapesVertical ? ITEM_MAX_COUNT : 1);

        int itemHeight = imageRect.size.height/ itemsCountVerticalMAX * 0.90;
        int itemWidth = imageRect.size.width/ itemsCountHorizontalMAX * 0.90;
        CGSize itemSize = CGSizeMake(itemWidth, itemHeight);

        int itemRectHeight = imageRect.size.height/ itemsCountVertical;
        int itemRectWidth = imageRect.size.width/ itemsCountHorizontal;

        int itemRectXDelta = (placeShapesVertical ? 0 : itemRectWidth);
        int itemRectYDelta = (!placeShapesVertical ? 0 : itemRectHeight);

        for (int item =0 ; item < itemCount; item++) {
            CGRect rectForShape = CGRectMake(imageRect.origin.x + item*itemRectXDelta, imageRect.origin.y + item*itemRectYDelta, itemRectWidth, itemRectHeight);
            [self drawShapeIn:rectForShape ofSize:itemSize];
        }
    }

    CGContextRestoreGState(UIGraphicsGetCurrentContext());
}

- (void)drawShapeIn:(CGRect) imageRect ofSize:(CGSize) size
{
    //Make width and height equal for shapes
    CGFloat widthAndHeightEqual = MIN(size.width, size.height);
    size.height = widthAndHeightEqual; size.width = widthAndHeightEqual;

    int xDiff = (imageRect.size.width - size.width)/2;
    int yDiff = (imageRect.size.height - size.height)/2;

    CGRect rectForShape = CGRectInset(imageRect, xDiff, yDiff);

    UIBezierPath * shape;
    if (self.shape == 1) { //Square or rect
        shape = [UIBezierPath bezierPathWithRect:rectForShape];
    } else if (self.shape ==2) { //Circle or oval
        shape = [UIBezierPath bezierPathWithOvalInRect:rectForShape];
    } else if (self.shape == 3) { //Triangle
        shape = [UIBezierPath bezierPath];
        [shape moveToPoint:CGPointMake(rectForShape.origin.x + size.width/2, rectForShape.origin.y)];
        [shape addLineToPoint:CGPointMake(rectForShape.origin.x + size.width - 1, rectForShape.origin.y + size.height - 1)];
        [shape addLineToPoint:CGPointMake(rectForShape.origin.x, rectForShape.origin.y + size.height -1)];
        [shape closePath];
    }
    [shape fill];
    [shape stroke];
}
@end