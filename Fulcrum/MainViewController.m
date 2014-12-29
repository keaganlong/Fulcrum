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
#import "MainView.h"
#import "DailySurveyViewController.h"

@implementation MainViewController

-(id)init{
    self = [super init];
    if(self){
        MainView* mainView = [[MainView alloc] initWithFrame:[[UIScreen mainScreen] applicationFrame]];
        [self setView:mainView];
        [self setMainView:mainView];
        
        [[[self mainView] dailySurveyButton] addTarget:self action:@selector(onDailySurveyButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
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



@end
