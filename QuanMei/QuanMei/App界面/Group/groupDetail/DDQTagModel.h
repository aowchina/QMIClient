//
//  DDQTagModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 16/2/23.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQTagModel : NSObject

@property (copy,nonatomic) NSString *gid;
@property (copy,nonatomic) NSString *iD;
@property (copy,nonatomic) NSString *intime;
@property (copy,nonatomic) NSString *name;
//选中的标签是否改变
@property (assign,nonatomic) BOOL isChange;

@end
