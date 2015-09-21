//
//  DotsView.m
//  Fulcrum
//
//  Created by Keagan Long on 9/1/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "DotsView.h"
#import <FlatUIKit/FlatUIKit.h>

@implementation DotsView

-(id)initWithFrame:(CGRect)frame Title:(NSString*)title{
    self = [super initWithFrame:frame];
    if(self){
        //self.layer.borderColor = [UIColor greenColor].CGColor;
        //self.layer.borderWidth = 1.0f;
        self.labelWidth = 70;
        self.title = title;
        [self initLabel];
        self.maxNumDots = 5;
        self.numDots = 2.5;
        [self initDots];
    }
    return self;
}

-(void)initLabel{
    CGRect labelFrame = CGRectMake(0, 0, self.labelWidth, self.frame.size.height);
    self.label = [[UILabel alloc] initWithFrame:labelFrame];
    self.label.text = self.title;
    UIFont* font = [UIFont flatFontOfSize:19];
    self.label.font = font;
    self.label.adjustsFontSizeToFitWidth = YES;
    [self.label sizeToFit];
    //self.label.layer.borderColor = [UIColor orangeColor].CGColor;
    //self.label.layer.borderWidth = 1.0f;
    [self addSubview:self.label];
}

-(void)initDots{
    self.dotViews = [NSMutableArray new];
    for(int i = 0; i<self.maxNumDots;i++){
        float height = self.frame.size.height-10;
        float width = height;
        float x = (i*width+i*10)+self.labelWidth+30;
        float y = 5;
        UIView* dotView = [[UIView alloc] initWithFrame:CGRectMake(x,y,width,height)];
        dotView.layer.cornerRadius = width/2;
        dotView.backgroundColor = [UIColor blueColor];
        [self addSubview:dotView];
        [self.dotViews addObject:dotView];
    }
}

-(void)changeMaxNumDots:(int)maxNumDots{
    self.maxNumDots = maxNumDots;
    [self initDots];
    [self setNumDots:self.numDots];
}

-(void)changeNumDots:(float)numDots{
    int numFilledIn = floor(numDots);
    float remainder = numDots-numFilledIn;
    
    int i;
    for(i = 0; i<numFilledIn;i++){
        UIView* dotView = [self.dotViews objectAtIndex:i];
        dotView.backgroundColor = [UIColor blueColor];
    }
    
    if(i<[self.dotViews count]){
        UIView* dotView = [self.dotViews objectAtIndex:i];
        dotView.alpha = (0.3)+0.7*remainder;
        i++;
    }
    for(;i<[self.dotViews count];i++){
        UIView* dotView = [self.dotViews objectAtIndex:i];
        dotView.alpha = 0.2;
    }
}


@end