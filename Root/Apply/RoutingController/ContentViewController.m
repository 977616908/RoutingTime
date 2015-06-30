//
//  ContentViewController.m
//  RoutingTime
//
//  Created by HXL on 15/6/23.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "ContentViewController.h"
#import "RoutingContentController.h"
#import "RoutingCamera.h"
#import "HgView.h"
#import "WgView.h"
#import "UIImageView+WebCache.h"
#import "RoutingWrittinController.h"

@interface ContentViewController ()<SDWebImageManagerDelegate>{
        SDWebImageManager *manager;
}

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
    manager=[SDWebImageManager sharedManager];
    manager.delegate=self;
    RoutingCamera *routing=self.dataObject;
    if (routing) {
        if (routing.rtTag==-1) { //第一张
            UIView *startView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame)-20, CGRectGetHeight(self.view.frame))];
//            startView.backgroundColor=RGBCommon(247, 250, 236);
            startView.backgroundColor=[UIColor whiteColor];
            UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"rt_ybright"]];
            img.frame=CGRectMake(0, 0, 75, CGRectGetHeight(startView.frame));
            [startView addSubview:img];
            [self.view addSubview:startView];
        }else if(routing.rtTag==-2){ //最后一张
            UIView *endView=[[UIView alloc]initWithFrame:CGRectMake(20, 0, CGRectGetWidth(self.view.frame)-20, CGRectGetHeight(self.view.frame))];
//            endView.backgroundColor=RGBCommon(247, 250, 236) ;
            endView.backgroundColor=[UIColor whiteColor];
            UIImageView *img=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"yt_ybleft"]];
            img.frame=CGRectMake(CGRectGetWidth(endView.frame)-75, 0, 75, CGRectGetHeight(endView.frame));
            [endView addSubview:img];
            [self.view addSubview:endView];
        }else{
            NSURL *url=[NSURL URLWithString:routing.rtPath];
            if ([manager diskImageExistsForURL:url]) {
                UIImage *image= [manager.imageCache imageFromDiskCacheForKey:routing.rtPath];
                [self showRouting:routing Image:image];
            }else{
                //            [self downImage:url];
                [NSThread detachNewThreadSelector:@selector(downImage:) toTarget:self withObject:url];
            }
        }

        
    }
    
}


-(void)downImage:(NSURL *)url{
    //    __weak MJPhotoView *photoView = self;
    //    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
    NSData *data=[NSData dataWithContentsOfURL:url];
    UIImage *img=[UIImage imageWithData:data];
    CGFloat count=1;
    if (img.size.width>640) {
        count=img.size.width/640;
    }
    CGFloat wh=img.size.width/count;
    CGFloat hg=img.size.height/count;
    PSLog(@"--%f--%f",wh,hg);
    [manager downloadWithURL:url options:0 width:wh height:hg progress:^(NSUInteger receivedSize, long long expectedSize) {
        dispatch_async(dispatch_get_main_queue(), ^{
//            if (receivedSize > kMinProgress) {
//                _photoLoadingView.progress = (float)receivedSize/expectedSize;
//            }
        });
    } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, BOOL finished) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (image) {
                [self showRouting:_dataObject Image:image];
            }
        });
    }];
}

-(void)showRouting:(RoutingCamera *)routing Image:(UIImage*)image{
    CGFloat moveX=0;
    if (routing.rtTag%2==0) {
        moveX=20;
    }
    UITapGestureRecognizer *imgGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onGestureListener:)];
     UITapGestureRecognizer *txtGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onGestureListener:)];
    if (image.size.width>image.size.height) {
        WgView *wgView=[[WgView alloc]initWithFrame:self.view.bounds];
        wgView.moveX=moveX;
        wgView.imgIcon.image=image;
        wgView.lbTitle.text=routing.rtStory;
        wgView.lbDate.text=routing.rtDate;

        wgView.imgView.userInteractionEnabled=YES;
        [wgView.imgView addGestureRecognizer:imgGesture];
        
        wgView.lbTitle.tag=2;
        wgView.lbTitle.userInteractionEnabled=YES;
        [wgView.lbTitle addGestureRecognizer:txtGesture];
        [self.view addSubview:wgView];
    }else{
        HgView *hgView=[[HgView alloc]initWithFrame:self.view.bounds];
        hgView.moveX=moveX;
        hgView.imgIcon.image=image;
        hgView.lbTitle.text=routing.rtStory;
        hgView.lbDate.text=routing.rtDate;
        
        hgView.imgView.userInteractionEnabled=YES;
        [hgView.imgView addGestureRecognizer:imgGesture];
        
        hgView.lbTitle.tag=2;
        hgView.lbTitle.userInteractionEnabled=YES;
        [hgView.lbTitle addGestureRecognizer:txtGesture];
        [self.view addSubview:hgView];
    }
}


-(void)onGestureListener:(UIGestureRecognizer *)gesture{
    if ([gesture.view tag]==2) {
        RoutingWrittinController *writtinController=[[RoutingWrittinController alloc]init];
        writtinController.dataObject=self.dataObject;
        [self presentViewController:writtinController animated:YES completion:nil];
    }else{
        RoutingContentController *contentController=[[RoutingContentController alloc]init];
        contentController.animView=gesture.view;
        [contentController show];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UIImage*)imageManager:(SDWebImageManager *)imageManager transformDownloadedImage:(UIImage *)image withURL:(NSURL *)imageURL width:(NSInteger)w height:(NSInteger)h {
    //缩放图片
    // Create a graphics image context
    UIGraphicsBeginImageContext(CGSizeMake(w, h));
    
    // Tell the old image to draw in this new context, with the desired
    // new size
    [image drawInRect:CGRectMake(0,0,w, h)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    return newImage;
}


@end
