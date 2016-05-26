//
//  LeftController.m
//  DDMenuController
//
//  Created by Devin Doty on 11/30/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "LeftController.h"
#import "FeedController.h"
#import "DDMenuController.h"

@implementation LeftController

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
        UITableView *tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        tableView.delegate = (id<UITableViewDelegate>)self;
        tableView.dataSource = (id<UITableViewDataSource>)self;
        [self.view addSubview:tableView];
        self.tableView = tableView;
    }
}

- (void)viewDidUnload {
    [super viewDidUnload];
    self.tableView = nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView*)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

- (UITableViewCell*)tableView:(UITableView*)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    /* 
     * Content in this cell should be inset the size of kMenuOverlayWidth
     */

    switch (indexPath.row) {
        case 0:
            cell.textLabel.text = @"设备列表";
            break;
        case 1:
            cell.textLabel.text = @"添加设备";
            break;
        case 2:
            cell.textLabel.text = @"系统设置";
            break;
        case 3:
            cell.textLabel.text = @"使用说明";
            break;
        default:
            break;
    }
    return cell;
    
}

- (NSString*)tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section {
    return @"插座控制";
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView*)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // set the root controller
    DDMenuController *menuController = (DDMenuController*)((AppDelegate*)[[UIApplication sharedApplication] delegate]).menuController;
    UINavigationController *navController = nil;
    
    switch (indexPath.row) {
        case 0:
        {
            MainViewController *main = [[MainViewController alloc] initWithNibName:@"MainViewController" bundle:nil];
            navController = [[UINavigationController alloc] initWithRootViewController:main];
            break;
        }
            
        case 1:
        {
            ConfigViewController *configVC = [[ConfigViewController alloc] initWithNibName:@"ConfigViewController" bundle:nil];
            navController = [[UINavigationController alloc] initWithRootViewController:configVC];
        }
            break;
        case 2:
        {
            SysConfigViewController *sysConfigVC = [[SysConfigViewController alloc] initWithNibName:@"SysConfigViewController" bundle:nil];
            navController = [[UINavigationController alloc] initWithRootViewController:sysConfigVC];
        }
            break;
        case 3:
        {
            return;
        }
            break;
            
        default:
            break;
    }

    [menuController setRootController:navController animated:YES];
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}



@end
