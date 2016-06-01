//
//  DDQLoginSingleModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/9.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQLoginSingleModel : NSObject
#pragma mark - 普通登陆和注册
/**
 *  用户昵称
 */
@property (strong,nonatomic) NSString *nameString;
/**
 *  用户出生年月
 */
@property (strong,nonatomic) NSString *userBorn;
/**
 *  用户电话
 */
@property (strong,nonatomic) NSString *userPhone;
/**
 *  用户密码
 */
@property (strong,nonatomic) NSString *userPassword;
/**
 *  记录用户是否登录
 */
@property (assign,nonatomic) BOOL isLogin;
/**
 *  记录用户的id
 */
@property (copy,nonatomic) NSString *errorCodeString;

@property (copy,nonatomic) NSString *positionString;

@property (copy,nonatomic) NSString *iconString;

#pragma mark - 第三方登陆
/**
 *  用户头像
 */
@property (copy,nonatomic) NSString *userImage;
/**
 *  用户昵称
 */
@property (copy,nonatomic) NSString *userNickName;


+(instancetype)singleModelByValue;
@end
