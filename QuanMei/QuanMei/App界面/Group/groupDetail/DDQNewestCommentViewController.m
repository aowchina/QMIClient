//
//  DDQNewestCommentViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/7.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//
//12-02

#import "DDQNewestCommentViewController.h"
#import "DDQUserCommentViewController.h"
#import "DDQPreferenceDetailViewController.h"

#import "DDQDiaryViewCell.h"
#import "DDQHotProjectViewCell.h"
#import "DDQTagModel.h"
#import "DDQPostingViewController.h"

#import "DDQHeaderSingleModel.h"

#import "DDQGroupCollectionViewCell.h"


@interface DDQNewestCommentViewController ()<UITableViewDataSource,UITableViewDelegate,MBProgressHUDDelegate,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,UIGestureRecognizerDelegate>
{
    NSString *tagString;//筛选标签
    BOOL isClick;//点击状态
    
}
@property (strong,nonatomic) UITableView *mainTableView;

/**
 *  显示从小组头部视图传过来的数值
 */
@property (strong,nonatomic) DDQHeaderSingleModel *header_single;

@property (strong,nonatomic) NSMutableArray *articleModelArray;
@property (nonatomic ,strong)NSMutableArray *groupHeaderArray;
@property (strong,nonatomic) NSMutableArray *tagArray;

@property (strong,nonatomic) UIView *headerView;
@property (nonatomic ,strong)MBProgressHUD *hud;

@property (nonatomic ,strong)UIView *aView;

@property (nonatomic ,assign)BOOL isjoinGroup;//是否加入小组
//10-30
@property (nonatomic ,strong)UIView *tagView;//标签的存放
@property (assign,nonatomic) CGFloat rowHeight;

@property (strong,nonatomic) UITableViewCell *temp_cell;

@property (strong,nonatomic) UICollectionViewCell *temp_item;

@property (strong,nonatomic) UICollectionView *collectionView;
@end

@implementation DDQNewestCommentViewController

-(NSMutableArray *)groupHeaderArray {
    if (!_groupHeaderArray) {
        _groupHeaderArray = [NSMutableArray array];
    }
    return _groupHeaderArray;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    //12-09
    tagString = @"0";
    self.tagArray = [NSMutableArray array];
    isClick = NO;
    _header_single = [DDQHeaderSingleModel singleModelByValue];
    [self initTableView];
    self.temp_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    
    self.hud.detailsLabelText = @"请稍后...";
}
//12-03
- (void)refresh
{
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        if (!errorDic) {
            // 下拉刷新
            self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
                //再次请求接口先判断数组是否为nil
                [_articleModelArray removeAllObjects];
                //
                [self asyArticleListWithPage:1];
                // 结束刷新
                [self.mainTableView.header endRefreshing];
                [self.hud hide:YES];
            }];
            
            // 下拉刷新
            self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
                //再次请求接口先判断数组是否为nil
                int num = Page ++;
                [self asyArticleListWithPage:num];
                // 结束刷新
                [self.mainTableView.footer endRefreshing];
                self.mainTableView.footer.state = MJRefreshStateNoMoreData;
                [self.hud hide:YES];
                
            }];
        } else {
        
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
}
-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    //12-03
    _articleModelArray = [NSMutableArray array];
    
    [self.hud show:YES];
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        [self.hud hide:YES];
        if (!errorDic) {
            
            [self getGroupDetail];
            
            [self asyArticleListWithPage:1];
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
}

//10-23
- (void)postingButtonClicked
{
    DDQPostingViewController *postingVC  = [DDQPostingViewController new];
    
    postingVC.hidesBottomBarWhenPushed = YES;

    postingVC.PstringTagArray = self.tagArray;
    [self.navigationController pushViewController:postingVC animated:YES];
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    creatView = YES;
    
}
static BOOL creatView = NO;

