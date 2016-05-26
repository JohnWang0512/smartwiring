//
//  DevicePowerEntity.m
//  SmartWiring
//
//  Created by 陈 远 on 13-8-11.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import "DevicePowerEntity.h"

@implementation DevicePowerEntity
@synthesize macAddress;
@synthesize statu;
@synthesize power;
@synthesize duShu;
@synthesize devStatu;

-(id)initWithData:(Byte*)data
{
    if ([super init]) {
        CustomArray bMac = [Global getArrayByCount:6];
        CustomArray bPower = [Global getArrayByCount:4];
        CustomArray bDu = [Global getArrayByCount:4];
        Byte len = data[3];
        len += 0x08;
        int iMacIndex = 0;
        int iPowerIndex = 0;
        int iDuIndex = 0;
        
        for (int i = 9;i <= len;i++) {
            if (i > 8 && i < 15) {
                bMac.byteArray[iMacIndex] = data[i];
                iMacIndex++;
            }
            else if (i == 16) {
                statu = data[i];
            }
            else if (i >= 18 && i < 22) {
                bPower.byteArray[iPowerIndex] = data[i];
                iPowerIndex++;
            }
            else if (i > 22 && i <=26) {
                bDu.byteArray[iDuIndex] = data[i];
                iDuIndex++;
            }
        }
        
        macAddress = [NSString stringWithUTF8String:(char*)bMac.byteArray];
        
        union floatByte powerfb;
        powerfb.b[0] = bPower.byteArray[0];
        powerfb.b[1] = bPower.byteArray[1];
        powerfb.b[2] = bPower.byteArray[2];
        powerfb.b[3] = bPower.byteArray[3];
        
        union floatByte dushufb;
        dushufb.b[0] = bDu.byteArray[0];
        dushufb.b[1] = bDu.byteArray[1];
        dushufb.b[2] = bDu.byteArray[2];
        dushufb.b[3] = bDu.byteArray[3];
        
        power = powerfb.f;
        duShu = dushufb.f;
        
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
