//
//  FirstViewController.m
//  Fulcrum
//
//  Created by Keagan Long on 11/6/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "DailySurveyViewController.h"

@interface DailySurveyViewController ()

@end

@implementation DailySurveyViewController

NSArray *question1Responses;
NSArray *question2Responses;
NSArray *question3Responses;

- (void)viewDidLoad
{
    [super viewDidLoad];
    question1Responses = [NSArray arrayWithObjects:@"Not Coping",@"Poorly",@"Ok",@"Well", @"Very Well", nil];
    question2Responses = [NSArray arrayWithObjects:@"Terrible",@"Bad",@"Fair",@"Good", @"Fantastic", nil];
    question3Responses = [NSArray arrayWithObjects:@"Distant",@"Unconnected",@"Eh..",@"Connected", @"Very Connected", nil];

}

- (IBAction)onSliderValueChanged:(id)sender {
    int index;
    if(sender == self.question1Slider){
        index = ((int)self.question1Slider.value)-1;
        self.question1Label.text = [question1Responses objectAtIndex:index];
    }
    else if(sender==self.question2Slider){
        index = ((int)self.question2Slider.value)-1;
        self.question2Label.text = [question2Responses objectAtIndex:index];
    }
    else if(sender==self.question3Slider){
        index = ((int)self.question3Slider.value)-1;
        self.question3Label.text = [question3Responses objectAtIndex:index];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)onTouchDragExit:(id)sender {
    if(sender == self.question1Slider){
        self.question1Slider.value = round(self.question1Slider.value);
    }
    else if(sender==self.question2Slider){
        self.question2Slider.value = round(self.question2Slider.value);
    }
    else if(sender==self.question3Slider){
        self.question3Slider.value = round(self.question3Slider.value);
    }
    
    int index;
    if(sender == self.question1Slider){
        index = ((int)self.question1Slider.value)-1;
        self.question1Label.text = [question1Responses objectAtIndex:index];
    }
    else if(sender==self.question2Slider){
        index = ((int)self.question2Slider.value)-1;
        self.question2Label.text = [question2Responses objectAtIndex:index];
    }
    else if(sender==self.question3Slider){
        index = ((int)self.question3Slider.value)-1;
        self.question3Label.text = [question3Responses objectAtIndex:index];
    }
}




@end