//12-02
- (void)getGroupDetail
{
    DDQHeaderSingleModel *groupHeader_single = [DDQHeaderSingleModel singleModelByValue];
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *spellString = [SpellParameters getBasePostString];
        
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@",spellString,groupHeader_single.groupId,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]];
        
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_String = [postEncryption stringWithPost:post_baseString];
        
        NSMutableDictionary *post_Dic = [[PostData alloc] postData:post_String AndUrl:kGroup_detail];
        
        //11-05
        if ([[post_Dic objectForKey:@"errorcode"]intValue]==0) {
            
            NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_Dic];
            
            
            self.groupHeaderArray = [NSMutableArray arrayWithCapacity:0];
            //            for (NSDictionary *dic in get_jsonDic[@"group"]) {
            DDQGroupArticleModel *articleModel = [[DDQGroupArticleModel alloc]init];
            
            articleModel.amount = [get_jsonDic valueForKey:@"amount"];//人数
            
            articleModel.intro = [get_jsonDic valueForKey:@"intro"];//简介
            
            
            NSArray *temp_array = get_jsonDic[@"tag"];
            [self.tagArray removeAllObjects];
            for (NSDictionary *dic in temp_array) {
                DDQTagModel *model = [[DDQTagModel alloc] init];
                model.iD = dic[@"id"];
                model.gid = dic[@"gid"];
                model.intime = dic[@"intime"];
                model.name = dic[@"name"];
                [self.tagArray addObject:model];
            }
            
            articleModel.isin =  [get_jsonDic valueForKey:@"isin"];
            articleModel.isTemp = NO;
            [_groupHeaderArray addObject:articleModel];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (creatView == NO) {
                    
                    [self creatView];
                    self.mainTableView.tableHeaderView = self.headerView;
                    creatView = YES;
                    
                }

                [self.hud hide:YES];
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.hud hide:YES];
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message: @"服务器繁忙"  delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
        //11-05
        
    });
}

//12-04
static int tiezicount = 0,rijicount =0;
#pragma mark - asy net work
static int Page = 2;
-(void)asyArticleListWithPage:(int)page {
    rijicount = 0;
    tiezicount = 0;

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSString *spellString = [SpellParameters getBasePostString];
        
        //12-09
        NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@*%@*%@",spellString,@"1",_header_single.groupId,tagString,[NSString stringWithFormat:@"%d",page]];
        
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_String = [postEncryption stringWithPost:post_baseString];
        
        NSMutableDictionary *post_Dic = [[PostData alloc] postData:post_String AndUrl:kWenzhangUrl];
        
        //11-05
        if ([[post_Dic objectForKey:@"errorcode"]intValue] ==0) {
            
            //解密
            NSDictionary *get_jsonDic = [DDQPOSTEncryption judgePOSTDic:post_Dic];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if (get_jsonDic != nil && get_jsonDic.count > 0) {
                    
                    //10-30
                    //12-21
                    for (NSDictionary *dic1 in get_jsonDic) {
                        
                        NSDictionary *dic = [DDQPublic nullDic:dic1];
                        DDQGroupArticleModel *articleModel = [[DDQGroupArticleModel alloc] init];
                        //精或热
                        articleModel.isJing = [dic valueForKey:@"isjing"];//1是精,0不是
                        articleModel.articleTitle = [dic valueForKey:@"title"];
                        //                articleModel.groupName = [dic valueForKey:@"gname"];
                        articleModel.articleType = [dic valueForKey:@"type"];
                        //                articleModel.imgArray = [dic valueForKey:@"img"];
                        articleModel.introString = [dic valueForKey:@"text"];
                        //                articleModel.userHeaderImg = [dic valueForKey:@"pluserimg"];
                        //                articleModel.userName = [dic valueForKey:@"plusername"];
                        //12-14
                        articleModel.replyNum = [dic valueForKey:@"pl"];
                        articleModel.thumbNum = [dic valueForKey:@"zan"];
                        //                articleModel.plTime = [dic valueForKey:@"pltime"];
                        
                        //10-30
                        articleModel.groupName = [dic valueForKey:@"groupname"];
                        articleModel.imgArray = [dic valueForKey:@"imgs"];
                        articleModel.userHeaderImg = [dic valueForKey:@"userimg"];
                        articleModel.userid = [dic valueForKey:@"userid"];
                        articleModel.userName = [dic valueForKey:@"username"];
                        articleModel.plTime = [dic valueForKey:@"pubtime"];
                        
                        articleModel.ctime = dic[@"ctime"];
                        articleModel.articleId = dic[@"id"];
                        [_articleModelArray addObject:articleModel];
                        
                        //12-04
                        if ([articleModel.articleType isEqualToString:@"1"]) {
                            rijicount++;
                        }
                        else
                            if ([articleModel.articleType isEqualToString:@"2"]) {
                                tiezicount++;
                            }
                    }
                    [_mainTableView reloadData];
                    
                    [self.hud hide:YES];

                } else {
                    [self.hud hide:YES];

                    UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"暂无更多数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alertView show];
                    [_mainTableView reloadData];

                }
                
                
            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.hud hide:YES];
                
                UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"服务器繁忙" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                [alertView show];
            });
        }
        //11-05
        
    });
}

