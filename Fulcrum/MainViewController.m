//
//  MainViewController.m
//  Fulcrum
//
//  Created by Keagan Long on 11/9/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import "MainViewController.h"
#import "iCarousel.h"
#import "JBBarChartView.h"
#import "LowerCarouselDataSourceAndDelegate.h"
#import "DailySurveyViewController.h"
#import "DateService.h"
#import "FulcrumAPIFacade.h"
#import <EventKit/EventKit.h>
#import "iCalService.h"
#import "UPApiService.h"
#import <UPPlatformSDK/UPPlatformSDK.h>
#import "WellnessAreaViewController.h"
#import "WellnessAreaViewFactory.h"
#import "FulcrumColors.h"
#import <Parse/Parse.h>
#import <FlatUIKit/FlatUIKit.h>
#import "ScoreView.h"
#import "DailySurveyWellnessAverage.h"

@implementation MainViewController

CGFloat const CAROUSEL_X = 0;
CGFloat const CAROUSEL_Y = 40;
CGFloat const CAROUSEL_HEIGHT = 160;

-(id)init{
    self = [super init];
    if(self){
        self.currDate = [NSDate date];
        self.scoreView = [UIView new];
        [self.view addSubview: self.scoreView];
        //[UPApiService getUserPermissionWithCompletionHandler:^(UPSession * session) {
            [self initView];
            [[self dailySurveyButton] addTarget:self action:@selector(onDailySurveyButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        //}];
    }
    return self;
}

- (void)initView
{
    self.frame = [[UIScreen mainScreen] applicationFrame];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    
//    CGRect appFrame = [[UIScreen mainScreen] applicationFrame];
//    UIView* border = [[UIView alloc] initWithFrame:CGRectMake(0,64, appFrame.size.width, appFrame.size.height-44)];
//    border.layer.borderWidth = 7.0;
//    border.layer.borderColor = [[UIColor grayColor] CGColor];
//    [self.view addSubview:border];

    
    UpperCarouselDataSourceAndDelegate* upperCarouselDSandD = [[UpperCarouselDataSourceAndDelegate alloc] initWithController:self];
    self.upperCarouselDataSourceAndDelegate = upperCarouselDSandD;
    
    self.upperCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(CAROUSEL_X,CAROUSEL_Y,self.frame.size.width,CAROUSEL_HEIGHT)];
    self.upperCarousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.upperCarousel.type = iCarouselTypeLinear;
    self.upperCarousel.delegate = self.upperCarouselDataSourceAndDelegate;
    self.upperCarousel.dataSource = self.upperCarouselDataSourceAndDelegate;
    self.upperCarousel.wrapEnabled = YES;
    //self.upperCarousel.layer.borderColor = [[UIColor redColor] CGColor];
    //self.upperCarousel.layer.borderWidth = 4.0;
    
    [self.view addSubview:self.upperCarousel];
    
    UIButton* overallWellnessButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    overallWellnessButton.frame = CGRectMake(-80+self.frame.size.width/2,210,160,40);
    [overallWellnessButton setTitle:@"Overall Wellness" forState:UIControlStateNormal];
    [overallWellnessButton setBackgroundColor:[FulcrumColors overallBaseColor]];
    [overallWellnessButton setTintColor:[UIColor whiteColor]];
    [overallWellnessButton addTarget:self action:@selector(onOverallWellnessButtonOnTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    //[self.view addSubview:overallWellnessButton];
    [self setOverallWellnessButton:overallWellnessButton];
    
    [self  initSelectedDateLabel];
    [self initCalender];
}

-(void)initSelectedDateLabel{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame.origin.x = 10;
    frame.origin.y = 170;
    frame.size.height = 50;
    frame.size.width = frame.size.width - 10;
    UILabel* dateLabel = [[UILabel alloc] initWithFrame:frame];
    UIFont* font = [UIFont flatFontOfSize:22];
    dateLabel.font = font;
    NSString* dateString = [DateService readableStringFromDate:self.currDate];
    [dateLabel setText:dateString];
    dateLabel.adjustsFontSizeToFitWidth = YES;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    self.selectedDateLabel = dateLabel;
    [self.view addSubview:dateLabel];
}


-(IBAction)onOverallWellnessButtonOnTouchUpInside:(id)sender{
    WellnessAreaViewController* controller = [WellnessAreaViewFactory wellnessAreaViewControllerForWellnessArea:OVERALL];
    [self.navigationController pushViewController:controller animated:YES];
}

-(void)initCalender{
    EKEventStore* store = [iCalService currentStore];
    [store requestAccessToEntityType:EKEntityTypeEvent completion:^(BOOL granted, NSError *error) {
        if(granted){
            [self initLowerCarousel];
        }
    }];
}

-(void)initLowerCarousel{
    dispatch_async(dispatch_get_main_queue(),
                   ^{

                       
                       self.lowerCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0,308,self.frame.size.width,255)];
                       self.lowerCarousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                       self.lowerCarousel.type = iCarouselTypeLinear;
                       //self.lowerCarousel.layer.borderColor = [[UIColor purpleColor] CGColor];
                       //self.lowerCarousel.layer.borderWidth = 4.0;
                       LowerCarouselDataSourceAndDelegate* lowerCarouselDSandD = [[LowerCarouselDataSourceAndDelegate alloc] initWithController:self AndWithCarousel:self.lowerCarousel];
                       self.lowerCarouselDataSourceAndDelegate = lowerCarouselDSandD;
                       
                       self.lowerCarousel.dataSource = self.lowerCarouselDataSourceAndDelegate;
                       self.lowerCarousel.delegate = self.lowerCarouselDataSourceAndDelegate;
                       [self.view addSubview:self.lowerCarousel];
                       
                       self.todayButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
                       self.todayButton.frame = CGRectMake(-25+self.frame.size.width/2,540,50,20);
                       [self.todayButton setTitle:@"Today" forState:UIControlStateNormal];
                       [self.todayButton addTarget:self action:@selector(onTodayButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
                       
                       [self.view addSubview:self.todayButton];
                   });
}

-(IBAction)onTodayButtonTouchUpInside:(id)sender{
    [self.lowerCarousel scrollToItemAtIndex:7 animated:YES];
}

-(void)initDailySurveyButton{
    [FulcrumAPIFacade lastDateDailySurveyCompletedForWithCallback:^(NSDate *lastDate) {
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               if(self.dailySurveyButton==nil){
                                   UIButton* dailySurveyButton = [[UIButton alloc]initWithFrame:CGRectMake(-80+self.frame.size.width/2,225,160,30)];
                                   NSMutableString* dailySurveyButtonString = [NSMutableString stringWithString:@"Daily Survey"];
                                   [dailySurveyButton setTitle:dailySurveyButtonString forState:UIControlStateNormal];
                                   [dailySurveyButton setBackgroundColor:[FulcrumColors dailySurveyButtonColor]];
                                   [dailySurveyButton addTarget:self action:@selector(onDailySurveyButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
                                   self.dailySurveyButton = dailySurveyButton;
                                   [self.view addSubview:dailySurveyButton];
                               }
                           });
    }];
}

-(void)dateChangedTo:(NSDate*)newDate{
    self.currDate = newDate;
    NSString* dateString = [DateService readableStringFromDate:self.currDate];
    [self.selectedDateLabel setText:dateString];
    [self initScoreView];
}

-(void) viewWillAppear:(BOOL)animated{
    [FulcrumAPIFacade getDailySurveyResponsesWithCallback:^(NSMutableArray *dailySurveyResponses) {
        if(dailySurveyResponses!=nil){
            DailySurveyDataMap* dataMap = [[DailySurveyDataMap alloc] initWithDailySurveyResponses:dailySurveyResponses];
            self.dataMap = dataMap;
        }
        [self initDailySurveyButton];
        [self.lowerCarouselDataSourceAndDelegate refresh];
        [self.upperCarousel reloadData];
        [self initScoreView];
        [super viewWillAppear:animated];
    }];
}

-(void)initScoreView{
    [self.scoreView removeFromSuperview];
    DailySurveyResponse* dailySurveyResponse = [self.dataMap dailySurveyResponseForDate:self.currDate];
    if(dailySurveyResponse != nil){
        NSMutableArray* dailySurveyQuestionResponses = dailySurveyResponse.dailySurveyQuestionResponses;
        DailySurveyWellnessAverage* dailySurveyWellnessAverage = [[DailySurveyWellnessAverage alloc] initWithDailySurveyQuestionResponses:dailySurveyQuestionResponses];
        CGRect frame = CGRectMake(40, 270, 240, 100);
        ScoreView* scoreView = [[ScoreView alloc] initWithDailySurveyWellnessAverage:dailySurveyWellnessAverage AndFrame:frame];
        self.scoreView = scoreView;
        [self.view addSubview:scoreView];
    }
    else{
        CGRect frame = CGRectMake(40, 280, 240, 100);
        UILabel* noScoreLabel = [[UILabel alloc] initWithFrame:frame];
        noScoreLabel.text = @"Daily Survey Not Completed";
        noScoreLabel.textAlignment = NSTextAlignmentCenter;
        noScoreLabel.alpha = 0.5;
        self.scoreView = noScoreLabel;
        [self.view addSubview:self.scoreView];
    }
}

-(void) loadView{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(IBAction)onDailySurveyButtonTouchUpInside:(id)sender{
    DailySurveyResponse* dailySurveyResponse = nil;
    BOOL editable = [DateService isTodayOrYesterday:self.currDate];
    if(self.dataMap){
        dailySurveyResponse = [self.dataMap dailySurveyResponseForDate:self.currDate];
    }
    DailySurveyViewController* dailySurveyViewController = [[DailySurveyViewController alloc]initWithDailySurveyResponse:dailySurveyResponse date:self.currDate editable:editable];

    [self.navigationController pushViewController:dailySurveyViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)changeToViewController:(UIViewController*)viewController{
    [self.navigationController pushViewController:viewController animated:YES];
}

-(void)viewDidAppear:(BOOL)animated
{
}

@end
