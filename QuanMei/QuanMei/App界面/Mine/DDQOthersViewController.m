//
//  DDQOthersViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/9.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQOthersViewController.h"
#import "DDQUserCommentViewController.h"
#import "DDQOthersTableViewCell.h"
#import "DDQOthersCommentCell.h"
#import "DDQDiaryViewCell.h"
#import "DDQMyCommentCell.h"
#import "DDQMineInfoModel.h"
#import "DDQOthersModel.h"
#import "DDQOthersCommentModel.h"
#import "DDQGroupArticleModel.h"
#import "DDQHeaderSingleModel.h"
@interface DDQOthersViewController () <UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *mainTableView;
/**
 *  接下来都是头视图所需的控件
 */
@property (strong,nonatomic) UIImageView *backgroundImageView;
@property (strong,nonatomic) UIImageView *userImageView;
@property (strong,nonatomic) UILabel *userName;
@property (strong,nonatomic) UIView *userMessage;
@property (strong,nonatomic) UILabel *userLV;

/**
 *  cell新高度
 */
@property (assign,nonatomic) CGFloat group_height;
@property (assign,nonatomic) CGFloat diary_height;
@property (assign,nonatomic) CGFloat comment_height;

@property (strong,nonatomic) DDQMineInfoModel *userInfo;
@property (strong,nonatomic) NSMutableArray *personalDiary_array;
@property (strong,nonatomic) NSMutableArray *personalComment_array;

@end

@implementation DDQOthersViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"个人主页";

    [self initTableView];
    [self asyPersonalPageNetWork];
    [self asyPersonalDiaryNetWotkWithPage:1];
    [self asyPersonalCommentNetWorkWithPage:1];
    
    self.personalDiary_array = [NSMutableArray array];
    self.personalComment_array = [NSMutableArray array];
    
    self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
            
            if (errorDic == nil) {
                [self.personalComment_array removeAllObjects];
                [self.personalDiary_array removeAllObjects];
                [self asyPersonalPageNetWork];
                [self asyPersonalCommentNetWorkWithPage:1];
                [self asyPersonalDiaryNetWotkWithPage:1];
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
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        
        if (errorDic == nil) {
            
            
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
}

static int commentPage = 2;

-(void)asyPersonalCommentNetWorkWithPage:(int)page {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //八段
        NSString *spellString = [SpellParameters getBasePostString];
        NSInteger type = 2;
        //拼参数
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%lu*%d",spellString,self.others_userid,type,page];
        
        //加密
        DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
        NSString *post_encryption = [post stringWithPost:post_baseString];
        
        //传
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kMyDiaryUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            //判断errorcode
            NSString *errorcode = post_dic[@"errorcode"];
            int num = [errorcode intValue];
            if (num == 0) {
                NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_dic];
                
                for (NSDictionary *dic in get_jsonDic) {
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
                    [self.personalComment_array addObject:articleModel];
                }
                if (get_jsonDic.count == 0) {
                    
                    [self alertController:@"暂无更多数据"];
                    [self.mainTableView.header endRefreshing];
                    
                } else {
                    
                    [self.mainTableView reloadData];
                    [self.mainTableView.header endRefreshing];
                }
                
            }else {
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"服务器繁忙" andShowDim:NO andSetDelay:YES andCustomView:nil];
            }
            
            
        });
    });

}

static int diaryPage = 2;
-(void)asyPersonalDiaryNetWotkWithPage:(int)page {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //八段
        NSString *spellString = [SpellParameters getBasePostString];
        NSInteger type = 1;
        //拼参数
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%lu*%d",spellString,self.others_userid,type,page];
        
        //加密
        DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
        NSString *post_encryption = [post stringWithPost:post_baseString];
        
        //传
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kMyDiaryUrl];
        dispatch_async(dispatch_get_main_queue(), ^{
            //判断errorcode
            NSString *errorcode = post_dic[@"errorcode"];
            int num = [errorcode intValue];
            if (num == 0) {
                NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_dic];
                
                for (NSDictionary *dic in get_jsonDic) {
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
                    [self.personalDiary_array addObject:articleModel];
                }
                if (get_jsonDic.count == 0) {
                    
                    [self alertController:@"暂无更多数据"];
                    
                } else {
                    
                    [self.mainTableView reloadData];
                    [self.mainTableView.header endRefreshing];
                }
                
            }else {
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"服务器繁忙" andShowDim:NO andSetDelay:YES andCustomView:nil];
            }
            
            
        });
    });
}


