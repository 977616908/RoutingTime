//
//  ContentViewController.m
//  RoutingTime
//
//  Created by HXL on 15/6/23.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ContentViewController.h"
#import "RoutingCamera.h"
#import "HgView.h"
#import "WgView.h"

@interface ContentViewController ()

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
    UIImage *image=[UIImage imageNamed:routing.rtPath];
    if (image.size.width>image.size.height) {
        WgView *wgView=[[WgView alloc]initWithFrame:self.view.bounds];
        wgView.imgIcon.image=[UIImage imageNamed:routing.rtPath];
        wgView.lbTitle.text=routing.rtContent;
        [self.view addSubview:wgView];
    }else{
        HgView *hgView=[[HgView alloc]initWithFrame:self.view.bounds];
        hgView.imgIcon.image=[UIImage imageNamed:routing.rtPath];
        hgView.lbTitle.text=routing.rtContent;
        [self.view addSubview:hgView];
    }

    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
