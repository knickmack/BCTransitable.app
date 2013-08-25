//
//  BCTStyleController.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-24.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTStyleController.h"
#import "SIAlertView.h"
#import "UIColor+BCTransitable.h"
#import "UIFont+BCTransitable.h"
#import "UIImage+BCTransitable.h"

@implementation BCTStyleController

#pragma mark - BCTStyleController

+ (void)applyStyles {
    [self styleAlertView];
    [self styleNavigationBar];
    [self styleSearchBar];
    [self styleToolbar];
}

+ (void)styleAlertView {
    [[SIAlertView appearance] setButtonFont:[UIFont boldLatoFontOfSize:17.f]];
}

+ (void)styleNavigationBar {
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor bctransitableGreenColor]] forBarMetrics:UIBarMetricsDefault];
    [[UINavigationBar appearance] setTitleTextAttributes:@{ UITextAttributeTextColor: [UIColor whiteColor], UITextAttributeTextShadowColor: [UIColor clearColor], UITextAttributeTextShadowOffset: [NSValue valueWithCGSize:CGSizeZero], UITextAttributeFont: [UIFont boldLatoFontOfSize:0.f] }];
}

+ (void)styleSearchBar {
    [[UISearchBar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor bctransitableBlueColor]]];
}

+ (void)styleToolbar {
    [[UIToolbar appearance] setBackgroundImage:[UIImage imageWithColor:[UIColor bctransitableBlueColor]] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
}

@end