-(void)asyPersonalPageNetWork {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        //八段
        NSString *spellString = [SpellParameters getBasePostString];
        
        //拼参数
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@",spellString,self.others_userid];
        
        //加密
        DDQPOSTEncryption *post = [[DDQPOSTEncryption alloc] init];
        NSString *post_encryption = [post stringWithPost:post_baseString];
        
        //传
        NSMutableDictionary *post_dic = [[PostData alloc] postData:post_encryption AndUrl:kUser_moreUrl];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            NSDictionary *dic = [DDQPOSTEncryption judgePOSTDic:post_dic];
            
            if ([dic[@"errorcode"] intValue] == 0) {
                self.userInfo = [[DDQMineInfoModel alloc] init];
                
                self.userInfo.age = dic[@"age"];
                self.userInfo.city = dic[@"city"];
                self.userInfo.level = dic[@"level"];
                self.userInfo.sex = dic[@"sex"];
                self.userInfo.star = dic[@"star"];
                self.userInfo.userid = dic[@"userid"];
                self.userInfo.userimg = dic[@"userimg"];
                self.userInfo.username = dic[@"username"];
                self.userInfo.group = dic[@"group"];
            }
            self.mainTableView.tableHeaderView = [self setHeaderView];
            [self.mainTableView reloadData];
        });
        
    });
}

-(void)initTableView {
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-64) style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.backgroundColor = [UIColor backgroundColor];
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

