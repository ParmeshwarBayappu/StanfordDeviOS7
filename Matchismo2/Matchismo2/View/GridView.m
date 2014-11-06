//
//  GridView.m
//  Matchismo2
//
//  Created by Parmesh Bayappu on 11/5/14.
//  Copyright (c) 2014 Parmesh Bayappu. All rights reserved.
//

#import "GridView.h"
#import "Grid.h"

@interface GridView ()
@property (nonatomic, strong) Grid *grid;
@end

@implementation GridView {
}

#pragma mark - Initialization

- (void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw; //TODO: Is there need for this?

}

- (void)layoutSubviews {
    [super layoutSubviews];
    NSArray *subViews = [self subviews];

    self.grid.size = self.bounds.size;
    self.grid.minimumNumberOfCells = subViews.count;
    uint cellIndex = 0;
    for (uint row=0; row < self.grid.rowCount; row++) {
        for (uint col=0; col < self.grid.columnCount && cellIndex < self.grid.minimumNumberOfCells; col++, cellIndex++) {
            UIView *cellView = subViews[cellIndex];
            [cellView setFrame:[self.grid frameOfCellAtRow:row inColumn:col]];
        }
    }
}

- (void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setup];
    return self;
}

- (Grid *)grid {
    if (!_grid) {
        _grid = [Grid  new];
        _grid.cellAspectRatio = 1.0;
    }
    return _grid;
}

- (void)setCellAspectRatio:(CGFloat)cellAspectRatio {
    self.grid.cellAspectRatio = cellAspectRatio;
}

@end
