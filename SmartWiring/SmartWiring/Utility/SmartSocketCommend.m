//
//  SmartSocketCommend.m
//  SmartWiring
//
//  Created by alex wang on 13-8-1.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import "SmartSocketCommend.h"


@implementation SmartSocketCommend

/*
 租帧(第一段)

 帧头      功能码     数据长度      数据      校验位     帧尾
 2b         1b          2b       unknow      1b       2b
 $$       0x05       data len     data      0x00      ##
 */

+(CustomArray)createFrames:(CustomArray)data
{
    int iIndex = 0;
    //根据长度计算出最终包的大小，并创建数组
    
    long iLastLen = 2+1+2+data.count+1+2;
    
    CustomArray buffer = [Global getArrayByCount:iLastLen];
    //帧头
    buffer.byteArray[iIndex++] = DEF_HEAD;
    buffer.byteArray[iIndex++] = DEF_HEAD;
    //功能码
    buffer.byteArray[iIndex++] = DEF_SMARTSOCKET;
    
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


/*
 数据帧 （第二段）
 symbol(1byte) + len(2byte) + date(N byte)
 */
+(CustomArray)createDataFrames:(Byte)funId datas:(CustomArray)datas
{
    int iIndex = 0;
    int iCount = 1+2+datas.count;
    CustomArray cmd = [Global getArrayByCount:iCount];
    cmd.byteArray[iIndex++] = funId;
    cmd.byteArray[iIndex++] = [Global getLow:datas.count];
    cmd.byteArray[iIndex++] = [Global getHigh:datas.count];
    
    for (int i = 0;i < iCount;i++) {
        cmd.byteArray[iIndex++] = datas.byteArray[i];
    }
    return cmd;
}

/*
 查询设备信息
 */
+(CustomArray)fetchDeviceInfo:(NSString*)mac
{
    CustomArray cmd = [SmartSocketCommend createFrames:[SmartSocketCommend createDataFrames:DEF_GET_DEVICE_INFO datas:[SmartSocketCommend createMacAddressCmd:mac]]];
    return cmd;
}

/*
 查询设备状态
 */

+(CustomArray)fetchDeviceStat:(NSString*)mac
{
    CustomArray cmd = [SmartSocketCommend createFrames:[SmartSocketCommend createDataFrames:DEF_GET_DEVICE_STAT datas:[SmartSocketCommend createMacAddressCmd:mac]]];
    return cmd;
}

/*
 查询设备版本
 */
+(CustomArray)fetchDeviceVersion:(NSString*)mac
{
    CustomArray cmd = [SmartSocketCommend createFrames:[SmartSocketCommend createDataFrames:DEF_QUARY_SS_VER datas:[SmartSocketCommend createMacAddressCmd:mac]]];
    return cmd;
}

/*
 查询功率
 */
+(CustomArray)fetchDevicePower:(NSString*)mac
{
    CustomArray cmd = [SmartSocketCommend createFrames:[SmartSocketCommend createDataFrames:DEF_QUARY_SS_POWER datas:[SmartSocketCommend createMacAddressCmd:mac]]];
    return cmd;
}

/*
 发送控制插座开
 */
+(CustomArray)createTurnOnCmd:(NSString*)mac
{
    CustomArray cmd = [SmartSocketCommend createFrames:[SmartSocketCommend createDataFrames:DEF_OPERATE_OPEN_SS datas:[SmartSocketCommend createMacAddressCmd:mac]]];
    return cmd;
}

/*
 发送控制插座关
 */
+(CustomArray)createTurnOffCmd:(NSString*)mac
{
    CustomArray cmd = [SmartSocketCommend createFrames:[SmartSocketCommend createDataFrames:DEF_OPERATE_CLOSE_SS datas:[SmartSocketCommend createMacAddressCmd:mac]]];
    return cmd;
}

/*
    只创建长度+mac地址
 */
+(CustomArray)createMacAddressCmd:(NSString*)mac
{
    int iIndex = 0;
    CustomArray macCmd = [Global getArrayByCount:7];
    macCmd.byteArray[iIndex++] = DEF_MACLEN;
    
    NSArray *a = [mac componentsSeparatedByString:@":"];
    
    for (int i = 0; i < a.count; i++) {
        NSString *s = [a objectAtIndex:i];
        macCmd.byteArray[iIndex++] = [Global getIntByString:s];
    }
    return macCmd;
}


#pragma mark - Analysis



/*
 获取数据源的第六位-标识码字段
 兼判断包的正确性，不正确则直接返回cmd_null
 */
+(SSCmdType)getCmdType:(Byte*)data
{
    
    if ([SmartSocketCommend checkAvailable:data]) {
        Byte type = data[5];
        switch (type) {
            case DEF_GET_DEVICE_STAT_ACK:
                //查询设备状态返回
                return CMD_QUARY_SS_STATE;
                break;
                
            case DEF_GET_DEVICE_INFO_ACK:
                //查询设备信息
                return CMD_QUARY_SS_INFO;
                break;
                
            case DEF_BROCDCAST_QUARY_SS_ACK:
                //广播查询设备返回
                return CMD_BROCDCAST_QUARY_SS;
                break;
                
            case DEF_QUARY_SS_VER_ACK:
                //查询设备版本号返回
                return CMD_QUARY_SS_VER;
                break;
                
            case DEF_OPERATE_SS_ACK:
                //操作设备(打开/关闭)返回
                return CMD_OPERATE_SS;
                break;
                
            case DEF_QUARY_SS_POWER_ACK:
                //查询功耗信息返回
                return CMD_QUARY_SS_POWER;
                break;
                
            default:
                break;
        }
        return CMD_NULL;
    } else {
        return CMD_NULL;
    }
}

/*
 检查帧头、帧尾、功能码和命令类型标志功能
 */

+(BOOL)checkAvailable:(Byte*)data
{
    //int len = GET_ARRAY_LEN(data);
    Byte len = data[3];
    len += 0x08;
    if (data[0] == DEF_HEAD) {
        if (data[1] == DEF_HEAD) {
            if (data[2] == DEF_SMARTSOCKET) {
                if (data[len-1] == DEF_END) {
                    if (data[len-2] == DEF_END) {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}

+(BOOL)checkConfigAvailable:(Byte*)data
{
    //int len = GET_ARRAY_LEN(data);

    if (data[0] == DEF_HEAD) {
        if (data[1] == DEF_HEAD) {
            if (data[2] == DEF_CONFIG_CODE) {
                if (data[13] == DEF_END) {
                    if (data[14] == DEF_END) {
                        return YES;
                    }
                }
            }
        }
    }
    return NO;
}


+(SSWorkState)getStatByData:(Byte*)data
{
    Byte b = data[15];
    switch (b) {
        case 0x00:
            return NOTCONNECTSERVER;
            break;
        case 0x01:
            return CONNECTSERVER;
            break;
        case 0x02:
            return WORKNORMAL;
            break;
        case 0x03:
            return WORKSLEEP;
            break;
        case 0x04:
            return ERROR;
            break;
            
        default:
            return ERROR;
            break;
    }
}


+(SSCmdType*)analysisTurnOnOrOff:(Byte)data
{
    return 0;
}



@end
