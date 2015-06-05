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
#import "REPhoto.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "RoutingMsg.h"
#import "RoutingTime.h"
#define HEIGHT 200
#define BARHEIGHT 44

@interface RoutingDetailController ()<UITextViewDelegate,PhotosViewDelegate,PiFiiBaseViewDelegate,UIActionSheetDelegate>{
    NSMutableArray  *_photoArr;
    MBProgressHUD           *stateView;
    NSString *pathArchtive;
    NSMutableOrderedSet     *_saveSet;
    NSMutableOrderedSet     *_deleteArr;
    NSMutableDictionary *params;
    NSInteger downCount;
    UIView       *_toolbar;
    BOOL  isDelete;
}

@property(nonatomic,weak)CCTextView *textView;
@property(nonatomic,weak)PhotosView *photosView;
@property(nonatomic,weak)CCScrollView *rootScrollView;
@property(nonatomic,weak)CCLabel *lbDate;
@property(nonatomic,weak)CCButton *btnSelect;
@end

@implementation RoutingDetailController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title=@"时光片段";
    _photoArr=[NSMutableArray array];
    _deleteArr=[NSMutableOrderedSet orderedSet];
    pathArchtive= pathInCacheDirectory(@"AppCache/SavePhotoName.archiver");
    NSArray *array=[NSKeyedUnarchiver unarchiveObjectWithFile:pathArchtive];
    if (array&&array.count>0) {
        _saveSet=[NSMutableOrderedSet orderedSetWithArray:array];
    }else{
        _saveSet=[NSMutableOrderedSet orderedSet];
    }
    [self createPhotosView];
    [self createTextView];
    [self createView];
    if (_routingTime) {
        NSArray *arr=_routingTime.rtSmallPaths;
        [self addImage:arr];
        _textView.text=_routingTime.rtTitle;
        _lbDate.text=[NSString stringWithFormat:@"创建时间: %@",_routingTime.rtDate];
        for (RoutingMsg *msg in _routingTime.rtPaths) {
            REPhoto *photo=[[REPhoto alloc]init];
            photo.imageUrl=msg.msgPath;
            photo.date=_routingTime.rtDate;
            [_photoArr addObject:photo];
        }
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

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
    
}

-(void)createTextView{
    
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(self.view.frame)-HEIGHT, CGRectGetWidth(self.view.frame), HEIGHT)];
    bgView.backgroundColor=[UIColor whiteColor];
    CCLabel *lbDate=CCLabelCreateWithNewValue(@"", 15, CGRectMake(5, 5, CGRectGetWidth(self.view.frame), 15));
    lbDate.textColor=RGBCommon(181, 181, 181);
    self.lbDate=lbDate;
    [bgView addSubview:lbDate];
    // 1.添加
    CCTextView *textView = [[CCTextView alloc] init];
    textView.font = [UIFont systemFontOfSize:14];
    textView.textColor=RGBCommon(52, 52, 52);
    textView.placeholderColor=RGBCommon(181, 181, 181);
//    textView.backgroundColor=[UIColor redColor];
    textView.frame = CGRectMake(7, 20, CGRectGetWidth(bgView.frame)-15, CGRectGetHeight(bgView.frame)-51);
//    textView.textContainerInset=UIEdgeInsetsMake(15, 10, 0, 10);
    // 垂直方向上永远可以拖拽
    textView.alwaysBounceVertical = YES;
    textView.delegate = self;
    textView.editable=NO;
//    textView.placeholder = @"这一刻的想法...";
    self.textView = textView;
    [bgView addSubview:textView];
    
    UIView *line=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(bgView.frame)-31, CGRectGetWidth(bgView.frame), 1)];
    line.backgroundColor=RGBCommon(181, 181, 181);
    [bgView addSubview:line];
    
    UIView *bgTool=[[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetHeight(bgView.frame)-30, CGRectGetWidth(bgView.frame), 30)];
    bgTool.backgroundColor=[UIColor whiteColor];
    CCButton *btnComment=CCButtonCreateWithValue(CGRectMake(0, 0, CGRectGetWidth(bgTool.frame)/2, 30), @selector(onCommentClick:), self);
    btnComment.tag=1;
    [btnComment alterFontSize:12];
    [btnComment setImage:[UIImage imageNamed:@"hm_share"] forState:UIControlStateNormal];
    [btnComment alterNormalTitle:@"分享"];
    [bgTool addSubview:btnComment];
    
    CCButton *btnEdit=CCButtonCreateWithValue(CGRectMake(0, CGRectGetWidth(bgTool.frame)/2, CGRectGetWidth(bgTool.frame)/2, 30), @selector(onCommentClick:), self);
    btnEdit.tag=1;
    [btnEdit alterFontSize:12];
    [btnEdit setImage:[UIImage imageNamed:@"hm_edit"] forState:UIControlStateNormal];
    [btnEdit alterNormalTitle:@"编辑"];
    [bgTool addSubview:btnEdit];
    [bgView addSubview:bgTool];
  
    
    [self.view addSubview:bgView];
}


