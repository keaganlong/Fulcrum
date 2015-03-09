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
#import <UPPlatformSDK/UPPlatformSDK.h>
#import "AggregationAlgorithm.h"

@implementation DailySurveyDataMap{
    NSMutableDictionary* dailySurveyScoreDictionary;
    NSMutableDictionary* sleepScoreDictionary;
}

-(id)init{
    self = [super init];
    if(self){
        dailySurveyScoreDictionary = [NSMutableDictionary new];
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
            [dailySurveyScoreDictionary setObject:currWellnessAverage forKey:forDateString];
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

-(void)setSleeps:(NSArray*)sleeps{
    for(int i = 0; i<[sleeps count];i++){
        UPSleep* currSleep = [sleeps objectAtIndex:i];
        NSDate* forDate = currSleep.date;
        NSString* forDateString = [DateService yearMonthDateStringFromDate:forDate];
        sleepScoreDictionary[forDateString] = currSleep.quality;
    }
    
}

-(CGFloat)valueForDate:(NSDate*)date forWellnessArea:(WELLNESS_AREA)area{
    NSString* dateString = [DateService yearMonthDateStringFromDate:date];
    DailySurveyWellnessAverage* dailySurveyWellnessAverage = [dailySurveyScoreDictionary objectForKey:dateString];
    NSNumber* baseValue;
    if(dailySurveyWellnessAverage == nil){
        baseValue = [NSNumber numberWithFloat:[self getMissingValueForDate:date forWellnessArea:area]];
    }
    else{
        switch(area){
            case EMOTIONAL:
                baseValue = [dailySurveyWellnessAverage emotionalAverage];
                break;
            case ACADEMIC:
                baseValue = [dailySurveyWellnessAverage academicAverage];
                break;
            case PHYSICAL:
                baseValue = [dailySurveyWellnessAverage physicalAverage];
                break;
            case SOCIAL:
                baseValue = [dailySurveyWellnessAverage socialAverage];
                break;
            default:
                baseValue = [dailySurveyWellnessAverage socialAverage];
                break;
        }
    }
    if(area == PHYSICAL){
        NSNumber* sleepScore = sleepScoreDictionary[dateString];
        NSNumber* physicalValue = [AggregationAlgorithm phyiscalScoreWithDailySurveyScore:baseValue sleepQuality:sleepScore];
        if(physicalValue==nil){
            //TODO: get missing value!
            return [baseValue floatValue];
        }
        return [physicalValue floatValue];
    }
    return [baseValue floatValue];
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
    static int count = 0;
    return slope*(-1*leftDistance)+leftValue;
}

-(BOOL)dataExistsForDate:(NSDate*)date{
    NSString* dateString = [DateService yearMonthDateStringFromDate:date];
    DailySurveyWellnessAverage* dailySurveyWellnessAverage = [dailySurveyScoreDictionary objectForKey:dateString];
    return dailySurveyWellnessAverage != nil;
}


@end