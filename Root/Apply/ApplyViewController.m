//
//  ApplyViewController.m
//  RoutingTime
//
//  Created by HXL on 15/6/10.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ApplyViewController.h"
#import "MediaCenterViewController.h"
#import "ApplyView.h"
#import "CameraViewController.h"
#import "NetSaveViewController.h"
#import "NetWorkViewController.h"
#import "NetInstallController.h"

@interface ApplyViewController (){
    NSArray *arrImg;
    NSInteger showCount;
}
- (IBAction)onClick:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgArr;
@property (nonatomic,weak)ApplyView *applyView;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *wfImgs;
@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrImg=@[@"hm_asxl",@"hm_aphc",@"hm_aap",@"hm_save"];
    showCount=0;
    [self startAnimation];
    [self startWifiiAnimation];
}

-(void)coustomNav{
   self.navigationItem.title=@"家庭应用";
   CCButton *sendBut = CCButtonCreateWithValue(CGRectMake(10, 0, 30, 20), @selector(onAddClick:), self);
   sendBut.tag=1;
   [sendBut setImage:[UIImage imageNamed:@"hm_add"] forState:UIControlStateNormal];
   [sendBut setImage:[UIImage imageNamed:@"hm_add_select"] forState:UIControlStateSelected];
   self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBut];
}

-(void)onAddClick:(id)sendar{
    if (!_applyView) {
        CGFloat gh=0;
        if(is_iOS7())gh=50;
        ApplyView *applyView=[[ApplyView alloc]initWithFrame:CGRectMake(0,0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-gh)];
        self.applyView=applyView;
        [self.view addSubview:applyView];
    }
    [self.applyView moveTransiton:YES];
    _applyView.type=^(NSInteger tag){
        PSLog(@"---[%d]---",tag);
        switch (tag) {
            case 0:{
                
            }
                break;
            case 1:{
                CameraViewController *cameraController=[[CameraViewController alloc]init];
                [self.navigationController pushViewController:cameraController animated:YES];
            }
                break;
            case 2:{
                NetInstallController *installController=[[NetInstallController alloc]init];
                [self.navigationController pushViewController:installController animated:YES];
            }
                break;
            default:
                break;
        }
        [self.applyView moveTransiton:NO];
    };
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)onClick:(id)sender {
    UIImageView *image=((UIImageView *)_imgArr[[sender tag]-1]);
    [UIView animateWithDuration:0.5 animations:^{
        image.transform=CGAffineTransformMakeScale(1.5, 1.5);
    } completion:^(BOOL finished) {
        image.transform=CGAffineTransformIdentity;
        [self startController:[sender tag]];
    }];

}

-(void)startController:(NSInteger)tag{
    switch (tag) {
        case 1:
            [self showToast:@"暂未连接到摄像头" Long:1.5];
            break;
            
        case 2:{
            MediaCenterViewController *mediaController=[[MediaCenterViewController alloc]init];
            mediaController.title=@"应用中心";
            [self.navigationController pushViewController:mediaController animated:YES];
        }
            break;
        case 3:
            [self showToast:@"暂未连接到该设备" Long:1.5];
            break;
        case 4:{
            NSUserDefaults *user = [NSUserDefaults standardUserDefaults];
            id password=[user objectForKey:NETPASSWORD];
            if ([password length]>0) {
                NetSaveViewController *saveController=[[NetSaveViewController alloc]init];
                [self.navigationController pushViewController:saveController animated:YES];
            }else{
                NetWorkViewController *workController=[[NetWorkViewController alloc]init];
                [self.navigationController pushViewController:workController animated:YES];
            }
            //                [self setMacBounds];
        }
            break;
            
    }
}

#pragma mark 启动动画
-(void)startWifiiAnimation{
    [UIView animateWithDuration:0.65 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        UIImageView *image=(UIImageView *)_wfImgs[showCount];
        image.alpha=1.0;
    } completion:^(BOOL finished) {
        showCount+=1;
        if (showCount==_wfImgs.count) {
            showCount=0;
            for (UIImageView *image in _wfImgs) {
                image.alpha=0.1;
            }
        }else{
            UIImageView *image=(UIImageView *)_wfImgs[showCount];
            image.alpha=0.1;
        }
        [self startWifiiAnimation];
    }];
}

- (void)startAnimation
{
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        for (int i=0; i<_imgArr.count; i++) {
            UIImageView *image=(UIImageView *)_imgArr[i];
            image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_select",arrImg[i]]];
            image.alpha=1.0;
        }
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            for (int i=0; i<_imgArr.count; i++) {
                UIImageView *image=(UIImageView *)_imgArr[i];
                image.image=[UIImage imageNamed:arrImg[i]];
                image.alpha=0.3;
            }
        } completion:^(BOOL finished) {
            [self startAnimation];
        }];
    }];
    
}


/**
 * 判断是否绑定与连接PIFii路由
 */
-(BOOL)setMacBounds{
    BOOL isBound=[GlobalShare isBindMac];
    if (!isBound) {
        [[[UIAlertView alloc]initWithTitle:@"提示" message:@"网络异常或未绑定PiFii路由" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
    }else{
        BOOL isConnect=[[[NSUserDefaults standardUserDefaults]objectForKey:ISCONNECT]boolValue];
        if (!isConnect) {
            [[[UIAlertView alloc]initWithTitle:@"提示" message:@"未连接绑定PiFii路由" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil] show];
            isBound=NO;
        }
    }
    return isBound;
}
@end
