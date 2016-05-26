//
//  ItemViewController.m
//  SmartWiring
//
//  Created by 王义吉 on 8/8/13.
//  Copyright (c) 2013 王义吉. All rights reserved.
//

#import "ItemViewController.h"

@interface ItemViewController ()

@end

@implementation ItemViewController
@synthesize udpSocket;
@synthesize deviceItem;
@synthesize nowDeviceStatu;
@synthesize sPower;
@synthesize bOpen;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization

    }
    return self;
}

-(void)viewDidAppear:(BOOL)animated
{
    self.udpSocket.delegate = self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设备控制";
    
    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"刷新" style:UIBarButtonItemStylePlain target:self action:@selector(didPressedRefresh)];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];
    
    
    
    lblDeviceTitle.text = deviceItem.name;
    lblMacAddress.text = deviceItem.mac;
    lblPower.text = [NSString stringWithFormat:@"%@W",sPower];
    lblDeviceGonglv.text = [NSString stringWithFormat:@"%@W",sPower];
    lblDeviceName.text = deviceItem.name;
    
    //更多信息
    infoView.alpha = 0;
    infoView.layer.borderWidth = 2;
    infoView.layer.borderColor = [[UIColor greenColor] CGColor];
    infoView.layer.cornerRadius = 8;
    infoView.layer.masksToBounds = YES;
    
    if (nowDeviceStatu == openStatu) {
        [self setLightOn:YES];
    }
    else if (nowDeviceStatu == closeStatus) {
        [self setLightOn:NO];
    }

    // Do any additional setup after loading the view from its nib.
}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (bInfoShow) {
        [self showMoreInfo:NO];
        bInfoShow = NO;
    }
}

-(AsyncUdpSocket *)udpSocket
{
    if (!udpSocket) {
        udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
    }
    return udpSocket;
}

-(void)didPressedRefresh
{
    [self getPower];
}

//获取设备状态
-(void)getLightStat
{
    CustomArray tempCmd = [SmartSocketCommend fetchDeviceStat:deviceItem.mac];
    NSData *sendData = [NSData dataWithBytes:tempCmd.byteArray length:tempCmd.count];
    [Global sendUdp:self.udpSocket data:sendData mac:deviceItem.mac tag:DEF_GET_DEVICE_STAT];
}

//获取设备信息
-(void)getLightInfo
{
    CustomArray tempCmd = [SmartSocketCommend fetchDeviceInfo:deviceItem.mac];
    NSData *sendData = [NSData dataWithBytes:tempCmd.byteArray length:tempCmd.count];
    [Global sendUdp:self.udpSocket data:sendData mac:deviceItem.mac tag:DEF_GET_DEVICE_INFO];
}

//获取设备版本
-(void)getVersion
{
    [Global showMbDialog:self.view title:@"正在获取详细信息"];
    CustomArray tempCmd = [SmartSocketCommend fetchDeviceVersion:deviceItem.mac];
    NSData *sendData = [NSData dataWithBytes:tempCmd.byteArray length:tempCmd.count];
    [Global sendUdp:self.udpSocket data:sendData mac:deviceItem.mac tag:DEF_QUARY_SS_VER];
//    [self testVersion];
}

//获取功率
-(void)getPower
{
    CustomArray tempCmd = [SmartSocketCommend fetchDevicePower:deviceItem.mac];
    NSData *sendData = [NSData dataWithBytes:tempCmd.byteArray length:tempCmd.count];
    [Global sendUdp:self.udpSocket data:sendData mac:deviceItem.mac tag:DEF_QUARY_SS_POWER];
//    [self testPower];
}

//开灯
-(void)openLight
{
    NSLog(@"send open");
    CustomArray tempCmd = [SmartSocketCommend createTurnOnCmd:deviceItem.mac];
    NSData *sendData = [NSData dataWithBytes:tempCmd.byteArray length:tempCmd.count];
    [Global sendUdp:self.udpSocket data:sendData mac:deviceItem.mac tag:DEF_OPERATE_OPEN_SS];
 //   [self testLightOn];
}

//关灯
-(void)closeLight
{
        NSLog(@"send close");
    CustomArray tempCmd = [SmartSocketCommend createTurnOffCmd:deviceItem.mac];
    NSData *sendData = [NSData dataWithBytes:tempCmd.byteArray length:tempCmd.count];
    [Global sendUdp:self.udpSocket data:sendData mac:deviceItem.mac tag:DEF_OPERATE_CLOSE_SS];
//    [self testLightOff];
}

