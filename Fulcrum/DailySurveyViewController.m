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
    self = [super init];
    if(self){
        self.view.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.dailySurveyQuestionViews = [[NSMutableArray alloc]init];
    questionResponses = [NSArray arrayWithObjects:
                        [NSArray arrayWithObjects:@"Not Coping",@"Poorly",@"Ok",@"Well", @"Very Well", nil],
                        [NSArray arrayWithObjects:@"Terrible",@"Bad",@"Fair",@"Good", @"Fantastic", nil],
                        [NSArray arrayWithObjects:@"Hopeless",@"Down",@"Ok",@"Good", @"Amazing", nil],
                        [NSArray arrayWithObjects:@"Very Dissatisfied",@"Dissatisfied",@"Neutral",@"Satisfied", @"Very Satisfied", nil],
                        [NSArray arrayWithObjects:@"Very Stressed",@"Stressed",@"Ok",@"Somewhat Relaxed", @"Relaxed", nil],
                        [NSArray arrayWithObjects:@"Very Dissatisfied",@"Dissatisfied",@"Neutral",@"Satisfied", @"Very Satisfied", nil],
                        [NSArray arrayWithObjects:@"Very Dissatisfied",@"Dissatisfied",@"Neutral",@"Satisfied", @"Very Satisfied", nil],
                        [NSArray arrayWithObjects:@"Very Unhealthy",@"Unhealthy",@"Ok",@"Healthy", @"Very Healthy", nil],
                        [NSArray arrayWithObjects:@"Very Dissatisfied",@"Dissatisfied",@"Neutral",@"Satisfied", @"Very Satisfied", nil],
                        [NSArray arrayWithObjects:@"Distant",@"Unconnected",@"Eh..",@"Connected", @"Very Connected", nil], nil];

    questionTitles = [NSArray arrayWithObjects:
                      @"How well did you cope today?",
                      @"How did you feel today overall?",
                      @"How did you feel about yourself today?",
                      @"How do you feel about your academic performance today?",
                      @"How stressed do you feel today?",
                      @"How satisfied are you with your academic productivity today?",
                      @"How satisfied are you with your physical activity today",
                      @"How healthy do you feel today",
                      @"Rate your social life today",
                      @"How connected to others did you feel today?",
                      nil];

    
    [self initDailySurveyQuestions];
    [self initQuestionViews];
    

    
}

-(void)initDailySurveyQuestions{
    self.dailySurveyQuestions = [[NSMutableArray alloc] init];

    for(int i = 0; i< [questionTitles count];i++){
        DailySurveyQuestion* q = [[DailySurveyQuestion alloc] init];
        [q setQuestionString:[questionTitles objectAtIndex:i]];
        [q setResponses:[questionResponses objectAtIndex:i]];
        [self.dailySurveyQuestions addObject:q];
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
        UIView* currView = [[DailySurveyQuestionView alloc] initWithDailySurveyQuestion:[self.dailySurveyQuestions objectAtIndex:i]AndWithFrame:CGRectMake(0,140*i,fullScreenRect.size.width-40,140)];
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
        [self surveySubmitted];
    }];
    
    [self presentViewController:confirmationAlertController animated:YES completion:^(void) {}];
    
    [confirmationAlertController addAction: noAction];
    [confirmationAlertController addAction:yesAction];
}

-(void)saveResponses{
    DailySurveyResponse* dailySurveyResponse = [[DailySurveyResponse alloc]init];
    [dailySurveyResponse setSubmissionDate:[NSDate date]];
    //[dailySurveyResponse setForDate:[NSDate date]];
    NSDate* hackDate = [DateService dateFromYearMonthDateString:@"2015-02-16"];
    [dailySurveyResponse setForDate:hackDate];
    NSMutableArray* dailySurveyQuestionResponses = [NSMutableArray new];
    for(int i = 0;i<[self.dailySurveyQuestionViews count];i++){
        DailySurveyQuestionView* currView = [self.dailySurveyQuestionViews objectAtIndex:i];
        float rawValue = [[currView slider] value];
        int roundedValue = round(rawValue);
        DailySurveyQuestionResponse* questionResponse = [[DailySurveyQuestionResponse alloc] init];
        [questionResponse setValue:roundedValue];
        [questionResponse setTitle:[[currView currentSelectionLabel] text]];
        [dailySurveyQuestionResponses addObject:questionResponse];
    }
    [dailySurveyResponse setDailySurveyQuestionResponses:dailySurveyQuestionResponses];
    
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults valueForKey:@"access_token"];
    if(token != nil){
        //NSLog(@"%@",token);
        [FulcrumAPIFacade submitDailySurveyResponse:dailySurveyResponse withCallback:^(NSError *error) {
            NSLog(@"Submit Error: %@",error);
        }];
    }
}

-(void)surveySubmitted{
    MainViewController* mainViewController = [[MainViewController alloc]init];
    [[self navigationController] popViewControllerAnimated:NO];
    [[self navigationController] pushViewController:mainViewController animated:YES];
    
}

@end
