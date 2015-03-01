//
//  FulcrumAPIService.m
//  Fulcrum
//
//  Created by Keagan Long on 12/30/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FulcrumAPIService.h"
#import "DateService.h"

#define BASE_FULCRUM_API_URL @"http://fulcrumservice.azurewebsites.net/api"
#define BASE_FULCRUM_URL @"http://fulcrumservice.azurewebsites.net"
#define GET_DAILY_SURVEY_RESPONSES_FOR_USER_URL @"/Users/GetDailySurveyResponses"
#define POST_USER_DAILY_SURVEY_RESPONSE_URL @"/Users/AddUserDailySurveyResponse"
#define REGISTER_USER_URL @"/Account/Register"
#define GET_TOKEN_URL @"/Token"
#define LAST_DAILY_SURVEY_RESPONSE_URL @"/Users/LastDailySurveyResponse"
#define ADD_CALENDER_EVENTS_URL @"/Users/AddCalenderEvents"
#define UPDATE_CALENDER_EVENTS_URL @"/Users/UpdateCalenderEvent"
#define GET_CALENDER_EVENTS_IN_RANGE_URL @"/Users/GetCalenderEventsInRange"

@implementation FulcrumAPIService

-(void)postDailySurveyResponseDate:(NSData*)data withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults objectForKey:@"access_token"];
    if(token == nil){
        return; //TODO
    }
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/",BASE_FULCRUM_API_URL,POST_USER_DAILY_SURVEY_RESPONSE_URL]];
    NSMutableURLRequest* request = [self _createPOSTRequestWithURL:url andData:data];
    NSString* authorizationHeader = [NSString stringWithFormat:@"Bearer %@",token];
    [request setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
    NSURLSession* session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:completionFunction] resume];
}


- (void) getDailySurveyResponsesWithCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults objectForKey:@"access_token"];
    if(token == nil){
        return; //TODO
    }
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/",BASE_FULCRUM_API_URL,GET_DAILY_SURVEY_RESPONSES_FOR_USER_URL]];
    NSMutableURLRequest* request = [self _createGETRequestWithURL:url];
    NSString* authorizationHeader = [NSString stringWithFormat:@"Bearer %@",token];
    [request setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
    NSURLSession* session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:completionFunction] resume];
}

-(void)loginWithUsername:(NSString*)username andWithPassword:(NSString*)password withCallback:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_FULCRUM_URL,GET_TOKEN_URL]];
    NSString* messageBody = [NSString stringWithFormat:@"grant_type=password&username=%@&password=%@",username,password];
    NSData* bodyData = [messageBody dataUsingEncoding:NSUTF8StringEncoding];
    NSMutableURLRequest* request = [self _createPOSTRequestWithURL:url andData:bodyData];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    NSURLSession* session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:completionFunction] resume];
}

-(void)registerAccountWithUsername:(NSString*)username andPassword:(NSString*)password withCallback:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/",BASE_FULCRUM_API_URL,REGISTER_USER_URL]];
    NSError* serializeError;
    NSMutableDictionary* dict = [NSMutableDictionary new];
    dict[@"Email"] = username;
    dict[@"Password"] = password;
    dict[@"ConfirmPassword"] = password;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:dict options:NSJSONWritingPrettyPrinted error:&serializeError];
    NSMutableURLRequest* request = [self _createPOSTRequestWithURL:url andData:jsonData];
    NSURLSession* session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:completionFunction] resume];
}

-(void)lastDailySurveyResponse:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults objectForKey:@"access_token"];
    if(token == nil){
        return; //TODO
    }
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/",BASE_FULCRUM_API_URL,LAST_DAILY_SURVEY_RESPONSE_URL]];
    NSMutableURLRequest* request = [self _createGETRequestWithURL:url];
    NSString* authorizationHeader = [NSString stringWithFormat:@"Bearer %@",token];
    [request setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
    NSURLSession* session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:completionFunction] resume];
}

-(void)postCalenderEvents:(NSData*)data withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults objectForKey:@"access_token"];
    if(token == nil){
        return; //TODO
    }
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/",BASE_FULCRUM_API_URL,ADD_CALENDER_EVENTS_URL]];
    NSMutableURLRequest* request = [self _createPOSTRequestWithURL:url andData:data];
    NSString* authorizationHeader = [NSString stringWithFormat:@"Bearer %@",token];
    [request setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
    NSURLSession* session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:completionFunction] resume];
}

-(void)updateCalenderEvent:(NSData*)data withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults objectForKey:@"access_token"];
    if(token == nil){
        return; //TODO
    }
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/",BASE_FULCRUM_API_URL,UPDATE_CALENDER_EVENTS_URL]];
    NSMutableURLRequest* request = [self _createPOSTRequestWithURL:url andData:data];
    NSString* authorizationHeader = [NSString stringWithFormat:@"Bearer %@",token];
    [request setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
    NSURLSession* session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:completionFunction] resume];
}

-(void)getCalenderEventsWithStartDate:(NSDate*)startDate AndEndDate:(NSDate*)endDate withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* token = [defaults objectForKey:@"access_token"];
    if(token == nil){
        return; //TODO
    }
    NSString* startDateString = [DateService dateJSONTransformer:startDate];
    NSString* endDateString = [DateService dateJSONTransformer:endDate];
    
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@?startDate=%@&endDate=%@",BASE_FULCRUM_API_URL,GET_CALENDER_EVENTS_IN_RANGE_URL,startDateString,endDateString]];
    NSMutableURLRequest* request = [self _createGETRequestWithURL:url];
    NSString* authorizationHeader = [NSString stringWithFormat:@"Bearer %@",token];
    [request setValue:authorizationHeader forHTTPHeaderField:@"Authorization"];
    NSURLSession* session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:completionFunction] resume];
}

- (NSMutableURLRequest *) _createGETRequestWithURL: (NSURL *)url{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"GET"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    return request;
}

- (NSMutableURLRequest *) _createPOSTRequestWithURL: (NSURL *)url andData:(NSData*)data{
    NSMutableURLRequest* request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPMethod:@"POST"];
    [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:data];
    return request;
}

+(void)postDailySurveyResponseDate:(NSData*)data withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    [[self instance] postDailySurveyResponseDate:data withCompletionHandler:completionFunction];
}


+ (void) getDailySurveyResponsesWithCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    [[self instance] getDailySurveyResponsesWithCompletionHandler:completionFunction];
}

+(void)loginWithUsername:(NSString*)username andWithPassword:(NSString*)password withCallback:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    [[self instance] loginWithUsername:username andWithPassword:password withCallback:completionFunction];
}

+(void)registerAccountWithUsername:(NSString*)username andPassword:(NSString*)password withCallback:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    [[self instance] registerAccountWithUsername:username andPassword:password withCallback:completionFunction];
}

+(void)lastDailySurveyResponse:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    [[self instance] lastDailySurveyResponse:completionFunction];
}

+(void)postCalenderEvents:(NSData*)data withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    [[self instance] postCalenderEvents:data withCompletionHandler:completionFunction];
}

+(void)updateCalenderEvent:(NSData*)data withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    [[self instance] updateCalenderEvent:data withCompletionHandler:completionFunction];
}

+(void)getCalenderEventsWithStartDate:(NSDate*)startDate AndEndDate:(NSDate*)endDate withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    [[self instance] getCalenderEventsWithStartDate:startDate AndEndDate:endDate withCompletionHandler:completionFunction];
}

+ (FulcrumAPIService*) instance{
    static FulcrumAPIService* instance = nil;
    @synchronized(self){
        if(instance == nil){
            instance = [[self alloc] init];
        }
        return instance;
    }
}

@end