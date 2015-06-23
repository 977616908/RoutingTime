//
//  RoutingCameraController.m
//  RoutingTest
//
//  Created by apple on 15/6/22.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "RoutingCameraController.h"
#import "RTSlider.h"

@interface RoutingCameraController ()

@property (weak, nonatomic) IBOutlet RTSlider *slider;

- (IBAction)onClick:(id)sender;

- (IBAction)onSilderChange:(id)sender;

@end

@implementation RoutingCameraController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
    [self initView];
    
}

-(void)initView{
    self.slider.minimumValue = 1;
    self.slider.maximumValue = 25;
    self.slider.value = 2;
    //    _steppedSlider.labelOnThumb.hidden = YES;
    self.slider.labelAboveThumb.font = [UIFont systemFontOfSize:16.0];
    self.slider.labelAboveThumb.hidden=YES;
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

- (IBAction)onClick:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)onSilderChange:(id)sender {
    
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
}


@end
