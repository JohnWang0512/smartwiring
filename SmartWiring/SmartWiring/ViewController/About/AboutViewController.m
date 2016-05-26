//
//  AboutViewController.m
//  SmartWiring
//
//  Created by 陈 远 on 13-8-21.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController

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
    self.title = @"关于";
    
    //更多信息
    contextView.layer.borderWidth = 2;
    contextView.layer.borderColor = [[UIColor grayColor] CGColor];
    contextView.layer.cornerRadius = 8;
    contextView.layer.masksToBounds = YES;
    
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
