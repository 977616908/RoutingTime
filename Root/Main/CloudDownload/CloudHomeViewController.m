//
//  CloudDownViewController.m
//  RoutingTime
//
//  Created by HXL on 15/3/17.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CloudHomeViewController.h"
#import "CloudViewCell.h"
#import "CloudMessage.h"
#import "CloudTvPlayViewController.h"
#import "CloudFilmViewController.h"
#import "MJRefresh.h"

#define CELLID @"CLOUND"

@interface CloudHomeViewController ()<UICollectionViewDataSource,UICollectionViewDelegate,MJRefreshBaseViewDelegate>{
    NSMutableArray *arrTv;
    NSMutableArray *arrFilm;
    MBProgressHUD *stateView;
    BOOL isRefresh;
}
@property(nonatomic,weak)UIView *bgLine;
@property(nonatomic,weak)UICollectionView *collectionTv;
@property(nonatomic,weak)UICollectionView *collectionFilm;
@property(nonatomic,weak)CCScrollView *rootScrollView;

@property(nonatomic,weak)MJRefreshHeaderView *headerTV;
@property(nonatomic,weak)MJRefreshHeaderView *headerFilm;

@end

@implementation CloudHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self createView];
}

-(void)createView{
    self.view.backgroundColor=[UIColor whiteColor];
    UIView *bgView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 37)];
    bgView.layer.borderWidth=0.5;
    bgView.layer.borderColor=[RGBCommon(2, 137, 193) CGColor];
    bgView.backgroundColor=[UIColor clearColor];
    [self.view addSubview:bgView];
    
    CCButton *btnTv=CCButtonCreateWithValue(CGRectMake(0, 0, 160, 37), @selector(onVedioClick:), self);
    btnTv.tag=1;
    [btnTv alterFontSize:18.0f];
    [btnTv alterNormalTitle:@"电视剧"];
    [btnTv alterNormalTitleColor:RGBCommon(2, 137, 193)];
    [bgView addSubview:btnTv];
    
    CCButton *btnFilm=CCButtonCreateWithValue(CGRectMake(160, 0, 160, 37), @selector(onVedioClick:), self);
    btnFilm.tag=2;
    [btnFilm alterFontSize:18.0f];
    [btnFilm alterNormalTitle:@"电影"];
    [btnFilm alterNormalTitleColor:RGBCommon(2, 137, 193)];
    [bgView addSubview:btnFilm];
    
    UIView *bgLine=[[UIView alloc]initWithFrame:CGRectMake(0, 35, 160, 2)];
    bgLine.backgroundColor=RGBCommon(2, 137, 193);
    self.bgLine=bgLine;
    [bgView addSubview:bgLine];
    
    CGFloat hg=64;
    hg=[UIScreen mainScreen].bounds.size.height-hg-37;
    CCScrollView *rootScrollView=CCScrollViewCreateNoneIndicatorWithFrame(CGRectMake(0, 37, CGRectGetWidth(self.view.frame), hg), self, YES);
    rootScrollView.bounces=YES;
    rootScrollView.contentSize=CGSizeMake(CGRectGetWidth(self.view.frame)*2, 0);
    self.rootScrollView=rootScrollView;
    [self.view addSubview:rootScrollView];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UICollectionView *collectionTv=[[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.rootScrollView.frame), CGRectGetHeight(self.rootScrollView.frame)) collectionViewLayout:layout];
    collectionTv.tag=1;
    collectionTv.showsVerticalScrollIndicator=NO;
    collectionTv.backgroundColor=[UIColor clearColor];
    collectionTv.dataSource=self;
    collectionTv.delegate=self;
    collectionTv.alwaysBounceVertical=YES;
    [collectionTv registerClass:[CloudViewCell class] forCellWithReuseIdentifier:CELLID];
    self.collectionTv=collectionTv;
    [self.rootScrollView addSubview:collectionTv];
    
    UICollectionViewFlowLayout *layout1=[[UICollectionViewFlowLayout alloc] init];
    UICollectionView *collectionFilm=[[UICollectionView alloc]initWithFrame:CGRectMake(CGRectGetWidth(self.rootScrollView.frame), 0, CGRectGetWidth(self.rootScrollView.frame), CGRectGetHeight(self.rootScrollView.frame)) collectionViewLayout:layout1];
    collectionFilm.tag=2;
    collectionFilm.showsVerticalScrollIndicator=NO;
    collectionFilm.backgroundColor=[UIColor clearColor];
    collectionFilm.dataSource=self;
    collectionFilm.delegate=self;
    collectionFilm.alwaysBounceVertical=YES;
    [collectionFilm registerClass:[CloudViewCell class] forCellWithReuseIdentifier:CELLID];
    self.collectionFilm=collectionFilm;
    [self.rootScrollView addSubview:collectionFilm];
    [self setupRefreshView];
    stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    stateView.hidden=YES;
    [self requestWithTv:YES];
}


