//
//  SearchViewCell.m
//  RoutingTime
//
//  Created by apple on 15/3/23.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "SearchViewCell.h"

@implementation SearchViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self=[super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self=[[NSBundle mainBundle]loadNibNamed:@"SearchViewCell" owner:nil options:nil][0];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end


