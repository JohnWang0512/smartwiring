//
//  DeviceEntity.h
//  SmartWiring
//
//  Created by 陈 远 on 13-8-23.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DeviceEntity : NSObject
{
    NSString *mac;
}
@property (nonatomic,retain) NSString *mac;
-(id)initWithData:(Byte*)data;
@end
