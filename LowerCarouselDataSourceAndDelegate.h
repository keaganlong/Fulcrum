//
//  LowerCarouselDataSourceAndDelegate.h
//  Fulcrum
//
//  Created by Keagan Long on 11/14/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//
#import "iCarousel.h"

@class MainViewController;

@interface LowerCarouselDataSourceAndDelegate: NSObject<iCarouselDataSource, iCarouselDelegate>

- (id)initWithController:(MainViewController*)mainViewController AndWithCarousel:(iCarousel*)carousel;

@property NSMutableArray* dates;
@property NSMutableDictionary* eventMap;
@property NSMutableSet* currentEventsSet;
@property NSMutableSet* needsRatingSet;
@property NSMutableArray* currentEvents;
@property int currentDateIndex;
@property (nonatomic, weak) iCarousel *carousel;
@property MainViewController* parentViewController;
@property BOOL firstTimeViewed;
@property BOOL initialized;

-(void)refresh;

@end

