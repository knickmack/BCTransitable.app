//
//  BCTScheduleViewController.h
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-24.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCTRegion, BCTRoute;

@interface BCTScheduleViewController : UICollectionViewController <UINavigationControllerDelegate, UISplitViewControllerDelegate>

- (void)setRegion:(BCTRegion *)region route:(BCTRoute *)route;

@end
