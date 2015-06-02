//
//  SearchViewCell.h
//  RoutingTime
//
//  Created by apple on 15/3/23.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *searchImage;
@property (weak, nonatomic) IBOutlet UILabel *searchTitle;

@property (weak, nonatomic) IBOutlet UILabel *searchName;
@property (weak, nonatomic) IBOutlet UILabel *searchType;
@property (weak, nonatomic) IBOutlet UILabel *searchCome;
@property (weak, nonatomic) IBOutlet UIButton *searchBtn;

@end




