//
//  DateRangeService.h
//  Fulcrum
//
//  Created by Keagan Long on 1/13/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

@interface DateRangeService: NSObject

+(NSMutableArray*)getSevenDaysPriorStartingWithDate:(NSDate*)date;
+(NSDate*)date:(NSDate*)date offsetByInteger:(NSInteger)integer;
+(NSString*)yearMonthDateStringFromDate:(NSDate*)date;

@end
