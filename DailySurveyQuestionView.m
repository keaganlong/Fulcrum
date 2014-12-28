//
//  DailySurveyQuestionView.m
//  Fulcrum
//
//  Created by Keagan Long on 12/27/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DailySurveyQuestionView.h"

@implementation DailySurveyQuestionView

-(id) initWithDailySurveyQuestion: (DailySurveyQuestion*) question AndWithFrame: (CGRect) frame{
    [self setWidth:frame.size.width];
    [self setHeight:frame.size.height];
    self = [super initWithFrame:frame];
    if(self){
        self.dailySurveyQuestion = question;
        UILabel* questionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,0,frame.size.width,50)];
        questionLabel.numberOfLines = 1;
        questionLabel.adjustsFontSizeToFitWidth = YES;
        questionLabel.textAlignment = NSTextAlignmentCenter;
        [questionLabel setText:[self.dailySurveyQuestion questionString]];
        [self setQuestionLabel: questionLabel];
        
        UISlider* slider =[[UISlider alloc]initWithFrame:CGRectMake(10,[self height]*(1.0/3.0),frame.size.width-20,[self height]*(1.0/3.0))];
        [slider setMinimumValue:1.0];
        [slider setMaximumValue:5.0];
        [slider setValue:3.0];
        [slider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(onTouchDragExit:) forControlEvents:UIControlEventTouchDragExit];
        [self setSlider:slider];
        
        UILabel* currentSelectionLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,[self height]*(2.0/3.0),frame.size.width,50)];
        currentSelectionLabel.numberOfLines = 1;
        currentSelectionLabel.adjustsFontSizeToFitWidth = YES;
        currentSelectionLabel.textAlignment = NSTextAlignmentCenter;
        [currentSelectionLabel setText:[[self.dailySurveyQuestion responses] objectAtIndex:[self.dailySurveyQuestion.responses count]/2]];
        [self setCurrentSelectionLabel: currentSelectionLabel];
        
        [self addSubview:[self questionLabel]];
        [self addSubview:[self slider]];
        [self addSubview:[self currentSelectionLabel]];
        self.layer.borderColor = [UIColor redColor].CGColor;
        self.layer.borderWidth = 2.0f;
        
    }
    return self;
}

- (IBAction)onSliderValueChanged:(id)sender {
    float currentValue = [self.slider value];
    int currIndex = (int)round(currentValue)-1;
    [self.currentSelectionLabel setText:[[self.dailySurveyQuestion responses] objectAtIndex:currIndex]];
}

- (IBAction)onTouchDragExit:(id)sender {
    float currentValue = [self.slider value];
    NSLog(@"%f %f",currentValue, round(currentValue));
    [self.slider setValue:round(currentValue)];
}

@end