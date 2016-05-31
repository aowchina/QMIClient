//
//  DDQNewOrderDetailController.m
//  QuanMei
//
//  Created by min－fo018 on 16/5/14.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQNewOrderDetailController.h"

#import "DDQNewOrderDetailView.h"
#import "QRCode.h"
@interface DDQNewOrderDetailController ()<NewOrderDetailDelegate>

@property ( strong, nonatomic) DDQNewOrderDetailView *orderDetailV;

@end

@implementation DDQNewOrderDetailController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.title_label.text = @"订单详情";
    
    /**
     初始化还是在这里做好点
     */
    self.orderDetailV = [[DDQNewOrderDetailView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.orderDetailV];
    self.orderDetailV.delegate = self;
    
    /**
     *  网络请求
     */
    [self orderDetailC_netWork];
    
}

/**
 *  订单详情网络请求
 */
- (void)orderDetailC_netWork {

    [self.wait_hud show:YES];
    [self.net_work asy_netWithUrlString:kUserOrderDetailUrl ParamArray:@[self.userid,self.orderid] Success:^(id source, NSError *analysis_error) {
        
        if (analysis_error) {
            
            [self.wait_hud hide:YES];
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        } else {
        
            [self.wait_hud hide:YES];
            DDQNewOrderDetailModel *new_model = [DDQNewOrderDetailModel mj_objectWithKeyValues:source];
            [self.orderDetailV new_orderDetailViewWithModel:new_model];

        }
        
    } Failure:^(NSError *net_error) {
    
        [self.wait_hud hide:YES];
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
}

/**
 *  生成二维码
 *
 *  @param QR_content 一条用以生成二维码的字符串
 */
- (void)new_orderDetailView_createQRCode:(NSString *)QR_content {

    QRCode *code = [[QRCode alloc] initWithQRCodeString:QR_content width:kScreenWidth*0.6];
    UIImage *QRCode = code.QRCodeImage;
    
    UIView *QRView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
    [self.view.window addSubview:QRView];
    QRView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    
    UIImageView *QRImg = [[UIImageView alloc] init];
    [QRView addSubview:QRImg];
    [QRImg mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.mas_equalTo(QRView.mas_centerX);
        make.centerY.mas_equalTo(QRView.mas_centerY);
        make.width.and.height.offset(kScreenWidth * 0.6);
        
    }];
    QRImg.userInteractionEnabled = YES;
    QRImg.image = QRCode;
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
    [QRView addGestureRecognizer:tap1];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeView:)];
    [QRView addGestureRecognizer:tap2];
    
}

- (void)removeView:(UITapGestureRecognizer *)tap {

    if ([[tap view] isKindOfClass:[UIImageView class]]) {
        
        [[[tap view] superview] removeFromSuperview];
        
    } else {
    
        [[tap view] removeFromSuperview];
        
    }
    
}

@end
