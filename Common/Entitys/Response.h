//
//  Response.h
//  QNKit
//
//  Created by Robert Luo on 12-7-24.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WSError.h"

@interface Response : NSObject

@property(nonatomic,copy)NSString *session;
@property(nonatomic,assign)NSInteger status;
@property(nonatomic,copy) NSString *token;
@property(nonatomic,copy)NSString *userAgent;
@property(nonatomic,strong) WSError *error;

- (id) initWithDict:(NSDictionary *)response;

@end
