//
//  NetSaveViewController.m
//  RoutingTime
//
//  Created by HXL on 15/3/13.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CameraViewController.h"
#import "PFDownloadIndicator.h"
#import "ScannerViewController.h"
#import <SystemConfiguration/CaptiveNetwork.h>
#import "CameraMessage.h"

@interface CameraViewController ()<ScannerMacDelegate>{
    CGFloat downloadedBytes;
    NSTimer *timer;
    BOOL isConnect;
    NSMutableArray *arrSteps;
}
@property(nonatomic,weak)PFDownloadIndicator *downIndicator;
@property(nonatomic,weak)CCLabel *downMsg;
@property(nonatomic,weak)CCButton *btnStart;
@property(nonatomic,weak)CCLabel *lbMsg;
@property(nonatomic,weak)CameraMessage *cameraMsg;
@end

@implementation CameraViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createNav];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=YES;
    [self showConnect];
}

-(void)createNav{
    self.view.backgroundColor=RGBCommon(63, 205, 225);
    CGFloat gh=-20;
    if (is_iOS7()) {
        gh=20;
    }
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, gh, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh)];
    bgView.backgroundColor=[UIColor whiteColor];
    [self.view addSubview:bgView];
    CCView *navTopView = [CCView createWithFrame:CGRectMake(0, 0, 80, 44) backgroundColor:[UIColor clearColor]];
    CCButton *btnBack=CCButtonCreateWithValue(CGRectMake(10, 0, 60, 44), @selector(exitCurrentController), self);
    [btnBack setImage:[UIImage imageNamed:@"hm_return"] forState:UIControlStateNormal];
    btnBack.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [navTopView addSubview:btnBack];
    [bgView addSubview:navTopView];
    
    
    CCLabel *title=CCLabelCreateWithNewValue(@"连接智能摄像头", 16, CGRectMake(0,CGRectGetMaxY(navTopView.frame)+10,CGRectGetWidth(bgView.frame),16));
    title.textColor=RGBCommon(63, 205, 225);
    title.textAlignment=NSTextAlignmentCenter;
    [bgView addSubview:title];
    
    CCLabel *msg=CCLabelCreateWithNewValue(@"接通电源，设备指示灯闪烁时点击下一步", 13, CGRectMake(0,CGRectGetMaxY(title.frame)+10,CGRectGetWidth(bgView.frame),14));
    msg.textColor=RGBCommon(155, 155, 155);
    msg.textAlignment=NSTextAlignmentCenter;
    self.lbMsg=msg;
    [bgView addSubview:msg];
    
    CCImageView *img=CCImageViewCreateWithNewValue(@"hm_camera", CGRectMake(132,CGRectGetMaxY(msg.frame)+60, 56, 76));
    [bgView addSubview:img];
    
    PFDownloadIndicator *downIndicator = [[PFDownloadIndicator alloc]initWithFrame:CGRectMake(90, CGRectGetMaxY(msg.frame)+50, 140, 140) type:kRMClosedIndicator];
    [downIndicator setBackgroundColor:[UIColor clearColor]];
    [downIndicator setFillColor:RGBCommon(201, 201, 201)];
    [downIndicator setStrokeColor:RGBCommon(63, 205, 225)];
    downIndicator.radiusPercent = 0.45;
    
    self.downIndicator=downIndicator;
//    downIndicator.hidden=YES;
    [self.view addSubview:downIndicator];
    [downIndicator loadIndicator];
    
    CCLabel *downMsg=CCLabelCreateWithNewValue(@"正在为您下载模板中...", 15, CGRectMake(0,CGRectGetMaxY(downIndicator.frame)-10,CGRectGetWidth(bgView.frame),15));
    downMsg.textColor=RGBCommon(123, 123, 123);
    downMsg.textAlignment=NSTextAlignmentCenter;
    self.downMsg=downMsg;
    downMsg.hidden=YES;
    [bgView addSubview:downMsg];
    
    UIView *stepView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(downMsg.frame), 320, 150)];
    CCImageView *imgConn=CCImageViewCreateWithNewValue(@"hm_camera_conn", CGRectMake(0, 0, 320, 150));
    [stepView addSubview:imgConn];
    CCLabel *lbMsg=CCLabelCreateWithBlodNewValue(@"配制摄像头步骤:", 13.0, CGRectMake(15, 20, 100, 14));
    lbMsg.textColor=RGBCommon(155, 155, 155);
    [stepView addSubview:lbMsg];
    NSArray *arr=@[@" 1.扫描设置二维码",@" 2.连接“IPCAM-XXX”的WIFI",@" 3.连接摄像头",@" 4.设置摄像头WIFI",@" 5.重启摄像头"];
    arrSteps=[NSMutableArray array];
    for(int i=0;i < arr.count;i++){
        CGFloat hg=40+i*15;
        CCButton *btn=CCButtonCreateWithFrame(CGRectMake(14, hg, 180, 14));
        [btn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [btn alterFontSize:11.0];
        [btn setImage:[UIImage imageNamed:@"rt_gou"] forState:UIControlStateSelected];
        [btn alterNormalTitle:arr[i]];
        [btn alterNormalTitleColor:RGBCommon(155, 155, 155)];
        [stepView addSubview:btn];
        [arrSteps addObject:btn];
    }
    [bgView addSubview:stepView];
    
    CCButton *btnStart=CCButtonCreateWithValue(CGRectMake(20, CGRectGetMaxY(stepView.frame)+10, CGRectGetWidth(self.view.frame)-40, 42), @selector(onTypeClick:), self);
    btnStart.backgroundColor=RGBCommon(63, 205, 225);
    btnStart.tag=2;
    [btnStart alterFontSize:20];
    [btnStart alterNormalTitle:@"扫一扫"];
    self.btnStart=btnStart;
    [bgView addSubview:btnStart];

}




