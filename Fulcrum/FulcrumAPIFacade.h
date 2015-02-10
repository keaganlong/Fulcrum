//
//  FulcrumAPIFacade.h
//  Fulcrum
//
//  Created by Keagan Long on 12/30/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//
#import "DailySurveyResponse.h"

@interface FulcrumAPIFacade : NSObject

+(void)getDailySurveyResponsesWithCallback:(void(^)(NSMutableArray *dailySurveyResponses))callbackFunction;
+(void)submitDailySurveyResponse:(DailySurveyResponse*)response withCallback:(void(^)(NSError*))callbackFunction;
+(void)loginWithUsername:(NSString*)username andWithPassword:(NSString*)password withCallback:(void(^)(NSString* token,NSString* errorMessage))callbackFunction;
+(void)registerAccountWithUsername:(NSString*)username andPassword:(NSString*)password withCallback:(void(^)(NSString*))callbackFunction;
+(void)lastDateDailySurveyCompletedForWithCallback:(void(^)(NSDate* lastDate))callbackFunction;

+(void)addCalenderEvents:(NSArray*)calenderEvents withCompletionHandler:(void(^)(NSError*))completionFunction;

+(void)getCalenderEventsWithStartDate:(NSDate*)startDate AndEndDate:(NSDate*)endDate withCompletionHandler:(void(^)(NSArray*))completionFunction;


@end
