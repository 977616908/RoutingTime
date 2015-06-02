//
//  HttpRequest.m
//  Own
//
//  Created by Harvey on 13-8-31.
//  Copyright (c) 2013年 nso. All rights reserved.
//

#import "HttpRequest.h"
#import "JSONKit.h"

@implementation HttpRequest

+ (void)getWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras requestOK:(SEL)sAction requestFail:(SEL)fAction runTarget:(id)target
{
    [self requestWithBaseURL:url path:path isGETRequest:YES parameters:paras successAction:sAction failureAction:fAction runTarget:target];
}

+ (void)postWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras requestOK:(SEL)sAction requestFail:(SEL)fAction runTarget:(id)target
{
     [self requestWithBaseURL:url path:path isGETRequest:NO parameters:paras successAction:sAction failureAction:fAction runTarget:target];
}

+ (void)getWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras OKBlock:(void (^)(NSDictionary *))sAction failBlock:(void (^)(NSError *))fAction
{
    [self requestWithBaseURL:url path:path isGETRequest:YES parameters:paras successAction:^(NSDictionary *dict) {
        
        if(sAction)
            sAction(dict);
    } failureAction:^(NSError *error) {
        
        if(fAction)
            fAction(error);
    }];
}

+ (void)postWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras OKBlock:(void (^)(NSDictionary *))sAction failBlock:(void (^)(NSError *))fAction
{
    [self requestWithBaseURL:url path:path isGETRequest:NO parameters:paras successAction:^(NSDictionary *dict) {
        
        if(sAction)
            sAction(dict);
    } failureAction:^(NSError *error) {
        if(fAction)
            fAction(error);
    }];
}

+ (void)getWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras cookie:(NSDictionary *)cookie requestOK:(SEL)sAction requestFail:(SEL)fAction runTarget:(id)target
{
    [self requestWithBaseURL:url path:path method:@"GET" paras:paras cookie:cookie requestOK:sAction requestFail:fAction runTarget:target];
}

+ (void)postWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras cookie:(NSDictionary *)cookie requestOK:(SEL)sAction requestFail:(SEL)fAction runTarget:(id)target
{
     [self requestWithBaseURL:url path:path method:@"POST" paras:paras cookie:cookie requestOK:sAction requestFail:fAction runTarget:target];
}

+ (void)getWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras cookie:(NSDictionary *)cookie OKBlock:(void (^)(NSDictionary *))sAction failBlock:(void (^)(NSError *))fAction
{
    [self requestWithBaseURL:url path:path method:@"GET" paras:paras cookie:cookie OKBlock:^(NSDictionary *dict) {
        
        if(sAction)
            sAction(dict);
    } failBlock:^(NSError *error) {
        if(fAction)
            fAction(error);
    }];
}

+ (void)postWithBaseURL:(NSString *)url path:(NSString *)path paras:(NSDictionary *)paras cookie:(NSDictionary *)cookie OKBlock:(void (^)(NSDictionary *))sAction failBlock:(void (^)(NSError *))fAction
{
    [self requestWithBaseURL:url path:path method:@"POST" paras:paras cookie:cookie OKBlock:^(NSDictionary *dict) {
        
        if(sAction)
            sAction(dict);
    } failBlock:^(NSError *error) {
        if(fAction)
            fAction(error);
    }];
}

+ (void)postWithBaseURL:(NSString *)url path:(NSString *)path paraJSONString:(NSString *)paraString requestOK:(SEL)sAction requestFail:(SEL)fAction runTarget:(id)target
{
    __block SEL successAction = sAction;
    __block SEL failureAction = fAction;
    __block id runTarget = target;

    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer new];
    NSString *str = url;
    if(path.length > 0) {
        
        str = [str stringByAppendingFormat:@"/%@",path];
    }
    NSMutableURLRequest *mRequest = [requestSerializer requestWithMethod:@"POST" URLString:str parameters:nil error:nil];
    [mRequest setTimeoutInterval:REQUESTTIMEOUT];
    [mRequest setHTTPBody:[paraString stringConvertData]];
    [mRequest setValue:@"json" forHTTPHeaderField:@"content-type"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:mRequest];
    //operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(runTarget && sAction)
            [runTarget performSelector:successAction withParameter:[responseObject objectFromJSONData]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(runTarget && failureAction)
            [runTarget performSelector:failureAction withParameter:error];
    }];
    [[NSOperationQueue mainQueue] addOperation:operation];
}


/// 一般请求
+ (void)requestWithBaseURL:(NSString *)url path:(NSString *)path isGETRequest:(BOOL )isGet  parameters:(NSDictionary *)paras successAction:(SEL)sAction failureAction:(SEL)fAction runTarget:(id)target
{
    __block SEL successAction = sAction;
    __block SEL failureAction = fAction;
    __block id runTarget = target;
    
    AFHTTPRequestOperationManager *requestOM = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
    //requestOM.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    if(isGet) {
        
        [requestOM GET:path parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(runTarget && sAction)
                [runTarget performSelector:successAction withParameter:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(runTarget && failureAction)
                [runTarget performSelector:failureAction withParameter:error];
        }];
    }else {
        
        [requestOM POST:path parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(runTarget && sAction)
                [runTarget performSelector:successAction withParameter:responseObject];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(runTarget && failureAction)
                [runTarget performSelector:failureAction withParameter:error];
        }];
    }
}

