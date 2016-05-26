//
//  Global.m
//  SmartWiring
//
//  Created by 王义吉 on 8/1/13.
//  Copyright (c) 2013 王义吉. All rights reserved.
//

#import "Global.h"

@implementation Global
+(NSString*)getBordCastIp
{
    FreeAddresses();
    GetIPAddresses();

//    NSString *sIp1 = [NSString stringWithFormat:@"%s",ip_names[0]];
    NSString *sIp = @"";
    NSString *sIp1 = @"";
    NSString *sIp2 = @"";
    if (ip_names[1]) {
        sIp1 = [NSString stringWithFormat:@"%s",ip_names[1]];
    }
    if (ip_names[0]) {
        sIp = [NSString stringWithFormat:@"%s",ip_names[0]];
    }
    if (ip_names[2]) {
        sIp2 = [NSString stringWithFormat:@"%s",ip_names[2]];
    }
    
    NSArray *a = [sIp componentsSeparatedByString:@"."];
    NSArray *a1 = [sIp1 componentsSeparatedByString:@"."];
    NSArray *a2 = [sIp2 componentsSeparatedByString:@"."];
    
    NSArray *aLast = nil;
    if ([[a objectAtIndex:0] isEqualToString:@"192"]) {
        aLast = a;
    }
    else if ([[a1 objectAtIndex:0] isEqualToString:@"192"]) {
        aLast = a1;
    }
    else if ([[a2 objectAtIndex:0] isEqualToString:@"192"]) {
        aLast = a2;
    }
    
    NSString *lastIp = [NSString stringWithFormat:@"%@.%@.%@.255",[aLast objectAtIndex:0],[aLast objectAtIndex:1],[aLast objectAtIndex:2]];
    
    return lastIp;
}

+(CustomArray)getArrayByCount:(int)iCount
{
    CustomArray array;
    array.byteArray = (Byte*)calloc(iCount, sizeof(Byte));
    array.count = iCount;    
    return array;
}

//高八位
+(Byte)getHigh:(int)iLen
{
    return (Byte)iLen >> 8;
}

//低八位
+(Byte)getLow:(int)iLen
{
    return (Byte)iLen & 0x00ff;
}

//int 转 byte
+(CustomArray)intToByte:(int)iValue
{
    CustomArray ca = [Global getArrayByCount:4];
    for (int i = 0; i<4; i++) {
        ca.byteArray[i] = (Byte)(iValue >> 8 * (3-i) & 0xff);
    }
    return ca;
}

//byte 转 int
+(int)byteToInt:(Byte*)b
{
    int iValue = 0;
    for (int i = 0;i < GET_ARRAY_LEN(b);i++) {
        iValue += (b[i] & 0xff) << (8*(3-i));
    }
    return iValue;
}

+(CustomArray)int2Byte:(int)iValue
{
    CustomArray ca = [Global getArrayByCount:2];
    ca.byteArray[0] = iValue&0xff;
    ca.byteArray[1] = (iValue&0xff00) >> 8;
    return ca;
}

+(Byte*)floatToByte:(float)fValue
{
    Byte bAry[4];
    Byte *lpAry = (Byte*)bAry;
    *(float*)lpAry = fValue;
    return lpAry;
}

+(float)byteToFloat:(Byte*)b
{
    union floatByte fb;
    fb.b[0] = b[0];
    fb.b[1] = b[1];
    fb.b[2] = b[2];
    fb.b[3] = b[3];
    return fb.f;
}


+(int)getIntByString:(NSString*)str
{
    const char *b = [str UTF8String];
    int i1 = [Global getCharHexValue:b[0]];
    int i2 = [Global getCharHexValue:b[1]];
    int iLast = i1*16+i2;
    return iLast;
}

/*
 * 函数名: getCharHexValue()
 * 参数  : char c
 * 功能  : 将十六进制字符c转换为对应的int型值
 * 返回  : 成功返回正确的值，错误返回-1
 */

+(int)getCharHexValue:(char)c
{
    int res = 0;
    
    if (c >= 48 && c <= 57) {         /* 0-9 */
        res = c - 48;
    } else if (c >= 97 && c <= 102) {   /* a-f */
        res = c - 87;
    } else {                         /* 非法 */
        res = -1;
    }
    return res;
}

+(Byte*)string2Byte:(NSString*)s
{
    NSData *bytes = [s dataUsingEncoding:NSUTF8StringEncoding];
    Byte *myByte = (Byte *)[bytes bytes];
    return myByte;
}


+(NSString*)byteMacToString:(Byte*)t
{
   return [NSString stringWithFormat:@"%02x:%02x:%02x:%02x:%02x:%02x",t[0],t[1],t[2],t[3],t[4],t[5]];
}

+(BOOL)sendUdp:(AsyncUdpSocket*)udpSocket data:(NSData*)data mac:(NSString*)sMac tag:(long)lTag
{
    NSDictionary *obj = [AppDelegateEntity.sendDic objectForKey:[NSNumber numberWithLong:lTag]];
    if (obj) {
        NSNumber *num = [obj objectForKey:DEF_KEY_COUNT];
        if ([num integerValue] >= 3) {
            return YES;
        }
    } else {
        
        NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
        [dic setValue:data forKey:DEF_KEY_SENDDATA];
        [dic setValue:[NSNumber numberWithInt:0] forKey:DEF_KEY_COUNT];
        [dic setValue:sMac forKey:DEF_KEY_MACADDRESS];
        
        [AppDelegateEntity.sendDic setObject:dic forKey:[NSNumber numberWithLong:lTag]];
    }
    [udpSocket receiveWithTimeout:DEF_TIMEOUT tag:lTag];
    
    NSString *sServerName = [[NSUserDefaults standardUserDefaults] objectForKey:DEF_KEY_SERVERNAME];
    NSString *sPort = [[NSUserDefaults standardUserDefaults] objectForKey:DEF_KEY_SERVERPORT];
    
    
    if (sServerName.length == 0) {
        sServerName = DEF_HOST;
    }
    if (sPort.length == 0) {
        sPort = [NSString stringWithFormat:@"%d",DEF_WAN_Port];
    }
    
    return [udpSocket sendData:data
                      toHost:sServerName
                        port:[sPort integerValue]
                 withTimeout:DEF_TIMEOUT
                         tag:lTag];
}

+(void)showMbDialog:(UIView*)view title:(NSString*)sTitle
{
    if (AppDelegateEntity.HUD) {
        [AppDelegateEntity.HUD release];
        AppDelegateEntity.HUD = nil;
    }
    AppDelegateEntity.HUD = [[MBProgressHUD alloc] initWithView:view];
    [view addSubview:AppDelegateEntity.HUD];
    [view bringSubviewToFront:AppDelegateEntity.HUD];
    AppDelegateEntity.HUD.labelText = sTitle;
    [AppDelegateEntity.HUD show:YES];
}

+(void)hiddenDialog
{
    if (AppDelegateEntity.HUD) {
        [AppDelegateEntity.HUD removeFromSuperview];
        AppDelegateEntity.HUD = nil;
    }
}

@end
