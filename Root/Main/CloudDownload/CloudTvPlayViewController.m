//
//  CloudTvPlayViewController.m
//  RoutingTime
//
//  Created by HXL on 15/3/18.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CloudTvPlayViewController.h"
#import "SeveralViewCell.h"
#import "CloudTvSeveralViewController.h"

#define CELLID @"SeveralID"

@interface CloudTvPlayViewController ()<UICollectionViewDataSource,UICollectionViewDelegate>{
    NSMutableArray *arrCount;
    MBProgressHUD *stateView;
}

@property (weak, nonatomic) IBOutlet UIScrollView *rootScrollView;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lbTvNames;
@property (weak, nonatomic) IBOutlet UILabel *lbNetFrom;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *lbContents;

@property (weak, nonatomic) IBOutlet UILabel *tvIntroduction;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionCount;
@property (strong, nonatomic) IBOutletCollection(UIImageView) NSArray *imgArr;


- (IBAction)onClick:(id)sender;


@end

@implementation CloudTvPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor=[UIColor whiteColor];
    CGRect rect=[[UIScreen mainScreen]bounds];
    CGFloat contentHeight=rect.size.height-64;
    _rootScrollView.frame=CGRectMake(0, 0, CGRectGetWidth(rect), contentHeight);
    CGRect textRect=_tvIntroduction.frame;
    CGSize textSize=[GlobalShare sizeWithText:_tvIntroduction.text font:_tvIntroduction.font maxSize:CGSizeMake(CGRectGetWidth(textRect), MAXFLOAT)];
    textRect.size=textSize;
    _tvIntroduction.frame=textRect;
    _rootScrollView.contentSize=CGSizeMake(0, CGRectGetMaxY(_tvIntroduction.frame)+15);
    [_collectionCount registerClass:[SeveralViewCell class] forCellWithReuseIdentifier:CELLID];
   
}

-(void)initBase{
    arrCount=[NSMutableArray array];
    for(int i=0;i<[self.msg.updateAmountNew integerValue];i++){
        NSString *count=[NSString stringWithFormat:@"%02d",i+1];
        [arrCount addObject:count];
    }
    NSString *account=[NSString stringWithFormat:@"更新至%@集/全%@集",_msg.updateAmountNew,_msg.updateAmountAll];
    if ([_msg.updateAmountNew isEqualToString:_msg.updateAmountAll])
        account=[NSString stringWithFormat:@"%@集全",_msg.updateAmountNew];
    NSArray *titles=@[_msg.name,account];
    for (int i=0; i<titles.count; i++) {
        ((UILabel *)self.lbTvNames[i]).text=titles[i];
    }
    
    NSArray *contents=@[_msg.protagonist,_msg.director,_msg.region,_msg.year];
    for (int i=0; i<contents.count; i++) {
        ((UILabel *)self.lbContents[i]).text=contents[i];
    }
    _tvIntroduction.text=_msg.introduction;
    _lbNetFrom.text=_msg.netFrom;
    NSArray *imgArr=@[_msg.bigPicPath,_msg.smallPicPath];
    for (int i=0; i<imgArr.count; i++) {
        NSString *path=imgArr[i];
        UIImageView *img=_imgArr[i];
        CGSize size=CGSizeMake(65, 90);
        if (i==0)size=CGSizeMake(320, 175);
        if (hasCachedImageWithString(path)) {
            img.image=[UIImage imageWithContentsOfFile:pathForString(path)];
        }else{
            NSValue *value=[NSValue valueWithCGSize:size];
            NSDictionary *dict=@{@"url":path,@"imageView":img,@"size":value};
            [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
        }
    }
}

- (IBAction)onClick:(id)sender {
    switch ([sender tag]) {
        case 1:{
            CloudTvSeveralViewController *severalController=[[CloudTvSeveralViewController alloc]init];
            severalController.title=self.title;
            severalController.msg=self.msg;
            [self.navigationController pushViewController:severalController animated:YES];
        }
            break;
        case 2:
            [[[UIAlertView alloc]initWithTitle:@"" message:@"自动下载最新剧集" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil]show];
            break;
        default:
            break;
    }
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
        [cell.btnDown setImage:[UIImage imageNamed:@"hm_yxiaz"] forState:UIControlStateNormal];
    }else{
        cell.btnDown.hidden=YES;
    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSString *msg=arrCount[indexPath.row];
    [self showToast:[NSString stringWithFormat:@"成功添加第%@集至下载列表",msg] Long:2.0];
}

#pragma mark -网络下载
-(void)requestDown{
    if (!stateView) {
        stateView=[MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
    stateView.labelText=@"添加下载...请稍候!";
    stateView.hidden=NO;
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
    stateView.labelText=@"添加失败";
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


#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(51, 51);
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0,10, 0, 10);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
