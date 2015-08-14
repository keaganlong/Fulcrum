//
//  AggregationAlgorithm.m
//  Fulcrum
//
//  Created by Keagan Long on 3/8/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AggregationAlgorithm.h"
#define PHYSICAL_SCORE_WEIGHT 0.3
#define SLEEP_QUALITY_WEIGHT 0.4
#define ACTIVE_CALORIES_WEIGHT 0.3

@implementation AggregationAlgorithm

+(NSNumber*)phyiscalScoreWithDailySurveyScore:(NSNumber*)dailySurveyPhysicalScore sleepQuality:(NSNumber*)sleepQuality activeCalories:(NSNumber*)activeCalories{
    NSMutableArray* values = [NSMutableArray new];
    NSMutableArray* weights = [NSMutableArray new];
    CGFloat totalWeight = 0.0;
    if(dailySurveyPhysicalScore != nil){
        totalWeight += PHYSICAL_SCORE_WEIGHT;
        CGFloat floatDecimalValue = ([dailySurveyPhysicalScore floatValue]-1.0) / 4.0;
        [values addObject:[NSNumber numberWithFloat:floatDecimalValue]];
        NSNumber* weightNumber = [NSNumber numberWithFloat:PHYSICAL_SCORE_WEIGHT];
        [weights addObject:weightNumber];
    }
    if(sleepQuality != nil){
        totalWeight += SLEEP_QUALITY_WEIGHT;
        CGFloat floatDecimalValue = [sleepQuality floatValue] / 100.0;
        [values addObject:[NSNumber numberWithFloat:floatDecimalValue]];
        NSNumber* weightNumber = [NSNumber numberWithFloat:SLEEP_QUALITY_WEIGHT];
        [weights addObject:weightNumber];
    }
    if(activeCalories != nil){
        totalWeight += ACTIVE_CALORIES_WEIGHT;
        CGFloat floatDecimalValue = [activeCalories floatValue] / 500.0;
        if(floatDecimalValue > 1.0){
            floatDecimalValue = 1.0;
        }
        [values addObject:[NSNumber numberWithFloat:floatDecimalValue]];
        NSNumber* weightNumber = [NSNumber numberWithFloat:ACTIVE_CALORIES_WEIGHT];
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
        aggregateValue += 1.0+currValue*currWeight*4.0;
    }
    NSNumber* output = [NSNumber numberWithFloat:aggregateValue];
    return output;
}

@end