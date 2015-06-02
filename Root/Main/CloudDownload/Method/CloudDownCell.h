//
//  CloudDownCell.h
//  RoutingTime
//
//  Created by HXL on 15/3/23.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CloudDownCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *selectImg;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIImageView *titleImg;
@property (weak, nonatomic) IBOutlet UILabel *titleName;
@property (weak, nonatomic) IBOutlet UIProgressView *titleProgress;
@property (weak, nonatomic) IBOutlet UILabel *titleCount;

@property (weak, nonatomic) IBOutlet UILabel *titleLength;
@property (weak, nonatomic) IBOutlet UILabel *lbCome;

@end

@interface CloudDownMessage : NSObject
@property(nonatomic,copy)NSString *titleImg;
@property(nonatomic,copy)NSString *titleName;
@property(nonatomic,assign)CGFloat titleProgress;
@property(nonatomic,copy)NSString *titleLength;
@property(nonatomic,copy)NSString *titleCome;

@end
