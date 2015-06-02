//
//  CloudDownCell.m
//  RoutingTime
//
//  Created by HXL on 15/3/23.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CloudDownCell.h"
@interface CloudDownCell()


@end
@implementation CloudDownCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self=[[NSBundle mainBundle]loadNibNamed:@"CloudDownCell" owner:nil options:nil][0];
        self.backgroundColor=RGBCommon(234, 234, 234);
        self.selectionStyle=UITableViewCellSelectionStyleNone;
   
    }
    return self;
}

- (void)awakeFromNib {
    
}

-(void)layoutSubviews{
    [super layoutSubviews];
    dispatch_async(dispatch_get_main_queue(), ^{
//        [UIView animateWithDuration:0.3 animations:^{
            CGRect bgRect=_bgView.frame;
            CGRect proRect=_titleProgress.frame;
            if(_selectImg.hidden){
                bgRect.origin.x=0;
                proRect.size.width=215;
                _bgView.frame=bgRect;
                _titleProgress.frame=proRect;
            }else{
                bgRect.origin.x=22;
                proRect.size.width=193;
                _bgView.frame=bgRect;
                _titleProgress.frame=proRect;
            }
//        }];
    });

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

@end

@implementation CloudDownMessage


@end


