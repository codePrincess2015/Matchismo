//
//  SetGameViewController.m
//  Matchismo
//
//  Created by Harshitha Ramesh on 4/21/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "SetGameViewController.h"
#import "SetCardDeck.h"
#import "Grid.h"
#import "SetCard.h"
#import "SetCardView.h"

@interface SetGameViewController()



@end
@implementation SetGameViewController

- (Deck *)createDeck
{
    return [[SetCardDeck alloc] init];
}

- (IBAction)drawThree:(id)sender {
    for (int i = 0; i < 3; i++ ){
        Card *card = [self.game.currentDeck drawRandomCard];
        if(card == nil) {
            break;
        }
        [self.game.cards addObject:card];
    }
    self.rearrangeNeeded = true;
    [self rearrangeCards];
}



- (void)viewDidLoad
{
    [super viewDidLoad];
    self.initNumCards = 12;
    self.matchNum = 3;
    [self rearrangeCards];
}

- (UIColor *) backgroundColorForCard:(Card *) card {
    if(card.isChosen) return [UIColor cyanColor];
    else return [UIColor whiteColor];
}

- (void) modifyView:(UIView *)view withSelection:(BOOL)choice{
    SetCardView *setView = (SetCardView*) view;
    [setView setSelected:choice];
}

- (void) rearrangeCards {
    self.cardsGrid.size = self.cardsView.bounds.size;
   [super rearrangeCards];
    NSUInteger limit = [self.game.cards count];
    int count = 0;
    for(int i = 0; i < self.cardsGrid.rowCount; i++){
        for(int j = 0; j < self.cardsGrid.columnCount;j++){
            if (count < limit) {
                SetCardView *cv  = [[SetCardView alloc] initWithFrame:[self.cardsGrid frameOfCellAtRow:i inColumn:j]];
                [self.cardsView addSubview:cv];
                [self.cardsArray addObject:cv];
                [self recognizeTouch:cv];
                [self recognizePan:cv];
                
                CGRect newFrame = cv.frame; newFrame.origin.x = -200; newFrame.origin.y = -200; cv.frame = newFrame;
                [UIView animateWithDuration:1.0
                                      delay:0.5
                                    options:UIViewAnimationOptionCurveEaseInOut
                                 animations:^{cv.frame = [self.cardsGrid frameOfCellAtRow:i inColumn:j];}
                                 completion:nil];
                count++;
            }
        }
    }
    NSMutableArray *cards = self.game.cards;
    NSMutableArray *views = self.cardsArray;
    for (int i = 0; i < [cards count]; i++){
        SetCard *randomCard = (SetCard*) cards[i];
        SetCardView *view = (SetCardView *)views[i];
        if(randomCard.isChosen) {
            [view setSelected:true];
        }
        [view setNumber:randomCard.num];
        [view setCardColor:randomCard.color];
        [view  setSymbol:randomCard.symbol];
        [view setPattern:randomCard.pattern];
        
    }
    self.rearrangeNeeded = false;
}




@end
