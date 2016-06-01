//
//  DDQSetModel.m
//  QuanMei
//
//  Created by min-fo013 on 15/10/15.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQSetModel.h"

@implementation DDQSetModel

- (DDQSetModel *)loadDataWithDictionary:(NSDictionary *)dic {
        DDQSetModel *model = [[DDQSetModel alloc] init];
        model.img = dic[@"img"];
        model.niceName = dic[@"niceName"];
        model.age = dic[@"age"];
        model.city = dic[@"city"];
        model.level = dic[@"level"];
    return model;
}

@end
