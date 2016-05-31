//
//  DDQMineInfoModel.m
//  QuanMei
//
//  Created by min-fo013 on 15/10/19.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQMineInfoModel.h"

@implementation DDQMineInfoModel

-(DDQMineInfoModel *)loadModelWithDictionary:(NSDictionary *)dict {
    DDQMineInfoModel *model = [[DDQMineInfoModel alloc] init];
    model.age = [NSString stringWithFormat:@"%@",dict[@"age"]];
    model.city = dict[@"city"];
    model.level = [NSString stringWithFormat:@"%@",dict[@"level"]];
    model.sex = dict[@"sex"];
    model.star = [NSString stringWithFormat:@"%@",dict[@"star"]];
    model.userimg = dict[@"userimg"];
    model.userid = [NSString stringWithFormat:@"%@",dict[@"userid"]];
    model.username = dict[@"username"];
    return model;
}

@end
