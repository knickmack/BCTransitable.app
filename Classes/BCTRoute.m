//
//  BCTRoute.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-24.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTRegion.h"
#import "BCTRoute.h"
#import "BCTYahooQueryLanguageAPIClient.h"

@implementation BCTRoute

@synthesize number = _number;
@synthesize title = _title;

#pragma mark - BCTRoute

+ (void)routesWithRegion:(BCTRegion *)region block:(void (^)(NSArray *routes, NSError *error))block {
    NSParameterAssert(region);
    NSParameterAssert(block);
    
    NSDictionary *parameters = @{ @"q": [NSString stringWithFormat:@"select * from knickmack.bctransitable.routes where region=\"%@\"", region.abbreviation] };
    
    [[BCTYahooQueryLanguageAPIClient sharedClient] getPath:nil parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *routes = [@[] mutableCopy];
        for (NSDictionary *attributes in [JSON valueForKeyPath:@"query.results.result.routes"]) {
            BCTRoute *route = [[BCTRoute alloc] initWithAttributes:attributes];
            
            [routes addObject:route];
        }
        
        block([routes copy], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _number = [attributes valueForKeyPath:@"number"];
    _title = [[attributes valueForKeyPath:@"title"] capitalizedString];
    
    return self;
}

#pragma mark - NSSecureCoding

+ (BOOL)supportsSecureCoding {
    return YES;
}

#pragma mark - NSCoding

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _number = [aDecoder decodeObjectOfClass:[NSNumber class] forKey:@"number"];
    _title = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"title"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.number forKey:@"number"];
    [aCoder encodeObject:self.title forKey:@"title"];
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, number: %@, title: %@>", [self class], self, self.number, self.title];
}

@end
