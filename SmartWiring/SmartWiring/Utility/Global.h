//
//  Global.h
//  SmartWiring
//
//  Created by 王义吉 on 8/1/13.
//  Copyright (c) 2013 王义吉. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "IPAddress.h"

#define GET_ARRAY_LEN(array) sizeof(array)// / sizeof(array[1])

#define DEF_HOST        @"61.177.24.118"
#define DEF_LAN_Port    6810        //局域网
#define DEF_WAN_Port    5050        //广域网

#define DEF_TIMEOUT     5

#define AppDelegateEntity ((AppDelegate *)[UIApplication sharedApplication].delegate)

#define DEF_HEAD                    0x24    // 帧头  - $
#define DEF_END                     0x23    // 帧尾  - #
#define DEF_SMARTSOCKET             0x05    // 插座功能码
#define DEF_CONFIG_CODE             0xfe    // 配置功能码

#define DEF_GET_DEVICE_STAT         0x80    //查询设备状态
#define DEF_GET_DEVICE_STAT_ACK     0x81    //返回查询设备状态

#define DEF_GET_DEVICE_INFO         0x86    //查询设备信息
#define DEF_GET_DEVICE_INFO_ACK     0x87    //返回查询设备信息


#define DEF_BROCDCAST_QUARY_SS      0x19    // 广播-查询设备
#define DEF_BROCDCAST_QUARY_SS_ACK  0x1a    // 广播-查询设备返回

#define DEF_QUARY_SS_VER            0x9c    // 查询设备版本号
#define DEF_QUARY_SS_VER_ACK        0x9d    // 查询设备版本号返回

#define DEF_OPERATE_OPEN_SS         0xa0    // 打开设备
#define DEF_OPERATE_CLOSE_SS        0xa1    // 关闭设备
#define DEF_OPERATE_SS_ACK          0xa3    // 操作设备(打开/关闭)返回

#define DEF_QUARY_SS_POWER          0xa6    // 查询功耗信息
#define DEF_QUARY_SS_POWER_ACK      0xa7    // 查询功耗信息返回

#define DEF_CHECKBIT                0x00    // 校验位
#define DEF_PACKETMINLEN            0x08    // 包最小长度
#define DEF_MACLEN                  0x06    // MAC地址长度
#define DEF_DATAPARTMINLEN          0x03    // 数据字段最小长度

#define DEF_BORDCASTTAG             0xfe    //广播功能码

#define DEF_GLOABL_FLAG             0x80    // 广域网命令标识码


#define DEF_DEVICE_STATU_CLOSE          0x00    //关闭
#define DEF_DEVICE_STATU_CLOSE_FALD     0x01    //关闭失败
#define DEF_DEVICE_STATU_OPEN           0x02    //打开
#define DEF_DEVICE_STATU_OPEN_FALD      0x03    //打开露点错误
#define DEF_DEVICE_STATU_NOWORK         0x04    //打开出错，未工作

#define DEF_KEY_SENDDATA             @"sendData"
#define DEF_KEY_COUNT                @"count"
#define DEF_KEY_MACADDRESS           @"macaddress"

#define DEF_KEY_SERVERNAME           @"servername"
#define DEF_KEY_SERVERPORT           @"serverport"


union floatByte
{
    Byte b[4];
    float f;
};

union macByteString
{
    Byte b[6];
    NSString *strMac;
};

typedef enum
{
    cmdssid = 0,
    cmdPWD,
    cmdIp,
    cmdPort
}configType;

typedef struct
{
    Byte *byteArray;
    int count;
}CustomArray;

////三次请求协议
//typedef struct
//{
//    NSData *sendData;
//    int count;
//    NSString *sMacAddress;
//}SendDataItem;


/* 插座操作状态 */
typedef enum
{
    CLOSE = 0,          // 关闭
    CLOSE_ERROR,        // 关闭失败
    OPEN,               // 打开
    OPEN_LEAKAGE,       // 打开漏电出错
    OPEN_NOT_WORK,      // 打开未工作
    ERROR_LEAKAGE       // 漏电出错
}SSOperateState;

/* 插座工作状态 */
typedef enum
{
    NOTCONNECTSERVER = 0,   // 未连接服务器
    CONNECTSERVER,          // 已经连接服务器
    WORKNORMAL,             // 正常工作
    WORKSLEEP,              // 休眠状态，节能
    ERROR                   // 出错
}SSWorkState;

/* 命令类型 */
typedef enum
{
    CMD_NULL = 0,             // 空命令
    CMD_QUARY_SS_STATE,       // 查询设备状态命令
    CMD_QUARY_SS_INFO,        // 查询设备信息命令
    CMD_BROCDCAST_QUARY_SS,   // 广播-查询设备命令
    CMD_QUARY_SS_VER,         // 查询设备版本号命令
    CMD_OPERATE_SS,           // 打开设备命令
    CMD_QUARY_SS_POWER        // 查询功耗信息命令
}SSCmdType;

typedef enum
{
    openStatu,
    closeStatus,
    loadingStatus
}DeviceStatu;


@interface Global : NSObject

+(NSString*)getBordCastIp;

+(CustomArray)getArrayByCount:(int)iCount;

+(Byte)getHigh:(int)iLen;
+(Byte)getLow:(int)iLen;

+(CustomArray)intToByte:(int)iValue;
+(int)byteToInt:(Byte*)b;

+(Byte*)floatToByte:(float)fValue;
+(float)byteToFloat:(Byte*)b;

+(int)getCharHexValue:(char)c;
+(int)getIntByString:(NSString*)str;
+(Byte*)string2Byte:(NSString*)s;
+(CustomArray)int2Byte:(int)iValue;

+(NSString*)byteMacToString:(Byte*)t;

+(BOOL)sendUdp:(AsyncUdpSocket*)udpSocket data:(NSData*)data mac:(NSString*)sMac tag:(long)lTag;

//显示全局的dialog
+(void)showMbDialog:(UIView*)view title:(NSString*)sTitle;
//隐藏全局的dialog
+(void)hiddenDialog;



@end
