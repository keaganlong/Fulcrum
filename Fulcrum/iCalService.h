//
//  iCalService.h
//  Fulcrum
//
//  Created by Keagan Long on 2/1/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <EventKit/EventKit.h>

@interface iCalService : NSObject

@property EKEventStore* store;

+(EKEventStore*)currentStore;

@end
