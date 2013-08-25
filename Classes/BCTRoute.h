//
//  BCTRoute.h
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-24.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BCTRegion;

@interface BCTRoute : NSObject <NSCoding, NSSecureCoding>

@property (strong, nonatomic, readonly) NSNumber *number;
@property (copy, nonatomic, readonly) NSString *title;

+ (void)routesWithRegion:(BCTRegion *)region block:(void (^)(NSArray *routes, NSError *error))block;
- (id)initWithAttributes:(NSDictionary *)attributes;

@end
