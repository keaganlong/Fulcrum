//
//  StressStrategy.h
//  Fulcrum
//
//  Created by Keagan Long on 2/3/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

@interface StressStrategy : NSObject

-(CGFloat)getBarHeigthFromTotalStress:(NSInteger)totalStress;
-(UIColor*)getBarColorFromTotalStress:(NSInteger)totalStress;

@end
