//
//  PiFiiHeadView.m
//  RoutingTime
//
//  Created by Harvey on 14-5-8.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "MediaCenterView.h"
#import "MediaViewCell.h"
#import "CloudMessage.h"
#import "REPhotoController.h"
#import "MJPhotoBrowser.h"
#import "SearchViewController.h"
#import "CloudHomeViewController.h"
#import "CloudFilmViewController.h"
#import "CloudTvPlayViewController.h"
#import "PermissionSetController.h"
#import "MoPiiViewController.h"
#define KCellIdentifier @"identifier"
#define IMAGEHEIGHT 92

@interface MediaCenterView () <UISearchBarDelegate,UICollectionViewDataSource,UICollectionViewDelegate
>
@property(nonatomic,weak)UICollectionView *collectionPhoto;
@property(nonatomic,weak)UICollectionView *collectionVedio;
@end

@implementation MediaCenterView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        [self viewLoad];
    }
    return self;
}

-(void)addControl{
    [self showImage];
    [self downWithContent];
}

#pragma mark 创建视图
-(void)showImage{
    CCView *bgImage=[[CCView alloc]initWithFrame:CGRectMake(10, 10, 300, 210)];
    [bgImage setBackgroundColor:RGBCommon(209, 231, 238)];
    bgImage.layer.masksToBounds=YES;
    bgImage.layer.cornerRadius=5;
    
    CCView *bgView=[[CCView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bgImage.frame), 40)];
    CCImageView *img=[CCImageView createWithImage:@"hm_photo" frame:CGRectMake(5, 5, 29, 29)];
    [bgView addSubview:img];
    CCLabel *lbTitle=[CCLabel createWithText:@"手机全部" fontSize:16 frame:CGRectMake(39, 11, 80, 18)];
    lbTitle.textColor=RGBCommon(38, 38, 38);
    [bgView addSubview:lbTitle];
    
    CCButton *moreBtn = CCButtonCreateWithValue(CGRectMake(CGRectGetWidth(bgView.frame)-50, 7, 50,30), @selector(onMoreClick:), self);
    moreBtn.tag=1;
    [moreBtn alterNormalTitle:@"更多>"];
    [moreBtn alterNormalTitleColor:RGBCommon(38, 38, 38)];
    [moreBtn alterFontSize:14];
    [bgView addSubview:moreBtn];
    
    CCView *line=[CCView createWithFrame:CGRectMake(0, CGRectGetHeight(bgView.frame), CGRectGetWidth(bgView.frame), 0.5) backgroundColor:RGBCommon(172, 211, 224)];
    
    [bgImage addSubview:bgView];
    [bgImage addSubview:line];
    
//    UICollectionViewLayout *layout=[[UICollectionViewLayout alloc]init];
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *collectionPhoto=[[UICollectionView alloc]initWithFrame:CGRectMake(10, 50, 280, 105) collectionViewLayout:layout];
    collectionPhoto.backgroundColor=[UIColor clearColor];
    collectionPhoto.showsHorizontalScrollIndicator=NO;
    collectionPhoto.tag=1;
    collectionPhoto.dataSource=self;
    collectionPhoto.delegate=self;
//    [collectionPhoto setContentOffset:CGPointMake(280, 0.0F)];
    self.collectionPhoto=collectionPhoto;
    [bgImage addSubview:collectionPhoto];
    [collectionPhoto registerClass:[MediaViewCell class] forCellWithReuseIdentifier:KCellIdentifier];
    
    CCView *line1=[CCView createWithFrame:CGRectMake(0, CGRectGetHeight(bgImage.frame)-42, CGRectGetWidth(bgView.frame), 0.5) backgroundColor:RGBCommon(172, 211, 224)];
    [bgImage addSubview:line1];
    
    CCButton *mediaBtn = CCButtonCreateWithValue(CGRectMake(50, CGRectGetHeight(bgImage.frame)-41,CGRectGetWidth(bgImage.frame)-100,41), @selector(onMoreClick:), self);
    mediaBtn.tag=2;
    [mediaBtn alterNormalTitle:@"备份至媒体中心"];
    [mediaBtn alterNormalTitleColor:RGBCommon(31, 102, 124)];
    [mediaBtn alterFontSize:18];
    self.btnMessage=mediaBtn;
    [bgImage addSubview:mediaBtn];
    
    [self addSubview:bgImage];
}


