//
//  FulcrumAPIFacade.m
//  Fulcrum
//
//  Created by Keagan Long on 12/30/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FulcrumAPIFacade.h"
#import "FulcrumAPIService.h"
#import "DailySurveyResponse.h"
#import "DailySurveyQuestionResponse.h"

@implementation FulcrumAPIFacade

-(void)getDailySurveyResponsesForUser:(int) userId withCallback:(void(^)(NSArray *dailySurveyResponses))callbackFunction{
    [FulcrumAPIService getDailySurveyResponsesForUser:userId withCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError* serializeError = nil;
        NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializeError];
        if(jsonArray){
            NSMutableArray* dailySurveyResponses = [NSMutableArray new];
            for(NSDictionary* dailySurveyResponseDictionary in jsonArray){
                DailySurveyResponse* dailySurveyResponse = [self dictionaryToDailySurveyResponse:dailySurveyResponseDictionary];
                [dailySurveyResponses addObject:dailySurveyResponse];
            }
            callbackFunction(dailySurveyResponses);
        }
        else{
            callbackFunction(nil);
        }
    }];
}

-(void)submitForUser:(int)userId dailySurveyResponse:(DailySurveyResponse*)response withCallback:(void(^)(NSError*))callbackFunction{
    NSError* serializeError = nil;
    NSDictionary* responseDictionary = [self dailySurveyResponseToDictionary:response];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:responseDictionary options:NSJSONWritingPrettyPrinted error:&serializeError];
    [FulcrumAPIService postForUser:userId dailySurveyResponseDate:jsonData withCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        callbackFunction(error);
    }];
    
}

-(NSDictionary*)dailySurveyResponseToDictionary:(DailySurveyResponse*)response{
    NSMutableDictionary* dictionary = [NSMutableDictionary new];
    [dictionary setValue:[self dateJSONTransformer:[response forDate]] forKey:@"ForDate"];
    [dictionary setValue:[self dateJSONTransformer:[response submissionDate]] forKey:@"SubmissionTime"];
    NSMutableArray* responses = [NSMutableArray new];
    NSArray* dailySurveyQuestionResponses = [response dailySurveyQuestionResponses];
    for(DailySurveyQuestionResponse* questionResponse in dailySurveyQuestionResponses){
        NSDictionary* questionResponseDictionary = [self dailySurveyQuestionResponseToDictionary:questionResponse];
        [responses addObject:questionResponseDictionary];
    }
    [dictionary setValue:responses forKey:@"Responses"];
    return dictionary;
}

-(NSDictionary*)dailySurveyQuestionResponseToDictionary:(DailySurveyQuestionResponse*)questionResponse{
    NSMutableDictionary* dictionary = [NSMutableDictionary new];
    [dictionary setValue:[NSNumber numberWithInteger:[questionResponse value]] forKey:@"Value"];
    [dictionary setValue:[questionResponse title] forKey:@"Title"];
    return dictionary;
}

- (NSString*)dateJSONTransformer:(NSDate*)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ssZZZ"];
    return [dateFormatter stringFromDate:date];
}

-(DailySurveyResponse*)dictionaryToDailySurveyResponse:(NSDictionary*)dictionary{
    DailySurveyResponse* dailySurveyResponse = [[DailySurveyResponse alloc] init];
    NSDate* submissionDate = dictionary[@"SubmissionTime"];
    if(submissionDate != nil){
        [dailySurveyResponse setSubmissionDate:submissionDate];
    }
    NSDate* forDate = dictionary[@"ForDate"];
    if(submissionDate != nil){
        [dailySurveyResponse setForDate:forDate];
    }
    NSArray* responses = dictionary[@"Responses"];
    NSMutableArray* dailySurveyQuestionResponses = [NSMutableArray new];
    if(responses != nil){
        for(NSDictionary* dailySurveyQuestionResponseDictionary in responses){
            DailySurveyQuestionResponse* dailySurveyQuestionResponse = [self dictionaryToDailySurveyQuestionResponse:dailySurveyQuestionResponseDictionary];
            [dailySurveyQuestionResponses addObject:dailySurveyQuestionResponse];
        }
        [dailySurveyResponse setDailySurveyQuestionResponses:dailySurveyQuestionResponses];
    }
    return dailySurveyResponse;
}

-(DailySurveyQuestionResponse*)dictionaryToDailySurveyQuestionResponse:(NSDictionary*)dictionary{
    DailySurveyQuestionResponse* dailySurveyQuestionResponse = [[DailySurveyQuestionResponse alloc]init];
    NSInteger value = [dictionary[@"Value"] intValue];
    NSString* title = dictionary[@"Title"];
    [dailySurveyQuestionResponse setValue:value];
    [dailySurveyQuestionResponse setTitle:title];
    return dailySurveyQuestionResponse;
}

+(void)getDailySurveyResponsesForUser:(int) userId withCallback:(void(^)(NSArray *dailySurveyResponses))callbackFunction{
    [[self instance] getDailySurveyResponsesForUser:userId withCallback:callbackFunction];
}

+(void)submitForUser:(int)userId dailySurveyResponse:(DailySurveyResponse*)response withCallback:(void(^)(NSError*))callbackFunction{
    [[self instance] submitForUser:userId dailySurveyResponse:response withCallback:callbackFunction];
}


+ (FulcrumAPIFacade*) instance{
    static FulcrumAPIFacade* instance = nil;
    @synchronized(self){
        if(instance == nil){
            instance = [[self alloc] init];
        }
        return instance;
    }
}

@end