#pragma mark - UPD Delegate
- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    //请求已发出
    NSLog(@"didSendDataWithTag");
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    //解析命令
    NSLog(@"did get data");
    NSString *sMacAddress = [self analysisData:(Byte*)[data bytes] tag:tag];
    
    //根据tag获取请求信息
    NSDictionary *v = [AppDelegateEntity.sendDic objectForKey:[NSNumber numberWithLong:tag]];
    if (v) {
        NSString *sMac = [v objectForKey:DEF_KEY_MACADDRESS];
        
        //通过mac匹配到是发出的命令，则删去标记
        if ([sMac isEqualToString:sMacAddress]) {
            [AppDelegateEntity.sendDic removeObjectForKey:[NSNumber numberWithLong:tag]];
        }
    }
    
    //移除弹框
    [Global hiddenDialog];
	//已经处理完毕
	return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
    [self afterError:tag error:error];
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
    [self afterError:tag error:error];
}

-(void)afterError:(long)tag error:(NSError*)error
{
    //无法接收时，返回异常提示信息
    NSDictionary *dic= [AppDelegateEntity.sendDic objectForKey:[NSNumber numberWithLong:tag]];
    
    NSNumber *count = [dic objectForKey:DEF_KEY_COUNT];
    
    if ([count integerValue] < 2) {
        //次数小余3则发送，count+1;
        
        count = [NSNumber numberWithInt:[count integerValue]+1];
        
        [dic setValue:count forKey:DEF_KEY_COUNT];
        [AppDelegateEntity.sendDic setObject:dic forKey:[NSNumber numberWithLong:tag]];
        
        [Global sendUdp:self.udpSocket data:[dic objectForKey:DEF_KEY_SENDDATA] mac:deviceItem.mac tag:tag];
    } else {
        [Global hiddenDialog];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络异常"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        [AppDelegateEntity.sendDic removeObjectForKey:[NSNumber numberWithLong:tag]];
        
        if (tag == DEF_OPERATE_OPEN_SS) {
            nowDeviceStatu = closeStatus;
            [self setLightOn:NO];
        }
        
        if (tag == DEF_OPERATE_CLOSE_SS) {
            nowDeviceStatu = openStatu;
            [self setLightOn:YES];
        }
    }
}


-(NSString*)analysisData:(Byte*)data tag:(long)tag
{
    SSCmdType type = [SmartSocketCommend getCmdType:data];
    switch (type) {
        case CMD_QUARY_SS_STATE:
            //表B
        {
            
        }
            break;
        case CMD_QUARY_SS_INFO:
            //设备信息 表C
        {
            
        }
            break;
        case CMD_QUARY_SS_VER:
            //版本号 表D
        {
            DeviceVersionEntity *version = [[DeviceVersionEntity alloc] initWithData:data];
            lblDeviceVersion.text = version.version;
            
            infoView.hidden = NO;
            bInfoShow = !bInfoShow;
            [self showMoreInfo:bInfoShow];
            
            return version.macAddress;
        }
            break;
        case CMD_OPERATE_SS:
            //开关灯 表E
        {
            
            DeviceOpenEntity *open = [[DeviceOpenEntity alloc] initWithData:data];
            
            if (open.devStatu == CLOSE || open.devStatu == CLOSE_ERROR) {
                //关闭
                if (bOpen) {
                    [self setLightOn:NO];
                    nowDeviceStatu = closeStatus;
                    bOpen = NO;
                } else {
                    NSDictionary *dic = [AppDelegateEntity.sendDic objectForKey:[NSNumber numberWithLong:tag]];
                    NSNumber *count = [dic objectForKey:DEF_KEY_COUNT];
                    if ([count integerValue] < 2) {
                        count = [NSNumber numberWithInt:[count integerValue]+1];
                        
                        [dic setValue:count forKey:DEF_KEY_COUNT];
                        [AppDelegateEntity.sendDic setObject:dic forKey:[NSNumber numberWithLong:tag]];
                        
                        [Global sendUdp:self.udpSocket data:[dic objectForKey:DEF_KEY_SENDDATA] mac:deviceItem.mac tag:tag];
                    } else {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"打开失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];
                        [alert release];
                        
                        [AppDelegateEntity.sendDic removeObjectForKey:[NSNumber numberWithLong:tag]];
                        [self setLightOn:NO];
                        nowDeviceStatu = closeStatus;
                        bOpen = NO;
                    }
                }
            }
            else if (open.devStatu == OPEN || open.devStatu == OPEN_LEAKAGE || open.devStatu == OPEN_NOT_WORK) {
                if (!bOpen) {
                    [self setLightOn:YES];
                    nowDeviceStatu = openStatu;
                    bOpen = YES;
                } else {
                    NSDictionary *dic = [AppDelegateEntity.sendDic objectForKey:[NSNumber numberWithLong:tag]];
                    NSNumber *count = [dic objectForKey:DEF_KEY_COUNT];
                    if ([count integerValue] < 2) {
                        count = [NSNumber numberWithInt:[count integerValue]+1];
                        
                        [dic setValue:count forKey:DEF_KEY_COUNT];
                        [AppDelegateEntity.sendDic setObject:dic forKey:[NSNumber numberWithLong:tag]];
                        
                        [Global sendUdp:self.udpSocket data:[dic objectForKey:DEF_KEY_SENDDATA] mac:deviceItem.mac tag:tag];
                    } else {
                        
                        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"关闭失败" delegate:self cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
                        [alert show];
                        [alert release];
                        
                        [AppDelegateEntity.sendDic removeObjectForKey:[NSNumber numberWithLong:tag]];
                        [self setLightOn:YES];
                        nowDeviceStatu = openStatu;
                        bOpen = YES;
                    }
                }
            }
            return open.mac;
        }
        case CMD_QUARY_SS_POWER:
        {
            //功耗
            DevicePowerEntity *power = [[DevicePowerEntity alloc] initWithData:data];
            lblPower.text = [NSString stringWithFormat:@"%0.1f",power.power];
            switch (power.devStatu) {
                case CLOSE:
                    //关闭
                    [self setLightOn:NO];
                    nowDeviceStatu = closeStatus;
                    break;
                case CLOSE_ERROR:
                    //关闭失败
                    
                    break;
                case OPEN:
                    //打开
                    [self setLightOn:YES];
                    nowDeviceStatu = openStatu;
                    break;
                case OPEN_LEAKAGE:
                    //打开漏电
                    
                    break;
                case OPEN_NOT_WORK:
                    //电器未工作
                    
                    break;
                    
                default:
                    break;
            }
            return power.macAddress;
        }
            
        default:
            break;
    }
    return @"";
}


