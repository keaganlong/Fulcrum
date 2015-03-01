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
#import "DateService.h"
#import "CalenderEvent.h"

@implementation FulcrumAPIFacade

-(void)getDailySurveyResponsesWithCallback:(void(^)(NSMutableArray *dailySurveyResponses))callbackFunction{
//    [FulcrumAPIService getDailySurveyResponsesWithCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSError* serializeError = nil;
//        NSObject* serializedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializeError];
//        if([self validateGetDailySurveyResponses:serializedObject]){
//            NSArray* jsonArray = (NSArray*)serializedObject;
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
    NSMutableArray* dates = [DateService getDateRangeStartingWithDate:[NSDate date] withInteger:74];
    for(int i = 0; i<[dates count];i++){
        if(i<0){
            continue;
        }
        DailySurveyResponse* curr = [[DailySurveyResponse alloc] init];
        NSDate* date = [dates objectAtIndex:i];
        [curr setForDate:date];
        NSMutableArray* qrs = [NSMutableArray new];
        int value = 3;
        if(i<=[dates count]-20){
            value = 2;
            value+=rand()%2;
        }
        else if(i>[dates count]-20 && i<[dates count]-10){
            value = 3;
            value+=rand()%2;
        }
        else{
            value = 4;
            value+=rand()%2;
        }
        for(int j = 0; j<10;j++){
            DailySurveyQuestionResponse* res = [[DailySurveyQuestionResponse alloc] init];
            [res setValue:value+1-(rand()%2)];
            [qrs addObject:res];
        }
        [curr setDailySurveyQuestionResponses:qrs];
        [arr addObject:curr];
    }
    callbackFunction(arr);
}

-(BOOL)validateGetDailySurveyResponses:(NSObject*)object{
    if([object isKindOfClass:[NSDictionary class]]){
        return NO;
    }
    return YES;
}

-(BOOL)validateGetDailySurveyResponse:(NSObject*)object{
    if([object isKindOfClass:[NSDictionary class]]){
        return YES;
    }
    return NO;
}

-(void)submitDailySurveyResponse:(DailySurveyResponse*)response withCallback:(void(^)(NSError*))callbackFunction{
    NSError* serializeError = nil;
    NSDictionary* responseDictionary = [self dailySurveyResponseToDictionary:response];
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:responseDictionary options:NSJSONWritingPrettyPrinted error:&serializeError];
    [FulcrumAPIService postDailySurveyResponseDate:jsonData withCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        callbackFunction(error);
    }];
    
}

-(void)loginWithUsername:(NSString*)username andWithPassword:(NSString*)password withCallback:(void(^)(NSString* token, NSString* errorMessage))callbackFunction{
    [FulcrumAPIService loginWithUsername:username andWithPassword:password withCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            NSString* errorMsg = @"Network issue.";
            callbackFunction(nil,errorMsg);
        }
        else{
            NSError* deserializeError = nil;
            NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&deserializeError];
            callbackFunction(jsonDictionary[@"access_token"],jsonDictionary[@"error_description"]);
        }
    }];
}

