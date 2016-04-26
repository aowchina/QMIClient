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

@interface DDQMainSearchDetailViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    UITableView *mainTableView;
}
@property (nonatomic ,strong)NSMutableArray * wenzhangArray;//数据

@property (nonatomic ,assign)CGFloat  rowHeight;

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
//    [self asyncListForSearchWenzhang];
    
//    [self creatViewSearchDetail];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    //背景
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"bar"] forBarMetrics:UIBarMetricsDefault];
    
    //不透明
    self.navigationController.navigationBar.translucent = NO;
    
    //title 颜色
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    
    //返回颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    
    [self asyncListForSearchWenzhang];

}

- (void)asyncListForSearchWenzhang
{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //
        NSData *data1 = [_searchWenzhangText dataUsingEncoding:NSUTF8StringEncoding];
        Byte *byteArray1 = (Byte *)[data1 bytes];
        NSMutableString *searchtext = [[NSMutableString alloc] init];
        
        for(int i=0;i<[data1 length];i++) {
            [searchtext appendFormat:@"%d#",byteArray1[i]];
        }
        
        
        //请求特惠列表
        NSString *spellString = [SpellParameters getBasePostString];
        
        //加密
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],searchtext,_type,@"1"];
        
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_String = [postEncryption stringWithPost:post_baseString];
        
        
        //接受字典
        NSMutableDictionary *get_postDic = [[PostData alloc] postData:post_String AndUrl:kSearchWenzhangUrl];
        
        NSDictionary * get_JsonDic = [DDQPOSTEncryption judgePOSTDic:get_postDic];
        
        
        //10-19
        //10-30
        if (![get_JsonDic isKindOfClass:[NSNull class]]) {
            //12-21
            for (NSDictionary *dic1 in get_JsonDic) {
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
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self creatViewSearchDetail];
//            [tableView reloadData];
        });
    });
}

- (void)creatViewSearchDetail
{
    mainTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0,  kScreenWidth,  kScreenHeight-64 ) style:(UITableViewStylePlain)];
    
    mainTableView.delegate = self;
    
    mainTableView.dataSource = self;
    
    
    [self.view addSubview:mainTableView];
}
#pragma mark  - delegate for tableview

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDQGroupArticleModel *articleModel = [_wenzhangArray objectAtIndex:indexPath.row];
    
    DDQDiaryViewCell *diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    diaryCell.articleModel      = articleModel;
    
    self.rowHeight              = diaryCell.newRect.size.height;
    
    diaryCell.selectionStyle    = UITableViewCellSelectionStyleNone;//取消选中高亮
    
    diaryCell.backgroundColor   = [UIColor myGrayColor];
    
    return diaryCell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _wenzhangArray.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.rowHeight != 0)
    {
        return  self.rowHeight + kScreenHeight*0.25;
        
    }
    else
    {
        return kScreenHeight * 0.5;
    }
   
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDQGroupArticleModel * articleModel = _wenzhangArray[indexPath.row];
    //创建单例用来传值
    DDQHeaderSingleModel *headerSingle = [DDQHeaderSingleModel singleModelByValue];

    DDQUserCommentViewController *commentVC = [[DDQUserCommentViewController alloc] init];
    //赋值
    headerSingle.ctime                      = articleModel.ctime;
    headerSingle.articleId                  = articleModel.articleId;
    headerSingle.userId                     = articleModel.userid;
    commentVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:commentVC animated:YES];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
