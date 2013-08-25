//
//  BCTScheduleWaypointCollectionReusableView.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-24.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTScheduleWaypointCollectionReusableView.h"
#import "UIColor+BCTransitable.h"
#import "UIFont+BCTransitable.h"

@implementation BCTScheduleWaypointCollectionReusableView

@synthesize waypointLabel = _waypointLabel;

#pragma mark - BCTScheduleWaypointCollectionReusableView

- (UILabel *)waypointLabel {
    if (!_waypointLabel) {
        _waypointLabel = [UILabel new];
        
        _waypointLabel.backgroundColor = [UIColor bctransitableBlueColor];
        _waypointLabel.font = [UIFont latoFontOfSize:15.f];
        _waypointLabel.textAlignment = NSTextAlignmentCenter;
        _waypointLabel.textColor = [UIColor whiteColor];
    }
    
    return _waypointLabel;
}

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self addSubview:self.waypointLabel];

    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.waypointLabel.frame = self.bounds;
}

@end
