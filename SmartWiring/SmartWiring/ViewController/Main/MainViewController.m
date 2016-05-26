//
//  MainViewController.m
//  SmartWiring
//
//  Created by 王义吉 on 8/1/13.
//  Copyright (c) 2013 王义吉. All rights reserved.
//

#import "MainViewController.h"
#import "AboutViewController.h"

//请求类型
typedef enum
{
    brodCastTag = 0
}TAG_SEND_TYPE;


@interface MainViewController ()

@end

@implementation MainViewController
@synthesize udpSocket;
@synthesize ddmenuVC;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"设备列表";
    
    lights = [[NSMutableArray alloc] init];
    
    //初始化icon
    planeView.alpha = 0;
    planeView.layer.borderWidth = 2;
    planeView.layer.borderColor = [[UIColor greenColor] CGColor];
    planeView.layer.cornerRadius = 8;
    planeView.layer.masksToBounds = YES;
    
    //初始化设备名
    inputView.alpha = 0;
    inputView.layer.borderWidth = 2;
    inputView.layer.borderColor = [[UIColor greenColor] CGColor];
    inputView.layer.cornerRadius = 8;
    inputView.layer.masksToBounds = YES;

    
    //没网络弹框
//    Reachability * hostReach=[Reachability reachabilityWithHostName:@"www.baidu.com"];
//    switch ([hostReach currentReachabilityStatus]) {
//        case ReachableViaWiFi:
//            
//            break;
//        case ReachableVia3G:
//            
//            break;
//        case NotReachable:
//        {
//            bShowNoWaln = YES;
//        }
//            break;
//        default:
//            
//            break;
//    }
	// Do any additional setup after loading the view, typically from a nib.
}

-(void)viewWillAppear:(BOOL)animated
{
    ddmenuVC.bMove = YES;
    self.udpSocket.delegate = self;
    //启动就初始化网络
    [self refreshAll];
}

-(void)help
{
    
}

