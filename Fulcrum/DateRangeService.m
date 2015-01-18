//
//  DateRangeService.m
//  Fulcrum
//
//  Created by Keagan Long on 1/13/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateRangeService.h"

@implementation DateRangeService

+(NSMutableArray*)getSevenDaysPriorStartingWithDate:(NSDate*)date{
    NSCalendar* calendar = [NSCalendar currentCalendar];
    NSMutableArray* arr = [NSMutableArray new];
    NSDate* now = [NSDate date];
    [arr addObject:now];
    
    NSDateComponents* comps = [[NSDateComponents alloc]init];

    for(int i = 0; i<6;i++){
        comps.day = (i+1)*-1;
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

+(NSString*)yearMonthDateStringFromDate:(NSDate*)date{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString* dateString = [formatter stringFromDate:date];
    return dateString;
}

@end