//
//  PHPError.m
//  QpidNetworkForLady
//
//  Created by Lo Robert on 12-12-6.
//  Copyright (c) 2012年 Lo Robert. All rights reserved.
//

#import "WSError.h"

@implementation WSError


- (id) initWithDictionary:(NSDictionary *)dict{
    self=[super init];
    
    if (self) {
        [self setStatusType:(StatusType)[dict objectForKey:@"status"]];
    }
    
    return self;
}


@end
