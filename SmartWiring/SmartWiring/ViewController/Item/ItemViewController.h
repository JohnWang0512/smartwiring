//
//  ItemViewController.h
//  SmartWiring
//
//  Created by 王义吉 on 8/8/13.
//  Copyright (c) 2013 王义吉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SmartSocketCommend.h"
#import "Device.h"

#import "DeviceInfoEntity.h"
#import "DeviceVersionEntity.h"
#import "DevicePowerEntity.h"

#import "DeviceInfoEntity.h"
#import "DevicePowerEntity.h"
#import "DeviceVersionEntity.h"
#import "DeviceOpenEntity.h"



@interface ItemViewController : UIViewController
{
    IBOutlet UIButton *btnLight;
    IBOutlet UIButton *btnMoreInfo;
    
    IBOutlet UILabel *lblPower;
    
    IBOutlet UILabel *lblDeviceTitle;
    
    
    IBOutlet UIView *infoView;
    IBOutlet UILabel *lblDeviceName;
    IBOutlet UILabel *lblDeviceGonglv;
    IBOutlet UILabel *lblMacAddress;
    IBOutlet UILabel *lblDeviceVersion;
    
    AsyncUdpSocket *udpSocket;
    Device *deviceItem;

    BOOL bInfoShow;
    
    BOOL bOpen;
    
    DeviceStatu nowDeviceStatu;
    NSString *sPower;
}

@property (nonatomic,retain) AsyncUdpSocket *udpSocket;
@property (nonatomic,retain) Device *deviceItem;
@property (nonatomic) DeviceStatu nowDeviceStatu;
@property (nonatomic,retain) NSString *sPower;
@property (nonatomic) BOOL bOpen;

//解析数据包，返回mac地址
-(NSString*)analysisData:(Byte*)data tag:(long)tag;
-(void)afterError:(long)tag error:(NSError*)error;

-(IBAction)didPressedLight:(id)sender;
-(IBAction)didPressedMoreInfo:(id)sender;


@end
