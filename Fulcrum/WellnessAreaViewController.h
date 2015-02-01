//
//  EmotionalViewController.h
//  Fulcrum
//
//  Created by Keagan Long on 1/3/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import "JBLineChartView.h"
#import "DailySurveyDataMap.h"
#import "YAxisView.h"

@interface WellnessAreaViewController : UIViewController<JBLineChartViewDelegate, JBLineChartViewDataSource>

@property JBLineChartView* lineChartView;
@property NSMutableArray* currentDateRange;
@property DailySurveyDataMap* dailySurveyDataMap;
@property NSUInteger numberOfDataElements;
@property NSInteger numberOfVerticalValues;
@property CGFloat dotRadius;
@property CGFloat lineWidth;
@property NSDate* earliestDate;
@property NSDate* latestDate;
@property YAxisView* yAxisView;

@property UILabel* selectedDateLabel;

@property WELLNESS_AREA wellnessArea;

-(id)initWithWellnessArea:(WELLNESS_AREA)area;
-(void)setGraphBackgroundColor:(UIColor*)color;

@end
