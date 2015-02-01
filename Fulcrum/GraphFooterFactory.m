//
//  GraphFooterFactory.m
//  Fulcrum
//
//  Created by Keagan Long on 1/18/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GraphFooterFactory.h"
#import "JBLineChartFooterView.h"

@implementation GraphFooterFactory

+(JBLineChartFooterView*)footerViewWithFrame:(CGRect)frame numberOfTicks:(NSInteger)count firstLabel:(NSString*)firstLabel lastLabel:(NSString*)lastLabel{
    JBLineChartFooterView *footerView = [[JBLineChartFooterView alloc] initWithFrame:frame];
    footerView.backgroundColor = [UIColor clearColor];
    
    footerView.leftLabel.text = firstLabel;
    footerView.leftLabel.textColor = [UIColor whiteColor];
    footerView.rightLabel.text = lastLabel;
    footerView.rightLabel.textColor = [UIColor whiteColor];
    footerView.sectionCount = count;
    return footerView;
}

@end