//
//  AppDelegate.h
//  SmartWiring
//
//  Created by 王义吉 on 8/1/13.
//  Copyright (c) 2013 王义吉. All rights reserved.
//

#import <UIKit/UIKit.h>

/*
 1.首次点击发送80包，返回81包，stat为0则不在线，弹框 “设备不在线”
 2.stat为非0，发A0查询插座功率信息，同事进入单体控制界面 ，带名字、图标、功率
 3.点刷新重复26包，刷新设备信息。
 4.点击灯泡，发20包，过程中显示loading，等待23包，界面变成开灯图标。
 5.包验证，前5位加data的len的后2位为##，则通过
 
 */

@class MainViewController;

#import "DDMenuController.h"
#import "LeftController.h"
#import "RightController.h"
#import "MainViewController.h"
#import "Device.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    NSString *sHost;
    AsyncUdpSocket *udpSocket;
    NSMutableDictionary *sendDic;
    MBProgressHUD *HUD;
}

@property (nonatomic,retain) NSString *sHost;
@property (strong, nonatomic) DDMenuController *menuController;
@property (nonatomic,retain) NSMutableDictionary *sendDic;

@property (strong, nonatomic) UIWindow *window;
@property (nonatomic,retain) AsyncUdpSocket *udpSocket;
@property (nonatomic,retain) MBProgressHUD *HUD;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (strong, nonatomic)MainViewController  *mainViewController;

@end