-(void)registerAccountWithUsername:(NSString*)username andPassword:(NSString*)password withCallback:(void(^)(NSString*))callbackFunction{
    [FulcrumAPIService registerAccountWithUsername:username andPassword:password withCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
        NSError* deserializeError = nil;
        NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&deserializeError];
        if(jsonDictionary[@"ModelState"]!=nil){
            NSDictionary* modelStateDictionary = jsonDictionary[@"ModelState"];
            NSString* errorMessage = modelStateDictionary[@""];
            callbackFunction(errorMessage);
        }
        else{
            callbackFunction(nil);
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
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    [dateFormatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
    return [dateFormatter stringFromDate:date];
}

-(DailySurveyResponse*)dictionaryToDailySurveyResponse:(NSDictionary*)dictionary{
    DailySurveyResponse* dailySurveyResponse = [[DailySurveyResponse alloc] init];
    NSDate* submissionDate = dictionary[@"SubmissionTime"];
    if(submissionDate != nil){
        [dailySurveyResponse setSubmissionDate:submissionDate];
    }
    NSString* forDateString = [dictionary[@"ForDate"]substringToIndex:10];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    NSDate* forDate = [formatter dateFromString:forDateString];
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

-(void)lastDateDailySurveyCompletedForWithCallback:(void(^)(NSDate* lastDate))callbackFunction{
        [FulcrumAPIService lastDailySurveyResponse:^(NSData *data, NSURLResponse *response, NSError *error) {
            if(error){
                callbackFunction(nil);
            }
            else{
                NSError* serializeError;
                NSObject* serializedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializeError];
                if([self validateGetDailySurveyResponse:serializedObject]){
                    NSDictionary* dict = (NSDictionary*)serializedObject;
                    DailySurveyResponse* lastResponse = [self dictionaryToDailySurveyResponse:dict];
                    callbackFunction(lastResponse.forDate);
                }
                else{
                    callbackFunction(nil);
                }
            }
        }];
}

-(void)updateCalenderEvent:(CalenderEvent*)calenderEvent withCompletionHandler:(void(^)(NSError*))completionFunction{
    NSError* serializeError = nil;
    NSMutableDictionary* serializedCalenderEvent = [self calenderEventToDictionary:calenderEvent];
    bool valid = [NSJSONSerialization isValidJSONObject:serializedCalenderEvent];
    if(valid){
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:serializedCalenderEvent options:NSJSONWritingPrettyPrinted error:&serializeError];
        [FulcrumAPIService updateCalenderEvent:jsonData withCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            completionFunction(error);
        }];
    }
    else{
        
    }
}

+(void)updateCalenderEvent:(CalenderEvent*)calenderEvent withCompletionHandler:(void(^)(NSError*))completionFunction{
    [[self instance] updateCalenderEvent:calenderEvent withCompletionHandler:completionFunction];
}

-(NSMutableDictionary*)calenderEventToDictionary:(CalenderEvent*) event{
    NSMutableDictionary* dict = [NSMutableDictionary new];
    dict[@"EventIdentifier"]=event.EventIdentifier;
    dict[@"StressLevel"]=[NSNumber numberWithInteger:event.StressLevel];
    dict[@"Rated"]=event.Rated ? @"true" : @"false";
    dict[@"Ignored"]=event.Ignored ? @"true" : @"false";
    dict[@"StartDate"]= [self dateJSONTransformer:event.StartDate];
    dict[@"EndDate"] = [self dateJSONTransformer:event.EndDate];
    dict[@"Title"] = event.Title;
    return dict;
}

-(NSMutableArray*)calenderEventsToJSONAbleArray:(NSArray*)calenderEvents{
    NSMutableArray* output = [NSMutableArray new];
    
    for(int i = 0;i<[calenderEvents count];i++){
        CalenderEvent* currEvent = [calenderEvents objectAtIndex:i];
        NSMutableDictionary* eventDict = [self calenderEventToDictionary:currEvent];
        [output addObject:eventDict];
    }
    
    return output;
}

-(void)addCalenderEvents:(NSArray*)calenderEvents withCompletionHandler:(void(^)(NSError*))completionFunction{
    NSError* serializeError = nil;
    NSArray* serializedCalenderEvents = [self calenderEventsToJSONAbleArray:calenderEvents];
    bool valid = [NSJSONSerialization isValidJSONObject:serializedCalenderEvents];
    if(valid){
        NSData* jsonData = [NSJSONSerialization dataWithJSONObject:serializedCalenderEvents options:NSJSONWritingPrettyPrinted error:&serializeError];
        [FulcrumAPIService postCalenderEvents:jsonData withCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
            NSLog(@"Response: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
            completionFunction(error);
        }];
    }
    else{
        
    }
}

-(void)getCalenderEventsWithStartDate:(NSDate*)startDate AndEndDate:(NSDate*)endDate withCompletionHandler:(void(^)(NSArray*))completionFunction{
    [FulcrumAPIService getCalenderEventsWithStartDate:startDate AndEndDate:endDate withCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        if(error){
            completionFunction(nil);
        }
        else{
            NSError* serializeError;
            NSObject* serializedObject = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&serializeError];
            if([serializedObject isKindOfClass:[NSArray class]]){
                NSArray* arr = (NSArray*)serializedObject;
                NSMutableArray* calenderArr = [self jsonToCalenderEventArray:arr];
//                for(int i = 0; i<[calenderArr count];i++){
//                    CalenderEvent* e = [calenderArr objectAtIndex:i];
//                    NSLog(@"%@ %@    %@ %@",e.Title,e.StartDate, e.EndDate, e.EventIdentifier);
//                }
                completionFunction(calenderArr);
            }
            else{
                completionFunction(nil);
            }
        }
    }];
}

