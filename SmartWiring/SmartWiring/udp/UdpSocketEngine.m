//
//  UdpSocketEngine.m
//  SmartWiring
//
//  Created by 王义吉 on 8/1/13.
//  Copyright (c) 2013 王义吉. All rights reserved.
//

#import "UdpSocketEngine.h"

static AsyncUdpSocket *_instance = nil;
@implementation UdpSocketEngine


+(AsyncUdpSocket*)getInstance:(id)delegate{
    @synchronized(self){
        if (_instance == nil) {
            _instance = [[AsyncUdpSocket alloc] init];
        }
        _instance.delegate = delegate;
    }
	return _instance;
}

+(void)alertFaild
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                    message:@"发送失败"
                                                   delegate:nil
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
}
@end
