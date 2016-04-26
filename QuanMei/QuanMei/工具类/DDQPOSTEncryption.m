//
//  DDQPOSTEncryption.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/11.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQPOSTEncryption.h"

@interface DDQPOSTEncryption ()


@property (strong,nonatomic) NSMutableArray *temp_array;

@end

@implementation DDQPOSTEncryption

-(id)stringWithPost:(NSString *)postStr url:(NSString *)url model:(Class)model {
    
    BOOL isConnected = [self checkNetWorkStates];
    //判断是否有网络连接
    if (isConnected == YES) {
        BOOL isStates = [self isNetConnectedWithServer:url];
        
        //判断连接是否成功
        if (isStates == YES) {
            NSString *postString     = [self stringWithPost:postStr];//加密传进来的字符串
            NSMutableDictionary *dic = [[PostData alloc] postData:postString AndUrl:url];//加密post后的dic
            NSString *errorcode      = [dic valueForKey:@"errorcode"];
            NSArray *keyArray        = [dic allKeys];
            
            //如果这个array中有data这个键
            if ([keyArray containsObject:@"data"] && [errorcode intValue] == 0) {
                
                //如果这个键对应的值不为空
                if ([dic valueForKey:@"data"] != nil) {
                    NSString *jsonString = [self stringWithDic:dic];//解密加密post过后返给我的dic
                    BOOL  isJson         = [self checkJsonDic:jsonString];
                    
                    //如果服务器返给我东西了
                    if (isJson == YES) {
                        
                        NSData *data  = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
                        NSDictionary *data_dic  = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                        
                        NSArray *propteyArray  = [self getAllPropertiesOfModel:model];
                        NSMutableArray *temp_array = [NSMutableArray array];
                        
                        //应为propteyArray数组的元素不是NSString类型需转换
                        for (int i = 0; i<propteyArray.count; i++) {
                            NSString *string = propteyArray[i];
                            [temp_array addObject:string];
                        }
                        
                        BOOL iNeed = [self getNeedKey:data_dic keyArray:temp_array];
                        
                        //如果这个json中有我需要的所有的键
                        if (iNeed == YES) {
                            [self reflectDataFromOtherObject:data_dic];
                            
                            //如果这个零时数组没有值，表示key，value没问题
                            if (_temp_array.count == 0) {
                                return data_dic;
                                
                            } else {
                                return _temp_array;
                            }
                            
                        } else {
                            return @"键值缺失";
                        }
                        
                    } else {
                        return @"这不是json";
                    }
                    
                } else {
                    return @"data键值为空";
                }
                
            } else {
                if (errorcode) {
                    return [NSString stringWithFormat:@"%@",errorcode];
                    
                } else {
                    return @"没data键啊大兄弟";
                }
            }
            
        } else {
            return @"网络连接中断";
        }
        
    } else {
        return @"当前无网络连接";
    }
}

-(NSString *)stringWithDic:(NSDictionary *)dic {
    
    NSString *getString = @"";
    @try {
        for (int i=0; i<[[[dic objectForKey:@"data"]objectForKey:@"cnt"] intValue]; i++) {
            NSString *data_item = [[dic objectForKey:@"data"]objectForKey:[NSString stringWithFormat:@"%d",i]];
            char ret_out[512];
            memset(ret_out,0,sizeof(ret_out));
            decryptedString([data_item cStringUsingEncoding:NSUTF8StringEncoding], ret_out);
            
            getString = [getString stringByAppendingString:[[NSString alloc] initWithCString:(const char*)ret_out encoding:NSUTF8StringEncoding]];
        }
    }
    @catch (NSException *exception) {
    }
    return getString;
}

-(NSString *)stringWithPost:(NSString *)postStr {
    postStr = [postStr stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    const char * a_basePostString = [postStr UTF8String];
    long int str_counter;
    if((strlen(a_basePostString) % 60) != 0){
        str_counter = (long int)(strlen(a_basePostString) / 60) +1;
    } else {
        str_counter = (long int)(strlen(a_basePostString) / 60);
    }
    long int total_counter = str_counter + 3;
    NSString *t_counter = [NSString stringWithFormat:@"%ld",total_counter];
    
    NSString *postString = @"p0=";
    postString = [postString stringByAppendingString:t_counter];
    postString = [postString stringByAppendingString:@"&p1=7000000004&p2=2"];
    for (int i = 0; i < str_counter; i++) {
        postString = [postString stringByAppendingString:@"&p"];
        postString = [postString stringByAppendingString:[NSString stringWithFormat:@"%d",(i + 3)]];
        postString = [postString stringByAppendingString:@"="];
        
        char sub_text[100];
        memset(sub_text, 0, sizeof(sub_text));
        //strncpy(sub_text,a_basePostString+(i * 60), 60);
        
        if (i == (str_counter - 1)) {
            
            strncpy(sub_text,a_basePostString+(i * 60), (strlen(a_basePostString) - (i * 60)));
        } else {
            strncpy(sub_text,a_basePostString+(i * 60), 60);
        }
        
        char ret[512];
        memset(ret,0,sizeof(ret));
        encryptedString(sub_text,ret);
        
        NSString *en_postString = [[NSString alloc] initWithCString:(const char*)ret encoding:NSUTF8StringEncoding];
        en_postString = (NSString*)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(nil,(CFStringRef)en_postString, nil,(CFStringRef)@"!*'();:@&=+$,/?%#[]", kCFStringEncodingUTF8));
        
        postString = [postString stringByAppendingString:en_postString];
    }
    return postString;
}

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

-(BOOL)isNetConnectedWithServer:(NSString *)urlString {
    //设置检测主页
    Reachability *reachability = [Reachability reachabilityWithHostName:urlString];
    
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
    if (json_dic != nil) {
        return YES;
    } else {
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
    

    
    //判断是不是子集
    NSSet *new_set1 = [NSSet setWithArray:new_key_array];
    NSSet *new_set2 = [NSSet setWithArray:newKey_array];
    
    //比较两个新集合
    if ([new_set1 isSubsetOfSet:new_set2] == YES) {
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


- (void)reflectDataFromOtherObject:(NSDictionary *)dataSource {
    BOOL ret = NO;
    NSString *state_string = [[NSString alloc] init];
    for (NSString *key in [dataSource allKeys]) {
//        if ([dataSource isKindOfClass:[NSDictionary class]]) {
//            ret = ([dataSource valueForKey:key]==nil)?NO:YES;
//        }

        id propertyValue = [dataSource valueForKey:key];
        //该值不为NSNULL，并且也不为nil
        if (![propertyValue isKindOfClass:[NSNull class]] && propertyValue!=nil) {
            ret = YES;
        } else {
            ret = NO;
            state_string = [NSString stringWithFormat:@"%@的类型是%@,不是我要的",key,[propertyValue class]];
            break;//只要ret为NO就跳出去
        }
    }
    self.temp_array = [NSMutableArray array];

    if (ret == NO) {//当ret是no的时候记录对应的key的名字
        [_temp_array addObject:state_string];
        
    } else {
        
    }
}
@end
