//
//  ConfigViewController.h
//  SmartWiring
//
//  Created by 陈 远 on 13-8-3.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigCommend.h"

@interface ConfigViewController : UITableViewController
<
    UIAlertViewDelegate
>
{
    IBOutlet UITableView *myTableview;
    
    IBOutlet UITableViewCell *apNameCell;
    IBOutlet UITextField *txtApName;
    IBOutlet UITableViewCell *apPWDCell;
    IBOutlet UITextField *txtPwd;
    
    IBOutlet UITableViewCell *addressCell;
    IBOutlet UITextField *txtAddress;
    IBOutlet UITableViewCell *portCell;
    IBOutlet UITextField *txtPort;
    
    IBOutlet UITableViewCell *versionCell;
    IBOutlet UILabel *lblVersion;
    IBOutlet UITableViewCell *submitCell;
    IBOutlet UIButton *btnSubmit;
    
    IBOutlet UITableViewCell *macAddressCell;
    IBOutlet UITextField *txtMacAddress;
    
    IBOutlet UISwitch *swith;
    
    AsyncUdpSocket *udpSocket;
}

@property (nonatomic,retain) AsyncUdpSocket *udpSocket;

-(NSString*)checkInfo;

-(IBAction)didPressedSubmit:(id)sender;

-(IBAction)didPressedAddMac:(id)sender;

-(IBAction)didPressedBeginEdit:(id)sender;
-(IBAction)didPressedEndEdit:(id)sender;

-(IBAction)done:(id)sender;

-(IBAction)switchChange:(id)sender;

@end
