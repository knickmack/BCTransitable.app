//
//  BCTRegion.h
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-24.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BCTRegion : NSObject <NSCoding, NSSecureCoding>

@property (copy, nonatomic, readonly) NSString *abbreviation;
@property (copy, nonatomic, readonly) NSString *title;

+ (void)regionsWithBlock:(void (^)(NSArray *regions, NSError *error))block;
- (id)initWithAttributes:(NSDictionary *)attributes;

@end
