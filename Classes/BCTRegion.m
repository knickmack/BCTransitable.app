//
//  BCTRegion.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-24.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTRegion.h"
#import "BCTYahooQueryLanguageAPIClient.h"

@implementation BCTRegion

@synthesize abbreviation = _abbreviation;
@synthesize title = _title;

#pragma mark - BCTRegion

+ (void)regionsWithBlock:(void (^)(NSArray *regions, NSError *error))block {
    NSParameterAssert(block);
    
    NSDictionary *parameters = @{ @"q": @"select * from knickmack.bctransitable.regions" };
    
    [[BCTYahooQueryLanguageAPIClient sharedClient] getPath:nil parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *regions = [@[] mutableCopy];
        for (NSDictionary *attributes in [JSON valueForKeyPath:@"query.results.result.regions"]) {
            BCTRegion *region = [[BCTRegion alloc] initWithAttributes:attributes];
            
            [regions addObject:region];
        }
        
        block([regions copy], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _abbreviation = [attributes valueForKeyPath:@"abbreviation"];
    _title = [attributes valueForKeyPath:@"title"];
    
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
    
    _abbreviation = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"abbreviation"];
    _title = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"title"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.abbreviation forKey:@"abbreviation"];
    [aCoder encodeObject:self.title forKey:@"title"];
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, abbreviation: %@, title: %@>", [self class], self, self.abbreviation, self.title];
}

@end
