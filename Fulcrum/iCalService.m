//
//  iCalService.m
//  Fulcrum
//
//  Created by Keagan Long on 2/1/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "iCalService.h"
#import <EventKit/EventKit.h>

@implementation iCalService

+(EKEventStore*)currentStore{
    iCalService* service = [self instance];
    return service.store;
}

+ (iCalService*) instance{
    static iCalService* instance = nil;
    @synchronized(self){
        if(instance == nil){
            instance = [[self alloc] init];
            instance.store = [[EKEventStore alloc] init];
        }
        return instance;
    }
}

@end