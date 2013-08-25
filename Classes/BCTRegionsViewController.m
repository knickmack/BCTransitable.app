//
//  BCTRegionsViewController.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-23.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTRegion.h"
#import "BCTRegionsViewController.h"
#import "BCTRoutesViewController.h"
#import "BCTTableViewCell.h"
#import "BCTTableViewSectionHeaderView.h"
#import "UIColor+BCTransitable.h"

@implementation BCTRegionsViewController

#pragma mark - BCTRegionsViewController

- (void)refreshRegions:(UIRefreshControl *)control {
    [BCTRegion regionsWithBlock:^(NSArray *regions, NSError *error) {
        if (!regions) {
            NSLog(@"%@", error);
            [control endRefreshing];
            return;
        }
        
        self.sections = regions;
        [control endRefreshing];
    }];
}

#pragma mark - KNMKSearchableIndexedTableViewController

- (SEL)collationStringSelector {
    return @selector(title);
}

#pragma mark - UITableViewDataSource

- (BCTTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    BCTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BCTTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    BCTRegion *region;
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        region = self.searchResults[indexPath.row];
    } else {
        NSArray *regions = self.sections[indexPath.section];
        
        region = regions[indexPath.row];
    }
    
    cell.label.text = region.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (![self tableView:tableView numberOfRowsInSection:section]) {
        return FLT_MIN;
    }
    
    return UITableViewAutomaticDimension;
}

- (BCTTableViewSectionHeaderView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (![self tableView:tableView numberOfRowsInSection:section]) {
        return nil;
    }

    BCTTableViewSectionHeaderView *view = [BCTTableViewSectionHeaderView new];
    
    view.label.text = [self tableView:tableView titleForHeaderInSection:section];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BCTRegion *region;
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        region = self.searchResults[indexPath.row];
    } else {
        NSArray *regions = self.sections[indexPath.section];
        
        region = regions[indexPath.row];
    }
    
    BCTRoutesViewController *routesViewController = [[BCTRoutesViewController alloc] initWithRegion:region];
    
    [self.navigationController pushViewController:routesViewController animated:YES];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.refreshControl = [UIRefreshControl new];
    self.tableView.contentOffset = CGPointMake(0.f, self.theSearchDisplayController.searchBar.bounds.size.height);
    self.tableView.tableHeaderView = self.theSearchDisplayController.searchBar;
    self.title = NSLocalizedString(@"BCTransitable", nil);
    
    [self.refreshControl addTarget:self action:@selector(refreshRegions:) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl beginRefreshing];
    [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
}

@end
