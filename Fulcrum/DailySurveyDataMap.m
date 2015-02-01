//
//  DailySurveyDataMap.m
//  Fulcrum
//
//  Created by Keagan Long on 1/13/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DailySurveyDataMap.h"
#import "DailySurveyResponse.h"
#import "DailySurveyWellnessAverage.h"
#import "DateService.h"

@implementation DailySurveyDataMap{
    NSMutableDictionary* dictionary;
}

-(id)init{
    self = [super init];
    if(self){
        dictionary = [NSMutableDictionary new];
    }
    return self;
}

-(id)initWithDailySurveyResponses:(NSMutableArray*)dailySurveyResponses{
    self = [self init];
    if(self){
        NSDate* candidateFirstDate;
        NSDate* candidateLastDate;
        for(int i = 0;i<[dailySurveyResponses count];i++){
            DailySurveyResponse* currDailySurveyResponse = [dailySurveyResponses objectAtIndex:i];
            NSDate* forDate = [currDailySurveyResponse forDate];
            NSString* forDateString = [DateService yearMonthDateStringFromDate:forDate];
            DailySurveyWellnessAverage* currWellnessAverage = [[DailySurveyWellnessAverage alloc] initWithDailySurveyQuestionResponses:[currDailySurveyResponse dailySurveyQuestionResponses]];
            [dictionary setObject:currWellnessAverage forKey:forDateString];
            if(candidateFirstDate==nil || candidateLastDate==nil){
                candidateFirstDate = forDate;
                candidateLastDate = forDate;
            }
            else{
                if([forDate compare:candidateFirstDate]==NSOrderedAscending){
                    candidateFirstDate = forDate;
                }
                if([forDate compare:candidateLastDate]==NSOrderedDescending){
                    candidateLastDate = forDate;
                }
            }
        }
        self.firstDate = candidateFirstDate;
        self.lastDate = candidateLastDate;
    }
    return self;
}

-(CGFloat)valueForDate:(NSDate*)date forWellnessArea:(WELLNESS_AREA)area{
    NSString* dateString = [DateService yearMonthDateStringFromDate:date];
    DailySurveyWellnessAverage* dailySurveyWellnessAverage = [dictionary objectForKey:dateString];
    if(dailySurveyWellnessAverage == nil){
        return [self getMissingValueForDate:date forWellnessArea:area];
    }
    switch(area){
        case EMOTIONAL:
            return [[dailySurveyWellnessAverage emotionalAverage] floatValue];
        case ACADEMIC:
            return [[dailySurveyWellnessAverage academicAverage] floatValue];
        case PHYSICAL:
            return [[dailySurveyWellnessAverage physicalAverage] floatValue];
        case SOCIAL:
        default:
            return [[dailySurveyWellnessAverage socialAverage] floatValue];
    }
}

-(CGFloat)getMissingValueForDate:(NSDate*)date forWellnessArea:(WELLNESS_AREA)area{
    if(self.firstDate == nil || self.lastDate == nil){
        return 0;
    }
    if([date compare:self.firstDate]==NSOrderedAscending || [date compare:self.lastDate]==NSOrderedDescending){
        return 0;
    }
    NSString* firstDateString = [DateService yearMonthDateStringFromDate:self.firstDate];
    NSString* lastDateString = [DateService yearMonthDateStringFromDate:self.lastDate];
    
    int leftDistance = 0;
    NSDate* leftDate;
    NSString* leftDateString;
    do{
        leftDistance--;
        leftDate = [DateService date:date offsetByInteger:leftDistance];
        leftDateString = [DateService yearMonthDateStringFromDate:leftDate];
    }
    while(![self dataExistsForDate:leftDate] && ![leftDateString isEqualToString:firstDateString]);
    int rightDistance = 0;
    NSDate* rightDate;
    NSString* rightDateString;
    do{
        rightDistance++;
        rightDate = [DateService date:date offsetByInteger:rightDistance];
        leftDateString = [DateService yearMonthDateStringFromDate:rightDate];
    }
    while(![self dataExistsForDate:rightDate] && ![rightDateString isEqualToString:lastDateString]);
    
    int gaps = (-1*leftDistance)+rightDistance;
    CGFloat leftValue = [self valueForDate:leftDate forWellnessArea:area];
    CGFloat rightValue = [self valueForDate:rightDate forWellnessArea:area];
    CGFloat slope = (rightValue-leftValue)/gaps;
    return slope*(-1*leftDistance)+leftValue;
}

-(BOOL)dataExistsForDate:(NSDate*)date{
    NSString* dateString = [DateService yearMonthDateStringFromDate:date];
    DailySurveyWellnessAverage* dailySurveyWellnessAverage = [dictionary objectForKey:dateString];
    return dailySurveyWellnessAverage != nil;
}


@end