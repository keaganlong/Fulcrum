//
//  DateRangeService.h
//  Fulcrum
//
//  Created by Keagan Long on 1/13/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

@interface DateService: NSObject

+(NSMutableArray*)getSevenDaysPriorStartingWithDate:(NSDate*)date;
+(NSMutableArray*)getThirtyDaysPriorStartingWithDate:(NSDate*)date;
+(NSMutableArray*)getNinetyDaysPriorStartingWithDate:(NSDate*)date;
+(NSMutableArray*)getOneYearDaysPriorStartingWithDate:(NSDate*)date;
+(NSMutableArray*)getDateRangeStartingWithDate:(NSDate*)date withInteger:(NSInteger)integer;
+(NSMutableArray*)getDateRangeStartingWithDate:(NSDate*)date daysPrior:(NSInteger)daysPrior daysFuture:(NSInteger)daysFuture;

+(NSDate*)date:(NSDate*)date offsetByInteger:(NSInteger)integer;

+(NSString*)weekdayAbbreviationStringForDate:(NSDate*)date;
+(NSString*)monthDayStringForDate:(NSDate*)date;
+(NSString*)yearStringForDate:(NSDate*)date;
+(NSString*)hourMinuteForDate:(NSDate*)date;

+(NSDate*)dateFromYearMonthDateString:(NSString*)dateString;
+(NSString*)yearMonthDateStringFromDate:(NSDate*)date;

+(NSString*)readableStringFromDate:(NSDate*)date;
+(NSString*)dateJSONTransformer:(NSDate*)date;

+(NSComparisonResult)date1:(NSDate*)date1 compareToDate2:(NSDate*)date2;

@end
