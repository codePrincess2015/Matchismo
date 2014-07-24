//
//  CardMatchingGame.h
//  Matchismo
//
//  Created by Harshitha Ramesh on 4/14/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Deck.h"
#import "Card.h"

@interface CardMatchingGame : NSObject

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck;


-(void)chooseCardAtIndex:(NSUInteger)index usingMatchMode:(NSInteger)matchNum;
-(Card *)cardAtIndex:(NSUInteger)index;

@property (nonatomic, readwrite) NSInteger score;
@property (nonatomic, readwrite) NSInteger matchScore;
@property (nonatomic,strong) NSMutableArray* cardsChosen;
@property (nonatomic, strong) NSMutableArray *cards;
@property (nonatomic,strong) Deck *currentDeck;
@end
