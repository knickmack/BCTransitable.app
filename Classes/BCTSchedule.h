//
//  BCTSchedule.h
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-24.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BCTRegion, BCTRoute;

@interface BCTSchedule : NSObject

@property (copy, nonatomic, readonly) NSString *day;
@property (copy, nonatomic, readonly) NSString *direction;
@property (strong, nonatomic, readonly) NSArray *times;
@property (copy, nonatomic, readonly) NSString *title;
@property (strong, nonatomic, readonly) NSArray *waypoints;

+ (void)schedulesWithRegion:(BCTRegion *)region route:(BCTRoute *)route block:(void (^)(NSArray *schedules, NSError *error))block;
- (id)initWithAttributes:(NSDictionary *)attributes;

@end
