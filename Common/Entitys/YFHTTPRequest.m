//
//  YFHTTPRequest.m
//  PiFiiHome
//
//  Created by Robert Lo on 14-5-8.
//  Copyright (c) 2014年 因孚网络科技. All rights reserved.
//

#import "YFHTTPRequest.h"

@implementation YFHTTPRequest

- (id)initWithURL:(NSString *)urlString
{
    NSURL *apiURL=[NSURL URLWithString:urlString];
    self=[super initWithURL:apiURL];
    
    if (self)
    {
        [self setDelegate:self];
        [self setDidStartSelector:@selector(requestDidStarted)];
        [self setDidFailSelector:@selector(requestDidFailed:)];
        [self setDidFinishSelector:@selector(requestDidSuccess:)];
    
        return self;
    }
    
    return NULL;
}

- (id)initWithFuncation:(NSString *)funcation
{
    [self setFunction:funcation];
    
    NSString *urlString=[[RouterApp sharedApp] apiRootURL];
    urlString=[urlString stringByAppendingString:funcation];
    NSLog(@"REQUEST %@",urlString);
    
    NSURL *apiURL=[NSURL URLWithString:urlString];
    self=[super initWithURL:apiURL];
    
    if (self)
    {
        [self setDelegate:self];
        [self setDidStartSelector:@selector(requestDidStarted)];
        [self setDidFailSelector:@selector(requestDidFailed:)];
        [self setDidFinishSelector:@selector(requestDidSuccess:)];
       
        return self;
    }
    
    return NULL;
}


- (void)requestDidStarted{
    if ([_responseDelegate conformsToProtocol:@protocol(YFHTTPRequestDelegate)]) {
        if ([_responseDelegate respondsToSelector:@selector(requestDidStarted:)]) {
            [_responseDelegate requestDidStarted:self];
        }
    }
}

- (void)addPostValue:(id <NSObject>)value forKey:(NSString *)key{
    if ([requestMethod isEqualToString:@"GET"]) {
        NSString *urlStr=[self.url absoluteString];
        NSRange range=[urlStr rangeOfString:@"?"];
        
        if (range.location==NSNotFound) {
            urlStr=[urlStr stringByAppendingString:@"?"];
        }else{
            urlStr=[urlStr stringByAppendingString:@"&"];
        }
        
        urlStr=[urlStr stringByAppendingString:key];
        urlStr=[urlStr stringByAppendingString:@"="];
        if (!isNIL(value)) {
            urlStr=[urlStr stringByAppendingString:(NSString *)value];
        }
        self.url=[NSURL URLWithString:urlStr];
    }else{
        [super addPostValue:value forKey:key];
    }
}

- (void)requestDidSuccess:(ASIFormDataRequest *)formRequest
{
   // NSLog(@"---Header:%@",[formRequest responseHeaders]);
    NSLog(@"---Status Code:%i",[formRequest responseStatusCode]);
    
    
    if ([_responseDelegate conformsToProtocol:@protocol(YFHTTPRequestDelegate)])
    {
        if ([_responseDelegate respondsToSelector:@selector(requestDidSuccess:responseObject:)])
        {
            NSLog(@"============:%@",[formRequest responseString]);
            
            id str=[NSJSONSerialization JSONObjectWithData:[formRequest responseData] options:NSJSONReadingAllowFragments error:nil];
            if ([str isKindOfClass:[NSArray class]]) {
                return;
            }
            
            if ([[str allKeys] containsObject:@"status"])
            {
                NSNumber *status=[str objectForKey:@"status"];
                
                if ([status intValue]==0)
                {
                    [_responseDelegate requestDidSuccess:self responseObject:str];
                }else{
                    WSError *err=[[WSError alloc] initWithDictionary:str];
                    if ([_responseDelegate respondsToSelector:@selector(executeDidFailed:errorInfo:)])
                    {
                         [_responseDelegate executeDidFailed:self errorInfo:err];
                    }
                }
            }else{
                [_responseDelegate requestDidSuccess:self responseObject:str];
            }
            
            
        }
    }

   // NSLog(@"URL:%@",[[[formRequest url] absoluteURL] absoluteString]);
}


- (void)requestDidFailed:(ASIFormDataRequest *)formRequest
{
    if ([_responseDelegate conformsToProtocol:@protocol(YFHTTPRequestDelegate)]) {
        if ([_responseDelegate respondsToSelector:@selector(requestDidFailed:)]) {
            [_responseDelegate requestDidFailed:self];
        }
    }
}

@end
