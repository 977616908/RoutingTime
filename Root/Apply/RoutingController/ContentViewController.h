//
//  ContentViewController.h
//  RoutingTime
//
//  Created by HXL on 15/6/23.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ContentDataSource <NSObject>

@optional

-(void)pushDataSource:(id)dataSource;

@end

@interface ContentViewController : UIViewController
@property(nonatomic,weak)id<ContentDataSource> dataSource;
@property (retain,nonatomic)id dataObject;
@end
