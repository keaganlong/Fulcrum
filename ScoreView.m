//
//  ScoreView.m
//  Fulcrum
//
//  Created by Keagan Long on 9/1/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ScoreView.h"
#import "DotsView.h"

@implementation ScoreView

-(id)initWithDailySurveyWellnessAverage:(DailySurveyWellnessAverage*)dailySurveyWellnessAverage AndFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if(self){
        self.dailySurveyWellnessAverage = dailySurveyWellnessAverage;
        self.frame = frame;
        //self.layer.borderColor = [UIColor redColor].CGColor;
        //self.layer.borderWidth = 3.0f;
        
        CGRect emotionalDotsViewFrame = CGRectMake(0, 0, frame.size.width, frame.size.height/4);
        DotsView* emotionalDotsView = [[DotsView alloc] initWithFrame:emotionalDotsViewFrame Title:@"Emotional"];
        float emotionalValueFloat = [[self.dailySurveyWellnessAverage emotionalAverage] floatValue];
        [emotionalDotsView changeNumDots:emotionalValueFloat];
        [self addSubview:emotionalDotsView];
        
        CGRect socialDotsViewFrame = CGRectMake(0, frame.size.height/4, frame.size.width, frame.size.height/4);
        DotsView* socialDotsView = [[DotsView alloc] initWithFrame:socialDotsViewFrame Title:@"Social"];
        float socialValueFloat = [[self.dailySurveyWellnessAverage socialAverage] floatValue];
        [socialDotsView changeNumDots:socialValueFloat];
        [self addSubview:socialDotsView];
        
        CGRect academicDotsViewFrame = CGRectMake(0, 2*(frame.size.height/4), frame.size.width, frame.size.height/4);
        DotsView* academicDotsView = [[DotsView alloc] initWithFrame:academicDotsViewFrame Title:@"Academic"];
        float academicValueFloat = [[self.dailySurveyWellnessAverage academicAverage] floatValue];
        [academicDotsView changeNumDots:academicValueFloat];
        [self addSubview:academicDotsView];
        
        CGRect physicalDotsViewFrame = CGRectMake(0, 3*(frame.size.height/4), frame.size.width, frame.size.height/4);
        DotsView* physicalDotsView = [[DotsView alloc] initWithFrame:physicalDotsViewFrame Title:@"Physical"];
        float physicalValueFloat = [[self.dailySurveyWellnessAverage physicalAverage] floatValue];
        [physicalDotsView changeNumDots:physicalValueFloat];
        [self addSubview:physicalDotsView];
    }
    return self;
}

-(void) viewWillAppear: (BOOL) animated {
    
}

@end