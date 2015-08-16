//
//  DailySurveyQuestionResponse.h
//  Fulcrum
//
//  Created by Keagan Long on 12/30/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import "DailySurveyQuestion.h"

@interface DailySurveyQuestionResponse : NSObject

@property DailySurveyQuestion* question;
@property NSString* response;
@property NSNumber* value;

@end
