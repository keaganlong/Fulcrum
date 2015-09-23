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

+(void)getUserPermissionWithCompletionHandler:(void(^)(UPSession*))completionFunction{
    [[UPPlatform sharedPlatform] startSessionWithClientID:clientID clientSecret:appSecret authScope:UPPlatformAuthScopeAll completion:^(UPSession *session, NSError *error) {
        completionFunction(session);
    }];
}

+(void)getSleepsWithCompletionHandler:(void(^)(NSArray*))completionFunction{
    [UPSleepAPI getSleepsWithLimit:1000 completion:^(NSArray *sleeps, UPURLResponse *response, NSError *error) {
        completionFunction(sleeps);
    }];
}

+(void)getEventsWithCompletionHandler:(void(^)(NSArray*))completionFunction{
    [UPMoveAPI getMovesWithLimit:10000 completion:^(NSArray *results, UPURLResponse *response, NSError *error) {
        completionFunction(results);
    }];
}

@end