//
//  AggregationAlgorithm.h
//  Fulcrum
//
//  Created by Keagan Long on 3/8/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import "DailySurveyWellnessAverage.h"

@interface AggregationAlgorithm : NSObject

+(NSNumber*)phyiscalScoreWithDailySurveyScore:(NSNumber*)dailySurveyPhysicalScore sleepQuality:(NSNumber*)sleepQuality;

@end
