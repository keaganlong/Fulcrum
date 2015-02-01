//
//  AlertFactory.m
//  Fulcrum
//
//  Created by Keagan Long on 1/31/15.
//  Copyright (c) 2015 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AlertFactory.h"

@implementation AlertFactory

+(UIAlertController*)alertWithMessage:(NSString*)message{
    UIAlertController* confirmationAlertController = [UIAlertController alertControllerWithTitle:@"Error" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* noAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
    }];
    [confirmationAlertController addAction: noAction];
    return confirmationAlertController;
}

@end