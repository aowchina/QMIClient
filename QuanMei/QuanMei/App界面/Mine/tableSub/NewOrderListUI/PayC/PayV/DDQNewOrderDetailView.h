//
//  DDQNewOrderDetailView.h
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DDQNewOrderDetailModel.h"

@protocol NewOrderDetailDelegate <NSObject>

@optional
- (void)new_orderDetailView_callTel:(NSString *)tel;
- (void)new_orderDetailView_createQRCode:(NSString *)QR_content;

@end

@interface DDQNewOrderDetailView : UIView

@property ( weak, nonatomic) id <NewOrderDetailDelegate> delegate;
- (CGFloat)new_orderDetailViewWithModel:(DDQNewOrderDetailModel *)detail_model;

@end
