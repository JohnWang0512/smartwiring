//
//  DeviceStatuEntity.m
//  SmartWiring
//
//  Created by 陈 远 on 13-8-11.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import "DeviceStatuEntity.h"

@implementation DeviceStatuEntity
@synthesize macAddress;
@synthesize statuByte;
@synthesize devStatu;

-(id)initWithData:(Byte*)data
{
    if ([self init]) {
        CustomArray macByte = [Global getArrayByCount:6];
        statuByte = data[16];
        
        int iIndex = 0;
        for (int i = 9; i < macByte.count + 8; i++) {
            if (i > 8 && i < 15) {
                macByte.byteArray[iIndex] = data[i];
                iIndex++;
            }
        }
        
        macAddress = [NSString stringWithUTF8String:(char*)macByte.byteArray];
        
        switch (statuByte) {
            case 0x00:
                devStatu = NOTCONNECTSERVER;
                break;
            case 0x01:
                devStatu = CONNECTSERVER;
                break;
            case 0x02:
                devStatu = WORKNORMAL;
                break;
            case 0x03:
                devStatu = WORKSLEEP;
                break;
            case 0x04:
                devStatu = ERROR;
                break;
                
            default:
                break;
        }
        
    }
    return self;
}

@end
