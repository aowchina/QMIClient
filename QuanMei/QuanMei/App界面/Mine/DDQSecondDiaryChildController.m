//
//  DDQSecondDiaryChildController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/7.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQSecondDiaryChildController.h"
#import "DDQMyCommentChildCell.h"

#import "ProjectNetWork.h"
#import "MJExtension.h"

@interface DDQSecondDiaryChildController ()<UITableViewDelegate,UITableViewDataSource,MyCommentChildCellDelegate>
/**
 *  主tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;
/**
 *  接受cell的新的高度
 */
@property (assign, nonatomic) CGFloat new_cellHeight;

@property (strong, nonatomic) NSMutableArray *chileModelArray;

@property (copy, nonatomic) NSString *hf_id;

@property (strong, nonatomic) ProjectNetWork *netWork;
/** 页码 */
@property (assign, nonatomic) int page;
/** hud */
@property (strong, nonatomic) MBProgressHUD *hud;

@end

@implementation DDQSecondDiaryChildController

//static int num = 2;
- (MBProgressHUD *)hud {
    
    if (!_hud) {
        
        _hud = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:_hud];
        _hud.detailsLabelText = @"请稍等...";
        
    }
    
    return _hud;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    [self initMainTabelView];
    self.chileModelArray = [NSMutableArray array];
    
    self.netWork = [ProjectNetWork sharedWork];
    
    self.page = 1;

    [self requestDataWith:1 url:kMyreply];
    
    self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        [self.chileModelArray removeAllObjects];
        [self requestDataWith:self.page url:kMyreply];
        [self.mainTableView.header endRefreshing];

    }];
    
    self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page = self.page + 1;
        [self requestDataWith:self.page url:kMyreply];
        [self.mainTableView.footer endRefreshing];

    }];
    
        
}

-(void)initMainTabelView {
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-111) style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.mainTableView.backgroundColor = [UIColor backgroundColor];
    self.mainTableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
}

#pragma mark - delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return self.chileModelArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.new_cellHeight + 5;
}

static NSString *identifier = @"cell1";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDQMyCommentChildCell *childCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    DDQMyCommentChildModel *childModel;
    if (self.chileModelArray.count != 0) {
        
        childModel = self.chileModelArray[indexPath.row];
        
    }
    
//    if (childCell == nil) {
    
    childCell = [[DDQMyCommentChildCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];

//    }
    
    childCell.commentChildModel = childModel;
    
    self.new_cellHeight         = childCell.cell_height;
    
    childCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    childCell.delegate = self;
    
    return childCell;
    
}

-(void)myCommentCellDelegateWithTapMethodAndWenzhangId:(NSString *)iD {
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"提示" message:@"确认删除" preferredStyle:0];
    
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self.hud show:YES];
        
        [self.netWork asyPOSTWithAFN_url:kDel_hfUrl andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"], iD] andSuccess:^(id responseObjc, NSError *code_error) {
            
            [self.view bringSubviewToFront:self.hud];

            [self.hud hide:YES];
            
            if (code_error) {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            } else {
            
                [self.chileModelArray removeAllObjects];
                [self requestDataWith:1 url:kMyreply];
                
            }
            
        } andFailure:^(NSError *error) {
            
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        }];
        
    }];
    
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        [self dismissViewControllerAnimated:YES completion:nil];
        
    }];
    [alertController addAction:actionOne];
    [alertController addAction:actionTwo];
    [self presentViewController:alertController animated:YES completion:nil];
    
}

- (void)requestDataWith:(NSInteger )page url:(NSString *)url{
    
    [self.view bringSubviewToFront:self.hud];
    [self.hud show:YES];
    
    [self.netWork asyPOSTWithAFN_url:url andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"], @(page).stringValue] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (code_error) {
            
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        } else {
        
            for (NSDictionary *dic in responseObjc) {
                
                DDQMyCommentChildModel *childeModel = [DDQMyCommentChildModel mj_objectWithKeyValues:dic];
                [self.chileModelArray addObject:childeModel];
                
            }
            
            if (self.chileModelArray.count == 0 && [responseObjc count] == 0) {
                
                UIImageView *temp_img = [[UIImageView alloc] init];
                [self.view addSubview:temp_img];
                [temp_img mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(self.view.mas_centerX);
                    make.centerY.equalTo(self.view.mas_centerY);
                    make.width.offset(70);
                    make.height.offset(70);
                }];
                temp_img.image = [UIImage imageNamed:@"default_pic"];
                
                UILabel *tip_onelabel = [[UILabel alloc] init];
                [self.view addSubview:tip_onelabel];
                [tip_onelabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(temp_img.mas_bottom).offset(10);
                    make.centerX.equalTo(temp_img.mas_centerX);
                    make.height.offset(20);
                }];
                tip_onelabel.text = @"暂无回复";
                tip_onelabel.textAlignment = NSTextAlignmentCenter;
                tip_onelabel.font = [UIFont systemFontOfSize:16.0f];
                
                UILabel *tip_twolabel = [[UILabel alloc] init];
                [self.view addSubview:tip_twolabel];
                [tip_twolabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.top.equalTo(tip_onelabel.mas_bottom).offset(10);
                    make.centerX.equalTo(tip_onelabel.mas_centerX);
                    make.height.offset(15);
                }];
                tip_twolabel.text = @"快去回复别人吧";
                tip_twolabel.textAlignment = NSTextAlignmentCenter;
                tip_twolabel.font = [UIFont systemFontOfSize:13.0f];
            
            }
            
            [self.mainTableView reloadData];

            [self.hud hide:YES];
            
            if ([responseObjc count] == 0) {
                
                self.mainTableView.footer.state = MJRefreshStateNoMoreData;
                
            } else {
            
                self.mainTableView.footer.state = MJRefreshStateIdle;
                
            }
            
        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:nil andSetDelay:YES andCustomView:nil];
        
    }];
    
}

-(void)alertController:(NSString *)message {
    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [userNameAlert addAction:actionOne];
    [userNameAlert addAction:actionTwo];
    [self presentViewController:userNameAlert animated:YES completion:nil];
}

@end
