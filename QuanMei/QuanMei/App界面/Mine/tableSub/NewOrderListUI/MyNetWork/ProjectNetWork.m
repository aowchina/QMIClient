//
//  ProjectNetWork.m
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "ProjectNetWork.h"
#import "AFNetworking.h"

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

- (void)asyPOSTWithAFN_url:(NSString *)url andData:(NSArray *)data andSuccess:(void (^)(id, NSError *))success andFailure:(void (^)(NSError *))failure {

    //拼八段
    NSString *spell = [SpellParameters getBasePostString];
    
    //拼参数
    NSMutableString *mutable_string = [[NSMutableString alloc] initWithString:spell];
    
    if (data != nil && data.count != 0) {
        
        for (int i = 0; i<data.count; i++) {
            
            [mutable_string appendFormat:@"*%@",data[i]];
            
        }
        
    }
    
    //加密
    NSString *encrption_str = [[[DDQPOSTEncryption alloc] init] stringWithPost:mutable_string];
    
    NSMutableString *temp_string = [[NSMutableString alloc] initWithString:encrption_str];
    
    NSMutableArray *temp_array = [NSMutableArray array];
    
    NSUInteger temp_i = 0;
    NSUInteger total_i = temp_string.length;
    
    while (temp_i < total_i) {
        
        NSRange range = [temp_string rangeOfString:@"&"];
        NSString *str;
        if (range.length != 0) {
            
            str = [temp_string substringToIndex:range.location];
            [temp_array addObject:str];
            [temp_string deleteCharactersInRange:NSMakeRange(0, range.location+1)];
            temp_i = temp_i + range.location + 1;
            
        } else {
            
            str = [temp_string substringToIndex:temp_string.length];
            [temp_array addObject:str];
            [temp_string deleteCharactersInRange:NSMakeRange(0, temp_string.length)];
            temp_i = total_i;
            
        }
        
    }
    
    NSMutableDictionary *temp_dic = [NSMutableDictionary dictionary];
    
    for (NSString *str in temp_array) {
        
        if (![[temp_dic allKeys] containsObject:[str substringToIndex:2]]) {
            
            [temp_dic setValue:[str substringWithRange:NSMakeRange(3, str.length - 3)] forKey:[str substringToIndex:2]];
            
        }
        
    }
    
    AFHTTPSessionManager *session_manager = [AFHTTPSessionManager manager];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"text/html", @"application/json", @"text/json", @"text/javascript", nil];
    session_manager.responseSerializer = responseSerializer;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10.0;
    session_manager.requestSerializer = requestSerializer;
    
    [session_manager POST:url parameters:temp_dic success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:nil];
        //这个字典不为空
        if (dic) {
            
            if ([[dic valueForKey:@"errorcode"] intValue] == 0) {
                
                NSDictionary *tempDic = [DDQPOSTEncryption judgePOSTDic:dic];
                success(tempDic,nil);
                
            } else {
                
                NSError *error = [NSError errorWithDomain:@"errorcode提示" code:[[dic valueForKey:@"errorcode"] integerValue] userInfo:nil];
                success(nil,error);
                
            }
            
        } else {
        
            NSError *error = [NSError errorWithDomain:@"服务器返回值为空" code:107038 userInfo:nil];
            success(nil,error);
            
        }
        

    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        failure(error);

    }];

}

