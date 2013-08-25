//
//  BCTRoutesViewController.m
//  BCTransitable
//
//  Created by Nik Macintosh on 2013-05-24.
//  Copyright (c) 2013 Nik Macintosh. All rights reserved.
//

#import "BCTChevronButton.h"
#import "BCTRegion.h"
#import "BCTReorderBarButtonItem.h"
#import "BCTRoute.h"
#import "BCTRoutesViewController.h"
#import "BCTSchedulesViewController.h"
#import "BCTSearchBar.h"
#import "BCTTableViewCell.h"
#import "BCTTableViewSectionHeaderView.h"

@interface BCTRoutesViewController () <UISearchDisplayDelegate>

@property (strong, nonatomic, readonly) BCTRegion *region;
@property (strong, nonatomic, readonly) NSArray *searchResults;
@property (strong, nonatomic, readonly) NSDictionary *sections;
@property (strong, nonatomic, readonly) UISearchDisplayController *theSearchDisplayController;

@end

@implementation BCTRoutesViewController

@synthesize region = _region;
@synthesize searchResults = _searchResults;
@synthesize sections = _sections;
@synthesize theSearchDisplayController = _theSearchDisplayController;

#pragma mark - BCTRoutesViewController

- (NSArray *)searchResults {
    if (!_searchResults) {
        _searchResults = @[];
    }
    
    return _searchResults;
}

- (NSDictionary *)sections {
    if (!_sections) {
        _sections = @{};
    }
    
    return _sections;
}

- (UISearchDisplayController *)theSearchDisplayController {
    if (!_theSearchDisplayController) {
        BCTSearchBar *searchBar = [BCTSearchBar new];
        
        searchBar.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        [searchBar sizeToFit];
        
        _theSearchDisplayController = [[UISearchDisplayController alloc] initWithSearchBar:searchBar contentsController:self];
        
        _theSearchDisplayController.delegate = self;
        _theSearchDisplayController.searchResultsDataSource = self;
        _theSearchDisplayController.searchResultsDelegate = self;
    }
    
    return _theSearchDisplayController;
}

- (id)initWithRegion:(BCTRegion *)region {
    self = [super initWithStyle:UITableViewStylePlain];
    if (!self) {
        return nil;
    }
    
    _region = region;
    
    return self;
}

- (void)didTapChevronButton:(BCTChevronButton *)button event:(UIEvent *)event {
    CGPoint point = [event.allTouches.anyObject locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    
    [self.tableView.delegate tableView:self.tableView accessoryButtonTappedForRowWithIndexPath:indexPath];
}

- (void)didTapLeftBarButtonItem {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)refreshRoutes:(UIRefreshControl *)control {
    __weak __typeof(&*self)weakSelf = self;

    [control beginRefreshing];
    
    [BCTRoute routesWithRegion:self.region block:^(NSArray *routes, NSError *error) {
        if (!routes) {
            NSLog(@"%@", error);
            [control endRefreshing];
            return;
        }
        
        NSMutableDictionary *sections = [@{} mutableCopy];
        for (BCTRoute *route in routes) {
            NSInteger min = route.number.integerValue / 10 * 10;
            NSInteger max = min + 9;
            NSString *title = [NSString stringWithFormat:@"%i - %i", min, max];
            NSMutableArray *section = sections[title];
            if (!section) {
                section = [@[] mutableCopy];
            }
            
            [section addObject:route];
            sections[title] = section;
        }
        
        _sections = [sections copy];
        [weakSelf.tableView reloadData];
        [control endRefreshing];
    }];
}

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"title beginswith[cd] %@", searchString];
    
    _searchResults = [[self.sections.allValues valueForKeyPath:@"@unionOfArrays.self"] filteredArrayUsingPredicate:predicate];
    
    return YES;
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        return 1;
    }
    
    return self.sections.allKeys.count;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        return nil;
    }

    NSArray *titles = [self.sections.allKeys sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
    return titles[section];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        return self.searchResults.count;
    }

    NSString *title = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    NSArray *routes = self.sections[title];
    
    return routes.count;
}

- (BCTTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    BCTChevronButton *button = [BCTChevronButton new];
    BCTTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BCTTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    BCTRoute *route;
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        route = self.searchResults[indexPath.row];
    } else {
        NSString *title = [tableView.dataSource tableView:tableView titleForHeaderInSection:indexPath.section];
        NSArray *routes = self.sections[title];

        route = routes[indexPath.row];
    }
    
    [button addTarget:self action:@selector(didTapChevronButton:event:) forControlEvents:UIControlEventTouchUpInside];
    
    cell.accessoryView = button;
    cell.label.text = route.title;
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    [tableView.delegate tableView:tableView didSelectRowAtIndexPath:indexPath];
}

- (BCTTableViewSectionHeaderView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    BCTTableViewSectionHeaderView *view = [BCTTableViewSectionHeaderView new];
    
    view.label.text = [tableView.dataSource tableView:tableView titleForHeaderInSection:section];
    
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    BCTRoute *route;
    if (tableView == self.theSearchDisplayController.searchResultsTableView) {
        route = self.searchResults[indexPath.row];
    } else {
        NSString *title = [tableView.dataSource tableView:tableView titleForHeaderInSection:indexPath.section];
        NSArray *routes = self.sections[title];
        
        route = routes[indexPath.row];
    }
    
    BCTSchedulesViewController *schedulesViewController = [[BCTSchedulesViewController alloc] initWithRegion:self.region route:route];
    
    [self.navigationController pushViewController:schedulesViewController animated:YES];
}

#pragma mark - UIViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    BCTReorderBarButtonItem *leftBarButtonItem = [BCTReorderBarButtonItem new];
    
    [(UIButton *)leftBarButtonItem.customView addTarget:self action:@selector(didTapLeftBarButtonItem) forControlEvents:UIControlEventTouchUpInside];
    
    self.navigationItem.leftBarButtonItem = leftBarButtonItem;
    self.refreshControl = [UIRefreshControl new];
    self.tableView.contentOffset = CGPointMake(0.f, self.theSearchDisplayController.searchBar.bounds.size.height);
    self.tableView.tableHeaderView = self.theSearchDisplayController.searchBar;
    self.title = self.region.title;
    
    [self.refreshControl addTarget:self action:@selector(refreshRoutes:) forControlEvents:UIControlEventValueChanged];
    [self.refreshControl sendActionsForControlEvents:UIControlEventValueChanged];
}

- (void)didReceiveMemoryWarning {
    _region = nil;
    _searchResults = nil;
    _sections = nil;
    _theSearchDisplayController = nil;

    [super didReceiveMemoryWarning];
}

@end
