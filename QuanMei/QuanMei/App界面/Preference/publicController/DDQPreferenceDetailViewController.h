//
//  DDQPreferenceDetailViewController.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/6.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DDQPreferenceDetailViewController : UIViewController
@property (nonatomic, readonly, copy) NSString *activityID;
//初始化方法
- (instancetype)initWithActivityID:(NSString *)activityID;

@end
