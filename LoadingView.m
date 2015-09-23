//
//  LoadingView.m
//  Fulcrum
//
//  Created by Keagan Long on 9/22/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LoadingView.h"

@implementation LoadingView

-(id)init{
    self = [super init];
    
    if(self) {
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        self.frame = screenRect;
        self.backgroundColor = [UIColor whiteColor];
    }
    
    return self;
}

@end