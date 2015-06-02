//
//  CloudMessage.h
//  RoutingTime
//
//  Created by HXL on 15/3/18.
//  Copyright (c) 2015年 广州因孚网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CloudMessage : NSObject
//@property(nonatomic,copy)NSString *cloundTitle;
@property(nonatomic,strong)UIImage *cloundImage;
//@property(nonatomic,copy)NSString *cloundContent;

@property(nonatomic,copy)NSString *type;
@property(nonatomic,copy)NSString *name;
@property(nonatomic,copy)NSArray *downloadUrl;
@property(nonatomic,copy)NSString *smallPicPath;
@property(nonatomic,copy)NSString *bigPicPath;
@property(nonatomic,copy)NSString *netFrom;
@property(nonatomic,copy)NSString *middlePicPath;
@property(nonatomic,copy)NSString *middleSearchPicPath;
@property(nonatomic,copy)NSString *plot;
@property(nonatomic,copy)NSString *protagonist;
@property(nonatomic,copy)NSString *director;
@property(nonatomic,copy)NSString *region;
@property(nonatomic,copy)NSString *year;
@property(nonatomic,copy)NSString *introduction;

@property(nonatomic,copy)NSString *updateAmountAll;
@property(nonatomic,copy)NSString *updateAmountNew;

-(id)initWithData:(NSDictionary *)data;

@end
