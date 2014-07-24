//
//  CardGameViewController.m
//  Matchismo
//
//  Created by Harshitha Ramesh on 4/7/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "CardGameViewController.h"
#import "HistoryViewController.h"
#import "PlayingCardDeck.h"
#import "CardMatchingGame.h"
#import "PlayingCard.h"
#import "CardView.h"


@interface CardGameViewController ()  <UIDynamicAnimatorDelegate>
@property (strong,nonatomic) id<UIDynamicItem> item;
@property (strong,nonatomic) UIDynamicAnimator *animator;


@end

@implementation CardGameViewController

- (IBAction)reDeal:(UIButton *)sender {
    self.cardsGrid.size = self.cardsView.bounds.size;
    self.move = nil;
    self.cardsAppended = nil;
    self.game = nil;
    self.rearrangeNeeded = true;
    [self rearrangeCards];
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: 0"];
    
}

- (NSMutableArray *) cardsArray
{
    if (!_cardsArray) _cardsArray = [[NSMutableArray alloc] init];
    return _cardsArray;
}


- (CardMatchingGame *) game
{
    if (!_game) _game = [[[CardMatchingGame alloc] init]initWithCardCount:self.initNumCards usingDeck:[self createDeck]];
    return _game;
}


- (Deck *)createDeck
{
    return nil;
}

- (NSMutableArray *) pile
{
    if (!_pile) _pile = [[NSMutableArray alloc] init];
    return _pile;
}

- (UIDynamicAnimator *) animator{
    if(!_animator) _animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.cardsView];
    return _animator;
    
}


- (NSMutableAttributedString *) move{
    if(!_move) _move = [[NSMutableAttributedString alloc] initWithString:@""];
    return _move;
}

- (Grid *) cardsGrid{
    if (!_cardsGrid) _cardsGrid = [[Grid alloc] init];
    return _cardsGrid;
}


- (void) viewDidLoad {
    [super viewDidLoad];
    self.cardsGrid.size = self.cardsView.bounds.size;
    self.cardsGrid.cellAspectRatio = 0.5;
    self.cardsGrid.minimumNumberOfCells = 15;
     [self recognizePinch:self.cardsView];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([segue.identifier isEqualToString:@""]){
        
    }
}
- (void) recognizeTouch: (CardView *) view
{
    UITapGestureRecognizer *tapgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touch:)];
    [view addGestureRecognizer:tapgr];
    
}

- (void) recognizePinch: (UIView *)view{
    UIPinchGestureRecognizer *pinchgr = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(pinch:)];
    [view addGestureRecognizer:pinchgr];
}

- (void) recognizePan: (CardView*) view
{
    UIPanGestureRecognizer *pangr = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [view addGestureRecognizer:pangr];
}

-(void) touch:(UITapGestureRecognizer *) tapgr
{
    int count = 0;
    if(self.inPile){
        for(int i = 0; i < self.cardsGrid.rowCount; i++){
            for(int j = 0; j < self.cardsGrid.columnCount;j++){
                if(count < [self.cardsArray count]){
                    CardView *card = self.cardsArray[count];
                    count++;
                    [UIView animateWithDuration:0.5
                                          delay:0.5
                                        options:UIViewAnimationOptionCurveEaseInOut
                                     animations:^{
                                        CGRect newFrame =[self.cardsGrid frameOfCellAtRow:i inColumn:j];
                                         card.frame = newFrame;}
                                     completion:^(BOOL finished){}];
                }
            }
        }
        self.inPile = false;
        [self.animator removeAllBehaviors];
        
    }
    else{
        NSUInteger chosenIndex = [self.cardsArray indexOfObject:tapgr.view];
        [self.game chooseCardAtIndex:chosenIndex usingMatchMode:self.matchNum];
        [self updateUI];
    }
}

- (void) pinch:(UIPinchGestureRecognizer *) pinchgr
{
    if (pinchgr.state == UIGestureRecognizerStateEnded)
    {
        for(CardView* view in self.cardsArray){
            UISnapBehavior *snap = [[UISnapBehavior alloc] initWithItem:view snapToPoint:CGPointMake(self.cardsView.bounds.size.width/2, self.cardsView.bounds.size.height/2)];
            snap.damping = 0.75f;
            [self.animator addBehavior:snap];
            [self.pile addObject:snap];
            self.inPile = true;
        }
    }
    
}
- (void) pan:(UIPanGestureRecognizer *) pangr
{
    if(self.inPile){
        if ((pangr.state == UIGestureRecognizerStateChanged) ||
            (pangr.state == UIGestureRecognizerStateEnded)) {
            self.moved = (CardView*)pangr.view;
            CGPoint translation = [pangr translationInView:pangr.view];
            pangr.view.center = CGPointMake(pangr.view.center.x + translation.x, pangr.view.center.y+translation.y);
            [pangr setTranslation:CGPointMake(0,0) inView:pangr.view];
            [self moveOtherCards];
        }
    }
}
- (void) moveOtherCards{
    CGRect frame = self.moved.frame;
    for(CardView *card in self.cardsArray){
        card.frame = frame;
    }
}

- (void)updateUI{
    NSMutableArray *cardsToRemove = [[NSMutableArray alloc]init];
    int count = 0;
    for (CardView *view in self.cardsArray){
        NSUInteger index = [self.cardsArray indexOfObject:view];
        Card *card = [self.game cardAtIndex:index];
        if(view.selected != card.chosen) {
            
            if([card isKindOfClass:[PlayingCard class]]) {
            [UIView transitionWithView:view
                              duration:0.3
                               options:UIViewAnimationOptionTransitionFlipFromRight
                            animations:^{
                                [self modifyView:view withSelection:card.chosen];
                            }
                            completion:nil];
            
            }
            
            else [self modifyView:view withSelection:card.chosen];
 
        }
        
        if(card.matched){
            self.rearrangeNeeded = true;
            [cardsToRemove addObject:card];
            count++;
        }
    }
    if(self.rearrangeNeeded) {
        for (Card *card in cardsToRemove){
            [self.game.cards removeObject:card];
        }
        [self rearrangeCards];
        self.rearrangeNeeded = false;
        
        
    }
    self.cardsAppended = self.game.cardsChosen;
    NSInteger numCards = [self.cardsAppended count];
    [self updateLabel:numCards];
}

- (void)updateLabel:(NSInteger)numCards{
    self.scoreLabel.text = [NSString stringWithFormat:@"Score: %ld",(long)self.game.score];

}

- (void) rearrangeCards
{
    self.inPile = false;
    self.cardsGrid.minimumNumberOfCells = [self.game.cards count];
    
    if(self.rearrangeNeeded){
        for (int i = 0; i < [self.cardsArray count]; i++){
            CardView *cv = self.cardsArray[i];
            [UIView animateWithDuration:0.5
                                  delay:0.25
                                options:UIViewAnimationOptionCurveEaseInOut
                             animations:^{CGRect newFrame = cv.frame; newFrame.origin.x = -200; newFrame.origin.y = -200; cv.frame = newFrame;}
                             completion:^(BOOL finished){[cv removeFromSuperview];}];
            
        }
    }
    [self.cardsArray removeAllObjects];
   
}

- (void) modifyView:(UIView *)view withSelection:(BOOL)choice{
    /* abstract */
}
- (NSMutableAttributedString *) titleForCard:(Card *)card{
    /* abstract*/
    return nil;
}

- (UIColor *) backgroundColorForCard:(Card *) card {
    /* abstract */
    
    return nil;
}




@end
