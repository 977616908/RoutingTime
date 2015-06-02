//
//  CollectionViewCell.m
//  collectionView
//
//  Created by shikee_app05 on 14-12-10.
//  Copyright (c) 2014年 shikee_app05. All rights reserved.
//

#import "SeveralViewCell.h"

@implementation SeveralViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.frame), CGRectGetWidth(self.frame))];
        self.imgView.image=[UIImage imageNamed:@"hm_spxz001"];
        [self addSubview:self.imgView];
        
        self.textCount = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMidY(self.imgView.frame)-10, CGRectGetWidth(self.frame), 20)];
        self.textCount.backgroundColor = [UIColor clearColor];
        self.textCount.font=[UIFont systemFontOfSize:16.0f];
        self.textCount.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.textCount];
        
        self.btnDown = [UIButton buttonWithType:UIButtonTypeCustom];
        self.btnDown.frame = CGRectMake(CGRectGetMaxX(self.textCount.frame)-32, CGRectGetMaxY(self.textCount.frame), 32,14);
        self.btnDown.contentVerticalAlignment=UIControlContentVerticalAlignmentBottom;
        self.btnDown.contentHorizontalAlignment=UIControlContentHorizontalAlignmentRight;
        [self addSubview:self.btnDown];
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
