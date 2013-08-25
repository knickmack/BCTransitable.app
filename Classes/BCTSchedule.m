//
//  BCTSchedule.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-24.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTRegion.h"
#import "BCTRoute.h"
#import "BCTSchedule.h"
#import "BCTYahooQueryLanguageAPIClient.h"

@implementation BCTSchedule

@synthesize day = _day;
@synthesize direction = _direction;
@synthesize times = _times;
@synthesize title = _title;
@synthesize waypoints = _waypoints;

#pragma mark - BCTSchedule

+ (void)schedulesWithRegion:(BCTRegion *)region route:(BCTRoute *)route block:(void (^)(NSArray *schedules, NSError *error))block {
    NSParameterAssert(region);
    NSParameterAssert(route);
    NSParameterAssert(block);
    
    NSDictionary *parameters = @{ @"q": [NSString stringWithFormat:@"select * from knickmack.bctransitable.schedules where region=\"%@\" and route=\"%@\"", region.abbreviation, route.number] };
    
    [[BCTYahooQueryLanguageAPIClient sharedClient] getPath:nil parameters:parameters success:^(AFHTTPRequestOperation *operation, id JSON) {
        NSMutableArray *mutableSchedules = [@[] mutableCopy];
        for (NSDictionary *attributes in [JSON valueForKeyPath:@"query.results.result.schedules"]) {
            BCTSchedule *schedule = [[BCTSchedule alloc] initWithAttributes:attributes];
            
            [mutableSchedules addObject:schedule];
        }
        
        block([mutableSchedules copy], nil);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        block(nil, error);
    }];
}

- (id)initWithAttributes:(NSDictionary *)attributes {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _day = [attributes valueForKeyPath:@"day"];
    _direction = [attributes valueForKeyPath:@"direction"];
    _times = [attributes valueForKeyPath:@"times"];
    _title = [attributes valueForKeyPath:@"title"];
    _waypoints = [attributes valueForKeyPath:@"waypoints"];
    
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
    
    _day = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"day"];
    _direction = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"direction"];
    _times = [aDecoder decodeObjectOfClass:[NSArray class] forKey:@"times"];
    _title = [aDecoder decodeObjectOfClass:[NSString class] forKey:@"title"];
    _waypoints = [aDecoder decodeObjectOfClass:[NSArray class] forKey:@"waypoints"];
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:self.day forKey:@"day"];
    [aCoder encodeObject:self.direction forKey:@"direction"];
    [aCoder encodeObject:self.times forKey:@"times"];
    [aCoder encodeObject:self.title forKey:@"title"];
    [aCoder encodeObject:self.waypoints forKey:@"waypoints"];
}

#pragma mark - NSObject

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@: %p, title: %@>", [self class], self, self.title];
}

@end
