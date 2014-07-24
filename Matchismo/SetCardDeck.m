//
//  SetCardDeck.m
//  Matchismo
//
//  Created by Harshitha Ramesh on 4/20/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "SetCardDeck.h"

@implementation SetCardDeck

- (instancetype)init
{
    self = [super init];
    if (self) {
        for(int pattern = 1; pattern <=  MAX_PATTERNS; pattern++){
           for(int color = 1; color <=  MAX_COLORS; color++) {
                for(int num = 1; num <=  MAX_NUMS; num++){
                    for(int symbol = 1; symbol <=  MAX_SYMBOLS; symbol++){
                        SetCard *card = [[SetCard alloc] init];
                        card.color = color;
                        card.symbol = symbol;
                        card.num = num;
                        card.pattern = pattern;
                        [self addCard:card];
                    }
                }
            }
        }
    }
    return self;
}
@end
