//
//  DDQEvaluateViewController.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/11/10.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQEvaluateViewController.h"
#import "StarsView.h"
#import "DDQBaseViewController.h"

@interface DDQEvaluateViewController ()<UITextViewDelegate,StarsDelegate>
{
    UIImageView * tempImageView;
    NSString * huaString;
}
@property (nonatomic ,strong)UITextView *textView;

@property (nonatomic ,strong)UILabel *alabel;

//xing
@property (nonatomic, strong) StarsView *effectStarsView1;
@property (nonatomic, strong) StarsView *effectStarsView2;
@property (nonatomic, strong) StarsView *effectStarsView3;

@property ( strong, nonatomic) NSString *star_str1;
@property ( strong, nonatomic) NSString *star_str2;
@property ( strong, nonatomic) NSString *star_str3;

@end

@implementation DDQEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"医院评价";

    [self creatViewForEvaluate];
    
    self.star_str1 = @"5";
    self.star_str2 = @"5";
    self.star_str3 = @"5";

}

- (void)creatViewForEvaluate
{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight/2-64)];
    
    headerView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:headerView];
    
    
    _textView = [[UITextView alloc]initWithFrame:CGRectMake(10, 0, kScreenWidth-20, headerView.frame.size.height-40)];
    
    _textView.delegate =self;
    
    
    [headerView addSubview:_textView];
    
    
    _alabel = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, headerView.frame.size.width-10, 30)];
    
    _alabel.text = @"请输入帖子内容";
    
    _alabel.font = [UIFont systemFontOfSize:14];
    
    _alabel.textColor = [UIColor colorWithRed:147.0/255 green:147.0/255  blue:147.0/255  alpha:0.4f];
    
    _alabel.enabled = NO;
    
    _alabel.backgroundColor = [UIColor clearColor];
    
    [headerView addSubview:_alabel];
    
    UIView *lineview1 = [[UIView alloc]initWithFrame:CGRectMake(0   ,
                                                               _textView.frame.origin.y + _textView.frame.size.height,
                                                                kScreenWidth, 2)];
    lineview1.backgroundColor = [UIColor backgroundColor];
    
    [headerView addSubview:lineview1];
    
    //评价类型
    UIView * evalView = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               lineview1.frame.origin.y +lineview1.frame.size.height,
                                                                kScreenWidth, headerView.frame.size.height - (lineview1.frame.origin.y +lineview1.frame.size.height))];
    
    
    [headerView addSubview:evalView];
    
    //12-08
    //好中差
    UIImageView *goodImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth/3, evalView.frame.size.height)];
    
    goodImageView.userInteractionEnabled = YES;
    
    goodImageView.image = [UIImage imageNamed:@"好评"];
    
    goodImageView.contentMode = UIViewContentModeCenter;
    
    goodImageView.tag = 1;
    
    [evalView addSubview:goodImageView];
    
    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(evalViewImageClicked:)];

    [goodImageView addGestureRecognizer:tap1];
    
    //
    UIImageView *mindImageView = [[UIImageView alloc]initWithFrame:CGRectMake( kScreenWidth/3, 0, kScreenWidth/3, evalView.frame.size.height)];
    
    mindImageView.userInteractionEnabled = YES;

    mindImageView.tag =2;
    
    mindImageView.image = [UIImage imageNamed:@"中评"];
    
    mindImageView.contentMode = UIViewContentModeCenter;
    
    [evalView addSubview:mindImageView];
    
    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(evalViewImageClicked:)];
    [mindImageView addGestureRecognizer:tap2];
    
    //
    UIImageView *badImageView = [[UIImageView alloc]initWithFrame:CGRectMake(kScreenWidth/3*2, 0 , kScreenWidth/3, evalView.frame.size.height)];
    
    badImageView.userInteractionEnabled = YES;

    badImageView.tag = 3;
    
    badImageView.image = [UIImage imageNamed:@"差评"];
    
    badImageView.contentMode = UIViewContentModeCenter;
    
    [evalView addSubview:badImageView];
    
    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(evalViewImageClicked:)];
    [badImageView addGestureRecognizer:tap3];
    //好中差
    
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               headerView.frame.origin.y +headerView.frame.size.height,
                                                               kScreenWidth,
                                                                5)];
    lineView2.backgroundColor = [UIColor backgroundColor];
    
    [self.view addSubview:lineView2];
    ///////header//////
    
    ////foot
    UIView *footView = [[UIView alloc]initWithFrame:CGRectMake(0 , lineView2.frame.size.height +lineView2.frame.origin.y, kScreenWidth, kScreenHeight - headerView.frame.size.height-lineView2.frame.size.height-64)];
    
    //11-30-17
    footView.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:footView];
    
    //星星
    UIView *fenshuView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kScreenHeight, footView.frame.size.height/3*2)];
    
    fenshuView.backgroundColor  = [UIColor backgroundColor];
    
    [footView addSubview:fenshuView];
    
    CGFloat fenshuViewHeight =fenshuView.frame.size.height;
    
    //星级评分
    UILabel * xingxingTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth/3, fenshuViewHeight/4)];
    
    xingxingTitleLabel.text = @"星级评分";
    
    xingxingTitleLabel.textAlignment = 1;
    
    xingxingTitleLabel.font = [UIFont systemFontOfSize:17];
    
    [fenshuView addSubview:xingxingTitleLabel];
    
    
    //审美
    UILabel * shenmeiLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, fenshuViewHeight/4, kScreenWidth/3, fenshuViewHeight/4)];
    
    shenmeiLabel.text = @"审美";
    
    shenmeiLabel.textAlignment = 1;
    
    shenmeiLabel.font = [UIFont systemFontOfSize:15];
    
    [fenshuView addSubview:shenmeiLabel];
