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
}


- (IBAction)onCancel:(id)sender {
    [self.view removeFromSuperview];
    [self removeFromParentViewController];
}

- (IBAction)onSelectAdd:(id)sender {
}

- (IBAction)onTypeClick:(id)sender {
}
@end
