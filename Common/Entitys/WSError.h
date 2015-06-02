//
//  PHPError.h
//  QpidNetworkForLady
//
//  Created by Lo Robert on 12-12-6.
//  Copyright (c) 2012年 Lo Robert. All rights reserved.
//

#import <Foundation/Foundation.h>


typedef enum {
    Successful,//成功
    Unsuccessful,//操作未完成,下次再查(专为长操作设计)
    ArgumentsError,//参数错误。
    InsideError,//系统内部错误。
    Unknown,//未知错误。
    AppError,//应用错误(配置保存成功,但服务 reload 失败)。
    NoLogin,//未登录。
    ConnFailure,//配置提交成功,但连接失败。
    None,//留空。
    Operation,//上一次操作还未完成,不允许进行本次操作。
}StatusType;

@interface WSError : NSObject

@property(nonatomic,assign)StatusType statusType;

- (id) initWithDictionary:(NSDictionary *)dict;

@end
