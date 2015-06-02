//
//  CloudTvSeveralViewController.m
//  WoPiiFi_test
//
//  Created by apple on 15/3/18.
//  Copyright (c) 2015年 chenhp. All rights reserved.
//

#import "CloudTvSeveralViewController.h"
#import "SeveralViewCell.h"
#import "CloudDownViewController.h"
#define CELLID @"SEVERAL"
@interface CloudTvSeveralViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *arrCount;
}
@property(nonatomic,weak)UILabel *lbCount;

@end

@implementation CloudTvSeveralViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=RGBCommon(234, 234, 234);
    [self initCreate];
}

-(void)initCreate{
    UIView *bgDown=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 44)];
    bgDown.backgroundColor=[UIColor whiteColor];
    UILabel *lbContent=[[UILabel alloc]initWithFrame:CGRectMake(110, 0, 75, 44)];
    lbContent.text=@"查看下载";
    lbContent.font=[UIFont systemFontOfSize:18.0f];
    lbContent.backgroundColor=[UIColor clearColor];
    UILabel *lbCount=[[UILabel alloc]initWithFrame:CGRectMake(185, 13, 18, 18)];
    lbCount.backgroundColor=[UIColor colorWithPatternImage:[UIImage imageNamed:@"hm_ckxz"]];
    lbCount.text=@"2";
    lbCount.textAlignment=NSTextAlignmentCenter;
    lbCount.font=[UIFont systemFontOfSize:14.0f];
    lbCount.textColor=[UIColor whiteColor];
    self.lbCount=lbCount;
    [bgDown addSubview:lbCount];
    
    UIImageView *img=[[UIImageView alloc]initWithFrame:CGRectMake(300, 14, 12, 12)];
    img.image=[UIImage imageNamed:@"hm_jinru"];
    [bgDown addSubview:img];
    [bgDown addSubview:lbContent];
    bgDown.layer.borderWidth=0.5;
    bgDown.layer.borderColor=[RGBCommon(197, 197, 197) CGColor];
    UITapGestureRecognizer *tapGesture=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapClick)];
    [bgDown addGestureRecognizer:tapGesture];
    [self.view addSubview:bgDown];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionVertical];
    UICollectionView *collectionSeveral=[[UICollectionView alloc]initWithFrame:CGRectMake(0,CGRectGetMaxY(bgDown.frame), 320, CGRectGetHeight(self.view.frame)-100) collectionViewLayout:layout];
    collectionSeveral.showsVerticalScrollIndicator=NO;
    collectionSeveral.backgroundColor=[UIColor clearColor];
    collectionSeveral.dataSource=self;
    collectionSeveral.delegate=self;
    [collectionSeveral registerClass:[SeveralViewCell class] forCellWithReuseIdentifier:CELLID];
    [self.view addSubview:collectionSeveral];
    
    
    
  
}

-(void)onTapClick{
    CloudDownViewController *downController=[[CloudDownViewController alloc]init];
    [self.navigationController pushViewController:downController animated:YES];
}

-(void)initBase{
    arrCount=[NSMutableArray array];
    for(int i=0;i<[self.msg.updateAmountNew integerValue];i++){
        NSString *count=[NSString stringWithFormat:@"%02d",i+1];
        [arrCount addObject:count];
    }
    PSLog(@"%@",self.msg.downloadUrl);
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return arrCount.count;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    SeveralViewCell *cell=[collectionView dequeueReusableCellWithReuseIdentifier:CELLID forIndexPath:indexPath];
    cell.textCount.text=arrCount[indexPath.row];
    if (indexPath.row==1||indexPath.row==2) {
        cell.btnDown.hidden=NO;
        [cell.btnDown setImage:[UIImage imageNamed:@"hm_xiazai"] forState:UIControlStateNormal];
    }else{
        cell.btnDown.hidden=YES;
    }
    return cell;
}


-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    SeveralViewCell *cell=(SeveralViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    if (cell.btnDown.hidden) {
        cell.btnDown.hidden=NO;
        [cell.btnDown setImage:[UIImage imageNamed:@"hm_xiazai"] forState:UIControlStateNormal];
        _lbCount.text=[NSString stringWithFormat:@"%d",[_lbCount.text integerValue]+1];
        [self showToast:[NSString stringWithFormat:@"成功添加第%@集至下载列表",arrCount[indexPath.row]] Long:2.0];
    }
}

#pragma mark -网络下载
-(void)requestDown{
    NSDictionary *param=@{@"tradeCode":@1012,
                          @"id":@"0001",
                          @"download_amount":@"1",
                          @"download_url":@"",
                          @"type":@"download"};
    [self initPostWithURL:CLOUNDURL path:@"moreCloudDown" paras:param mark:@"cloudDown" autoRequest:YES];
}

-(void)handleRequestOK:(id)response mark:(NSString *)mark{
    
}

-(void)handleRequestFail:(NSError *)error mark:(NSString *)mark{
  
    
}



#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(51, 51);
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(20,10,20,10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}

@end
