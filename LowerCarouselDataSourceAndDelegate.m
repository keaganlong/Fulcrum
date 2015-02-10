//
//  LowerCarouselDataSourceAndDelegate.m
//  Fulcrum
//
//  Created by Keagan Long on 11/14/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iCarousel.h"
#import "LowerCarouselDataSourceAndDelegate.h"
#import "JBBarChartView.h"
#import "iCalService.h"
#import "CalenderEvent.h"
#import "FulcrumAPIFacade.h"
#import "DateService.h"
#import "LowerCarouselDateView.h"
#import "DateViewController.h"
#import "MainViewController.h"
#import "iCarousel.h"

@implementation LowerCarouselDataSourceAndDelegate

- (id)initWithController:(MainViewController*)mainViewController AndWithCarousel:(iCarousel*)carousel{
    self = [super init];
    if (self) {
        self.parentViewController = mainViewController;
        self.carousel = carousel;
        [self initCalenderEvents];
    }
    return self;
}

-(void)initCalenderEvents{
    self.dates = [DateService getDateRangeStartingWithDate:[NSDate date] daysPrior:14 daysFuture:14];
    NSDate* startDate = [self.dates firstObject];
    NSDate* endDate = [self.dates lastObject];
    self.eventMap = [NSMutableDictionary new];
    [FulcrumAPIFacade getCalenderEventsWithStartDate:startDate AndEndDate:endDate withCompletionHandler:^(NSArray *calenderEvents) {
        if(calenderEvents!=nil){
            [self processCalenderEvents:calenderEvents];
        }
        [self.carousel reloadData];
    }];
}
-(void)processCalenderEvents:(NSArray*)calenderEvents{
    for(int i = 0; i<[calenderEvents count];i++){
        CalenderEvent* currEvent = [calenderEvents objectAtIndex:i];
        NSString* key = [DateService yearMonthDateStringFromDate:currEvent.StartDate];
        if(self.eventMap[key]==nil){
            self.eventMap[key] = [NSMutableArray new];
        }
        NSMutableArray* eventListForDate = self.eventMap[key];
        [eventListForDate addObject:currEvent];
    }
}

-(void)retrieveNewCalenderEvents{
    EKEventStore* store = [iCalService currentStore];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *oneDayAgoComponents = [[NSDateComponents alloc] init];
    oneDayAgoComponents.day = -1;
    NSDate *oneDayAgo = [NSDate date];
    
    NSDateComponents *oneWeekFromNowComponents = [[NSDateComponents alloc] init];
    oneWeekFromNowComponents.day = 7;
    NSDate *oneWeekFromNow = [calendar dateByAddingComponents:oneWeekFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    NSPredicate *predicate = [store predicateForEventsWithStartDate:oneDayAgo
                                                            endDate:oneWeekFromNow
                                                          calendars:nil];
    NSArray* eventsUnsorted = [store eventsMatchingPredicate:predicate];
    NSArray* events = [eventsUnsorted sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    NSMutableDictionary* eventDict = [NSMutableDictionary new];
    for(int i = 0; i<[events count];i++){
        EKEvent* event = [events objectAtIndex:i];
        if(eventDict[event.eventIdentifier]==nil){
            eventDict[event.eventIdentifier] = event;
        }
    }
    NSMutableArray* calenderEvents = [NSMutableArray new];
    for(NSString* key in eventDict){
        EKEvent* event = eventDict[key];
        CalenderEvent* calenderEvent = [[CalenderEvent alloc] init];
        calenderEvent.EventIdentifier = event.eventIdentifier;
        calenderEvent.StressLevel = 1+rand()%5;
        calenderEvent.Rated = true;
        calenderEvent.Ignored = false;
        calenderEvent.StartDate = event.startDate;
        [calenderEvents addObject:calenderEvent];
    }
    NSLog(@"New events to add: %lu",[calenderEvents count]);
    [FulcrumAPIFacade addCalenderEvents:calenderEvents withCompletionHandler:^(NSError * error) {
        if(error != nil){
            NSLog(@"%@",error);
        }
    }];
}


- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.dates count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
//    if(view!=nil){
//        return view;
//    }
    index = (13+index)%[self.dates count];
    NSDate* date = [self.dates objectAtIndex:index];
    NSInteger totalStress = [self getTotalStressForDate:date];
    
    UIView* newView = [[LowerCarouselDateView alloc] initWithDate:date AndTotalStress:totalStress];
    [newView setTag:index];
    [self addGestureToView:newView];
    return newView;
}

-(void)addGestureToView:(UIView*)view{
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [view addGestureRecognizer:tapGestureRecognizer];
}

-(NSMutableArray*)getCalenderEventsForDate:(NSDate*)date{
    NSString* key = [DateService yearMonthDateStringFromDate:date];
    NSMutableArray* calenderEventsForDay = self.eventMap[key];
    return calenderEventsForDay;
}

-(NSInteger)getTotalStressForDate:(NSDate*)date{
    NSInteger output = 0;
    NSMutableArray* calenderEvents = [self getCalenderEventsForDate:date];
    for(int i = 0; i<[calenderEvents count];i++){
        CalenderEvent* currCalenderEvent = [calenderEvents objectAtIndex:i];
        output+= currCalenderEvent.StressLevel;
    }
    return output;
}

-(IBAction)onTap:(id)sender{
    UITapGestureRecognizer* tapGestureRecognizer = (UITapGestureRecognizer*)sender;
    NSInteger tag = tapGestureRecognizer.view.tag;
   
    if([tapGestureRecognizer state]==UIGestureRecognizerStateEnded){
        NSDate* dateClicked = [self.dates objectAtIndex:tag];
        NSMutableArray* calenderEventsForDay = [self getCalenderEventsForDate:dateClicked];
        
        UIViewController* dateViewController = [[DateViewController alloc]initWithCalenderEvents:calenderEventsForDay];
        [self.parentViewController changeToViewController:dateViewController];
    }
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [label.font fontWithSize:50.0f];
        [view addSubview:label];
    }
    else
    {
        label = [[view subviews] lastObject];
    }
    
    //set label
    label.text = (index == 0)? @"[": @"]";
    
    return view;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return NO;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return 1.3*value;
        }
    }
}


- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView{
    return 5;
}


- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index{
    int randomInt = 1+(index % 2);
    NSLog(@"%i",randomInt);
    return index+1;
}

- (UIView *)barChartView:(JBBarChartView *)barChartView barViewAtIndex:(NSUInteger)index
{
    UIView* view = [[UIView alloc] init];
    view.alpha = 0.5;
    view.backgroundColor = [UIColor blueColor];
    return view;
}




@end