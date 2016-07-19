//
//  DDQMyCommentChildModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQMyCommentChildModel : NSObject
@property (copy,nonatomic) NSString *id;
@property (copy,nonatomic) NSString *userid;
@property (copy,nonatomic) NSString *userid2;
@property (copy,nonatomic) NSString *username;
@property (copy,nonatomic) NSString *username2;
@property (copy,nonatomic) NSString *text;//标题
@property (copy,nonatomic) NSString *text2;//内容
@property (copy,nonatomic) NSString *userimg;
@property (copy,nonatomic) NSString *pubtime;
@property (copy,nonatomic) NSString *wid;

//@property (copy,nonatomic) NSString *title;
//@property (copy,nonatomic) NSString *intro;
//
//
//@property (copy,nonatomic) NSString *commentString;
//@property (copy,nonatomic) NSString *commentUser;
//
@property (copy,nonatomic) NSString *ctime;
//@property (copy,nonatomic) NSString *articleId;

@end
