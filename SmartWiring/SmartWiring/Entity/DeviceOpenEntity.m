//
//  DeviceOpenEntity.m
//  SmartWiring
//
//  Created by 陈 远 on 13-8-11.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import "DeviceOpenEntity.h"

@implementation DeviceOpenEntity
@synthesize mac;
@synthesize statu;
@synthesize devStatu;

-(id)initWithData:(Byte*)data
{
    if ([super init]) {
        CustomArray macByte = [Global getArrayByCount:6];
        
        statu = data[16];
        
        int macIndex = 0;
        for (int i = 9; i < macByte.count + 8; i++) {
            if (i > 8 && i < 15) {
                macByte.byteArray[macIndex] = data[i];
                macIndex++;
            }
        }
        mac = [NSString stringWithUTF8String:(char*)macByte.byteArray];
        
        switch (statu) {
            case DEF_DEVICE_STATU_CLOSE:
                devStatu = CLOSE;
                break;
            case DEF_DEVICE_STATU_CLOSE_FALD:
                devStatu = CLOSE_ERROR;
                break;
            case DEF_DEVICE_STATU_OPEN:
                devStatu = OPEN;
                break;
            case DEF_DEVICE_STATU_OPEN_FALD:
                devStatu = OPEN_LEAKAGE;
                break;
            case DEF_DEVICE_STATU_NOWORK:
                devStatu = OPEN_NOT_WORK;
                break;
                
            default:
                break;
        }
        
    }
    return self;
}
@end