#pragma mark - tableView and headerView
-(void)initTableView {
    //10-30
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kScreenHeight-64) style:UITableViewStyleGrouped];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    
    [self.view addSubview:self.mainTableView];
    self.mainTableView.backgroundColor = [UIColor backgroundColor];
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self refresh];
}

- (void)creatView
{
    if (_groupHeaderArray.count == 0) {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"请求失败" message:@"网络繁忙..." delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
        [self.hud hide:YES];
}
    else{
        DDQGroupArticleModel *model =[_groupHeaderArray objectAtIndex:0];
        
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight*0.25)];
        _headerView = headerView;
        _headerView.backgroundColor = [UIColor whiteColor];
        
        //imageView
        UIImageView *imageView = [[UIImageView alloc] init];
        [_headerView addSubview:imageView];
        [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(_headerView.mas_centerY);
            make.left.equalTo(_headerView.mas_left).offset(10);
            make.width.equalTo(_headerView.mas_width).multipliedBy(0.2);
            make.height.equalTo(imageView.mas_width);
            
        }];
        NSURL *url = [NSURL URLWithString:_header_single.iconUrl];
        [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_pic"]];
        [imageView.layer setCornerRadius:5];
        
        //title
        UILabel *titleLabel = [[UILabel alloc] init];
        [_headerView addSubview:titleLabel];
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@70);
            make.height.equalTo(@30);
            make.top.equalTo(imageView.mas_top);
            make.left.equalTo(imageView.mas_right).with.offset(10);
        }];
        [titleLabel setText:_header_single.name];
        [titleLabel setFont:[UIFont systemFontOfSize:18.0 weight:5.0]];
        
        //描述
        CGRect rect = [model.intro boundingRectWithSize:CGSizeMake(kScreenWidth - kScreenWidth*0.2 - 70 - 65, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil];
        UILabel *description = [[UILabel alloc] init];
        [_headerView addSubview:description];
        [description mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(imageView.mas_right).with.offset(10);
            make.top.equalTo(titleLabel.mas_bottom);
            make.width.offset(rect.size.width);
            make.height.offset(rect.size.height);
        }];
        [description setNumberOfLines:0];
        description.font = [UIFont systemFontOfSize:15.0];
        description.text = model.intro;
        //10-21
        description.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:0.5];
        
        //一个小button
        UIButton *joinButton = [[UIButton alloc] init];
        [_headerView addSubview:joinButton];
        [joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(headerView.mas_centerY);
            make.right.equalTo(_headerView.mas_right).with.offset(-10);
            make.width.mas_equalTo(65.0f);
            make.height.offset(35.0f);
        }];
        
        //10-30
        if ([model.isin intValue]==0) {
            [joinButton setTitle:@"加入" forState:UIControlStateNormal];
            joinButton.tag = 1;
            _isjoinGroup = NO;
            [joinButton setTitleColor:[UIColor meiHongSe] forState:UIControlStateNormal];
            [joinButton.layer setBorderColor:[UIColor meiHongSe].CGColor];
            
        }
        else
            if ([model.isin intValue]== 1) {
                [joinButton setTitle:@"退出" forState:UIControlStateNormal];
                joinButton.tag = 2;
                _isjoinGroup = YES;
                
                [joinButton setTitleColor:[UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:0.5] forState:(UIControlStateNormal)];
                
                [joinButton.layer setBorderColor:[UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:0.5].CGColor];
            }
        
        [joinButton.layer setCornerRadius:15];
        [joinButton.layer setBorderWidth:1];
        
        [joinButton addTarget:self action:@selector(isjoinButtonClicked:) forControlEvents:(UIControlEventTouchUpInside)];
        //10-30
        
        
        //一个小图标
        UIImageView *oneImage = [[UIImageView alloc] init];
        [_headerView addSubview:oneImage];
        [oneImage mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@20);
            make.height.equalTo(@20);
            make.left.equalTo(_headerView.mas_left).with.offset(10);
            make.bottom.equalTo(_headerView.mas_bottom).with.offset(-5);
        }];
        oneImage.image = [UIImage imageNamed:@"people"];
        
        //人数label
        UILabel *populationLabel = [[UILabel alloc] init];
        [_headerView addSubview:populationLabel];
        [populationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.height.equalTo(oneImage.mas_height);
            make.centerY.equalTo(oneImage.mas_centerY);
            make.left.equalTo(oneImage.mas_right).with.offset(5);
            make.width.equalTo(oneImage.mas_width).with.multipliedBy(5);
        }];
        [populationLabel setText:model.amount];
        //10-21
        populationLabel.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:0.5];
        
        
        //10-21
        //标签
        UIButton *tagButton = [UIButton buttonWithType:(UIButtonTypeSystem)];
        [_headerView addSubview:tagButton];
        [tagButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@35);
            make.right.equalTo(joinButton.mas_right);
            make.centerY.equalTo(oneImage.mas_centerY);
            make.height.equalTo(populationLabel.mas_height);
        }];
        [tagButton setTitle:@"标签" forState:(UIControlStateNormal)];
        [tagButton addTarget:self action:@selector(tagButtonClicked) forControlEvents:(UIControlEventTouchUpInside)];
        [tagButton setTitleColor:[UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:0.5] forState:(UIControlStateNormal)];
        
        //三个小图标
        UIImageView *threeImageView =[[UIImageView alloc] init];
        [_headerView addSubview:threeImageView];
        [threeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(tagButton.mas_left);
            make.width.equalTo(oneImage.mas_width);
            make.height.equalTo(oneImage.mas_height);
            make.centerY.equalTo(oneImage.mas_centerY);
        }];
        threeImageView.image = [UIImage imageNamed:@"title"];
        
        headerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.2 + 60);
        _headerView = headerView;
        _headerView.backgroundColor = [UIColor whiteColor];
        
        UIView *backView = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight - 110, self.view.frame.size.width,50)];
        
        backView.backgroundColor  = [[UIColor blackColor] colorWithAlphaComponent:0.5f];
        
        [self.view addSubview:backView];
        
        UILabel *postingLabel = [UILabel new];
        [backView addSubview:postingLabel];
        [postingLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(backView.mas_centerY);
            make.left.equalTo(backView.mas_centerX);
            
        }];
        postingLabel.font = [UIFont systemFontOfSize:17.0f weight:1.0f];
        postingLabel.text = @"发帖";
        postingLabel.textColor = [UIColor whiteColor];
        
        UIImageView *temp_img = [UIImageView new];
        [backView addSubview:temp_img];
        [temp_img mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.right.equalTo(postingLabel.mas_left).offset(-5);
            make.centerY.equalTo(postingLabel.mas_centerY);
            make.width.and.height.offset(17);
            
        }];
        
        temp_img.image = [UIImage imageNamed:@"indicator_arrow"];
        temp_img.userInteractionEnabled = YES;
        postingLabel.userInteractionEnabled = YES;
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(postingButtonClicked)];
        [backView addGestureRecognizer:tap];
    }
}

