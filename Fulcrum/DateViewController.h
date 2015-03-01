//
//  DateViewController.h
//  Fulcrum
//
//  Created by Keagan Long on 2/3/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

@interface DateViewController : UIViewController

@property NSArray* calenderEvents;

-(id)initWithCalenderEvents:(NSMutableArray*)calenderEvents forDate:(NSDate*)date;

@end