//    self.effectStarsView1 = [[StarsView alloc] initWithStarSize:CGSizeMake(20, 20) space:10 numberOfStar:5];
    self.effectStarsView1 = [[StarsView alloc] initWithFrame:CGRectMake(shenmeiLabel.frame.origin.x +shenmeiLabel.frame.size.width,
                                                                        shenmeiLabel.frame.origin.y,
                                                                        kScreenWidth/3*2,
                                                                        shenmeiLabel.frame.size.height)];
    [self.effectStarsView1 setStarSize:CGSizeMake(20, 20) space:10 numberOfStar:5];
//    self.effectStarsView1.frame = CGRectMake(shenmeiLabel.frame.origin.x +shenmeiLabel.frame.size.width,
//                                            shenmeiLabel.frame.origin.y,
//                                            kScreenWidth/3*2,
//                                            shenmeiLabel.frame.size.height);
//    
    [fenshuView addSubview:self.effectStarsView1];

    //环境
    UILabel * huanjingTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, fenshuViewHeight/2, kScreenWidth/3, fenshuViewHeight/4)];
    
    huanjingTitleLabel.text = @"环境";
    
    huanjingTitleLabel.textAlignment = 1;
    
    huanjingTitleLabel.font = [UIFont systemFontOfSize:15];
    
    [fenshuView addSubview:huanjingTitleLabel];
    
    self.effectStarsView2 = [[StarsView alloc] initWithFrame:CGRectMake(huanjingTitleLabel.frame.origin.x +huanjingTitleLabel.frame.size.width,
                                                                        huanjingTitleLabel.frame.origin.y,
                                                                        kScreenWidth/3*2,
                                                                        huanjingTitleLabel.frame.size.height)];
    [self.effectStarsView2 setStarSize:CGSizeMake(20, 20) space:10 numberOfStar:5];
    