-(void)downWithContent{
    CCView *bgDown=[[CCView alloc]initWithFrame:CGRectMake(10, 230, 300, 217)];
    [bgDown setBackgroundColor:RGBCommon(209, 231, 238)];
    bgDown.layer.masksToBounds=YES;
    bgDown.layer.cornerRadius=5;
    
    CCView *bgView=[[CCView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(bgDown.frame), 40)];
    CCImageView *img=[CCImageView createWithImage:@"hm_shipin" frame:CGRectMake(5, 5, 29, 29)];
    [bgView addSubview:img];
    CCLabel *lbTitle=[CCLabel createWithText:@"云下载" fontSize:16 frame:CGRectMake(39, 11, 50, 18)];
    lbTitle.textColor=RGBCommon(38, 38, 38);
    [bgView addSubview:lbTitle];
    CCLabel *lbContent=[CCLabel createWithText:@"大片、韩剧、美剧、综艺..." fontSize:13 frame:CGRectMake(90, 13, 155, 16)];
    lbContent.textColor=RGBCommon(119, 180, 199);
    [bgView addSubview:lbContent];
    
    
    CCButton *moreBtn = CCButtonCreateWithValue(CGRectMake(CGRectGetWidth(bgView.frame)-50, 7, 50,30), @selector(onMoreClick:), self);
    moreBtn.tag=3;
    [moreBtn alterNormalTitle:@"更多>"];
    [moreBtn alterNormalTitleColor:RGBCommon(38, 38, 38)];
    [moreBtn alterFontSize:14];
    [bgView addSubview:moreBtn];
    
    CCView *line=[CCView createWithFrame:CGRectMake(0, CGRectGetHeight(bgView.frame), CGRectGetWidth(bgView.frame), 0.5) backgroundColor:RGBCommon(172, 211, 224)];
    
    [bgDown addSubview:bgView];
    [bgDown addSubview:line];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
    UICollectionView *collectionVedio=[[UICollectionView alloc]initWithFrame:CGRectMake(10, 50, 280, 125) collectionViewLayout:layout];
    collectionVedio.showsHorizontalScrollIndicator=NO;
    collectionVedio.backgroundColor=[UIColor clearColor];
    collectionVedio.dataSource=self;
    collectionVedio.delegate=self;
    collectionVedio.tag=2;
    //    [collectionPhoto setContentOffset:CGPointMake(280, 0.0F)];
    self.collectionVedio=collectionVedio;
    [bgDown addSubview:collectionVedio];
    [collectionVedio registerClass:[MediaViewCell class] forCellWithReuseIdentifier:KCellIdentifier];
    CGRect barRect=CGRectMake(30, CGRectGetHeight(bgDown.frame)-38, 240, 28);
    UISearchBar *searchBar=[[UISearchBar alloc]initWithFrame:barRect];
    searchBar.placeholder=@"找大片 追韩剧";
    searchBar.barStyle=UIBarStyleDefault;
    if(is_iOS7()){
       [searchBar setBackgroundColor:[UIColor whiteColor]];
       searchBar.barTintColor=[UIColor whiteColor];
       searchBar.layer.masksToBounds=YES;
       searchBar.layer.cornerRadius=14;
       searchBar.layer.borderWidth=0.5;
       searchBar.layer.borderColor=[RGBAlpha(186, 186, 186, 0.8) CGColor];
    }else{
        [[searchBar.subviews objectAtIndex:0]removeFromSuperview];
        [searchBar setBackgroundColor:[UIColor clearColor]];
    }
//    searchBar.delegate=self;
    CCButton *btnSearch=CCButtonCreateWithValue(barRect, @selector(onMoreClick:), self);
    btnSearch.tag=4;
    [btnSearch setBackgroundColor:[UIColor clearColor]];
    [bgDown addSubview:searchBar];
    [bgDown addSubview:btnSearch];
    [self addSubview:bgDown];
    
}


