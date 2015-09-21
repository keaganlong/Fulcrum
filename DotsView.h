//
//  DotsView.h
//  Fulcrum
//
//  Created by Keagan Long on 9/1/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

@interface DotsView : UIView

@property int maxNumDots;
@property float numDots;
@property NSMutableArray* dotViews;
@property UILabel* label;
@property float labelWidth;
@property NSString* title;

-(void)changeMaxNumDots:(int)maxNumDots;
-(void)changeNumDots:(float)numDots;
-(id)initWithFrame:(CGRect)frame Title:(NSString*)title;

@end