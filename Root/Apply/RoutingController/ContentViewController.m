//
//  ContentViewController.m
//  RoutingTime
//
//  Created by HXL on 15/6/23.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ContentViewController.h"
#import "RoutingCamera.h"

@interface ContentViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UIImageView *imgTitle;

@end

@implementation ContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [self initView];
    
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self initView];
}

-(void)initView{
    RoutingCamera *routing=self.dataObject;
    self.lbTitle.text=routing.rtContent;
    self.imgTitle.image=[UIImage imageNamed:routing.rtPath];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