-(void)onMoreClick:(CCButton *)sendar{
    PSLog(@"---%d---",sendar.tag);
    MoPiiViewController *controller=(MoPiiViewController *)self.superController;
    switch (sendar.tag) {
        case 1:{
            if (self.isError) {
                PermissionSetController *setController=[[PermissionSetController alloc]init];
                [controller.navigationController pushViewController:setController animated:YES];
            }else{
                REPhotoController *photoController = [[REPhotoController alloc] init];
                [photoController setDatasource:_imageArr];
                [controller.navigationController pushViewController:photoController animated:YES];
            }
        }
            break;
        case 2:
            if (self.isError) {
                PermissionSetController *setController=[[PermissionSetController alloc]init];
                [controller.navigationController pushViewController:setController animated:YES];
            }else{
                self.backup(-1);
            }
            break;
        case 3:{
            CloudHomeViewController * cloudController=[[CloudHomeViewController alloc]init];
//            cloudController.arrCount=_vedioArr;
            cloudController.title=@"云下载";
            [controller.navigationController pushViewController:cloudController animated:YES];
        }
            break;
        case 4:{
            SearchViewController *searchController=[[SearchViewController alloc]init];
            [controller.navigationController.view.layer addAnimation:[self customAnimationType:kCATransitionPush upDown:YES] forKey:@"animation"];
            [controller.navigationController pushViewController:searchController animated:NO];
        }
            break;
        default:
            break;
    }

}

#pragma mark -创建数据
-(void)setImagePhoto:(NSMutableArray *)imageArr{
    _imageArr=imageArr;
    [self updateImage];
}

-(void)setCloudVedio:(NSMutableArray *)vedioArr{
    _vedioArr=vedioArr;
    [_collectionVedio reloadData];
}

-(void)updateImage{
    if(_imageArr.count==0){
        REPhoto *detail=[[REPhoto alloc]init];
        detail.image=[UIImage imageNamed:@"hm_tupian"];
        detail.imageName=@"shezhi";
        detail.isBackup=YES;
        detail.imageUrl=@"hm_tupian";
        detail.photoDate = [NSDate date];
        [_imageArr addObject:detail];
    }else{
        NSInteger count=0;
        for (REPhoto *photo in _imageArr) {
            if (!photo.isBackup) {
                count+=1;
            }
        }
        if (count==0) {
            [_btnMessage alterNormalTitle:@"备份完成"];
        }else{
            [_btnMessage alterNormalTitle:[NSString stringWithFormat:@"备份至媒体中心(%d张)",count]];
        }
        
    }
    [_collectionPhoto reloadData];
}


#pragma mark - UICollectionViewDataSource
//- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
//{
//    return 1;
//}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    PSLog(@"---collection---");
    if (collectionView.tag==1) {
        return _imageArr.count;
    }else{
        return _vedioArr.count;
    }
 
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MediaViewCell *cell = (MediaViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:KCellIdentifier
                                                                        forIndexPath:indexPath];
    cell.btn.tag=indexPath.row;
    if (collectionView.tag==1) {
        REPhoto *photo=_imageArr[indexPath.row];
        [cell.btn setTitle:@"备份" forState:UIControlStateNormal];
        if(photo.isVedio){
            cell.bgVedio.hidden=NO;
            cell.txtDuration.text=photo.duration;
        }else{
            cell.bgVedio.hidden=YES;
        }
        cell.imgView.image=photo.image;
        [cell.btn addTarget:self action:@selector(onImageClick:) forControlEvents:UIControlEventTouchUpInside];
        if (photo.isBackup) {
            [cell.btn setBackgroundImage:[UIImage imageNamed:@"hm_dizi03"] forState:UIControlStateNormal];
        }else{
            [cell.btn setBackgroundImage:[UIImage imageNamed:@"hm_dizi"] forState:UIControlStateNormal];
        }
        cell.btn.enabled=!photo.isBackup;
    }else{
        CloudMessage *msg=_vedioArr[indexPath.row];
        cell.text.hidden=NO;
//        cell.imgView.image = [UIImage imageNamed:@"hm_tupian"];
        cell.text.text = msg.name;
        [cell.btn setTitle:@"下载" forState:UIControlStateNormal];
        [cell.btn addTarget:self action:@selector(onVedioClick:) forControlEvents:UIControlEventTouchUpInside];
        NSString *path=msg.smallPicPath;
        if (msg.cloundImage) {
            cell.imgView.image=msg.cloundImage;
        }else{
            if (hasCachedImageWithString(path)) {
                msg.cloundImage=[UIImage imageWithContentsOfFile:pathForString(path)];
                [cell.imgView setImage:msg.cloundImage];
            }else{
                NSValue *size=[NSValue valueWithCGSize:CGSizeMake(70, 96)];
                NSDictionary *dict=@{@"url":path,@"imageView":cell.imgView,@"size":size};
                [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
            }
        }
    }
    return cell;
}

