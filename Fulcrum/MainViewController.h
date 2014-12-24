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

@interface MainViewController:UIViewController {
}
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, strong) UINavigationItem *navItem;
@property (nonatomic, strong) iCarousel *upperCarousel;
@property (strong,nonatomic) LowerCarouselDataSourceAndDelegate* lowerCarouselDataSourceAndDelegate;
@property (strong,nonatomic) UpperCarouselDataSourceAndDelegate* upperCarouselDataSourceAndDelegate;
@property (nonatomic, strong) iCarousel *lowerCarousel;
@property (nonatomic) NSMutableArray *dates;

@property (weak, nonatomic) IBOutlet UIButton *backButton;


@end
