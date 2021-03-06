//
//  DateView.m
//  Fulcrum
//
//  Created by Keagan Long on 2/3/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LowerCarouselDateView.h"

@implementation LowerCarouselDateView

-(id)initWithDate:(NSDate*)date AndTotalStress:(NSInteger)totalStress AndNumEvents:(NSInteger)numEvents{
    self = [self initWithFrame:CGRectMake(0,0,100,260)];
    if(self){
        self.totalStress = totalStress;
        self.date = date;
        self.numEvents = numEvents;
        [self initViews];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
    }
    return self;
}

-(void)initViews{
    
    int barHeight = [StressStrategy getBarHeigthFromNumberOfEvents:self.numEvents];
    UIView* barView = [[UIView alloc] initWithFrame:CGRectMake(0,0,70,barHeight)];
    
    UIColor* color = [StressStrategy getBarColorFromTotalStress:self.totalStress];
    
    barView.backgroundColor = color;
    barView.alpha = 0.8;
    
    UIView* circleView = [[UIView alloc] initWithFrame:CGRectMake(100,100,80,80)];
    circleView.layer.cornerRadius = 40;
    circleView.alpha = 1;
    circleView.backgroundColor = color;
    self.circleView = circleView;
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, circleView.frame.size.width, circleView.frame.size.height-12)];
    [label setTextColor:[UIColor whiteColor]];
    label.textAlignment = NSTextAlignmentCenter;
    [label setFont:[UIFont fontWithName: @"Trebuchet MS" size: 9.0f]];

    UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 6, circleView.frame.size.width, circleView.frame.size.height)];
    [label2 setTextColor:[UIColor whiteColor]];
    label2.textAlignment = NSTextAlignmentCenter;
    [label2 setFont:[UIFont fontWithName: @"Trebuchet MS" size: 9.0f]];
    
    CGPoint circleCenter = CGPointMake(self.center.x,self.center.y+65);
    circleView.center = circleCenter;
    
    int barCenterY = 130-(barHeight/2);
    CGPoint barCenter = CGPointMake(self.center.x,barCenterY);
    barView.center = barCenter;
    self.barView = barView;
    
    NSDate* date = self.date;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateStyle:NSDateFormatterFullStyle];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    
    NSString *dateAsString = [formatter stringFromDate:date];
    int i;
    for(i = 0; i<dateAsString.length;i++){
        if([dateAsString characterAtIndex:i] == ','){
            break;
        }
    }
    
    NSString* dayName = [dateAsString substringToIndex:i];
    NSString* rest = [dateAsString substringFromIndex:i+2];
    rest = [@"" stringByAppendingString:[rest substringToIndex:rest.length-6]];
    [label setText:dayName];
    [label2 setText:rest];
    [circleView addSubview:label];
    [circleView addSubview:label2];
    [self addSubview:barView];
    [self addSubview:circleView];
}

-(void)setNeedsRating{
    CGFloat borderWidth = 2.0f;
    
    self.barView.frame = CGRectInset(self.barView.frame, -borderWidth, -borderWidth);
    self.barView.layer.borderColor = [UIColor yellowColor].CGColor;
    self.barView.layer.borderWidth = borderWidth;
    
    self.circleView.frame = CGRectInset(self.circleView.frame, -borderWidth, -borderWidth);
    self.circleView.layer.borderColor = [UIColor yellowColor].CGColor;
    self.circleView.layer.borderWidth = borderWidth;
}

@end