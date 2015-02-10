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

@implementation DateViewController

-(id)initWithCalenderEvents:(NSMutableArray*)calenderEvents{
    self = [self init];
    if(self){
        self.calenderEvents = calenderEvents;
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
    for(int i = 0; i<[self.calenderEvents count];i++){
        CGRect frame = CGRectMake(20,120+i*20,self.view.frame.size.width-40,20);
        UILabel* label = [[UILabel alloc] initWithFrame:frame];
        label.textAlignment = NSTextAlignmentLeft;
        
        CalenderEvent* calenderEvent = [self.calenderEvents objectAtIndex:i];
        [label setText:calenderEvent.Title==nil ? @"Calender Event":calenderEvent.Title];
        label.numberOfLines =0;
        label.adjustsFontSizeToFitWidth = YES;
        [self.view addSubview:label];
    }
}

@end