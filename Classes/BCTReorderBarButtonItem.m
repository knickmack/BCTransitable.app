//
//  BCTReorderBarButtonItem.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-26.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTReorderBarButtonItem.h"
#import "UIFont+BCTransitable.h"

@interface BCTReorderBarButtonItem ()

@property (strong, nonatomic, readonly) UIButton *button;

@end

@implementation BCTReorderBarButtonItem

@synthesize button = _button;

#pragma mark - BCTReorderBarButtonItem

- (UIButton *)button {
    if (!_button) {
        _button = [UIButton new];
        
        _button.contentEdgeInsets = UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f);
        _button.contentMode = UIViewContentModeCenter;
        _button.titleLabel.font = [UIFont fontAwesomeFontOfSize:20.f];
        _button.showsTouchWhenHighlighted = YES;
        
        [_button setTitle:@"\uf0c9" forState:UIControlStateNormal];
        [_button sizeToFit];
    }
    
    return _button;
}

#pragma mark - NSObject

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.customView = self.button;
    self.style = UIBarButtonItemStylePlain;
    
    return self;
}

@end
