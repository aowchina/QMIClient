//
//  DDQFeedbackController.m
//  QuanMei
//
//  Created by min-fo013 on 15/10/16.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQFeedbackController.h"

@interface DDQFeedbackController ()<UITextFieldDelegate,UITextViewDelegate>

//联系方式
@property (nonatomic, strong)UITextField *numberField;
//反馈意见
@property (nonatomic, strong)UITextView *userFeedbackView;
//占位字
@property (nonatomic, strong)UILabel *placeholderLabel;

@property (nonatomic, strong) NSString *userPhone;
@property (nonatomic, strong) NSString *suggest;

@end

@implementation DDQFeedbackController

- (void)viewDidLoad {
    [super viewDidLoad];
//        self.navigationController.navigationBar.translucent = YES;
    [self buildSubView];
    // Do any additional setup after loading the view.
}

/**
 * @ author SuperLian
 *
 * @ date   15/12/4
 *
 * @ func   设置标题栏右按钮
 */
- (void)buildNavgationBar {
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    rightBtn.frame = CGRectMake(0, 0, 60, 30);
    rightBtn.titleLabel.text = @"提交";
    [rightBtn addTarget:self action:@selector(handlePush) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *rightButtonItem = [[UIBarButtonItem alloc] initWithCustomView:rightBtn];
    self.navigationItem.rightBarButtonItem = rightButtonItem;
}

- (void)buildSubView {
//    numberField
    self.view.backgroundColor = [UIColor whiteColor];
    self.numberField = [[UITextField alloc] init];
    
    self.numberField.delegate = self;
    
    self.numberField.borderStyle = UITextBorderStyleNone;
//    self.numberField.layer.cornerRadius = 5;
//    self.navigationController.navigationBar.translucent = NO;
    self.numberField.placeholder = @"请留下联系方式(QQ、邮箱、手机)";
    [self.view addSubview:self.numberField];
    
//    创建userFeedbackView
    self.userFeedbackView = [[UITextView alloc] init];
    //属性
    self.userFeedbackView.font = [UIFont systemFontOfSize:14];
    self.userFeedbackView.layer.borderWidth = 1;
//    self.userFeedbackView.layer.borderColor = (__bridge CGColorRef _Nullable)([UIColor colorWithRed:0.6 green:0.7 blue:0.5 alpha:1]);
    self.userFeedbackView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.userFeedbackView];
    self.userFeedbackView.hidden = NO;
    self.userFeedbackView.delegate = self;
    //其次在UITextView上面覆盖个UILable,UILable设置为全局变量。
    self.placeholderLabel = [[UILabel alloc] init];
    self.placeholderLabel.font = [UIFont systemFontOfSize:14];
    self.placeholderLabel.text = @"请输入反馈意见及建议...";
    //label必须设置为不可用
    self.placeholderLabel.enabled = NO;
    self.placeholderLabel.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.placeholderLabel];

}

- (void)viewWillLayoutSubviews {
    self.numberField.frame = CGRectMake(10, 10 + 64, self.view.bounds.size.width - 20, 40);
    self.userFeedbackView.frame = CGRectMake(10, 10  + 64 + self.numberField.bounds.size.height, self.view.bounds.size.width - 20, self.view.bounds.size.height - self.numberField.bounds.size.height - 49 - 64 - 20);
    self.placeholderLabel.frame = CGRectMake(12, 10 + 64 + self.numberField.bounds.size.height, self.view.bounds.size.width - 20, 40);
}

//    实现UITextView的代理
#pragma mark -  UITextFieldDelegate and UITextViewDelegate

// 结束输入后执行的方法
- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([self.type isEqualToString:@""]) {
        self.userPhone = textField.text;
    }else if ([self.type isEqualToString:@""]) {
                    self.userPhone = textField.text;
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}
-(void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length == 0) {
        self.placeholderLabel.text = @"请输入反馈意见及建议...";
    }else{
        self.placeholderLabel.text = @"";
    }
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.numberField endEditing:YES];
    [self.userFeedbackView endEditing:YES];
}


/**
 * @ author SuperLian
 *
 * @ date   15/12/4
 *
 * @ func   点击提交
 */
- (void)handlePush {
    
}



@end
