//
//  DDQMyReplyedModel.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/10.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DDQMyCommentChildCell.h"
#import "DDQMyCommentChildModel.h"

//我需要控制器的Url,userid,页码
@protocol MyReplyedDelegate <NSObject>

@optional
-(NSString *)getMyReplyedVCUrl;
-(NSString *)getMyReplyedVCUserid;
-(int)getMyReplyedVCPage;

-(UIView *)HUDshowView;

@end

typedef void(^JSONBlock)(NSArray *modelArray);


@interface DDQMyReplyedModel : NSObject
@property (copy,nonatomic) NSString *url;
@property (copy,nonatomic) NSString *userid;
@property (assign,nonatomic) int page;
@property (strong,nonatomic) UIView *hudShowView;

@property (weak,nonatomic) id <MyReplyedDelegate> delegate;
@property (copy,nonatomic) JSONBlock jsonBlock;

-(void)myReplyedNetWorkWith:(JSONBlock)block;

+(instancetype)instanceManager;

@end
