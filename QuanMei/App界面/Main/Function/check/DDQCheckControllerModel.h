//
//  DDQCheckControllerModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/9.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DDQCheckControllerModel : NSObject

@property (copy,nonatomic) NSString *iconString;

@property (copy,nonatomic) NSString *nameString;

@property (copy,nonatomic) NSString *projectNameString;

@property (copy,nonatomic) NSString *projectIdString;

@property (strong,nonatomic) NSMutableArray *listArray;

@property (assign,nonatomic) BOOL showImage;
@end
