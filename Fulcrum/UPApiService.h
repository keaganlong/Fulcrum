//
//  UPApiService.h
//  Fulcrum
//
//  Created by Keagan Long on 3/7/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//
#import <UPPlatformSDK/UPPlatformSDK.h>


@interface UPApiService : NSObject

+(void)getUserPermissionWithCompletionHandler:(void(^)(UPSession*))completionFunction;
+(void)getSleepsWithCompletionHandler:(void(^)(NSArray*))completionFunction;
+(void)getEventsWithCompletionHandler:(void(^)(NSArray*))completionFunction;

@end
