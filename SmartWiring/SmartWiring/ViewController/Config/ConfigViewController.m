//
//  ConfigViewController.m
//  SmartWiring
//
//  Created by 陈 远 on 13-8-3.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import "ConfigViewController.h"

#define DEF_CONFIG_SSIDNAME @"SCI_UART_AP"
#define DEF_CONFIG_PWD      @""
#define DEF_CONFIG_IPADDRESS @"192.168.43.1"
#define DEF_CONFIG_PORT     @"5050"

#define DEF_CONFIG_KEY_SSIDNAME     @"CONFIG_KEY_SSIDNAME"
#define DEF_CONFIG_KEY_PWD          @"CONFIG_KEY_PWD"
#define DEF_CONFIG_KEY_IPADDRESS    @"CONFIG_KEY_IPADDRESS"
#define DEF_CONFIG_KEY_PORT         @"CONFIG_KEY_PORT"


@interface ConfigViewController ()

@end

@implementation ConfigViewController
@synthesize udpSocket;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"添加设备";
    lblVersion.text = @"版本号：1.0";
    
    txtApName.text = [self getSSIDName];
    txtPwd.text = [self getPWD];
    
    txtAddress.text = [self getIPAddress];
    txtPort.text = [self getPort];

    // Do any additional setup after loading the view from its nib.
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setValue:txtApName.text forKey:DEF_CONFIG_KEY_SSIDNAME];
    [[NSUserDefaults standardUserDefaults] setValue:txtPwd.text forKey:DEF_CONFIG_KEY_PWD];
    [[NSUserDefaults standardUserDefaults] setValue:txtAddress.text forKey:DEF_CONFIG_KEY_IPADDRESS];
    [[NSUserDefaults standardUserDefaults] setValue:txtPort.text forKey:DEF_CONFIG_KEY_PORT];
    NSLog(@"disappear");
}


-(NSString*)getSSIDName
{
    NSString *ssid = [[NSUserDefaults standardUserDefaults] objectForKey:DEF_CONFIG_KEY_SSIDNAME];
    if (ssid) {
        return ssid;
    } else {
        return DEF_CONFIG_SSIDNAME;
    }
}

-(NSString*)getPWD
{
    NSString *pwd = [[NSUserDefaults standardUserDefaults] objectForKey:DEF_CONFIG_KEY_PWD];
    if (pwd) {
        return pwd;
    } else {
        return DEF_CONFIG_PWD;
    }
}

-(NSString*)getIPAddress
{
    NSString *ip = [[NSUserDefaults standardUserDefaults] objectForKey:DEF_CONFIG_KEY_IPADDRESS];
    if (ip) {
        return ip;
    } else {
        return DEF_CONFIG_IPADDRESS;
    }
}

-(NSString*)getPort
{
    NSString *port = [[NSUserDefaults standardUserDefaults] objectForKey:DEF_CONFIG_KEY_PORT];
    if (port) {
        return port;
    } else {
        return DEF_CONFIG_PORT;
    }
}

-(AsyncUdpSocket *)udpSocket
{
    if (!udpSocket) {
        udpSocket = [[AsyncUdpSocket alloc] initWithDelegate:self];
        //[udpSocket bindToPort:6810 error:nil];
    }
    return udpSocket;
}

#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return 2;
            break;
        case 1:
            return 2;
            break;
        case 2:
            return 2;
            break;
        case 3:
            return 1;
            break;
        default:
            break;
    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    switch (indexPath.section) {
        case 0:
            if (indexPath.row == 0) {
                return apNameCell;
            }
            else if (indexPath.row == 1) {
                return apPWDCell;
            }
            break;
        case 1:
            if (indexPath.row == 0) {
                return addressCell;
            }
            else if (indexPath.row == 1) {
                return portCell;
            }
            break;
        case 2:
            if (indexPath.row == 0) {
                return versionCell;
            }
            else if (indexPath.row == 1) {
                return submitCell;
            }
            break;
        case 3:
        {
            return macAddressCell;
        }
            break;
        default:
            break;
    }
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section) {
        case 0:
            return @"模块下次上电连接AP的参数";
            break;
        case 1:
            return @"服务器参数";
            break;
        case 2:
            return @"软件版本信息";
            break;
        case 3:
            return @"新增设备";
            break;
        default:
            break;
    }
    return @"";
}

