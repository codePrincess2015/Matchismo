//
//  PlayingCard.m
//  Matchismo
//
//  Created by Ian on 4/7/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "PlayingCard.h"

@implementation PlayingCard

/* Method: match
 * --------------
 * Compares the card in question to other cards in the NSArray and
 * awards points for suit or rank matches.
 * Change hard-coded values to constants.
 */
- (int)match:(NSArray *)otherCards
{
    int score = 0;
    
    if ([otherCards count] == 2) { // Look for a match of three
        // Search for rank first
        NSUInteger rankToMatch = self.rank;
        for (int i = 0; i < [otherCards count]; i++) {
            if (((PlayingCard *)otherCards[i]).rank != rankToMatch) {
                break;
            }
            if (i == ([otherCards count] - 1)) {
                score = 12;
            }
        }
        
        if (score == 0) { // Search for suit
            NSString *suitToMatch = self.suit;
            for (int i = 0; i < [otherCards count]; i++) {
                if (![((PlayingCard *)otherCards[i]).suit isEqualToString:suitToMatch]) { // if the suits don't match
                    break;
                }
                if (i == ([otherCards count] - 1)) {
                    score = 3;
                }
            }
        }
        if (score != 0) return score; // if match is found, no use looking for pair matches
        // Otherwise, look for a match of two
        PlayingCard *cardOne = (PlayingCard *) otherCards[0];
        PlayingCard *cardTwo = (PlayingCard *) otherCards[1];
        if (cardOne.rank == cardTwo.rank) {
            score = 4;
        } else if ([cardOne.suit isEqualToString:cardTwo.suit]) {
            score = 1;
        }
    }
    // handles 2 card matching (but not exclusively for 2-card-matching mode)
    for (PlayingCard *otherCard in otherCards) {
        if (otherCard.rank == self.rank) {
            score += 4;
        } else if ([otherCard.suit isEqualToString:self.suit]) {
            score += 1;
        }
    }

    return score;
}

- (NSString *)contents
{
    NSArray *rankStrings = [PlayingCard rankStrings];
    return [rankStrings[self.rank] stringByAppendingString:self.suit];
}

@synthesize suit = _suit; // because we supply setter AND getter

+ (NSArray *)validSuits
{
    return @[@"♠️",@"♣️",@"♥️",@"♦️"];
}

- (void)setSuit:(NSString *)suit
{
    if ([[PlayingCard validSuits] containsObject:suit]) {
        _suit = suit;
    }
}

- (NSString *)suit
{
    return _suit ? _suit : @"?";
}

+ (NSArray *)rankStrings
{
    return @[@"?",@"A",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"J",@"Q",@"K"];
}

+ (NSUInteger)maxRank { return [[self rankStrings] count]-1; }

- (void)setRank:(NSUInteger)rank
{
    if (rank <= [PlayingCard maxRank]) {
        _rank = rank;
    }
}

@end
