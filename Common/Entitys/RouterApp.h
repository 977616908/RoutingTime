//
//  App.h
//  PiFiiHome
//
//  Created by Robert Lo on 14-5-8.
//  Copyright (c) 2014年 因孚网络科技. All rights reserved.
//
#define HOST_IP_WAN  @"witfii.com"
#define HOST_IP_WAN_OWN  @"www.ifidc.com"
#define HOST_IP_LAN  [GlobalShare routerIP]
#define VERSION  @"0"

#import <Foundation/Foundation.h>

@interface RouterApp : NSObject

@property(nonatomic,copy)NSString *ipAddr;
@property(nonatomic,copy)NSString *version;
@property(nonatomic,copy)NSString *token;
@property(nonatomic,copy)NSString *xsrf;

+ (RouterApp *)sharedApp;

-(NSString *)apiRootURL;

@end
