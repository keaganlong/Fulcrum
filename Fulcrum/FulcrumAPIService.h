//
//  FulcrumAPIService.h
//  Fulcrum
//
//  Created by Keagan Long on 12/30/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

@interface FulcrumAPIService : NSObject

+(void)getDailySurveyResponsesForUser:(int) userId withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction;
+(void)postForUser:(int) userId dailySurveyResponseDate:(NSData*)data withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction;
+(void)loginWithUsername:(NSString*)username andWithPassword:(NSString*)password withCallback:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction;


@end