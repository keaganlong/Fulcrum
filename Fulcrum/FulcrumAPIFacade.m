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
#import "DailySurveyQuestion.h"

#import <Parse/Parse.h>

@implementation FulcrumAPIFacade

-(void)getDailySurveyResponsesWithCallback:(void(^)(NSMutableArray*))callbackFunction{
    PFUser *user = [PFUser currentUser];
    PFQuery *query = [PFQuery queryWithClassName:@"DailySurveyResponse"];
    [query whereKey:@"user" equalTo:user];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error){
        NSMutableArray *dailySurveyResponses = [NSMutableArray new];
        for(PFObject* pfDailySurveyResponse in objects){
            DailySurveyResponse* newDailySurveyResponse = [DailySurveyResponse new];
            newDailySurveyResponse.forDate = pfDailySurveyResponse[@"date"];
            NSMutableArray* newDailySurveyQuestionResponses = [NSMutableArray new];
            
            PFQuery* questionResponseQuery = [PFQuery queryWithClassName:@"DailySurveyQuestionResponse"];
            [questionResponseQuery whereKey:@"dailySurveyResponse" equalTo:pfDailySurveyResponse];
            [questionResponseQuery includeKey:@"question"];
            NSArray* pfDailySurveyQuestionResponses = [questionResponseQuery findObjects]; //Not async
            for(PFObject* pfDailySurveyQuestionResponse in pfDailySurveyQuestionResponses){
                DailySurveyQuestionResponse* newQuestionResponse = [DailySurveyQuestionResponse new];
                newQuestionResponse.response = pfDailySurveyQuestionResponse[@"response"];
                newQuestionResponse.value = pfDailySurveyQuestionResponse[@"value"];
                DailySurveyQuestion* dailySurveyQuestion = [DailySurveyQuestion new];
                PFObject* pfDailySurveyQuestion = pfDailySurveyQuestionResponse[@"question"];
                dailySurveyQuestion.pfDailySurveyQuestion = pfDailySurveyQuestion;
                dailySurveyQuestion.questionString = pfDailySurveyQuestion[@"question"];
                dailySurveyQuestion.responses = pfDailySurveyQuestion[@"responses"];
                newQuestionResponse.question = dailySurveyQuestion;
                [newDailySurveyQuestionResponses addObject:newQuestionResponse];
            }
            newDailySurveyResponse.dailySurveyQuestionResponses = newDailySurveyQuestionResponses;
            [dailySurveyResponses addObject:newDailySurveyResponse];
        }
        callbackFunction(dailySurveyResponses);
    }];
    
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
    NSMutableArray* dailySurveyQuestionResponses = response.dailySurveyQuestionResponses;
    
    PFObject *dailySurveyResponse = [PFObject objectWithClassName:@"DailySurveyResponse"];
    for(int i = 0; i< [dailySurveyQuestionResponses count];i++){
        DailySurveyQuestionResponse* currQuestionResponse = [dailySurveyQuestionResponses objectAtIndex:i];
        PFObject* newQuestionResponse = [PFObject objectWithClassName:@"DailySurveyQuestionResponse"];
        newQuestionResponse[@"question"] = currQuestionResponse.question.pfDailySurveyQuestion;
        newQuestionResponse[@"response"] = currQuestionResponse.response;
        newQuestionResponse[@"value"] = currQuestionResponse.value;
        newQuestionResponse[@"dailySurveyResponse"] = dailySurveyResponse;
        [newQuestionResponse save];
    }
    
    dailySurveyResponse[@"date"] = response.forDate;
    dailySurveyResponse[@"user"] = [PFUser currentUser];
    
    [dailySurveyResponse saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (succeeded) {
            callbackFunction(nil);
        } else {
            callbackFunction(error);
        }
    }];
    
//    NSError* serializeError = nil;
//    NSDictionary* responseDictionary = [self dailySurveyResponseToDictionary:response];
//    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:responseDictionary options:NSJSONWritingPrettyPrinted error:&serializeError];
//    [FulcrumAPIService postDailySurveyResponseDate:jsonData withCompletionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//        callbackFunction(error);
//    }];
}

