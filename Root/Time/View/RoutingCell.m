//
//  RoutingCell.m
//  RoutingTest
//
//  Created by HXL on 15/5/18.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import "RoutingCell.h"
#import "RoutingTime.h"
#import "RoutingMsg.h"
@interface RoutingCell ()
#define HEIGHT 156
#define WEITH 268

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *lbTitle;
@property (weak, nonatomic) IBOutlet UILabel *lbCount;
@property (weak, nonatomic) IBOutlet UIImageView *imgTag;
@property (weak, nonatomic) IBOutlet UILabel *lbDay;
@property (weak, nonatomic) IBOutlet UILabel *lbMM;


@end

@implementation RoutingCell

- (void)awakeFromNib {
    // Initialization code
}

+(instancetype)cellWithTableView:(UITableView *)tableView{
   static NSString *ID=@"RoutingTime";
    RoutingCell *cell=[tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell=[[RoutingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.bgView.layer.masksToBounds=YES;
    cell.bgView.layer.cornerRadius=2.5;
    return cell;
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self=[[NSBundle mainBundle]loadNibNamed:@"RoutingCell" owner:nil options:nil][0];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)setRoutingTime:(RoutingTime *)routingTime{
    _routingTime=routingTime;
    if (routingTime) {
        self.lbTitle.text=routingTime.rtTitle;
        self.lbCount.text=routingTime.rtNums;
        self.lbMM.text=[self getDate:routingTime.rtDate type:@"MM月"];
        self.lbDay.text=[self getDate:routingTime.rtDate type:@"dd"];
        if (routingTime.rtSmallPaths.count==1) {
            UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, WEITH, HEIGHT)];
            image.image=[UIImage imageNamed:@"hm_tupian_da"];
            [self.bgView addSubview:image];
            RoutingMsg *msg=routingTime.rtSmallPaths[0];
            NSString *path=msg.msgPath;
            //        [cell.imgView setImageWithURL:[path urlInstance]];
            if (hasCachedImageWithString(path)) {
                image.image=[UIImage imageWithContentsOfFile:pathForString(path)];
            }else{
                NSValue *size=[NSValue valueWithCGSize:CGSizeMake(WEITH, HEIGHT)];
                NSDictionary *dict=@{@"url":path,@"imageView":image,@"size":size};
                [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
            }
            
        }else if(routingTime.rtSmallPaths.count==2){
            for (int i=0; i<2; i++) {
                UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(2+(WEITH/2)*i,2 ,WEITH/2-1, HEIGHT)];
                image.image=[UIImage imageNamed:@"hm_tupian_center"];
                [self.bgView addSubview:image];
                RoutingMsg *msg=routingTime.rtSmallPaths[i];
                NSString *path=msg.msgPath;
                //        [cell.imgView setImageWithURL:[path urlInstance]];
                if (hasCachedImageWithString(path)) {
                    image.image=[UIImage imageWithContentsOfFile:pathForString(path)];
                }else{
                    NSValue *size=[NSValue valueWithCGSize:CGSizeMake(WEITH/2, HEIGHT)];
                    NSDictionary *dict=@{@"url":path,@"imageView":image,@"size":size};
                    [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
                }
            }
            
            
        }else{
            for (int i=0; i<3; i++) {
                if (i==0) {
                    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(2, 2, WEITH/2-1, HEIGHT-1)];
                    image.image=[UIImage imageNamed:@"hm_tupian_center"];
                    [self.bgView addSubview:image];
                    RoutingMsg *msg=routingTime.rtSmallPaths[i];
                    NSString *path=msg.msgPath;
                    //        [cell.imgView setImageWithURL:[path urlInstance]];
                    if (hasCachedImageWithString(path)) {
                        image.image=[UIImage imageWithContentsOfFile:pathForString(path)];
                    }else{
                        NSValue *size=[NSValue valueWithCGSize:CGSizeMake(WEITH/2, HEIGHT)];
                        NSDictionary *dict=@{@"url":path,@"imageView":image,@"size":size};
                        [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
                    }
                }else{
                    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(WEITH/2+2,2+(HEIGHT/2)*(i-1), WEITH/2, HEIGHT/2-1)];
                    image.image=[UIImage imageNamed:@"hm_tupian_small"];
                    [self.bgView addSubview:image];
                    RoutingMsg *msg=routingTime.rtSmallPaths[i];
                    NSString *path=msg.msgPath;
                    //        [cell.imgView setImageWithURL:[path urlInstance]];
                    if (hasCachedImageWithString(path)) {
                        image.image=[UIImage imageWithContentsOfFile:pathForString(path)];
                    }else{
                        NSValue *size=[NSValue valueWithCGSize:CGSizeMake(WEITH/2, HEIGHT/2)];
                        NSDictionary *dict=@{@"url":path,@"imageView":image,@"size":size};
                        [NSThread detachNewThreadSelector:@selector(cacheImage:) toTarget:[ImageCacher defaultCacher] withObject:dict];
                    }
                }
            }
        }

    }
    
}

-(void)setImgName:(NSString *)imgName{
    _imgName=imgName;
    self.imgTag.image=[UIImage imageNamed:imgName];
}

-(NSString *)getDate:(NSString *)date type:type{
    NSDateFormatter *sdf=[[NSDateFormatter alloc]init];
    [sdf setDateFormat:@"yyyy-MM-dd"];
    NSDate *dt=[sdf dateFromString:date];
    [sdf setDateFormat:type];
    return [sdf stringFromDate:dt];
}

@end
