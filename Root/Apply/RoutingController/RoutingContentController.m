//
//  RoutingCameraController.m
//  RoutingTest
//
//  Created by apple on 15/6/22.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "RoutingContentController.h"
#import "RTSlider.h"

@interface RoutingContentController ()

- (IBAction)onCancel:(id)sender;

- (IBAction)onSelectAdd:(id)sender;

- (IBAction)onTypeClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation RoutingContentController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(BOOL)shouldAutorotate{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (void)show
{
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    [window addSubview:self.view];
    [window.rootViewController addChildViewController:self];
    UIImageView *image=_animView.subviews[0];
    UIScrollView *rootScrollView=[self addImage:image];
    
    CGRect moveRect=self.bgView.frame;
    rootScrollView.origin=CGPointMake((CGRectGetWidth(moveRect)-CGRectGetWidth(rootScrollView.frame))/2, (CGRectGetHeight(moveRect)-CGRectGetHeight(rootScrollView.frame))/2);
    [self.bgView addSubview:rootScrollView];
    self.bgView.frame=[_animView convertRect:_animView.bounds toView:nil];
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame=moveRect;
    }];
}


-(UIScrollView *)addImage:(UIImageView *)image{
    UIScrollView *moveScroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(image.frame)*1.5, CGRectGetHeight(image.frame)*1.5)];
    moveScroll.pagingEnabled=NO;
    moveScroll.contentSize=image.image.size;
    UIImageView *imgView=[[UIImageView alloc]initWithImage:image.image];
    [moveScroll addSubview:imgView];
    return moveScroll;
}

- (IBAction)onCancel:(id)sender {
    [UIView animateWithDuration:0.3 animations:^{
        self.bgView.frame=[_animView convertRect:_animView.bounds toView:nil];
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
        [self removeFromParentViewController];
    }];

}

- (IBAction)onSelectAdd:(id)sender {
//    RoutingImagesController *listController=[[RoutingImagesController alloc]init];
//    [self.view addSubview:listController.view];
//    [self addChildViewController:listController];
}

- (IBAction)onTypeClick:(id)sender {
    
}


@end
