//
//  SetCardView.m
//  Graphical Set
//
//  Created by Ian on 4/27/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "SetCardView.h"

@implementation SetCardView

-(void)setSymbol:(NSUInteger)symbol
{
    _symbol = symbol;
    [self setNeedsDisplay];
}


-(void)setNumber:(NSUInteger)number
{
    _number = number;
    [self setNeedsDisplay];
}

-(void)setPattern:(NSUInteger)pattern
{
    _pattern = pattern;
    [self setNeedsDisplay];
}

/*
 * NOTE: one-indexed
 */
-(void)setCardColor:(NSUInteger)color{
    _cardColor = color;
    [self setNeedsDisplay];
}




#define CORNER_FONT_STANDARD_HEIGHT 180.0
#define CORNER_RADIUS 12.0
#define CORNER_LINE_SPACING_REDUCTION 0.25

#define SHAPE_HEIGHT_MULTIPLIER 0.160256
#define SHAPE_WIDTH_MULTIPLIER 0.526316
#define OVAL_CORNER_RADIUS 35.0



- (CGFloat)cornerScaleFactor { return self.bounds.size.height / CORNER_FONT_STANDARD_HEIGHT; }
- (CGFloat)cornerRadius { return CORNER_RADIUS * [self cornerScaleFactor]; }
- (CGFloat)cornerOffset { return [self cornerRadius] / 3.0; }
- (CGFloat)shapeHeight { return (self.bounds.size.height * SHAPE_HEIGHT_MULTIPLIER); }
- (CGFloat)shapeWidth { return (self.bounds.size.width * SHAPE_WIDTH_MULTIPLIER); }



- (void)drawRect:(CGRect)rect
{
    // Drawing code
    self.roundedRect = [UIBezierPath bezierPathWithRoundedRect:self.bounds cornerRadius:[self cornerRadius]];
    
    NSLog(@"Bounds width: %f & height: %f", self.bounds.size.width, self.bounds.size.height);
    
    [self.roundedRect addClip];
    
    if(!self.selected){
        [[UIColor whiteColor] setFill];
    }
    else [[UIColor cyanColor] setFill];
    UIRectFill(self.bounds);
    [[UIColor blackColor] setStroke];
    [self.roundedRect stroke];
    
    [self drawShapesOnCard];
    
}


- (CGFloat)shapeSeparation { return [self shapeHeight] * 0.2; }

-(void)drawShapesOnCard {
    UIColor *colorToDraw;
    colorToDraw = [self getColorToDraw];
    
    CGFloat shapeGroupHeight = self.number * [self shapeHeight] + (self.number - 1) * [self shapeSeparation];
    
    
    for (int i = 0; i < self.number; i++) {
        UIBezierPath *shapeToDraw;
        [colorToDraw setStroke];
        switch (self.symbol) {
            case 1:
                shapeToDraw = [self drawShapeOneAtX:((self.bounds.size.width/2) - [self shapeWidth]/2) andY:(((self.bounds.size.height/2) - shapeGroupHeight/2) + (i * ([self shapeHeight] + [self shapeSeparation])))];
                break;
            case 2:
                shapeToDraw = [self drawShapeTwoAtX:((self.bounds.size.width/2) - [self shapeWidth]/2) andY:((self.bounds.size.height/2) - shapeGroupHeight/2) + (i * ([self shapeHeight] + [self shapeSeparation]))];
                break;
            case 3:
                shapeToDraw = [self drawShapeThreeAtX:((self.bounds.size.width/2) - [self shapeWidth]/2) andY:((self.bounds.size.height/2) - shapeGroupHeight/2) + (i * ([self shapeHeight] + [self shapeSeparation]))];
                break;
            default:
                NSLog(@"Error: Symbol:%lu not found", (unsigned long)self.symbol);
                break;
        }
        [shapeToDraw stroke];
    }
}

/* Method: getColorToDraw
 * -----------------------
 * Returns the color to fill the shape with, as specified by the pattern and color properties.
 */
-(UIColor *)getColorToDraw {
    UIColor *ret = nil;
    if (self.cardColor > 0 && self.cardColor <= [[self validColors] count]) {
        ret =[self validColors][self.cardColor - 1];
    } else {
        NSLog(@"Error: self.color = %lu not found", (unsigned long)self.cardColor);
    }
    
    if (ret == nil) {
        NSLog(@"Error: Color is nil.");
    }
    
    return ret;
}


/* Method: drawShapeOneAtX: andY:
 * -------------------------------
 * Draws the shape (currently an oval) associated with symbol 0 at the specified X and Y coordinates. The origin is in
 * the upper left-hand corner of the drawing.
 */
-(UIBezierPath *)drawShapeOneAtX:(CGFloat)X andY:(CGFloat)Y
{
    CGRect ovalRect = CGRectMake(X, Y, [self shapeWidth], [self shapeHeight]);
    UIBezierPath *oval = [UIBezierPath bezierPathWithRoundedRect:ovalRect cornerRadius:OVAL_CORNER_RADIUS];
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ref);
    [oval addClip];
    [self fillShape:oval];
    CGContextRestoreGState(ref);
    
    return oval;
}

