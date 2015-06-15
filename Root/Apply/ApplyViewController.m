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

@interface ApplyViewController (){
    NSArray *arrImg;
}
- (IBAction)onClick:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgArr;
@property (nonatomic,weak)ApplyView *applyView;
@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrImg=@[@"hm_asxl",@"hm_aphc",@"hm_aap"];
    [self startAnimation];
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
            
    }
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
@end
