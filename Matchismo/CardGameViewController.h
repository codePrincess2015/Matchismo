//
//  CardGameViewController.h
//  Matchismo
//
//  Created by Harshitha Ramesh on 4/7/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CardMatchingGame.h"
#import "CardView.h"
#import "Grid.h"

@interface CardGameViewController : UIViewController
- (void) updateUI; //protected

@property (nonatomic) NSMutableAttributedString *move;
@property (weak, nonatomic) IBOutlet UILabel *scoreLabel;
@property (nonatomic) NSMutableArray *cardsAppended;
@property (strong, nonatomic) CardMatchingGame *game;
@property(nonatomic) NSInteger matchNum;
@property (weak, nonatomic) IBOutlet UIView *cardsView;
@property (strong, nonatomic) NSMutableArray *cardsArray;
@property (nonatomic) BOOL rearrangeNeeded;
@property (nonatomic) BOOL inPile;
@property (strong, nonatomic) Deck *deck;
@property(nonatomic) NSInteger initNumCards;
@property (strong,nonatomic) NSMutableArray *pile;
@property (strong,nonatomic) CardView *moved;
@property (strong,nonatomic) Grid *cardsGrid;

- (void) recognizeTouch: (CardView *)view;
- (void) recognizePinch: (UIView*) view;
- (void) recognizePan: (CardView *)view;
- (void) modifyView:(UIView *)view withSelection:(BOOL)choice;
- (void) rearrangeCards;
@end
