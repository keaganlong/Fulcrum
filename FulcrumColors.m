//
//  FulcrumColors.m
//  Fulcrum
//
//  Created by Keagan Long on 3/26/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FulcrumColors.h"

@implementation FulcrumColors

+(UIColor*)academicBaseColor{
    return [UIColor colorWithRed:.467 green:.784 blue:.937 alpha:1.0];
}

+(UIColor*)emotionalBaseColor{
    return [UIColor colorWithRed:0.176 green:0.655 blue:0.886 alpha:1.0];
}

+(UIColor*)socialBaseColor{
    return [UIColor colorWithRed:0.031 green:0.533 blue:0.776 alpha:1.0];
}

+(UIColor*)physicalBaseColor{
    return [UIColor colorWithRed:0.008 green:0.392 blue:0.576 alpha:1.0];
}

+(UIColor*)overallBaseColor{
    return [UIColor colorWithRed:0.004 green:0.647 blue:.678 alpha:1.0];
}

+(UIColor*)dailySurveyButtonColor{
    return [UIColor colorWithRed:0.282 green:0.559 blue:.451 alpha:1.0];
}

@end