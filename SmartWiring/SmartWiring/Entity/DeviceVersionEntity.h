//
//  DeviceVersionEntity.h
//  SmartWiring
//
//  Created by 陈 远 on 13-8-11.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceVersionEntity : NSObject
{
    NSString *macAddress;
    NSString *version;
}
@property (nonatomic,retain) NSString *macAddress;
@property (nonatomic,retain) NSString *version;
-(id)initWithData:(Byte*)data;
@end
