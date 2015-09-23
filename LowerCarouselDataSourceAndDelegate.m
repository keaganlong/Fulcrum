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
        self.initialized = NO;
        self.currentDateIndex = 7;
        self.parentViewController = mainViewController;
        self.carousel = carousel;
    }
    return self;
}

-(void)initCalenderEvents{
    self.dates = [DateService getDateRangeStartingWithDate:[NSDate date] daysPrior:8 daysFuture:8];
    NSMutableArray* d = [DateService getDateRangeStartingWithDate:[NSDate date] daysPrior:9 daysFuture:9];
   
    self.eventMap = [NSMutableDictionary new];
    [FulcrumAPIFacade getCalenderEventsWithStartDate:[d firstObject] AndEndDate:[d lastObject] withCompletionHandler:^(NSArray *calenderEvents) {
        if(calenderEvents!=nil){
            NSLog(@"Retrived: %lu calender events",[calenderEvents count]);
            [self processCalenderEvents:calenderEvents];
        }
        [self retrieveNewCalenderEventsWithCallback:^{
            dispatch_async(dispatch_get_main_queue(),
                   ^{
                       [self.carousel reloadData];
                       [self.carousel scrollToItemAtIndex:self.currentDateIndex animated:NO];
                       CGRect dateBarFrame = CGRectMake(0, 457, 500, 10);
                       UIView* dateBar = [[UIView alloc] initWithFrame:dateBarFrame];
                       [dateBar setBackgroundColor:[UIColor blackColor]];
                       [self.parentViewController.view addSubview:dateBar];
                       self.initialized = YES;
                   });
        }];
    }];
}

-(void)processCalenderEvents:(NSArray*)calenderEvents{
    for(int i = 0; i<[calenderEvents count];i++){
        CalenderEvent* currEvent = [calenderEvents objectAtIndex:i];
        [self.currentEventsSet addObject:currEvent.EventIdentifier];
        
        [self.currentEvents addObject:currEvent];
        
        NSString* key = [DateService yearMonthDateStringFromDate:currEvent.StartDate];
        if(!currEvent.Rated) {
            [self.needsRatingSet addObject:key];
        }
        if(self.eventMap[key]==nil) {
            self.eventMap[key] = [NSMutableArray new];
        }
        NSMutableArray* eventListForDate = self.eventMap[key];
        [eventListForDate addObject:currEvent];
    }
}

-(void)retrieveNewCalenderEventsWithCallback:(void(^)())callBack{
    EKEventStore* store = [iCalService currentStore];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    //NSDateComponents *oneWeekBeforeNowComponents = [[NSDateComponents alloc] init];
    //oneWeekBeforeNowComponents.day = -7;
    
    
//    NSDate *oneWeekBeforeNow = [calendar dateByAddingComponents:oneWeekBeforeNowComponents
//                                                       toDate:[NSDate date]
//                                                      options:0];
    
    NSDateComponents *twoWeeksFromNowComponents = [[NSDateComponents alloc] init];
    twoWeeksFromNowComponents.day = 14;
    
    NSDate *twoWeeksFromNow = [calendar dateByAddingComponents:twoWeeksFromNowComponents
                                                       toDate:[NSDate date]
                                                      options:0];
    NSPredicate *predicate = [store predicateForEventsWithStartDate:[NSDate date]
                                                            endDate:twoWeeksFromNow
                                                          calendars:nil];
    
    NSArray* eventsUnsorted = [store eventsMatchingPredicate:predicate];
    NSArray* events = [eventsUnsorted sortedArrayUsingSelector:@selector(compareStartDateWithEvent:)];
    NSMutableArray* eventsToAdd = [NSMutableArray new];
    for(int i = 0; i<[events count];i++){
        EKEvent* event = [events objectAtIndex:i];
        NSMutableString* hackedEventIdentifier = [NSMutableString stringWithString:event.eventIdentifier];
        NSString* startDateString = [DateService yearMonthDateStringFromDate:event.startDate];
        [hackedEventIdentifier appendString:startDateString];
        NSString* hackedEventIdentifierString = [NSString stringWithString:hackedEventIdentifier];
        if(![self.currentEventsSet containsObject:hackedEventIdentifierString]){
            [self.currentEventsSet addObject:hackedEventIdentifierString];
            NSLog(@"\t Unseen: %@",event.title);
            [eventsToAdd addObject:event];
        }
    }
    NSMutableArray* calenderEvents = [NSMutableArray new];
    NSLog(@"New Events to Add: %lu",[eventsToAdd count]);
    for(int i = 0; i<[eventsToAdd count];i++){
        EKEvent* event = [eventsToAdd objectAtIndex:i];
        CalenderEvent* calenderEvent = [[CalenderEvent alloc] init];
        NSMutableString* hackedEventIdentifier = [NSMutableString stringWithString:event.eventIdentifier];
        NSString* startDateString = [DateService yearMonthDateStringFromDate:event.startDate];
        [hackedEventIdentifier appendString:startDateString];
        NSLog(@"\t Creating: %@",event.title);
        calenderEvent.EventIdentifier = hackedEventIdentifier;
        calenderEvent.StressLevel = 0;
        calenderEvent.Rated = false;
        calenderEvent.Ignored = false;
        calenderEvent.StartDate = event.startDate;
        calenderEvent.EndDate = event.endDate;
        calenderEvent.Title = event.title;
        [calenderEvents addObject:calenderEvent];
        
        NSString* key = [DateService yearMonthDateStringFromDate:calenderEvent.StartDate];
        [self.needsRatingSet addObject:key];
    }
    if([calenderEvents count] > 0){
        [FulcrumAPIFacade addCalenderEvents:calenderEvents withCompletionHandler:^(NSError * error) {
            if(error != nil){
                NSLog(@"Adding Calender Events Error: %@",error);
            }
            [self processCalenderEvents:calenderEvents];
            callBack();
        }];
    }
    else {
        callBack();
    }
}

