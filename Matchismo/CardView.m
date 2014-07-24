//
//  CardGame.m
//  Matchismo
//
//  Created by Harshitha Ramesh on 5/6/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "CardView.h"

@implementation CardView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void) changeSelection:(UIColor*) color{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSaveGState(context);
    [color setFill];
    [self.roundedRect fill];
    CGContextRestoreGState(context);
}

-(void)setSelected:(BOOL)selected
{
    _selected = selected;
    [self setNeedsDisplay];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