/* Method: drawShapeTwoAtX: andY:
 * -------------------------------
 * Draws the shape (currently a diamond) associated with symbol 1 at the specified X and Y coordinates. The origin is in
 * the upper left-hand corner of the drawing.
 */
-(UIBezierPath *)drawShapeTwoAtX:(CGFloat)X andY:(CGFloat)Y
{
    UIBezierPath *diamond = [[UIBezierPath alloc] init];
    [diamond moveToPoint:CGPointMake(X + [self shapeWidth]/2, Y)];
    [diamond addLineToPoint:CGPointMake(X + [self shapeWidth], Y + [self shapeHeight]/2)];
    [diamond addLineToPoint:CGPointMake(X + [self shapeWidth]/2, Y + [self shapeHeight])];
    [diamond addLineToPoint:CGPointMake(X, Y + [self shapeHeight]/2)];
    [diamond closePath];
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ref);
    [diamond addClip];
    [self fillShape:diamond];
    CGContextRestoreGState(ref);
    
    return diamond;
}

#define SQUIGGLE_START_POINT_VERTICAL_OFFSET_PROPORTION 0.5
#define SQUIGGLE_FIRST_END_POINT_HORIZONTAL_OFFSET_PROPORTION 0.48
#define SQUIGGLE_FIRST_END_POINT_VERTICAL_OFFSET_PROPORTION 0.17
#define SQUIGGLE_FIRST_CONTROL_POINT_HORIZONTAL_OFFSET_PROPORTION 0.07
#define SQUIGGLE_FIRST_CONTROL_POINT_VERTICAL_OFFSET_PROPORTION 0.05
#define SQUIGGLE_SECOND_END_POINT_HORIZONTAL_OFFSET_PROPORTION 0.82
#define SQUIGGLE_SECOND_END_POINT_VERTICAL_OFFSET_PROPORTION 0.09
#define SQUIGGLE_SECOND_CONTROL_POINT_HORIZONTAL_OFFSET_PROPORTION 0.68
#define SQUIGGLE_SECOND_CONTROL_POINT_VERTICAL_OFFSET_PROPORTION 0.32
#define SQUIGGLE_THIRD_END_POINT_HORIZONTAL_OFFSET_PROPORTION 0.93
#define SQUIGGLE_THIRD_END_POINT_VERTICAL_OFFSET_PROPORTION 0.4
#define SQUIGGLE_THIRD_CONTROL_POINT_HORIZONTAL_OFFSET_PROPORTION 0.95
#define SQUIGGLE_THIRD_CONTROL_POINT_VERTICAL_OFFSET_PROPORTION 0.01
#define SQUIGGLE_FOURTH_END_POINT_HORIZONTAL_OFFSET_PROPORTION 0.52
#define SQUIGGLE_FOURTH_END_POINT_VERTICAL_OFFSET_PROPORTION 0.80
#define SQUIGGLE_FOURTH_CONTROL_POINT_HORIZONTAL_OFFSET_PROPORTION 0.86
#define SQUIGGLE_FOURTH_CONTROL_POINT_VERTICAL_OFFSET_PROPORTION 0.99
#define SQUIGGLE_FIFTH_END_POINT_HORIZONTAL_OFFSET_PROPORTION 0.20
#define SQUIGGLE_FIFTH_END_POINT_VERTICAL_OFFSET_PROPORTION 0.85
#define SQUIGGLE_FIFTH_CONTROL_POINT_HORIZONTAL_OFFSET_PROPORTION 0.35
#define SQUIGGLE_FIFTH_CONTROL_POINT_VERTICAL_OFFSET_PROPORTION 0.68
#define SQUIGGLE_SIXTH_END_POINT_HORIZONTAL_OFFSET_PROPORTION 0
#define SQUIGGLE_SIXTH_END_POINT_VERTICAL_OFFSET_PROPORTION 0.5
#define SQUIGGLE_SIXTH_CONTROL_POINT_HORIZONTAL_OFFSET_PROPORTION 0.0
#define SQUIGGLE_SIXTH_CONTROL_POINT_VERTICAL_OFFSET_PROPORTION 1.08



/* Method: drawShapeThreeAtX: andY:
 * ---------------------------------
 * Draws the shape (currently a squiggle) associated with symbol 2 at the specified X and Y coordinates. The origin is in
 * the upper left-hand corner of the drawing.
 */
