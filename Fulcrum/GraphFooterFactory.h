//
//  GraphFooterFactory.h
//  Fulcrum
//
//  Created by Keagan Long on 1/18/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import "JBLineChartFooterView.h"

@interface GraphFooterFactory : NSObject

+(JBLineChartFooterView*)footerViewWithFrame:(CGRect)frame numberOfTicks:(NSInteger)count firstLabel:(NSString*)firstLabel lastLabel:(NSString*)lastLabel;

@end
