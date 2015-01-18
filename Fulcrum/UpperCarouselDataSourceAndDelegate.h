//
//  UpperCarouselDataSourceAndDelegate.h
//  Fulcrum
//
//  Created by Keagan Long on 12/23/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import "iCarousel.h"
@class MainViewController;

@interface UpperCarouselDataSourceAndDelegate: NSObject<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) NSMutableArray *items;
@property MainViewController* parentViewController;

- (id)initWithController:(MainViewController*)mainViewController;

@end