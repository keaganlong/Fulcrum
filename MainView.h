//
//  MainView.h
//  Fulcrum
//
//  Created by Keagan Long on 12/28/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import "LowerCarouselDataSourceAndDelegate.h"
#import "UpperCarouselDataSourceAndDelegate.h"

@interface MainView: UIView

@property (nonatomic, strong) iCarousel *upperCarousel;
@property (strong,nonatomic) LowerCarouselDataSourceAndDelegate* lowerCarouselDataSourceAndDelegate;
@property (strong,nonatomic) UpperCarouselDataSourceAndDelegate* upperCarouselDataSourceAndDelegate;
@property (nonatomic, strong) iCarousel *lowerCarousel;
@property (nonatomic) NSMutableArray *dates;
@property UIButton* dailySurveyButton;

- (id)initWithFrame:(CGRect)frame;

@end