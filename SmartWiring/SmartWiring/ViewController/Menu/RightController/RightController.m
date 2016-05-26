//
//  RightController.m
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "RightController.h"
#import "FeedController.h"

@implementation RightController

@synthesize tableView=_tableView;

- (id)init {
    if ((self = [super init])) {
    }
    return self;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return YES;
}


#pragma mark - View lifecycle

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (!_tableView) {
        
        CGRect frame = self.view.bounds;
        frame.origin.x = 40.0f;
        frame.size.width -= 40.0f;
        
        UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        tableView.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];
        [self.view addSubview:tableView];
        self.tableView = tableView;
        
    }
    
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 8;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    cell.textLabel.text = [NSString stringWithFormat:@"Cell %i", indexPath.row];
    
    return cell;
    
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Right Controller";
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // lets just push another feed view 
    UINavigationController *menuController = (UINavigationController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    FeedController *controller = [[FeedController alloc] init];
    [menuController pushViewController:controller animated:YES];
    
    
}

@end