/// 一般请求, 使用block
+ (void)requestWithBaseURL:(NSString *)url path:(NSString *)path isGETRequest:(BOOL )isGet  parameters:(NSDictionary *)paras successAction:(void (^)(NSDictionary *dict))sAction failureAction:(void (^)(NSError *error))fAction
{
        AFHTTPRequestOperationManager *requestOM = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:url]];
  //  requestOM.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    if(isGet) {
        
        [requestOM GET:path parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(sAction)
                sAction(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fAction)
                fAction(error);
        }];
    }else {
        
        [requestOM POST:path parameters:paras success:^(AFHTTPRequestOperation *operation, id responseObject) {
            if(sAction)
                sAction(responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(fAction)
                fAction(error);
        }];
    }
}

/// 带cookie请求
+ (void)requestWithBaseURL:(NSString *)url path:(NSString *)path method:(NSString *)method paras:(NSDictionary *)paras cookie:(NSDictionary *)cookie requestOK:(SEL)sAction requestFail:(SEL)fAction runTarget:(id)target
{
    __block SEL successAction = sAction;
    __block SEL failureAction = fAction;
    __block id runTarget = target;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer new];
    NSMutableURLRequest *mRequest = [requestSerializer requestWithMethod:method URLString:[NSString stringWithFormat:@"%@/%@",url,path] parameters:paras];
    
    if(cookie)
        [mRequest setValue:(id)cookie forHTTPHeaderField:@"Cookie"];
  
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:mRequest];
    //operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(runTarget && successAction)
           [runTarget performSelector:successAction withParameter:[responseObject objectFromJSONData]];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(runTarget && failureAction)
            [runTarget performSelector:failureAction withParameter:error];
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

/// 带cookie请求, 使用block
+ (void)requestWithBaseURL:(NSString *)url path:(NSString *)path method:(NSString *)method paras:(NSDictionary *)paras cookie:(NSDictionary *)cookie OKBlock: (void (^)(NSDictionary *dict))sAction failBlock:(void (^)(NSError *error))fAction
{
      AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer new];
    NSMutableURLRequest *mRequest = [requestSerializer requestWithMethod:method URLString:[NSString stringWithFormat:@"%@/%@",url,path] parameters:paras];
    if(cookie)
        [mRequest setValue:(id)cookie forHTTPHeaderField:@"Cookie"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:mRequest];
   // operation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];

    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        if(sAction)
            sAction([responseObject objectFromJSONData]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(fAction)
            fAction(error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:operation];
}

+ (void)postWithBaseURL:(NSString *)url path:(NSString *)path  ContentType:(NSString *)cType paras:(NSDictionary *)paras OKBlock:(void (^)(NSDictionary *dict))sAction failBlock:(void (^)(NSError *error))fAction
{
    AFHTTPRequestSerializer *requestSerializer = [[AFHTTPRequestSerializer alloc] init];
    
    if (path.length) {
        url = [url stringByAppendingPathComponent:path];
    }
    
    NSMutableURLRequest *mRequest = [requestSerializer requestWithMethod:@"GET" URLString:url parameters:paras];
    AFHTTPRequestOperation *requestOperation = [[AFHTTPRequestOperation alloc] initWithRequest:mRequest];
    if(cType.length > 0) {
        
        requestOperation.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/html"];
    }

    [requestOperation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
      
        //NSLog(@"%@",[[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        if(sAction)
            sAction([responseObject objectFromJSONData]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        if(fAction)
            fAction(error);
    }];
    
    [[NSOperationQueue mainQueue] addOperation:requestOperation];
}

+ (void)POSTHTTPS
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager]; //initialize
    //manager.securityPolicy.allowInvalidCertificates=YES;    //allow unsigned
    //manager.responseSerializer=[AFJSONResponseSerializer serializer];   //set up for JSOn
    
    AFHTTPRequestSerializer *serializer = [AFHTTPRequestSerializer serializer];
    NSMutableURLRequest *mRequest = [serializer requestWithMethod:@"GET"
                                                        URLString:@"https://witfii.com/module/wifi_client_list"
                                                       parameters:@{@"_xsrf": ReadFromLocalWithKey(@"_xsrf"),
//                                                                    @"email": @"cmcc1@pifii.com",
//                                                                    @"password": @"123456",
//                                                                    @"return_user_info": @"1",
                                                                    //@"return_router_states": @"1",
                                                                    @"token": [GlobalShare getToken]}];
    
   // [mRequest setValue:(id)[GlobalShare userCookieForRouter] forHTTPHeaderField:@"Cookie"];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:mRequest];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSLog(@"客户端列表(AFNetworking)%@",[responseObject objectFromJSONData]);
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"客户端列表ERROR: %@",error);
    }];
    
    [manager.operationQueue addOperation:operation];
}

@end
