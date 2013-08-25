//
//  BCTScheduleViewController.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-24.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTCalendarBarButtonItem.h"
#import "BCTRandomBarButtonItem.h"
#import "BCTRefreshBarButtonItem.h"
#import "BCTReorderBarButtonItem.h"
#import "BCTRegion.h"
#import "BCTRoute.h"
#import "BCTSchedule.h"
#import "BCTScheduleCollectionViewLayout.h"
#import "BCTScheduleTimeCollectionViewCell.h"
#import "BCTScheduleViewController.h"
#import "BCTScheduleWaypointCollectionReusableView.h"
#import "SIAlertView.h"

static NSString * const kBCTScheduleCollectionViewCellIdentifier = @"Cell";
static NSString * const kBCTScheduleCollectionReusableViewIdentifier = @"Header";

@interface BCTScheduleViewController () <UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic, readonly) NSDictionary *day;
@property (strong, nonatomic, readonly) NSDictionary *direction;
@property (strong, nonatomic, readonly) BCTCalendarBarButtonItem *daysBarButtonItem;
@property (strong, nonatomic, readonly) BCTRandomBarButtonItem *directionsBarButtonItem;
@property (strong, nonatomic, readonly) UIBarButtonItem *flexibleSpaceBarButtonItem;
@property (strong, nonatomic, readonly) BCTRefreshBarButtonItem *refreshBarButtonItem;
@property (strong, nonatomic, readonly) BCTRegion *region;
@property (strong, nonatomic, readonly) BCTRoute *route;
@property (strong, nonatomic) BCTSchedule *schedule;
@property (strong, nonatomic) NSArray *sections;

@end

@implementation BCTScheduleViewController

@synthesize day = _day;
@synthesize direction = _direction;
@synthesize daysBarButtonItem = _daysBarButtonItem;
@synthesize directionsBarButtonItem = _directionsBarButtonItem;
@synthesize flexibleSpaceBarButtonItem = _flexibleSpaceBarButtonItem;
@synthesize refreshBarButtonItem = _refreshBarButtonItem;
@synthesize region = _region;
@synthesize route = _route;
@synthesize schedule = _schedule;
@synthesize sections = _sections;

#pragma mark - BCTScheduleViewController

