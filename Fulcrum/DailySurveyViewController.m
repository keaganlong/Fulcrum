//
//  FirstViewController.m
//  Fulcrum
//
//  Created by Keagan Long on 11/6/14.
//  Copyright (c) 2014 ___FULLUSERNAME___. All rights reserved.
//

#import "DailySurveyViewController.h"
#import "DailySurveyQuestion.h"
#import "DailySurveyQuestionView.h"
#import "MainViewController.h"
#import "FulcrumAPIFacade.h"
#import "DailySurveyResponse.h"
#import "DailySurveyQuestionResponse.h"
#import "DateService.h"

#import <FlatUIKit/FlatUIKit.h>

@implementation DailySurveyViewController{
    NSArray *questionResponses;
    NSArray* questionTitles;
}

-(id)init{
    return [self initWithDailySurveyResponse:nil date:nil editable:NO];
}

-(id)initWithDailySurveyResponse:(DailySurveyResponse*) dailySurveyResponse date:(NSDate*)date editable:(BOOL)editable{
    self = [super init];
    if(self){
        self.view.backgroundColor = [UIColor whiteColor];
        self.dailySurveyResponse = dailySurveyResponse;
        self.date = date;
        self.editable = editable;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    self.dailySurveyQuestionViews = [[NSMutableArray alloc]init];
    [self initDailySurveyQuestions:^{
        [super viewWillAppear:animated];
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void)initDailySurveyQuestions:(void(^)())callBack{
    [self initDateLabel];
    if(self.dailySurveyResponse){
        NSArray* questionResponses = self.dailySurveyResponse.dailySurveyQuestionResponses;
        NSMutableArray* questions = [NSMutableArray new];
        for(DailySurveyQuestionResponse* questionResponse in questionResponses){
            [questions addObject:questionResponse.question];
        }
        self.dailySurveyQuestions = questions;
        [self initQuestionViews];
        [self setSliderValues];
    }
    else if(self.editable){
        [FulcrumAPIFacade getDailySurveyQuestions:^(NSArray* questions) {
            if(questions){
                self.dailySurveyQuestions = questions;
                [self initQuestionViews];
                callBack();
            }
            else{
                callBack();
            }
        }];
    }
    else{
        [self initNonCompletedSurveyView];
        callBack();
    }
}

-(void)initDateLabel{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame.origin.x = 10;
    frame.origin.y = 30;
    frame.size.height = 100;
    frame.size.width = frame.size.width - 10;
    UILabel* dateLabel = [[UILabel alloc] initWithFrame:frame];
    UIFont* font = [UIFont flatFontOfSize:22];
    dateLabel.font = font;
    NSString* dateString = [DateService readableStringFromDate:self.date];
    [dateLabel setText:dateString];
    dateLabel.adjustsFontSizeToFitWidth = YES;
    dateLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:dateLabel];
}

-(void)initNonCompletedSurveyView{
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame.origin.x = 20;
    frame.origin.y = 80;
    frame.size.height = 100;
    frame.size.width = frame.size.width - 20;
    UILabel* messageLabel = [[UILabel alloc] initWithFrame:frame];
    messageLabel.adjustsFontSizeToFitWidth = YES;
    messageLabel.textAlignment = NSTextAlignmentCenter;
    [messageLabel setText:@"Daily Survey not Completed"];
    [self.view addSubview:messageLabel];
}

-(void)setSliderValues{
    NSArray* questionResponses = self.dailySurveyResponse.dailySurveyQuestionResponses;
    for(int i = 0; i<[questionResponses count];i++){
        DailySurveyQuestionView* currView = [self.dailySurveyQuestionViews objectAtIndex:i];
        DailySurveyQuestionResponse* currQuestionResponse = [questionResponses objectAtIndex:i];
        float value = [currQuestionResponse.value floatValue];
        [currView.slider setValue:value];
        currView.slider.enabled = self.editable;
    }
}

-(void) initQuestionViews{
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    fullScreenRect.origin.x = 20;
    fullScreenRect.origin.y = 150;
    fullScreenRect.size.height = fullScreenRect.size.height - 80;
    fullScreenRect.size.width = fullScreenRect.size.width - 20;
    
    UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:fullScreenRect];
    scrollView.contentSize=CGSizeMake(fullScreenRect.size.width-60,140*[self.dailySurveyQuestions count]+100);
    //scrollView.contentInset=UIEdgeInsetsMake(64.0,0.0,44.0,0.0);
    
    int i;
    for(i = 0; i<[self.dailySurveyQuestions count];i++){
        DailySurveyQuestionView* currView = [[DailySurveyQuestionView alloc] initWithDailySurveyQuestion:[self.dailySurveyQuestions objectAtIndex:i]AndWithFrame:CGRectMake(0,140*i,fullScreenRect.size.width-40,140)];
        [self.dailySurveyQuestionViews addObject:currView];
        [scrollView addSubview:currView];
    }
    
    UIButton* completeButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    completeButton.frame = CGRectMake(105,140*i+15,50,30);
    [completeButton setTitle:@"Done" forState:UIControlStateNormal];
    [completeButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [completeButton setBackgroundColor:[UIColor blueColor]];
    [completeButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
    [completeButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [completeButton addTarget:self action:@selector(onTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    completeButton.enabled = self.editable;
    [scrollView addSubview:completeButton];
    
    self.questionScrollView = scrollView;
    [self.view addSubview:self.questionScrollView];
}

- (IBAction)onTouchUpInside:(id)sender{
    UIAlertController* confirmationAlertController = [UIAlertController alertControllerWithTitle:@"Confirm" message:@"Submit daily survey?" preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"No" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
        
    }];
    
    UIAlertAction* yesAction = [UIAlertAction actionWithTitle:@"Yes" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        [self saveResponses];
    }];
    
    [self presentViewController:confirmationAlertController animated:YES completion:^(void) {}];
    
    [confirmationAlertController addAction: noAction];
    [confirmationAlertController addAction:yesAction];
}

-(void)saveResponses{
    if(self.dailySurveyResponse){
        NSArray* questionResponses = self.dailySurveyResponse.dailySurveyQuestionResponses;
        for(int i = 0;i<[self.dailySurveyQuestionViews count];i++){
            DailySurveyQuestionView* currView = [self.dailySurveyQuestionViews objectAtIndex:i];
            float rawValue = [[currView slider] value];
            int roundedValue = round(rawValue);
            DailySurveyQuestionResponse* questionResponse = [questionResponses objectAtIndex:i];
            [questionResponse setValue:[NSNumber numberWithInt:roundedValue]];
            [questionResponse setResponse:[[currView currentSelectionLabel] text]];
        }
        CGRect fullFrame = [[UIScreen mainScreen] bounds];
        UIView* loadingView = [[UIView alloc] initWithFrame:fullFrame];
        loadingView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
        [self.view addSubview:loadingView];
        [FulcrumAPIFacade updateDailySurveyResponse:self.dailySurveyResponse withCallback:^(NSError *error) {
            [self surveySubmitted];
        }];
        
    }
    else{
        DailySurveyResponse* dailySurveyResponse = [[DailySurveyResponse alloc]init];
        NSDate* today = [NSDate date];
        [dailySurveyResponse setForDate:today];

        NSMutableArray* dailySurveyQuestionResponses = [NSMutableArray new];
        for(int i = 0;i<[self.dailySurveyQuestionViews count];i++){
            DailySurveyQuestionView* currView = [self.dailySurveyQuestionViews objectAtIndex:i];
            float rawValue = [[currView slider] value];
            int roundedValue = round(rawValue);
            DailySurveyQuestionResponse* questionResponse = [[DailySurveyQuestionResponse alloc] init];
            [questionResponse setValue:[NSNumber numberWithInt:roundedValue]];
            [questionResponse setResponse:[[currView currentSelectionLabel] text]];
            questionResponse.question = [self.dailySurveyQuestions objectAtIndex:i];
            [dailySurveyQuestionResponses addObject:questionResponse];
        }
        [dailySurveyResponse setDailySurveyQuestionResponses:dailySurveyQuestionResponses];

        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        NSString* token = [defaults valueForKey:@"access_token"];
        if(token != nil){
            CGRect fullFrame = [[UIScreen mainScreen] bounds];
            UIView* loadingView = [[UIView alloc] initWithFrame:fullFrame];
            loadingView.backgroundColor = [UIColor colorWithRed:0.5 green:0.5 blue:0.5 alpha:0.5];
            [self.view addSubview:loadingView];
            [FulcrumAPIFacade submitDailySurveyResponse:dailySurveyResponse withCallback:^(NSError *error) {
                [self surveySubmitted];
            }];
        }
    }
}

-(void)surveySubmitted{
    MainViewController* mainViewController = [[MainViewController alloc]init];
    [[self navigationController] popViewControllerAnimated:YES];
    [[self navigationController] pushViewController:mainViewController animated:YES];
}

@end
