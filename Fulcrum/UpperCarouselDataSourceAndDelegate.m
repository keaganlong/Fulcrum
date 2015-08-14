//
//  UpperCarouselDataSourceAndDelegate.m
//  Fulcrum
//
//  Created by Keagan Long on 12/23/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UpperCarouselDataSourceAndDelegate.h"
#import "MainViewController.h"
#import "WellnessAreaViewFactory.h"
#import "WellnessAreaViewController.h"
#import "FulcrumColors.h"

@implementation UpperCarouselDataSourceAndDelegate


- (id)initWithController:(MainViewController*)mainViewController {
    self = [super init];
    if (self) {
        [self initItems];
    }
    [self setParentViewController:mainViewController];
    return self;
}

-(void) initItems{
    self.items = [NSMutableArray array];
    for (int i = 0; i < 4; i++)
    {
        [self.items addObject:[NSNumber numberWithInt:i]];
    }
}


- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    return [self.items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
    
    //create new view if no view is available for recycling
    if (view == nil)
    {
        view = [[UIView alloc] initWithFrame:CGRectMake(0,0,120,120)];
        view.layer.cornerRadius = 60;
        view.alpha = 0.7;
        
        label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 120, 120)];
        [label setTextColor:[UIColor whiteColor]];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName: @"Trebuchet MS" size: 20.0f]];
        label.textAlignment = NSTextAlignmentCenter;
    }
    else
    {
        
    }
    switch(index){
        case 0:
            [label setText: @"Emotional"];
            [view setTag:0];
            view.backgroundColor = [FulcrumColors emotionalBaseColor];
            [self addGestureToView:view];
            break;
        case 1:
            [view setTag:1];
            [label setText: @"Social"];
            view.backgroundColor = [FulcrumColors socialBaseColor];
            [self addGestureToView:view];
            break;
        case 2:
            [label setText: @"Physical"];
            [view setTag:2];
            view.backgroundColor = [FulcrumColors physicalBaseColor];
            [self addGestureToView:view];
            break;
        default:
            [view setTag:3];
            [label setText: @"Academic"];
            view.backgroundColor = [FulcrumColors academicBaseColor];
            [self addGestureToView:view];
    }
    //set label
    [view addSubview:label];
    return view;
}

-(void)addGestureToView:(UIView*)view{
    UITapGestureRecognizer* tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(onTap:)];
    [view addGestureRecognizer:tapGestureRecognizer];
}

-(IBAction)onTap:(id)sender{
    UITapGestureRecognizer* tapGestureRecognizer = (UITapGestureRecognizer*)sender;
    NSInteger tag = tapGestureRecognizer.view.tag;
    WELLNESS_AREA area;
    switch(tag){
        case 0:
            area = EMOTIONAL;
            break;
        case 1:
            area = SOCIAL;
            break;
        case 2:
            area = PHYSICAL;
            break;
        default:
            area = ACADEMIC;
            break;
    }
    WellnessAreaViewController* controller;
    switch([tapGestureRecognizer state]){
        case UIGestureRecognizerStateEnded:
            controller = [WellnessAreaViewFactory wellnessAreaViewControllerForWellnessArea:area];
            [self.parentViewController changeToViewController:controller];
            break;
    }
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
            YES;
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


@end

