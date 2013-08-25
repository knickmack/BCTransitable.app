//
//  BCTSearchBar.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-06-06.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTSearchBar.h"

@implementation BCTSearchBar

#pragma mark - UIView

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.showsCancelButton = NO;
}

@end
