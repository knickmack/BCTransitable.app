//
//  BCTTableViewCell.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-28.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTTableViewCell.h"
#import "UIColor+BCTransitable.h"
#import "UIFont+BCTransitable.h"

@implementation BCTTableViewCell

@synthesize label = _label;

#pragma mark - BCTTableViewCell

- (UILabel *)label {
    if (!_label) {
        _label = [UILabel new];
        
        _label.font = [UIFont boldLatoFontOfSize:21.f];
        _label.highlightedTextColor = [UIColor whiteColor];
    }
    
    return _label;
}

#pragma mark - UITableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (!self) {
        return nil;
    }
    
    self.selectedBackgroundView = [UIView new];
    self.selectedBackgroundView.backgroundColor = [UIColor bctransitableBlueColor];
    
    [self.contentView addSubview:self.label];
    
    return self;
}

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.label.frame = CGRectOffset(CGRectInset(self.contentView.bounds, 5.f, 0.f), 5.f, 0.f);
}

@end
