//
//  ProjectNetWork.m
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "ProjectNetWork.h"

@implementation ProjectNetWork

+ (instancetype)sharedWork {

    static ProjectNetWork *net_work = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        net_work = [[ProjectNetWork alloc] init];
        
    });
    
    return net_work;
    
}

- (void)asy_netWithUrlString:(NSString *)url_s ParamArray:(NSArray *)param_a Success:(void (^)(id, NSError *))success Failure:(void (^)(NSError *))failure {

    NSURL *url = [NSURL URLWithString:url_s];
    
    //拼八段
    NSString *spell = [SpellParameters getBasePostString];
    
    //拼参数
    NSMutableString *mutable_string = [[NSMutableString alloc] initWithString:spell];
    
    if (param_a != nil && param_a.count != 0) {
        
        for (int i = 0; i<param_a.count; i++) {
            
            [mutable_string appendFormat:@"*%@",param_a[i]];
            
        }
        
    }

    //加密
    NSString *encrption_str = [[[DDQPOSTEncryption alloc] init] stringWithPost:mutable_string];
    
    NSMutableURLRequest *url_request = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:0 timeoutInterval:8.0f];
    [url_request setHTTPMethod:@"POST"];
    [url_request setHTTPBody:[encrption_str dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLSessionConfiguration *ses_con = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *ses = [NSURLSession sessionWithConfiguration:ses_con];
    NSURLSessionDataTask *data_task = [ses dataTaskWithRequest:url_request completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                failure(error);
                
            });
            
        } else {
        
            id data_source = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
            if (data_source == nil) {
                
                NSError *description_error = [NSError errorWithDomain:@"返回值为空" code:1 userInfo:@{@"error":[[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]}];
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    success(nil,description_error);
                    
                });
                
            } else {
            
                if ([data_source[@"errorcode"] intValue] == 0) {
                    
                    NSString *str = [[[DDQPOSTEncryption alloc] init] stringWithDic:data_source];
                    NSData *str_data = [str dataUsingEncoding:NSUTF8StringEncoding];
                    id source = [NSJSONSerialization JSONObjectWithData:str_data options:NSJSONReadingMutableContainers error:nil];
                    if (source == nil) {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            success(str,nil);
                            
                        });
                        
                    } else {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            
                            success(source,nil);
                            
                        });
                        
                    }
                    
                } else {
                    
                    
                    NSError *code_error = [NSError errorWithDomain:@"errorcode不为0" code:[data_source[@"errorcode"] intValue] userInfo:@{@"errorcode":[NSString stringWithFormat:@"%d",[data_source[@"errorcode"] intValue]]}];
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        success(nil,code_error);
                        
                    });
                    
                }
                
            }
            
        }
        
    }];

    [data_task resume];
    
}

@end
