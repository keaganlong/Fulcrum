//
//  StressStrategy.m
//  Fulcrum
//
//  Created by Keagan Long on 2/3/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StressStrategy.h"

#define NUM_EVENTS_LOWER_BOUND 0
#define NUM_EVENTS_UPPER_BOUND 10
#define STRESS_LEVEL_LOWER_BOUND 0
#define STRESS_LEVEL_UPPER_BOUND 23
#define MIN_HEIGHT 0
#define MAX_HEIGHT 120


@implementation StressStrategy

+(CGFloat)getBarHeigthFromNumberOfEvents:(NSInteger)numberEvents{
    CGFloat portion = ((CGFloat)numberEvents)/(NUM_EVENTS_UPPER_BOUND-NUM_EVENTS_LOWER_BOUND);
    if(portion > 1.0){
        portion =  1.0;
    }
    return MIN_HEIGHT+portion*(MAX_HEIGHT-MIN_HEIGHT);
}

+(UIColor*)getBarColorFromTotalStress:(NSInteger)totalStress{
    CGFloat portion = ((CGFloat)totalStress)/(STRESS_LEVEL_UPPER_BOUND-STRESS_LEVEL_LOWER_BOUND);
    if(portion > 1.0){
        portion = 1.0;
    }
    float red = 0.0;
    float green = 1.0-portion;
    float blue = 0.6;
    float lowerBound = 0.2;
    float upperBound = 0.6;
    green = (upperBound-lowerBound)*green+lowerBound;
    blue = green*2;
    UIColor* color = [UIColor colorWithRed:red green:green blue:blue alpha:0.8];
    return color;
}

@end