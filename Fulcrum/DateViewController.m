//
//  DateViewController.m
//  Fulcrum
//
//  Created by Keagan Long on 2/3/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DateViewController.h"
#import "CalenderEvent.h"
#import "CalenderEventView.h"
#import "DateService.h"

@implementation DateViewController

-(id)initWithCalenderEvents:(NSMutableArray*)calenderEvents forDate:(NSDate*)date{
    self = [self init];
    if(self){
        NSArray* sortedEvents = [calenderEvents sortedArrayUsingComparator:^(id obj1, id obj2) {
            return [[(CalenderEvent *)obj1 StartDate] compare:[(CalenderEvent*)obj2 StartDate]];
        }];
        self.calenderEvents = sortedEvents;
        UILabel* title = [[UILabel alloc] initWithFrame:CGRectMake(10,60,200,30)];
        NSString* monthDayString = [DateService monthDayStringForDate:date];
        [title setText:monthDayString];
        [self.view addSubview:title];
        [self initCalenderEventViews];
    }
    return self;
}

-(id)init{
    self = [super init];
    if(self){
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

-(void)initCalenderEventViews{
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    fullScreenRect.origin.x = 20;
    fullScreenRect.origin.y = 100;
    fullScreenRect.size.height = fullScreenRect.size.height - 120;
    fullScreenRect.size.width = fullScreenRect.size.width - 40;
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:fullScreenRect];
    scrollView.contentSize=CGSizeMake(fullScreenRect.size.width-40,90*[self.calenderEvents count]+40);
    
    for(int i = 0; i<[self.calenderEvents count];i++){
        CGRect frame = CGRectMake(0,i*90,self.view.frame.size.width-40,90);
        CalenderEvent* calenderEvent = [self.calenderEvents objectAtIndex:i];
        CalenderEventView* calenderView = [[CalenderEventView alloc] initWithFrame:frame andCalenderEvent:calenderEvent];
        [scrollView addSubview:calenderView];
    }
    [self.view addSubview:scrollView];
}


@end