-(NSMutableArray*)jsonToCalenderEventArray:(NSArray*)eventDicts{
    NSMutableArray* output = [NSMutableArray new];
    for(int i = 0; i<[eventDicts count];i++){
        NSDictionary* currDict = [eventDicts objectAtIndex:i];
        CalenderEvent* currCalenderEvent = [self dictionaryToCalenderEvent:currDict];
        [output addObject:currCalenderEvent];
    }
    return output;
}

-(CalenderEvent*)dictionaryToCalenderEvent:(NSDictionary*)dict{
    CalenderEvent* output = [[CalenderEvent alloc] init];
    output.EventIdentifier = dict[@"EventIdentifier"];
    output.StressLevel = [dict[@"StressLevel"] integerValue];
    NSNumber* ratedNumber = dict[@"Rated"];
    output.Rated = [ratedNumber integerValue] == 1 ? YES:NO;
    NSNumber* ignoredNumber = dict[@"Ignored"];
    output.Ignored = [ignoredNumber integerValue] == 1 ? YES:NO;
    
    output.Title = dict[@"Title"];
    NSString* startDateString = [dict[@"StartDate"]substringToIndex:19];
    NSString* endDateString = [dict[@"EndDate"] substringToIndex:19];
    NSDateFormatter* formatter = [[NSDateFormatter alloc] init];
    [formatter setTimeZone:[NSTimeZone timeZoneWithAbbreviation:@"EST"]];
    [formatter setDateFormat:@"YYYY-MM-dd'T'HH:mm:ss"];
    NSDate* startDate = [formatter dateFromString:startDateString];
    output.StartDate = startDate;
    NSDate* endDate = [formatter dateFromString:endDateString];
    output.EndDate = endDate;
    return output;
}

-(DailySurveyQuestionResponse*)dictionaryToDailySurveyQuestionResponse:(NSDictionary*)dictionary{
    DailySurveyQuestionResponse* dailySurveyQuestionResponse = [[DailySurveyQuestionResponse alloc]init];
    NSInteger value = [dictionary[@"Value"] intValue];
    NSString* title = dictionary[@"Title"];
    [dailySurveyQuestionResponse setValue:value];
    [dailySurveyQuestionResponse setTitle:title];
    return dailySurveyQuestionResponse;
}

+(void)getDailySurveyResponsesWithCallback:(void(^)(NSMutableArray *dailySurveyResponses))callbackFunction{
    [[self instance] getDailySurveyResponsesWithCallback:callbackFunction];
}

+(void)submitDailySurveyResponse:(DailySurveyResponse*)response withCallback:(void(^)(NSError*))callbackFunction{
    [[self instance] submitDailySurveyResponse:response withCallback:callbackFunction];
}

+(void)loginWithUsername:(NSString*)username andWithPassword:(NSString*)password withCallback:(void(^)(NSString* token, NSString* errorMessage))callbackFunction{
    [[self instance] loginWithUsername:username andWithPassword:password withCallback:callbackFunction];
}

+(void)lastDateDailySurveyCompletedForWithCallback:(void(^)(NSDate* lastDate))callbackFunction{
    [[self instance] lastDateDailySurveyCompletedForWithCallback:(void(^)(NSDate* lastDate))callbackFunction];
}

+(void)registerAccountWithUsername:(NSString*)username andPassword:(NSString*)password withCallback:(void(^)(NSString*))callbackFunction{
    [[self instance] registerAccountWithUsername:username andPassword:password withCallback:callbackFunction];
}

+(void)addCalenderEvents:(NSArray*)calenderEvents withCompletionHandler:(void(^)(NSError*))completionFunction{
    [[self instance] addCalenderEvents:calenderEvents withCompletionHandler:completionFunction];
}

+(void)getCalenderEventsWithStartDate:(NSDate*)startDate AndEndDate:(NSDate*)endDate withCompletionHandler:(void(^)(NSArray*))completionFunction{
    [[self instance] getCalenderEventsWithStartDate:startDate AndEndDate:endDate withCompletionHandler:completionFunction];
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