
//
//  DDQOrderModel.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/12/11.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQOrderModel.h"

@implementation DDQOrderModel
-(void)setValue:(id)value forUndefinedKey:(NSString *)key
{
    if ([key isEqualToString:@"id"]) {
        self.idString = value;
    }
}
@end
