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


CGFloat const CAROUSEL_X = 0;
CGFloat const CAROUSEL_Y = 0;
CGFloat const CAROUSEL_HEIGHT = 200;

@implementation MainViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UpperCarouselDataSourceAndDelegate* upperCarouselDSandD = [[UpperCarouselDataSourceAndDelegate alloc] init];
    self.upperCarouselDataSourceAndDelegate = upperCarouselDSandD;
    
    self.upperCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(CAROUSEL_X,CAROUSEL_Y,self.view.frame.size.width,CAROUSEL_HEIGHT)];
    self.upperCarousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.upperCarousel.type = iCarouselTypeLinear;
    self.upperCarousel.delegate = self.upperCarouselDataSourceAndDelegate;
    self.upperCarousel.dataSource = self.upperCarouselDataSourceAndDelegate;
    
    [self.view addSubview:self.upperCarousel];

    LowerCarouselDataSourceAndDelegate* lowerCarouselDSandD = [[LowerCarouselDataSourceAndDelegate alloc] init];
    self.lowerCarouselDataSourceAndDelegate = lowerCarouselDSandD;
    
    self.lowerCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0,250,self.view.frame.size.width,400)];
    self.lowerCarousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.lowerCarousel.type = iCarouselTypeLinear;

    self.lowerCarousel.dataSource = self.lowerCarouselDataSourceAndDelegate;
    self.lowerCarousel.delegate = self.lowerCarouselDataSourceAndDelegate;

    [self.view addSubview:self.lowerCarousel];
    
    [self.view bringSubviewToFront:self.backButton];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
