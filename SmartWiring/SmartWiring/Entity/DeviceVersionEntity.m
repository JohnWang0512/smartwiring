//
//  DeviceVersionEntity.m
//  SmartWiring
//
//  Created by 陈 远 on 13-8-11.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import "DeviceVersionEntity.h"

@implementation DeviceVersionEntity
@synthesize macAddress;
@synthesize version;

-(id)initWithData:(Byte*)data
{
    if ([self init]) {
        
        CustomArray macByte = [Global getArrayByCount:6];
        Byte versionCount = data[15];
        CustomArray versionByte = [Global getArrayByCount:versionCount];
        Byte len = data[3];
        len += 0x08;
        
        int macIndex = 0;
        int versionIndex = 0;
        for (int i = 9;i < len; i++) {
            if (i>8 && i < 15) {
                macByte.byteArray[macIndex] = data[i];
                macIndex++;
            }
            if (i > 15 && i< (15+versionCount+1)) {
                versionByte.byteArray[versionIndex] = data[i];
                versionIndex++;
            }
        }
        
        macAddress = [NSString stringWithUTF8String:(char*)macByte.byteArray];
        version = [NSString stringWithUTF8String:(char*)versionByte.byteArray];
    }
    return self;
}
@end