//设置头视图
-(UIView *)setHeaderView {
    
    self.backgroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height*0.3)];
    [self.view addSubview:self.backgroundImageView];
    
    //创建一个文件管理者
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *fullPath =[[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"avatar.png"];
    
    if ([fileManager fileExistsAtPath:fullPath] == YES) {
        self.backgroundImageView.image = [UIImage imageWithContentsOfFile:fullPath];
        
    } else {
        self.backgroundImageView.image = nil;
    }
    
    
    self.userMessage = [[UIView alloc] init];
    [self.backgroundImageView addSubview:self.userMessage];
    [self.userMessage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundImageView.mas_centerX);
        make.bottom.equalTo(self.backgroundImageView.mas_bottom).with.offset(-10);
        if (kScreenHeight == 480) {
            make.width.offset(160);
            make.height.offset(20);
        } else if (kScreenHeight == 568) {
            make.width.offset(160);
            make.height.offset(20);
        } else if (kScreenHeight == 667) {
            make.width.offset(186);
            make.height.offset(20);
        } else {
            make.width.offset(270);
            make.height.offset(20);
        }
    }];
    [self.userMessage.layer setCornerRadius:10.0f];
    

    [self.userMessage.layer setMasksToBounds:YES];
    [self.userMessage setBackgroundColor:[UIColor whiteColor]];
    NSString *sex = self.userInfo.sex;

    UIImageView *imageView_1 = [[UIImageView alloc] init];
    UILabel *label_1 = [[UILabel alloc] init];
    UIImageView *imageView_2 = [[UIImageView alloc] init];
    UILabel *label_2 = [[UILabel alloc] init];
    [self.userMessage addSubview:imageView_1];
    [self.userMessage addSubview:imageView_2];
    [self.userMessage addSubview:label_1];
    [self.userMessage addSubview:label_2];
    [label_1 setTextAlignment:NSTextAlignmentCenter];
    [label_2 setTextAlignment:NSTextAlignmentCenter];
    
    if (kScreenHeight == 480) {
        imageView_1.frame = CGRectMake(10, 5, 10, 10);
        imageView_1.image = [UIImage imageNamed:@"god_icon_sex"];
        [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView_1.mas_right);
            make.top.equalTo(imageView_1.mas_top);
            make.height.equalTo(imageView_1.mas_height);
        }];
        [label_1 setText:sex];
        label_1.font = [UIFont systemFontOfSize:13.0f];
        
        
        label_2.frame = CGRectMake(110, 5, 50, 10);
        label_2.font = [UIFont systemFontOfSize:13.0f];
        label_2.text = self.userInfo.city;
        label_2.textAlignment = NSTextAlignmentLeft;
        [imageView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label_2.mas_left);
            make.top.equalTo(label_2.mas_top);
            make.height.equalTo(label_2.mas_height);
            make.width.equalTo(imageView_1.mas_width);
        }];
        imageView_2.image = [UIImage imageNamed:@"god_icon_location"];
        
    } else if (kScreenHeight == 568) {
        imageView_1.frame = CGRectMake(10, 5, 10, 10);
        imageView_1.image = [UIImage imageNamed:@"god_icon_sex"];
        [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView_1.mas_right);
            make.top.equalTo(imageView_1.mas_top);
            make.height.equalTo(imageView_1.mas_height);
        }];
        [label_1 setText:sex];
        label_1.font = [UIFont systemFontOfSize:13.0f];
        
        
        label_2.frame = CGRectMake(110, 5, 50, 10);
        label_2.font = [UIFont systemFontOfSize:13.0f];
        label_2.text = self.userInfo.city;
        label_2.textAlignment = NSTextAlignmentLeft;
        [imageView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label_2.mas_left);
            make.top.equalTo(label_2.mas_top);
            make.height.equalTo(label_2.mas_height);
            make.width.equalTo(imageView_1.mas_width);
        }];
        imageView_2.image = [UIImage imageNamed:@"god_icon_location"];
        
    } else if (kScreenHeight == 667) {
        imageView_1.frame = CGRectMake(10, 5, 10, 10);
        imageView_1.image = [UIImage imageNamed:@"god_icon_sex"];
        [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView_1.mas_right);
            make.top.equalTo(imageView_1.mas_top);
            make.height.equalTo(imageView_1.mas_height);
        }];
        [label_1 setText:sex];
        label_1.font = [UIFont systemFontOfSize:13.0f];
        
        
        label_2.frame = CGRectMake(121, 5, 50, 10);
        label_2.font = [UIFont systemFontOfSize:13.0f];
        label_2.text = self.userInfo.city;
        label_2.textAlignment = NSTextAlignmentLeft;
        [imageView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label_2.mas_left);
            make.top.equalTo(label_2.mas_top);
            make.height.equalTo(label_2.mas_height);
            make.width.equalTo(imageView_1.mas_width);
        }];
        imageView_2.image = [UIImage imageNamed:@"god_icon_location"];
        
    } else {
        imageView_1.frame = CGRectMake(10, 5, 10, 10);
        imageView_1.image = [UIImage imageNamed:@"god_icon_sex"];
        [label_1 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView_1.mas_right);
            make.top.equalTo(imageView_1.mas_top);
            make.height.equalTo(imageView_1.mas_height);
        }];
        [label_1 setText:sex];
        label_1.font = [UIFont systemFontOfSize:13.0f];
        
        
        label_2.frame = CGRectMake(195, 5, 50, 10);
        label_2.font = [UIFont systemFontOfSize:13.0f];
        label_2.text = self.userInfo.city;
        label_2.textAlignment = NSTextAlignmentLeft;
        [imageView_2 mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(label_2.mas_left);
            make.top.equalTo(label_2.mas_top);
            make.height.equalTo(label_2.mas_height);
            make.width.equalTo(imageView_1.mas_width);
        }];
        imageView_2.image = [UIImage imageNamed:@"god_icon_location"];
        
    }
    
    
    self.userName = [[UILabel alloc] init];
    [self.backgroundImageView addSubview:self.userName];
    [self.userName mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userMessage.mas_left);
        make.height.offset(20);
        make.bottom.equalTo(self.userMessage.mas_top).with.offset(-5);
        make.width.equalTo(self.userMessage.mas_width).with.multipliedBy(0.6);
    }];
    [self.userName setText:self.userInfo.username];
    _userName.font = [UIFont systemFontOfSize:15.0f];
    [self.userName setTextAlignment:NSTextAlignmentLeft];
    _userName.textColor = [UIColor whiteColor];

    UIImageView *levelImageView = [[UIImageView alloc] init];
    [self.backgroundImageView addSubview:levelImageView];
    [levelImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.userMessage.mas_right);
        make.bottom.equalTo(self.userName.mas_bottom);
        make.height.equalTo(self.userName.mas_height);
        make.width.equalTo(self.userMessage.mas_width).with.multipliedBy(0.3);
    }];
    [levelImageView setImage:[UIImage imageNamed:@"levelImg"]];
    self.userLV = [[UILabel alloc] init];
    [levelImageView addSubview:self.userLV];
    [self.userLV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(levelImageView.mas_left);
        make.bottom.equalTo(levelImageView.mas_bottom);
        make.height.equalTo(levelImageView.mas_height);
        make.width.equalTo(levelImageView.mas_width);
    }];
    NSString *str_userLevel = [NSString stringWithFormat:@"LV:%@",self.userInfo.level];
    [self.userLV setText:str_userLevel];
    _userLV.font = [UIFont systemFontOfSize:13.0f];
    _userLV.textAlignment = NSTextAlignmentLeft;
    _userLV.textColor = [UIColor whiteColor];
    
    self.userImageView = [[UIImageView alloc] init];
    [self.backgroundImageView addSubview:self.userImageView];
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backgroundImageView.mas_centerX);
        make.centerY.equalTo(self.backgroundImageView.mas_centerY).with.offset(-30);
        make.width.offset(70);
        make.height.offset(70);
    }];
    [self.userImageView.layer setCornerRadius:35.0f];
    [self.userImageView.layer setMasksToBounds:YES];