//    self.effectStarsView2 = [[StarsView alloc] initWithStarSize:CGSizeMake(20, 20) space:10 numberOfStar:5];
//    
//    self.effectStarsView2.frame = CGRectMake(huanjingTitleLabel.frame.origin.x +huanjingTitleLabel.frame.size.width,
//                                            huanjingTitleLabel.frame.origin.y,
//                                            kScreenWidth/3*2,
//                                            huanjingTitleLabel.frame.size.height);
//
    [fenshuView addSubview:self.effectStarsView2];

    //服务
    UILabel * fuwuTitleLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, fenshuViewHeight/4*3, kScreenWidth/3, fenshuViewHeight/4)];
    
    fuwuTitleLabel.text = @"服务";
    
    fuwuTitleLabel.textAlignment = 1;
    
    fuwuTitleLabel.font = [UIFont systemFontOfSize:15];
    
    [fenshuView addSubview:fuwuTitleLabel];
//    self.effectStarsView3 = [[StarsView alloc] initWithStarSize:CGSizeMake(20, 20) space:10 numberOfStar:5];
//    
//    self.effectStarsView3.frame = CGRectMake(fuwuTitleLabel.frame.origin.x +fuwuTitleLabel.frame.size.width,
//                                            fuwuTitleLabel.frame.origin.y,
//                                            kScreenWidth/3*2,
//                                            fuwuTitleLabel.frame.size.height);
    self.effectStarsView3 = [[StarsView alloc] initWithFrame:CGRectMake(fuwuTitleLabel.frame.origin.x +fuwuTitleLabel.frame.size.width,
                                                                        fuwuTitleLabel.frame.origin.y,
                                                                        kScreenWidth/3*2,
                                                                        fuwuTitleLabel.frame.size.height)];
    [self.effectStarsView3 setStarSize:CGSizeMake(20, 20) space:10 numberOfStar:5];

    [fenshuView addSubview:self.effectStarsView3];
//    [self.effectStarsView3 mas_makeConstraints:^(MASConstraintMaker *make) {
//        
//        make.centerY.equalTo(fuwuTitleLabel.mas_centerY);
//        make.left.equalTo(fuwuTitleLabel.mas_right);
//        make.height.equalTo(fuwuTitleLabel.mas_height);
//        make.right.equalTo(fenshuView.mas_right).offset(-10);
//        
//    }];

    //星星
    
    
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0,
                                                               fenshuView.frame.size.height +fenshuView.frame.origin.y,
                                                               kScreenHeight,
                                                                5)];
    lineView3.backgroundColor = [UIColor backgroundColor];
    [footView addSubview:lineView3];
    
    //提交
    UIButton *button = [UIButton buttonWithType:(UIButtonTypeSystem)];

    button.frame= CGRectMake(kScreenWidth/3*2-20, lineView3.frame.origin.y + 15, kScreenWidth/3, 30);
    
    [button setTitle:@"发表评价" forState:(UIControlStateNormal)];
    
    [button addTarget:self action:@selector(buttonClicked) forControlEvents:(UIControlEventTouchUpInside)];
    
    [button setTitleColor:[UIColor whiteColor] forState:(UIControlStateNormal)];
    
    button.backgroundColor = [UIColor meiHongSe];
    
    button.layer.cornerRadius = 3.0;
    button.layer.masksToBounds = YES;
    
    [footView addSubview:button];
    self.effectStarsView1.delegate = self;
    self.effectStarsView2.delegate = self;
    self.effectStarsView3.delegate = self;
}

