//
//  ConfigCommend.m
//  SmartWiring
//
//  Created by 陈 远 on 13-8-3.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import "ConfigCommend.h"

#define DEF_CONFIG_SSID         0x01    //修改SSID
#define DEF_CONFIG_PWD          0x02    //修改密码
#define DEF_CONFIG_IP           0x03    //修改ip地址
#define DEF_CONFIG_WORKMODEL    0x04    //修改模块工作类型
#define DEF_CONFIG_PORT         0x07    //修改端口号
#define DEF_CONFIG_SUBMIT       0x08    //提交配置



@implementation ConfigCommend

//获取包的总长度
+(int)getAllFrameCount:(NSString*)ssid pwd:(NSString*)pwd ip:(NSString*)sIp port:(int)iPort
{
    int ssidCount = 9+ssid.length;
    int pwdCount = 9+pwd.length;
    int ipCount = 9+sIp.length;
    int workModelCount = 10;
    int portCount = 9+2;
    return ssidCount+pwdCount+ipCount+workModelCount+portCount;
}

//把5个分包组成一个包
+(CustomArray)createLastFrames:(NSString*)ssid pwd:(NSString*)pwd ip:(NSString*)sIp port:(int)iPort
{
    int iCount = [ConfigCommend getAllFrameCount:ssid pwd:pwd ip:sIp port:iPort];
    CustomArray cmd = [Global getArrayByCount:iCount];
    
    CustomArray ssidCmd = [ConfigCommend configSSID:ssid];
    CustomArray pwdCmd = [ConfigCommend configPWD:pwd];
    CustomArray ipCmd = [ConfigCommend configIP:sIp];
    CustomArray workModelCmd = [ConfigCommend configWorkModel];
    CustomArray portCmd = [ConfigCommend configPort:iPort];
    
    int iIndex = 0;
    for (int i = 0; i<ssidCmd.count; i++) {
        cmd.byteArray[iIndex++] = ssidCmd.byteArray[i];
    }
    
    for (int i = 0; i<pwdCmd.count; i++) {
        cmd.byteArray[iIndex++] = pwdCmd.byteArray[i];
    }
    
    for (int i = 0; i<ipCmd.count; i++) {
        cmd.byteArray[iIndex++] = ipCmd.byteArray[i];
    }
    for (int i = 0; i<workModelCmd.count; i++) {
        cmd.byteArray[iIndex++] = workModelCmd.byteArray[i];
    }
    for (int i = 0; i<portCmd.count; i++) {
        cmd.byteArray[iIndex++] = portCmd.byteArray[i];
    }
    return cmd;
}

/*
 租帧(第一段)
 
 帧头      功能码     数据长度      数据      校验位     帧尾
 2b         1b          2b       unknow      1b       2b
 $$       0x05       data len     data      0x00      ##
 */
+(CustomArray)createConfigFrames:(CustomArray)data
{
    int iIndex = 0;
    //根据长度计算出最终包的大小，并创建数组
    
    long iLastLen = 2+1+2+data.count+1+2;
    
    CustomArray buffer = [Global getArrayByCount:iLastLen];
    //帧头
    buffer.byteArray[iIndex++] = DEF_HEAD;
    buffer.byteArray[iIndex++] = DEF_HEAD;
    //功能码
    buffer.byteArray[iIndex++] = DEF_CONFIG_CODE;
    
    //长度
    buffer.byteArray[iIndex++] = [Global getLow:data.count];
    buffer.byteArray[iIndex++] = [Global getHigh:data.count];
    
    //数据
    for (int i = 0;i < data.count;i++) {
        buffer.byteArray[iIndex++] = data.byteArray[i];
    }
    
    //校验码
    buffer.byteArray[iIndex++] = DEF_CHECKBIT;
    //帧尾
    buffer.byteArray[iIndex++] = DEF_END;
    buffer.byteArray[iIndex++] = DEF_END;
    
    for (int i = 0; i< buffer.count;i++ ) {
        NSLog(@"buffer  %x",buffer.byteArray[i]);
    }
    
    //释放数据段
    free(data.byteArray);
    return buffer;
}

//修改SSID
+(CustomArray)configSSID:(NSString*)ssid
{
    int iIndex = 0;
    Byte *sByte = [Global string2Byte:ssid];
    CustomArray ssidbyte = [Global getArrayByCount:ssid.length+1];
    ssidbyte.byteArray[iIndex++] = DEF_CONFIG_SSID;
    for (int i = 0;i<ssid.length;i++) {
        ssidbyte.byteArray[iIndex++] = sByte[i];
    }
    CustomArray cmd = [ConfigCommend createConfigFrames:ssidbyte];
    return cmd;
}

//修改密码
+(CustomArray)configPWD:(NSString*)pwd
{
    int iIndex = 0;
    Byte *sByte = [Global string2Byte:pwd];
    CustomArray pwdbyte = [Global getArrayByCount:pwd.length+1];
    pwdbyte.byteArray[iIndex++] = DEF_CONFIG_PWD;
    for (int i = 0;i<pwd.length;i++) {
        pwdbyte.byteArray[iIndex++] = sByte[i];
    }
    CustomArray cmd = [ConfigCommend createConfigFrames:pwdbyte];
    return cmd;
}

//修改IP
+(CustomArray)configIP:(NSString*)ip
{
    int iIndex = 0;
    Byte *sByte = [Global string2Byte:ip];
    CustomArray ipByte = [Global getArrayByCount:ip.length+1];
    ipByte.byteArray[iIndex++] = DEF_CONFIG_IP;
    for (int i = 0;i<ip.length;i++) {
        ipByte.byteArray[iIndex++] = sByte[i];
    }
    CustomArray cmd = [ConfigCommend createConfigFrames:ipByte];
    return cmd;
}

//修改工作状态
+(CustomArray)configWorkModel
{
    int iIndex = 0;
    CustomArray modelbyte = [Global getArrayByCount:2];
    modelbyte.byteArray[iIndex++] = DEF_CONFIG_WORKMODEL;
    modelbyte.byteArray[iIndex++] = 0x02;
    CustomArray cmd = [ConfigCommend createConfigFrames:modelbyte];
    return cmd;
}

//修改端口号
+(CustomArray)configPort:(int)iPort
{
    int iIndex = 0;
    CustomArray portIntByte = [Global int2Byte:iPort];
    CustomArray portByte = [Global getArrayByCount:portIntByte.count+1];
    portByte.byteArray[iIndex++] = DEF_CONFIG_PORT;
    portByte.byteArray[iIndex++] = portIntByte.byteArray[0];
    portByte.byteArray[iIndex++] = portIntByte.byteArray[1];
    CustomArray cmd = [ConfigCommend createConfigFrames:portByte];
    return cmd;
}


@end