-(void)initBase{
    arrTv=[NSMutableArray array];
    arrFilm=[NSMutableArray array];
//    for (CloudMessage *msg in _arrCount) {
//        if ([msg.type isEqualToString:@"tv"]) {
//            [arrTv addObject:msg];
//        }else{
//            [arrFilm addObject:msg];
//        }
//    }
   
}


#pragma mark --网络视频请求

-(void)requestWithTv:(BOOL)isTv{
    if (isTv) {
        if(arrTv.count<=0){
          stateView.hidden=NO;
          [self getVedioType:@"tv" Page:1];
        }
    }else{
        if(arrFilm.count<=0){
            stateView.hidden=NO;
           [self getVedioType:@"movie" Page:1];
        }
    }
}

-(void)getVedioType:(NSString *)type Page:(NSInteger)page{
    NSDictionary *params=@{@"tradeCode":@"1010",
                           @"recommendation":@"cloud",
                           @"type":type,
                           @"page":@(page)};
    [self initPostWithURL:CLOUNDURL path:@"moreCloudDown" paras:params mark:type autoRequest:YES];
}


#pragma mark 上拉刷新

-(void)setupRefreshView{
    isRefresh=NO;
    MJRefreshHeaderView *headerTV = [MJRefreshHeaderView header];
    headerTV.tag=1;
    headerTV.scrollView = self.collectionTv;
    headerTV.delegate = self;
    self.headerTV = headerTV;
    
    MJRefreshHeaderView *headerFilm=[MJRefreshHeaderView header];
    headerFilm.tag=2;
    headerFilm.scrollView=self.collectionFilm;
    headerFilm.delegate=self;
    self.headerFilm=headerFilm;
    
}
/**
 *  刷新控件进入开始刷新状态的时候调用
 */
- (void)refreshViewBeginRefreshing:(MJRefreshBaseView *)refreshView
{
    //    if ([refreshView isKindOfClass:[MJRefreshFooterView class]]) { // 上拉刷新
    //        [self loadMoreData];
    //    } else { // 下拉刷新
    //        [self loadNewData];
    //    }
    //    [self initBase];
    isRefresh=YES;
    if (refreshView.tag==1) { //电视剧
        [self getVedioType:@"tv" Page:1];
    }else{ //电影
       [self getVedioType:@"movie" Page:1];
    }
    
}


-(void)onVedioClick:(CCButton *)sendar{
    PSLog(@"--%d--",sendar.tag);
    switch (sendar.tag) {
        case 1:
            [self moveLine:YES];
            break;
        case 2:
            [self moveLine:NO];
            break;
        default:
            break;
    }
}


-(void)moveLine:(BOOL)isLeft{
    CGRect rect=self.bgLine.frame;
    CGFloat move;
    if (isLeft) {
        rect.origin.x=0;
        move=0;
    }else{
        rect.origin.x=160;
        move=320;
    }
    if (!CGRectContainsRect(rect, self.bgLine.frame)) {
        [self requestWithTv:isLeft];
    }
    [UIView animateWithDuration:0.38 animations:^{
        self.bgLine.frame=rect;
        _rootScrollView.contentOffset = CGPointMake(move, 0);
    }];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
//    CGRect rect=self.bgLine.frame;
//    rect.origin.x=self.rootScrollView.contentOffset.x/2;
//    [UIView animateWithDuration:0.35 animations:^{
//        self.bgLine.frame=rect;
//    }];
    if (_rootScrollView.contentOffset.x==0) {
        [self moveLine:YES];
    }else{
        [self moveLine:NO];
    }
}

