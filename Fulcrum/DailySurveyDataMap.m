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
#import "DateRangeService.h"

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
        for(int i = 0;i<[dailySurveyResponses count];i++){
            DailySurveyResponse* currDailySurveyResponse = [dailySurveyResponses objectAtIndex:i];
            NSDate* forDate = [currDailySurveyResponse forDate];
            NSString* forDateString = [DateRangeService yearMonthDateStringFromDate:forDate];
            DailySurveyWellnessAverage* currWellnessAverage = [[DailySurveyWellnessAverage alloc] initWithDailySurveyQuestionResponses:[currDailySurveyResponse dailySurveyQuestionResponses]];
            [dictionary setObject:currWellnessAverage forKey:forDateString];
        }
        DailySurveyResponse* dailySurveyResponse = [dailySurveyResponses objectAtIndex:0];
        self.firstDate = [dailySurveyResponse forDate];
        dailySurveyResponse = [dailySurveyResponses objectAtIndex:[dailySurveyResponses count]-1];
        self.lastDate = [dailySurveyResponse forDate];
    }
    return self;
}

-(CGFloat)valueForDate:(NSDate*)date{
    NSString* dateString = [DateRangeService yearMonthDateStringFromDate:date];
    DailySurveyWellnessAverage* dailySurveyWellnessAverage = [dictionary objectForKey:dateString];
    if(dailySurveyWellnessAverage == nil){
        return [self getMissingValueForDate:date];
    }
    return [[dailySurveyWellnessAverage emotionalAverage] floatValue];
}

-(CGFloat)getMissingValueForDate:(NSDate*)date{
    NSString* firstDateString = [DateRangeService yearMonthDateStringFromDate:self.firstDate];
    NSString* lastDateString = [DateRangeService yearMonthDateStringFromDate:self.lastDate];
    
    int leftDistance = 0;
    NSDate* leftDate;
    NSString* leftDateString;
    do{
        leftDistance--;
        leftDate = [DateRangeService date:date offsetByInteger:leftDistance];
        leftDateString = [DateRangeService yearMonthDateStringFromDate:leftDate];
    }
    while(![self dataExistsForDate:leftDate] && ![leftDateString isEqualToString:firstDateString]);
    int rightDistance = 0;
    NSDate* rightDate;
    NSString* rightDateString;
    do{
        rightDistance++;
        rightDate = [DateRangeService date:date offsetByInteger:rightDistance];
        leftDateString = [DateRangeService yearMonthDateStringFromDate:rightDate];
    }
    while(![self dataExistsForDate:rightDate] && ![rightDateString isEqualToString:lastDateString]);
    
    int gaps = (-1*leftDistance)+rightDistance;
    CGFloat leftValue = [self valueForDate:leftDate];
    CGFloat rightValue = [self valueForDate:rightDate];
    CGFloat slope = (rightValue-leftValue)/gaps;
    return slope*(-1*leftDistance)+leftValue;
}

-(BOOL)dataExistsForDate:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [formatter stringFromDate:date];
    DailySurveyWellnessAverage* dailySurveyWellnessAverage = [dictionary objectForKey:dateString];
    return dailySurveyWellnessAverage != nil;
}


@end