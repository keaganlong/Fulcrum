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

@implementation MainViewController

CGFloat const CAROUSEL_X = 0;
CGFloat const CAROUSEL_Y = 35;
CGFloat const CAROUSEL_HEIGHT = 200;

-(id)init{
    self = [super init];
    if(self){
        [self initView];
        [[self dailySurveyButton] addTarget:self action:@selector(onDailySurveyButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)initView
{
    self.frame = [[UIScreen mainScreen] applicationFrame];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UpperCarouselDataSourceAndDelegate* upperCarouselDSandD = [[UpperCarouselDataSourceAndDelegate alloc] initWithController:self];
    self.upperCarouselDataSourceAndDelegate = upperCarouselDSandD;
    
    self.upperCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(CAROUSEL_X,CAROUSEL_Y,self.frame.size.width,CAROUSEL_HEIGHT)];
    self.upperCarousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.upperCarousel.type = iCarouselTypeLinear;
    self.upperCarousel.delegate = self.upperCarouselDataSourceAndDelegate;
    self.upperCarousel.dataSource = self.upperCarouselDataSourceAndDelegate;
    
    [self.view addSubview:self.upperCarousel];
    
    [self initDailySurveyButton];
    
    [self initCalender];

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

                       
                       self.lowerCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0,220,self.frame.size.width,400)];
                       self.lowerCarousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
                       self.lowerCarousel.type = iCarouselTypeLinear;
                       
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
    [self.lowerCarousel scrollToItemAtIndex:0 animated:YES];
}

-(void)initDailySurveyButton{
    [FulcrumAPIFacade lastDateDailySurveyCompletedForWithCallback:^(NSDate *lastDate) {
        //NSDate* today = [NSDate date];
        NSDate* today = [DateService dateFromYearMonthDateString:@"2016-02-16"];
        //NSLog(@"%@ %@",lastDate, today);
        if([DateService date1:lastDate compareToDate2:today]==NSOrderedAscending){
            dispatch_async(dispatch_get_main_queue(),
                           ^{
                               UIButton* dailySurveyButton = [[UIButton alloc]initWithFrame:CGRectMake(-80+self.frame.size.width/2,230,160,40)];
                               NSMutableString* dailySurveyButtonString = [NSMutableString stringWithString:@"Take Daily Survey"];
                               [dailySurveyButton setTitle:dailySurveyButtonString forState:UIControlStateNormal];
                               [dailySurveyButton setBackgroundColor:[UIColor blueColor]];
                               [dailySurveyButton addTarget:self action:@selector(onDailySurveyButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
                               [self setDailySurveyButton:dailySurveyButton];
                               [self.view addSubview:dailySurveyButton];
                           });
        }
        else{
        }
    }];
}

-(void) viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if(self.dailySurveyButton!=nil){
        self.dailySurveyButton.hidden = YES;
        [self.dailySurveyButton removeFromSuperview];
        self.dailySurveyButton = nil;
    }
    [self initDailySurveyButton];
}

-(void) loadView{
    [super loadView];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(IBAction)onDailySurveyButtonTouchUpInside:(id)sender{
    DailySurveyViewController* dailySurveyViewController = [[DailySurveyViewController alloc]init];
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
    [self.lowerCarouselDataSourceAndDelegate refresh];
    [self.upperCarousel reloadData];
}

@end
