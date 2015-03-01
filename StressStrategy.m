//
//  StressStrategy.m
//  Fulcrum
//
//  Created by Keagan Long on 2/3/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "StressStrategy.h"

#define LOWER_BOUND 0
#define UPPER_BOUND 20
#define MIN_HEIGHT 20
#define MAX_HEIGHT 120


@implementation StressStrategy

-(CGFloat)getBarHeigthFromTotalStress:(NSInteger)totalStress{
    CGFloat portion = ((CGFloat)totalStress)/(UPPER_BOUND-LOWER_BOUND);
    if(portion > 1.0){
        portion =  1.0;
    }
    return MIN_HEIGHT+portion*(MAX_HEIGHT-MIN_HEIGHT);
}

-(UIColor*)getBarColorFromTotalStress:(NSInteger)totalStress{
    CGFloat barHeight = [self getBarHeigthFromTotalStress:totalStress];
    float red = 0.0;
    float green = 1.0-((2.0*barHeight)/255.0);
    float blue = 0.6;
    float lowerBound = 0.2;
    float upperBound = 0.6;
    green = (upperBound-lowerBound)*green+lowerBound;
    blue = green*2;
    UIColor* color = [UIColor colorWithRed:red green:green blue:blue alpha:0.8];
    return color;
}

@end