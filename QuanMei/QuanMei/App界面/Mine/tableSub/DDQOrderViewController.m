//
//  DDQOrderViewController.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/11/10.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQOrderViewController.h"

#import "DDQOrderTableViewCell.h"

//订单详情
#import "DDQOrderDetailViewController.h"

#import "DDQOrderModel.h"
//评价
#import "DDQEvaluateViewController.h"

@interface DDQOrderViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *tableView;
}
@property (nonatomic ,strong)NSMutableArray * orderArray;
@property (nonatomic ,strong)MBProgressHUD *hud;

@end

@implementation DDQOrderViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    self.navigationItem.title = @"我的订单";
    [self creatView];

    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    
    self.hud.labelText = @"加载中...";
}
//12-17
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            [self asyNetWork];
            
        } else {
            
            [self.hud hide:YES];
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
    
}

- (void)creatView
{
    tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:(UITableViewStylePlain)];
    
    tableView.delegate  = self;
    tableView.dataSource = self;
    
    tableView.tableFooterView = [[UIView alloc]initWithFrame:CGRectZero];
    
    [self refresh];
    
    [self.view addSubview:tableView];
}
- (void)refresh
{
    tableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
            
            if (errorDic == nil) {
                [_orderArray removeAllObjects];
                [self asyNetWork];
                [tableView.header endRefreshing];
                
            } else {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
                [tableView.header endRefreshing];
            }
        }];
        
    }];
    
}
static NSString * idenfitier = @"cell";

#pragma  mark - delegate for tableView
- (UITableViewCell *)tableView:(UITableView *)tableView1 cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (_orderArray !=nil && _orderArray.count != 0) {
        DDQOrderTableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:idenfitier];
        
        if (cell ==nil) {
            cell = [[DDQOrderTableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:idenfitier];
            
        }
        //11-30-15
        //12-16
        DDQOrderModel *moedel = _orderArray[indexPath.row];
        
        cell.model = moedel;
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        [cell orderCellCallBackMethod:^{
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                
                NSString *spellString = [SpellParameters getBasePostString];
                
                NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],moedel.orderid];
                
                DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
                NSString *post_String = [postEncryption stringWithPost:post_baseString];
                
                NSMutableDictionary *post_Dic = [[PostData alloc] postData:post_String AndUrl:kOrder_DelUrl];
                
                NSString *errorcode_string = [post_Dic valueForKey:@"errorcode"];
                
                //11-30-15
                dispatch_async(dispatch_get_main_queue(), ^{
                    if ([errorcode_string intValue] == 0 && post_Dic !=nil) {
                    
                        [self alertController:@"删除成功"];
                        [self asyNetWork];
                        
                    } else if([errorcode_string intValue] == 13) {
                    
                        [self alertController:@"您还未登录"];
                    } else if([errorcode_string intValue] == 15){
                    
                        [self alertController:@"您只能删除待支付订单"];
                    } else {
                    
                        [self alertController:@"系统繁忙"];
                    }
                });
            });

        }];
        
        return cell;
    }
    else
    {
        UITableViewCell *cell = [tableView1 dequeueReusableCellWithIdentifier:@"cell"];
        
        return cell;
    }
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _orderArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return kScreenHeight * 0.2f;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDQOrderModel *model = _orderArray[indexPath.row];
    
    
    switch ([model.status intValue]) {
        case 1:
        {
            
            //12-16
            if(![DDQPublic isBlankString:model.tid])
            {
                DDQOrderDetailViewController *orderDetailVC  = [[DDQOrderDetailViewController alloc]init];
                
                orderDetailVC.tel = model.tel;
                orderDetailVC.name = model.name;
                orderDetailVC.dj = model.dj;
                orderDetailVC.tid = model.tid;
                
                orderDetailVC.orderid = model.orderid;
                
                orderDetailVC.price = model.newval;
                
                orderDetailVC.hidesBottomBarWhenPushed  = YES;
                [self.navigationController pushViewController:orderDetailVC animated:YES];
            }
            else
            {
                UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:@"订单有误" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
                UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
                [userNameAlert addAction:actionOne];
                [userNameAlert addAction:actionTwo];
                [self presentViewController:userNameAlert animated:YES completion:nil];            }
            break;
        }
        case 2:
        {
            break;
        }
        case 3:
        {
            //评价
            DDQEvaluateViewController *evaluateVC = [[DDQEvaluateViewController alloc]init];
            evaluateVC.hid = model.hid;
            evaluateVC.orderid = model.orderid;
            
            
            evaluateVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:evaluateVC animated:YES];
            
            break;
        }
        case 4:
        {
            break;
        }
        default:
            break;
    }
}

#pragma mark - netWork
-(void)asyNetWork {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        NSString *spellString = [SpellParameters getBasePostString];
        
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]];
        
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_String = [postEncryption stringWithPost:post_baseString];
        
        NSMutableDictionary *post_Dic = [[PostData alloc] postData:post_String AndUrl:kUserOrderUrl];
        
        NSString *errorcode_string = [post_Dic valueForKey:@"errorcode"];
        //11-30-15
        if ([errorcode_string intValue] == 0 && post_Dic !=nil)
        {
            NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_Dic];
            self.orderArray= [[NSMutableArray alloc]init];
            
            for (NSDictionary *dic in get_jsonDic)
            {
                DDQOrderModel *model =[[DDQOrderModel alloc]init];
                
                //遍历数组里的字典
                model.orderid = dic[@"orderid"];
                model.tid = dic[@"tid"];
                model.simg =dic[@"simg"];
                model.dj = dic[@"dj"];
                model.fname = dic[@"fname"];
                model.name = dic[@"name"];
                model.hname = dic[@"hname"];
                model.status = dic[@"status"];
                model.hid = dic[@"hid"];
                model.intime = dic[@"intime"];
                model.userid = dic[@"userid"];
                model.idString = dic[@"id"];
                model.tel = dic[@"tel"];
                model.newval = dic[@"newval"];
                
                [self.orderArray addObject:model];
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                //12-22
                [self.hud hide:YES];

                if (_orderArray.count ==0) {
                    UILabel *label= [[UILabel alloc]init];
                    
                    label.frame = CGRectMake(0, self.view.frame.size.height/2-20,self.view.frame.size.width, 40);
                    
                    label.text = @"您还没有订单呢....";
                    
                    label.textAlignment = 1;
                    
                    [self.view addSubview:label];
                }
                else
                {
                    [tableView reloadData];
                }
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hide:YES];

            });
        }
    });
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
