//
//  DeviceInfoEntity.h
//  SmartWiring
//
//  Created by 陈 远 on 13-8-11.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceInfoEntity : NSObject
{
    NSString *macAddress;
    NSString *password;
    NSString *name;
    NSString *state;
}

@property (nonatomic,retain) NSString *macAddress;
@property (nonatomic,retain) NSString *password;
@property (nonatomic,retain) NSString *name;
@property (nonatomic,retain) NSString *state;

-(id)initWithData:(Byte*)data;
@end
