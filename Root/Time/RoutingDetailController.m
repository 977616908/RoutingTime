//
//  ComposeViewController.m
//  RoutingTime
//
//  Created by HXL on 15/5/20.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "RoutingDetailController.h"
#import "CCTextView.h"
#import "PhotosView.h"
#import "MJPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RoutingMsg.h"
#import "RoutingTime.h"
#define HEIGHT 200

@interface RoutingDetailController ()<UITextViewDelegate,PhotosViewDelegate,PiFiiBaseViewDelegate>{
    NSMutableArray  *_photoArr;
    MBProgressHUD           *stateView;
    NSString *pathArchtive;
    NSMutableOrderedSet     *_saveSet;
    NSMutableDictionary *params;
    NSInteger downCount;
}

@property(nonatomic,weak)CCTextView *textView;
@property(nonatomic,weak)PhotosView *photosView;
@property(nonatomic,weak)CCScrollView *rootScrollView;
@end

@implementation RoutingDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"时光片段";
    _photoArr=[NSMutableArray array];
    pathArchtive= pathInCacheDirectory(@"AppCache/SavePhotoName.archiver");
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchtive];
    if (array&&array.count>0) {
        _saveSet=[NSMutableOrderedSet orderedSetWithArray:array];
    }else{
        _saveSet=[NSMutableOrderedSet orderedSet];
    }
    self.view.backgroundColor = [UIColor whiteColor];
    [self createPhotosView];
    [self createTextView];
    if (_routingTime) {
        NSArray *arr=_routingTime.rtSmallPaths;
        [self addImage:arr];
        _textView.text=_routingTime.rtTitle;
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

}


-(void)createTextView{
    // 1.添加
    CCTextView *textView = [[CCTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:14];
    textView.placeholderColor=RGBCommon(181, 181, 181);
    
    textView.frame = CGRectMake(7, CGRectGetMaxY(self.rootScrollView.frame), CGRectGetWidth(self.view.frame)-15, HEIGHT);
//    textView.textContainerInset=UIEdgeInsetsMake(15, 10, 0, 10);
    // 垂直方向上永远可以拖拽
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.editable=NO;
//    textView.placeholder = @"这一刻的想法...";
    [self.view addSubview:textView];
    self.textView = textView;
}

-(void)createPhotosView{
    CCScrollView *scrollView=CCScrollViewCreateNoneIndicatorWithFrame(CGRectMake(0, 5, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)-HEIGHT), self, NO);
    scrollView.bounces=YES;
    self.rootScrollView=scrollView;
    [self.view addSubview:scrollView];
    
    PhotosView *photosView = [[PhotosView alloc] init];
    photosView.isAdd=YES;
    photosView.frame = CGRectMake(0, 0, CGRectGetWidth(self.rootScrollView.frame), CGRectGetHeight(self.rootScrollView.frame));
    self.photosView = photosView;
    photosView.delegate=self;
    [self.rootScrollView addSubview:photosView];

    
//    [photosView addImage:[UIImage imageNamed:@"hm_zengjjiad"]];
    
}

-(void)onAddTap:(id)sendar{
    PSLog(@"--add--");
    
}

-(void)photosTapWithIndex:(NSInteger)index{
    PSLog(@"--add--[%d]",index);

    MJPhotoBrowser *photo=[[MJPhotoBrowser alloc]init];
    photo.isPhoto=YES;
    photo.currentPhotoIndex=index-1;
    photo.photos=_photoArr;
//    photo.pifiiDelegate=self;
    [self.navigationController.view.layer addAnimation:[self customAnimationType:kCATransitionFade upDown:NO]  forKey:@"animation"];
    [self.navigationController pushViewController:photo animated:NO];
    
}




-(void)addImage:(id)dataSource{
    for (RoutingMsg *msg in dataSource) {
        NSString *path=msg.msgPath;
        //        [cell.imgView setImageWithURL:[path urlInstance]];
        if (hasCachedImageWithString(path)) {
            UIImage *image=[UIImage imageWithContentsOfFile:pathForString(path)];
            [self.photosView addImage:image duration:nil];
        }else{
            UIImageView *image=[self.photosView addImage:nil duration:nil];
            NSValue *size=[NSValue valueWithCGSize:CGSizeMake(144, 144)];
            NSDictionary *dict=@{@"url":path,@"imageView":image,@"size":size};
            [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
        }
    }
    CGFloat gh=self.photosView.subviews.count/4*80;
    self.rootScrollView.contentSize=CGSizeMake(0, gh);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.view endEditing:YES];
}


-(void)textViewDidChange:(UITextView *)textView{
    self.navigationItem.rightBarButtonItem.enabled = (self.textView.text.length != 0);
    
}

-(CATransition *)customAnimationType:(NSString *)type upDown:(BOOL )boolUpDown{
    CATransition *animation = [CATransition animation];
    animation.duration = 0.5f ;
    animation.type = type;//101
    if (boolUpDown) {
        animation.subtype = kCATransitionFromTop;
    }else{
        animation.subtype = kCATransitionFromBottom;
    }
    animation.timingFunction = UIViewAnimationCurveEaseInOut;
    
    return animation;
}


@end
