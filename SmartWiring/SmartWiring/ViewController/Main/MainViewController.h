//
//  MainViewController.h
//  SmartWiring
//
//  Created by 王义吉 on 8/1/13.
//  Copyright (c) 2013 王义吉. All rights reserved.
//

#import "AsyncUdpSocket.h"

#import <CoreData/CoreData.h>

#import "ConfigViewController.h"
#import "ThreeWiringCell.h"
#import "ItemViewController.h"
#import "SmartSocketCommend.h"
#import "Device.h"
#import "Reachability.h"
#import "DeviceStatuEntity.h"
#import "DDMenuController.h"

@interface MainViewController : UIViewController
<
    UITableViewDelegate,
    UITableViewDataSource,
    UIActionSheetDelegate
>
{
    AsyncUdpSocket *udpSocket;
    IBOutlet UITableView *myTableview;
    
    IBOutlet UIView *planeView;
    IBOutlet UIButton *btnType1;
    IBOutlet UIButton *btnType2;
    IBOutlet UIButton *btnType3;
    IBOutlet UIButton *btnType4;
    IBOutlet UIButton *btnType5;
    IBOutlet UIButton *btnType6;
    
    IBOutlet UIView *inputView;
    IBOutlet UITextField *txtDeviceName;
    IBOutlet UIButton *btnSure;
    IBOutlet UIButton *btnCancel;
    
    DDMenuController *ddmenuVC;
    
    BOOL bShowTypePlane;
    BOOL bInputShow;

    NSMutableArray *lights;
    int iSelectIndex;
    BOOL bShowNoWaln;
    
    int iChangeIndex;
}

@property (nonatomic,retain) AsyncUdpSocket *udpSocket;
@property (nonatomic,retain) DDMenuController *ddmenuVC;

-(void)refreshAll;
-(void)afterError:(long)tag error:(NSError*)error;
/*
 device type
 */
-(IBAction)didPressedType:(id)sender;

-(IBAction)didPressedSure:(id)sender;
-(IBAction)didPressedCancel:(id)sender;

-(IBAction)done:(id)sender;

-(void)didPressedNoWaln:(id)sender;

-(NSString*)analysisData:(Byte*)data;

-(void)pushLightItem:(int)iIndex deviceStatu:(Byte)statu power:(float)fPower;

@end
