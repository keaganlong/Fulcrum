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


@implementation DailySurveyViewController

NSArray *question1Responses;
NSArray *question2Responses;
NSArray *question3Responses;

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
    
    question1Responses = [NSArray arrayWithObjects:@"Not Coping",@"Poorly",@"Ok",@"Well", @"Very Well", nil];
    question2Responses = [NSArray arrayWithObjects:@"Terrible",@"Bad",@"Fair",@"Good", @"Fantastic", nil];
    question3Responses = [NSArray arrayWithObjects:@"Distant",@"Unconnected",@"Eh..",@"Connected", @"Very Connected", nil];
    self.dailySurveyQuestions = [[NSMutableArray alloc] init];
    
    DailySurveyQuestion* q1 = [[DailySurveyQuestion alloc] init];
    [q1 setQuestionString:@"How well did you cope today?"];
    [q1 setResponses:question1Responses];
    [self.dailySurveyQuestions addObject:q1];
    DailySurveyQuestion* q2 = [[DailySurveyQuestion alloc] init];
    [q2 setQuestionString:@"How did you feel today overall?"];
    [q2 setResponses:question2Responses];
    [self.dailySurveyQuestions addObject:q2];
    DailySurveyQuestion* q3 = [[DailySurveyQuestion alloc] init];
    [q3 setQuestionString:@"How connected to others did you feel today?"];
    [q3 setResponses:question3Responses];
    [self.dailySurveyQuestions addObject:q3];
    
    [self initQuestionViews];
    

    
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
    for(int i = 0;i<[self.dailySurveyQuestionViews count];i++){
        DailySurveyQuestionView* currView = [self.dailySurveyQuestionViews objectAtIndex:i];
        float rawValue = [[currView slider] value];
        int roundedValue = round(rawValue);
        NSLog(@"%d",roundedValue);
    }
}

-(void)surveySubmitted{
    MainViewController* mainViewController = [[MainViewController alloc]init];
    [[self navigationController] pushViewController:mainViewController animated:YES];
    
}

@end
