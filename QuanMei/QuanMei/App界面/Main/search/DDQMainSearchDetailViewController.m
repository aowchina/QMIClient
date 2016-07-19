//
//  DDQMainSearchDetailViewController.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/11/9.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQMainSearchDetailViewController.h"

#import "DDQDiaryViewCell.h"

#import "DDQUserCommentViewController.h"

#import "DDQHeaderSingleModel.h"

#import "Header.h"
#import "ProjectNetWork.h"

@interface DDQMainSearchDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mainTableView;
}
@property (nonatomic, strong) NSMutableArray *wenzhangArray;//数据

@property (nonatomic, assign) CGFloat rowHeight;

@property (nonatomic, strong) MBProgressHUD *hud;

@property (nonatomic, strong) ProjectNetWork *netWork;

@end

@implementation DDQMainSearchDetailViewController

- (NSMutableArray *)wenzhangArray
{
    if (!_wenzhangArray) {
        _wenzhangArray = [[NSMutableArray alloc]init];
    }
    return _wenzhangArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    _wenzhangArray = [[NSMutableArray alloc]init];

    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.detailsLabelText = @"请稍等...";
    
    //title 颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor meiHongSe]};
    
    //返回颜色
    self.navigationController.navigationBar.tintColor = [UIColor meiHongSe];
    
    self.netWork = [ProjectNetWork sharedWork];
    
    [self asyncListForSearchWenzhang];
    
}

- (void)asyncListForSearchWenzhang {
    
    if (_searchWenzhangText != nil || ![_searchWenzhangText isEqualToString:@""]) {
        
        [self.hud show:YES];

        NSData *data1 = [_searchWenzhangText dataUsingEncoding:NSUTF8StringEncoding];
        Byte *byteArray1 = (Byte *)[data1 bytes];
        NSMutableString *searchtext = [[NSMutableString alloc] init];
        
        for(int i=0;i<[data1 length];i++) {
            [searchtext appendFormat:@"%d#",byteArray1[i]];
        }
        
        [self.netWork asyPOSTWithAFN_url:kSearchWenzhangUrl andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],searchtext,_type,@"1"] andSuccess:^(id responseObjc, NSError *code_error) {
            
            if (code_error) {
                
                [self.hud hide:YES];
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            } else {
            
                for (NSDictionary *dic1 in responseObjc) {
                    
                    NSDictionary * dic = [DDQPublic nullDic:dic1];
                    
                    DDQGroupArticleModel *articleModel = [[DDQGroupArticleModel alloc] init];
                    //精或热
                    articleModel.articleType   = [NSString stringWithFormat:@"%@",[dic valueForKey:@"type"]];
                    articleModel.isJing        = [NSString stringWithFormat:@"%@",[dic valueForKey:@"isjing"]];
                    articleModel.articleTitle  = [dic valueForKey:@"title"];
                    articleModel.groupName     = [dic valueForKey:@"groupname"];
                    articleModel.userHeaderImg = [dic valueForKey:@"userimg"];
                    articleModel.userName      = [dic valueForKey:@"username"];
                    articleModel.userid        = [NSString stringWithFormat:@"%@",[dic valueForKey:@"userid"]];
                    articleModel.plTime        = [dic valueForKey:@"pubtime"];
                    articleModel.thumbNum      = [NSString stringWithFormat:@"%@",[dic valueForKey:@"zan"]];
                    articleModel.replyNum      = [NSString stringWithFormat:@"%@",[dic valueForKey:@"pl"]];
                    articleModel.articleId     = [NSString stringWithFormat:@"%@",[dic valueForKey:@"id"]];
                    articleModel.introString   = [dic valueForKey:@"text"];
                    articleModel.imgArray      = [dic valueForKey:@"imgs"];
                    articleModel.ctime         = [NSString stringWithFormat:@"%@",[dic valueForKey:@"ctime"]];
                    
                    [_wenzhangArray addObject:articleModel];
                    
                }
                
                [self.hud hide:YES];
                [self creatViewSearchDetail];

            }
            
        } andFailure:^(NSError *error) {
            
            [self.hud hide:YES];
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        }];
        
    } else {
        
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"请输入搜索内容" andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }
    
}

- (void)creatViewSearchDetail {
    
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,  kScreenWidth,  kScreenHeight-64 ) style:(UITableViewStylePlain)];
    
    mainTableView.delegate = self;
    
    mainTableView.dataSource = self;
    
    mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:mainTableView];
    
}

#pragma mark  - delegate for tableview
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDQGroupArticleModel *articleModel = [_wenzhangArray objectAtIndex:indexPath.row];
    
    DDQDiaryViewCell *diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    diaryCell.articleModel      = articleModel;
    
    self.rowHeight              = diaryCell.newRect.size.height;
    
    diaryCell.selectionStyle    = UITableViewCellSelectionStyleNone;//取消选中高亮
    
    diaryCell.backgroundColor   = [UIColor myGrayColor];
    
    return diaryCell;
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    return _wenzhangArray.count;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat h;
    if (kScreenHeight <= 568) {
        
        h = 20;
        
    } else if (kScreenHeight == 667) {
        
        h = 30;
        
    } else {
        
        h = 40;
        
    }
    
    if (indexPath.section == 0) {
        
        if (indexPath.row == _wenzhangArray.count) {
            
            return 44;
            
        } else if (self.rowHeight != 0) {
            
            return  self.rowHeight + kScreenHeight*0.25-h;
            
        } else {
            
            DDQGroupArticleModel *model;
            
            if (_wenzhangArray.count > 0) {
                
                model = _wenzhangArray[indexPath.row];
                
            }
            
            if (model.imgArray.count == 0 ){//不传图的情况
                
                if ([model.introString isEqualToString:@""]) {//不传图还不传字
                    
                    return kScreenHeight *0.25 - h;
                    
                } else {//有字，那就是帖子了
                    
                    return kScreenHeight *0.25 + self.rowHeight - h;
                    
                }
                
            } else {//传了图
                
                return self.rowHeight + kScreenHeight *0.5-h;
                
            }
            
        }
        
    } else {
        
        return kScreenHeight*0.2;
        
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDQGroupArticleModel * articleModel = _wenzhangArray[indexPath.row];
    
    DDQUserCommentViewController *commentVC = [[DDQUserCommentViewController alloc] init];
    //赋值
    commentVC.ctime                      = articleModel.ctime;
    commentVC.articleId                  = articleModel.articleId;
    commentVC.userid                     = articleModel.userid;
    commentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentVC animated:YES];
    
}


@end
