//
//  Device.h
//  SmartWiring
//
//  Created by 陈 远 on 13-8-10.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Device : NSManagedObject

@property (nonatomic, retain) NSString * icon;
@property (nonatomic, retain) NSString * mac;
@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * gonglv;
@property (nonatomic, retain) NSString * version;

@end