-(void)onTypeClick:(CCButton *)sendar{
//    [self showToast:@"暂未找到可连接的设置" Long:1.5];
    if (isConnect) {
        self.btnStart.enabled=NO;
        [self startAnimation];
    }else{
        [self.navigationController.view.layer addAnimation:[self customAnimation1:self.view upDown:YES] forKey:@"animation1"];
        ScannerViewController *svc = [[ScannerViewController alloc]init];
        svc.type=ScannerOther;
        svc.delegate=self;
        [self.navigationController pushViewController:svc animated:NO];
    }

}
//判断是否连接当前摄像头
-(void)showConnect{
    NSString *wifiiName=[self getWifiName];
    if ([wifiiName hasPrefix:@"IPCAM-"]) {
        isConnect=YES;
        CameraMessage *msg=[[CameraMessage alloc]init];
        msg.camdevicewifiname=wifiiName;
        _cameraMsg=msg;
        [self setStepsCount:2];
        [self.btnStart alterNormalTitle:@"开始智能连接"];
    }
    NSLog(@"---[%@]---",wifiiName);
}


#pragma mark - Update Views
- (void)startAnimation
{
    self.downMsg.hidden=NO;
    self.downIndicator.hidden=NO;
    downloadedBytes = 0;
    timer=[NSTimer scheduledTimerWithTimeInterval:0.2 target:self selector:@selector(updateView) userInfo:nil repeats:YES];
}

- (void)updateView
{
    downloadedBytes+=arc4random()%5;
    downloadedBytes=downloadedBytes>100?100:downloadedBytes;
    _downMsg.text=[NSString stringWithFormat:@"正在为您连接摄像头...(%.0f%%)",downloadedBytes];
    [_downIndicator updateWithTotalBytes:100 downloadedBytes:downloadedBytes];
    if(downloadedBytes>=100){
        [timer invalidate];
        timer=nil;
        self.btnStart.enabled=YES;
        _downMsg.text=@"摄像头连接成功";
        [self.pifiiDelegate pushViewDataSource:@(0)];
        [self performSelector:@selector(exitCurrentController) withObject:nil afterDelay:0.7];
    }
}

-(void)setStepsCount:(NSInteger)count{
    for (int i=0; i<count; i++) {
        [arrSteps[i] setSelected:YES];
    }
}

-(void)scannerMessage:(NSString *)msg{
    if (![msg isEqualToString:@""]) {
        [self setStepsCount:1];
        self.lbMsg.text=[NSString stringWithFormat:@"连接摄像机设备ID:%@",msg];
//        /platports/pifii/plat/plug/getCamera?camid=HDXQ-005664-CEGGN
        [self initPostWithURL:ROUTINGCAMERA path:@"getCamera" paras:@{@"camid":msg} mark:@"user" autoRequest:YES];
    }

}

-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    PSLog(@"%@:%@",response,mark);
    NSNumber *returnCode=[response objectForKey:@"returnCode"];
    if ([returnCode intValue]==200) {
        NSDictionary *data=response[@"data"];
        CameraMessage *msg=[[CameraMessage alloc]initWithData:data];
        self.cameraMsg=msg;
        PSLog(@"%@",msg);
        if(msg.isOpen){
            isConnect=YES;
            [self setStepsCount:5];
            [self.btnStart alterNormalTitle:@"开始智能连接"];
        }
    }
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    
}

- (NSString *)getWifiName

{
    NSString *wifiName = nil;
    CFArrayRef wifiInterfaces = CNCopySupportedInterfaces();
    if (!wifiInterfaces) {
        return nil;
    }
    NSArray *interfaces = (__bridge NSArray *)wifiInterfaces;
    for (NSString *interfaceName in interfaces) {
        CFDictionaryRef dictRef = CNCopyCurrentNetworkInfo((__bridge CFStringRef)(interfaceName));
        if (dictRef) {
            NSDictionary *networkInfo = (__bridge NSDictionary *)dictRef;
            NSLog(@"network info -> %@", networkInfo);
            wifiName = [networkInfo objectForKey:(__bridge NSString *)kCNNetworkInfoKeySSID];
            CFRelease(dictRef);
        }
    }
    CFRelease(wifiInterfaces);
    return wifiName;
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden=NO;
}

-(CATransition *)customAnimation1:(UIView *)viewNum upDown:(BOOL )boolUpDown{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f ;
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    animation.fillMode = kCAFillModeForwards;
    animation.endProgress = 1;
    animation.removedOnCompletion = NO;
    animation.type = @"oglFlip";//101
    if (boolUpDown) {
        animation.subtype = kCATransitionFromRight;
    }else{
        animation.subtype = kCATransitionFromLeft;
    }
    return animation;
}

@end
