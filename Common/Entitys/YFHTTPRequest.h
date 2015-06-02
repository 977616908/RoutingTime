//
//  YFHTTPRequest.h
//  PiFiiHome
//
//  Created by Robert Lo on 14-5-8.
//  Copyright (c) 2014年 因孚网络科技. All rights reserved.
//

//登录类,以 /account/ 为前缀,登入登出功能;
//通用类,以 /common/ 为前缀,多个功能模块均可能用到,多为查询;
//模块类,以  /module/ 为前缀,每个功能模块有自己专属的操作,系统自带;
//扩展类,以 /extension/ 为前缀,可装卸的高级功能,可用于第三方扩展。

#define ACCOUNT     @"account"
#define COMMON      @"common"
#define MODULE      @"module"
#define EXTENSION   @"extension"


#import "ASIFormDataRequest.h"
#import "Response.h"
#import "RouterApp.h"
#import "WSError.h"

@protocol YFHTTPRequestDelegate;

@interface YFHTTPRequest : ASIFormDataRequest

@property (assign)id<YFHTTPRequestDelegate> responseDelegate;
@property (nonatomic, copy) NSString *function;

- (id)initWithURL:(NSString *)urlString;
- (id)initWithFuncation:(NSString *)funcation;
- (void)addPostValue:(id <NSObject>)value forKey:(NSString *)key;

@end

@protocol YFHTTPRequestDelegate <NSObject>
@optional

- (void)executeDidFailed:(YFHTTPRequest *) httpRequest errorInfo:(WSError *)error;
- (void)requestDidSuccess:(YFHTTPRequest *) httpRequest responseObject:(NSDictionary *) response;
- (void)requestDidFailed:(YFHTTPRequest *) httpRequest;
- (void)requestDidStarted:(YFHTTPRequest *) httpRequest;

@end
