//
//  SetCard.h
//  Matchismo
//
//  Created by Harshitha Ramesh on 4/20/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Card.h"

@interface SetCard : Card
@property(nonatomic) NSUInteger symbol;
@property(nonatomic) NSUInteger color;
@property(nonatomic) NSUInteger num;
@property(nonatomic) NSUInteger pattern;
#define MAX_PATTERNS 3
#define MAX_SYMBOLS 3
#define MAX_COLORS 3
#define MAX_NUMS 3
- (BOOL) checkSymbols:(NSArray *) otherCards;
- (BOOL) checkPatterns:(NSArray *) otherCards;
- (BOOL) checkNums:(NSArray *) otherCards;
- (BOOL) checkColors: (NSArray *) otherCards;

@end
