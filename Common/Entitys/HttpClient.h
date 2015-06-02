//
//  HttpClient.h
//  PiFiiHome
//
//  Created by Robert Lo on 14-6-12.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#define ROUTER_TRANSIT_URL      @"https://witfii.com"
#define ROUTER_LOCAL            @"http://192.168.10.1"
#define ROUTER_SUFFIX           @"/cgi-bin/luci/api/0"

#import <Foundation/Foundation.h>

@interface HttpClient : NSObject

@property(nonatomic,copy)NSString *apiRemoteHost;
@property(nonatomic,copy)NSString *apiLocalHost;
@property(nonatomic,copy)NSString *apiHost;
@property(nonatomic,copy)NSString *function;

@property(nonatomic,assign)BOOL isLocal;
@property(nonatomic,assign)BOOL isRouterAPI;

-(id)initWithFunction:(NSString *)function;

-(YFHTTPRequest *)requestWithRespDelegate:(id<YFHTTPRequestDelegate>) delegate;

@end
