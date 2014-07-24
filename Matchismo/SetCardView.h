//
//  SetCardView.h
//  Graphical Set
//
//  Created by Ian on 4/27/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardView.h"

@interface SetCardView : CardView

// The following four properties each correspond to an index in their respective array of possible values.
@property (nonatomic) NSUInteger symbol;
@property (nonatomic) NSUInteger number;
@property (nonatomic) NSUInteger pattern;
@property (nonatomic) NSUInteger cardColor;

-(void)drawShapesOnCard;

@end
