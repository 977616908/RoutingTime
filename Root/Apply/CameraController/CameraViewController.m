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


@interface CameraViewController ()<ScannerMacDelegate>{
    CGFloat downloadedBytes;
    NSTimer *timer;
    BOOL isConnect;
}
@property(nonatomic,weak)PFDownloadIndicator *downIndicator;
@property(nonatomic,weak)CCLabel *downMsg;
@property(nonatomic,weak)CCButton *btnStart;
@property(nonatomic,weak)CCLabel *lbMsg;
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
}

-(void)createNav{
    self.view.backgroundColor=RGBCommon(63, 205, 225);
    CGFloat gh=0;
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
    
    CCImageView *imgConn=CCImageViewCreateWithNewValue(@"hm_camera_conn", CGRectMake(0,CGRectGetMaxY(downMsg.frame), 320, 158));
    [bgView addSubview:imgConn];
    
    CCButton *btnStart=CCButtonCreateWithValue(CGRectMake(20, CGRectGetMaxY(imgConn.frame)+10, CGRectGetWidth(self.view.frame)-40, 42), @selector(onTypeClick:), self);
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


-(void)scannerMessage:(NSString *)msg{
    if (![msg isEqualToString:@""]) {
        isConnect=YES;
        self.lbMsg.text=[NSString stringWithFormat:@"连接摄像机设备ID:%@",msg];
        [self.btnStart alterNormalTitle:@"开始智能连接"];
    }
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
