//
//  WellnessAreaViewFactory.h
//  Fulcrum
//
//  Created by Keagan Long on 1/19/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import "WellnessAreaViewController.h"

@interface WellnessAreaViewFactory : NSObject

+(WellnessAreaViewController*)wellnessAreaViewControllerForWellnessArea:(WELLNESS_AREA)area;

@end
