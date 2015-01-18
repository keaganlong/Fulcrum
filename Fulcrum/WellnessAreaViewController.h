//
//  EmotionalViewController.h
//  Fulcrum
//
//  Created by Keagan Long on 1/3/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import "JBLineChartView.h"
#import "DailySurveyDataMap.h"

@interface WellnessAreaViewController : UIViewController<JBLineChartViewDelegate, JBLineChartViewDataSource>

@property JBLineChartView* lineChartView;
@property NSMutableArray* currentDateRange;
@property DailySurveyDataMap* dailySurveyDataMap;
@property NSUInteger numberOfDataElements;

@end
