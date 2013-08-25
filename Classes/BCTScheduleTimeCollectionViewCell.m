//
//  BCTScheduleTimeCollectionViewCell.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-24.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTScheduleTimeCollectionViewCell.h"

@implementation BCTScheduleTimeCollectionViewCell

@synthesize timeLabel = _timeLabel;

#pragma mark - BCTScheduleTimeCollectionViewCell

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [UILabel new];
        
        _timeLabel.textAlignment = NSTextAlignmentCenter;
    }
    
    return _timeLabel;
}

#pragma mark - UIView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (!self) {
        return nil;
    }
    
    [self.contentView addSubview:self.timeLabel];
    
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.timeLabel.frame = self.contentView.bounds;
}

@end
