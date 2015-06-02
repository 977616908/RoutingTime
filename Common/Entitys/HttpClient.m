//
//  HttpClient.m
//  PiFiiHome
//
//  Created by Robert Lo on 14-6-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import "HttpClient.h"
#import "RouterApp.h"

@implementation HttpClient

- (id)initWithFunction:(NSString *)function
{
    self=[super init];
    
    if (self)
    {
        _apiRemoteHost=ROUTER_TRANSIT_URL;
        _apiLocalHost=ROUTER_LOCAL;
        _apiHost=_apiRemoteHost;
        [self setFunction:function];
    }
    
    return self;
}

-(YFHTTPRequest *)requestWithRespDelegate:(id<YFHTTPRequestDelegate>) delegate
{
    if (_isLocal) {
        _apiHost=_apiLocalHost;
    }
    
    NSString * url=[NSString stringWithFormat:@"%@%@",_apiHost,_function];
    
    if (_isRouterAPI){
        url=[NSString stringWithFormat:@"%@%@%@",_apiHost,ROUTER_SUFFIX,_function];
    }
    
    NSLog(@"REQUEST %@",url);
    
    YFHTTPRequest *request=[[YFHTTPRequest alloc] initWithURL:url];
    [request setResponseDelegate:delegate];
    
    return request;
}



@end
