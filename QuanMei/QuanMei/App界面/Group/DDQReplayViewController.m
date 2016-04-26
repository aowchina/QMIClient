//
//  DDQReplayViewController.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/10/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQReplayViewController.h"

#import "Header.h"

//user
#import "DDQUserInfoModel.h"



@interface DDQReplayViewController ()<UITextFieldDelegate,UITextViewDelegate,UINavigationControllerDelegate>

@property (nonatomic ,strong)UITextView *textView;
@property (nonatomic ,strong)UILabel *alabel;


@property (nonatomic ,strong)UIView *backView;//遮掩
@property (nonatomic ,strong)UIView *showView;

@property (nonatomic ,strong)NSString *contetSTring;//内容

@end

@implementation DDQReplayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor lightGrayColor];
    
    self.navigationController.navigationBar.translucent = NO;
    
    [self creatView];
    
    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:(UIBarButtonItemStyleDone) target:self action:@selector(replayRep)];
    
    
    self.navigationItem.rightBarButtonItem = bar;
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
}

- (void)replayRep {

    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        
        if (errorDic == nil) {
            
            [self replayAsyNetWork];
            
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
}

-(void)replayAsyNetWork {

    //
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //调用点赞接口
        //八段
        NSString *spellString = [SpellParameters getBasePostString];
        
        NSData *data = [_textView.text dataUsingEncoding:NSUTF8StringEncoding];
        Byte *byteArray = (Byte *)[data bytes];
        NSMutableString *str = [[NSMutableString alloc] init];
        for(int i=0;i<[data length];i++) {
            [str appendFormat:@"%d#",byteArray[i]];
        }
        
        //自己回复自己
        if ([self.beiPLUserId isEqualToString:[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]]) {
            self.beiPLUserId = @"0";
        }
        
        //拼参数
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],self.beiPLUserId,self.wenzhangId,self.fathPLId,str];
        
        
        //加密
        DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
        NSString *post_encryption = [post stringWithPost:post_baseString];
        
        //传
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kPl_add];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            int num = [post_dic[@"errorcode"] intValue];
            
            
            if (num == 0) {
                //                [self alertController:@"发布成功"];
                [self.navigationController popViewControllerAnimated:YES];
            } else if (num == 16) {
                
                [self alertController:@"您还未登录，无法评价"];
            } else if (num == 17) {
                
            } else {
                [self alertController:@"系统繁忙"];
            }
        });
    });

}

#pragma  mark - 构建页面
- (void)creatView {
    //输入
    UIView *blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height/2)];
    
    blackView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:blackView];
    
    UITextView * textView = [[UITextView alloc]initWithFrame:CGRectMake(0, 0, blackView.frame.size.width, blackView.frame.size.height)];
    
    textView.delegate = self;
    
    _textView= textView;
    
    [blackView addSubview:textView];
    
    
    _alabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, blackView.frame.size.width-10, 30)];
    
    _alabel.text = @"请输入回复内容";
    
    _alabel.font = [UIFont systemFontOfSize:14];
    
    _alabel.textColor = [UIColor colorWithRed:147.0/255 green:147.0/255  blue:147.0/255  alpha:0.4f];
    
    _alabel.enabled = NO;
    
    _alabel.backgroundColor = [UIColor clearColor];
    
    [blackView addSubview:_alabel];
    
    //底部
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0, blackView.frame.origin.y + blackView.frame.size.height +10, blackView.frame.size.width, self.view.frame.size.height - blackView.frame.size.height-10)];
    
    footView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:footView];
    
    
    UIView *tubiaoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, footView.frame.size.width, 50)];
    
    [footView addSubview:tubiaoView];
}

- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length ==0) {
        _alabel.text = @"请输入回复内容";
    }
    else
    {
        _alabel.text = @"";
    }
    _contetSTring = textView.text;
}

#pragma mark - 回收键盘
//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    UIBarButtonItem *done =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
//    self.navigationItem.rightBarButtonItem = done;
//}
//- (void)textViewDidEndEditing:(UITextView *)textView {
//    UIBarButtonItem *bar = [[UIBarButtonItem alloc]initWithTitle:@"发表" style:(UIBarButtonItemStyleDone) target:self action:@selector(replayRep)];
//    
//    self.navigationItem.rightBarButtonItem = bar;
//}
- (void)leaveEditMode {
    [_textView resignFirstResponder];
}
- (void)dismissViewRep
{
    [_showView removeFromSuperview];
    [_backView removeFromSuperview];
}

#pragma mark - other methods
-(void)alertController:(NSString *)message {
    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [userNameAlert addAction:actionOne];
    [userNameAlert addAction:actionTwo];
    [self presentViewController:userNameAlert animated:YES completion:nil];
}
@end