//12-08
//选择评价等级
- (void)evalViewImageClicked:(id)sender
{
    UITapGestureRecognizer * tap = (UITapGestureRecognizer * )sender;
    
    UIImageView *img = (UIImageView *) [self.view viewWithTag:[tap view].tag];
    if (img.tag != tempImageView.tag) {
        switch ([tap view].tag) {
            case 1:
            {
                switch (tempImageView.tag) {
                    case 1:
                    {
                        tempImageView.image = [UIImage imageNamed:@"好评"];
                        
                        break;
                    }
                    case 2:
                    {
                        tempImageView.image = [UIImage imageNamed:@"中评"];
                        
                        break;
                    }
                    case 3:
                    {
                        tempImageView.image = [UIImage imageNamed:@"差评"];
                        
                        break;
                    }
                    default:
                        break;
                }
                
                huaString = @"3";
                img.image= [UIImage imageNamed:@"已选中好评"];
                tempImageView = img;
                
                break;
            }
            case 2:
            {
                switch (tempImageView.tag) {
                    case 1:
                    {
                        tempImageView.image = [UIImage imageNamed:@"好评"];
                        
                        break;
                    }
                    case 2:
                    {
                        tempImageView.image = [UIImage imageNamed:@"中评"];
                        
                        break;
                    }
                    case 3:
                    {
                        tempImageView.image = [UIImage imageNamed:@"差评"];
                        
                        break;
                    }
                    default:
                        break;
                }
                
                huaString = @"2";
                img.image= [UIImage imageNamed:@"已选中中评"];
                tempImageView = img;
                break;
            }
            case 3:
            {
                switch (tempImageView.tag) {
                    case 1:
                    {
                        tempImageView.image = [UIImage imageNamed:@"好评"];
                        
                        break;
                    }
                    case 2:
                    {
                        tempImageView.image = [UIImage imageNamed:@"中评"];
                        
                        break;
                    }
                    case 3:
                    {
                        tempImageView.image = [UIImage imageNamed:@"差评"];
                        
                        break;
                    }
                    default:
                        break;
                }
                huaString = @"1";
                img.image= [UIImage imageNamed:@"已选中差评"];
                tempImageView = img;
                break;
            }
                
            default:
                break;
        }
    }
    
}
- (void)buttonClicked
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (![DDQPublic isBlankString:_textView.text]) {
            
            //标题
            NSData *data2 = [_textView.text dataUsingEncoding:NSUTF8StringEncoding];
            Byte *byteArray2 = (Byte *)[data2 bytes];
            NSMutableString *titleString = [[NSMutableString alloc] init];
            for(int i=0;i<[data2 length];i++) {
                [titleString appendFormat:@"%d#",byteArray2[i]];
            }
            
            if (huaString != nil) {
                
                //八段
                NSString *spellString = [SpellParameters getBasePostString];
                
                //拼参数
                NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@*%@*%@*%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],_orderid,_hid,huaString,self.star_str1,self.star_str2,self.star_str3,titleString];
                
                //加密
                DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
                NSString *post_encryption = [post stringWithPost:post_baseString];
                //传
                NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kOrderPjUrl];

                if ([[post_dic objectForKey:@"errorcode"] intValue]==0) {
                    
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        
                        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"上传成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                        [alertView show];
                        [[NSNotificationCenter defaultCenter] postNotificationName:kFreshOrderCNotification object:nil];
                        
                        [self.navigationController popViewControllerAnimated:YES];

                        
                    });
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        
                        if ([post_dic[@"errorcode"] intValue] == 20) {
                            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"订单已不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        } else {
                            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器繁忙" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                            [alertView show];
                        }

                    });
                }
            }
            else
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请选择好中差评" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    
                });
            }
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请填写评价内容" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
                
            });

        }
    });

}

#pragma mark - 回收键盘
- (void)textViewDidBeginEditing:(UITextView *)textView
{
    UIBarButtonItem *done =  [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(leaveEditMode)];
    self.navigationItem.rightBarButtonItem = done;
    [_alabel removeFromSuperview];
}
- (void)textViewDidEndEditing:(UITextView *)textView {
    
    self.navigationItem.rightBarButtonItem = nil;
}
- (void)leaveEditMode {
    [_textView resignFirstResponder];
}

//占位符
- (void)textViewDidChange:(UITextView *)textView
{
    if (textView.text.length ==0) {
        _alabel.text = @"请输入帖子内容";
    }
    else
    {
        _alabel.text = @"";
    }
}


- (void)stars_viewCount:(NSInteger)cout View:(StarsView *)view {

    if (view == self.effectStarsView1) {
        self.star_str1 = [NSString stringWithFormat:@"%ld",cout+1];
    }
    if (view == self.effectStarsView2) {
        self.star_str2 = [NSString stringWithFormat:@"%ld",cout+1];
    }
    if (view == self.effectStarsView3) {
        self.star_str3 = [NSString stringWithFormat:@"%ld",cout+1];
    }
}

@end
