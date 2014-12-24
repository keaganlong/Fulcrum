//
//  FirstViewController.m
//  Fulcrum
//
//  Created by Keagan Long on 11/6/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "DailySurveyViewController.h"


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
    
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:fullScreenRect];
    scrollView.contentSize=CGSizeMake(320,758);
    scrollView.contentInset=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    
    for(int i = 0; i<10;i++){
        CGRect frame = CGRectMake(0.0, i*100, 200.0, 10.0);
        UISlider *slider = [[UISlider alloc] initWithFrame:frame];
        [slider addTarget:self action:@selector(onSliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [slider setBackgroundColor:[UIColor clearColor]];
        slider.minimumValue = 0.0;
        slider.maximumValue = 50.0;
        slider.continuous = YES;
        slider.value = 25.0;
        [scrollView addSubview:slider];
    }
    self.questionScrollView = scrollView;
    [self.view addSubview:self.questionScrollView];

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
