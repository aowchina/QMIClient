//
//  DDQReplayViewController.h
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQReplayViewController : UIViewController
//被回复者userid
@property (nonatomic ,copy)NSString *beiPLUserId;
//文章id
@property (nonatomic ,copy)NSString *wenzhangId;
//父级评论id
@property (nonatomic ,copy)NSString *fathPLId;


@end
