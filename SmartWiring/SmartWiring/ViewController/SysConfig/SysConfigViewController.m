//
//  SysConfigViewController.m
//  SmartWiring
//
//  Created by alex wang on 13-8-8.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import "SysConfigViewController.h"

@interface SysConfigViewController ()

@end

@implementation SysConfigViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"系统设置";
    
    
    
    // Do any additional setup after loading the view from its nib.
}

#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            serverCell.textLabel.text = @"服务器";
            return serverCell;
            break;
        case 1:
            safeCell.textLabel.text = @"安全";
            return safeCell;
            break;
        case 2:
            aboutCell.textLabel.text = @"关于";
            return aboutCell;
            break;
        default:
            break;
    }
    return nil;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.row) {
        case 0:
            [self pushServer];
            break;
        case 1:
            [self pushSafe];
            break;
        case 2:
            [self pushAbout];
            break;
        default:
            break;
    }
}

//服务器
-(void)pushServer
{
    ServeConfigViewController *serverVC = [[ServeConfigViewController alloc] initWithNibName:@"ServeConfigViewController" bundle:nil];
    [self.navigationController pushViewController:serverVC animated:YES];
    [serverVC release];
}

//安全
-(void)pushSafe
{
    SafeConfigViewController *safeConfigVC = [[SafeConfigViewController alloc] initWithNibName:@"SafeConfigViewController" bundle:nil];
    [self.navigationController pushViewController:safeConfigVC animated:YES];
    [safeConfigVC release];
}

//关于
-(void)pushAbout
{
    AboutViewController *aboutVC = [[AboutViewController alloc] initWithNibName:@"AboutViewController" bundle:nil];
    [self.navigationController pushViewController:aboutVC animated:YES];
    [aboutVC release];
}

-(void)dealloc
{
    [myTableview release];
    [serverCell release];
    [safeCell release];
    [aboutCell release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