- (BCTCalendarBarButtonItem *)daysBarButtonItem {
    if (!_daysBarButtonItem) {
        _daysBarButtonItem = [BCTCalendarBarButtonItem new];
        
        [(UIButton *)_daysBarButtonItem.customView addTarget:self action:@selector(didTapDaysBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _daysBarButtonItem;
}

- (BCTRandomBarButtonItem *)directionsBarButtonItem {
    if (!_directionsBarButtonItem) {
        _directionsBarButtonItem = [BCTRandomBarButtonItem new];
        
        [(UIButton *)_directionsBarButtonItem.customView addTarget:self action:@selector(didTapDirectionsBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _directionsBarButtonItem;
}

- (UIBarButtonItem *)flexibleSpaceBarButtonItem {
    if (!_flexibleSpaceBarButtonItem) {
        _flexibleSpaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    }
    
    return _flexibleSpaceBarButtonItem;
}

- (BCTRefreshBarButtonItem *)refreshBarButtonItem {
    if (!_refreshBarButtonItem) {
        _refreshBarButtonItem = [BCTRefreshBarButtonItem new];
        
        [(UIButton *)_refreshBarButtonItem.customView addTarget:self action:@selector(refreshSchedule) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _refreshBarButtonItem;
}

- (void)setSchedule:(BCTSchedule *)schedule {
    _schedule = schedule;
    
    self.sections = self.schedule.times;
    [self.collectionView reloadData];
    
//    if (schedule.days.count) {
//        [self addDaysBarButtonItemToToolbar];
//    } else {
//        [self removeDaysBarButtonItemFromToolbar];
//    }
//    
//    if (schedule.directions.count) {
//        [self addDirectionsBarButtonItemToToolbar];
//    } else {
//        [self removeDirectionsBarButtonItemFromToolbar];
//    }
    
    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (NSArray *)sections {
    if (!_sections) {
        _sections = @[];
    }
    
    return _sections;
}

- (void)setSections:(NSArray *)times {
    NSMutableArray *sections = [@[] mutableCopy];
    for (NSUInteger i = 0, j = self.schedule.waypoints.count; i < j; i++) {
        NSMutableArray *section = [@[] mutableCopy];
        for (NSUInteger k = i, l = self.schedule.times.count; k < l; k += j) {
            [section addObject:self.schedule.times[k]];
        }
        
        [sections addObject:section];
    }
    
    _sections = [sections copy];
}

- (void)setRegion:(BCTRegion *)region route:(BCTRoute *)route {
    _region = region;
    _route = route;
    
    self.title = route.title;
    
    [self refreshSchedule];
}

- (void)addToolbarItems:(NSArray *)items {
    NSMutableArray *mutableToolbarItems = [self.toolbarItems mutableCopy];
    
    [mutableToolbarItems addObjectsFromArray:items];
    [self setToolbarItems:[mutableToolbarItems copy] animated:YES];
}

- (void)insertToolbarItems:(NSArray *)items atIndexes:(NSIndexSet *)indexes {
    NSMutableArray *mutableToolbarItems = [self.toolbarItems mutableCopy];
    
    [mutableToolbarItems insertObjects:items atIndexes:indexes];
    [self setToolbarItems:[mutableToolbarItems copy] animated:YES];
}

- (void)removeToolbarItemsAtIndexes:(NSIndexSet *)indexes {
    NSMutableArray *mutableToolbarItems = [self.toolbarItems mutableCopy];
    
    [mutableToolbarItems removeObjectsAtIndexes:indexes];
    [self setToolbarItems:[mutableToolbarItems copy] animated:YES];
}

- (void)addDaysBarButtonItemToToolbar {
    if ([self.toolbarItems containsObject:self.daysBarButtonItem]) {
        return;
    }
    
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)];
    
    [self insertToolbarItems:@[ self.flexibleSpaceBarButtonItem, self.daysBarButtonItem ] atIndexes:indexes];
}

- (void)removeDaysBarButtonItemFromToolbar {
    if (![self.toolbarItems containsObject:self.daysBarButtonItem]) {
        return;
    }
    
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 2)];
    
    [self removeToolbarItemsAtIndexes:indexes];
}

- (void)addDirectionsBarButtonItemToToolbar {
    if ([self.toolbarItems containsObject:self.directionsBarButtonItem]) {
        return;
    }
    
    [self addToolbarItems:@[ self.directionsBarButtonItem, self.flexibleSpaceBarButtonItem ]];
}

- (void)removeDirectionsBarButtonItemFromToolbar {
    if (![self.toolbarItems containsObject:self.directionsBarButtonItem]) {
        return;
    }
    
    NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(self.toolbarItems.count - 3, 2)];
    
    [self removeToolbarItemsAtIndexes:indexes];
}

- (void)didTapDaysBarButtonItem {
//    SIAlertView *alertView = [SIAlertView new];
//    __weak __typeof(&*self)weakSelf = self;

//    for (NSDictionary *day in self.schedule.days) {
//        if ([day[@"selected"] boolValue]) {
//            [alertView addButtonWithTitle:day[@"title"] type:SIAlertViewButtonTypeDestructive handler:nil];
//            continue;
//        }
//
//        [alertView addButtonWithTitle:day[@"title"] type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
//            NSMutableDictionary *mutableAttributes = [@{ @"region": weakSelf.region, @"route": weakSelf.route } mutableCopy];
//            if (weakSelf.direction) {
//                mutableAttributes[@"direction"] = weakSelf.direction;
//            }
//            
//            mutableAttributes[@"day"] = day;
//            
//            [BCTSchedule scheduleWithAttributes:[mutableAttributes copy] block:^(BCTSchedule *schedule, NSError *error) {
//                if (!schedule) {
//                    NSLog(@"%@", error);
//                    return;
//                }
//                
//                _day = day;
//                weakSelf.schedule = schedule;
//            }];
//        }];
//    }
//    
//    [alertView addButtonWithTitle:NSLocalizedString(@"Cancel", nil) type:SIAlertViewButtonTypeCancel handler:nil];
//    [alertView show];
}

- (void)didTapDirectionsBarButtonItem {
//    SIAlertView *alertView = [SIAlertView new];
//    __weak __typeof(&*self)weakSelf = self;
//
//    for (NSDictionary *direction in self.schedule.directions) {
//        if ([direction[@"selected"] boolValue]) {
//            [alertView addButtonWithTitle:direction[@"title"] type:SIAlertViewButtonTypeDestructive handler:nil];
//            continue;
//        }
//
//        [alertView addButtonWithTitle:direction[@"title"] type:SIAlertViewButtonTypeDefault handler:^(SIAlertView *alertView) {
//            NSMutableDictionary *mutableAttributes = [@{ @"region": weakSelf.region, @"route": weakSelf.route } mutableCopy];
//            if (self.day) {
//                mutableAttributes[@"day"] = weakSelf.day;
//            }
//            
//            mutableAttributes[@"direction"] = direction;
//            
//            [BCTSchedule scheduleWithAttributes:[mutableAttributes copy] block:^(BCTSchedule *schedule, NSError *error) {
//                if (!schedule) {
//                    NSLog(@"%@", error);
//                    return;
//                }
//                
//                _direction = direction;
//                weakSelf.schedule = schedule;
//            }];
//        }];
//    }
//    
//    [alertView addButtonWithTitle:NSLocalizedString(@"Cancel", nil) type:SIAlertViewButtonTypeCancel handler:nil];
//    [alertView show];
}

- (void)didTapLeftBarButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshSchedule {
//    __weak __typeof(&*self)weakSelf = self;

//    [BCTSchedule scheduleWithRegion:self.region route:self.route block:^(BCTSchedule *schedule, NSError *error) {
//        if (!schedule) {
//            NSLog(@"%@", error);
//            return;
//        }
//        
//        weakSelf.schedule = schedule;
//    }];
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    self.navigationItem.leftBarButtonItem.title = viewController.title;
}

#pragma mark - UISplitViewControllerDelegate

- (void)splitViewController:(UISplitViewController *)svc willHideViewController:(UINavigationController *)navigationController withBarButtonItem:(UIBarButtonItem *)barButtonItem forPopoverController:(UIPopoverController *)pc {
    BCTReorderBarButtonItem *leftBarButtonItem = [BCTReorderBarButtonItem new];
    
    [(UIButton *)leftBarButtonItem.customView addTarget:barButtonItem.target action:barButtonItem.action forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)splitViewController:(UISplitViewController *)svc willShowViewController:(UIViewController *)aViewController invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem {
    self.navigationItem.leftBarButtonItem = nil;
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return self.sections.count;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if (![kind isEqualToString:UICollectionElementKindSectionHeader]) {
        return nil;
    }
    
    BCTScheduleWaypointCollectionReusableView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kBCTScheduleCollectionReusableViewIdentifier forIndexPath:indexPath];
    NSString *waypoint = self.schedule.waypoints[indexPath.section];

    header.waypointLabel.text = waypoint;

    return header;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *times = self.sections[section];
    
    return times.count;
}

- (BCTScheduleTimeCollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    BCTScheduleTimeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kBCTScheduleCollectionViewCellIdentifier forIndexPath:indexPath];
    NSArray *times = self.sections[indexPath.section];
    NSString *time = times[indexPath.row];
    
    cell.timeLabel.backgroundColor = indexPath.item % 2 ? [UIColor colorWithWhite:0.9f alpha:1.f] : [UIColor whiteColor];
    cell.timeLabel.text = time;
    
    return cell;
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.collectionView.backgroundColor = [UIColor whiteColor];
    self.collectionView.directionalLockEnabled = YES;
    self.title = self.route.title;
    self.toolbarItems = @[ self.flexibleSpaceBarButtonItem, self.refreshBarButtonItem, self.flexibleSpaceBarButtonItem ];
    
    [self.collectionView registerClass:[BCTScheduleTimeCollectionViewCell class] forCellWithReuseIdentifier:kBCTScheduleCollectionViewCellIdentifier];
    [self.collectionView registerClass:[BCTScheduleWaypointCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kBCTScheduleCollectionReusableViewIdentifier];
    
    BCTReorderBarButtonItem *leftBarButtonItem = [BCTReorderBarButtonItem new];
    
    [(UIButton *)leftBarButtonItem.customView addTarget:self action:@selector(didTapLeftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
}

- (void)viewWillDisappear:(BOOL)animated {
    [self.navigationController setToolbarHidden:YES animated:animated];

    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    _day = nil;
    _direction = nil;
    _daysBarButtonItem = nil;
    _directionsBarButtonItem = nil;
    _flexibleSpaceBarButtonItem = nil;
    _refreshBarButtonItem = nil;
    _region = nil;
    _route = nil;
    _schedule = nil;
    _sections = nil;

    [super didReceiveMemoryWarning];
}

#pragma mark - NSObject

- (id)init {
    self = [super initWithCollectionViewLayout:[BCTScheduleCollectionViewLayout new]];
    if (!self) {
        return nil;
    }
    
    return self;
}

@end
