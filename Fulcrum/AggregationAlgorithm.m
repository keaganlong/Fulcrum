//
//  AggregationAlgorithm.m
//  Fulcrum
//
//  Created by Keagan Long on 3/8/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AggregationAlgorithm.h"
#define PHYSICAL_SCORE_WEIGHT 0.5
#define SLEEP_QUALITY_WEIGHT 0.5

@implementation AggregationAlgorithm

+(NSNumber*)phyiscalScoreWithDailySurveyScore:(NSNumber*)dailySurveyPhysicalScore sleepQuality:(NSNumber*)sleepQuality{
    NSMutableArray* values = [NSMutableArray new];
    NSMutableArray* weights = [NSMutableArray new];
    CGFloat totalWeight = 0.0;
    if(dailySurveyPhysicalScore != nil){
        totalWeight += PHYSICAL_SCORE_WEIGHT;
        [values addObject:dailySurveyPhysicalScore];
        NSNumber* weightNumber = [NSNumber numberWithFloat:PHYSICAL_SCORE_WEIGHT];
        [weights addObject:weightNumber];
    }
    if(sleepQuality != nil){
        totalWeight += SLEEP_QUALITY_WEIGHT;
        [values addObject:sleepQuality];
        NSNumber* weightNumber = [NSNumber numberWithFloat:SLEEP_QUALITY_WEIGHT];
        [weights addObject:weightNumber];
    }
    
    if([values count]==0){
        return nil;
    }
    
    CGFloat aggregateValue = 0.0;
    
    for(int i = 0; i<[values count];i++){
        CGFloat currValue = [[values objectAtIndex:i] floatValue];
        CGFloat currWeight = [[weights objectAtIndex:i] floatValue];
        currWeight/=totalWeight;
        aggregateValue += currValue*currWeight;
    }
    NSNumber* output = [NSNumber numberWithFloat:aggregateValue];
    return output;
}

@end