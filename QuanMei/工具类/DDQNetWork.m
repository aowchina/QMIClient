//
//  DDQNetWork.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/8.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQNetWork.h"


//@interface DDQNetWork ()
//
//@property (copy,nonatomic) NetWorkError error;
//
//+(void)checkNetWorkWithError:(NetWorkError)error;
//
//@end

@implementation DDQNetWork


+(void)checkNetWorkWithError:(netWorkError)error {

    DDQNetWork *netWork = [[DDQNetWork alloc] init];
    netWork.error = error;
    
    NSURL *url = [[NSURL alloc] initWithString:kBaseUrl];
    
    NSMutableURLRequest *urlRequest = [[NSMutableURLRequest alloc] initWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0f];
    
   [NSURLConnection sendAsynchronousRequest:urlRequest queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse * response, NSData * data, NSError * connectionError) {
       
       if (data == nil) {
           netWork.error(connectionError.userInfo);
       } else {
           netWork.error(nil);
       }
    }];

}

@end
