//
//  ServeConfigViewController.m
//  SmartWiring
//
//  Created by alex wang on 13-8-8.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import "ServeConfigViewController.h"

@interface ServeConfigViewController ()

@end

@implementation ServeConfigViewController

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
    self.title = @"服务器设置";

    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"确定"
                                                                 style:UIBarButtonItemStylePlain
                                                                target:self
                                                                action:@selector(pressedRight)];
    self.navigationItem.rightBarButtonItem = rightBar;
    [rightBar release];
    

    
    // Do any additional setup after loading the view from its nib.
}

-(void)viewDidAppear:(BOOL)animated
{
    NSString *sName = [[NSUserDefaults standardUserDefaults] objectForKey:DEF_KEY_SERVERNAME];
    NSString *sPort = [[NSUserDefaults standardUserDefaults] objectForKey:DEF_KEY_SERVERPORT];

    txtAddress.text = sName?sName:DEF_HOST;
    txtPort.text = sPort?sPort:[NSString stringWithFormat:@"%d",DEF_WAN_Port];
    
    [txtAddress becomeFirstResponder];
}

-(void)pressedRight
{
    NSString *sMsg = @"";
    if (txtAddress.text.length == 0) {
        sMsg = @"服务器地址不能为空";
    }
    if (txtPort.text.length == 0) {
        sMsg = @"端口地址不能为空";
    }
    
    if (sMsg.length > 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:sMsg delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil];
        [alert show];
        [alert release];
    } else {
        [[NSUserDefaults standardUserDefaults] setObject:txtAddress.text forKey:DEF_KEY_SERVERNAME];
        [[NSUserDefaults standardUserDefaults] setObject:txtPort.text forKey:DEF_KEY_SERVERPORT];
        [self.navigationController popViewControllerAnimated:YES];
    }
}

-(void)dealloc
{
    [txtAddress release];
    [txtPort release];
    [super dealloc];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
