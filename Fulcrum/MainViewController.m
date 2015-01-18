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

@implementation MainViewController

CGFloat const CAROUSEL_X = 0;
CGFloat const CAROUSEL_Y = 0;
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
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    UpperCarouselDataSourceAndDelegate* upperCarouselDSandD = [[UpperCarouselDataSourceAndDelegate alloc] initWithController:self];
    self.upperCarouselDataSourceAndDelegate = upperCarouselDSandD;
    
    self.upperCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(CAROUSEL_X,CAROUSEL_Y,frame.size.width,CAROUSEL_HEIGHT)];
    self.upperCarousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.upperCarousel.type = iCarouselTypeLinear;
    self.upperCarousel.delegate = self.upperCarouselDataSourceAndDelegate;
    self.upperCarousel.dataSource = self.upperCarouselDataSourceAndDelegate;
    
    [self.view addSubview:self.upperCarousel];
    
    UIButton* dailySurveyButton = [[UIButton alloc]initWithFrame:CGRectMake(-80+frame.size.width/2,200,160,40)];
    [dailySurveyButton setTitle:@"Take Daily Survey" forState:UIControlStateNormal];
    [dailySurveyButton setBackgroundColor:[UIColor blueColor]];
    [self.view addSubview:dailySurveyButton];
    [self setDailySurveyButton:dailySurveyButton];
    
    LowerCarouselDataSourceAndDelegate* lowerCarouselDSandD = [[LowerCarouselDataSourceAndDelegate alloc] init];
    self.lowerCarouselDataSourceAndDelegate = lowerCarouselDSandD;
    
    self.lowerCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0,250,frame.size.width,400)];
    self.lowerCarousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.lowerCarousel.type = iCarouselTypeLinear;
    
    self.lowerCarousel.dataSource = self.lowerCarouselDataSourceAndDelegate;
    self.lowerCarousel.delegate = self.lowerCarouselDataSourceAndDelegate;
    
    
    [self.view addSubview:self.lowerCarousel];
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

@end
