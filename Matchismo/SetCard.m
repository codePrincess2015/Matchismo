//
//  SetCard.m
//  Matchismo
//
//  Created by Harshitha Ramesh on 4/20/14.
//  Copyright (c) 2014 Stanford University. All rights reserved.
//

#import "SetCard.h"

@implementation SetCard

//-(NSString *)contents {
//    //NSString *content = [ NSString stringWithFormat:@"%@ %@ %@ %@",self.num,self.symbol,self.color,self.pattern];
//    return content;
//    
//}

- (int)match:(NSMutableArray *) otherCards {
    [otherCards addObject:self];
    if([self checkSymbols:otherCards] && [self checkPatterns:otherCards] && [self checkNums:otherCards] && [self checkColors:otherCards] ) return 1;
    return 0;
}
- (BOOL) checkSymbols:(NSMutableArray *) otherCards {
    BOOL isAllSame = false;
    BOOL isAllDifferent = false;
    for (int i = 0; i < [otherCards count]; i++){
        SetCard *card1 = otherCards[i];
        for (int j = i+1; j < [otherCards count]; j++){
            SetCard *card2 = otherCards[j];
            if(card1.symbol == card2.symbol){
                if(isAllDifferent) return false;
                else if(!isAllSame) isAllSame = true;
            }
            else {
                if(isAllSame) return false;
                else if (!isAllDifferent) isAllDifferent = true;
            }
        }
    }
    
    return true;
}
- (BOOL) checkPatterns:(NSMutableArray *) otherCards {
    BOOL isAllSame = false;
    BOOL isAllDifferent = false;
    for (int i = 0; i < [otherCards count]; i++){
        SetCard *card1 = otherCards[i];
        for (int j = i+1; j < [otherCards count]; j++){
            SetCard *card2 = otherCards[j];
            if(card1.pattern == card2.pattern){
                if(isAllDifferent) return false;
                else if(!isAllSame) isAllSame = true;
            }
            else {
                if(isAllSame) return false;
                else if (!isAllDifferent) isAllDifferent = true;
            }
        }
    }
    return true;
}
- (BOOL) checkNums:(NSMutableArray *) otherCards {
    BOOL isAllSame = false;
    BOOL isAllDifferent = false;
    for (int i = 0; i < [otherCards count]; i++){
        SetCard *card1 = otherCards[i];
        for (int j = i+1; j < [otherCards count]; j++){
            SetCard *card2 = otherCards[j];
            if(card1.num  == card2.num){
                if(isAllDifferent) return false;
                else if(!isAllSame) isAllSame = true;
            }
            else {
                if(isAllSame) return false;
                else if (!isAllDifferent) isAllDifferent = true;
            }
        }
    }
    return true;
}
- (BOOL) checkColors: (NSMutableArray *) otherCards {
    BOOL isAllSame = false;
    BOOL isAllDifferent = false;
    for (int i = 0; i < [otherCards count]; i++){
        SetCard *card1 = otherCards[i];
        for (int j = i+1; j < [otherCards count]; j++){
            SetCard *card2 = otherCards[j];
            if(card1.color == card2.color){
                if(isAllDifferent) return false;
                else if(!isAllSame) isAllSame = true;
            }
            else {
                if(isAllSame) return false;
                else if (!isAllDifferent) isAllDifferent = true;
            }
        }
    }
    return true;
}


@end