-(void)updateDailySurveyResponse:(DailySurveyResponse*)response withCallback:(void(^)(NSError*))callbackFunction{
    PFQuery *query = [PFQuery queryWithClassName:@"DailySurveyResponse"];
    [query whereKey:@"date" equalTo:response.forDate];
    [query getFirstObjectInBackgroundWithBlock:^(PFObject *dailySurveyResponse, NSError *error){
        if(dailySurveyResponse){
            NSArray* questionResponses = response.dailySurveyQuestionResponses;
            PFQuery* questionResponsesQuery = [PFQuery queryWithClassName:@"DailySurveyQuestionResponse"];
            [questionResponsesQuery whereKey:@"dailySurveyResponse" equalTo:dailySurveyResponse];
            [questionResponsesQuery findObjectsInBackgroundWithBlock:^(NSArray *PFquestionResponses, NSError *error){
                if(questionResponses){
                    NSMutableDictionary* questionResponsesMap = [NSMutableDictionary new];
                    for(DailySurveyQuestionResponse* questionResponse in questionResponses){
                        NSString* key = [questionResponse.question.pfDailySurveyQuestion objectId];
                        questionResponsesMap[key] = questionResponse;
                    }
                    for(PFObject* PFquestionResponse in PFquestionResponses){
                        DailySurveyQuestionResponse* currQuestionResponse = questionResponsesMap[[PFquestionResponse[@"question"] objectId]];
                        PFquestionResponse[@"response"] = currQuestionResponse.response;
                        PFquestionResponse[@"value"] = currQuestionResponse.value;
                        [PFquestionResponse save];
                    }
                    callbackFunction(nil);
                }
                else{
                    NSLog(@"Update error 2");
                }
            }];
        }
        else{
            NSLog(@"Update error");
        }
    }];
}

-(void)loginWithUsername:(NSString*)username andWithPassword:(NSString*)password withCallback:(void(^)(NSError* error))callbackFunction{
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error){
        callbackFunction(error);
    }];
    
//    [FulcrumAPIService loginWithUsername:username andWithPassword:password withCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
//        if(error){
//            NSString* errorMsg = @"Network issue.";
//            callbackFunction(nil,errorMsg);
//        }
//        else{
//            NSError* deserializeError = nil;
//            NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&deserializeError];
//            callbackFunction(jsonDictionary[@"access_token"],jsonDictionary[@"error_description"]);
//        }
//    }];
}

-(void)registerAccountWithUsername:(NSString*)username andPassword:(NSString*)password withCallback:(void(^)(NSError*))callbackFunction{
    
    PFUser *user = [PFUser user];
    user.username = username;
    user.password = password;
    user.email = username;
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error){
        callbackFunction(error);
    }];
    
//    [FulcrumAPIService registerAccountWithUsername:username andPassword:password withCallback:^(NSData *data, NSURLResponse *response, NSError *error) {
//        NSError* deserializeError = nil;
//        NSDictionary* jsonDictionary = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&deserializeError];
//        if(jsonDictionary[@"ModelState"]!=nil){
//            NSDictionary* modelStateDictionary = jsonDictionary[@"ModelState"];
//            NSString* errorMessage = modelStateDictionary[@""][1];
//            callbackFunction(errorMessage);
//        }
//        else{
//            callbackFunction(nil);
//        }
//    }];
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
    [dictionary setValue:[questionResponse response] forKey:@"Title"];
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
                NSString* dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
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
            NSLog(@"POST CalEvent Response: %@",[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
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
    NSNumber* value = [NSNumber numberWithInt:[dictionary[@"Value"] intValue]];
    NSString* title = dictionary[@"Title"];
    [dailySurveyQuestionResponse setValue:value];
    [dailySurveyQuestionResponse setResponse:title];
    return dailySurveyQuestionResponse;
}


+(void)getDailySurveyQuestions:(void(^)(NSArray*))callback{
    PFQuery *query = [PFQuery queryWithClassName:@"DailySurveyQuestion"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            NSMutableArray* dailySurveyQuestions = [NSMutableArray new];
            for (PFObject *object in objects) {
                DailySurveyQuestion* newQuestion = [DailySurveyQuestion new];
                newQuestion.questionString = object[@"question"];
                newQuestion.responses = object[@"responses"];
                newQuestion.pfDailySurveyQuestion = object;
                [dailySurveyQuestions addObject:newQuestion];
            }
            callback(dailySurveyQuestions);
        } else {
            callback(nil);
        }
    }];
}

+(void)getDailySurveyResponsesWithCallback:(void(^)(NSMutableArray *dailySurveyResponses))callbackFunction{
    [[self instance] getDailySurveyResponsesWithCallback:callbackFunction];
}

+(void)submitDailySurveyResponse:(DailySurveyResponse*)response withCallback:(void(^)(NSError*))callbackFunction{
    [[self instance] submitDailySurveyResponse:response withCallback:callbackFunction];
}

+(void)updateDailySurveyResponse:(DailySurveyResponse*)response withCallback:(void(^)(NSError*))callbackFunction{
    [[self instance] updateDailySurveyResponse:response withCallback:callbackFunction];
}

+(void)loginWithUsername:(NSString*)username andWithPassword:(NSString*)password withCallback:(void(^)(NSError*))callbackFunction{
    [[self instance] loginWithUsername:username andWithPassword:password withCallback:callbackFunction];
}

+(void)lastDateDailySurveyCompletedForWithCallback:(void(^)(NSDate* lastDate))callbackFunction{
    [[self instance] lastDateDailySurveyCompletedForWithCallback:(void(^)(NSDate* lastDate))callbackFunction];
}

+(void)registerAccountWithUsername:(NSString*)username andPassword:(NSString*)password withCallback:(void(^)(NSError*))callbackFunction{
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