//
//  BCTTableViewSectionHeaderView.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-28.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTTableViewSectionHeaderView.h"
#import "UIColor+BCTransitable.h"
#import "UIFont+BCTransitable.h"

@implementation BCTTableViewSectionHeaderView

@synthesize label = _label;

#pragma mark - BCTTableViewSectionHeaderView

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        
        _label.backgroundColor = [UIColor clearColor];
        _label.font = [UIFont latoFontOfSize:17.f];
        _label.opaque = YES;
        _label.textColor = [UIColor whiteColor];
    }

    return _label;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.label.frame = CGRectInset(self.bounds, 10.f, 0.f);
}

#pragma mark - NSObject

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.backgroundColor = [UIColor bctransitableBlueColor];
    
    [self addSubview:self.label];
    
    return self;
}

@end
