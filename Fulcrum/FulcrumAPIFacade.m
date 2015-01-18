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
#import "DateRangeService.h"

@implementation FulcrumAPIFacade

-(void)getDailySurveyResponsesForUser:(int) userId withCallback:(void(^)(NSMutableArray *dailySurveyResponses))callbackFunction{
//    [FulcrumAPIService getDailySurveyResponsesForUser:userId withCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSError* serializeError = nil;
//        NSArray* jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializeError];
//        if(jsonArray){
//            NSMutableArray* dailySurveyResponses = [NSMutableArray new];
//            for(NSDictionary* dailySurveyResponseDictionary in jsonArray){
//                DailySurveyResponse* dailySurveyResponse = [self dictionaryToDailySurveyResponse:dailySurveyResponseDictionary];
//                [dailySurveyResponses addObject:dailySurveyResponse];
//            }
//            callbackFunction(dailySurveyResponses);
//        }
//        else{
//            callbackFunction(nil);
//        }
//    }];
    NSMutableArray* arr = [NSMutableArray new];
    NSMutableArray* dates = [DateRangeService getSevenDaysPriorStartingWithDate:[NSDate date]];
    for(int i = 0; i<7;i++){
        if(i==4 || i==5){
            continue;
        }
        DailySurveyResponse* curr = [[DailySurveyResponse alloc] init];
        NSDate* date = [dates objectAtIndex:i];
        [curr setForDate:date];
        NSMutableArray* qrs = [NSMutableArray new];
        for(int i = 0; i<10;i++){
            DailySurveyQuestionResponse* res = [[DailySurveyQuestionResponse alloc] init];
            [res setValue:(1+rand()%5)];
            [qrs addObject:res];
        }
        [curr setDailySurveyQuestionResponses:qrs];
        [arr addObject:curr];
    }
    callbackFunction(arr);
}

-(void)submitForUser:(int)userId dailySurveyResponse:(DailySurveyResponse*)response withCallback:(void(^)(NSError*))callbackFunction{
    NSError* serializeError = nil;
    NSDictionary* responseDictionary = [self dailySurveyResponseToDictionary:response];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:responseDictionary options:NSJSONWritingPrettyPrinted error:&serializeError];
    [FulcrumAPIService postForUser:userId dailySurveyResponseDate:jsonData withCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        callbackFunction(error);
    }];
    
}

-(void)loginWithUsername:(NSString*)username andWithPassword:(NSString*)password withCallback:(void(^)(NSString*))callbackFunction{
    [FulcrumAPIService loginWithUsername:username andWithPassword:password withCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            callbackFunction(nil);
        }
        else{
            NSError* deserializeError = nil;
            NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&deserializeError];
            callbackFunction(jsonDictionary[@"access_token"]);
        }
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

+(void)loginWithUsername:(NSString*)username andWithPassword:(NSString*)password withCallback:(void(^)(NSString*))callbackFunction{
    [[self instance] loginWithUsername:username andWithPassword:password withCallback:callbackFunction];
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