#pragma mark - tableview delegate
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 10;
    //return lights.count / 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIButton *b = [UIButton buttonWithType:UIButtonTypeCustom];
    [b setTitle:@"当前网络不可用，请检查您的网络连接。" forState:UIControlStateNormal];
    [b.titleLabel setFont:[UIFont systemFontOfSize:13]];
    [b.titleLabel setTextAlignment:NSTextAlignmentCenter];
    [b setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [b addTarget:self action:@selector(didPressedNoWaln:) forControlEvents:UIControlEventTouchUpInside];
    b.frame = CGRectMake(0, 0, 320, 44);
    return b;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
//    if (bShowNoWaln) {
//        return 44;
//    } else {
//        return 0;
//    }
    return 0;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSString *identifier = @"identifier";
    ThreeWiringCell* cell = (ThreeWiringCell*)[tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (cell == nil)
    {
        NSArray* nibs = [[NSBundle mainBundle] loadNibNamed:@"ThreeWiringCell" owner:self options:nil];
        
        for (id oneObject in nibs)
        {
            if ([oneObject isKindOfClass:[ThreeWiringCell class]])
            {
                cell = (ThreeWiringCell*)oneObject;
            }
        }
    }
    
    int index1 = indexPath.row * 3;
    int index2 = indexPath.row * 3 + 1;
    int index3 = indexPath.row * 3 + 2;
    
    if (index1 < lights.count) {
        [cell setDevice1:[lights objectAtIndex:index1] tag:index1];
    }

    if (index2 < lights.count) {
        [cell setDevice2:[lights objectAtIndex:index2] tag:index2];
    }

    if (index3 < lights.count) {
        [cell setDevice3:[lights objectAtIndex:index3] tag:index3];
    }
    
    [cell setbuttonSel:@selector(searchLightStat:) target:self section:indexPath.row];
    [cell setBtnLongSel:@selector(longPressedItem:) target:self];

    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 100;
}

-(void)searchLightStat:(UIButton*)btn
{
    ThreeWiringCell *cell = (ThreeWiringCell*)[[btn superview] superview];
    
    if (btn.frame.origin.x == 0) {
        iSelectIndex = cell.btn1Index;
    }
    else if (btn.frame.origin.x == 107) {
        iSelectIndex = cell.btn2Index;
    }
    else if (btn.frame.origin.x == 214) {
        iSelectIndex = cell.btn3Index;
    }

    //查询设备状态
    if (btn.tag < lights.count) {
        
        Device *item = [lights objectAtIndex:btn.tag];
        
        CustomArray tb = [SmartSocketCommend fetchDeviceStat:item.mac];
        
        NSData *data = [NSData dataWithBytes:tb.byteArray length:tb.count];
        
        [Global showMbDialog:self.view title:@"正在连接该设备"];
        [Global sendUdp:self.udpSocket data:data mac:item.mac tag:DEF_GET_DEVICE_STAT];
    }
   // [self pushLightItem:0 deviceStatu:0x00 power:5.2];
}

//获取功率
-(void)getPower
{
    Device *deviceItem = [lights objectAtIndex:iSelectIndex];
    CustomArray tempCmd = [SmartSocketCommend fetchDevicePower:deviceItem.mac];
    NSData *sendData = [NSData dataWithBytes:tempCmd.byteArray length:tempCmd.count];
    [Global sendUdp:self.udpSocket data:sendData mac:deviceItem.mac tag:DEF_QUARY_SS_POWER];
}

-(void)pushLightItem:(int)iIndex deviceStatu:(Byte)statu power:(float)fPower
{
    ItemViewController *itemVC = [[ItemViewController alloc] initWithNibName:@"ItemViewController" bundle:nil];
    if (statu == DEF_DEVICE_STATU_CLOSE || statu == DEF_DEVICE_STATU_CLOSE_FALD) {
        itemVC.nowDeviceStatu = closeStatus;
        itemVC.bOpen = NO;
    }
    else if (statu == DEF_DEVICE_STATU_OPEN || statu == DEF_DEVICE_STATU_OPEN_FALD || statu == DEF_DEVICE_STATU_NOWORK) {
        itemVC.nowDeviceStatu = openStatu;
        itemVC.bOpen = YES;
    }
    itemVC.sPower = [NSString stringWithFormat:@"%0.1f",fPower];
    itemVC.deviceItem = [lights objectAtIndex:iIndex];
    self.udpSocket.delegate = itemVC;
    itemVC.udpSocket = self.udpSocket;
    
    ddmenuVC.bMove = NO;
    
    [self.navigationController pushViewController:itemVC animated:YES];
    [itemVC release];
}

#pragma mark - IBAction
-(void)longPressedItem:(id)sender
{
    UILongPressGestureRecognizer *l = (UILongPressGestureRecognizer*)sender;
    
    UIButton *btn = (UIButton*)l.view;
    
    ThreeWiringCell *cell = (ThreeWiringCell*)[[btn superview] superview];
    
    if (btn.frame.origin.x == 0) {
        iChangeIndex = cell.btn1Index;
    }
    else if (btn.frame.origin.x == 107) {
        iChangeIndex = cell.btn2Index;
    }
    else if (btn.frame.origin.x == 214) {
        iChangeIndex = cell.btn3Index;
    }
    
    l.view.tag = iChangeIndex;
    if (l.state == UIGestureRecognizerStateBegan) {
        UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"操作"
                                                           delegate:self
                                                  cancelButtonTitle:nil
                                             destructiveButtonTitle:nil
                                                  otherButtonTitles:@"改变名称",@"修改图标",@"删除",@"取消", nil];
        [sheet showInView:self.view];
        [sheet release];
    }
}

-(void)didPressedNoWaln:(id)sender
{
    bShowNoWaln = NO;
    [myTableview reloadData];
}

-(void)showPlane:(BOOL)bShow
{
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    planeView.alpha = bShow?1:0;
    [UIView commitAnimations];
}

-(void)showInput:(BOOL)bShow
{
    if (!bShow) {
        [txtDeviceName resignFirstResponder];
    }
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    inputView.alpha = bShow?1:0;
    [UIView commitAnimations];
}



-(void)refreshAll
{
    [lights removeAllObjects];
    NSMutableArray *array = [DBhelper searchBy:@"Device"];
    [lights addObjectsFromArray:array];
    [array release];
    [myTableview reloadData];
}

#pragma mark - ActionSheet Delegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex) {
        case 0:         //改名称
        {
            bInputShow = YES;
            [self showInput:bInputShow];
        }
            break;
        case 1:         //改图标
        {
            bShowTypePlane = YES;
            [self showPlane:bShowTypePlane];
        }
            break;
        case 2:         //删除
        {
            Device *d = [lights objectAtIndex:iChangeIndex];
            [DBhelper deleteBy:d];
            [DBhelper Save];
            [self refreshAll];
        }
            break;
            
        default:
            break;
    }
}

#pragma mark - IBAction
-(IBAction)didPressedSure:(id)sender
{
    Device *deviceItem = [lights objectAtIndex:iChangeIndex];
    bInputShow = NO;
    deviceItem.name = txtDeviceName.text;
    [DBhelper Save];
    [self showInput:bInputShow];
    [self refreshAll];
}

-(IBAction)didPressedCancel:(id)sender
{
    bInputShow = NO;
    [self showInput:bInputShow];
}

