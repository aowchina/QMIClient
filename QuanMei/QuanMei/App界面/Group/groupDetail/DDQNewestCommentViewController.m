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

#import "ProjectNetWork.h"

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

/** 记录我上一个点击的cell */
@property (strong,nonatomic) DDQGroupCollectionViewCell *temp_item;

@property (strong,nonatomic) UICollectionView *collectionView;

@property (strong, nonatomic) ProjectNetWork *netWork;
/** 页码 */
@property (assign, nonatomic) int page;

@end

@implementation DDQNewestCommentViewController


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    //这个单例里有上个页面的值
    _header_single = [DDQHeaderSingleModel singleModelByValue];
    
    tagString = @"0";
    self.tagArray          = [NSMutableArray array];
    self.articleModelArray = [NSMutableArray array];
    self.groupHeaderArray  = [NSMutableArray array];
    
    //初始化表示图
    [self initTableView];
    
    isClick = NO;
    self.temp_cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    
    self.hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:self.hud];
    self.hud.detailsLabelText = @"请稍候...";
    
    //网路
    self.netWork = [ProjectNetWork sharedWork];
    
    //页码
    self.page = 1;
    
}

//刷新
- (void)refresh {
    
    // 下拉刷新
    self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.page = 1;
        [self asyArticleListWithPage:1 ClearContainer:YES];
        [self.mainTableView.header endRefreshing];
        
    }];
    
    self.mainTableView.footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        
        self.page = self.page + 1;
        [self asyArticleListWithPage:self.page ClearContainer:NO];
        [self.mainTableView.footer endRefreshing];
        
    }];
    
}

-(void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    self.navigationController.navigationBar.translucent = NO;
    
    [self getGroupDetail];
    [self asyArticleListWithPage:1 ClearContainer:YES];
    
}

//10-23
- (void)postingButtonClicked {
    
    DDQPostingViewController *postingVC  = [DDQPostingViewController new];
    postingVC.hidesBottomBarWhenPushed = YES;

    postingVC.PstringTagArray = self.tagArray;
    [self.navigationController pushViewController:postingVC animated:YES];
    
}

