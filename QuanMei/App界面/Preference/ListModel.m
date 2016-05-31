//
//  ListModel.m
//  QuanMei
//
//  Created by minfo010 on 15/10/14.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    //act_list
    if ([key isEqualToString:@"bimg"]) {
        self.act_list_bimg = value;
    }
    if ([key isEqualToString:@"fname"]) {
        self.act_list_ffname = value;
    }
    if ([key isEqualToString:@"hid"]) {
        self.act_list_hid = value;
    }
    if ([key isEqualToString:@"intime"]) {
        self.act_list_intime = value;
    }
    if ([key isEqualToString:@"name"]) {
        self.act_list_name = value;
    }
    if ([key isEqualToString:@"pid"]) {
        self.act_list_pid = value;
    }
    if ([key isEqualToString:@"simg"]) {
        self.act_list_simg = value;
    }
    if ([key isEqualToString:@"id"]) {
        self.act_list_id = value;
    }
}

@end