//10-30
#pragma  mark -

- (void)tagButtonClicked
{
    if (isClick == NO) {
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.mainTableView beginUpdates];
        DDQGroupArticleModel *model1= [[DDQGroupArticleModel alloc] init];
        model1.isTemp = YES;
        [_articleModelArray insertObject:model1 atIndex:0];
        [self.mainTableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationLeft];
        [self.mainTableView endUpdates];
        [self.mainTableView reloadData];
        isClick = YES;

        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;

        self.collectionView = [[UICollectionView alloc]initWithFrame:CGRectMake(0  ,   0  , kScreenWidth  ,  50) collectionViewLayout:flowLayout];
        self.collectionView.showsHorizontalScrollIndicator = NO;
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;

        self.collectionView.backgroundColor = [UIColor backgroundColor];

        self.collectionView.minimumZoomScale = 1;
        self.collectionView.maximumZoomScale = 1;

        [self.collectionView registerClass:[DDQGroupCollectionViewCell class] forCellWithReuseIdentifier:@"collectionCell"];
        
        [self.temp_cell.contentView addSubview:self.collectionView];
    } else {
    
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
        [self.mainTableView beginUpdates];
        [_articleModelArray removeObjectAtIndex:0];
        [self.mainTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationRight];
        [self.collectionView removeFromSuperview];
        
        [self.mainTableView endUpdates];
        [self.mainTableView reloadData];
        isClick = NO;
    }
}

