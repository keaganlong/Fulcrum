//
//  FulcrumAPIFacade.h
//  Fulcrum
//
//  Created by Keagan Long on 12/30/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//
#import "DailySurveyResponse.h"

@interface FulcrumAPIFacade : NSObject

+(void)getDailySurveyResponsesForUser:(int) userId withCallback:(void(^)(NSArray *dailySurveyResponses))callbackFunction;
+(void)submitForUser:(int)userId dailySurveyResponse:(DailySurveyResponse*)response withCallback:(void(^)(NSError*))callbackFunction;

@end
