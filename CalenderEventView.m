//
//  CalenderEventView.m
//  Fulcrum
//
//  Created by Keagan Long on 2/11/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CalenderEventView.h"
#import "DateService.h"
#import "FulcrumAPIFacade.h"
#import "CalenderEvent.h"

@implementation CalenderEventView

-(id)initWithFrame:(CGRect)frame andCalenderEvent:(CalenderEvent*)calenderEvent{
    self = [super initWithFrame:frame];
    if(self){
        self.center = CGPointMake(CGRectGetMidX(frame), CGRectGetMidY(frame));
        self.frame = frame;
        self.calenderEvent = calenderEvent;
        [self initView];
    }
    return self;
}

-(void)initView{
    UILabel* titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, 16)];
    [titleLabel setText:self.calenderEvent.Title==[NSNull null] ? @"Calender Event":self.calenderEvent.Title];
    titleLabel.textAlignment = NSTextAlignmentLeft;
    titleLabel.numberOfLines =0;
    titleLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel = titleLabel;
    [self addSubview:titleLabel];
    
    UILabel* timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 16, self.frame.size.width, 16)];
    NSString* forTimeString = [DateService hourMinuteForDate:self.calenderEvent.StartDate];
    NSString* endTimeString = [DateService hourMinuteForDate:self.calenderEvent.EndDate];
    NSString* timeString = [NSString stringWithFormat:@"%@ - %@",forTimeString,endTimeString];
    [timeLabel setText:timeString];
    timeLabel.textAlignment = NSTextAlignmentLeft;
    timeLabel.numberOfLines =0;
    timeLabel.adjustsFontSizeToFitWidth = YES;
    self.timeLabel = timeLabel;
    [self addSubview:timeLabel];
    
    UISlider* slider = [[UISlider alloc] initWithFrame:CGRectMake(0, 40, self.frame.size.width, 10)];
    [slider setMinimumValue:1.0];
    [slider setMaximumValue:5.0];
    [slider setValue:3.0];
    [slider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
    [slider addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    self.slider = slider;
    [self addSubview:slider];
    
    UILabel* currentSelectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,55,15,15)];
    currentSelectionLabel.numberOfLines = 1;
    currentSelectionLabel.textAlignment = NSTextAlignmentCenter;
    currentSelectionLabel.adjustsFontSizeToFitWidth = YES;
    
    UIButton* rateButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    rateButton.frame = CGRectMake(-30+self.frame.size.width/2, 30, 80, 30);
    [rateButton setTitle:@"Rate Stress" forState:UIControlStateNormal];
    [rateButton addTarget:self action:@selector(onRateButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    self.rateButton = rateButton;
    [self addSubview:self.rateButton];
    
    if(self.calenderEvent.Rated){
        [currentSelectionLabel setText:[NSString stringWithFormat:@"%@",self.calenderEvent.StressLevel]];
        [slider setValue:[self.calenderEvent.StressLevel intValue]];
        [self.rateButton setEnabled:NO];
        [self.rateButton setHidden:YES];
    }
    else{
        [self.slider setEnabled:NO];
        [self.slider setHidden:YES];
        currentSelectionLabel.text = @"";
    }
    self.currentSelectionLabel = currentSelectionLabel;
    [self addSubview:currentSelectionLabel];
}

- (IBAction)onSliderValueChanged:(id)sender {
    float currentValue = [self.slider value];
    int currIndex = (int)round(currentValue)-1;
    [self.currentSelectionLabel setText:[NSString stringWithFormat:@"%i",(currIndex+1)]];
}

- (IBAction)onRateButtonTouchUpInside:(id)sender {
    [self.rateButton setEnabled:NO];
    [self.rateButton setHidden:YES];
    [self.slider setEnabled:YES];
    [self.slider setHidden:NO];
}

- (IBAction)onTouchUpInside:(id)sender {
    float currentValue = [self.slider value];
    int stressLevel =  round(currentValue);
    [self.slider setValue:stressLevel];
    self.calenderEvent.Rated = YES;
    self.calenderEvent.Ignored = NO;
    self.calenderEvent.StressLevel = [NSNumber numberWithInt:stressLevel];
    [self updateCalenderEvent];
}

-(void)updateCalenderEvent{
    UIView* savingView = [[UIView alloc] initWithFrame:self.bounds];
    savingView.backgroundColor = [UIColor colorWithRed:0.455 green:0.455 blue:0.522 alpha:0.3];
    self.slider.enabled = NO;
    [self addSubview:savingView];
    [FulcrumAPIFacade updateCalenderEvent:self.calenderEvent withCompletionHandler:^(NSError * error) {
        NSLog(@"Update error: %@",error);
        dispatch_async(dispatch_get_main_queue(),
            ^{
                self.slider.enabled = YES;
                savingView.hidden = YES;
                [savingView removeFromSuperview];
            });
    }];
}

@end