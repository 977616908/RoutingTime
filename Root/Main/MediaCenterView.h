//
//  PiFiiHeadView.h
//  RoutingTime
//
//  Created by Harvey on 14-5-8.
//  Copyright (c) 2014年 广州因孚网络科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "REPhoto.h"
typedef void(^BackupWithImage)(NSInteger index);

@interface MediaCenterView : CCView
@property(nonatomic,strong)id superController;
@property(nonatomic,copy)BackupWithImage backup;
@property(nonatomic,weak)CCButton *btnMessage;
@property(nonatomic,strong,setter=setImagePhoto:)NSMutableArray *imageArr;
@property(nonatomic,strong,setter=setCloudVedio:)NSMutableArray *vedioArr;
@property(nonatomic,assign,getter=isError)BOOL error;
@end
