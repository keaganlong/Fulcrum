//
//  MainViewController.m
//  Fulcrum
//
//  Created by Keagan Long on 11/9/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import "MainViewController.h"
#import "Carousel.h"
#import "iCarousel.h"
#import "JBBarChartView.h"
#import "LowerCarouselDataSourceAndDelegate.h"

@interface MainViewController ()<JBBarChartViewDelegate, JBBarChartViewDataSource, iCarouselDataSource, iCarouselDelegate, UIActionSheetDelegate> {
    //Carousel* circleCarousel;
}
@property (nonatomic, assign) BOOL wrap;
@property (nonatomic, strong) UINavigationItem *navItem;
@property (nonatomic, strong) iCarousel *carousel;

@property (nonatomic, strong) iCarousel *lowerCarousel;
@property (nonatomic, strong) NSMutableArray *items;
@property (weak) id<iCarouselDataSource> lowerCarouselDataSource;
@property (weak) id<iCarouselDelegate> lowerCarouselDelegate;
@property (nonatomic) NSMutableArray *dates;

@end

CGFloat const CAROUSEL_X = 0;
CGFloat const CAROUSEL_Y = 0;
CGFloat const CAROUSEL_HEIGHT = 200;

@implementation MainViewController
@synthesize dates;
@synthesize carousel;
@synthesize lowerCarousel;
@synthesize navItem;
@synthesize wrap;
@synthesize items;
@synthesize lowerCarouselDataSource;
@synthesize lowerCarouselDelegate;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.items = [NSMutableArray array];
    for (int i = 0; i < 4; i++)
    {
        [items addObject:[NSNumber numberWithInt:i]];
    }
    
    dates = [[NSMutableArray alloc] init];
    NSTimeInterval secondsPerDay = 24 * 60 * 60;
    
    for(int i = -50; i< 50;i++){
        NSDate* day = [[NSDate alloc] initWithTimeIntervalSinceNow:secondsPerDay*i];
        [dates addObject:day];
    }
    
    carousel = [[iCarousel alloc] initWithFrame:CGRectMake(CAROUSEL_X,CAROUSEL_Y,self.view.frame.size.width,CAROUSEL_HEIGHT)];
    carousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    carousel.type = iCarouselTypeLinear;
    carousel.delegate = self;
    carousel.dataSource = self;
    
    [self.view addSubview:carousel];

    
    lowerCarousel = [[iCarousel alloc] initWithFrame:CGRectMake(0,250,self.view.frame.size.width,400)];
    lowerCarousel.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    lowerCarousel.type = iCarouselTypeLinear;

    lowerCarousel.dataSource = self;
    lowerCarousel.delegate = self;

    [self.view addSubview:lowerCarousel];
    
    [self.view bringSubviewToFront:self.backButton];
    
//    JBBarChartView* barChartView = [[JBBarChartView alloc] init];
//    barChartView.dataSource = self;
//    barChartView.delegate = self;
//    barChartView.frame = CGRectMake(0,350,self.view.frame.size.width,140);
//    [barChartView reloadData];
//    [self.view addSubview:barChartView];
    
}



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark iCarousel methods

- (NSInteger)numberOfItemsInCarousel:(iCarousel *)carousel
{
    if(carousel == lowerCarousel){
        return [dates count];
    }
    return [items count];
}

- (UIView *)carousel:(iCarousel *)carousel viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UILabel *label = nil;
 
    if(carousel == lowerCarousel){
        
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
    else
    {
        
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
    return CATransform3DTranslate(transform, 0.0f, 0.0f, offset * carousel.itemWidth);
}

- (CGFloat)carousel:(iCarousel *)_carousel valueForOption:(iCarouselOption)option withDefault:(CGFloat)value
{
    //customize carousel display
    switch (option)
    {
        case iCarouselOptionWrap:
        {
            //normally you would hard-code this to YES or NO
            return wrap;
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
