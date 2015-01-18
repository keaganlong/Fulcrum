
//
//  DailySurveyWellnessAverage.h
//  Fulcrum
//
//  Created by Keagan Long on 1/13/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

@interface DailySurveyWellnessAverage: NSObject

@property NSNumber* emotionalAverage;
@property NSNumber* physicalAverage;
@property NSNumber* socialAverage;
@property NSNumber* academicAverage;

-(id)initWithDailySurveyQuestionResponses:(NSMutableArray*)dailySurveyQuetionResponses;

@end

