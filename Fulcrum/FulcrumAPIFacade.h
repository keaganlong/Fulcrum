//
//  FulcrumAPIFacade.h
//  Fulcrum
//
//  Created by Keagan Long on 12/30/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//
#import "DailySurveyResponse.h"

@interface FulcrumAPIFacade : NSObject

+(void)getDailySurveyResponsesForUser:(int) userId withCallback:(void(^)(NSMutableArray *dailySurveyResponses))callbackFunction;
+(void)submitForUser:(int)userId dailySurveyResponse:(DailySurveyResponse*)response withCallback:(void(^)(NSError*))callbackFunction;
+(void)loginWithUsername:(NSString*)username andWithPassword:(NSString*)password withCallback:(void(^)(NSString*))callbackFunction;

@end
