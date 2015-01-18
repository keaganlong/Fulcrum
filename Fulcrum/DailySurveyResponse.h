//
//  DailySurveyResponse.h
//  Fulcrum
//
//  Created by Keagan Long on 12/30/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

@interface DailySurveyResponse : NSObject

@property NSDate* forDate;
@property NSDate* submissionDate;
@property NSMutableArray* dailySurveyQuestionResponses;

@end
