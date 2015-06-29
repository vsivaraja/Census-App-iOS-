//
//  censusCaller.m
//  Census App
//
//  Created by Vikram Sivaraja on 6/22/15.
//  Copyright (c) 2015 Vikram Sivaraja. All rights reserved.
//

#import "censusCaller.h"
#import "ViewController.h"

@implementation censusCaller

- (censusCaller*) initWithParams: (NSString*)city state: (NSString*)state searchType: (NSString*)searchType
{
    self.city = city;
    self.state = state;
    self.searchType = searchType;
    self.baseURL = @"http://api.usatoday.com/open/census/pop?keypat=";
    self.key = @"&api_key=mprrq9m57kbywvqk3n4ppjuj";
    self.cityLevel = @"&keyname=placename&sumlevid=4,6";
    self.countyLevel = @"&keyname=placename&sumlevid=3";
    self.response = @"";
    return self;
}

- (NSURL*) constructURL: (BOOL) isCitySearch
{
    NSString* processedCity = [self processCity:self.city];
    if (isCitySearch) {
        NSString *stringURl = [[[self.baseURL stringByAppendingString:processedCity] stringByAppendingString:self.cityLevel] stringByAppendingString:self.key];
        return [NSURL URLWithString:stringURl];
    } else {
        NSString *stringURl = [[[self.baseURL stringByAppendingString:processedCity] stringByAppendingString:self.countyLevel] stringByAppendingString:self.key];
        return [NSURL URLWithString:stringURl];
    }
}

- (NSString*) processCity:(NSString*) city
{
    if ([[city componentsSeparatedByString:@" "] count] > 1)
    {
        NSArray* cityParts = [city componentsSeparatedByString:@" "];
        NSString* toRtn = cityParts[0];
        for (int i = 1; i < [cityParts count]; i++)
        {
            toRtn = [[toRtn stringByAppendingString:@"%20"] stringByAppendingString:cityParts[i]];
        }
        return toRtn;
    }
    else
    {
        return city;
    }
}

- (void) APICall
{
    self.hasCompletedResponse = NO;
    NSURL* url = [self constructURL:YES];
    NSURLRequest *query = [NSURLRequest requestWithURL:url];
    [NSURLConnection sendAsynchronousRequest:query
                                       queue:[NSOperationQueue mainQueue]
                           completionHandler:^(NSURLResponse *response,
                                               NSData *data, NSError *connectionError)
     {
         BOOL didGetNonEmptyData = NO;
         if (connectionError == nil && data.length > 0)
         {
             NSDictionary *JSONData = [NSJSONSerialization JSONObjectWithData:data
                                                                      options:0
                                                                        error:NULL];
             didGetNonEmptyData = YES;
             if ([JSONData[@"response"] count] == 0)
             {
                 self.response = @"Please check your inputs";
                 [self noResultsFound];
             }
             for (NSDictionary *item in JSONData[@"response"])
             {
                 if ([item[@"Placename"] isEqualToString:self.city] && [item[@"StatePostal"] isEqualToString:self.state])
                 {
                     self.response = item[self.searchType];
                     self.hasCompletedResponse = YES;
                     [self connectionDidFinishLoading];
                 }
             }
         }
         if (connectionError != nil)
         {
             [self connectionHadError];
         }
         if (didGetNonEmptyData == YES && [self.response isEqualToString:@""])
         {
             self.response = @"Could not find this city in this state";
             [self noSuchState];
         }
     }];
}

-(void) noSuchState
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLNoState" object:nil];
}

-(void) noResultsFound
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLReturnedNoResponse" object:nil];
}

-(void) connectionHadError
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLConnectionHadError" object:nil];
}

-(void) connectionDidFinishLoading
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSURLConnectionDidFinish" object:self.response];
}
@end