-(void)createView{
    CCButton *sendBut = CCButtonCreateWithValue(CGRectMake(-10, 0, 50,50), @selector(addPhotoListener:), self);
    [sendBut alterNormalTitle:@"选择"];
    [sendBut alterNormalTitleColor:RGBWhiteColor()];
    [sendBut alterFontSize:16];
    self.btnSelect=sendBut;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:sendBut];
    _toolbar = [[UIView alloc] init];
    _toolbar.backgroundColor=RGBCommon(63, 205, 225);
    _toolbar.frame = CGRectMake(0, CGRectGetHeight(self.view.frame), CGRectGetWidth(self.view.frame), BARHEIGHT);
    _toolbar.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    
    UIButton *downBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    downBtn.frame=CGRectMake(20, 0, BARHEIGHT, BARHEIGHT);
    downBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    downBtn.tag=1;
    [downBtn setImage:[UIImage imageNamed:@"hm_baocun_selector"] forState:UIControlStateNormal];
    //    [_deleteBtn setImage:[UIImage imageNamed:@"photo-gallery-trashcan.png"] forState:UIControlStateHighlighted];
    [downBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:downBtn];
    
    UIButton *deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    deleteBtn.frame=CGRectMake(CGRectGetWidth(self.view.frame)-20-BARHEIGHT, 0, BARHEIGHT, BARHEIGHT);
    deleteBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
    [deleteBtn setImage:[UIImage imageNamed:@"hm_shanchu_selector"] forState:UIControlStateNormal];
    deleteBtn.tag=2;
    //    [_deleteBtn setImage:[UIImage imageNamed:@"photo-gallery-trashcan.png"] forState:UIControlStateHighlighted];
    [deleteBtn addTarget:self action:@selector(onClick:) forControlEvents:UIControlEventTouchUpInside];
    [_toolbar addSubview:deleteBtn];
    [self.view addSubview:_toolbar];
}

-(void)onCommentClick:(CCButton *)sendar{
    PSLog(@"--评论--%d",sendar.tag);
}

-(void)onClick:(UIButton *)sendar{
    PSLog(@"--图片--%d",sendar.tag);
    UIActionSheet *action=nil;
    switch (sendar.tag) {
        case 1:
            if (_deleteArr.count==1) {
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"下载到本地" otherButtonTitles:nil, nil];
            }else{
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"下载%d张到本地",_deleteArr.count] otherButtonTitles:nil, nil];
            }
            [action showInView:self.view];
            break;
        case 2:
            if (_deleteArr.count==1) {
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:@"删除照片" otherButtonTitles:nil, nil];
            }else{
                action=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:[NSString stringWithFormat:@"删除%d张照片",_deleteArr.count] otherButtonTitles:nil, nil];
            }
            [action showInView:self.view];
            break;
    }
    
}

-(void)addPhotoListener:(CCButton*)sendar{
    if ([sendar.titleLabel.text isEqualToString:@"选择"]) {
        [sendar alterNormalTitle:@"取消"];
        [self toolBarWithAnimation:NO];
        self.title=@"选择项目";
        isDelete=YES;
    }else{
        [sendar alterNormalTitle:@"选择"];
        [self toolBarWithAnimation:YES];
        self.title=@"时光片段";
        isDelete=NO;
    }
    [_deleteArr removeAllObjects];
}

-(void)toolBarWithAnimation:(BOOL)isHidden{
    CGFloat barY=0;
    if (isHidden) {
        barY=CGRectGetHeight(self.view.frame);
    }else{
        barY=CGRectGetHeight(self.view.frame)-BARHEIGHT;
    }
    [UIView animateWithDuration:0.3 animations:^{
        _toolbar.frame = CGRectMake(0, barY, CGRectGetWidth(self.view.frame), BARHEIGHT);
    }];
}


-(void)photosTapWithIndex:(NSInteger)index{
    PSLog(@"--add--[%d]",index);
    if (isDelete) {
        UIImageView *delImg=self.photosView.totalImages[index-1];
        
        UIImageView *selectImg=[[UIImageView alloc]init];
        UIImage *image=@"ImageSelectedOn".imageInstance;
        CGSize size=image.size;
        selectImg.frame=CGRectMake(CGRectGetWidth(delImg.frame)-size.width, CGRectGetHeight(delImg.frame)-size.height, size.width, size.height);
        [delImg addSubview:selectImg];
    }else{
        MJPhotoBrowser *photo=[[MJPhotoBrowser alloc]init];
        photo.isPhoto=NO;
        photo.currentPhotoIndex=index-1;
        photo.photos=_photoArr;
        //    photo.pifiiDelegate=self;
        [self.navigationController.view.layer addAnimation:[self customAnimationType:kCATransitionFade upDown:NO]  forKey:@"animation"];
        [self.navigationController pushViewController:photo animated:NO];
    }
}




-(void)addImage:(id)dataSource{
    for (RoutingMsg *msg in dataSource) {
        NSString *path=msg.msgPath;
        //        [cell.imgView setImageWithURL:[path urlInstance]];
        if (hasCachedImageWithString(path)) {
            UIImage *image=[UIImage imageWithContentsOfFile:pathForString(path)];
            UIImage *scaleImag=[[ImageCacher defaultCacher]scaleImage:image size:CGSizeMake(144, 144)];
            [self.photosView addImage:scaleImag duration:nil];
        }else{
            UIImageView *image=[self.photosView addImage:nil duration:nil];
            NSValue *size=[NSValue valueWithCGSize:image.frame.size];
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
