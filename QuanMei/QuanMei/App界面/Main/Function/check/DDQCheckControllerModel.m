//
//  DDQCheckControllerModel.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/9.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQCheckControllerModel.h"

@implementation DDQCheckControllerModel

-(NSMutableArray *)listArray {
    if (!_listArray) {
        _listArray = [NSMutableArray array];
    };
    return _listArray;
}

@end
