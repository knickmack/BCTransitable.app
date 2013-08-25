//
//  UIFont+BCTransitable.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-28.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "UIFont+BCTransitable.h"

@implementation UIFont (BCTransitable)

+ (UIFont *)boldLatoFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-Bold" size:size];
}

+ (UIFont *)fontAwesomeFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"FontAwesome" size:size];
}

+ (UIFont *)latoFontOfSize:(CGFloat)size {
    return [UIFont fontWithName:@"Lato-Regular" size:size];
}

@end
