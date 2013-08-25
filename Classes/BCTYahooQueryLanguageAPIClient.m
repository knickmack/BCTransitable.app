//
//  BCTYahooQueryLanguageAPIClient.m
//  VIHA
//
//  Created by Nik Macintosh on 2013-05-14.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "AFJSONRequestOperation.h"
#import "BCTYahooQueryLanguageAPIClient.h"

static NSString * const kBCTYahooQueryLanguageAPIBaseURLString = @"http://query.yahooapis.com/v1/public/yql";

@implementation BCTYahooQueryLanguageAPIClient

#pragma mark - BCTYahooQueryLanguageAPIClient

+ (instancetype)sharedClient {
    static BCTYahooQueryLanguageAPIClient *_sharedClient = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        _sharedClient = [[BCTYahooQueryLanguageAPIClient alloc] initWithBaseURL:[NSURL URLWithString:kBCTYahooQueryLanguageAPIBaseURLString]];
    });
    
    return _sharedClient;
}

#pragma mark - AFHTTPClient

- (id)initWithBaseURL:(NSURL *)url {
    self = [super initWithBaseURL:url];
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    [self setDefaultHeader:@"Accept" value:@"application/json"];
    
    return self;
}

- (NSMutableURLRequest *)requestWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableDictionary *mutableParameters = [parameters mutableCopy];
    
    mutableParameters[@"compat"] = @"html5";
    mutableParameters[@"env"] = @"store://fGkQG4aHgZvyRyXoxDjtuy";
    mutableParameters[@"format"] = @"json";
    mutableParameters[@"jsonCompat"] = @"new";
    
    return [super requestWithMethod:method path:path parameters:[mutableParameters copy]];
}

@end
