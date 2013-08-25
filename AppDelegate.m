//
//  AppDelegate.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-23.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "AFNetworkActivityIndicatorManager.h"
#import "AppDelegate.h"
#import "BCTRegionsViewController.h"
#import "BCTScheduleViewController.h"
#import "BCTStyleController.h"

@implementation AppDelegate

#pragma mark - AppDelegate

- (UIWindow *)window {
    if (!_window) {
        _window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
        
        _window.rootViewController = [[UINavigationController alloc] initWithRootViewController:[BCTRegionsViewController new]];
    }
    
    return _window;
}

#pragma mark - UIApplicationDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    NSURLCache *URLCache = [[NSURLCache alloc] initWithMemoryCapacity:8 * 1024 * 1024 diskCapacity:20 * 1024 * 1024 diskPath:nil];
    [NSURLCache setSharedURLCache:URLCache];
    
    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];
    
    [BCTStyleController applyStyles];
    
    [self.window makeKeyAndVisible];
    
    return YES;
}

@end
