//
//  ScannerViewController.m
//  YYQMusic
//
//  Created by Harvey on 13-10-18.
//  Copyright (c) 2013年 广东星外星文化传播有限公司. All rights reserved.
//

#import "ScannerViewController.h"

#define H_DegreesToRadinas(x) (M_PI * (x)/180.0)

@interface ScannerViewController()<UIAlertViewDelegate,ZBarReaderDelegate>{
    MBProgressHUD *stateView;
    CCView  *tipView;
    CCLabel *crMsg;
    CCView *rigViewNav;
    CGFloat org_Y;
}

@end


@implementation ScannerViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(BOOL)shouldAutorotate{
    return NO;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self coustomNav];
    [self myViewDidLoad];
    self.readerDelegate=self;
//    [self.scanner setSymbology:ZBAR_I25 config:ZBAR_CFG_ENABLE to:0];
//    self.showsZBarControls=NO;
    self.readerView.frame=self.view.bounds;

    CCLabel *tipBack = CCLabelCreateWithNewValue(@"正在为你开启摄像头...", 16, CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)));
    tipBack.textColor = [UIColor whiteColor];
    tipBack.backgroundColor = RGBBlackColor();
    tipBack.alpha =0.0;
    tipBack.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tipBack];
    
    [UIView animateWithDuration:2.5 animations:^{
        tipBack.alpha = 1.0;
    } completion:^(BOOL finished) {
        tipBack.hidden = YES;
        [tipBack removeFromSuperview];
        //        [self.readerView start];
    }];
}



- (void)coustomNav
{
    CCView *navTopView = [CCView createWithFrame:CGRectMake(0, 0, 80, 44) backgroundColor:[UIColor clearColor]];
    CCButton *btnBack=CCButtonCreateWithValue(CGRectMake(10, 0, 60, 44), @selector(exitCurrentController), self);
    [btnBack setImage:[UIImage imageNamed:@"hm_fanhui"] forState:UIControlStateNormal];
    [btnBack alterNormalTitle:@" 关闭"];
    btnBack.contentHorizontalAlignment=UIControlContentHorizontalAlignmentLeft;
    [navTopView addSubview:btnBack];
    [self.view addSubview:navTopView];
}

- (void)myViewDidLoad
{
//    CGRect rect = self.view.frame;
//    rect.origin.y = (self.view.height - 280 - 44)/2.0f;
//    self.view.frame = rect;
    CGFloat gh=(self.view.height-300)/2;
    
    CCLabel *tip = CCLabelCreateWithNewValue(@"请将二维码放入扫描框内，即可自动扫描", 14, CGRectMake(0,  gh + 290, self.view.width, 20));
    //    [self performSelector:@selector(startScanner) withObject:nil afterDelay:1.0];
    tip.textColor = [UIColor whiteColor];
    tip.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:tip];
    
    
    
    CCImageView *angle = CCImageViewCreateWithNewValue(@"green", CGRectMake(25, gh + 5, 25, 25));
    [self.view addSubview:angle];
    
    angle = CCImageViewCreateWithNewValue(@"green", CGRectMake(25, gh + 250, 25, 25));
    angle.transform = CGAffineTransformIdentity;
    angle.transform = CGAffineTransformMakeRotation(H_DegreesToRadinas(-90));
    [self.view addSubview:angle];
    
    angle = CCImageViewCreateWithNewValue(@"green",CGRectMake(self.view.width - 50, gh + 5, 25, 25));
    angle.transform = CGAffineTransformIdentity;
    angle.transform = CGAffineTransformMakeRotation(H_DegreesToRadinas(90));
    [self.view addSubview:angle];
    
    angle = CCImageViewCreateWithNewValue(@"green",CGRectMake(self.view.width - 50, gh + 250, 25, 25));
    angle.transform = CGAffineTransformIdentity;
    angle.transform = CGAffineTransformMakeRotation(H_DegreesToRadinas(180));
    [self.view addSubview:angle];
    
    //    [self scannerTipView];
}

- (void)exitCurrentController
{
    if (![self.navigationController popViewControllerAnimated:YES]) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    id<NSFastEnumeration> results =
    [info objectForKey: ZBarReaderControllerResults];
    ZBarSymbol *symbol = nil;
    for(symbol in results)
        break;
    [self.readerView flushCache];
    [self.readerView stop];
    NSString *myContent=symbol.data;
    PSLog(@"myDim:%@",myContent);
    
    if (self.type==ScannerMac) {
        [self performSelector:@selector(bindMac:) withObject:myContent afterDelay:1.5];
    }else if(self.type==ScannerOther){
        [self.delegate scannerMessage:myContent];
        [self performSelector:@selector(exitCurrentController) withObject:nil afterDelay:1.5];
    }
    else{
        if (tipView.frame.origin.y == (org_Y - 180)) {
            return;
        }
        crMsg.text = myContent;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.38];
        tipView.frame = CGRectMake(0, org_Y - 180, 320, 180);
        [UIView commitAnimations];
    }
}

- (void)DimensionalCodeReaderWithContent:(NSString *)myContent
                               fromImage:(UIImage *)image
{
    //    svc.crInfo = myContent;
    PSLog(@"myDim:%@",myContent);
    if (self.type==ScannerMac) {
        [self performSelector:@selector(bindMac:) withObject:myContent afterDelay:1.5];
    }else if(self.type==ScannerOther){
        [self.delegate scannerMessage:myContent];
        [self performSelector:@selector(exitCurrentController) withObject:nil afterDelay:1.5];
    }
    else{
        if (tipView.frame.origin.y == (org_Y - 180)) {
            return;
        }
        crMsg.text = myContent;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.38];
        tipView.frame = CGRectMake(0, org_Y - 180, 320, 180);
        [UIView commitAnimations];
    }
}

