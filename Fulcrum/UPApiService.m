//
//  UPApiService.m
//  Fulcrum
//
//  Created by Keagan Long on 3/7/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UPApiService.h"
#import <UPPlatformSDK/UPPlatformSDK.h>

NSString *const clientID = @"dfnfThc1q80";
NSString *const appSecret = @"040527806cacbd1b00bc748ffb710dd2272092f1";

@implementation UPApiService

+(void)getUserPermission{
    [[UPPlatform sharedPlatform] startSessionWithClientID:clientID clientSecret:appSecret authScope:UPPlatformAuthScopeAll completion:^(UPSession *session, NSError *error) {
        if(session!=nil){
            NSLog(@"Jawbone user: %@",session.currentUser);
        }else{
            NSLog(@"session nil");
        }
    }];
}

+(void)getSleepsWithCompletionHandler:(void(^)(NSArray*))completionFunction{
    [UPSleepAPI getSleepsWithLimit:100 completion:^(NSArray *sleeps, UPURLResponse *response, NSError *error) {
        completionFunction(sleeps);
    }];
}



@end