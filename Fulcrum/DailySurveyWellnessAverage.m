//
//  DailySurveyWellnessAverage.m
//  Fulcrum
//
//  Created by Keagan Long on 1/13/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DailySurveyWellnessAverage.h"
#import "DailySurveyQuestionResponse.h"

@implementation DailySurveyWellnessAverage

-(id)initWithDailySurveyQuestionResponses:(NSMutableArray*)dailySurveyQuetionResponses{
    self = [super init];
    if(self){
        CGFloat emotionalTotal = 0;
        CGFloat socialTotal = 0;
        CGFloat academicTotal = 0;
        CGFloat physicalTotal = 0;
        DailySurveyQuestionResponse* questionResponse = [dailySurveyQuetionResponses objectAtIndex:0];
        emotionalTotal += [questionResponse value];
        questionResponse = [dailySurveyQuetionResponses objectAtIndex:1];
        emotionalTotal += [questionResponse value];
        questionResponse = [dailySurveyQuetionResponses objectAtIndex:2];
        emotionalTotal += [questionResponse value];
        questionResponse = [dailySurveyQuetionResponses objectAtIndex:3];
        socialTotal += [questionResponse value];
        questionResponse = [dailySurveyQuetionResponses objectAtIndex:4];
        socialTotal += [questionResponse value];
        //etc
        
        NSNumber* emotionalAverage = [NSNumber numberWithFloat:(emotionalTotal/3.0)];
        [self setEmotionalAverage:emotionalAverage];
        
    }
    return self;
}

@end