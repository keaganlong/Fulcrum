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
#import "PhysicalWellnessAreaView.h"
#import "FulcrumColors.h"

@implementation WellnessAreaViewFactory

+(WellnessAreaViewController*)wellnessAreaViewControllerForWellnessArea:(WELLNESS_AREA)area{
    WellnessAreaViewController* controller;
    switch(area){
        case EMOTIONAL:
            controller = [[WellnessAreaViewController alloc] initWithWellnessArea:EMOTIONAL];
            [controller setGraphBackgroundColor:[FulcrumColors emotionalBaseColor]];
            break;
        case ACADEMIC:
            controller = [[WellnessAreaViewController alloc] initWithWellnessArea:ACADEMIC];
            [controller setGraphBackgroundColor:[FulcrumColors academicBaseColor]];
            break;
        case SOCIAL:
            controller = [[WellnessAreaViewController alloc] initWithWellnessArea:SOCIAL];
            [controller setGraphBackgroundColor:[FulcrumColors socialBaseColor]];
            break;
        case PHYSICAL:
            controller = [[PhysicalWellnessAreaView alloc] init];
            [controller setGraphBackgroundColor:[FulcrumColors physicalBaseColor]];
            break;
        case OVERALL:
        default:
            controller = [[WellnessAreaViewController alloc] initWithWellnessArea:OVERALL];
            [controller setGraphBackgroundColor:[FulcrumColors overallBaseColor]];
            break;
    }
    return controller;
}

@end