-(UIBezierPath *)drawShapeThreeAtX:(CGFloat)X andY:(CGFloat)Y
{
    UIBezierPath *squiggle = [[UIBezierPath alloc] init];
    [squiggle moveToPoint:CGPointMake(X, Y + SQUIGGLE_START_POINT_VERTICAL_OFFSET_PROPORTION * [self shapeHeight])];
    [squiggle addQuadCurveToPoint:CGPointMake((X + SQUIGGLE_FIRST_END_POINT_HORIZONTAL_OFFSET_PROPORTION * [self shapeWidth]), Y + [self shapeHeight] * SQUIGGLE_FIRST_END_POINT_VERTICAL_OFFSET_PROPORTION)
                     controlPoint:CGPointMake(X + SQUIGGLE_FIRST_CONTROL_POINT_HORIZONTAL_OFFSET_PROPORTION * [self shapeWidth], Y - SQUIGGLE_FIRST_CONTROL_POINT_VERTICAL_OFFSET_PROPORTION * [self shapeHeight])];
    [squiggle addQuadCurveToPoint:CGPointMake(X + SQUIGGLE_SECOND_END_POINT_HORIZONTAL_OFFSET_PROPORTION * [self shapeWidth], Y + SQUIGGLE_SECOND_END_POINT_VERTICAL_OFFSET_PROPORTION * [self shapeHeight])
                     controlPoint:CGPointMake(X + SQUIGGLE_SECOND_CONTROL_POINT_HORIZONTAL_OFFSET_PROPORTION * [self shapeWidth], Y + SQUIGGLE_SECOND_CONTROL_POINT_VERTICAL_OFFSET_PROPORTION * [self shapeHeight])];
    [squiggle addQuadCurveToPoint:CGPointMake(X + SQUIGGLE_THIRD_END_POINT_HORIZONTAL_OFFSET_PROPORTION * [self shapeWidth], Y + SQUIGGLE_THIRD_END_POINT_VERTICAL_OFFSET_PROPORTION * [self shapeHeight])
                     controlPoint:CGPointMake(X + SQUIGGLE_THIRD_CONTROL_POINT_HORIZONTAL_OFFSET_PROPORTION * [self shapeWidth], Y - SQUIGGLE_THIRD_CONTROL_POINT_VERTICAL_OFFSET_PROPORTION * [self shapeHeight])];
    [squiggle addQuadCurveToPoint:CGPointMake(X + SQUIGGLE_FOURTH_END_POINT_HORIZONTAL_OFFSET_PROPORTION * [self shapeWidth], Y + SQUIGGLE_FOURTH_END_POINT_VERTICAL_OFFSET_PROPORTION * [self shapeHeight])
                     controlPoint:CGPointMake(X + SQUIGGLE_FOURTH_CONTROL_POINT_HORIZONTAL_OFFSET_PROPORTION * [self shapeWidth], Y + SQUIGGLE_FOURTH_CONTROL_POINT_VERTICAL_OFFSET_PROPORTION * [self shapeHeight])];
    [squiggle addQuadCurveToPoint:CGPointMake(X + SQUIGGLE_FIFTH_END_POINT_HORIZONTAL_OFFSET_PROPORTION * [self shapeWidth], Y + SQUIGGLE_FIFTH_END_POINT_VERTICAL_OFFSET_PROPORTION * [self shapeHeight])
                     controlPoint:CGPointMake(X + SQUIGGLE_FIFTH_CONTROL_POINT_HORIZONTAL_OFFSET_PROPORTION * [self shapeWidth], Y + SQUIGGLE_FIFTH_CONTROL_POINT_VERTICAL_OFFSET_PROPORTION * [self shapeHeight])];
    [squiggle addQuadCurveToPoint:CGPointMake(X + SQUIGGLE_SIXTH_END_POINT_HORIZONTAL_OFFSET_PROPORTION * [self shapeWidth], Y + SQUIGGLE_SIXTH_END_POINT_VERTICAL_OFFSET_PROPORTION * [self shapeHeight])
                     controlPoint:CGPointMake(X + SQUIGGLE_SIXTH_CONTROL_POINT_HORIZONTAL_OFFSET_PROPORTION * [self shapeWidth], Y + SQUIGGLE_SIXTH_CONTROL_POINT_VERTICAL_OFFSET_PROPORTION * [self shapeHeight])];
    [squiggle closePath];
    
    CGContextRef ref = UIGraphicsGetCurrentContext();
    CGContextSaveGState(ref);
    [squiggle addClip];
    [self fillShape:squiggle];
    CGContextRestoreGState(ref);
    
    return squiggle;
}

-(void)fillShape:(UIBezierPath *)path
{
    switch (self.pattern) {
        case 1:
            break;
        case 2:
            [self drawStripesOnBezierPath:path];
            break;
        case 3:
            [[self getColorToDraw] set];
            [path fill];
            break;
        default:
            break;
    }
}

#define STRIPE_SEPARATION_MULTIPLIER 3
-(void)drawStripesOnBezierPath:(UIBezierPath *)path
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    for (int i = 0; i < path.bounds.size.width; i += STRIPE_SEPARATION_MULTIPLIER) {
        CGContextMoveToPoint(context, path.bounds.origin.x + i, CGRectGetMinY(path.bounds));
        CGContextAddLineToPoint(context, path.bounds.origin.x + i, CGRectGetMaxY(path.bounds));
    }
    
    CGContextStrokePath(context);
}

/* Method: validColors
 * -------------------
 * Returns an array of all the valid colors in the game. */
-(NSArray *)validColors
{
    return @[[UIColor redColor], [UIColor greenColor], [UIColor purpleColor]];
}


-(void)setup
{
    self.backgroundColor = nil;
    self.opaque = NO;
    self.contentMode = UIViewContentModeRedraw;
}

-(void)awakeFromNib
{
    [self setup];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
        // Initialization code
    }
    return self;
}


@end
