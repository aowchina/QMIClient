//
//  DDQMainViewControllerModel.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/13.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQMainViewControllerModel.h"

@implementation DDQMainViewControllerModel



-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        _IdString = value;
    }
    if ([key isEqualToString:@"newval"]) {
        _newvalString = value;
    }if ([key isEqualToString:@"oldval"]) {
        _oldvalString = value;
    }if ([key isEqualToString:@"bimg"]) {
        _bimgString = value;
    }if ([key isEqualToString:@"fname"]) {
        _fnameString = value;
    }if ([key isEqualToString:@"name"]) {
        _nameString = value;
    }if ([key isEqualToString:@"simg"]) {
        _simgString = value;
    }
    
//    if ([key isEqualToString:@""]) {
//        <#statements#> = value;
//    }
}

@end
