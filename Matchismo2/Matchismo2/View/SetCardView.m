//
// Created by Parmesh Bayappu on 11/6/14.
// Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "SetCardView.h"

@interface SetCardView ()

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

static NSArray * COLORS_IN_SET = nil;
+ (NSArray *)colorsInSet
{
    if(!COLORS_IN_SET) COLORS_IN_SET = @[[UIColor greenColor], [UIColor redColor], [UIColor purpleColor]];
    return COLORS_IN_SET;
}

static NSArray * ALPHAS_IN_SET = nil;
+ (NSArray *)alphasInSet
{
    if(!ALPHAS_IN_SET) ALPHAS_IN_SET = @[@(0.0), @(0.2), @(1.0)];
    return ALPHAS_IN_SET;
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

- (UIColor *)colorOfCard {
    return [self.class colorsInSet][self.color-1];
}

- (CGFloat)alphaOfCard {
    return [(NSNumber *) [self.class alphasInSet][self.shading - 1] floatValue];
}

- (void)drawCardContents:(CGRect) Rect
{
    CGContextSaveGState (UIGraphicsGetCurrentContext());

    CGRect imageRect = [self scaledCardContentsRect];

    //TODO: Later use CG Patterns to draw stripes when shading is 2 - instead of current use of color alpha component
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

        int itemHeight = imageRect.size.height/ itemsCountVerticalMAX * 0.80;
        int itemWidth = imageRect.size.width/ itemsCountHorizontalMAX * 0.80;
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