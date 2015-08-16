//
//  DailySurveyDataMap.h
//  Fulcrum
//
//  Created by Keagan Long on 1/13/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import "DailySurveyResponse.h"

typedef enum { EMOTIONAL, ACADEMIC, PHYSICAL, SOCIAL, OVERALL} WELLNESS_AREA;

@interface DailySurveyDataMap: NSObject

@property NSDate* firstDate;
@property NSDate* lastDate;

-(id)initWithDailySurveyResponses:(NSMutableArray*)dailySurveyResponses;
-(CGFloat)valueForDate:(NSDate*)date forWellnessArea:(WELLNESS_AREA)area;
-(BOOL)dataExistsForDate:(NSDate*)date forWellnessArea:(WELLNESS_AREA)area;
-(void)setSleeps:(NSArray*)sleeps;
-(void)setMoves:(NSArray*)events;

-(DailySurveyResponse*)dailySurveyResponseForDate:(NSDate*)date;

@end

