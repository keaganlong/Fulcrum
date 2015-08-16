//
//  DailySurveyQuestion.h
//  Fulcrum
//
//  Created by Keagan Long on 12/27/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import <Parse/Parse.h>

@interface DailySurveyQuestion: NSObject

@property NSString* questionString;
@property NSMutableArray* responses;

@property PFObject* pfDailySurveyQuestion;

@end
