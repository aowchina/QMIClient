//
//  DDQMyCommentChildModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQMyCommentChildModel : NSObject
@property (copy,nonatomic) NSString *iD;
@property (copy,nonatomic) NSString *userid;
@property (copy,nonatomic) NSString *userid2;

@property (copy,nonatomic) NSString *title;
@property (copy,nonatomic) NSString *intro;
@property (copy,nonatomic) NSString *userimg;
@property (copy,nonatomic) NSString *username;
@property (copy,nonatomic) NSString *username2;

@property (copy,nonatomic) NSString *pubtime;
@property (copy,nonatomic) NSString *commentString;
@property (copy,nonatomic) NSString *commentUser;
@end
