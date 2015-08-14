//
//  DateView.h
//  Fulcrum
//
//  Created by Keagan Long on 2/3/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import "StressStrategy.h"

@interface LowerCarouselDateView : UIView

@property NSDate* date;
@property NSInteger totalStress;
@property NSInteger numEvents;

@property UIView* barView;
@property UIView* circleView;

-(id)initWithDate:(NSDate*)date AndTotalStress:(NSInteger)totalStress AndNumEvents:(NSInteger)numEvents;
-(void)setNeedsRating;

@end
