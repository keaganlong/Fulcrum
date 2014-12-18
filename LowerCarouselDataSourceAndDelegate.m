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

@interface LowerCarouselDataSourceAndDelegate()

@property (nonatomic) NSMutableArray *dates;

@end

@implementation LowerCarouselDataSourceAndDelegate

@synthesize dates;

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
    return (NSInteger)100;
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0,0,120,120)];
        view.layer.cornerRadius = 60;
        view.alpha = 0.4;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(25, 0, 120, 120)];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
    }
    else
    {
        
    }
    NSDate* thisDate = [dates objectAtIndex:index];
    NSLog(@"%@",thisDate.description);
    [label setText: thisDate.description];
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

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
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
            if (_carousel.type == iCarouselTypeCustom)
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



@end