#pragma mark - asy net work
/** 请求头视图 */
- (void)getGroupDetail{
    
    DDQHeaderSingleModel *groupHeader_single = [DDQHeaderSingleModel singleModelByValue];
    
    [self.netWork asyPOSTWithAFN_url:kGroup_detail andData:@[groupHeader_single.groupId, [[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (!code_error) {
            
            //每次请求成功就删除标签数组的全部内容
            [self.tagArray removeAllObjects];//不然会有重复数据
            
            DDQGroupArticleModel *articleModel = [[DDQGroupArticleModel alloc]init];
            
            articleModel.amount = [responseObjc valueForKey:@"amount"];//人数
            articleModel.intro  = [responseObjc valueForKey:@"intro"];//简介
            articleModel.isTemp = NO;
            articleModel.isin   = [responseObjc valueForKey:@"isin"];
            
            [_groupHeaderArray addObject:articleModel];
            
            NSArray *temp_array = responseObjc[@"tag"];
            for (NSDictionary *dic in temp_array) {
                
                DDQTagModel *model = [[DDQTagModel alloc] init];
                model.iD           = dic[@"id"];
                model.gid          = dic[@"gid"];
                model.intime       = dic[@"intime"];
                model.name         = dic[@"name"];
                
                [self.tagArray addObject:model];
                
            }
            
            //更新UI
            [self.hud hide:YES];
            [self creatView];
            self.mainTableView.tableHeaderView = self.headerView;
            
        } else {
            
            [self.hud hide:YES];
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        
    }];
    
}

//static int Page = 1;
-(void)asyArticleListWithPage:(int)page ClearContainer:(BOOL)isClear{
    
    [self.hud show:YES];//显示hud
    
    if (isClear) {//是否清楚数据源
        
        self.articleModelArray = nil;
        self.articleModelArray = [NSMutableArray array];
        
    }
    
    [self.netWork asyPOSTWithAFN_url:kWenzhangUrl andData:@[@"1", _header_single.groupId, tagString, @(page).stringValue] andSuccess:^(id responseObjc, NSError *code_error) {
        
        if (!code_error) {
            
            for (NSDictionary *dic in responseObjc) {
                
                NSDictionary *tem = [DDQPublic nullDic:dic];
                DDQGroupArticleModel *articleModel = [[DDQGroupArticleModel alloc] init];
                //精或热
                articleModel.isJing        = [tem valueForKey:@"isjing"];//1是精,0不是
                articleModel.articleTitle  = [tem valueForKey:@"title"];
                articleModel.articleType   = [tem valueForKey:@"type"];
                articleModel.introString   = [tem valueForKey:@"text"];
                articleModel.replyNum      = [tem valueForKey:@"pl"];
                articleModel.thumbNum      = [tem valueForKey:@"zan"];
                
                articleModel.groupName     = [tem valueForKey:@"groupname"];
                articleModel.imgArray      = [tem valueForKey:@"imgs"];
                articleModel.userHeaderImg = [tem valueForKey:@"userimg"];
                articleModel.userid        = [tem valueForKey:@"userid"];
                articleModel.userName      = [tem valueForKey:@"username"];
                articleModel.plTime        = [tem valueForKey:@"pubtime"];
                
                articleModel.ctime         = tem[@"ctime"];
                articleModel.articleId     = tem[@"id"];
                
                [_articleModelArray addObject:articleModel];
                
            }
            
            if ([responseObjc count] == 0) {
                
                self.mainTableView.footer.state = MJRefreshStateNoMoreData;
                
            } else {
                
                self.mainTableView.footer.state = MJRefreshStateIdle;
                
            }
            
            [self.hud hide:YES];
            [self.mainTableView reloadData];
            
        } else {
            
            [self.hud hide:YES];
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
            
        }
        
    } andFailure:^(NSError *error) {
        
        [self.hud hide:YES];
        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
        [self.mainTableView reloadData];
        
    }];
    
}

#pragma mark - tableView and headerView
-(void)initTableView {
    //10-30
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, kScreenHeight-64) style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    
    [self.view addSubview:self.mainTableView];
    self.mainTableView.backgroundColor = [UIColor backgroundColor];
    self.mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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
    
    [self refresh];
}

- (void)creatView
{
    DDQGroupArticleModel *model =[_groupHeaderArray objectAtIndex:0];
    
    
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, kScreenHeight*0.25)];
    headerView.backgroundColor = [UIColor whiteColor];
    
    //imageView
    UIImageView *imageView = [[UIImageView alloc] init];
    [headerView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(headerView.mas_centerY);
        make.left.equalTo(headerView.mas_left).offset(10);
        make.width.equalTo(headerView.mas_width).multipliedBy(0.2);
        make.height.equalTo(imageView.mas_width);
        
    }];
    NSURL *url = [NSURL URLWithString:_header_single.iconUrl];
    [imageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_pic"]];
    [imageView.layer setCornerRadius:5];
    
    //title
    UILabel *titleLabel = [[UILabel alloc] init];
    [headerView addSubview:titleLabel];
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
    [headerView addSubview:description];
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
    [headerView addSubview:joinButton];
    [joinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(headerView.mas_centerY);
        make.right.equalTo(headerView.mas_right).with.offset(-10);
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
    [headerView addSubview:oneImage];
    [oneImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(@20);
        make.height.equalTo(@20);
        make.left.equalTo(headerView.mas_left).with.offset(10);
        make.bottom.equalTo(headerView.mas_bottom).with.offset(-5);
    }];
    oneImage.image = [UIImage imageNamed:@"people"];
    
    //人数label
    UILabel *populationLabel = [[UILabel alloc] init];
    [headerView addSubview:populationLabel];
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
    [headerView addSubview:tagButton];
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
    [headerView addSubview:threeImageView];
    [threeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(tagButton.mas_left);
        make.width.equalTo(oneImage.mas_width);
        make.height.equalTo(oneImage.mas_height);
        make.centerY.equalTo(oneImage.mas_centerY);
    }];
    threeImageView.image = [UIImage imageNamed:@"title"];
    
    headerView.frame = CGRectMake(0, 0, kScreenWidth, kScreenWidth * 0.2 + 60);
    _headerView = headerView;
    
}

