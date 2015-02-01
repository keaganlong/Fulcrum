//
//  YAxisView.h
//  Fulcrum
//
//  Created by Keagan Long on 1/22/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

@interface YAxisView : UIView

@property CGFloat headerPadding;
@property CGFloat startValue;
@property CGFloat endValue;

-(id)initWithFrame:(CGRect)frame AndHeaderPadding:(CGFloat)headerPadding StartValue:(NSInteger)startValue EndValue:(NSInteger)endValue;

@end
