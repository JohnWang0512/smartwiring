//
//  SmartSocketCommend.h
//  SmartWiring
//
//  Created by alex wang on 13-8-1.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SmartSocketCommend : NSObject

/*
 第一部分
 组帧
 */
+(CustomArray)createFrames:(CustomArray)data;

/* 
 第二部分
 数据段
 */
+(CustomArray)createDataFrames:(Byte)funId datas:(CustomArray)datas;

/*
 第三部分
 */
+(CustomArray)fetchDeviceInfo:(NSString*)mac;
+(CustomArray)fetchDeviceStat:(NSString*)mac;
+(CustomArray)fetchDeviceVersion:(NSString*)mac;
+(CustomArray)fetchDevicePower:(NSString*)mac;
+(CustomArray)createTurnOnCmd:(NSString*)mac;
+(CustomArray)createTurnOffCmd:(NSString*)mac;
+(CustomArray)createMacAddressCmd:(NSString*)mac;

/*
 解析
 */
+(SSCmdType)getCmdType:(Byte*)data;
+(SSCmdType*)analysisTurnOnOrOff:(Byte)data;


+(SSWorkState)getStatByData:(Byte*)data;

+(BOOL)checkAvailable:(Byte*)data;
+(BOOL)checkConfigAvailable:(Byte*)data;

@end
