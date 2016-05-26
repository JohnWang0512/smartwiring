//
//  ConfigCommend.h
//  SmartWiring
//
//  Created by 陈 远 on 13-8-3.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Global.h"

@interface ConfigCommend : NSObject

+(int)getAllFrameCount:(NSString*)ssid pwd:(NSString*)pwd ip:(NSString*)sIp port:(int)iPort;

+(CustomArray)createLastFrames:(NSString*)ssid pwd:(NSString*)pwd ip:(NSString*)sIp port:(int)iPort;

+(CustomArray)createConfigFrames:(CustomArray)data;

+(CustomArray)configSSID:(NSString*)ssid;

+(CustomArray)configPWD:(NSString*)pwd;

+(CustomArray)configIP:(NSString*)ip;

+(CustomArray)configWorkModel;

+(CustomArray)configPort:(int)iPort;

@end
