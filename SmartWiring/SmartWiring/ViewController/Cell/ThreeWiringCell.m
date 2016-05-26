//
//  ThreeWiringCell.m
//  SmartWiring
//
//  Created by alex wang on 13-8-7.
//  Copyright (c) 2013年 王义吉. All rights reserved.
//

#import "ThreeWiringCell.h"

@implementation ThreeWiringCell
@synthesize device1;
@synthesize device2;
@synthesize device3;

@synthesize btn1Index;
@synthesize btn2Index;
@synthesize btn3Index;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

-(void)setDevice1:(Device *)_device1 tag:(int)iTag
{
    [btn1 setTitle:_device1.name forState:UIControlStateNormal];
    btn1.tag = iTag;
    img1.image = [UIImage imageNamed:_device1.icon];
    btn1Index = iTag;
    device1 = [_device1 retain];
}

-(void)setDevice2:(Device *)_device2 tag:(int)iTag
{
    [btn2 setTitle:_device2.name forState:UIControlStateNormal];
    btn2.tag = iTag;
    img2.image = [UIImage imageNamed:_device2.icon];
    btn2Index = iTag;
    device2 = [_device2 retain];
}

-(void)setDevice3:(Device *)_device3 tag:(int)iTag
{
    [btn3 setTitle:_device3.name forState:UIControlStateNormal];
    btn3.tag = iTag;
    img3.image = [UIImage imageNamed:_device3.icon];
    btn3Index = iTag;
    device3 = [_device3 retain];
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setbuttonSel:(SEL)sel target:(id)tar section:(int)iSection
{
    btn1.tag = iSection * 3;
    btn2.tag = iSection * 3 + 1;
    btn3.tag = iSection * 3 + 2;
    
    [btn1 addTarget:tar action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn2 addTarget:tar action:sel forControlEvents:UIControlEventTouchUpInside];
    [btn3 addTarget:tar action:sel forControlEvents:UIControlEventTouchUpInside];
}

-(void)setBtnLongSel:(SEL)sel target:(id)tar
{
    UILongPressGestureRecognizer *lpress = [[UILongPressGestureRecognizer alloc] initWithTarget:tar action:sel];
    lpress.minimumPressDuration = 0.5;
    [btn1 addGestureRecognizer:lpress];
    [lpress release];
    
    UILongPressGestureRecognizer *lpress1 = [[UILongPressGestureRecognizer alloc] initWithTarget:tar action:sel];
    lpress.minimumPressDuration = 0.5;
    [btn2 addGestureRecognizer:lpress1];
    [lpress1 release];
    
    UILongPressGestureRecognizer *lpress2 = [[UILongPressGestureRecognizer alloc] initWithTarget:tar action:sel];
    lpress.minimumPressDuration = 0.5;
    [btn3 addGestureRecognizer:lpress2];
    [lpress2 release];
}

@end
