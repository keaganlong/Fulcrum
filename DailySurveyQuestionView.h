//
//  DailySurveyQuestionView.h
//  Fulcrum
//
//  Created by Keagan Long on 12/27/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import "DailySurveyQuestion.h"

@interface DailySurveyQuestionView: UIView

@property DailySurveyQuestion* dailySurveyQuestion;
@property UILabel* questionLabel;
@property UISlider* slider;
@property UILabel* currentSelectionLabel;
@property CGFloat width;
@property CGFloat height;

-(id) initWithDailySurveyQuestion: (DailySurveyQuestion*) question AndWithFrame: (CGRect) frame;
-(IBAction)onSliderValueChanged:(id)sender;
- (IBAction)onTouchDragExit:(id)sender;

@end
