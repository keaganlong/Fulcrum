//
//  CalenderEvent.h
//  Fulcrum
//
//  Created by Keagan Long on 2/1/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

@interface CalenderEvent : NSObject

@property NSString* EventIdentifier;
@property NSInteger StressLevel;
@property bool Rated;
@property bool Ignored;
@property NSDate* StartDate;
@property NSDate* EndDate;
@property NSString* Title;

@end
