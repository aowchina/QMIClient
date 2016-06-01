//
//  DDQGroupViewController.m
//  Full_ beauty
//
//  Created by Min-Fo_003 on 15/8/21.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQGroupViewController.h"
#import "DDQUserDiaryViewController.h"
#import "DDQPreferenceDetailViewController.h"
#import "DDQGroupDetailViewController.h"
#import "DDQLoginViewController.h"
#import "DDQMineViewController.h"
#import "DDQUserCommentViewController.h"
#import "DDQPostingViewController.h"
#import "DDQGroupHeaderViewItem.h"
#import "DDQDiaryViewCell.h"
#import "DDQHotProjectViewCell.h"

#import "DDQGroupHeaderModel.h"
#import "DDQUserInfoModel.h"
#import "DDQHeaderSingleModel.h"
#import "DDQGroupArticleModel.h"

@interface DDQGroupViewController ()<UITableViewDataSource,UITableViewDelegate,UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,MBProgressHUDDelegate>
/**
 *  主要的tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;
/**
 *  headerView
 */
@property (strong,nonatomic) UICollectionView *assistantCollection;


@property (strong,nonatomic) NSString *textString;
/**
 *  post 八段字符串
 */
@property (copy,nonatomic) NSString *spellString;

@property (strong,nonatomic) DDQSingleModel *mySingle;

@property (strong,nonatomic) NSMutableArray *headerModelArray;

@property (strong,nonatomic) NSMutableArray *articleModelArray;

@property (strong,nonatomic) DDQDiaryViewCell *diaryCell;
@property (nonatomic ,strong)MBProgressHUD *hud;

@property (assign,nonatomic) CGFloat rowHeight;

@property (strong,nonatomic) NSDictionary *jsonDic;
@end

@implementation DDQGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.translucent = NO;
    
    //设置bar相关
    [self layoutNavigationBar];
    
    [self initTableView];
    
    _headerModelArray = [NSMutableArray array];
    _articleModelArray = [NSMutableArray array];
    _assistantCollection.scrollEnabled = NO;
    
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    self.hud.labelText = @"加载中...";
    
    [self asyWenzhangNetWork:1 type:1];
    [self asyNetWork];
    
    self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
            
            if (errorDic == nil) {
                [_articleModelArray removeAllObjects];
                [_headerModelArray removeAllObjects];
                [self asyWenzhangNetWork:1 type:1];
                [self asyNetWork];
                [self.mainTableView.header endRefreshing];
                
            } else {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                [self.mainTableView.header endRefreshing];
            }
        }];
        
    }];
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    [self layoutNavigationBar];
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        
        if (errorDic == nil) {
        
//            [self asyWenzhangNetWork:1 type:1];
//            [self asyNetWork];
            
        } else {
            
            [self.hud hide:YES];
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
}

-(void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:YES];
    if (_jsonDic != nil && _jsonDic.count != 0) {
        num = 2;
    }
}


-(void)layoutNavigationBar {
    
    [self.navigationItem setTitle:@"美人圈"];
    
    NSDictionary * dict = @{NSForegroundColorAttributeName:[UIColor titleColor]};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    [self.navigationController.navigationBar setTintColor:[UIColor titleColor]];
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(pushToLoginViewController)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    //拿到单例model
    DDQUserInfoModel *infoModel = [DDQUserInfoModel singleModelByValue];//这是登陆过后的data值
    
    if (infoModel.isLogin == YES) {
        
        if (![infoModel.userimg isEqualToString:@""]&&infoModel.userimg != nil) {//判断用户是否有头像
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:infoModel.userimg] placeholderImage:[UIImage imageNamed:@"default_pic"]];
            imageView.layer.cornerRadius     = 15.0f;
            imageView.contentMode            = UIViewContentModeScaleAspectFit;
            imageView.layer.masksToBounds    = YES;
            //打开用户交互
            imageView.userInteractionEnabled = YES;
            
            //添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToMineViewController)];
            [imageView addGestureRecognizer:tap];
            
            UIBarButtonItem *leftItem             = [[UIBarButtonItem alloc] initWithCustomView:imageView];
            self.navigationItem.leftBarButtonItem = leftItem;
            
            
        } else {
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            
            [imageView setImage:[UIImage imageNamed:@"default_pic"]];
            imageView.layer.cornerRadius     = 15.0f;
            imageView.contentMode            = UIViewContentModeScaleAspectFit;
            imageView.layer.masksToBounds    = YES;
            //打开用户交互
            imageView.userInteractionEnabled = YES;
            
            //添加手势
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToMineViewController)];
            [imageView addGestureRecognizer:tap];
            
            UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithCustomView:imageView];
            self.navigationItem.leftBarButtonItem = leftItem;
        }
        
    } else {
        
        UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithTitle:@"登录" style:UIBarButtonItemStyleDone target:self action:@selector(pushToLoginViewController)];
        //10-19
        //11-06
        leftItem.tintColor        = [UIColor meiHongSe];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
}

