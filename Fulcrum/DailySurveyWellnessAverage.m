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
        emotionalTotal += [[questionResponse value] intValue];
        questionResponse = [dailySurveyQuetionResponses objectAtIndex:1];
        emotionalTotal += [[questionResponse value] intValue];
        questionResponse = [dailySurveyQuetionResponses objectAtIndex:2];
        emotionalTotal += [[questionResponse value] intValue];
        
        questionResponse = [dailySurveyQuetionResponses objectAtIndex:3];
        academicTotal += [[questionResponse value] intValue];
        questionResponse = [dailySurveyQuetionResponses objectAtIndex:4];
        academicTotal += [[questionResponse value] intValue];
        questionResponse = [dailySurveyQuetionResponses objectAtIndex:5];
        academicTotal += [[questionResponse value] intValue];
        
        questionResponse = [dailySurveyQuetionResponses objectAtIndex:6];
        physicalTotal += [[questionResponse value] intValue];
        questionResponse = [dailySurveyQuetionResponses objectAtIndex:7];
        physicalTotal += [[questionResponse value] intValue];
        
        questionResponse = [dailySurveyQuetionResponses objectAtIndex:8];
        socialTotal += [[questionResponse value] intValue];
        questionResponse = [dailySurveyQuetionResponses objectAtIndex:9];
        socialTotal += [[questionResponse value] intValue];
        
        
        NSNumber* emotionalAverage = [NSNumber numberWithFloat:(emotionalTotal/3.0)];
        [self setEmotionalAverage:emotionalAverage];
        NSNumber* academicAverage = [NSNumber numberWithFloat:(academicTotal/3.0)];
        [self setAcademicAverage:academicAverage];
        NSNumber* physicalAverage = [NSNumber numberWithFloat:(physicalTotal/2.0)];
        [self setPhysicalAverage:physicalAverage];
        NSNumber* socialAverage = [NSNumber numberWithFloat:(socialTotal/2.0)];
        [self setSocialAverage:socialAverage];
        
    }
    return self;
}

@end