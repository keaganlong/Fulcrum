//
//  CircleCarousel.m
//  Fulcrum
//
//  Created by Keagan Long on 11/11/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import "Carousel.h"

@interface Carousel (){
    NSMutableArray* circles;
    UIView* centerView;
    UIView* beforeCenterView;
    UIView* afterCenterView;
}
@end

CGFloat currentX;
CGFloat currentY;

@implementation Carousel

- (id)initWithFrame:(CGRect)theFrame {
    self = [super initWithFrame:theFrame];
    if (self) {
        [self setup];
    }
    return self;
}

-(void) setup{
    
    circles = [NSMutableArray array];
    for(NSInteger i = 0; i < 5; i++)
    {
        UIView* circleView = [[UIView alloc] initWithFrame:CGRectMake(i*80-40,20,70,70)];
        circleView.layer.cornerRadius = 35;
        if(i==2){
            circleView = [[UIView alloc] initWithFrame:CGRectMake(i*100-40,20,110,110)];
            circleView.layer.cornerRadius = 55;
        }
        circleView.alpha = 0.5;
        circleView.backgroundColor = [UIColor blueColor];
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 300, 20)];
        [label setTextColor:[UIColor blackColor]];
        //[label setBackgroundColor:[UIColor clearColor]];
        [label setFont:[UIFont fontWithName: @"Trebuchet MS" size: 8.0f]];
        [label setText: @"Physical"];
        [circleView addSubview:label];
        
        [circles addObject:circleView];
        [self addSubview:circleView];
        if(i==1){
            beforeCenterView = circleView;
        }
        else if(i==2){
            centerView = circleView;
        }
        else if(i==3){
            afterCenterView = circleView;
        }
    }
    
    
    UIPanGestureRecognizer* panRecognizer = [[UIPanGestureRecognizer alloc]
                                                      initWithTarget:self action:@selector(onPan:)];
    [self addGestureRecognizer:panRecognizer];
}


-(void) onPan:(UIPanGestureRecognizer *)sender{
    switch(sender.state){
        case UIGestureRecognizerStateBegan:
            break;
        case UIGestureRecognizerStateChanged:
            [self onSwipe:sender];
            break;
        case UIGestureRecognizerStateEnded:
            [self onRelease:sender];
            break;
        case UIGestureRecognizerStateCancelled:
            break;
        case UIGestureRecognizerStatePossible:
            break;
        case UIGestureRecognizerStateFailed:
            break;
    }
}

-(void) onSwipe:(UIPanGestureRecognizer *) sender{
    CGFloat newX = [sender translationInView:self].x;
    CGFloat deltaX = newX-currentX;
    currentX = newX;
    for(UIView* view in circles){
        CGFloat x = view.center.x;
        CGFloat y = view.center.y;
        CGPoint point = CGPointMake(x+deltaX,y);

        [view setCenter:point];
        //TODO clean this garbage up
        if(deltaX>0){
            if(view==beforeCenterView){
                CGFloat width = view.frame.size.width;
                CGFloat height = view.frame.size.height;
                view.bounds = CGRectMake(view.center.x,view.center.y,width+deltaX*.6,height+deltaX*.6);
                view.layer.cornerRadius = (width+deltaX*.6)/2.0;
            }
            else if(view==centerView){
                CGFloat width = view.frame.size.width;
                CGFloat height = view.frame.size.height;
                view.bounds = CGRectMake(view.center.x,view.center.y,width-deltaX*.6,height-deltaX*.6);
                view.layer.cornerRadius = (width-deltaX*.6)/2.0;
            }
        }
        else{
            if(view==beforeCenterView){
                CGFloat width = view.frame.size.width;
                CGFloat height = view.frame.size.height;
                view.bounds = CGRectMake(view.center.x,view.center.y,width+deltaX*.6,height+deltaX*.6);
                view.layer.cornerRadius = (width+deltaX*.6)/2.0;
            }
            else if(view==centerView){
                CGFloat width = view.frame.size.width;
                CGFloat height = view.frame.size.height;
                view.bounds = CGRectMake(view.center.x,view.center.y,width-deltaX*.6,height-deltaX*.6);
                view.layer.cornerRadius = (width-deltaX*.6)/2.0;
            }
        }
    }
}

-(void) onRelease:(UIPanGestureRecognizer *) sender{
    CGFloat deltaX = 909090900; //todo fix
    CGFloat centerX = self.center.x;
    UIView* closestViewToCenter = nil;
    for(UIView* view in circles){
        CGFloat x = view.center.x;
        NSLog(@"%f %f\n",centerX, x);
        if(fabsf(x-centerX)<fabsf(deltaX)){
            deltaX = x-centerX;
            closestViewToCenter = view;
        }
    }
    centerView = closestViewToCenter;
    for(UIView* view in circles){
        CGFloat x = view.center.x;
        CGFloat y = view.center.y;
        CGPoint point = CGPointMake(x+deltaX,y);
        [view setCenter:point];
    }
    
}
@end