//12-02
- (void)isjoinButtonClicked:(UIButton *)btn
{
    //
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"] !=nil && ![DDQPublic isBlankString:[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]]) {
        
        if (_isjoinGroup == NO) {
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *spellString = [SpellParameters getBasePostString];
                
                NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],_header_single.groupId];
                
                DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
                NSString *post_String = [postEncryption stringWithPost:post_baseString];
                
                NSMutableDictionary *post_Dic = [[PostData alloc] postData:post_String AndUrl:kGroup_join];
                
                switch ([[post_Dic objectForKey:@"errorcode"]intValue]) {
                    case 0:
                    {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                                message:@"加入小组成功"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil, nil];
                            [alertView show];
                            
                            [btn setTitle:@"退出" forState:(UIControlStateNormal)];
                            
                            [btn setTitleColor:[UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:0.5] forState:(UIControlStateNormal)];
                            
                            [btn.layer setBorderColor:[UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:0.5].CGColor];
                            
                            _isjoinGroup = YES;
                        });
                        break;
                    }
                    case 50:
                    {
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                                message:@"您已在本小组"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil, nil];
                            [alertView show];
                            
                            [btn setTitle:@"退出" forState:(UIControlStateNormal)];
                            
                            [btn setTitleColor:[UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:0.5] forState:(UIControlStateNormal)];
                            
                            [btn.layer setBorderColor:[UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:0.5].CGColor];
                            
                            _isjoinGroup = YES;
                        });
                        
                        
                        break;
                    }
                    default:
                    {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"加入小组失败"
                                                                                message:@"服务器繁忙,请稍后重试"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil, nil];
                            [alertView show];
                            
                            _isjoinGroup = NO;
                        });
                        
                        break;
                    }
                }
                
            });
            
            
        }else{
            
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                NSString *spellString = [SpellParameters getBasePostString];
                
                NSString *post_baseString = [NSString stringWithFormat:@"%@*%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"],_header_single.groupId];
                
                DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
                NSString *post_String = [postEncryption stringWithPost:post_baseString];
                
                NSMutableDictionary *post_Dic = [[PostData alloc] postData:post_String AndUrl:kGroup_exit];
                
                switch ([[post_Dic objectForKey:@"errorcode"]intValue]) {
                    case 0:
                    {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                                message:@"退出小组成功"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil, nil];
                            [alertView show];
                            
                            [btn setTitle:@"加入" forState:(UIControlStateNormal)];
                            [btn setTitleColor:[UIColor meiHongSe] forState:(UIControlStateNormal)];
                            
                            [btn.layer setBorderColor:[UIColor meiHongSe].CGColor];
                            
                            _isjoinGroup = NO;
                        });
                        break;
                    }
                    case 51:
                    {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                                                message: @"您尚未加入小组"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil, nil];
                            [alertView show];
                            
                            [btn setTitle:@"加入" forState:(UIControlStateNormal)];
                            [btn setTitleColor:[UIColor meiHongSe] forState:(UIControlStateNormal)];
                            
                            [btn.layer setBorderColor:[UIColor meiHongSe].CGColor];
                            
                            _isjoinGroup = NO;
                        });
                        
                        
                        break;
                    }
                    default:
                    {
                        
                        dispatch_async(dispatch_get_main_queue(), ^{
                            UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"退出小组失败"
                                                                                message:@"服务器繁忙,请稍后重试"
                                                                               delegate:self
                                                                      cancelButtonTitle:@"确定"
                                                                      otherButtonTitles:nil, nil];
                            [alertView show];
                            
                            _isjoinGroup = YES;
                        });
                        
                        break;
                    }
                }
                
            });
            
            
            _isjoinGroup = NO;
        }
        
    }else
    {
        UIAlertView * alertView = [[UIAlertView alloc]initWithTitle:@"提示"
                                                            message:@"请先登录..."
                                                           delegate:self
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil, nil];
        
        [alertView show];
    }
}

