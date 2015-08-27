//
//  MainViewController.h
//  Fulcrum
//
//  Created by Keagan Long on 11/9/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "iCarousel.h"
#import "JBBarChartView.h"
#import "LowerCarouselDataSourceAndDelegate.h"
#import "UpperCarouselDataSourceAndDelegate.h"
#import "DailySurveyDataMap.h"

@interface MainViewController:UIViewController

@property (nonatomic, strong) iCarousel *upperCarousel;
@property (strong,nonatomic) LowerCarouselDataSourceAndDelegate* lowerCarouselDataSourceAndDelegate;
@property (strong,nonatomic) UpperCarouselDataSourceAndDelegate* upperCarouselDataSourceAndDelegate;
@property (nonatomic, strong) iCarousel *lowerCarousel;
@property (nonatomic) NSMutableArray *dates;
@property (strong) UIButton* dailySurveyButton;
@property CGRect frame;
@property UIButton* overallWellnessButton;

@property UIButton* todayButton;

@property DailySurveyDataMap* dataMap;
@property NSDate* currDate;
@property UILabel* selectedDateLabel;

-(void)changeToViewController:(UIViewController*)viewController;
-(void)dateChangedTo:(NSDate*)newDate;

@end
