//
//  MainView.m
//  Fulcrum
//
//  Created by Keagan Long on 12/28/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MainView.h"
#import "MainViewController.h"
#import "iCarousel.h"
#import "JBBarChartView.h"
#import "LowerCarouselDataSourceAndDelegate.h"

@implementation MainView

CGFloat const CAROUSEL_X = 0;
CGFloat const CAROUSEL_Y = 0;
CGFloat const CAROUSEL_HEIGHT = 200;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self setBackgroundColor:[UIColor whiteColor]];
    if(self){
        UpperCarouselDataSourceAndDelegate* upperCarouselDSandD = [[UpperCarouselDataSourceAndDelegate alloc] init];
        self.upperCarouselDataSourceAndDelegate = upperCarouselDSandD;

        self.upperCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(CAROUSEL_X,CAROUSEL_Y,frame.size.width,CAROUSEL_HEIGHT)];
        self.upperCarousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.upperCarousel.type = iCarouselTypeLinear;
        self.upperCarousel.delegate = self.upperCarouselDataSourceAndDelegate;
        self.upperCarousel.dataSource = self.upperCarouselDataSourceAndDelegate;

        [self addSubview:self.upperCarousel];
        
        UIButton* dailySurveyButton = [[UIButton alloc]initWithFrame:CGRectMake(-80+frame.size.width/2,200,160,40)];
        [dailySurveyButton setTitle:@"Take Daily Survey" forState:UIControlStateNormal];
        [dailySurveyButton setBackgroundColor:[UIColor blueColor]];
        [self addSubview:dailySurveyButton];
        [self setDailySurveyButton:dailySurveyButton];
    
        LowerCarouselDataSourceAndDelegate* lowerCarouselDSandD = [[LowerCarouselDataSourceAndDelegate alloc] init];
        self.lowerCarouselDataSourceAndDelegate = lowerCarouselDSandD;

        self.lowerCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0,250,frame.size.width,400)];
        self.lowerCarousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        self.lowerCarousel.type = iCarouselTypeLinear;

        self.lowerCarousel.dataSource = self.lowerCarouselDataSourceAndDelegate;
        self.lowerCarousel.delegate = self.lowerCarouselDataSourceAndDelegate;

        
        [self addSubview:self.lowerCarousel];
    }
    return self;
}


@end