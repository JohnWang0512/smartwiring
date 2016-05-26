//
//  DeviceOpenEntity.h
//  SmartWiring
//
//  Created by 陈 远 on 13-8-11.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceOpenEntity : NSObject
{
    NSString *mac;
    Byte statu;
    SSOperateState devStatu;
}
@property (nonatomic,retain) NSString *mac;
@property (nonatomic) Byte statu;
@property (nonatomic) SSOperateState devStatu;

-(id)initWithData:(Byte*)data;
@end
