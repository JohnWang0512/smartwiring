//
//  DeviceInfoEntity.m
//  SmartWiring
//
//  Created by 陈 远 on 13-8-11.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import "DeviceInfoEntity.h"

@implementation DeviceInfoEntity
@synthesize macAddress;
@synthesize password;
@synthesize name;
@synthesize state;
-(id)initWithData:(Byte*)data
{
    if ([self init]) {
        Byte macCount = data[8];                                    //6
        Byte pwdCount = data[8+macCount+1];                         //15
        Byte nameCount = data[8+macCount+1+pwdCount+1];             //19
        Byte statCount = data[8+macCount+1+pwdCount+1+nameCount+1]; //24
        
        CustomArray macByte = [Global getArrayByCount:macCount];
        CustomArray pwdByte = [Global getArrayByCount:pwdCount];
        CustomArray nameByte = [Global getArrayByCount:nameCount];
        CustomArray statByte = [Global getArrayByCount:statCount];
        
        int macIndex = 0;
        int pwdIndex = 0;
        int nameIndex = 0;
        
        int iDataCount = GET_ARRAY_LEN(data);
        for (int i = 8; i < iDataCount; i++) {
            if (i > 8 && i<= (8+macCount)) {
                macByte.byteArray[macIndex] = data[i];
                macIndex++;
            }
            if (i > (8+macCount+1) && i <= (8+macCount+1+pwdCount)) {
                pwdByte.byteArray[pwdIndex] = data[i];
                pwdIndex++;
            }
            if (i > (8+macCount+1+pwdCount+1) && i<= (8+macCount+1+pwdCount+1+nameCount)) {
                nameByte.byteArray[nameIndex] = data[i];
                nameIndex++;
            }
            if (i == (iDataCount-2)) {
                statByte.byteArray[0] = data[i];
            }
        }
        
        macAddress = [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",
                      macByte.byteArray[0],
                      macByte.byteArray[1],
                      macByte.byteArray[2],
                      macByte.byteArray[3],
                      macByte.byteArray[4],
                      macByte.byteArray[5]];
        
        password = [NSString stringWithUTF8String:(char*)pwdByte.byteArray];
        name = [NSString stringWithUTF8String:(char*)nameByte.byteArray];
        state = [NSString stringWithUTF8String:(char*)statByte.byteArray];
        
    }
    return self;
}
@end












