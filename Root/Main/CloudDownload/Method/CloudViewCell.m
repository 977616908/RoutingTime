//
//  CollectionViewCell.m
//  collectionView
//
//  Created by shikee_app05 on 14-12-10.
//  Copyright (c) 2014年 shikee_app05. All rights reserved.
//

#import "CloudViewCell.h"

@implementation CloudViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 0, 142, 85)];
        self.imgView.image = [UIImage imageNamed:@"hm_tupian"];
        [self addSubview:self.imgView];
        
        self.lbTitle = [[UILabel alloc]initWithFrame:CGRectMake(4, CGRectGetMaxY(self.imgView.frame)+2, CGRectGetWidth(self.imgView.frame), 20)];
        self.lbTitle.textColor = RGBCommon(38, 38, 38);
        self.lbTitle.font=[UIFont systemFontOfSize:16.0f];
        self.lbTitle.backgroundColor=[UIColor clearColor];
        [self addSubview:self.lbTitle];
        
        self.lbContent = [[UILabel alloc]initWithFrame:CGRectMake(4, CGRectGetMaxY(self.lbTitle.frame), CGRectGetWidth(self.imgView.frame), 16)];
        self.lbContent.textColor = RGBCommon(137, 137, 137);
        self.lbContent.font=[UIFont systemFontOfSize:12.0f];
        self.lbContent.backgroundColor=[UIColor clearColor];
        [self addSubview:self.lbContent];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
