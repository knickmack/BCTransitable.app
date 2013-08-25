//
//  UIImage+BCTransitable.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-26.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "UIImage+BCTransitable.h"

@implementation UIImage (BCTransitable)

+ (UIImage *)imageWithColor:(UIColor *)color {
    CGRect rect = (CGRect){ CGPointZero, CGSizeMake(1.f, 1.f) };
    UIGraphicsBeginImageContextWithOptions(rect.size, YES, 0.f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