-(IBAction)done:(id)sender
{
    [txtDeviceName resignFirstResponder];
}

-(IBAction)didPressedType:(id)sender
{
    Device *deviceItem = [lights objectAtIndex:iChangeIndex];
    if (sender == btnType1) {
        deviceItem.icon = @"device_type1.png";
    }
    else if (sender == btnType2) {
        deviceItem.icon = @"device_type2.png";
    }
    else if (sender == btnType3) {
        deviceItem.icon = @"device_type3.png";
    }
    else if (sender == btnType4) {
        deviceItem.icon = @"device_type4.png";
    }
    else if (sender == btnType5) {
        deviceItem.icon = @"device_type5.png";
    }
    else if (sender == btnType6) {
        deviceItem.icon = @"device_type6.png";
    }
    [DBhelper Save];
    bShowTypePlane = NO;
    [self showPlane:bShowTypePlane];
    [self refreshAll];
}


#pragma mark - UDP Delegate

-(AsyncUdpSocket *)udpSocket
{
    if (!udpSocket) {
        udpSocket =[[AsyncUdpSocket alloc] initWithDelegate:self];
    }
    return udpSocket;
}

- (BOOL)onUdpSocket:(AsyncUdpSocket *)sock didReceiveData:(NSData *)data withTag:(long)tag fromHost:(NSString *)host port:(UInt16)port
{
    NSLog(@"did get dat");
    //移除弹框
    [Global hiddenDialog];
    //解析命令
    NSString *sMacAddress = [self analysisData:(Byte*)[data bytes]];
    
    //根据tag获取请求信息
    NSDictionary *v = [AppDelegateEntity.sendDic objectForKey:[NSNumber numberWithLong:tag]];
    if (v) {
        NSString *sMac = [v objectForKey:DEF_KEY_MACADDRESS];
        
        //通过mac匹配到是发出的命令，则删去标记
        if ([sMac isEqualToString:sMacAddress]) {
            [AppDelegateEntity.sendDic removeObjectForKey:[NSNumber numberWithLong:tag]];
        }
    }
    
    
	return YES;
}

-(NSString*)analysisData:(Byte*)data
{
    //获取设备设备是否在线
    SSCmdType type = [SmartSocketCommend getCmdType:data];
    if (type == CMD_QUARY_SS_STATE) {
        DeviceStatuEntity *stat = [[DeviceStatuEntity alloc] initWithData:data];
        if (stat.devStatu == NOTCONNECTSERVER) {
            //设备不在线
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"设备不在线" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else {
            //状态非0，请求功率
            [Global showMbDialog:self.view title:@"正在获取设备功率和状态"];
            [self getPower];
        }
        return stat.macAddress;
    }
	else if (type == CMD_QUARY_SS_POWER) {
        //获取到当前功率
        DevicePowerEntity *power = [[DevicePowerEntity alloc] initWithData:data];
        [self pushLightItem:iSelectIndex deviceStatu:power.statu power:power.power];
        return power.macAddress;
    }
    return @"";
}

-(void)onUdpSocket:(AsyncUdpSocket *)sock didSendDataWithTag:(long)tag
{
    NSLog(@"finish");
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
        
        Device *d = [lights objectAtIndex:iSelectIndex];
        [Global sendUdp:self.udpSocket data:[dic objectForKey:DEF_KEY_SENDDATA] mac:d.mac tag:tag];
    } else {
        [Global hiddenDialog];
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示"
                                                        message:@"网络错误"
                                                       delegate:self
                                              cancelButtonTitle:@"确定"
                                              otherButtonTitles:nil];
        [alert show];
        [alert release];
        [AppDelegateEntity.sendDic removeObjectForKey:[NSNumber numberWithLong:tag]];
    }
}

-(void)testStstu
{
    Byte b[] ={0x24, 0x24, 0x05, 0x0c, 0x00, 0x81, 0x09, 0x00, 0x06, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x01, 0x02, 0x00, 0x23, 0x23};
    [self analysisData:b];
}

-(void)testPower
{
    Byte b[] = {0x24,0x24,0x05,0x16, 0x00, 0xa7, 0x13, 0x00, 0x06, 0x71, 0x72, 0x73, 0x74, 0x75, 0x76, 0x01, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x04, 0x00, 0x00, 0x00, 0x00, 0x00, 0x23, 0x23};
    Byte *bId = (Byte*)b;
    [self analysisData:bId];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    [myTableview release];
    [planeView release];
    [btnType1 release];
    [btnType2 release];
    [btnType3 release];
    [btnType4 release];
    [btnType5 release];
    [btnType6 release];
    [inputView release];
    [txtDeviceName release];
    [btnSure release];
    [btnCancel release];
    [super dealloc];
}

@end
