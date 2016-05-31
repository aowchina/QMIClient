//
//  THModel.m
//  QuanMei
//
//  Created by minfo010 on 15/10/13.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "THModel.h"

@implementation THModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.ID = value;
    }
}
@end
