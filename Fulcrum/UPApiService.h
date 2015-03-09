//
//  UPApiService.h
//  Fulcrum
//
//  Created by Keagan Long on 3/7/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

@interface UPApiService : NSObject

+(void)getUserPermission;
+(void)getSleepsWithCompletionHandler:(void(^)(NSArray*))completionFunction;

@end
