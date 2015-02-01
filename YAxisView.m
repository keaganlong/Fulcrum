//
//  YAxisView.m
//  Fulcrum
//
//  Created by Keagan Long on 1/22/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "YAxisView.h"

@implementation YAxisView

-(id)initWithFrame:(CGRect)frame AndHeaderPadding:(CGFloat)headerPadding StartValue:(NSInteger)startValue EndValue:(NSInteger)endValue{
    self = [super initWithFrame:frame];
    if(self){
        self.headerPadding = headerPadding;
        self.startValue = startValue;
        self.endValue = endValue;
        
        CGFloat startY = headerPadding+2;
        CGFloat height = frame.size.height-headerPadding;
        CGFloat width = frame.size.width;
        
        int numTicks = endValue-startValue+1;
        int i = 0;
        for(int v = endValue; v>=startValue;v--,i++){
            CGFloat tickX = 10;
            CGFloat tickY = startY+i*(1.8+(height/numTicks));
            CGFloat tickWidth = width-10;
            CGFloat tickHeight = 1;
            CGRect tickFrame = CGRectMake(tickX, tickY, tickWidth, tickHeight);
            [self addSubview:[self getTickWithFrame:tickFrame]];
            UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(3,tickY-5,10,10)];
            [label setText:[NSString stringWithFormat:@"%i",v]];
            [label setFont:[UIFont systemFontOfSize:9.0]];
            [label setTextColor:[UIColor whiteColor]];
            [self addSubview:label];
        }
        
        UIView* rightBorder = [[UIView alloc] initWithFrame:CGRectMake(width-.8, headerPadding, .8, height-headerPadding-15)];
        [rightBorder setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:rightBorder];
        
    }
    return self;
}

-(UIView*)getTickWithFrame:(CGRect)frame{
    UIView* tick = [[UIView alloc] initWithFrame:frame];
    [tick setBackgroundColor:[UIColor whiteColor]];
    return tick;
}

@end