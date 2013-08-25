//
//  BCTSchedulesViewController.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-07-25.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTRegion.h"
#import "BCTReorderBarButtonItem.h"
#import "BCTRoute.h"
#import "BCTSchedule.h"
#import "BCTSchedulesViewController.h"

@interface BCTSchedulesViewController ()

@property (strong, nonatomic, readonly) BCTRegion *region;
@property (strong, nonatomic, readonly) BCTRoute *route;

@end

@implementation BCTSchedulesViewController

@synthesize region = _region;
@synthesize route = _route;

#pragma mark - BCTSchedulesViewController

- (id)initWithRegion:(BCTRegion *)region route:(BCTRoute *)route {
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) {
        return nil;
    }
    
    _region = region;
    _route = route;
    
    return self;
}

- (void)didTapLeftBarButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshSchedules:(UIRefreshControl *)control {
    __weak __typeof(&*self)weakSelf = self;
    
    [BCTSchedule schedulesWithRegion:self.region route:self.route block:^(NSArray *schedules, NSError *error) {
        if (!schedules) {
            NSLog(@"%@", error);
            
            return [weakSelf.refreshControl endRefreshing];
        }
        
        NSLog(@"%@", schedules);
        [weakSelf.refreshControl endRefreshing];
    }];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    BCTReorderBarButtonItem *leftBarButtonItem = [BCTReorderBarButtonItem new];
    
    [(UIButton *)leftBarButtonItem.customView addTarget:self action:@selector(didTapLeftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.refreshControl = [UIRefreshControl new];
    self.title = self.route.title;
    
    [self.refreshControl addTarget:self action:@selector(refreshSchedules:) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    _region = nil;
    _route = nil;
    
    [super didReceiveMemoryWarning];
}

@end