#pragma mark 成功返回数据处理 mark是标识 response结果
- (void)handleRequestOK:(id)response mark:(NSString *)mark
{
    NSNumber *returnCode=[response objectForKey:@"returnCode"];
    if ([returnCode intValue]==200) {
        NSArray *data=[response objectForKey:@"data"];
        if ([mark isEqualToString:@"tv"]) {
            for (int i=0; i<data.count; i++) {
                NSDictionary *cloudData=data[i];
                if (cloudData) {
                    CloudMessage *msg=[[CloudMessage alloc]initWithData:cloudData];
                    [arrTv addObject:msg];
                }
            }
//              NSInteger counts=[[response objectForKey:@"counts"] integerValue]%9;
            [_collectionTv reloadData];
        }else{
            for (int i=0; i<data.count; i++) {
                NSDictionary *cloudData=data[i];
                if (cloudData) {
                    CloudMessage *msg=[[CloudMessage alloc]initWithData:cloudData];
                    [arrFilm addObject:msg];
                }
            }
            //              NSInteger counts=[[response objectForKey:@"counts"] integerValue]%9;
            [_collectionFilm reloadData];
        }
        [self performSelector:@selector(setStateView:) withObject:@"success" afterDelay:0.5];
    }else{
        NSString *msg=[response objectForKey:@"desc"];
        if (isNIL(msg)) {
            msg=@"网络异常，请检查网络!";
        }
        stateView.labelText=msg;
        [self performSelector:@selector(setStateView:) withObject:@"error" afterDelay:0.5];
    }
    if (isRefresh) {
        isRefresh=NO;
        [_headerTV endRefreshing];
        [_headerFilm endRefreshing];
    }
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
    if (isRefresh) {
        isRefresh=NO;
        [_headerTV endRefreshing];
        [_headerFilm endRefreshing];
    }
    NSDictionary *param=error.userInfo;
    stateView.labelText=[NSString stringWithFormat:@"%@,查询失败!",param[@"error"]];
    [self performSelector:@selector(setStateView:) withObject:@"fail" afterDelay:0.5];
}

-(void)setStateView:(NSString *)state{
    [UIView animateWithDuration:1 animations:^{
        stateView.alpha=0;
    } completion:^(BOOL finished) {
        stateView.alpha=1;
        stateView.hidden=YES;
        if ([state isEqualToString:@"fail"]) {
            
        }
    }];
}

#pragma mark -- UICollectionViewDataSource
//定义展示的UICollectionViewCell的个数

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (collectionView.tag==1) {
         return arrTv.count;
    }else{
        return arrFilm.count;
    }
   
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CloudViewCell *cell = (CloudViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:CELLID
                                                                                     forIndexPath:indexPath];
    CloudMessage *msg;
    if (collectionView.tag==1) {
        msg=arrTv[indexPath.row];
    }else{
        msg=arrFilm[indexPath.row];
    }
    if (msg) {
        cell.lbTitle.text=msg.name;
        cell.lbContent.text=msg.introduction;
        NSString *path=msg.middlePicPath;
//        [cell.imgView setImageWithURL:[path urlInstance]];
        if (hasCachedImageWithString(path)) {
                msg.cloundImage=[UIImage imageWithContentsOfFile:pathForString(path)];
                [cell.imgView setImage:msg.cloundImage];
        }else{
            NSValue *size=[NSValue valueWithCGSize:CGSizeMake(142, 85)];
            NSDictionary *dict=@{@"url":path,@"imageView":cell.imgView,@"size":size};
            [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
        }

    }
    return cell;
}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    return CGSizeMake(150, 120);
}


//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(10, 5, 10, 5);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView.tag==1) {
        CloudTvPlayViewController *tvPlayController=[[CloudTvPlayViewController alloc]init];
        CloudMessage *msg=arrTv[indexPath.row];
        tvPlayController.msg=msg;
        tvPlayController.title=msg.name;
        [self.navigationController pushViewController:tvPlayController animated:YES];
    }else{
        CloudFilmViewController *filmController=[[CloudFilmViewController alloc]init];
        CloudMessage *msg=arrFilm[indexPath.row];
        filmController.msg=msg;
        filmController.title=msg.name;
        [self.navigationController pushViewController:filmController animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


-(void)dealloc{
    [_headerFilm removeFromSuperview];
    [_headerTV removeFromSuperview];
}



@end