#pragma mark - navigationBar item target aciton
-(void)pushToLoginViewController {
    DDQLoginViewController *loginVC = [[DDQLoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:NO];
}

-(void)pushToMineViewController {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"minechange" object:nil userInfo:@{@"mine":@"mine"}];

}

#pragma mark - netWork
-(void)asyNetWork {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
        //拼8段
        NSString *spellString = [SpellParameters getBasePostString];
        //加密这个八段
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_baseString = [postEncryption stringWithPost:spellString];
        //post一小下
        NSMutableDictionary *get_serverDic = [[PostData alloc] postData:post_baseString AndUrl:kGroupListUrl];
        
        NSString *errorcode_string = [get_serverDic valueForKey:@"errorcode"];
        
        //11-06
        //11-30-15
        if ([errorcode_string intValue] == 0 && get_serverDic !=nil) {
            NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:get_serverDic];
                for (NSDictionary *groupDic in get_jsonDic)
                    
                {//遍历数组里的字典
                    
                    DDQGroupHeaderModel *headerModel = [[DDQGroupHeaderModel alloc] init];
                    
                    //首先获得部位图片和名字
                    
                    headerModel.iconUrl = [groupDic valueForKey:@"icon"];
                    
                    headerModel.name    = [groupDic valueForKey:@"name"];
                    
                    //传下一个页面所需的值
                    
                    headerModel.groupId = [groupDic valueForKey:@"id"];
                    
                    
                    [_headerModelArray addObject:headerModel];
                    
                }
                dispatch_async(dispatch_get_main_queue(), ^{
                    //头部刷新
                    [_assistantCollection reloadData];

                });
                
//            }
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.hud hide:YES];

                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            });
        }
    });
}

-(void)asyWenzhangNetWork:(int)page type:(int)type {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) , ^{
        NSString *page_string = [NSString stringWithFormat:@"%d",page];
        
        //拼8段
        NSString *spellString = [SpellParameters getBasePostString];
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@*%@",spellString,[NSString stringWithFormat:@"%d",type],@"0",@"0",page_string];
        //加密这个段数
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_string = [postEncryption stringWithPost:post_baseString];
        //post
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_string AndUrl:kWenzhangUrl];
        
        //11-06
        dispatch_async(dispatch_get_main_queue(), ^{
            NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_dic];
            NSString *errorcode_string = [get_jsonDic valueForKey:@"errorcode"];
            if ([errorcode_string intValue] == 0 && get_jsonDic != nil) {
                
                self.jsonDic = get_jsonDic;
                
                if (get_jsonDic!=nil && get_jsonDic.count != 0) {
                    
                    //12-21
                    for (NSDictionary *dic1 in get_jsonDic) {
                        NSDictionary *dic = [DDQPublic nullDic:dic1];
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
                        [_articleModelArray addObject:articleModel];
                    }
                    [_mainTableView reloadData];
                    [self.mainTableView.header endRefreshing];
                    [self.hud hide:YES];
                } else {
                
                    num = 2;
                    [self.hud hide:YES];

                }
                
            } else {
                [self.mainTableView.header endRefreshing];
                [self.hud hide:YES];
                [self alertController:@"服务器繁忙,请稍后重试"];
            }
            
        });
    });
}

#pragma mark - collectionView and tableView
-(void)initTableView{
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight - 64) style:UITableViewStyleGrouped];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.backgroundColor = [UIColor backgroundColor];

    self.mainTableView.tableHeaderView = [self layoutCollectionView];
}

-(UICollectionView *)layoutCollectionView {
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.assistantCollection = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height*0.4) collectionViewLayout:layout];
    [self.assistantCollection setDelegate:self];
    [self.assistantCollection setDataSource:self];
    
    [self.assistantCollection setBackgroundColor:[UIColor whiteColor]];
    [self.assistantCollection registerClass:[DDQGroupHeaderViewItem class] forCellWithReuseIdentifier:@"cell"];
    [self.view addSubview:self.assistantCollection];
    
    return self.assistantCollection;
}