//10-30
#pragma  mark -
/** 插入cell */
- (void)tagButtonClicked {
    
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

        self.collectionView.backgroundColor = [UIColor whiteColor];

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

//点击加入或退出按钮
- (void)isjoinButtonClicked:(UIButton *)btn {
    
    [self.hud show:YES];
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]) {
        
        if (self.isjoinGroup == NO) {
            
            [self.netWork asyPOSTWithAFN_url:kGroup_join andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"], _header_single.groupId] andSuccess:^(id responseObjc, NSError *code_error) {
                
                if (!code_error) {
                    
                    [self.hud hide:YES];

                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"加入小组成功" andShowDim:NO andSetDelay:YES andCustomView:nil];
                    
                    [btn setTitle:@"退出" forState:(UIControlStateNormal)];
                    [btn setTitleColor:[UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:0.5] forState:(UIControlStateNormal)];
                    [btn.layer setBorderColor:[UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:0.5].CGColor];
                    
                    self.isjoinGroup = YES;
                    
                } else {
                    
                    [self.hud hide:YES];
                    
                    NSInteger code = code_error.code;
                    if (code == 50) {
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"您已加入本小组" andShowDim:NO andSetDelay:YES andCustomView:nil];
                        
                    } else {
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                        
                    }
                    
                }
                
            } andFailure:^(NSError *error) {
                
                [self.hud hide:YES];
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            }];
            
        } else {
            
            [self.netWork asyPOSTWithAFN_url:kGroup_exit andData:@[[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"], _header_single.groupId] andSuccess:^(id responseObjc, NSError *code_error) {
                
                if (!code_error) {
                    
                    [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"退出小组成功" andShowDim:NO andSetDelay:YES andCustomView:nil];
                    
                    [btn setTitle:@"加入" forState:(UIControlStateNormal)];
                    [btn setTitleColor:[UIColor meiHongSe] forState:(UIControlStateNormal)];
                    [btn.layer setBorderColor:[UIColor meiHongSe].CGColor];
                    
                    self.isjoinGroup = NO;
                    
                    [self.hud hide:YES];
                    
                } else {
                    
                    [self.hud hide:YES];
                    
                    NSInteger code = code_error.code;
                    if (code == 51) {
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:@"您尚未加入小组" andShowDim:NO andSetDelay:YES andCustomView:nil];
                        
                    } else {
                        
                        [MBProgressHUD myCustomHudWithView:self.view andCustomText:kServerDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                        
                    }
                    
                }
                
            } andFailure:^(NSError *error) {
                
                [self.hud hide:YES];
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:kErrorDes andShowDim:NO andSetDelay:YES andCustomView:nil];
                
            }];
            
        }
        
    }
    
}

#pragma mark - collectionView
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //10-29
    DDQGroupCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collectionCell" forIndexPath:indexPath];
    
    DDQTagModel *model = self.tagArray[indexPath.row];
    
    NSString *str = model.name;
    cell.title.text = str;
    //10-29
    cell.layer.cornerRadius = 18.0f;
    cell.layer.borderWidth = 0.5;
    cell.layer.borderColor = [UIColor colorWithRed:227.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1.0f].CGColor;
    
    if (model.isChange == YES) {
        
        cell.layer.borderColor = [UIColor meiHongSe].CGColor;
        cell.title.textColor = [UIColor meiHongSe];

    } else{
    
        cell.backgroundColor = [UIColor whiteColor];

    }
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //当前cell
    DDQGroupCollectionViewCell *currentItem = [collectionView cellForItemAtIndexPath:indexPath];
    
    //点击了同一个cell
    if (self.temp_item == currentItem) return;
    
    //取出model类
    DDQTagModel *model = [_tagArray objectAtIndex:indexPath.row];
    tagString =  model.iD;
    if (model.isChange == NO) {
        
        //先让所有的选中都变为未选中
        for (DDQTagModel *model in _tagArray) {
            model.isChange = NO;
        }
        //在改变这个model的选中状态
        model.isChange = YES;
        
        //UI改变
        currentItem.title.textColor = [UIColor meiHongSe];
        currentItem.layer.borderColor = [UIColor meiHongSe].CGColor;
        
        self.temp_item.title.textColor = kTextColor;
        self.temp_item.layer.borderColor = [UIColor colorWithRed:227.0f/255.0f green:226.0f/255.0f blue:226.0f/255.0f alpha:1.0f].CGColor;
        
        //重新赋值
        self.temp_item = currentItem;
        
        //这是标签是否被点击了
        isClick = NO;
        [self asyArticleListWithPage:1 ClearContainer:YES];

    } else {
        
        return;
        
    }
    
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

        } else {
            
            DDQDiaryViewCell *diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
            
            //10-30
            self.rowHeight              = diaryCell.newRect.size.height;
            
            diaryCell.selectionStyle = UITableViewCellSelectionStyleNone;
            diaryCell.backgroundColor = [UIColor backgroundColor];
            return diaryCell;
            
        }
    
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor backgroundColor];
    return view;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForHeaderInSection:(NSInteger)section {

    return 10;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForFooterInSection:(NSInteger)section {

    return 0;
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
    if (indexPath.section ==0) {
        
        if (self.rowHeight !=0) {
            
            if (self.rowHeight != 50) {
                
                return self.rowHeight +kScreenHeight *0.25-h;
                
            } else {
            
                return 50;
            }
            
        } else {
        
            return kScreenHeight *0.5-h;

        }

    }else{
        
        return kScreenHeight *0.3;
        
    }
    
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDQUserCommentViewController *commentVC = [[DDQUserCommentViewController alloc] init];

    //取出model类
    DDQGroupArticleModel *model = self.articleModelArray[indexPath.row];

    commentVC.ctime                      = model.ctime;
    commentVC.articleId                  = model.articleId;
    commentVC.userid                     = model.userid;
    commentVC.hidesBottomBarWhenPushed = YES;
    
    if (model.isTemp == NO) {
        
        [self.navigationController pushViewController:commentVC animated:YES];
        
    }
    
}
@end