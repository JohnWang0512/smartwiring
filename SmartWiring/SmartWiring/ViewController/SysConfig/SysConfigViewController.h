//
//  SysConfigViewController.h
//  SmartWiring
//
//  Created by alex wang on 13-8-8.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServeConfigViewController.h"
#import "SafeConfigViewController.h"
#import "AboutViewController.h"

@interface SysConfigViewController : UIViewController
<
    UITableViewDataSource,
    UITableViewDelegate
>
{
    IBOutlet UITableView *myTableview;
    
    IBOutlet UITableViewCell *serverCell;
    IBOutlet UITableViewCell *safeCell;
    IBOutlet UITableViewCell *aboutCell;
}

-(void)pushServer;

-(void)pushSafe;

-(void)pushAbout;

@end