#pragma mark - delegate and tableView
//tableView
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    if (section == 0) {
    
        return _articleModelArray.count + 1;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *identifier1 = @"diary";
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    
    if (indexPath.row == _articleModelArray.count) {
        UITableViewCell *moreCell= [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"morecell"];
        UILabel *moreLabel = [[UILabel alloc]init];
        
        moreLabel.frame = CGRectMake(kScreenWidth/2-50 ,0, 80, 44);
        moreLabel.text = @"查看更多";
        
        moreLabel.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1];
        [moreCell.contentView addSubview:moreLabel];
        
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(moreLabel.frame.origin.x + moreLabel.frame.size.width , moreLabel.frame.size.height/3 , moreLabel.frame.size.height/3, moreLabel.frame.size.height/3)];
        imageView.image = [UIImage imageNamed:@"puss_load_more"];
        
        [moreCell.contentView addSubview:imageView];
        
        return moreCell;
        
    } else {
        
        DDQGroupArticleModel *articleModel;
        if (self.articleModelArray.count != 0) {
            articleModel = [_articleModelArray objectAtIndex:indexPath.row];
        }
        DDQDiaryViewCell *diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        diaryCell.articleModel      = articleModel;
        self.rowHeight              = diaryCell.newRect.size.height;
        diaryCell.selectionStyle    = UITableViewCellSelectionStyleNone;//取消选中高亮
        diaryCell.backgroundColor   = [UIColor myGrayColor];
        return diaryCell;
    }
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
        if (indexPath.row == _articleModelArray.count) {
            
            return 44;
            
        } else if (self.rowHeight != 0) {
            
            return  self.rowHeight + kScreenHeight*0.25-h;
            
        } else {
            
            DDQGroupArticleModel *model;
            
            if (_articleModelArray.count > 0) {
                
                model = _articleModelArray[indexPath.row];
                
            }
            
            if (model.imgArray.count == 0 ){//不传图的情况
                
                if ([model.introString isEqualToString:@""]) {//不传图还不传字
                    
                    return kScreenHeight *0.25-h;
                    
                } else {//有字，那就是帖子了
                    
                    return kScreenHeight *0.25 + self.rowHeight-h;
                    
                }
                
            } else {//传了图
                
                return self.rowHeight + kScreenHeight *0.5-h;
                
            }
            
        }
        
    } else {
        return kScreenHeight*0.2;
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 30;
    } else {
        return 5;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 1) {
        
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
        [view setBackgroundColor:[UIColor myGrayColor]];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, 200, 20)];
        [label setText:@"相关特惠项目"];
        [label setTextAlignment:NSTextAlignmentLeft];
        [view addSubview:label];
        return view;
        
    } else {
        return nil;
    }
}

static int num = 2;

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    int page = num ++ ;
    //取出model类
    DDQGroupArticleModel *articleModel;
    if (indexPath.row < self.articleModelArray.count) {
        articleModel = [_articleModelArray objectAtIndex:indexPath.row];
    }
    
    //创建单例用来传值
    DDQHeaderSingleModel *headerSingle = [DDQHeaderSingleModel singleModelByValue];
    
    if (indexPath.section == 0) {
        if (indexPath.row == _articleModelArray.count) {
            
            [self asyWenzhangNetWork:page type:1];
            
        } else  {
            DDQUserCommentViewController *commentVC = [[DDQUserCommentViewController alloc] init];
            //赋值
            headerSingle.ctime                      = articleModel.ctime;
            headerSingle.articleId                  = articleModel.articleId;
            headerSingle.userId                     = articleModel.userid;
            commentVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:commentVC animated:YES];
        }
    } else {
        //11-2有问题
        DDQPreferenceDetailViewController *detailVC = [[DDQPreferenceDetailViewController alloc] init];
        detailVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detailVC animated:YES];
    }
}

//collectionView
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.headerModelArray.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDQGroupHeaderViewItem *headerItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    DDQGroupHeaderModel *headerModel = [_headerModelArray objectAtIndex:indexPath.row];
    
    headerItem.headerLabel.text = headerModel.name;
    [headerItem.headerImageView sd_setImageWithURL:[NSURL URLWithString:headerModel.iconUrl] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    return headerItem;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.bounds.size.width*0.25, self.assistantCollection.frame.size.height*0.5);
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DDQGroupDetailViewController *detailVC = [[DDQGroupDetailViewController alloc] init];
    DDQGroupHeaderModel *headerModel = [_headerModelArray objectAtIndex:indexPath.row];//取出model类
    
    //将数据传递到下一个页面
    DDQHeaderSingleModel *header_single = [DDQHeaderSingleModel singleModelByValue];
    header_single.groupId = headerModel.groupId;
    header_single.introString = headerModel.introString;
    header_single.iconUrl = headerModel.iconUrl;
    header_single.name = headerModel.name;
    header_single.tagId = headerModel.tagId;
    detailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:detailVC animated:YES];
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

