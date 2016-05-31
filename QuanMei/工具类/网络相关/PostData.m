//
//  PostData.m
//  FootballGame
//
//  Created by minfo010 on 15/5/25.
//  Copyright (c) 2015年 minfo010. All rights reserved.
//

#import "PostData.h"

@implementation PostData
-(id)postData:(NSString *)sender AndUrl:(NSString *)url
{
    //将NSSrring格式的参数转换格式为NSData，POST提交必须用NSData数据。
    NSData *postData = [sender dataUsingEncoding:NSUTF8StringEncoding allowLossyConversion:YES];
    //计算POST提交数据的长度
    NSString *postLength = [NSString stringWithFormat:@"%lu",(unsigned long)[postData length]];
    //定义NSMutableURLRequest
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:[NSURL URLWithString:url] cachePolicy:0 timeoutInterval:5.0f];
    //设置提交目的url
//    [request setURL:[NSURL URLWithString:url]];
    //设置提交方式为 POST
    [request setHTTPMethod:@"POST"];
    //设置http-header:Content-Type
    //这里设置为 application/x-www-form-urlencoded ，如果设置为其它的，比如text/html;charset=utf-8，或者 text/html 等，都会出错。不知道什么原因。
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    //设置http-header:Content-Length
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    //设置需要post提交的内容
    [request setHTTPBody:postData];
    //定义
    NSHTTPURLResponse* urlResponse = nil;
    NSError *error = [[NSError alloc] init];
    //同步提交:POST提交并等待返回值（同步），返回值是NSData类型。
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&urlResponse error:&error];
//    NSLog(@"data = %@",[[NSString alloc] initWithData:responseData encoding:NSUTF8StringEncoding]);
    if (responseData == nil) {
        return nil;
    }else{
        //将NSData类型的返回值转换成NSDictionary类型
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableContainers error:nil];
        return dic;

    }
    
}


@end
