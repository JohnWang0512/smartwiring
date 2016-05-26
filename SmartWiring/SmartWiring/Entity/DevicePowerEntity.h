//
//  DevicePowerEntity.h
//  SmartWiring
//
//  Created by 陈 远 on 13-8-11.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DevicePowerEntity : NSObject
{
    NSString *macAddress;
    Byte statu;
    float power;
    float duShu;
    SSOperateState devStatu;
}

@property (nonatomic,retain) NSString *macAddress;
@property (nonatomic) Byte statu;
@property (nonatomic) float power;
@property (nonatomic) float duShu;
@property (nonatomic) SSOperateState devStatu;

-(id)initWithData:(Byte*)data;
@end
