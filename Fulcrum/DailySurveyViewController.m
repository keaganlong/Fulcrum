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

@implementation DailySurveyViewController{
    NSArray *questionResponses;
    NSArray* questionTitles;
}
-(id)init{
    return [self initWithDailySurveyResponse:nil];
}

-(id)initWithDailySurveyResponse:(DailySurveyResponse*) dailySurveyResponse{
    self = [super init];
    if(self){
        self.view.backgroundColor = [UIColor whiteColor];
        self.dailySurveyResponse = dailySurveyResponse;
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
    else{
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
}

-(void)setSliderValues{
    NSArray* questionResponses = self.dailySurveyResponse.dailySurveyQuestionResponses;
    for(int i = 0; i<[questionResponses count];i++){
        DailySurveyQuestionView* currView = [self.dailySurveyQuestionViews objectAtIndex:i];
        DailySurveyQuestionResponse* currQuestionResponse = [questionResponses objectAtIndex:i];
        float value = [currQuestionResponse.value floatValue];
        [currView.slider setValue:value];
    }
}

-(void) initQuestionViews{
    CGRect fullScreenRect=[[UIScreen mainScreen] applicationFrame];
    fullScreenRect.origin.x = 20;
    fullScreenRect.origin.y = 80;
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
    [[self navigationController] popViewControllerAnimated:NO];
    [[self navigationController] pushViewController:mainViewController animated:YES];
    
}

@end
