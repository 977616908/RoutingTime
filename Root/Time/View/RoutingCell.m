//
//  RoutingCell.m
//  RoutingTest
//
//  Created by HXL on 15/5/18.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "RoutingCell.h"
#import "RoutingMsg.h"
#import "REPhoto.h"
#import "RoutingDetailController.h"
#import "RoutingTimeController.h"
@interface RoutingCell (){
    NSArray *arrImgs;
}
#define HEIGHT 150
#define WEITH 268
#define DOWNPROGRESS @"DOWNPROGRESS"

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbCount;
@property (weak, nonatomic) IBOutlet UIImageView *imgTag;
@property (weak, nonatomic) IBOutlet UILabel *lbDay;
@property (weak, nonatomic) IBOutlet UILabel *lbMM;
@property (weak, nonatomic) UILabel *lbProgress;
@property (weak, nonatomic) UIView *lbView;
@property(nonatomic,strong)id superController;

@end

@implementation RoutingCell

- (void)awakeFromNib {
    // Initialization code
}

+(instancetype)cellWithTarget:(id)target tableView:(UITableView *)tableView {
   static NSString *ID=@"RoutingTime";
    RoutingCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[RoutingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.superController=target;
    }
    cell.bgView.layer.masksToBounds=YES;
    cell.bgView.layer.cornerRadius=2.5;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self=[[NSBundle mainBundle]loadNibNamed:@"RoutingCell" owner:nil options:nil][0];
        self.bgView.userInteractionEnabled=YES;
        [self.bgView addGestureRecognizer:[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(onTapClick)]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRoutingTime:(RoutingTime *)routingTime{
    _routingTime=routingTime;
    self.lbTitle.text=routingTime.rtTitle;
    self.lbCount.text=routingTime.rtNums;
    self.lbMM.text=[self getDate:routingTime.rtDate type:@"MM月"];
    self.lbDay.text=[self getDate:routingTime.rtDate type:@"dd"];
    NSArray *arr=routingTime.rtSmallPaths;
    if (arr) {
        [self addImageCount:arr.count];
        for (int i=0; i<arrImgs.count; i++) {
            UIImageView *image=arrImgs[i];
            RoutingMsg *msg=routingTime.rtSmallPaths[i];
            NSString *path=msg.msgPath;
            //        [cell.imgView setImageWithURL:[path urlInstance]];
            if (hasCachedImageWithString(path)) {
                image.image=[UIImage imageWithContentsOfFile:pathForString(path)];
            }else{
                NSValue *size=[NSValue valueWithCGSize:CGSizeMake(WEITH, HEIGHT)];
                if(i==1){
                    size=[NSValue valueWithCGSize:CGSizeMake(WEITH/2, HEIGHT)];
                }else if(i==2){
                    size=[NSValue valueWithCGSize:CGSizeMake(WEITH/2, HEIGHT/2)];
                }
                NSDictionary *dict=@{@"url":path,@"imageView":image,@"size":size};
                [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
            }
        }
    }
}

-(void)setRoutingDown:(RoutingDown *)routingDown{
    _routingDown=routingDown;
    NSDictionary *param=routingDown.params;
    self.lbTitle.text=param[@"title"];
    self.lbCount.text=[NSString stringWithFormat:@"%d",routingDown.downList.count];
    self.lbMM.text=[self getDate:nil type:@"MM月"];
    self.lbDay.text=[self getDate:nil type:@"dd"];
    NSArray *arr=_routingDown.downList;
    if (arr) {
        [self addImageCount:arr.count];
        for (int i=0; i<arrImgs.count; i++) {
            UIImageView *image=arrImgs[i];
            REPhoto *photo=arr[i];
            image.image=photo.image;
        }
    }
    UIView *lbView=[[UIView alloc]initWithFrame:CGRectMake(2, 2, CGRectGetWidth(self.bgView.frame)-5, 15)];
    lbView.backgroundColor=RGBAlpha(0, 0, 0, 0.7);
    UIActivityIndicatorView *start=[[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
    start.frame=CGRectMake(5, 2, 10, 10);
    start.transform=CGAffineTransformMakeScale(0.5, 0.5);
    [start startAnimating];
    [lbView addSubview:start];
    UILabel *lbDown=[[UILabel alloc]initWithFrame:CGRectMake(20, 0,CGRectGetWidth(self.bgView.frame), CGRectGetHeight(lbView.frame))];
    [lbDown setFont:[UIFont systemFontOfSize:10.0]];
    lbDown.textColor=[UIColor whiteColor];
//    lbDown.text=@"上传中...(2/1)37.0%";
    self.lbProgress=lbDown;
    [lbView addSubview:lbDown];
    self.lbView=lbView;
    [self.bgView addSubview:lbView];
    [PSNotificationCenter addObserver:self selector:@selector(onProgressChange:) name:DOWNPROGRESS object:nil];
}

-(void)addImageCount:(NSInteger)count{
    NSMutableArray *imags=[NSMutableArray array];
    if (count==1) {
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, WEITH, HEIGHT)];
        image.image=[UIImage imageNamed:@"hm_tupian_da"];
        [self.bgView addSubview:image];
        [imags addObject:image];
    }else if(count==2){
        for (int i=0; i<2; i++) {
            UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(2+(WEITH/2)*i,2 ,WEITH/2-1, HEIGHT)];
            image.image=[UIImage imageNamed:@"hm_tupian_center"];
            [self.bgView addSubview:image];
            [imags addObject:image];
        }
    }else{
        for (int i=0; i<3; i++) {
            if (i==0) {
                UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, WEITH/2-1, HEIGHT-1)];
                image.image=[UIImage imageNamed:@"hm_tupian_center"];
                [self.bgView addSubview:image];
                [imags addObject:image];
            }else{
                UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(WEITH/2+2,2+(HEIGHT/2)*(i-1), WEITH/2, HEIGHT/2-1)];
                image.image=[UIImage imageNamed:@"hm_tupian_small"];
                [self.bgView addSubview:image];
                [imags addObject:image];
            }
        }
    }
    arrImgs=imags;
}


