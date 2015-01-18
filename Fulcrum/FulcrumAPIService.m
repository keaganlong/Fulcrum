//
//  FulcrumAPIService.m
//  Fulcrum
//
//  Created by Keagan Long on 12/30/14.
//  Copyright (c) 2014 Keagan Long. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FulcrumAPIService.h"

#define BASE_FULCRUM_API_URL @"http://fulcrumservice.azurewebsites.net/api"
#define BASE_FULCRUM_URL @"http://fulcrumservice.azurewebsites.net"
#define GET_DAILY_SURVEY_RESPONSES_FOR_USER_URL @"/Users/GetDailySurveyResponses"
#define POST_USER_DAILY_SURVEY_RESPONSE_URL @"/Users/AddUserDailySurveyResponse"
#define GET_TOKEN_URL @"/Token"

@implementation FulcrumAPIService

-(void)postForUser:(int) userId dailySurveyResponseDate:(NSData*)data withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%d",BASE_FULCRUM_API_URL,POST_USER_DAILY_SURVEY_RESPONSE_URL,userId]];
    NSURLRequest* request = [self _createPOSTRequestWithURL:url andData:data];
    NSURLSession* session = [NSURLSession sharedSession];
    [[session dataTaskWithRequest:request completionHandler:completionFunction] resume];
}


- (void) getDailySurveyResponsesForUser:(int)userId withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    NSURL* url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@/%d",BASE_FULCRUM_API_URL,GET_DAILY_SURVEY_RESPONSES_FOR_USER_URL,userId]];
    NSURLRequest* request = [self _createGETRequestWithURL:url];
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

+(void)postForUser:(int) userId dailySurveyResponseDate:(NSData*)data withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    [[self instance] postForUser:userId dailySurveyResponseDate:data withCompletionHandler:completionFunction];
}


+ (void) getDailySurveyResponsesForUser:(int)userId withCompletionHandler:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    [[self instance] getDailySurveyResponsesForUser:userId withCompletionHandler:completionFunction];
}

+(void)loginWithUsername:(NSString*)username andWithPassword:(NSString*)password withCallback:(void(^)(NSData *data, NSURLResponse *response, NSError *error))completionFunction{
    [[self instance] loginWithUsername:username andWithPassword:password withCallback:completionFunction];
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