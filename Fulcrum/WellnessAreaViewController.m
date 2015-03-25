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
#import "DateService.h"
#import "GraphFooterFactory.h"
#import "YAxisView.h"
#import "UPApiService.h"

@implementation WellnessAreaViewController

-(id)initWithWellnessArea:(WELLNESS_AREA)area{
    self = [super init];
    if(self){
        self.wellnessArea = area;
        [self initView];
        [self hideGraph];
        [self startLoading];
        [self initData];
    }
    return self;
}

-(void)hideGraph{
    self.lineChartView.hidden = YES;
    self.yAxisView.hidden = YES;
}

-(void)showGraph{
    self.lineChartView.hidden = NO;
    self.yAxisView.hidden = NO;
}

-(void)startLoading{
    self.loadingView.hidden = NO;
    self.spinner.hidden = NO;
}

-(void)endLoading{
    self.loadingView.hidden = YES;
    self.spinner.hidden = YES;
    //[self.loadingView removeFromSuperview];
    //[self.spinner removeFromSuperview];
}

-(void) viewWillAppear:(BOOL)animated{
}

-(void)initView{
    CGRect fullFrame = [[UIScreen mainScreen] bounds];
    UIView* loadingView = [[UIView alloc] initWithFrame:fullFrame];
    loadingView.backgroundColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.5];
    [self.view addSubview:loadingView];
    self.loadingView = loadingView;
    self.loadingView.hidden = YES;
    
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    spinner.center = CGPointMake(self.view.center.x, self.view.center.y);
    [self.view addSubview:spinner];
    [spinner startAnimating];
    self.spinner = spinner;
    self.spinner.hidden = YES;
    
    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,70,appFrame.size.width-20,30)];
    [titleLabel setText:@"Social"];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [titleLabel setFont:[UIFont fontWithName: @"Trebuchet MS" size: 26.0f]];
    [self.view addSubview:titleLabel];
    
    UIButton* allButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [allButton setTitle:@"All" forState:UIControlStateNormal];
    [allButton addTarget:self action:@selector(onTouchUpInsideAllButton:) forControlEvents:UIControlEventTouchUpInside];
    allButton.frame = CGRectMake(0,100,60,60);
    
    UIButton* threeMonthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [threeMonthButton setTitle:@"3Mo" forState:UIControlStateNormal];
    [threeMonthButton addTarget:self action:@selector(onTouchUpInsideThreeMonthButton:) forControlEvents:UIControlEventTouchUpInside];
    threeMonthButton.frame = CGRectMake(45,100,60,60);
    
    UIButton* monthButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    monthButton.frame = CGRectMake(95,100,60,60);
    [monthButton setTitle:@"1Mo" forState:UIControlStateNormal];
    [monthButton addTarget:self action:@selector(onTouchUpInsideMonthButton:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* weekButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [weekButton setTitle:@"Week" forState:UIControlStateNormal];
    [weekButton addTarget:self action:@selector(onTouchUpInsideWeekButton:) forControlEvents:UIControlEventTouchUpInside];
    weekButton.frame = CGRectMake(150,100,60,60);
    
    [self.view addSubview:allButton];
    [self.view addSubview:threeMonthButton];
    [self.view addSubview:monthButton];
    [self.view addSubview:weekButton];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    
    self.selectedDateLabel = [[UILabel alloc] initWithFrame:CGRectMake(-100+screenFrame.size.width/2.0,160,240,25)];
    [self.selectedDateLabel setFont:[UIFont fontWithName:@"Helvetica" size:16.0]];
    [self.view addSubview:self.selectedDateLabel];
    
    YAxisView* yAxisView = [[YAxisView alloc] initWithFrame:CGRectMake(10,150,25,screenFrame.size.height-150) AndHeaderPadding:50 StartValue:0 EndValue:5];
    
    [self setYAxisView:yAxisView];
    [self.view addSubview:yAxisView];
    [self initChart];
}

-(void)initChart{
    JBLineChartView* lineChartView = [[JBLineChartView alloc] init];
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    lineChartView.frame = CGRectMake(35,150,screenFrame.size.width-40,screenFrame.size.height-150);
    
    [lineChartView setMinimumValue:0];
    [lineChartView setMaximumValue:5];
    [lineChartView setHeaderPadding:50];
    [lineChartView setFooterPadding:0];
    [lineChartView setDataSource:self];
    [lineChartView setDelegate:self];
    [self setLineChartView:lineChartView];
    [self.view addSubview:self.lineChartView];
    [lineChartView setHeaderView:nil];
}

-(void)setGraphBackgroundColor:(UIColor*)color{
    [self.lineChartView setBackgroundColor:color];
    [self.yAxisView setBackgroundColor:color];
}

- (IBAction)onTouchUpInsideAllButton:(id)sender{
    if(self.dailySurveyDataMap != nil){
        [self setRangeToAll];
        [self.lineChartView reloadData];
    }
}

- (IBAction)onTouchUpInsideThreeMonthButton:(id)sender{
    if(self.dailySurveyDataMap != nil){
        [self setRangeToThreeMonth];
        [self.lineChartView reloadData];
    }
}

- (IBAction)onTouchUpInsideMonthButton:(id)sender{
    if(self.dailySurveyDataMap != nil){
        [self setRangeToMonth];
        [self.lineChartView reloadData];
    }
}

- (IBAction)onTouchUpInsideWeekButton:(id)sender{
    if(self.dailySurveyDataMap != nil){
        [self setRangeToWeek];
        [self.lineChartView reloadData];
    }
}

-(void)setRangeToInteger:(NSInteger)integer{
    self.currentDateRange = [self getDateRangeGoingBackBy:integer];
    self.numberOfVerticalValues = [self.currentDateRange count];
    CGRect screenFrame = [[UIScreen mainScreen] applicationFrame];
    CGRect footerFrame = CGRectMake(0,0,screenFrame.size.width-20,50);
    NSDate* firstDate = [self.currentDateRange firstObject];
    NSDate* lastDate = [self.currentDateRange lastObject];
    NSString* firstDateString = [DateService monthDayStringForDate:firstDate];
    NSString* lastDateString = [DateService monthDayStringForDate:lastDate];
    JBLineChartFooterView *footerView = [GraphFooterFactory footerViewWithFrame:footerFrame numberOfTicks:self.numberOfVerticalValues firstLabel:firstDateString lastLabel:lastDateString];
    [self.lineChartView setFooterView:footerView];
}

-(NSMutableArray*)getDateRangeGoingBackBy:(NSInteger)integer{
    //NSLog(@"EARLIEST DATE %@",self.earliestDate);
    NSMutableArray* totalRange = [DateService getDateRangeStartingWithDate:[NSDate date] withInteger:integer];
    NSMutableArray* output = [NSMutableArray new];
    //NSLog(@"%@ %@",self.earliestDate,self.latestDate);
    for(int i = 0; i<[totalRange count];i++) {
        NSDate* currentDate = [totalRange objectAtIndex:i];
        //NSLog(@"%@",currentDate);
        if(![self date:currentDate preceedsDate:self.earliestDate] && ![self date:currentDate exceedsDate:self.latestDate]){
            [output addObject:currentDate];
        }
    }
    return output;
}

-(BOOL)date:(NSDate*)date1 preceedsDate:(NSDate*)date2{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSString* date1String = [formatter stringFromDate:date1];
    NSString* date2String = [formatter stringFromDate:date2];
    //NSLog(@"NO  d1 %@ d2 %@ d1s %@ d2s %@",date1,date2,date1String,date2String);
    if([date1String isEqualToString:date2String]){
        return NO;
    }
    NSDate* date1Clean = [formatter dateFromString:date1String];
    NSDate* date2Clean = [formatter dateFromString:date2String];
    return [date1Clean compare:date2Clean]==NSOrderedAscending;
}

-(BOOL)date:(NSDate*)date1 exceedsDate:(NSDate*)date2{
    NSDateFormatter* formatter = [[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"GMT"]];
    NSString* date1String = [formatter stringFromDate:date1];
    NSString* date2String = [formatter stringFromDate:date2];
    //NSLog(@"NO  d1 %@ d2 %@ d1s %@ d2s %@",date1,date2,date1String,date2String);
    if([date1String isEqualToString:date2String]){
        return NO;
    }
    NSDate* date1Clean = [formatter dateFromString:date1String];
    NSDate* date2Clean = [formatter dateFromString:date2String];
    return [date1Clean compare:date2Clean]==NSOrderedDescending;
}

-(void)setRangeToWeek{
    self.lineWidth = 2;
    self.dotRadius = 5.0;
    [self setRangeToInteger:7];
}

-(void)setRangeToMonth{
    self.lineWidth = 1.6;
    self.dotRadius = 4.0;
    [self setRangeToInteger:30];
}

-(void)setRangeToThreeMonth{
    self.lineWidth = 1.3;
    self.dotRadius = 2.8;
    [self setRangeToInteger:90];
}

-(void)setRangeToAll{
    self.lineWidth = 1.2;
    self.dotRadius = 2.8;
    [self setRangeToInteger:365];
}

-(void)initData{
    [FulcrumAPIFacade getDailySurveyResponsesWithCallback:^(NSMutableArray *dailySurveyResponses) {
        if(dailySurveyResponses!=nil){
            DailySurveyDataMap* dataMap = [[DailySurveyDataMap alloc] initWithDailySurveyResponses:dailySurveyResponses];
            if(self.wellnessArea == PHYSICAL){
                [UPApiService getSleepsWithCompletionHandler:^(NSArray* sleeps) {
                    [dataMap setSleeps:sleeps];
                    [self setDailySurveyDataMap:dataMap];
                    [self setEarliestDate:[dataMap firstDate]];
                    [self setLatestDate:[dataMap lastDate]];
                }];
            }
            else{
                [self setDailySurveyDataMap:dataMap];
                [self setEarliestDate:[dataMap firstDate]];
                [self setLatestDate:[dataMap lastDate]];
            }
            dispatch_async(dispatch_get_main_queue(),
                ^{
                    [self setRangeToWeek];
                    [self.lineChartView reloadData];
                    [self endLoading];
                    [self showGraph];
                });
        }
        else{
            // Alert user
        }
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
    //NSLog(@"veritcal values: %lu",self.numberOfVerticalValues);
    return self.numberOfVerticalValues;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView verticalValueForHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex
{
    if(self.dailySurveyDataMap == nil){
        //NSLog(@"Map is nuLL");
        return 0;
    }
    NSDate* dateAtIndex = [self.currentDateRange objectAtIndex:horizontalIndex];
    CGFloat value = [self.dailySurveyDataMap valueForDate:dateAtIndex forWellnessArea:self.wellnessArea];
    //NSLog(@"%lu %@ %f",horizontalIndex,dateAtIndex,value);
    return value;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView widthForLineAtLineIndex:(NSUInteger)lineIndex
{
    return self.lineWidth;
}

- (JBLineChartViewLineStyle)lineChartView:(JBLineChartView *)lineChartView lineStyleForLineAtLineIndex:(NSUInteger)lineIndex
{
    return JBLineChartViewLineStyleSolid;
}

//- (UIColor *)lineChartView:(JBLineChartView *)lineChartView fillColorForLineAtLineIndex:(NSUInteger)lineIndex
//{
//    return [UIColor grayColor];
//}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView verticalSelectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor];
}

- (CGFloat)verticalSelectionWidthForLineChartView:(JBLineChartView *)lineChartView
{
    return 3.0;
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForLineAtLineIndex:(NSUInteger)lineIndex
{
    return [UIColor whiteColor];
}

//- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionFillColorForLineAtLineIndex:(NSUInteger)lineIndex
//{
//    return [UIColor grayColor];
//}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView showsDotsForLineAtLineIndex:(NSUInteger)lineIndex{
    return YES;
}

- (CGFloat)lineChartView:(JBLineChartView *)lineChartView dotRadiusForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{
    if(self.dailySurveyDataMap != nil){
        NSDate* dateAtIndex = [self.currentDateRange objectAtIndex:horizontalIndex];
        if([self.dailySurveyDataMap dataExistsForDate:dateAtIndex]){
            return self.dotRadius;
        }
        else{
            return 0;
        }
    }
    return self.dotRadius;
}

-(UIColor *)lineChartView:(JBLineChartView *)lineChartView colorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{
    return [UIColor blackColor];
}

- (UIColor *)lineChartView:(JBLineChartView *)lineChartView selectionColorForDotAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{
    return [UIColor whiteColor];
}

//- (UIView *)lineChartView:(JBLineChartView *)lineChartView dotViewAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{
//    
//}

- (void)lineChartView:(JBLineChartView *)lineChartView didSelectLineAtIndex:(NSUInteger)lineIndex horizontalIndex:(NSUInteger)horizontalIndex touchPoint:(CGPoint)touchPoint
{
    NSDate* selectedDate = [self.currentDateRange objectAtIndex:horizontalIndex];
    NSString* selectedDateString = [DateService readableStringFromDate:selectedDate];
    [self.selectedDateLabel setText:selectedDateString];
}

- (void)didDeselectLineInLineChartView:(JBLineChartView *)lineChartView
{
    [self.selectedDateLabel setText:@""];
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView shouldHideDotViewOnSelectionAtHorizontalIndex:(NSUInteger)horizontalIndex atLineIndex:(NSUInteger)lineIndex{
    return YES;
}

- (BOOL)lineChartView:(JBLineChartView *)lineChartView smoothLineAtLineIndex:(NSUInteger)lineIndex{
    return YES;
}



@end