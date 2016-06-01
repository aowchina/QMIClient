//
//  DDQBaoXianViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 16/2/1.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQBaoXianViewController.h"

@interface DDQBaoXianViewController ()
@property (strong,nonatomic) UIScrollView *main_scroll;
@end

@implementation DDQBaoXianViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.translucent = NO;
    //隐藏背景图
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    
    self.navigationController.navigationBar.tintColor = [UIColor meiHongSe];
    
    //设置左按钮
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"img_return"] style:UIBarButtonItemStyleDone target:self action:@selector(goBackMethod)];
    
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //设置标题
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 30)];
    label.text = @"全美发布";
    label.textColor = [UIColor meiHongSe];
    self.navigationItem.titleView = label;
    
    
    self.main_scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64)];
    [self.view addSubview:self.main_scroll];
}

-(void)goBackMethod {

    [self.navigationController popViewControllerAnimated:YES];
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        
        if (errorDic == nil) {
            
            [self asyNetWork];
            
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
}

-(void)asyNetWork {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
        //拼8段
        NSString *spellString = [SpellParameters getBasePostString];
        //加密这个八段
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_baseString = [postEncryption stringWithPost:spellString];
        //post一小下
        NSMutableDictionary *get_serverDic = [[PostData alloc] postData:post_baseString AndUrl:kBX_listUrl];
        
        NSString *errorcode_string = [get_serverDic valueForKey:@"errorcode"];
        
        //11-06
        //11-30-15
        if ([errorcode_string intValue] == 0 && get_serverDic !=nil) {
            NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:get_serverDic];
            NSDictionary *dic = [DDQPublic nullDic:get_jsonDic];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                NSString *title = dic[@"title"];
                CGRect rect = [title boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:25.0f]} context:nil];
                
                NSString *intro_str = dic[@"intro"];
                CGRect intro_rect = [intro_str boundingRectWithSize:CGSizeMake(kScreenWidth-20, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:19.0f]} context:nil];
                
                [self.main_scroll setContentSize:CGSizeMake(kScreenWidth, rect.size.height + 15 + self.view.frame.size.height * 0.3 + 15 + intro_rect.size.height + 10)];
                
                UILabel *title_lable = [[UILabel alloc] initWithFrame:CGRectMake(self.view.center.x - rect.size.width*0.5, 15, rect.size.width, rect.size.height)];
                [self.main_scroll addSubview:title_lable];
                title_lable.textAlignment = NSTextAlignmentCenter;
                title_lable.font = [UIFont systemFontOfSize:24.0f];
                title_lable.text = title;
                title_lable.numberOfLines = 0;
                title_lable.textColor = [UIColor lightGrayColor];

                UIImageView *title_img = [[UIImageView alloc] initWithFrame:CGRectMake(10, 65, kScreenWidth -20, kScreenHeight*0.3)];
                [self.main_scroll addSubview:title_img];
                NSString *img_str = dic[@"img"];
                [title_img sd_setImageWithURL:[NSURL URLWithString:img_str] placeholderImage:[UIImage imageNamed:@"default_pic"]];
             
                UILabel *intro_label = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenHeight*0.3 + 25 + rect.size.height, intro_rect.size.width, intro_rect.size.height)];
                [self.main_scroll addSubview:intro_label];
                
                intro_label.numberOfLines = 0;
                intro_label.text = intro_str;
                intro_label.font = [UIFont systemFontOfSize:18.0f];
                intro_label.textColor = [UIColor lightGrayColor];

            });
            
        } else {
            
          
        }
    });
}

@end
