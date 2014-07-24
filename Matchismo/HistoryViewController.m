//
//  HistoryViewController.m
//  Matchismo
//
//  Created by Harshitha Ramesh on 4/23/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//


#import "HistoryViewController.h"

@interface HistoryViewController()
@property (weak, nonatomic) IBOutlet UITextView *display;

@end

@implementation HistoryViewController

- (void) viewDidLoad{
    NSMutableAttributedString *builtString = [[NSMutableAttributedString alloc] initWithString:@""];
    for (NSMutableAttributedString *string in self.history){
         [builtString appendAttributedString:string];
    }
    self.display.attributedText = builtString;
}
@end
