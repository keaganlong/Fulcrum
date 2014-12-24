//
//  LowerCarouselDataSourceAndDelegate.m
//  Fulcrum
//
//  Created by Keagan Long on 11/14/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iCarousel.h"
#import "LowerCarouselDataSourceAndDelegate.h"
#import "JBBarChartView.h"


@implementation LowerCarouselDataSourceAndDelegate{
    NSMutableArray *dates;
}


- (id)init {
    self = [super init];
    if (self) {
        [self initDates];
    }
    return self;
}

-(void) initDates{
    dates = [[NSMutableArray alloc] init];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;

    for(int i = -50; i< 50;i++){
        NSDate* day = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay*i];
        [dates addObject:day];
    }
}

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [dates count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    if(carousel !=nil){
        
        view = [[UIView alloc] initWithFrame:CGRectMake(0,0,100,260)];
        
        int barHeight = 20+arc4random()%110;
        UIView* barView = [[UIView alloc] initWithFrame:CGRectMake(0,0,70,barHeight)];
        float red = 0.0;
        float green = 1.0-((2.0*barHeight)/255.0);
        float blue = 0.6;
        float lowerBound = 0.2;
        float upperBound = 0.6;
        green = (upperBound-lowerBound)*green+lowerBound;
        blue = green*2;
        barView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.8];
        barView.alpha = 0.8;
        
        UIView* circleView = [[UIView alloc] initWithFrame:CGRectMake(100,100,80,80)];
        circleView.layer.cornerRadius = 40;
        circleView.alpha = 1;
        circleView.backgroundColor = [UIColor colorWithRed:red green:green blue:blue alpha:0.8];
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(26, 16, 60, 30)];
        [label setTextColor:[UIColor whiteColor]];
        [label setFont:[UIFont fontWithName: @"Trebuchet MS" size: 9.0f]];
        
        UILabel* label2 = [[UILabel alloc] initWithFrame:CGRectMake(20, 31, 60, 30)];
        [label2 setTextColor:[UIColor whiteColor]];
        [label2 setFont:[UIFont fontWithName: @"Trebuchet MS" size: 9.0f]];
        
        CGPoint circleCenter = CGPointMake(view.center.x,view.center.y+65);
        circleView.center = circleCenter;
        
        int barCenterY = 130-(barHeight/2);
        CGPoint barCenter = CGPointMake(view.center.x,barCenterY);
        barView.center = barCenter;
        
        NSDate* date = [dates objectAtIndex:((index+50)%100)];
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        [formatter setDateStyle:NSDateFormatterFullStyle];
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
        [view addSubview:barView];
        [view addSubview:circleView];
        return view;
    }
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0,0,120,120)];
        view.layer.cornerRadius = 60;
        view.alpha = 0.7;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 120, 120)];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
    }
    switch(index){
        case 1:
            [label setText: @"Physical"];
            view.backgroundColor = [UIColor colorWithRed:0.1 green:0.04 blue:0.9 alpha:0.8];
            break;
        case 2:
            [label setText: @"Emotional"];
            view.backgroundColor = [UIColor colorWithRed:0.0 green:0.4 blue:0.3 alpha:0.8];
            break;
        case 3:
            [label setText: @"Social"];
            view.backgroundColor = [UIColor colorWithRed:0.0 green:0.7 blue:0.8 alpha:0.8];
            break;
        default:
            [label setText: @"Academic"];
            view.backgroundColor = [UIColor colorWithRed:0.0 green:0.6 blue:0.9 alpha:0.8];
    }
    //set label
    [view addSubview:label];
    return view;
}

- (UIView *)carousel:(iCarousel *)carousel placeholderViewAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"page.png"]];
        label = [[UILabel alloc] initWithFrame:view.bounds];
        label.backgroundColor = [UIColor clearColor];
        label.textAlignment = UITextAlignmentCenter;
        label.font = [label.font fontWithSize:50.0f];
        [view addSubview:label];
    }
    else
    {
        label = [[view subviews] lastObject];
    }
    
    //set label
    label.text = (index == 0)? @"[": @"]";
    
    return view;
}

- (CATransform3D)carousel:(iCarousel *)_carousel itemTransformForOffset:(CGFloat)offset baseTransform:(CATransform3D)transform
{
    //implement 'flip3D' style carousel
    transform = CATransform3DRotate(transform, M_PI / 8.0f, 0.0f, 1.0f, 0.0f);
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * _carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return YES;
        }
        case iCarouselOptionSpacing:
        {
            //add a bit of spacing between the item views
            return value * 1.05f;
        }
        case iCarouselOptionFadeMax:
        {
            if (carousel.type == iCarouselTypeCustom)
            {
                //set opacity based on distance from camera
                return 0.0f;
            }
            return value;
        }
        default:
        {
            return 1.3*value;
        }
    }
}


- (NSUInteger)numberOfBarsInBarChartView:(JBBarChartView *)barChartView{
    return 5;
}


- (CGFloat)barChartView:(JBBarChartView *)barChartView heightForBarViewAtIndex:(NSUInteger)index{
    int randomInt = 1+(index % 2);
    NSLog(@"%i",randomInt);
    return index+1;
}

- (UIView *)barChartView:(JBBarChartView *)barChartView barViewAtIndex:(NSUInteger)index
{
    UIView* view = [[UIView alloc] init];
    view.alpha = 0.5;
    view.backgroundColor = [UIColor blueColor];
    return view;
}




@end