//
//  RoutingCameraController.m
//  RoutingTest
//
//  Created by apple on 15/6/22.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "RoutingWrittinController.h"
#import "RTSlider.h"
#import "CCTextView.h"

@interface RoutingWrittinController ()
- (IBAction)onClick:(id)sender;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@end

@implementation RoutingWrittinController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initView];
}

-(void)initView{
    CCTextView *txtContent=[[CCTextView alloc]initWithFrame:self.bgView.bounds];
    txtContent.placeholder=@"点击这里编辑文字...";
    txtContent.textColor=RGBCommon(171, 171, 171);
    txtContent.font=[UIFont systemFontOfSize:16.0f];
    [self.bgView addSubview:txtContent];
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
@end
