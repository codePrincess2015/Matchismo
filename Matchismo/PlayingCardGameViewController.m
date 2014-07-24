//
//  PlayingCardGameViewController.m
//  Matchismo
//
//  Created by Harshitha Ramesh on 4/22/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "PlayingCardGameViewController.h"
#import "PlayingCardDeck.h"
#import "PlayingCard.h"
#import "PlayingcardView.h"


@interface PlayingCardGameViewController ()

@end

@implementation PlayingCardGameViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.matchNum = 2;
    self.initNumCards = 21;
    [self rearrangeCards];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (Deck *)createDeck
{
    return [[PlayingCardDeck alloc] init];
}


- (UIImage *) backgroundImageForCard:(Card *) card{
    return [UIImage imageNamed:card.isChosen ? @"cardfront" : @"cardback"];
}

- (void) rearrangeCards {
    // self.cardsGrid.size = self.cardsView.bounds.size;
    [super rearrangeCards];
    NSUInteger limit = [self.game.cards count];
    int count = 0;
    for(int i = 0; i < self.cardsGrid.rowCount; i++){
        for(int j = 0; j < self.cardsGrid.columnCount;j++){
            if (count < limit) {
                PlayingCardView *cv  = [[PlayingCardView alloc] initWithFrame:[self.cardsGrid frameOfCellAtRow:i inColumn:j]]; 
                [self.cardsView addSubview:cv];
                [self.cardsArray addObject:cv];
                [self recognizeTouch:cv];
                [self recognizePan:cv];
                
                CGRect newFrame = cv.frame; newFrame.origin.x = -200; newFrame.origin.y = -200; cv.frame = newFrame;
                [UIView animateWithDuration:1.0
                                      delay:1.5
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
        PlayingCard *randomCard = (PlayingCard*) cards[i];
        PlayingCardView *view = (PlayingCardView *)views[i];
        if(randomCard.isChosen) {
            [view setSelected:true];
        }
        [view setRank:randomCard.rank];
        [view setSuit:randomCard.suit];
        
    }
    self.rearrangeNeeded = false;
}
- (void) modifyView:(UIView *)view withSelection:(BOOL)choice{
    PlayingCardView *playingView = (PlayingCardView*) view;
    [playingView setSelected:choice];
}


- (NSMutableAttributedString *) titleForCard:(Card *)card {
    PlayingCard *playingCard = (PlayingCard *)card;
    NSMutableAttributedString * content;
    if(card.isChosen) {
        NSString *suit = playingCard.suit;
        UIColor *fontColor;
        if ([suit isEqualToString:@"♥️"] || [suit isEqualToString:@"♦️"]){
            fontColor = [UIColor redColor];
        } else {
            fontColor = [UIColor blackColor];
        }
        content = [[NSMutableAttributedString alloc] initWithString:card.contents attributes:@{NSForegroundColorAttributeName:fontColor}];
    }
    else content = [[NSMutableAttributedString alloc] initWithString:@""];
    return content;
}
- (NSMutableAttributedString *) getCardLabel: (Card *) card{
    PlayingCard *playingCard = (PlayingCard *)card;
    NSMutableAttributedString * content;
    NSString *suit = playingCard.suit;
    UIColor *fontColor;
    if ([suit isEqualToString:@"♥️"] || [suit isEqualToString:@"♦️"]){
        fontColor = [UIColor redColor];
    } else {
        fontColor = [UIColor blackColor];
    }
    content = [[NSMutableAttributedString alloc] initWithString:card.contents attributes:@{NSForegroundColorAttributeName:fontColor}];
    return content;
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
 {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