#pragma mark - IBAcion

-(IBAction)didPressedLight:(id)sender
{
    if (bInfoShow) {
        bInfoShow = NO;
        [self showMoreInfo:bInfoShow];
        return;
    }
    [btnLight setImage:[UIImage imageNamed:@"device_loading.png"] forState:UIControlStateNormal];
    if (nowDeviceStatu == closeStatus) {
        nowDeviceStatu = loadingStatus;
        [self openLight];
        
    }
    else if (nowDeviceStatu == openStatu) {
        nowDeviceStatu = loadingStatus;
        [self closeLight];
    }
    

}

-(IBAction)didPressedMoreInfo:(id)sender
{
    [self getVersion];
}

-(void)setLightOn:(BOOL)bOn
{
    if (bOn) {
        [btnLight setImage:[UIImage imageNamed:@"device_on.png"] forState:UIControlStateNormal];
    } else {
        [btnLight setImage:[UIImage imageNamed:@"device_off.png"] forState:UIControlStateNormal];        
    }
}

-(void)showMoreInfo:(BOOL)bShow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    infoView.alpha = bShow?1:0;
    [UIView commitAnimations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)testPower
{
    Byte b[] = {0x24,0x24,0x05,0x16, 0x00, 0xa7, 0x13, 0x00, 0x06, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x01, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x23, 0x23};
    Byte *bId = (Byte*)b;
    [self analysisData:bId tag:0];
}

-(void)testLightOn
{
    Byte b[] = {0x24, 0x24, 0x05, 0x0c, 0x00, 0xa3, 0x09, 0x00, 0x06, 0x72, 0x23, 0x72, 0x34, 0x73, 0x90, 0x01,
        0x02, 0x00, 0x23, 0x23};
    Byte *bId = (Byte*)b;
    [self analysisData:bId tag:0];
    
}

-(void)testLightOff
{
    Byte b[] = {0x24, 0x24, 0x05, 0x0c, 0x00, 0xa3, 0x09, 0x00, 0x06, 0x72, 0x23, 0x72, 0x34, 0x73, 0x90, 0x01,
        0x00, 0x00, 0x23, 0x23};
    Byte *bId = (Byte*)b;
    [self analysisData:bId tag:0];
    
}

-(void)testVersion
{
    Byte b[] = {0x24, 0x24, 0x05, 0x15, 0x00, 0x9d, 0x12, 0x00, 0x06, 0x72, 0x23, 0x72, 0x34, 0x73, 0x90,
        0x0a, 0x32, 0x30, 0x31, 0x33, 0x2e, 0x30, 0x37, 0x2e, 0x33, 0x31, 0x00, 0x23, 0x23};
    Byte *bId = (Byte*)b;
    [self analysisData:bId tag:0];
}

-(void)dealloc
{
    [btnLight release];
    [btnMoreInfo release];
    [lblPower release];
    [lblDeviceTitle release];
    [infoView release];
    [lblDeviceName release];
    [lblDeviceGonglv release];
    [lblMacAddress release];
    [lblDeviceVersion release];
    [super dealloc];
}



@end
