//
//  EmotionalViewController.m
//  Fulcrum
//
//  Created by Keagan Long on 1/3/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WellnessAreaViewController.h"
#import "JBLineChartView.h"
#import "JBLineChartFooterView.h"
#import "FulcrumAPIFacade.h"
#import "DailySurveyDataMap.h"
#import "DateRangeService.h"

@implementation WellnessAreaViewController

-(id)init{
    self = [super init];
    if(self){
        self.currentDateRange = [DateRangeService getSevenDaysPriorStartingWithDate:[NSDate date]];
        
        self.view.backgroundColor = [UIColor whiteColor];
        JBLineChartView* lineChartView = [[JBLineChartView alloc] init];
        CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
        lineChartView.frame = CGRectMake(30,200,screenFrame.size.width-60,screenFrame.size.height-300);
        [lineChartView setDataSource:self];
        [lineChartView setDelegate:self];
        [lineChartView setBackgroundColor:[UIColor colorWithRed:0.1 green:0.04 blue:0.9 alpha:0.6]];
        [lineChartView setMinimumValue:1];
        [lineChartView setMaximumValue:5];
        [lineChartView setHeaderPadding:20];
        [lineChartView setFooterPadding:0];
        
        JBLineChartFooterView *footerView = [[JBLineChartFooterView alloc] initWithFrame:CGRectMake(0,0,screenFrame.size.width-60,50)];
        footerView.backgroundColor = [UIColor clearColor];
        footerView.leftLabel.text = @"idk";
        footerView.leftLabel.textColor = [UIColor whiteColor];
        footerView.rightLabel.text = @"www";
        footerView.rightLabel.textColor = [UIColor whiteColor];
        footerView.sectionCount = 7;
        
        [lineChartView setFooterView:footerView];
        [lineChartView setHeaderView:nil];
        
        [self setLineChartView:lineChartView];
        [self initData];
    }
    return self;
}


-(void)initData{
    [FulcrumAPIFacade getDailySurveyResponsesForUser:1 withCallback:^(NSMutableArray *dailySurveyResponses) {
        DailySurveyDataMap* dataMap = [[DailySurveyDataMap alloc] initWithDailySurveyResponses:dailySurveyResponses];
        [self setDailySurveyDataMap:dataMap];
        [self.view addSubview:self.lineChartView];
        [self.lineChartView reloadData];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (NSUInteger)numberOfLinesInLineChartView:(JBLineChartView *)lineChartView
{
    return 1;
}

- (NSUInteger)lineChartView:(JBLineChartView *)lineChartView numberOfVerticalValuesAtLineIndex:(NSUInteger)lineIndex
{
    return 7;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    if(self.dailySurveyDataMap == nil){
        return 0;
    }
    NSDate* dateAtIndex = [self.currentDateRange objectAtIndex:horizontalIndex];
    CGFloat value = [self.dailySurveyDataMap valueForDate:dateAtIndex];
    return value;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return 2;
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewLineStyleSolid;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView fillColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor grayColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView verticalSelectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor];
}

- (CGFloat)verticalSelectionWidthForLineChartView:(JBLineChartView *)lineChartView
{
    return 2.3;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionFillColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor grayColor];
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex{
    return YES;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{
    if(self.dailySurveyDataMap != nil){
        NSDate* dateAtIndex = [self.currentDateRange objectAtIndex:horizontalIndex];
        if([self.dailySurveyDataMap dataExistsForDate:dateAtIndex]){
            return 5;
        }
        else{
            return 0;
        }
    }
    return 5;
}

-(UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{
    return [UIColor blackColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{
    return [UIColor blackColor];
}

//- (UIView *)lineChartView:(JBLineChartView *)lineChartView dotViewAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{
//    
//}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView shouldHideDotViewOnSelectionAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{
    return YES;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex{
    return YES;
}



@end