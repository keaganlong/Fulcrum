//
//  FulcrumAPIService.h
//  Fulcrum
//
//  Created by Keagan Long on 12/30/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

@interface FulcrumAPIService : NSObject

+(void)getDailySurveyResponsesWithCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction;
+(void)postDailySurveyResponseDate:(NSData*)data withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction;
+(void)loginWithUsername:(NSString*)username andWithPassword:(NSString*)password withCallback:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction;
+(void)registerAccountWithUsername:(NSString*)username andPassword:(NSString*)password withCallback:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction;
+(void)lastDailySurveyResponse:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction;

+(void)postCalenderEvents:(NSData*)data withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction;

+(void)getCalenderEventsWithStartDate:(NSDate*)startDate AndEndDate:(NSDate*)endDate withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction;
                                                                                                            
@end