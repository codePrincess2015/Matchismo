//
//  Card.h
//  Matchismo
//
//  Created by Harshitha Ramesh on 4/7/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Card : NSObject
@property (strong, nonatomic) NSString *contents;

@property (nonatomic, getter=isChosen) BOOL chosen;
@property (nonatomic, getter=isMatched) BOOL matched;
- (int)match:(NSMutableArray *) otherCards;
@end
