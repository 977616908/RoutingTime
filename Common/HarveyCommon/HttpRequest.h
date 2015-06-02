//
//  HttpRequest.h
//  Own
//
//  Created by Harvey on 13-8-31.
//  Copyright (c) 2013年 nso. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AFNetworking.h"

@interface HttpRequest : NSObject

/// get请求
+ (void)getWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras requestOK:(SEL)sAction requestFail:(SEL)fAction runTarget:(id)target;

/// post请求
+ (void)postWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras requestOK:(SEL)sAction requestFail:(SEL)fAction runTarget:(id)target;

/// get请求, 使用block
+ (void)getWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras OKBlock:(void (^)(NSDictionary *dict))sAction failBlock:(void (^)(NSError *error))fAction;

/// post请求 , 使用block
+ (void)postWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras OKBlock:(void (^)(NSDictionary *dict))sAction failBlock:(void (^)(NSError *error))fAction;

/// get请求, 带cookie
+ (void)getWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras cookie:(NSDictionary *)cookie requestOK:(SEL)sAction requestFail:(SEL)fAction runTarget:(id)target;

/// post请求, 带cookie
+ (void)postWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras cookie:(NSDictionary *)cookie requestOK:(SEL)sAction requestFail:(SEL)fAction runTarget:(id)target;

/// get请求, 带cookie, 使用block
+ (void)getWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras cookie:(NSDictionary *)cookie OKBlock:(void (^)(NSDictionary *dict))sAction failBlock:(void (^)(NSError *error))fAction;

/// post请求, 带cookie, 使用block
+ (void)postWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras cookie:(NSDictionary *)cookie OKBlock:(void (^)(NSDictionary *dict))sAction failBlock:(void(^)(NSError *error))fAction;

/// post请求, paraString
+ (void)postWithBaseURL:(NSString *)url path:(NSString *)path paraJSONString:(NSString *)paraString requestOK:(SEL)sAction requestFail:(SEL)fAction runTarget:(id)target;

/// post请求,and optional set ContentTypes
+ (void)postWithBaseURL:(NSString *)url path:(NSString *)path  ContentType:(NSString *)cType paras:(NSDictionary *)paras OKBlock:(void (^)(NSDictionary *dict))sAction failBlock:(void (^)(NSError *error))fAction;

+ (void)POSTHTTPS;
@end
