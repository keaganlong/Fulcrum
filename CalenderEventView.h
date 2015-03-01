//
//  CalenderEventView.h
//  Fulcrum
//
//  Created by Keagan Long on 2/11/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import "CalenderEvent.h"

@interface CalenderEventView : UIView

@property CalenderEvent* calenderEvent;

@property CGRect frame;
@property UILabel* titleLabel;
@property UILabel* timeLabel;
@property UISlider* slider;
@property UILabel* currentSelectionLabel;
@property UIButton* rateButton;

-(id)initWithFrame:(CGRect)frame andCalenderEvent:(CalenderEvent*)calenderEvent;

@end