-(void)setImgName:(NSString *)imgName{
    _imgName=imgName;
    self.imgTag.image=[UIImage imageNamed:imgName];
}

-(NSString *)getDate:(NSString *)date type:type{
    NSDateFormatter *sdf=[[NSDateFormatter alloc]init];
    NSDate *dt=[NSDate date];
    if (date) {
        [sdf setDateFormat:@"yyyy-MM-dd"];
        dt=[sdf dateFromString:date];
    }
    [sdf setDateFormat:type];
    return [sdf stringFromDate:dt];
}

-(void)onProgressChange:(NSNotification *)not{
//    @"count":@(_photoArr.count),
//    @"totalCount":@(10),
//    @"progress":@(fraction*100)
    NSDictionary *param=not.userInfo;
    NSInteger totalCount=[param[@"totalCount"] integerValue];
    NSInteger count=totalCount-[param[@"count"] integerValue]+1;
    CGFloat progress=[param[@"progress"] floatValue];
    //    lbDown.text=@"上传中...(2/1)37.0%";
    self.lbProgress.text=[NSString stringWithFormat:@"上传中...(%d/%d)%.2f%%",totalCount,count,progress];
    if (progress>=100&&totalCount==count) {
        [PSNotificationCenter removeObserver:self name:DOWNPROGRESS object:nil];
        [self.lbView removeFromSuperview];
    }
    PSLog(@"--[%d]--[%f]-[%d]",totalCount,progress,count);
}

-(void)onTapClick{
    NSLog(@"tap--[%d]",_routingTime.rtSmallPaths.count);
    RoutingTimeController *controller=self.superController;
    if (_routingDown) {
        [controller showToast:@"时光片段正在分享..." Long:1.5];
        return;
    }
    RoutingDetailController *detailController=[[RoutingDetailController alloc]init];
    detailController.routingTime=_routingTime;
    [controller.navigationController pushViewController:detailController animated:YES];
}

@end