- (void)asyPOST_url:(NSString *)url Photo:(NSMutableArray *)imageArray Data:(NSArray *)data TagArray:(NSArray *)tagArray Success:(void (^)(id))success andFailure:(void (^)(NSError *))failure {

    //拼八段
    NSString *spell = [SpellParameters getBasePostString];
    
    //拼参数
    NSMutableString *mutable_string = [[NSMutableString alloc] initWithString:spell];
    
    if (data != nil && data.count != 0) {
        for (int i = 0; i<data.count; i++) {
            [mutable_string appendFormat:@"*%@",data[i]];
        }
    }
    
    //加密
    NSString *encrption_str = [[[DDQPOSTEncryption alloc] init] stringWithPost:mutable_string];
    
    //拼接字符串
    NSString *BOUNDRY = [self uuid];
    NSString *PREFIX = @"--";
    NSString *LINEND = @"\r\n";
    NSString *MULTIPART_FROM_DATA = @"multipart/form-data";
    NSString *CHARSET = @"UTF-8";
    
    //图片
    //图片
    int len=512;
    if (imageArray !=nil) {
        for (int i =0; i<imageArray.count; i++) {
            NSData *imageData = [imageArray objectAtIndex:i];
            //字节大小
            if(imageData !=nil){
                len = (int)imageData.length + len;
            }
        }
    }
    
    //文本类型
    NSMutableData  *postData =[NSMutableData dataWithCapacity:len];
    
    //p0
    NSArray *postArray = [encrption_str componentsSeparatedByString:@"&"];
    
    NSMutableString *text = [[NSMutableString alloc]init];
    
    for (int i = 0; i<postArray.count; i++) {
        
        [text appendString:[NSString stringWithFormat:@"%@%@%@",PREFIX,BOUNDRY,LINEND]];
        
        NSString *key = [postArray objectAtIndex:i];
        
        NSArray * smallArray = [key componentsSeparatedByString:@"="];
        
        [text appendFormat:@"Content-Disposition: form-data; name=\"%@\"%@",[smallArray objectAtIndex:0],LINEND];
        
        [text appendFormat:@"Content-Type: text/plain; charset=UTF-8%@",LINEND];
        [text appendString:LINEND];
        
        NSString *str =[[smallArray objectAtIndex:1] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        [text appendFormat:@"%@",str];
        
        [text appendString:LINEND];
        
    }
    
    [postData appendData:[text dataUsingEncoding:NSUTF8StringEncoding]];
    
    //文件数据
    if (imageArray.count != 0)
    {
        
        if (tagArray != nil && tagArray.count > 0) {
            
            for (int i = 0 ; i<imageArray.count; i++)
            {
                NSData *imagedata =  imageArray[i];
                [postData  appendData:[[NSString   stringWithFormat:@"%@%@%@",PREFIX,BOUNDRY,LINEND] dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSString *aaa = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"icon.png\"%@Content-Type: application/octet-stream;charset=UTF-8%@%@",[NSString stringWithFormat:@"img%ld",[tagArray[i] integerValue]],LINEND,LINEND,LINEND];
                
                [postData  appendData: [aaa dataUsingEncoding:NSUTF8StringEncoding]];
                
                [postData  appendData:imagedata];
                [postData appendData:[LINEND dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            
        } else {
            
            for (int i = 0 ; i<imageArray.count; i++){
                
                NSData *imagedata =  imageArray[i];
                [postData  appendData:[[NSString   stringWithFormat:@"%@%@%@",PREFIX,BOUNDRY,LINEND] dataUsingEncoding:NSUTF8StringEncoding]];
                
                NSString *aaa = [NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\";filename=\"icon.png\"%@Content-Type: application/octet-stream;charset=UTF-8%@%@",[NSString stringWithFormat:@"img%d",i],LINEND,LINEND,LINEND];
                
                [postData  appendData: [aaa dataUsingEncoding:NSUTF8StringEncoding]];
                
                [postData  appendData:imagedata];
                [postData appendData:[LINEND dataUsingEncoding:NSUTF8StringEncoding]];
                
            }
            
        }
        
    }
    
    [postData appendData:[[NSString stringWithFormat:@"%@%@%@",PREFIX,BOUNDRY,PREFIX] dataUsingEncoding:NSUTF8StringEncoding]];
   
    //网络请求
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];

    [urlRequest setTimeoutInterval:30.0];
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setValue:@"keep-alive" forHTTPHeaderField:@"connection"];
    [urlRequest setValue:CHARSET forHTTPHeaderField:@"Charsert"];
    [urlRequest setValue:[NSString stringWithFormat:@"%@;boundary=%@", MULTIPART_FROM_DATA,BOUNDRY] forHTTPHeaderField:@"Content-Type"];
    
    urlRequest.HTTPBody = postData;
    
    NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    NSURLSessionDataTask *dataTask = [session dataTaskWithRequest:urlRequest completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                failure(error);
                
            });
            
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                id dic = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
                
                success(dic);
                
            });
            
        }

    }];
    
    [dataTask resume];
    
}

/** 图片上传 */
- (void)asynPOSTPicUseAFN:(NSString *)url PhotoArray:(NSArray *)imgArray Param:(NSArray *)param Success:(void (^)(id, NSError *))success Failure:(void (^)(NSError *))failure {
    
    NSString *spell = [SpellParameters getBasePostString];
    
    //拼参数
    NSMutableString *mutable_string = [[NSMutableString alloc] initWithString:spell];
    
    if (param != nil && param.count != 0) {
        
        for (int i = 0; i<param.count; i++) {
            
            [mutable_string appendFormat:@"*%@",param[i]];
            
        }
        
    }
    
    //加密
    NSString *encryption_str = [[[DDQPOSTEncryption alloc] init] stringWithPost:mutable_string];
    
    NSArray *cutArray = [encryption_str componentsSeparatedByString:@"&"];
    
    NSMutableDictionary *paramDic = [NSMutableDictionary dictionary];
    
    for (NSString *str in cutArray) {
        
        if (![[paramDic allKeys] containsObject:[str substringToIndex:2]]) {
            
            [paramDic setValue:[str substringWithRange:NSMakeRange(3, str.length - 3)] forKey:[str substringToIndex:2]];
            
        }
        
    }

    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    
    AFHTTPResponseSerializer *responseSerializer = [AFHTTPResponseSerializer serializer];
    responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/json", @"text/javascript", @"text/html", nil];
    manager.responseSerializer = responseSerializer;
    
    AFHTTPRequestSerializer *requestSerializer = [AFHTTPRequestSerializer serializer];
    requestSerializer.timeoutInterval = 10.0;
    manager.requestSerializer = requestSerializer;
    
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nonnull responseObject) {
        
        
        
    } failure:^(NSURLSessionDataTask * _Nonnull task, NSError * _Nonnull error) {
        
        
        
    }];

}


//获取设备的UDID，唯一标识符给服务器
static NSString *uuidKey = @"ModelCenter uuid key";
-(NSString*)uuid
{
    NSString *string = [UICKeyChainStore stringForKey:uuidKey];
    if (string) {
        
    }else{
        UIDevice *currentDevice = [UIDevice currentDevice];
        NSUUID* identifierForVendor = currentDevice.identifierForVendor;
        string = [identifierForVendor UUIDString];
        [UICKeyChainStore setString:string forKey:uuidKey];
    }
    return string;
}


@end
