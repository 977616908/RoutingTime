//
//  ApplyViewController.m
//  RoutingTime
//
//  Created by HXL on 15/6/10.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ApplyViewController.h"
#import "MediaCenterViewController.h"

@interface ApplyViewController (){
    NSArray *arrImg;
}
- (IBAction)onClick:(id)sender;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgArr;

@end

@implementation ApplyViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    arrImg=@[@"hm_asxl",@"hm_aphc",@"hm_aap"];
    [self startAnimation];
}

-(void)coustomNav{
   self.navigationItem.title=@"家庭应用";
    
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
            
            break;
            
        case 2:{
            MediaCenterViewController *mediaController=[[MediaCenterViewController alloc]init];
            mediaController.title=@"应用中心";
            [self.navigationController pushViewController:mediaController animated:YES];
        }
            break;
        case 3:
            
            break;
            
    }
}
@end