- (void)carouselCurrentItemIndexDidChange:(iCarousel *)carousel{
    NSDate* newDate = [self.dates objectAtIndex:carousel.currentItemIndex];
    if(self.initialized){
        self.currentDateIndex = carousel.currentItemIndex;
    }
    [self.parentViewController dateChangedTo:newDate];
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.dates count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    NSDate* date = [self.dates objectAtIndex:index];
    NSInteger totalStress = [self getTotalStressForDate:date];
    NSInteger numEvents = [self getNumberOfEventsForDate:date];
    
    LowerCarouselDateView* newView = [[LowerCarouselDateView alloc] initWithDate:date AndTotalStress:totalStress AndNumEvents:numEvents];
    [newView setTag:index];
    NSString* dateString = [DateService yearMonthDateStringFromDate:date];
    if([self.needsRatingSet containsObject:dateString]){
        [newView setNeedsRating];
    }
    
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
        output+= [self stressFunction:currCalenderEvent.StressLevel];
    }
    return output;
}

-(NSInteger)stressFunction:(NSInteger)stressLevel{
    switch(stressLevel){
        case 0:
            return 0;
        case 1:
            return 0;
        case 2:
            return 1;
        case 3:
            return 5;
        case 4:
            return 8;
        case 5:
        default:
            return 12;
    }
}

-(NSInteger)getNumberOfEventsForDate:(NSDate*)date{
    NSMutableArray* calenderEvents = [self getCalenderEventsForDate:date];
    return [calenderEvents count];
}

-(IBAction)onTap:(id)sender{
    UITapGestureRecognizer* tapGestureRecognizer = (UITapGestureRecognizer*)sender;
    NSInteger tag = tapGestureRecognizer.view.tag;
   
    if([tapGestureRecognizer state]==UIGestureRecognizerStateEnded){
        NSDate* dateClicked = [self.dates objectAtIndex:tag];
        NSMutableArray* calenderEventsForDay = [self getCalenderEventsForDate:dateClicked];
        
        UIViewController* dateViewController = [[DateViewController alloc]initWithCalenderEvents:calenderEventsForDay forDate:dateClicked];
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
    return index+1;
}

- (UIView *)barChartView:(JBBarChartView *)barChartView barViewAtIndex:(NSUInteger)index
{
    UIView* view = [[UIView alloc] init];
    view.alpha = 0.5;
    view.backgroundColor = [UIColor blueColor];
    return view;
}

-(void)updateNeedsRatingSet{
    self.needsRatingSet = [NSMutableSet new];
    for(CalenderEvent* calenderEvent in self.currentEvents){
        if(!calenderEvent.Rated){
            NSString* key = [DateService yearMonthDateStringFromDate:calenderEvent.StartDate];
            [self.needsRatingSet addObject:key];
        }
    }
}

-(void)refresh{
    self.currentEvents = [NSMutableArray new];
    self.firstTimeViewed = YES;

    self.currentEventsSet = [NSMutableSet new];
    self.needsRatingSet = [NSMutableSet new];
    [self initCalenderEvents];
}



@end