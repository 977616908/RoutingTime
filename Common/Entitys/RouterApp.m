//
//  App.m
//  PiFiiHome
//
//  Created by Robert Lo on 14-5-8.
//  Copyright (c) 2014年 因孚网络科技. All rights reserved.
//

#import "RouterApp.h"

static RouterApp* _sharedApp= nil;

@implementation RouterApp

+ (RouterApp *)sharedApp
{
   	@synchronized(self)
    {
		if (_sharedApp== nil)
        {
            _sharedApp = [[self alloc] init];
        }
	}
    
	return _sharedApp;
}

-(id)init
{
    self=[super init];
    
    if (self)
    {
        _ipAddr = HOST_IP_LAN;
        if (CurrentRouterConnectionMode() == RouterConnectionModeTransitServer) {
            
            _ipAddr = HOST_IP_WAN;
        }else if (CurrentRouterConnectionMode() == RouterConnectionModeOwnServer) {
            
            _ipAddr = HOST_IP_WAN_OWN;
        }
        _version=VERSION;
        
        return self;
    }
    
    return NULL;
}

-(NSString *)apiRootURL
{
    NSString *rootURL=@"https://";
    rootURL=[rootURL stringByAppendingString:_ipAddr];
    
    if (CurrentRouterConnectionMode() == RouterConnectionModeLocal) {
        
        rootURL=[rootURL stringByAppendingString:@"/cgi-bin/luci/api/"];
        rootURL=[rootURL stringByAppendingString:_version];
    }
    rootURL=[rootURL stringByAppendingString:@"/"];
    
    return rootURL;
}

@end
