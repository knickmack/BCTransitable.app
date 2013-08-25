//
//  BCTSchedulesViewController.h
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-07-25.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BCTRegion, BCTRoute;

@interface BCTSchedulesViewController : UITableViewController

- (id)initWithRegion:(BCTRegion *)region route:(BCTRoute *)route;

@end