#pragma mark - collectionView

//12-04
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //10-29
    DDQGroupCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    DDQTagModel *model = self.tagArray[indexPath.row];
    
    
    NSString *str = model.name;
    cell.title.text = str;
    //10-29
    cell.layer.cornerRadius = 18.0f;
    cell.layer.borderWidth =1;
    cell.layer.borderColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1].CGColor;
    
    if (model.isChange == YES) {
        cell.layer.borderColor = [UIColor meiHongSe].CGColor;
        cell.title.textColor = [UIColor meiHongSe];

    } else{
    
        cell.backgroundColor = [UIColor whiteColor];

    }
    return cell;
}

//12-04有问题
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    DDQTagModel *model = [_tagArray objectAtIndex:indexPath.row];
    tagString =  model.iD;
    if (model.isChange == NO) {
        
        for (DDQTagModel *model in _tagArray) {
            model.isChange = NO;
        }
        model.isChange = YES;
        
        DDQGroupCollectionViewCell *cell = [collectionView cellForItemAtIndexPath:indexPath];
        cell.title.textColor = [UIColor meiHongSe];
        cell.layer.borderColor = [UIColor meiHongSe].CGColor;

    } else {
        model.isChange = NO;
    }
    //重新加载tableView
    [_articleModelArray removeAllObjects];
    isClick = NO;
    [self.hud show:YES];
    [self asyArticleListWithPage:1];
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.tagArray.count;
    //10-29
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(80, 35);
}

-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
    
}

#pragma mark - tableView Delegate And DataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
        return _articleModelArray.count;
    
}
static NSString *identifier = @"cell";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        //12-09
        if (_articleModelArray != nil && _articleModelArray.count !=0 ) {
        
            DDQGroupArticleModel *articleModel = [_articleModelArray objectAtIndex:indexPath.row];
            
            if (articleModel.isTemp == NO) {
                DDQDiaryViewCell *diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
                diaryCell.articleModel = articleModel;
                
                //10-30
                self.rowHeight              = diaryCell.newRect.size.height;
                
                diaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
                diaryCell.backgroundColor = [UIColor backgroundColor];
                return diaryCell;
                
            } else {
                
                self.rowHeight              = 50;
                self.temp_cell.backgroundColor = [UIColor backgroundColor];
                self.temp_cell.selectionStyle = UITableViewCellSelectionStyleNone;
                return self.temp_cell;
            }

           
        }
        else
        {
            DDQDiaryViewCell *diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            //10-30
            self.rowHeight              = diaryCell.newRect.size.height;
            
            diaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
            diaryCell.backgroundColor = [UIColor backgroundColor];
            return diaryCell;
        }
        //12-09
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor lightTextColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {

    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {

    return 0;
}

//10-30已跪
//12-03
//12-04
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat h;
    if (kScreenHeight <= 568) {
        
        h = 20;
        
    } else if (kScreenHeight == 667) {
        
        h = 30;
        
    } else {
        
        h = 40;
        
    }
    if (indexPath.section ==0) {
        
        if (self.rowHeight !=0) {
            
            if (self.rowHeight != 50) {
                return self.rowHeight +kScreenHeight *0.25-h;
            } else {
            
                return 50;
            }
        }

        return kScreenHeight *0.5-h;
    }else{
        return kScreenHeight *0.3;
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDQUserCommentViewController *commentVC = [[DDQUserCommentViewController alloc] init];

    //取出model类
    DDQGroupArticleModel *model = self.articleModelArray[indexPath.row];

    //赋值
    DDQHeaderSingleModel *headerSingle = [DDQHeaderSingleModel singleModelByValue];

    headerSingle.ctime                      = model.ctime;
    headerSingle.articleId                  = model.articleId;
    headerSingle.userId                     = model.userid;
    commentVC.hidesBottomBarWhenPushed = YES;
    if (model.isTemp == NO) {
        [self.navigationController pushViewController:commentVC animated:YES];
    }
}
@end