-(IBAction)didPressedSubmit:(id)sender
{
    [Global showMbDialog:self.view title:@"正在配置"];
    
    //按下提交保存到本地
    NSString *errorMsg = [self checkInfo];
    if (errorMsg.length == 0) {
        [[NSUserDefaults standardUserDefaults] setValue:txtApName.text forKey:DEF_CONFIG_KEY_SSIDNAME];
        [[NSUserDefaults standardUserDefaults] setValue:txtPwd.text forKey:DEF_CONFIG_KEY_PWD];
        [[NSUserDefaults standardUserDefaults] setValue:txtAddress.text forKey:DEF_CONFIG_KEY_IPADDRESS];
        [[NSUserDefaults standardUserDefaults] setValue:txtPort.text forKey:DEF_CONFIG_KEY_PORT];
        
        //配置完成，开始广播
        CustomArray cmd = [ConfigCommend createLastFrames:txtApName.text pwd:txtPwd.text ip:txtAddress.text port:[txtPort.text integerValue]];
        NSData *data = [NSData dataWithBytes:cmd.byteArray length:cmd.count];
        NSError *error = nil;
       
        [self.udpSocket enableBroadcast:YES error:&error];
        
        [self.udpSocket sendData:data
                          toHost:[Global getBordCastIp]
                            port:6810
                     withTimeout:-1
                             tag:0];
        [self.udpSocket receiveWithTimeout:-1 tag:0];
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:errorMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
}

-(NSString*)checkInfo
{
    if (txtApName.text.length == 0) {
        return @"SSID不能为空";
    }
    if (txtAddress.text.length == 0) {
        return @"服务器地址不能为空";
    }
    if (txtPort.text.length == 0) {
        return @"端口号不能为空";
    }
    return @"";
}

-(IBAction)didPressedAddMac:(id)sender
{
    
    if (txtMacAddress.text.length == 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"Mac地址不能为空" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        [alert show];
        [alert release];
    } else {
        
        NSArray *temp = [DBhelper searchBy:@"Device"];
        
        Device *d1 = [DBhelper insertWithEntity:@"Device"];
        d1.mac = txtMacAddress.text;
        d1.name = [NSString stringWithFormat:@"未命名%d",temp.count];
        d1.icon = @"device_type3.png";
        
        [DBhelper Save];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"新增设备成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles: nil];
        alert.tag = 200;
        [alert show];
        [alert release];
    }
}

#pragma mark - alert Delegate
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 200) {
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(IBAction)didPressedBeginEdit:(id)sender
{
    
}
-(IBAction)didPressedEndEdit:(id)sender
{
    [txtMacAddress resignFirstResponder];
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    //请求已发出
    NSLog(@"didSendDataWithTag");
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"did get data host %@",host);
    [Global hiddenDialog];
    if ([SmartSocketCommend checkConfigAvailable:(Byte*)[data bytes]])
    {
        //获取到配置信息
        Byte *b = (Byte*)[data bytes];
        Byte mac[6] = {0};
        mac[0] = b[6];
        mac[1] = b[7];
        mac[2] = b[8];
        mac[3] = b[9];
        mac[4] = b[10];
        mac[5] = b[11];
        
        NSString *sMac = [Global byteMacToString:mac];
        
        NSArray *a = [DBhelper searchBy:@"Device"];
        
        Device *dev = [DBhelper insertWithEntity:@"Device"];
        dev.mac = sMac;
        dev.icon = @"device_type3.png";
        if (a.count == 0) {
            dev.name = @"未命名";
        } else {
            dev.name = [NSString stringWithFormat:@"未命名%d",a.count];
        }
        [DBhelper Save];
        [a release];
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"提交成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"格式错误" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    }

	return YES;
}

- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotSendDataWithTag:(long)tag dueToError:(NSError *)error
{
        [Global hiddenDialog];
	//无法发送时,返回的异常提示信息
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:@"网络异常"
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
	
}
- (void)onUdpSocket:(AsyncUdpSocket *)sock didNotReceiveDataWithTag:(long)tag dueToError:(NSError *)error
{
        [Global hiddenDialog];
	//无法接收时，返回异常提示信息
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
													message:@"网络异常"
												   delegate:self
										  cancelButtonTitle:@"取消"
										  otherButtonTitles:nil];
	[alert show];
	[alert release];
}

-(IBAction)done:(id)sender
{
    [sender resignFirstResponder];
}

-(IBAction)switchChange:(id)sender
{
    if (swith.on) {
        txtPwd.enabled = YES;
        [txtPwd becomeFirstResponder];
    } else {
        txtPwd.enabled = NO;
        [txtPwd resignFirstResponder];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)dealloc
{
    [myTableview release];
    [apNameCell release];
    [txtApName release];
    [apPWDCell release];
    [txtPwd release];
    [addressCell release];
    [txtAddress release];
    [portCell release];
    [txtPort release];
    [versionCell release];
    [lblVersion release];
    [submitCell release];
    [btnSubmit release];
    [macAddressCell release];
    [txtMacAddress release];
    [swith release];
    [super dealloc];
}


@end
