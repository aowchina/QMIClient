//
//  DDQMyReplyedModel.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/10.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQMyReplyedModel.h"


@interface DDQMyReplyedModel ()



@end

@implementation DDQMyReplyedModel

+(instancetype)instanceManager {

    static DDQMyReplyedModel *model = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        model = [[self alloc] init];
    });
    return model;
}

-(void)setDelegate:(id<MyReplyedDelegate>)delegate {

    if (delegate != nil && [delegate respondsToSelector:@selector(getMyReplyedVCUrl)]) {
        self.url = [delegate getMyReplyedVCUrl];
    }
    if (delegate != nil && [delegate respondsToSelector:@selector(getMyReplyedVCUrl)]) {
        self.userid = [delegate getMyReplyedVCUserid];
    }
    if (delegate != nil && [delegate respondsToSelector:@selector(getMyReplyedVCUrl)]) {
        self.page = [delegate getMyReplyedVCPage];
    }
    if (delegate != nil && [delegate respondsToSelector:@selector(getMyReplyedVCUrl)]) {
        self.hudShowView = [delegate HUDshowView];
    }
}


-(void)myReplyedNetWorkWith:(JSONBlock)block {

    self.jsonBlock = block;
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        
        if (errorDic == nil) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                //八段
                NSString *spellString = [SpellParameters getBasePostString];
                
                //拼参数
                NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%d",spellString,self.userid,self.page];
                
                //加密
                DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
                NSString *post_encryption = [post stringWithPost:post_baseString];
                
                //传
                NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:self.url];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_dic];
                    
                    NSMutableArray *model_array = [NSMutableArray array];
                    
                    for (NSDictionary *dic in get_jsonDic) {
                        
                        DDQMyCommentChildModel *comment_childModel = [[DDQMyCommentChildModel alloc] init];
                        comment_childModel.iD        = dic[@"id"];
                        comment_childModel.pubtime   = dic[@"pubtime"];
                        comment_childModel.title     = dic[@"text"];
                        comment_childModel.intro     = dic[@"text2"];
                        comment_childModel.userid    = dic[@"userid"];
                        comment_childModel.userid2   = dic[@"userid2"];
                        comment_childModel.userimg   = dic[@"userimg"];
                        comment_childModel.username  = dic[@"username"];
                        comment_childModel.username2 = dic[@"username2"];
                        comment_childModel.userimg   = dic[@"userimg"];

                        [model_array addObject:comment_childModel];
                    }
                    
                    self.jsonBlock(model_array);
                    
                });
            });
            
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.hudShowView
                                 andCustomText:kErrorDes
                                    andShowDim:NO
                                   andSetDelay:YES
                                 andCustomView:nil];
        }
    }];
    
}



@end
