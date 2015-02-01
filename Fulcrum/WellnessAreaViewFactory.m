//
//  WellnessAreaViewFactory.m
//  Fulcrum
//
//  Created by Keagan Long on 1/19/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WellnessAreaViewFactory.h"
#import "WellnessAreaViewController.h"

@implementation WellnessAreaViewFactory

+(WellnessAreaViewController*)wellnessAreaViewControllerForWellnessArea:(WELLNESS_AREA)area{
    WellnessAreaViewController* controller;
    switch(area){
        case EMOTIONAL:
            controller = [[WellnessAreaViewController alloc] initWithWellnessArea:EMOTIONAL];
            [controller setGraphBackgroundColor:[UIColor colorWithRed:0.0 green:0.4 blue:0.3 alpha:0.65]];
            break;
        case ACADEMIC:
            controller = [[WellnessAreaViewController alloc] initWithWellnessArea:ACADEMIC];
            [controller setGraphBackgroundColor:[UIColor colorWithRed:0.0 green:0.6 blue:0.9 alpha:0.65]];
            break;
        case SOCIAL:
            controller = [[WellnessAreaViewController alloc] initWithWellnessArea:SOCIAL];
            [controller setGraphBackgroundColor:[UIColor colorWithRed:0.0 green:0.7 blue:0.8 alpha:0.65]];
            break;
        case PHYSICAL:
        default:
            controller = [[WellnessAreaViewController alloc] initWithWellnessArea:PHYSICAL];
            [controller setGraphBackgroundColor:[UIColor colorWithRed:0.1 green:0.04 blue:0.9 alpha:0.65]];
            break;
    }
    return controller;
}

@end