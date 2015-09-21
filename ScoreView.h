//
//  UIView_ScoreView.h
//  Fulcrum
//
//  Created by Keagan Long on 9/1/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DailySurveyWellnessAverage.h"

@interface ScoreView : UIView

@property DailySurveyWellnessAverage* dailySurveyWellnessAverage;
@property CGRect containerFrame;
@property UIView* containerView;

-(id)initWithDailySurveyWellnessAverage:(DailySurveyWellnessAverage*)dailySurveyWellnessAverage AndFrame:(CGRect)frame;

@end
