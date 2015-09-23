//
//  DailySurveyViewController.h
//  Fulcrum
//
//  Created by Keagan Long on 11/14/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailySurveyQuestion.h"
#import "DailySurveyResponse.h"

@interface DailySurveyViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIScrollView *questionScrollView;
@property NSArray* dailySurveyQuestions;
@property NSMutableArray* dailySurveyQuestionViews;
@property UIView* loadingView;
@property NSDate* date;
@property BOOL editable;

@property DailySurveyResponse* dailySurveyResponse;

-(id)initWithDailySurveyResponse:(DailySurveyResponse*) dailySurveyResponse date:(NSDate*)date editable:(BOOL)editable;

@end
