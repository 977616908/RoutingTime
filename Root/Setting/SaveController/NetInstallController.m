//
//  NetSaveViewController.m
//  RoutingTime
//
//  Created by HXL on 15/3/13.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "NetInstallController.h"


@interface NetInstallController (){

}


@end

@implementation NetInstallController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
}

-(void)createNav{
    self.view.backgroundColor=RGBCommon(63, 205, 225);
    CGFloat gh=0;
    if (is_iOS7()) {
        gh=20;
    }
    UIImageView *imgBg=[[UIImageView alloc]initWithFrame:CGRectMake(0, gh, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh)];
    imgBg.image=[UIImage imageNamed:@"hm_install"];
    [self.view addSubview:imgBg];
    CCView *navTopView = [CCView createWithFrame:CGRectMake(0, gh, 80, 44) backgroundColor:[UIColor clearColor]];
    CCButton *btnBack=CCButtonCreateWithValue(CGRectMake(10, 0, 60, 44), @selector(exitCurrentController), self);
    [btnBack setImage:[UIImage imageNamed:@"hm_return"] forState:UIControlStateNormal];
    btnBack.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [navTopView addSubview:btnBack];
    [self.view addSubview:navTopView];
    
    CCButton *btnStart=CCButtonCreateWithValue(CGRectMake(20, CGRectGetMaxY(imgBg.frame)-102, CGRectGetWidth(self.view.frame)-40, 42), @selector(onTypeClick:), self);
    btnStart.backgroundColor=RGBCommon(63, 205, 225);
    btnStart.tag=2;
    [btnStart alterFontSize:20];
    [btnStart alterNormalTitle:@"安装"];
    [self.view addSubview:btnStart];

}




-(void)onTypeClick:(CCButton *)sendar{


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}

@end
