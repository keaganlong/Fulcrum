//
//  DateRangeService.m
//  Fulcrum
//
//  Created by Keagan Long on 1/13/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateService.h"

@implementation DateService

+(NSMutableArray*)getSevenDaysPriorStartingWithDate:(NSDate*)date{
    return [DateService getDateRangeStartingWithDate:date withInteger:7];
}

+(NSMutableArray*)getThirtyDaysPriorStartingWithDate:(NSDate*)date{
    return [DateService getDateRangeStartingWithDate:date withInteger:30];
}

+(NSMutableArray*)getNinetyDaysPriorStartingWithDate:(NSDate*)date{
    return [DateService getDateRangeStartingWithDate:date withInteger:90];
}

+(NSMutableArray*)getOneYearDaysPriorStartingWithDate:(NSDate*)date{
    return [DateService getDateRangeStartingWithDate:date withInteger:365];
}

+(NSString*)weekdayAbbreviationStringForDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"EEE"];
    NSString* weekdayAbbreviation = [formatter stringFromDate:date];
    return weekdayAbbreviation;
}

+(NSString*)monthDayStringForDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM/dd"];
    NSString* dayMonth = [formatter stringFromDate:date];
    return dayMonth;
}

+(NSString*)yearStringForDate:(NSDate*)date{
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy"];
    NSString* dayMonth = [formatter stringFromDate:date];
    return dayMonth;
}

+(NSMutableArray*)getDateRangeStartingWithDate:(NSDate*)date withInteger:(NSInteger)integer{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSMutableArray* arr = [NSMutableArray new];
    
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    
    for(int i = integer-2; i>=-1;i--){
        comps.day = (i+1)*-1;
        NSDate* currDate = [calendar dateByAddingComponents:comps toDate:date options:nil];
        [arr addObject:currDate];
    }
    return arr;
}

+(NSMutableArray*)getDateRangeStartingWithDate:(NSDate*)date daysPrior:(NSInteger)daysPrior daysFuture:(NSInteger)daysFuture{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSMutableArray* arr = [NSMutableArray new];
    
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    
    for(int i = daysPrior-2; i>=-1;i--){
        comps.day = (i+1)*-1;
        NSDate* currDate = [calendar dateByAddingComponents:comps toDate:date options:nil];
        [arr addObject:currDate];
    }
    for(int i = 1;i<=daysFuture;i++){
        comps.day = i;
        NSDate* currDate = [calendar dateByAddingComponents:comps toDate:date options:nil];
        [arr addObject:currDate];
    }
    return arr;
}


+(NSDate*)date:(NSDate*)date offsetByInteger:(NSInteger)integer{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSDateComponents* comps = [[NSDateComponents alloc]init];
    comps.day = integer;
    NSDate* newDate = [calendar dateByAddingComponents:comps toDate:date options:nil];
    return newDate;
}

+(NSDate*)dateFromYearMonthDateString:(NSString*)dateString{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    NSDate* date = [formatter dateFromString:dateString];
    return date;
}

+(NSString*)yearMonthDateStringFromDate:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+(NSComparisonResult)date1:(NSDate*)date1 compareToDate2:(NSDate*)date2{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    NSString* date1String = [formatter stringFromDate:date1];
    NSString* date2String = [formatter stringFromDate:date2];
    NSDate* date1Clean = [formatter dateFromString:date1String];
    NSDate* date2Clean = [formatter dateFromString:date2String];
    return [date1Clean compare:date2Clean];
}


+(NSString*)readableStringFromDate:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"EEEE MMMM d, YYYY"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

+(NSString*)dateJSONTransformer:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
    return [dateFormatter stringFromDate:date];
}

@end