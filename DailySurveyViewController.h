//
//  DailySurveyViewController.h
//  Fulcrum
//
//  Created by Keagan Long on 11/14/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#ifndef Fulcrum_DailySurveyViewController_h
#define Fulcrum_DailySurveyViewController_h

#import <UIKit/UIKit.h>

@interface DailySurveyViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISlider *question1Slider;
@property (weak, nonatomic) IBOutlet UILabel *question1Label;
@property (weak, nonatomic) IBOutlet UISlider *question2Slider;
@property (weak, nonatomic) IBOutlet UILabel *question2Label;
@property (weak, nonatomic) IBOutlet UISlider *question3Slider;
@property (weak, nonatomic) IBOutlet UILabel *question3Label;
@property (weak, nonatomic) IBOutlet UIScrollView *questionScrollView;

@end


#endif
