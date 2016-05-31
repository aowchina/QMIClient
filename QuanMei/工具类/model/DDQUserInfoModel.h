//
//  DDQUserInfoModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/11.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQUserInfoModel : NSObject

@property (copy,nonatomic) NSString *ageString;
@property (copy,nonatomic) NSString *userimg;
@property (copy,nonatomic) NSString *passwordString;
@property (copy,nonatomic) NSString *userid;
@property (copy,nonatomic) NSString *userName;
@property (copy,nonatomic) NSString *userPhone;
@property (copy,nonatomic) NSString *userLevel;
@property (copy,nonatomic) NSString *userPid;
@property (copy,nonatomic) NSString *userSex;
@property (copy,nonatomic) NSString *birthdayString;

@property (assign,nonatomic) BOOL isLogin;

@property (strong,nonatomic) NSDictionary *QQUserInfo;


+(instancetype)singleModelByValue;


@end
