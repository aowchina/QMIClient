//
//  DDQNetUtils.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/9.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQNetUtils.h"
#import "Reachability.h"
#import <objc/runtime.h>

@implementation DDQNetUtils
-(BOOL)checkNetWorkStates {
    
    SCNetworkReachabilityFlags flags;
    BOOL receivedFlags;
    
    SCNetworkReachabilityRef reachability = SCNetworkReachabilityCreateWithName(CFAllocatorGetDefault(), [@"www.baidu.com" UTF8String]);
    receivedFlags = SCNetworkReachabilityGetFlags(reachability, &flags);
    CFRelease(reachability);
    
    if (!receivedFlags || (flags == 0) ) {
        return NO;
        
    } else {
        return YES;
    }
}

-(BOOL)isNetConnected {
    //设置检测主页
    Reachability *reachability = [Reachability reachabilityWithHostName:@"www.baidu.com"];
    
    NetworkStatus status = [reachability currentReachabilityStatus];
    [reachability startNotifier];
    if (status == NotReachable) {
        return NO;
        
    } else {
        return YES;
    }
}

-(BOOL)checkJsonDic:(NSString *)jsonString {
    
    NSData *json_data      = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *json_dic = [NSJSONSerialization JSONObjectWithData:json_data options:NSJSONReadingMutableContainers error:nil];
    
    @try {
        NSString *json_key     = [json_dic valueForKey:@"xixi"];
    }
    @catch (NSException *exception) {
        return NO;
    }
}


-(BOOL)getNeedKey:(NSDictionary *)jsonDic keyArray:(NSArray *)keyArray {
    
    NSArray *key_array = [jsonDic allKeys];//拿出所有的键值
    
    //排序后的新数组
    NSArray *new_key_array = [key_array sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return obj1 > obj2;
    }];
    
    //再把传入的数组排下序
    NSArray *newKey_array  = [keyArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        return obj1 > obj2;
    }];
    
    //比较两个新数组
    if ([new_key_array isEqualToArray:newKey_array] == YES) {
        return YES;
        
    } else {
        return NO;
    }
}

-(Class)judgeValuesType:(NSDictionary *)dic key:(NSString *)key {
    
    return [[dic valueForKey:key] class];
}


- (NSArray *)getAllPropertiesOfModel:(Class)model {
    
    u_int count;
    objc_property_t *properties  =class_copyPropertyList([model class], &count);
    NSMutableArray *propertiesArray = [NSMutableArray arrayWithCapacity:count];
    for (int i = 0; i<count; i++) {
        const char* propertyName =property_getName(properties[i]);
        [propertiesArray addObject: [NSString stringWithUTF8String: propertyName]];
    }
    free(properties);
    return propertiesArray;
}
@end
