//
//  RoutingMsg.m
//  RoutingTime
//
//  Created by HXL on 15/5/27.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import "RoutingMsg.h"

@implementation RoutingMsg

-(id)initWithData:(NSDictionary *)data{
    if (self=[super init]) {
        _msgNum=data.allKeys[0];
        _msgPath=data.allValues[0];
    }
    return self;
}
-(id)initWithSmallData:(NSDictionary *)data{
    if (self=[super init]) {
        _msgNum=isNIL(data[@"id"])?@"":[data[@"id"] stringValue];
        _msgPath=isNIL(data[@"smallpath"])?@"":data[@"smallpath"];
        _msgDuration=isNIL(data[@"duration"])?@"":data[@"duration"];
        if (!isNIL(_msgDuration)){
            _isVedio=YES;
        }
    }
    return self;
}

@end