#pragma mark -绑定界面
- (void)bindMac:(NSString *)mac
{
    
    if (!stateView) {
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    //    [self.scanLine.layer removeAllAnimations];
    stateView.removeFromSuperViewOnHide=YES;
    stateView.labelText=@"正在绑定...请稍候";
    [self performSelector:@selector(requestSaveBindMac:) withObject:mac afterDelay:1.5];
}

-(void)requestSaveBindMac:(NSString *)mac{
    NSMutableArray *_mydataArray=[NSMutableArray array];
    WFXDeviceFinder * finder = [[WFXDeviceFinder alloc] initWithDispatcher:[[SemiAsyncDispatcher alloc] init]];
    [finder findAllDevicesMatched:^(NSArray *responsedEchos) {
        [_mydataArray addObjectsFromArray:responsedEchos];
    }
                           missed:^{
                           }
                       completion:^{
                           if (_mydataArray.count >0) {
                               DeviceEcho *mymodels = [_mydataArray objectAtIndex:0];
                               PSLog(@"************%@",mymodels);
                               NSString *macBind=[[mymodels.macAddr stringByReplacingOccurrencesOfString:@":" withString:@""] uppercaseString];
                               macBind=[macBind substringToIndex:macBind.length-1];
                               
                               NSString *macAddress=mac;
                               macAddress=[[macAddress stringByReplacingOccurrencesOfString:@":" withString:@""] uppercaseString];
                               macAddress=[macAddress substringToIndex:macAddress.length-1];
                               
                               PSLog(@"---%@----%@",macBind,macAddress);
                               if (![macBind isEqualToString:macAddress]) {
                                   [[[UIAlertView alloc]initWithTitle:@"提示" message:@"扫描路由跟当前连接的路由地址不一致，扫描失败，请确定后重新扫描" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
                                   [self performSelector:@selector(setStateView:) withObject:@NO afterDelay:0.5];
                                   return;
                               }
                               //                               [self.delegate scannerWithParam:@{@"mac":mymodels.macAddr,@"name":mymodels.name}];
                               //                               NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
                               //                               [user setObject:mymodels.token forKey:TOKEN];
                               //                               [user setObject:mymodels.hostIP forKey:ROUTERIP];
                               //                               [user setObject:mymodels.macAddr forKey:ROUTERMAC];
                               //                               [user setObject:mymodels.name forKey:ROUTERNAME];
                               //                               [user setObject:@(YES) forKey:BOUNDMAC];
                               //                               [user synchronize];
                               if ([self.delegate respondsToSelector:@selector(scannerMacWithDeviceEcho:)]) {
                                   [self.delegate scannerMacWithDeviceEcho:mymodels];
                               }
                               stateView.labelText=@"扫描成功!";
                               [self performSelector:@selector(setStateView:) withObject:@YES afterDelay:0.5];
                           }else{
                               [[[UIAlertView alloc]initWithTitle:@"提示" message:@"当前没有可管理的路由器，请确定路由后重新扫描" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil]show];
                           }
                       }];
}

-(void)setStateView:(id)state{
    [UIView animateWithDuration:1 animations:^{
        stateView.alpha=0;
    } completion:^(BOOL finished) {
        stateView.alpha=1;
        stateView.hidden=YES;
        if ([state boolValue]) {
            [self exitCurrentController];
        }
    }];
}






- (void)scannerTipView
{
    org_Y = 504;
    if (is3_5Screen()) {
        
        org_Y = 416;
    }
    
    tipView = [CCView createWithFrame:CGRectMake(0, org_Y, 320, 180) backgroundColor:RGBWhiteColor()];
    [self.view addSubview:tipView];
    
    CCLabel *tip = CCLabelCreateWithNewValue(@"是否确定下载", 17, CGRectMake(0, 20, 320, 40));
    tip.textAlignment = NSTextAlignmentCenter;
    [tipView addSubview:tip];
    
    crMsg = CCLabelCreateWithNewValue(@"", 14, CGRectMake(20, 60, 280, 52));
    crMsg.numberOfLines = 3;
    [tipView addSubview:crMsg];
    
    CCImageView *actionView = CCImageViewCreateWithNewValue(@"0730aj", CGRectMake(13, 125, 294, 41));
    actionView.userInteractionEnabled = YES;
    [tipView addSubview:actionView];
    
    CCButton *cancel = CCButtonCreateWithValue(CGRectMake(0, 0, 147, 41), @selector(cancelOrOK:), self);
    [cancel alterNormalTitle:@"取消"];
    [cancel alterFontSize:15];
    [cancel alterNormalTitleColor:RGBBlackColor()];
    cancel.tag = 0;
    [actionView addSubview:cancel];
    
    CCButton *BtnOK = CCButtonCreateWithValue(CGRectMake(147, 0, 147, 41), @selector(cancelOrOK:), self);
    [BtnOK alterNormalTitle:@"确定"];
    BtnOK.tag = 1;
    [BtnOK alterNormalTitleColor:RGBBlackColor()];
    [BtnOK alterFontSize:15];
    [actionView addSubview:BtnOK];
}

- (void)cancelOrOK:(CCButton *)btn
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.38];
    tipView.frame = CGRectMake(0, org_Y, 320, 180);
    [UIView commitAnimations];
    if (btn.tag==1) {// 确定
        DownLoadViewController *dvc = [[DownLoadViewController alloc]init];
        dvc.url = crMsg.text;
        [self.navigationController pushViewController:dvc animated:YES];
        PSLog(@"确定 %@",crMsg.text);
    }
}


-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    [self exitCurrentController];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
