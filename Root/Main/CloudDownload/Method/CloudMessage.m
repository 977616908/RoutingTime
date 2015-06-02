//
//  CloudMessage.m
//  RoutingTime
//
//  Created by HXL on 15/3/18.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "CloudMessage.h"

@implementation CloudMessage

-(id)initWithData:(NSDictionary *)data{
    if (self=[super init]) {
        _type=data[@"type"];
        _name=data[@"name"];
        _downloadUrl=data[@"download_url"];
        _smallPicPath=data[@"small_pic_path"];
        _middlePicPath=data[@"middle_pic_path"];
        _middleSearchPicPath=data[@"middle_search_pic_path"];
        _bigPicPath=data[@"big_pic_path"];
        _netFrom=data[@"net_from"];
        _protagonist=data[@"protagonist"];
        _plot=data[@"plot"];
        _director=data[@"director"];
        _region=data[@"region"];
        _year=data[@"year"];
        _introduction=data[@"introduction"];
        _updateAmountAll=data[@"update_amount_all"];
        _updateAmountNew=data[@"update_amount_new"];
    }
    return self;
}

@end
