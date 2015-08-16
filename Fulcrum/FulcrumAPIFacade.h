//
//  FulcrumAPIFacade.h
//  Fulcrum
//
//  Created by Keagan Long on 12/30/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//
#import "DailySurveyResponse.h"
#import "CalenderEvent.h"

@interface FulcrumAPIFacade : NSObject

+(void)getDailySurveyResponsesWithCallback:(void(^)(NSMutableArray *dailySurveyResponses))callbackFunction;
+(void)submitDailySurveyResponse:(DailySurveyResponse*)response withCallback:(void(^)(NSError*))callbackFunction;
+(void)updateDailySurveyResponse:(DailySurveyResponse*)response withCallback:(void(^)(NSError*))callbackFunction;

+(void)loginWithUsername:(NSString*)username andWithPassword:(NSString*)password withCallback:(void(^)(NSError* error))callbackFunction;
+(void)registerAccountWithUsername:(NSString*)username andPassword:(NSString*)password withCallback:(void(^)(NSError*))callbackFunction;
+(void)lastDateDailySurveyCompletedForWithCallback:(void(^)(NSDate* lastDate))callbackFunction;

+(void)addCalenderEvents:(NSArray*)calenderEvents withCompletionHandler:(void(^)(NSError*))completionFunction;
+(void)updateCalenderEvent:(CalenderEvent*)calenderEvent withCompletionHandler:(void(^)(NSError*))completionFunction;

+(void)getCalenderEventsWithStartDate:(NSDate*)startDate AndEndDate:(NSDate*)endDate withCompletionHandler:(void(^)(NSArray*))completionFunction;

+(void)getDailySurveyQuestions:(void(^)(NSArray*))callback;

@end
