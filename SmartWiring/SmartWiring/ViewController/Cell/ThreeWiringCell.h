//
//  ThreeWiringCell.h
//  SmartWiring
//
//  Created by alex wang on 13-8-7.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Device.h"

@interface ThreeWiringCell : UITableViewCell
{
    IBOutlet UIButton *btn1;
    IBOutlet UIButton *btn2;
    IBOutlet UIButton *btn3;
    
    IBOutlet UIImageView *img1;
    IBOutlet UIImageView *img2;
    IBOutlet UIImageView *img3;

    Device *device1;
    Device *device2;
    Device *device3;
    
    int btn1Index;
    int btn2Index;
    int btn3Index;
}

@property (nonatomic,retain) Device *device1;
@property (nonatomic,retain) Device *device2;
@property (nonatomic,retain) Device *device3;

@property (nonatomic) int btn1Index;
@property (nonatomic) int btn2Index;
@property (nonatomic) int btn3Index;

-(void)setbuttonSel:(SEL)sel target:(id)tar section:(int)iSection;
-(void)setBtnLongSel:(SEL)sel target:(id)tar;

-(void)setDevice1:(Device *)_device1 tag:(int)iTag;
-(void)setDevice2:(Device *)_device2 tag:(int)iTag;
-(void)setDevice3:(Device *)_device3 tag:(int)iTag;

@end
