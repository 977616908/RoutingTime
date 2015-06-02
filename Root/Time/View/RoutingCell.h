//
//  RoutingCell.h
//  RoutingTest
//
//  Created by HXL on 15/5/18.
//  Copyright (c) 2015年 ifidc. All rights reserved.
//

#import <UIKit/UIKit.h>
@class RoutingTime;
@interface RoutingCell : UITableViewCell

+(instancetype)cellWithTableView:(UITableView *)tableView;

@property(nonatomic,strong)RoutingTime *routingTime;
@property(nonatomic,copy)NSString *imgName;
@end
