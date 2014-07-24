//
//  CardMatchingGame.m
//  Matchismo
//
//  Created by Harshitha Ramesh on 4/14/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "CardMatchingGame.h"

@interface CardMatchingGame()
//@property (nonatomic,strong) NSMutableArray* cardsChosen;
@end

@implementation CardMatchingGame

- (NSMutableArray *)cards
{
    if (!_cards) _cards = [[NSMutableArray alloc] init];
    return _cards;
}

- (instancetype)initWithCardCount:(NSUInteger)count
                        usingDeck:(Deck *)deck
{
    self = [super init];
    
    if (self) {
        self.currentDeck = deck;
        for (int i = 0; i < count; i++){
            Card *card = [deck drawRandomCard];
            if (card) {
                [self.cards addObject:card];
            }
            else{
                self = nil;
                break;
            }
        }
        
    }
    return self;
}
- (NSMutableArray *) cardsChosen {
    if(!_cardsChosen) _cardsChosen = [NSMutableArray new];
    return _cardsChosen;
}
- (Card *)cardAtIndex:(NSUInteger)index
{
    return (index<[self.cards count]) ? self.cards[index] : nil;
}
static const int MISMATCH_PENALTY = 2;
static const int MATCH_BONUS = 4;
static const int COST_TO_CHOOSE = 1;

- (void)chooseCardAtIndex:(NSUInteger)index usingMatchMode:(NSInteger)matchNum
{
    
    if ([self.cardsChosen count] == matchNum){
        BOOL keepOne = true;
        for(Card *card in self.cardsChosen){
            if(card.isMatched){
                self.cardsChosen = nil;
                keepOne = false;
                break;
            }
        }
        if(keepOne){
            Card *lastCard = self.cardsChosen[[self.cardsChosen count] - 1];
            [self.cardsChosen removeAllObjects];
            [self.cardsChosen addObject:lastCard];
        }
    }
    NSInteger limit = matchNum - 1;
    
    Card *card = [self cardAtIndex:index];
    if (!card.isMatched){
        if (card.isChosen) {
            card.chosen = NO;
            [self.cardsChosen removeObject:card];
        }
        else{
            for (Card *otherCard in self.cards){
                if (otherCard.isChosen && !otherCard.isMatched) {
                    if(![self.cardsChosen containsObject:otherCard]) {
                        [self.cardsChosen addObject:otherCard];
                    }
                    if([self.cardsChosen count] == limit){
                        int match = [card match:self.cardsChosen];
                        if (match){
                            self.matchScore = match + MATCH_BONUS;
                            self.score += self.matchScore;
                            for (Card *cardMatched in self.cardsChosen){
                                cardMatched.matched = YES;
                            }
                            card.matched = YES;
                        } else {
                            self.score -= MISMATCH_PENALTY;
                            for (Card *other in self.cardsChosen) {
                                other.chosen = NO;
                            }
                        }
                        break;
                    }
                }
            }
            self.score -= COST_TO_CHOOSE;
            if(![self.cardsChosen containsObject:card]) {
                [self.cardsChosen addObject:card];
            }
            card.chosen = YES;
        }
    }
}

@end