-(void)onImageClick:(UIButton *)sendar{
    PSLog(@"image:%d",sendar.tag);
//    REPhoto *photo=_imageArr[sendar.tag];
//    photo.isBackup=YES;
    self.backup(sendar.tag);
}

-(void)onVedioClick:(UIButton *)sendar{
    PSLog(@"vedio:%d",sendar.tag);
    
}
#pragma mark --UICollectionViewDelegate
//UICollectionView被选中时调用的方法
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
     PSLog(@"选择%d",indexPath.row);
    MoPiiViewController *controller=(MoPiiViewController*)self.superController;
    if(collectionView.tag==1){
        if (self.isError) {
            PermissionSetController *setController=[[PermissionSetController alloc]init];
            [controller.navigationController pushViewController:setController animated:YES];
        }else{
            MJPhotoBrowser *photo=[[MJPhotoBrowser alloc]init];
//            photo.isPhoto=YES;
            photo.currentPhotoIndex=indexPath.row;
            photo.photos=_imageArr;
            photo.navigationItem.title=@"图片预览";
            [controller.navigationController.view.layer addAnimation:[self customAnimationType:kCATransitionFade upDown:NO] forKey:@"animation"];
            [controller.navigationController pushViewController:photo animated:NO];
        }
    }else{
        CloudMessage *msg=_vedioArr[indexPath.row];
        if ([msg.type isEqualToString:@"tv"]) {
            CloudTvPlayViewController *tvPlayController=[[CloudTvPlayViewController alloc]init];
            tvPlayController.title=msg.name;
            tvPlayController.msg=msg;
            [controller.navigationController pushViewController:tvPlayController animated:YES];
        }else{
            CloudFilmViewController *filmController=[[CloudFilmViewController alloc]init];
            filmController.title=msg.name;
            filmController.msg=msg;
            [controller.navigationController pushViewController:filmController animated:YES];
        }
    }
   
}

#pragma mark - UIScrollViewDelegate
//- (void)scrollViewDidScroll:(UIScrollView *)_scrollView
//{
//    //无限循环....
//    float targetX = _scrollView.contentOffset.x;
//    int numCount = [self.collectionPhoto numberOfItemsInSection:0];
//    float ITEM_WIDTH = _scrollView.frame.size.width;
//    
//    if (numCount>=3)
//    {
//        if (targetX < ITEM_WIDTH/2) {
//            [_scrollView setContentOffset:CGPointMake(targetX+ITEM_WIDTH *numCount, 0)];
//        }
//        else if (targetX >ITEM_WIDTH/2+ITEM_WIDTH *numCount)
//        {
//            [_scrollView setContentOffset:CGPointMake(targetX-ITEM_WIDTH *numCount, 0)];
//        }
//    }
//    
//}

#pragma mark --UICollectionViewDelegateFlowLayout
//定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    //边距占5*4=20 ，2个
    //图片为正方形，边长：(fDeviceWidth-20)/2-5-5 所以总高(fDeviceWidth-20)/2-5-5 +20+30+5+5 label高20 btn高30 边
    if(collectionView.tag==1){
       return CGSizeMake(92,105);
    }else{
       return CGSizeMake(70, 125);
    }
    
}
//定义每个UICollectionView 的间距
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 0, 0, 0);
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

- (CGFloat)collePSLogctionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.0f;
}

-(void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
    [self endEditing:YES];
}

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)searchBar{
    [[NSNotificationCenter defaultCenter]removeObserver:self name:UIKeyboardWillChangeFrameNotification object:nil];
}

-(void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    PSLog(@"开始找片...");
    [self endEditing:YES];

}

-(void)keyboardWillChangeFrame:(NSNotification *)notification{
    CGFloat duration=[notification.userInfo[UIKeyboardAnimationDurationUserInfoKey]doubleValue];
    CGRect keyboardFrame=[notification.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat transfromY;
    if (keyboardFrame.origin.y-ScreenHeight()>=0) {
        transfromY=0;
    }else{
        transfromY=-184;
    }
    [UIView animateWithDuration:duration animations:^{
        self.transform=CGAffineTransformMakeTranslation(0, transfromY);
    }];
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
