//
//  BCTChevronButton.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-26.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTChevronButton.h"
#import "UIColor+BCTransitable.h"
#import "UIFont+BCTransitable.h"

@implementation BCTChevronButton

#pragma mark - NSObject

- (id)init {
    self = [[super class] buttonWithType:UIButtonTypeCustom];
    if (!self) {
        return nil;
    }
    
    self.titleLabel.font = [UIFont fontAwesomeFontOfSize:25.f];
    
    [self setTitle:@"\uf138" forState:UIControlStateNormal];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [self setTitleColor:[UIColor bctransitableBlueColor] forState:UIControlStateNormal];
    [self sizeToFit];
    
    return self;
}

@end
