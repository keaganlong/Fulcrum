//
//  DailySurveyDataMap.h
//  Fulcrum
//
//  Created by Keagan Long on 1/13/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

@interface DailySurveyDataMap: NSObject

@property NSDate* firstDate;
@property NSDate* lastDate;

-(id)initWithDailySurveyResponses:(NSMutableArray*)dailySurveyResponses;
-(CGFloat)valueForDate:(NSDate*)date;
-(BOOL)dataExistsForDate:(NSDate*)date;

@end

