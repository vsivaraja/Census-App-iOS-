//
//  censusCaller.h
//  Census App
//
//  Created by Vikram Sivaraja on 6/22/15.
//  Copyright (c) 2015 Vikram Sivaraja. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface censusCaller : NSObject

@property (nonatomic, strong, readwrite) NSString *baseURL;
@property (nonatomic, strong, readwrite) NSString *cityLevel;
@property (nonatomic, strong, readwrite) NSString *countyLevel;
@property (nonatomic, strong, readwrite) NSString *city;
@property (nonatomic, strong, readwrite) NSString *state;
@property (nonatomic, strong, readwrite) NSString *searchType;
@property (nonatomic, strong, readwrite) NSString *key;
@property (nonatomic, strong, readwrite) NSString *response;
@property (nonatomic, readwrite) BOOL hasCompletedResponse;

-(censusCaller*) initWithParams: (NSString*)city state: (NSString*)state searchType: (NSString*)searchType;
- (void) APICall;

@end
