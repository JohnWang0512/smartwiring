//
//  DeviceStatuEntity.h
//  SmartWiring
//
//  Created by 陈 远 on 13-8-11.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceStatuEntity : NSObject
{
    NSString *macAddress;
    Byte statuByte;
    SSWorkState devStatu;
}
@property (nonatomic,retain) NSString *macAddress;
@property (nonatomic) Byte statuByte;
@property (nonatomic) SSWorkState devStatu;

-(id)initWithData:(Byte*)data;

@end
