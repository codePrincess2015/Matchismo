//
//  CardGame.h
//  Matchismo
//
//  Created by Harshitha Ramesh on 5/6/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CardView : UIView
@property (strong,nonatomic) UIBezierPath *roundedRect;
@property (nonatomic) BOOL selected;

- (void) changeSelection:(UIColor*) color;

@end
