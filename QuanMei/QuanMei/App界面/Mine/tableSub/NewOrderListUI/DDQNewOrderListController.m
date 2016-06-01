//
//  DDQNewOrderListController.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/25.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQNewOrderListController.h"

#import "DDQPayController.h"
#import "DDQServerController.h"
#import "DDQEvaluateController.h"
#import "DDQCancelController.h"
#import "DDQOrderController.h"

@interface DDQNewOrderListController ()

@property (weak, nonatomic) IBOutlet UIButton *pay_button;
@property (weak, nonatomic) IBOutlet UIButton *server_button;
@property (weak, nonatomic) IBOutlet UIButton *evaluate_button;
@property (weak, nonatomic) IBOutlet UIButton *cancel_button;
@property (weak, nonatomic) IBOutlet UIButton *order_button;
@property (weak, nonatomic) IBOutlet UIView *temp_view;

/**
 *  插座button
 */
@property ( strong, nonatomic) UIButton *temp_button;

//子控制器
@property ( strong, nonatomic) DDQPayController *payC;
@property ( strong, nonatomic) DDQServerController *serverC;
@property ( strong, nonatomic) DDQEvaluateController *evaluateC;
@property ( strong, nonatomic) DDQCancelController *cancelC;
@property ( strong, nonatomic) DDQOrderController *orderC;

@end

@implementation DDQNewOrderListController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.title_label.text = @"我的订单";
    
    self.temp_button = self.pay_button;
    
    self.payC = [[DDQPayController alloc] initWithNibName:@"DDQPayController" bundle:nil];
    [self.view addSubview:self.payC.view];
    [self.payC.view mas_makeConstraints:^(MASConstraintMaker *make) {
    
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.temp_view.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    [self addChildViewController:self.payC];
    
    self.serverC = [[DDQServerController alloc] initWithNibName:@"DDQServerController" bundle:nil];
    [self.view insertSubview:self.serverC.view belowSubview:self.payC.view];
    [self.serverC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.temp_view.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    [self addChildViewController:self.serverC];
    
    self.evaluateC = [[DDQEvaluateController alloc] initWithNibName:@"DDQEvaluateController" bundle:nil];
    [self.view insertSubview:self.evaluateC.view belowSubview:self.payC.view];
    [self.evaluateC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.temp_view.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    [self addChildViewController:self.evaluateC];
    
    self.cancelC = [[DDQCancelController alloc] initWithNibName:@"DDQCancelController" bundle:nil];
    [self.view insertSubview:self.cancelC.view belowSubview:self.payC.view];
    [self.cancelC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.temp_view.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    [self addChildViewController:self.cancelC];
    
    self.orderC = [[DDQOrderController alloc] initWithNibName:@"DDQOrderController" bundle:nil];
    [self.view insertSubview:self.orderC.view belowSubview:self.payC.view];
    [self.orderC.view mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.view.mas_left);
        make.top.equalTo(self.temp_view.mas_bottom).offset(10);
        make.right.equalTo(self.view.mas_right);
        make.bottom.equalTo(self.view.mas_bottom);
        
    }];
    [self addChildViewController:self.orderC];
    
        
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.translucent = NO;
    
}

- (IBAction)differentButtonSelectedMethod:(UIButton *)sender {
    
    if (self.temp_button == sender) return;
    /**
     *  被选中的就不谈了
     */
    switch (sender.tag) {
            
        case 1:
            [sender setBackgroundImage:[UIImage imageNamed:@"img_To-be-paidL"] forState:UIControlStateNormal];
            [self.view bringSubviewToFront:self.payC.view];
            break;
            
        case 2:
            [sender setBackgroundImage:[UIImage imageNamed:@"img_For-serviceL"] forState:UIControlStateNormal];
            [self.view bringSubviewToFront:self.serverC.view];
            break;
            
        case 3:
            [sender setBackgroundImage:[UIImage imageNamed:@"img_To-evaluateL"] forState:UIControlStateNormal];
            [self.view bringSubviewToFront:self.evaluateC.view];
            break;
            
        case 4:
            [sender setBackgroundImage:[UIImage imageNamed:@"img_Has-been-cancelledL"] forState:UIControlStateNormal];
            [self.view bringSubviewToFront:self.cancelC.view];
            break;
            
        case 5:
            [sender setBackgroundImage:[UIImage imageNamed:@"img_My-orderL"] forState:UIControlStateNormal];
            [self.view bringSubviewToFront:self.orderC.view];
            break;
            
        default:
            break;
            
    }
    /**
     *  switch这个
     */
    switch (self.temp_button.tag) {
            
        case 1:
            [self.temp_button setBackgroundImage:[UIImage imageNamed:@"img_To-be-paid"] forState:UIControlStateNormal];
            break;
            
        case 2:
            [self.temp_button setBackgroundImage:[UIImage imageNamed:@"img_For-service"] forState:UIControlStateNormal];
            break;
            
        case 3:
            [self.temp_button setBackgroundImage:[UIImage imageNamed:@"img_To-evaluate"] forState:UIControlStateNormal];
            break;
            
        case 4:
            [self.temp_button setBackgroundImage:[UIImage imageNamed:@"img_Has-been-cancelled"] forState:UIControlStateNormal];
            break;
            
        case 5:
            [self.temp_button setBackgroundImage:[UIImage imageNamed:@"img_My-order"] forState:UIControlStateNormal];
            break;
            
        default:
            break;

    }
    /**
     *  别忘了这个
     */
    self.temp_button = sender;
    
}


@end
