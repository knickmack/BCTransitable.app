//
//  BCTCalendarBarButtonItem.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-26.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTCalendarBarButtonItem.h"
#import "UIFont+BCTransitable.h"

@interface BCTCalendarBarButtonItem ()

@property (strong, nonatomic, readonly) UIButton *customView;

@end

@implementation BCTCalendarBarButtonItem

@synthesize customView = _customView;

#pragma mark - BCTCalendarBarButtonItem

- (UIButton *)customView {
    if (!_customView) {
        _customView = [UIButton new];
        
        _customView.contentEdgeInsets = UIEdgeInsetsMake(0.f, 10.f, 0.f, 10.f);
        _customView.contentMode = UIViewContentModeCenter;
        _customView.titleLabel.font = [UIFont fontAwesomeFontOfSize:20.f];
        _customView.showsTouchWhenHighlighted = YES;
        
        [_customView setTitle:@"\uf073" forState:UIControlStateNormal];
        [_customView sizeToFit];
    }
    
    return _customView;
}

#pragma mark - NSObject

- (id)init {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    self.customView = self.customView;
    self.style = UIBarButtonItemStylePlain;
    
    return self;
}

@end
