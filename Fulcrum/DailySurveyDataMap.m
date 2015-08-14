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
    NSMutableDictionary* activeCaloriesDictionary;
}

-(id)init{
    self = [super init];
    if(self){
        dailySurveyScoreDictionary = [NSMutableDictionary new];
        activeCaloriesDictionary = [NSMutableDictionary new];
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
        
        if(self.firstDate == nil || [forDate compare:self.firstDate]==NSOrderedAscending){
            self.firstDate = forDate;
        }
        if(self.lastDate == nil || [forDate compare:self.lastDate]==NSOrderedDescending){
            self.lastDate = forDate;
        }
    }
}

-(void)setMoves:(NSArray*)moves{
    for(int i = 0; i<[moves count];i++){
        UPMove* currMove = [moves objectAtIndex:i];
        NSDate* forDate = currMove.date;
        NSString* forDateString = [DateService yearMonthDateStringFromDate:forDate];
        activeCaloriesDictionary[forDateString] = currMove.activeCalories;
        
        
        if(self.firstDate == nil || [forDate compare:self.firstDate]==NSOrderedAscending){
            self.firstDate = forDate;
        }
        if(self.lastDate == nil || [forDate compare:self.lastDate]==NSOrderedDescending){
            self.lastDate = forDate;
        }
    }
}

-(CGFloat)overallValueForDate:(NSDate*)date{
    //TODO consideration, how to handle missing components? average estimate or only use whats known?
    CGFloat totalSum = 0.0;
    int numComponents = 0;
    if([self dataExistsForDate:date forWellnessArea:EMOTIONAL]){
        CGFloat emotionalValue = [self valueForDate:date forWellnessArea:EMOTIONAL];
        totalSum += emotionalValue;
        numComponents++;
    }
    if([self dataExistsForDate:date forWellnessArea:ACADEMIC]){
        CGFloat academicValue = [self valueForDate:date forWellnessArea:ACADEMIC];
        totalSum += academicValue;
        numComponents++;
    }
    if([self dataExistsForDate:date forWellnessArea:PHYSICAL]){
        CGFloat physicalValue = [self valueForDate:date forWellnessArea:PHYSICAL];
        totalSum += physicalValue;
        numComponents++;
    }
    if([self dataExistsForDate:date forWellnessArea:SOCIAL]){
        CGFloat socialValue = [self valueForDate:date forWellnessArea:SOCIAL];
        totalSum += socialValue;
        numComponents++;
    }
    if(numComponents ==0){
        NSLog(@"all missing");
        return 0.0;
    }
    CGFloat averageValue = totalSum/numComponents;
    return averageValue;
}

-(CGFloat)valueForDate:(NSDate*)date forWellnessArea:(WELLNESS_AREA)area{
    if(area == OVERALL){
        return [self overallValueForDate:date];
    }
    NSString* dateString = [DateService yearMonthDateStringFromDate:date];
    DailySurveyWellnessAverage* dailySurveyWellnessAverage = [dailySurveyScoreDictionary objectForKey:dateString];
    NSNumber* baseValue;
    if(dailySurveyWellnessAverage == nil){
        if(area == PHYSICAL){
            baseValue = nil;
        }
        else{
            baseValue = [NSNumber numberWithFloat:[self getMissingValueForDate:date forWellnessArea:area]];
        }
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
        NSNumber* activeCalories = activeCaloriesDictionary[dateString];
        NSNumber* physicalValue = [AggregationAlgorithm phyiscalScoreWithDailySurveyScore:baseValue sleepQuality:sleepScore activeCalories:activeCalories];
        if(physicalValue==nil){
            CGFloat missingValue = [self getMissingValueForDate:date forWellnessArea:PHYSICAL];
            return missingValue;
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
    while(![self dataExistsForDate:leftDate forWellnessArea:area] && !([DateService date1:leftDate compareToDate2:self.firstDate]==NSOrderedAscending));
    int rightDistance = 0;
    NSDate* rightDate;
    NSString* rightDateString;
    do{
        rightDistance++;
        rightDate = [DateService date:date offsetByInteger:rightDistance];
        rightDateString = [DateService yearMonthDateStringFromDate:rightDate];
    }
    while(![self dataExistsForDate:rightDate forWellnessArea:area] && ![rightDateString isEqualToString:lastDateString]);
    
    int gaps = (-1*leftDistance)+rightDistance;
    if(![self dataExistsForDate:leftDate forWellnessArea:area] && !([DateService date1:rightDate compareToDate2:self.lastDate]==NSOrderedDescending)){
        return 0;
    }
    else if(![self dataExistsForDate:leftDate forWellnessArea:area]){
        return [self valueForDate:rightDate forWellnessArea:area];
    }
    else if(![self dataExistsForDate:rightDate forWellnessArea:area]){
        return [self valueForDate:leftDate forWellnessArea:area];
    }
    CGFloat leftValue = [self valueForDate:leftDate forWellnessArea:area];
    CGFloat rightValue = [self valueForDate:rightDate forWellnessArea:area];
    CGFloat slope = (rightValue-leftValue)/gaps;
    return slope*(-1*leftDistance)+leftValue;
}

-(BOOL)dataExistsForDate:(NSDate*)date forWellnessArea:(WELLNESS_AREA)area{
    NSString* dateString = [DateService yearMonthDateStringFromDate:date];
    DailySurveyWellnessAverage* dailySurveyWellnessAverage = [dailySurveyScoreDictionary objectForKey:dateString];
    if(area == PHYSICAL || area == OVERALL){
        NSNumber* sleepScore = sleepScoreDictionary[dateString];
        NSNumber* activeCalories = activeCaloriesDictionary[dateString];
        BOOL output = sleepScore!=nil || activeCalories !=nil || dailySurveyWellnessAverage !=nil;
        return output;
    }
    return dailySurveyWellnessAverage != nil;
}


@end