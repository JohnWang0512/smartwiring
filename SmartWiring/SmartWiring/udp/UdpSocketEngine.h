//
//  UdpSocketEngine.h
//  SmartWiring
//
//  Created by 王义吉 on 8/1/13.
//  Copyright (c) 2013 王义吉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AsyncUdpSocket.h"

@interface UdpSocketEngine : NSObject
{
    
}

+(AsyncUdpSocket*)getInstance:(id)delegate;
+(void)alertFaild;
@end
