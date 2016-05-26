//
//  DeviceEntity.m
//  SmartWiring
//
//  Created by 陈 远 on 13-8-23.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import "DeviceEntity.h"

@implementation DeviceEntity
@synthesize mac;

-(id)initWithData:(Byte*)data
{
    if ([self init]) {
        CustomArray macByte = [Global getArrayByCount:6];
        
        int macIndex = 0;
        for (int i = 9; i < macByte.count + 8; i++) {
            if (i > 8 && i < 15) {
                macByte.byteArray[macIndex] = data[i];
                macIndex++;
            }
        }
        mac = [NSString stringWithUTF8String:(char*)macByte.byteArray];
    }
    return self;
}
@end