//    
    if (![self.userInfo.userimg isEqualToString:@""] && self.userInfo.userimg != nil) {
        
        NSURL *url = [NSURL URLWithString:self.userInfo.userimg];
        [_userImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_pic"]];
    } else {
        
        _userImageView.image = [UIImage imageNamed:@"default_pic"];
    }
    
    return self.backgroundImageView;
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    //根据数据返回分区个数
//    if (self.userInfo.group.count != 0) {
//        return 2;
//    } else {
        return 3;
//    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    //返回个数同上
    if (section == 0) {
        return 1;
    } else if (section == 1) {
    
        return self.personalDiary_array.count;
    } else {
    
        return self.personalComment_array.count;
    }
}

static NSString *identifier = @"cell";
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
//    if (self.userInfo.group.count != 0) {
    
        if (indexPath.section == 0) {
            
            DDQOthersTableViewCell *othersCell = [[DDQOthersTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            DDQOthersModel *othersModel        = [[DDQOthersModel alloc] init];
            othersModel.imgArray = self.userInfo.group;
            othersCell.othersModel = othersModel;
            self.group_height = othersCell.img_height;
            
            othersCell.selectionStyle = UITableViewCellSelectionStyleNone;
            return othersCell;
            
        }  else if (indexPath.section == 1) {
            
            DDQGroupArticleModel *articleModel;
            if (self.personalDiary_array.count != 0) {
                
                articleModel = self.personalDiary_array[indexPath.row];
            }
            
            DDQMyCommentCell *commentCell = [[DDQMyCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            commentCell.articleModel      = articleModel;
            self.diary_height           = commentCell.cell_height;
            commentCell.selectionStyle    = UITableViewCellSelectionStyleNone;//取消选中高亮
            commentCell.backgroundColor   = [UIColor myGrayColor];
            
            UIView *delete_view = [commentCell.contentView viewWithTag:2];
            for (UIView *view in delete_view.subviews) {
                [view removeFromSuperview];
            }
            
            commentCell.selectionStyle = UITableViewCellSelectionStyleNone;

            return commentCell;
            
        } else if (indexPath.section == 2) {
        
            DDQGroupArticleModel *articleModel;
            if (self.personalComment_array.count != 0) {
                
                articleModel = self.personalComment_array[indexPath.row];
            }
            
            DDQMyCommentCell *commentCell = [[DDQMyCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            commentCell.articleModel      = articleModel;
            self.comment_height             = commentCell.cell_height;
            commentCell.selectionStyle    = UITableViewCellSelectionStyleNone;//取消选中高亮
            commentCell.backgroundColor   = [UIColor myGrayColor];
            
            UIView *delete_view = [commentCell.contentView viewWithTag:2];
            for (UIView *view in delete_view.subviews) {
                [view removeFromSuperview];
            }
            
            commentCell.selectionStyle = UITableViewCellSelectionStyleNone;

            return commentCell;
            
        } else {
        
            static NSString *identifier = @"cell";
            UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
            if (!cell) {
                cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            }
            return cell;
        }
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        
        return self.group_height;
        
    } else if (indexPath.section == 1) {
        
//        if (self.diary_height == 0) {
//            return  kScreenHeight * 0.5;
//        } else {
            return  self.diary_height;
//        }
        
    } else {
    
        return  self.comment_height;
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {

    if (section == 0) {
        return @"她加入的小组";
        
    } else if (section == 1) {
        return @"她的日记";
    
    } else {
        return @"她的回帖";
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DDQUserCommentViewController *userCommentVC = [[DDQUserCommentViewController alloc] init];
    DDQHeaderSingleModel *headerSingle = [DDQHeaderSingleModel singleModelByValue];
    if (indexPath.section == 1) {
        
        DDQGroupArticleModel *groupArticle;
        if (self.personalDiary_array.count != 0) {
            groupArticle = self.personalDiary_array[indexPath.row];
        }
        headerSingle.ctime = groupArticle.ctime;
        [self.navigationController pushViewController:userCommentVC animated:YES];
        
    } else {
    
        DDQGroupArticleModel *groupArticle;
        if (self.personalComment_array.count != 0) {
            groupArticle = self.personalComment_array[indexPath.row];
        }
        headerSingle.ctime = groupArticle.ctime;
        [self.navigationController pushViewController:userCommentVC animated:YES];
    }
}

#pragma mark - other methods
-(void)alertController:(NSString *)message {
    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [userNameAlert addAction:actionOne];
    [userNameAlert addAction:actionTwo];
}
@end
