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
#import "AlbumInstallController.h"
#import "RoutingListController.h"

@interface ApplyViewController ()<PiFiiBaseViewDelegate>{
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
    [self startWifiiAnimation];
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.navigationBarHidden=NO;
    // 删除系统自动生成的UITabBarButton
    for (UIView *child in self.tabBarController.tabBar.subviews) {
        if ([child isKindOfClass:[UIControl class]]) {
            [child removeFromSuperview];
        }
    }
    if([GlobalShare isBindMac]){
        UIImageView *image=_imgArr[1];
        if (image.tag!=2) {
            image.tag=2;
            [self startAnimation:image];
        }
    }
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
                AlbumInstallController  *albumController=[[AlbumInstallController alloc]init];
                albumController.pifiiDelegate=self;
                [self.navigationController pushViewController:albumController animated:YES];
            }
                break;
            case 1:{
                CameraViewController *cameraController=[[CameraViewController alloc]init];
                cameraController.pifiiDelegate=self;
                [self.navigationController pushViewController:cameraController animated:YES];
            }
                break;
            case 2:{
                NetInstallController *netController=[[NetInstallController alloc]init];
                netController.pifiiDelegate=self;
                [self.navigationController pushViewController:netController animated:YES];
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
    NSArray *arr=@[@"暂未添加摄像头连接",@"暂未绑定路由",@"暂未添加时光相册",@"暂未添加安全上网控件"];
    UIImageView *image=((UIImageView *)_imgArr[[sender tag]-1]);
    if(image.tag==[sender tag]){
        [sender setEnabled:NO];
        [UIView animateWithDuration:0.5 animations:^{
            image.transform=CGAffineTransformMakeScale(1.5, 1.5);
        } completion:^(BOOL finished) {
            image.transform=CGAffineTransformIdentity;
            [sender setEnabled:YES];
            [self startController:[sender tag]];
        }];
    }else{
       [self showToast:arr[[sender tag]-1] Long:1.5];
        RoutingListController *routingController=[[RoutingListController alloc]init];
        [self.navigationController pushViewController:routingController animated:YES];
    }


}

-(void)startController:(NSInteger)tag{
    switch (tag) {
        case 1:{
           
        }
            break;
            
        case 2:{
            MediaCenterViewController *mediaController=[[MediaCenterViewController alloc]init];
            mediaController.title=@"应用中心";
            [self.navigationController pushViewController:mediaController animated:YES];
        }
            break;
        case 3:{
            RoutingListController *routingController=[[RoutingListController alloc]init];
            [self.navigationController pushViewController:routingController animated:YES];
        }
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

- (void)startAnimation:(UIImageView *)image
{
    [UIView animateWithDuration:1.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        image.image=[UIImage imageNamed:[NSString stringWithFormat:@"%@_select",arrImg[[_imgArr indexOfObject:image]]]];
        image.alpha=1.0;
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.3 animations:^{
            image.image=[UIImage imageNamed:arrImg[[_imgArr indexOfObject:image]]];
            image.alpha=0.3;
        } completion:^(BOOL finished) {
            [self startAnimation:image];
        }];
    }];
    
}

-(void)pushViewDataSource:(id)dataSource{
    NSInteger count=[dataSource integerValue];
    UIImageView *image=_imgArr[count];
    if(image.tag!=count+1){
        image.tag=count+1;
        [self startAnimation:image];
    }
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
