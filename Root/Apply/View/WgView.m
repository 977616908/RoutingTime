//
//  WgView.m
//  RoutingTime
//
//  Created by HXL on 15/6/24.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "WgView.h"

@implementation WgView

-(instancetype)initWithFrame:(CGRect)frame{
    if (self=[super initWithFrame:frame]) {
        NSArray *array=[[NSBundle mainBundle]loadNibNamed:@"RoutingView" owner:nil options:nil];
        self=array[0];
    }
    return self;
}
@end
