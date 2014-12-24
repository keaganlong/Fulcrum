//
//  UpperCarouselDataSourceAndDelegate.h
//  Fulcrum
//
//  Created by Keagan Long on 12/23/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import "iCarousel.h"

@interface UpperCarouselDataSourceAndDelegate: NSObject<iCarouselDataSource, iCarouselDelegate>

@property (nonatomic, strong) NSMutableArray *items;

@end