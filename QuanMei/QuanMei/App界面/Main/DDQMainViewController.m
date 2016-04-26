
//  DDQMainViewController.m
//  Full_ beauty
//
//  Created by Min-Fo_003 on 15/8/21.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "AppDelegate.h"
#import "DDQMainViewController.h"
#import "DDQLoginViewController.h"
#import "DDQCheckViewController.h"
#import "DDQPreferenceViewController.h"
#import "DDQPreferenceDetailViewController.h"
#import "DDQThemeActivityViewController.h"
#import "DDQUserDiaryViewController.h"
#import "DDQZRBViewController.h"
#import "DDQMineViewController.h"
#import "DDQHospitalHomePageController.h"
#import "DDQUserCommentViewController.h"
#import "DDQMoreCommentViewController.h"
#import "DDQMyReplyedViewController.h"
#import "DDQMessageViewController.h"
#import "DDQTeacherListViewController.h"
#import "DDQThemeActivityCell.h"
#import "DDQDiaryViewCell.h"
#import "DDQJinDiaryViewController.h"
#import "DDQUserInfoModel.h"
#import "DDQHeaderSingleModel.h"
#import "DDQMainViewControllerModel.h"
#import "DDQGroupArticleModel.h"//riji
#import "DDQMainHotProjectTableViewCell.h"
#import "DDQMyWalletViewController.h"
//10-30
#import "DDQLoopView.h"
#import "DDQQiandaoView.h"
#import "DDQSearchBar.h"
//11-06
#import "DDQMainSearchViewController.h"
#import "DDQBaoXianViewController.h"
#import "DDQLunBoModel.h"
#import "DDQThirdRegisterViewController.h"

@interface DDQMainViewController ()<UITableViewDelegate,UITableViewDataSource,MBProgressHUDDelegate,UISearchBarDelegate,UIScrollViewDelegate,DDQLoopViewDelegate,QiandaoDelegate,SearchDelegate>
/**
 *  headerView
 */
@property (strong,nonatomic) UIView *headerView;
/**
 *  tableView
 */
@property (strong,nonatomic) UITableView *mainTableView;
/**
 *  载体view
 */
@property (strong,nonatomic) UIView *currentView;
/**
 *  四个功能按钮
 */
@property (strong,nonatomic) UIButton *neihanButton;
@property (strong,nonatomic) UIButton *jinpinButton;
@property (strong,nonatomic) UIButton *zhengrongButton;
@property (strong,nonatomic) UIButton *chaButton;
@property (strong,nonatomic) UIButton *qiandao_button;
/**
 *  作为下部view布局的约束标准
 */
@property (strong,nonatomic) UILabel *firstLabel;
/**
 *  评论cell对应的数组
 */
@property (strong,nonatomic) NSMutableArray *commentArray;
@property (strong,nonatomic) NSMutableArray *commentAllDataArray;
/**
 *  读取本地文件
 */
@property (strong,nonatomic) NSDictionary *CSDic;
@property (strong,nonatomic) NSDictionary *SFDic;
//特惠
@property (nonatomic ,strong)NSMutableArray *tehuiArray;

//huodong
@property (nonatomic ,strong)NSMutableArray *actArray;

//goods
@property (nonatomic ,strong)NSMutableArray *goodsArray;

//项目
@property (nonatomic ,strong)NSMutableArray *projectArray;

//日记
@property (nonatomic ,strong)NSMutableArray *diaryArray;

//lunbo
@property (nonatomic ,strong)NSMutableArray *lunbo_Array;


@property (nonatomic ,strong)UIImage *image1;
//头
@property (nonatomic ,strong)UIImageView *linshiimageView;

@property (nonatomic,strong)UIAlertView *alertView;

@property (nonatomic ,strong)MBProgressHUD *hud;

//10-30
@property (nonatomic ,assign)CGFloat rowHeight;//日记cell高度

@property (strong,nonatomic) UIBarButtonItem *rightItem;
@property (assign,nonatomic) int zan_count;
@property (assign,nonatomic) int reply_count;


@property (strong,nonatomic) DDQLoopView *mainScrollView;
@property (strong,nonatomic) UIPageControl *scroll_page;
@property (strong,nonatomic) NSTimer *scroll_timer;
@end

@implementation DDQMainViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //10-19
    [self layoutNavigationBar];
    DDQSearchBar *searchBar = [[DDQSearchBar alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth * 0.5, 30)];
    searchBar.layer.cornerRadius = 15.0f;
    self.navigationItem.titleView = searchBar;
    searchBar.backgroundColor = [UIColor whiteColor];
    searchBar.layer.borderWidth = 1;
    searchBar.layer.borderColor = [UIColor lightGrayColor].CGColor;
    searchBar.layer.masksToBounds = YES;
    searchBar.delegate = self;
    
    searchBar.attributeHolder = [[NSAttributedString alloc] initWithString:@"搜索项目,日记,特惠" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f],NSForegroundColorAttributeName:[UIColor lightGrayColor]}];
    
    [self initMainTableView];
    [self layoutFunctionButton];
    
    self.hud = [[MBProgressHUD alloc]initWithView:self.view];
    [self.view addSubview:self.hud];
    [self.hud show:YES];
    self.hud.labelText = @"加载中...";

    [self qiandao];
    [self asyProductList];

    self.mainTableView.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
            
            if (errorDic == nil) {
                //移除数组中的数据
                [self.tehuiArray removeAllObjects];
                [self.diaryArray removeAllObjects];
                [self.goodsArray removeAllObjects];
                [self.projectArray removeAllObjects];
                
                //重新添加数据
                [self asyProductList];
                [self.mainTableView.header endRefreshing];
            } else {
                
                [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
                [self.mainTableView.header endRefreshing];
            }
        }];
    }];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeReplyImage:) name:@"image" object:nil];
}


#pragma  mark --gcd

- (void)qiandao {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求特惠列表
        NSString *spellString = [SpellParameters getBasePostString];
        NSString *poststr = [NSString stringWithFormat:@"%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]];
        //加密
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_String = [postEncryption stringWithPost:poststr];
        
        //接受字典
        NSMutableDictionary *get_postDic = [[PostData alloc] postData:post_String AndUrl:kCheck_QDUrl];
        
        NSString *str = get_postDic[@"errorcode"];
        int num = [str intValue];
        if (num == 0) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.qiandao_button setBackgroundImage:[UIImage imageNamed:@"未签到"] forState:UIControlStateNormal];
            });
        } else {
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.qiandao_button setBackgroundImage:[UIImage imageNamed:@"已签到"] forState:UIControlStateNormal];
            });
        }
    });
}

static BOOL isHidden = NO;
-(void)asyProductList {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求特惠列表
        NSString *spellString = [SpellParameters getBasePostString];
        
        //加密
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_String = [postEncryption stringWithPost:spellString];
        
        
        //接受字典
        NSMutableDictionary *get_postDic = [[PostData alloc] postData:post_String AndUrl:kMainUrl];
        if ([get_postDic[@"active"] intValue] == 2) {
            //转换
            NSDictionary *get_JsonDic = [DDQPOSTEncryption judgePOSTDic:get_postDic];
            
            if (![get_JsonDic isKindOfClass:[NSNull class]]) {
                
                _tehuiArray = [[NSMutableArray alloc]init];
                _actArray   = [[NSMutableArray alloc]init];
                _goodsArray = [[NSMutableArray alloc]init];
                
                _projectArray =  [[NSMutableArray alloc]init];
                _lunbo_Array = [NSMutableArray array];
                _diaryArray = [[NSMutableArray alloc]init];
                //12-21
                for (NSDictionary*dic1 in [get_JsonDic objectForKey:@"tehui"]) {
                    
                    NSDictionary * tem = [DDQPublic nullDic:dic1];
                    
                    
                    //12-15
                    DDQMainViewControllerModel *model = [DDQMainViewControllerModel new];
                    
                    model.IdString = [tem objectForKey:@"id"];
                    
                    model.newvalString = [tem objectForKey:@"newval"];
                    model.oldvalString = [tem objectForKey:@"oldval"];
                    model.simgString = [tem objectForKey:@"simg"];
                    
                    model.fnameString = [tem objectForKey:@"fname"];
                    model.nameString = [tem objectForKey:@"name"];
                    
                    model.sellout = [tem objectForKey:@"sellout"];
                    
                    [_tehuiArray addObject:model];
                    
                    
                }
                //12-21
                for (NSDictionary *dic in [get_JsonDic objectForKey:@"act"]) {
                    NSDictionary * tem = [DDQPublic nullDic:dic];
                    DDQMainViewControllerModel *model = [[DDQMainViewControllerModel alloc]init];
                    
                    model.bimgString = [tem objectForKey:@"bimg"];
                    model.fnameString = [tem objectForKey:@"fname"];
                    model.nameString = [tem objectForKey:@"name"];
                    model.amount = [tem objectForKey:@"amount"];
                    model.IdString = [tem objectForKey:@"id"];
                    
                    //10-19
                    model.pid = [tem objectForKey:@"pid"];
                    model.hid = [tem objectForKey:@"hid"];
                    
                    //10-30
                    model.yyuserDic = [tem objectForKey:@"yyuser"];
                    
                    
                    [_actArray addObject:model];
                }
                //12-21
                for (NSDictionary *dic1  in [get_JsonDic objectForKey:@"diary"]) {
                    NSDictionary * dic = [DDQPublic nullDic:dic1];
                    
                    
                    DDQGroupArticleModel *articleModel = [[DDQGroupArticleModel alloc] init];
                    //精或热
                    articleModel.isJing        = [dic valueForKey:@"isjing"];//1是精,0不是
                    articleModel.articleTitle  = [dic valueForKey:@"title"];
                    articleModel.articleType   = [dic valueForKey:@"type"];
                    articleModel.introString   = [dic valueForKey:@"text"];
                    articleModel.replyNum      = [dic valueForKey:@"pl"];
                    articleModel.thumbNum      = [dic valueForKey:@"zan"];
                    
                    //10-30
                    articleModel.groupName     = [dic valueForKey:@"groupname"];
                    articleModel.articleId     = dic[@"id"];
                    articleModel.userid = [dic valueForKey:@"userid"];
                    articleModel.userHeaderImg = [dic valueForKey:@"userimg"];
                    articleModel.userName      = [dic valueForKey:@"username"];
                    articleModel.imgArray      = [dic valueForKey:@"imgs"];
                    articleModel.ctime         = [dic valueForKey:@"ctime"];
                    articleModel.plTime        = [dic valueForKey:@"pubtime"];
                    
                    [_diaryArray addObject:articleModel];
                    
                }
                
                //12-21
                for (NSDictionary *dic1 in [get_JsonDic objectForKey:@"goods" ]) {
                    NSDictionary * tem = [DDQPublic nullDic:dic1];
                    DDQMainViewControllerModel *model = [[DDQMainViewControllerModel alloc]init];
                    
                    model.IdString = [tem objectForKey:@"id"];
                    
                    model.newvalString = [tem objectForKey:@"newval"];
                    
                    model.oldvalString = [tem objectForKey:@"oldval"];
                    
                    model.simgString = [tem objectForKey:@"simg"];
                    
                    model.fnameString = [tem objectForKey:@"fname"];
                    
                    model.sellout = [tem objectForKey:@"sellout"];
                    
                    model.nameString = [tem objectForKey:@"name"];
                    model.hname = [tem objectForKey:@"hname"];
                    [_goodsArray addObject:model];
                }
                //12-21
                for (NSDictionary *dic1 in [get_JsonDic objectForKey:@"project"]) {
                    NSDictionary * tem = [DDQPublic nullDic:dic1];
                    DDQMainViewControllerModel *model = [[DDQMainViewControllerModel alloc]init];
                    
                    
                    model.IdString = [tem objectForKey:@"id"];
                    model.nameString = [tem objectForKey:@"name"];
                    
                    [_projectArray addObject:model];
                }
                
                //2-1
                for (NSDictionary *dic in get_JsonDic[@"lunbo"]) {
                    NSDictionary *temp_dic = [DDQPublic nullDic:dic];
                    DDQLunBoModel *model = [DDQLunBoModel new];
                    model.hid = temp_dic[@"hid"];
                    model.iD = temp_dic[@"id"];
                    model.img = temp_dic[@"img"];
                    model.pid = temp_dic[@"pid"];
                    model.type = temp_dic[@"type"];
                    [self.lunbo_Array addObject:model];
                }
            }
            
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [self.hud hide:YES];

            [self.mainTableView reloadData];
            [self.mainTableView.header endRefreshing];
            
            NSMutableArray *array = [NSMutableArray array];
            for (DDQLunBoModel *model in self.lunbo_Array) {
                [array addObject:model.img];
            }
            if (self.lunbo_Array.count > 0) {
                
                /**
                 *  这是为了防止轮播图定时器的重复添加
                 */
                [self.mainScrollView stop];
                self.mainScrollView.source_array = array;
                [self.mainScrollView.loop_collection reloadData];
                [self.mainScrollView star];

                self.mainScrollView.page_control.numberOfPages = array.count;
                
                self.mainScrollView.backgroundColor = [UIColor whiteColor];
                [self.mainScrollView.loop_collection setBackgroundColor:[UIColor whiteColor]];
            }
            
        });
        
    });
    
}
/**
 *  轮播图的点击事件
 *
 */
-(void)loopview_selectedMethod:(NSInteger)count {

    if (count <= 2) {
        
        DDQThemeActivityViewController *themeActivityVC = [[DDQThemeActivityViewController alloc] init];
        themeActivityVC.hidesBottomBarWhenPushed = YES;

        DDQMainViewControllerModel *model =  _actArray[count];

        themeActivityVC.pid = model.pid;
        themeActivityVC.hid = model.hid;
        themeActivityVC.ImgURL = model.bimgString;
        [self.navigationController pushViewController:themeActivityVC animated:YES];

    } else if (count == 3) {

        DDQTeacherListViewController *list_vc = [DDQTeacherListViewController new];
        list_vc.hidesBottomBarWhenPushed = YES;

        [self.navigationController pushViewController:list_vc animated:NO];
        
    } else {

        DDQBaoXianViewController *baoxian = [DDQBaoXianViewController new];
        baoxian.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:baoxian animated:NO];
        
    }

}


-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:YES];
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    [self.hud hide:YES];

    //首页必须设置image，tintColor和textAttribute
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    [self layoutNavigationBar];

    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic != nil) {
            [self.hud hide:YES];
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
        
    }];
    
}

#pragma mark - tableview
-(void)initMainTableView {
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight-49-64) style:UITableViewStylePlain];
    self.mainTableView.delegate = self;
    self.mainTableView.dataSource = self;
    [self.view addSubview:self.mainTableView];
    //头视图
    self.headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth,kScreenHeight*0.45)];

    self.automaticallyAdjustsScrollViewInsets = NO;
    self.headerView.backgroundColor = [UIColor backgroundColor];
    self.mainTableView.tableHeaderView = self.headerView;
    
}

#pragma mark - delegate and datasource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}

//12-01,判断空
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        return 1;
    } else if (section == 1) {
        return _actArray.count;
        
    } else if (section == 2){
        if (_diaryArray.count ==0) {
            
            return 1;
        } else {
            return _diaryArray.count +1;
        }
    } else {
        
        if(_goodsArray.count ==0 ) {
            return 1;
            
        } else {
            return _goodsArray.count+1;
        }
    }
}
#pragma mark - ----
static NSString *identifier = @"cell";

static NSString *identifier1 = @"theme";
static NSString *identifier2 = @"diary";
static NSString *identifier3 = @"hot";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //10-30
    
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if (indexPath.section == 0) {
        
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中高亮
        
        if (![_tehuiArray isEqual:@""] &&_tehuiArray!=nil && _tehuiArray.count!=0)
        {
            
            
            switch (_tehuiArray.count)
            {
                case 1:
                {
                    //12-21
                    DDQMainViewControllerModel *model_first  = [_tehuiArray objectAtIndex:0];
                    
                    NSString *image1 = model_first.simgString;
                    
                    NSAttributedString *string1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model_first.oldvalString]  attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
                    
                    UIView *view1 = [self createViewWithSaleNum:[NSString stringWithFormat:@"已售%@", model_first.sellout] image:image1 title:model_first.fnameString newPrice:[NSString stringWithFormat:@"￥%@", model_first.newvalString] oldPrice:string1 rect:CGRectMake(0,0,self.view.bounds.size.width*0.333,kScreenHeight*0.25) onView:cell.contentView];
                    
                    view1.tag  = 101;
                    
                    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToPreferenceDetailViewController:)];
                    
                    [view1 addGestureRecognizer:tap1];
                    
                    
                    [cell.contentView addSubview:view1];
                    
                    break;
                }
                case 2:
                {
                    DDQMainViewControllerModel *model_first  = [_tehuiArray objectAtIndex:0];
                    DDQMainViewControllerModel *model_second = [_tehuiArray objectAtIndex:1];
                    
                    NSString *image1 = model_first.simgString;
                    
                    NSAttributedString *string1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model_first.oldvalString]  attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
                    
                    UIView *view1 = [self createViewWithSaleNum:[NSString stringWithFormat:@"已售%@", model_first.sellout]
                                                          image:image1
                                                          title:model_first.fnameString
                                                       newPrice:[NSString stringWithFormat:@"￥%@", model_first.newvalString]
                                                       oldPrice:string1
                                                           rect:CGRectMake(0,0,self.view.bounds.size.width*0.333,kScreenHeight*0.25) onView:cell.contentView];
                    view1.tag  = 101;
                    
                    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToPreferenceDetailViewController:)];
                    
                    [view1 addGestureRecognizer:tap1];
                    
                    
                    [cell.contentView addSubview:view1];
                    
                    NSString *image2 = model_second.simgString;
                    
                    NSAttributedString *string2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model_second.oldvalString]
                                                                                  attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
                    
                    UIView *view2 = [self createViewWithSaleNum:[NSString stringWithFormat:@"已售%@", model_second.sellout]
                                                          image:image2
                                                          title:model_second.fnameString
                                                       newPrice:[NSString stringWithFormat:@"￥%@", model_second.newvalString]
                                                       oldPrice:string2
                                                           rect:CGRectMake(view1.frame.size.width+view1.frame.origin.x,
                                                                           0,
                                                                           self.view.bounds.size.width*0.333,
                                                                           kScreenHeight*0.25) onView:cell.contentView];
                    view2.tag = 102;
                    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToPreferenceDetailViewController:)];
                    
                    [view2 addGestureRecognizer:tap2];
                    [cell.contentView addSubview:view2];
                    
                    break;
                }
                case 3:
                {
                    DDQMainViewControllerModel *model_first  = [_tehuiArray objectAtIndex:0];
                    DDQMainViewControllerModel *model_second = [_tehuiArray objectAtIndex:1];
                    DDQMainViewControllerModel *model_third  = [_tehuiArray objectAtIndex:2];
                    

                    NSString *image1 = model_first.simgString;
                    
                    NSAttributedString *string1 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model_first.oldvalString]  attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
                    
                    UIView *view1 = [self createViewWithSaleNum:[NSString stringWithFormat:@"已售%@", model_first.sellout]
                                                          image:image1
                                                          title:model_first.fnameString
                                                       newPrice:[NSString stringWithFormat:@"￥%@", model_first.newvalString]
                                                       oldPrice:string1
                                                           rect:CGRectMake(0,0,self.view.bounds.size.width*0.333,kScreenHeight*0.25) onView:cell.contentView];
                    view1.tag  = 101;
                    
                    UITapGestureRecognizer *tap1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToPreferenceDetailViewController:)];
                    
                    [view1 addGestureRecognizer:tap1];
                    
                    
                    [cell.contentView addSubview:view1];

                    NSString *image2 = model_second.simgString;
                    
                    NSAttributedString *string2 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model_second.oldvalString]
                                                                                  attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
                    
                    UIView *view2 = [self createViewWithSaleNum:[NSString stringWithFormat:@"已售%@", model_second.sellout]
                                                          image:image2
                                                          title:model_second.fnameString
                                                       newPrice:[NSString stringWithFormat:@"￥%@", model_second.newvalString]
                                                       oldPrice:string2
                                                           rect:CGRectMake(view1.frame.size.width+view1.frame.origin.x,
                                                                           0,
                                                                           self.view.bounds.size.width*0.333,
                                                                           kScreenHeight*0.25) onView:cell.contentView];
                    view2.tag = 102;
                    UITapGestureRecognizer *tap2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToPreferenceDetailViewController:)];
                    
                    [view2 addGestureRecognizer:tap2];
                    [cell.contentView addSubview:view2];

                    NSString *image3 = model_third.simgString;
                    
                    NSAttributedString *string3 = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model_third.oldvalString] attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle)}];
                    
                    UIView *view3 = [self createViewWithSaleNum:[NSString stringWithFormat:@"已售%@", model_third.sellout]
                                                          image:image3
                                                          title:model_third.fnameString
                                                       newPrice:[NSString stringWithFormat:@"￥%@", model_third.newvalString]
                                                       oldPrice:string3
                                                           rect:CGRectMake(view2.frame.size.width +view2.frame.origin.x,
                                                                           0,
                                                                           self.view.bounds.size.width*0.333,
                                                                           kScreenHeight*0.25)
                                                         onView:cell.contentView];
                    view3.tag = 103;
                    
                    UITapGestureRecognizer *tap3 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pushToPreferenceDetailViewController:)];
                    
                    [view3 addGestureRecognizer:tap3];
                    
                    [cell.contentView addSubview:view3];
                    break;
                }
                default:
                    break;
            }
        }
        return cell;
        
    } else if (indexPath.section == 1) {
        DDQThemeActivityCell *themeCell = [tableView dequeueReusableCellWithIdentifier:@"theme"];
        if (!themeCell) {
            themeCell = [[DDQThemeActivityCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier1];
        }
        themeCell.backgroundColor = [UIColor myGrayColor];
        
        DDQMainViewControllerModel *model = _actArray[indexPath.row];
        themeCell.mVCModel = model;
        themeCell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中高亮
        return themeCell;
        //               return nil;
        
    } else if(indexPath.section ==2) {
        
        if ([indexPath row] ==_diaryArray.count) {
            UITableViewCell *moreCell= [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"morecell"];
            UILabel *moreLabel = [[UILabel alloc]init];
            
            moreLabel.frame = CGRectMake(kScreenWidth/2-40 ,0, 80, 44);
            moreLabel.text = @"查看更多";
            
            moreLabel.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1];
            [moreCell.contentView addSubview:moreLabel];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(moreLabel.frame.origin.x + moreLabel.frame.size.width , moreLabel.frame.size.height/3 , moreLabel.frame.size.height/3, moreLabel.frame.size.height/3)];
            imageView.image = [UIImage imageNamed:@"puss_load_more"];
            
            [moreCell.contentView addSubview:imageView];
            moreCell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中高亮
            
            return moreCell;
            
        } else {
            DDQGroupArticleModel *articleModel;
            if (_diaryArray.count != 0) {
                articleModel = [_diaryArray objectAtIndex:indexPath.row];
            };
            DDQDiaryViewCell *diaryCell = [[DDQDiaryViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier2];
            diaryCell.articleModel = articleModel;
            
            //10-30
            self.rowHeight  = diaryCell.newRect.size.height;
            
            diaryCell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中高亮
            diaryCell.backgroundColor = [UIColor myGrayColor];
            
            return diaryCell;
        }
        
    } else {
        
        if ([indexPath row] ==_goodsArray.count) {
            UITableViewCell *moreCell= [[UITableViewCell alloc]initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:@"morecell"];
            UILabel *moreLabel = [[UILabel alloc]init];
            
            moreLabel.frame = CGRectMake(kScreenWidth/2-70 ,0, 150, 44);
            moreLabel.text = @"查看特惠全部项目";
            
            moreLabel.textColor = [UIColor colorWithRed:147.0/255.0 green:147.0/255.0 blue:147.0/255.0 alpha:1];
            [moreCell.contentView addSubview:moreLabel];
            
            UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(moreLabel.frame.origin.x + moreLabel.frame.size.width , moreLabel.frame.size.height/3, moreLabel.frame.size.height/3, moreLabel.frame.size.height/3)];
            imageView.image = [UIImage imageNamed:@"puss_load_more"];
            
            [moreCell.contentView addSubview:imageView];
            moreCell.contentView.backgroundColor = [UIColor lightTextColor];

            return moreCell;
            
        } else {
            DDQMainHotProjectTableViewCell *hotCell = [tableView dequeueReusableCellWithIdentifier:identifier3];
            if (!hotCell) {
                hotCell = [[DDQMainHotProjectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier3];
            }
            hotCell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中高亮
            [hotCell setBackgroundColor:[UIColor myGrayColor]];
            
            DDQMainViewControllerModel *model1;
            if (self.goodsArray.count != 0) {
                model1 = _goodsArray[indexPath.row];
            }
            //10-30
            NSURL *url = [NSURL URLWithString:model1.simgString];
            
            [hotCell.modelImageView sd_setImageWithURL:url];
            //12-09
            hotCell.projectIntro.text = [NSString stringWithFormat:@"【%@】%@",model1.fnameString,model1.nameString];
            
            BOOL a = [DDQPublic isBlankString:model1.hname];
            if (a) {
                hotCell.projectHospital.text = @"暂无";
            } else {
                hotCell.projectHospital.text = model1.hname;
                
            }
            //10-30
            
            hotCell.sellNum.text = [NSString stringWithFormat:@"已售:%@", model1.sellout];
            hotCell.projectPrice.text =[NSString stringWithFormat:@"￥%@", model1.newvalString];
            
            NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model1.oldvalString] attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
            
            hotCell.oldPrice.attributedText = string;
            
            return hotCell;
        }
    }
}

//10-30
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
        
        if (kScreenHeight == 480) {
            
            return kScreenHeight*0.3;

        } else {
            
            return kScreenHeight*0.25;

        }
        
    } else if (indexPath.section == 1) {
        
        
        return kScreenHeight*0.35;
        
    } else if (indexPath.section ==2){
        
        if (indexPath.row ==_diaryArray.count) {
            
            return 44;
            
        } else {
            
            DDQGroupArticleModel *model;
    
            if ( _diaryArray.count > 0) {
                
                model = _diaryArray[indexPath.row];
                
            }
            
            if (model.imgArray.count == 0 ){//不传图的情况
                
                if ([model.introString isEqualToString:@""]) {//不传图还不传字
                    
                    return kScreenHeight *0.25 - h;

                } else {//有字，那就是帖子了
                
                    return kScreenHeight *0.25 + self.rowHeight - h;

                }
                
            } else {//传了图
            
                return self.rowHeight + kScreenHeight *0.5 - h;

            }
           
        }
        
    } else {
        
        if (indexPath.row ==_goodsArray.count) {
            
            return 44;
        } else {
            
            return kScreenHeight*0.2;
        }
        
    }
    
}
//10-30

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 70;
    } else {
        return 30;
    }
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 30)];
    sectionView.backgroundColor = [UIColor myGrayColor];
    if (section == 0) {
        
        self.firstLabel = [[UILabel alloc] init];
        [sectionView addSubview:self.firstLabel];
        [self.firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(sectionView.mas_centerY);
            make.left.equalTo(sectionView.mas_left).offset(15);
            make.height.equalTo(sectionView.mas_height).multipliedBy(0.5);
        }];
        [self.firstLabel setText:@"限时特惠"];
        [self.firstLabel setFont:[UIFont systemFontOfSize:15.0f]];
        
        UIButton *firstButton = [[UIButton alloc] init];
        [sectionView addSubview:firstButton];
        [firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(sectionView.mas_centerY);
            make.right.equalTo(sectionView.mas_right).offset(-10);
            make.height.equalTo(self.firstLabel.mas_height);
        }];
        [firstButton setTitle:@"更多>>" forState:UIControlStateNormal];
        [firstButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [firstButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        [firstButton addTarget:self action:@selector(pushToPreferenceViewController) forControlEvents:UIControlEventTouchDown];
        
    } else if (section == 1) {
        
        UILabel *label = [[UILabel alloc] init];
        [sectionView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(sectionView.mas_left).offset(10);
            make.centerY.equalTo(sectionView.mas_centerY);
            
        }];
        [label setText:@"热门活动"];
        [label setFont:[UIFont systemFontOfSize:15.0f]];
        
        
    } else if (section == 2) {
        
        UILabel *label = [[UILabel alloc] init];
        [sectionView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(sectionView.mas_left).offset(10);
            make.centerY.equalTo(sectionView.mas_centerY);
            
        }];
        [label setText:@"日记精选"];
        [label setFont:[UIFont systemFontOfSize:15.0f]];
        
    } else {
        
        UILabel *label = [[UILabel alloc] init];
        [sectionView addSubview:label];
        [label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(sectionView.mas_left).with.offset(self.view.bounds.size.width*0.01);
            make.top.equalTo(sectionView.mas_top).with.offset(10);
            make.bottom.equalTo(sectionView.mas_bottom).with.offset(-40);
            make.width.equalTo(sectionView.mas_width).with.multipliedBy(0.2);
        }];
        [label setText:@"热门项目"];
        [label setFont:[UIFont systemFontOfSize:15.0f]];
        
        //project
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, 40)];
        [sectionView addSubview:scrollView];
        [scrollView setBackgroundColor:[UIColor whiteColor]];
        scrollView.showsHorizontalScrollIndicator = NO;
        
        
        for(int i =0; i<_projectArray.count;i++) {
            
            
            UILabel *labelView = [[UILabel alloc ] init];
            DDQMainViewControllerModel *model = _projectArray[i];
            
            //为button显示赋值
            labelView.text = model.nameString;
            labelView.textColor = [UIColor whiteColor];
            labelView.textAlignment = 1;
            //设置button的大小
            labelView.frame = CGRectMake(100*i+10, 10, 100-20, 20);
            labelView.backgroundColor = [UIColor colorWithRed:140.0/255.0 green:221.0/255.0 blue:215.0/255.0 alpha:1];
            [scrollView addSubview:labelView];
            scrollView.contentSize = CGSizeMake(100*i+100, 40);
            
        }
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(gesturePushToPreferenceViewController)];
        [scrollView addGestureRecognizer:tapGesture];
        
    }
    return sectionView;
}

//10-30
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    DDQHeaderSingleModel *headerSingle = [DDQHeaderSingleModel singleModelByValue];
    if (indexPath.section == 1) {
        DDQThemeActivityViewController *themeActivityVC = [[DDQThemeActivityViewController alloc] init];
        themeActivityVC.hidesBottomBarWhenPushed = YES;
        //10-19
        DDQMainViewControllerModel *model = _actArray[indexPath.row];
        themeActivityVC.pid = model.pid;
        themeActivityVC.hid = model.hid;
        themeActivityVC.ImgURL = model.bimgString;
        
        [self.navigationController pushViewController:themeActivityVC animated:YES];
    } else
        //12-01,判断是否空
        if (indexPath.section == 2) {
            
            if ([_diaryArray count]== 0 ) {
                [self pushToGroupViewController];
            }
            else{
                
                if (indexPath.row ==_diaryArray.count) {
                    
                    [self pushToGroupViewController];
                }
                else{
                    DDQGroupArticleModel *articleModel = [self.diaryArray objectAtIndex:indexPath.row];
                    
                    DDQUserCommentViewController *commentVC = [[DDQUserCommentViewController alloc] init];
                    commentVC.hidesBottomBarWhenPushed = YES;
                    //赋值
                    headerSingle.ctime                      = articleModel.ctime;
                    headerSingle.articleId                  = articleModel.articleId;
                    headerSingle.userId                     = articleModel.userid;
                    [self.navigationController pushViewController:commentVC animated:YES];
                }
            }
            //12-01
        }
    
    //12-01,判断是否空
        else
            if (indexPath.section ==3)
            {
                if (_goodsArray.count == 0) {
                    [self pushToPreferenceViewController];
                }else
                {
                    
                    if (indexPath.row ==_goodsArray.count) {
                        [self pushToPreferenceViewController];
                    }
                    else{
                        
                        DDQMainViewControllerModel *model = _goodsArray[indexPath.row];
                        
                        DDQPreferenceDetailViewController *detailVC = [[DDQPreferenceDetailViewController alloc] initWithActivityID:model.IdString];
                        //10-30
                        detailVC.hidesBottomBarWhenPushed = YES;
                        
                        [self.navigationController pushViewController:detailVC animated:YES];
                    }
                }
            }
    
}
//10-30

#pragma mark - layout headerView functionButton
-(void)layoutNavigationBar {
    
    //拿到单例model
    DDQUserInfoModel *infoModel = [DDQUserInfoModel singleModelByValue];//这是登陆过后的data值
    
    if (infoModel.isLogin == YES) {
        
        if (![infoModel.userimg isEqualToString:@""]&&infoModel.userimg != nil) {//判断用户是否有头像
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:infoModel.userimg] placeholderImage:[UIImage imageNamed:@"default_pic"]];
            imageView.layer.cornerRadius     = 15.0f;
            imageView.contentMode            = UIImageResizingModeStretch;
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
            imageView.layer.cornerRadius     = 20.0f;
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
        leftItem.tintColor        = [UIColor whiteColor];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 30, 28)];
    [button setBackgroundImage:[UIImage imageNamed:@"xiao-xi"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(scanQRCode:) forControlEvents:UIControlEventTouchUpInside];
    
    //判断显不显示小椭圆
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"zanData"] || [[NSUserDefaults standardUserDefaults] valueForKey:@"replyData"]) {
        
        [button setBackgroundImage:[UIImage imageNamed:@"xiao-xi--tishi"] forState:UIControlStateNormal];
    }
    self.rightItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    self.navigationItem.rightBarButtonItem = self.rightItem;
    
    
     //10-16
//    [searchBar setImage:[UIImage imageNamed:@"chat_group_iconserch"] forSearchBarIcon:(UISearchBarIconSearch) state:(UIControlStateNormal)];
//    
//    searchBar.backgroundColor = [UIColor clearColor];
//    searchBar.searchBarStyle=UISearchBarStyleMinimal;
    
    //11-06

    
//    UITextField *textfield = [searchBar valueForKey:@"_searchField"];
//    [textfield setValue:[UIColor lightGrayColor] forKeyPath:@"_placeholderLabel.textColor"];
    
    self.navigationController.navigationBar.shadowImage = [[UIImage alloc] init];
}

//DDQ:12-21
-(void)changeReplyImage:(NSNotification *)notification {

    UIButton *button = self.rightItem.customView;

    UIImageView *cicrle_view = [[UIImageView alloc] init];
    [button addSubview:cicrle_view];
    [cicrle_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(button.mas_right);
        make.top.equalTo(button.mas_top);
        make.width.offset(5);
        make.height.offset(5);
    }];
    cicrle_view.image = [UIImage imageNamed:@"椭圆"];
}


-(void)layoutFunctionButton {
    
    self.currentView = [[UIView alloc] init];
    [self.headerView addSubview:self.currentView];
    [self.currentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.headerView.mas_left);
        make.right.equalTo(self.headerView.mas_right);
        make.bottom.equalTo(self.headerView.mas_bottom);
        if (kScreenWidth > 375) {
            make.height.offset(90);
            
        } else {
            make.height.offset(80);
            
        }
    }];

    [self.currentView setBackgroundColor:[UIColor whiteColor]];
    
    if (kScreenWidth>375) {
        
        self.mainScrollView = [[DDQLoopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.headerView.frame.size.height-90)];
        
    } else {
        
        self.mainScrollView = [[DDQLoopView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, self.headerView.frame.size.height-80)];
    }
    self.mainScrollView.delegate = self;
    [self.headerView addSubview:self.mainScrollView];

    CGFloat imgW;
    CGFloat imgH;
    if (kScreenWidth > 375) {
        imgW = 60;
        imgH = imgW;
    } else {
        imgW = 50;
        imgH = imgW;
    }
    /**
     内涵美
     */
    UIView *temp_viewone = [[UIView alloc] init];
    [self.currentView addSubview:temp_viewone];
    [temp_viewone mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(self.view.mas_width).multipliedBy(0.2 );
        make.left.equalTo(self.view.mas_left);
        make.height.equalTo(self.currentView.mas_height);
        make.top.equalTo(self.currentView.mas_top);
    }];
    
    self.neihanButton = [[UIButton alloc] init];
    [temp_viewone addSubview:self.neihanButton];
    [self.neihanButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(temp_viewone.mas_centerX);
        make.top.equalTo(temp_viewone.mas_top).offset(5);
        make.height.offset(imgW);
        make.width.offset(imgW);
    }];
    [self.neihanButton setImage:[UIImage imageNamed:@"内涵美"] forState:UIControlStateNormal];
    [self.neihanButton addTarget:self action:@selector(goTeacherListVCMethod:) forControlEvents:UIControlEventTouchDown];
    
    UILabel *neihanLabel = [[UILabel alloc] init];//创建一个label显示这个button的作用
    [self.currentView addSubview:neihanLabel];
    [neihanLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.neihanButton.mas_centerX);
        make.top.equalTo(self.neihanButton.mas_bottom).with.offset(5);//y
        make.height.offset(20);//h
    }];//加约束
    [neihanLabel setText:@"内涵美"];
    [neihanLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [neihanLabel setTextAlignment:1];
    [neihanLabel setTextAlignment:NSTextAlignmentCenter];
    
    /**
     精品日记
     */
    UIView *temp_viewtwo = [[UIView alloc] init];
    [self.currentView addSubview:temp_viewtwo];
    [temp_viewtwo mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(temp_viewone.mas_width);
        make.left.equalTo(temp_viewone.mas_right);
        make.height.equalTo(self.currentView.mas_height);
        make.top.equalTo(self.currentView.mas_top);
    }];
    
    self.jinpinButton = [[UIButton alloc] init];
    [temp_viewtwo  addSubview:self.jinpinButton];
    [self.jinpinButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(temp_viewtwo.mas_centerX);
        make.top.equalTo(temp_viewtwo.mas_top).offset(5);
        make.height.offset(imgW);
        make.width.offset(imgW);
    }];
    
    [self.jinpinButton setImage:[UIImage imageNamed:@"精品日记"] forState:UIControlStateNormal];
    [self.jinpinButton addTarget:self action:@selector(pushToJinDiaryVC) forControlEvents:UIControlEventTouchDown];
    
    UILabel *jinpinLabel = [[UILabel alloc] init];//创建一个label显示这个button的作用
    [self.currentView addSubview:jinpinLabel];
    [jinpinLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.jinpinButton.mas_centerX);
        make.top.equalTo(self.jinpinButton.mas_bottom).with.offset(5);//y
        make.height.offset(20);//h
    }];//加约束
    [jinpinLabel setText:@"精品日记"];
    [jinpinLabel setFont:[UIFont systemFontOfSize:13.0f]];
    [jinpinLabel setTextAlignment:NSTextAlignmentCenter];
    
    
    /**
     签到
     */
    UIView *temp_viewthree = [[UIView alloc] init];
    [self.currentView addSubview:temp_viewthree];
    [temp_viewthree mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(temp_viewtwo.mas_width);
        make.left.equalTo(temp_viewtwo.mas_right);
        make.height.equalTo(self.currentView.mas_height);
        make.top.equalTo(self.currentView.mas_top);
    }];
    
    self.qiandao_button = [[UIButton alloc] init];
    [temp_viewthree addSubview:self.qiandao_button];
    [self.qiandao_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(temp_viewthree.mas_centerX);
        make.centerY.equalTo(temp_viewthree.mas_centerY);
        make.height.offset(imgW);
        make.width.offset(imgW);
    }];
    //10-19
    [self.qiandao_button addTarget:self action:@selector(qiandaoMethod) forControlEvents:(UIControlEventTouchUpInside)];
    
    /**
     整容宝
    */
    UIView *temp_viewfour = [[UIView alloc] init];
    [self.currentView addSubview:temp_viewfour];
    [temp_viewfour mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(temp_viewthree.mas_width);
        make.left.equalTo(temp_viewthree.mas_right);
        make.height.equalTo(self.currentView.mas_height);
        make.top.equalTo(self.currentView.mas_top);
    }];
    
    self.zhengrongButton = [[UIButton alloc] init];
    [temp_viewfour addSubview:self.zhengrongButton];
    [self.zhengrongButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(temp_viewfour.mas_centerX);
        make.top.equalTo(temp_viewfour.mas_top).offset(5);
        make.height.offset(imgW);
        make.width.offset(imgW);
    }];
    [self.zhengrongButton setImage:[UIImage imageNamed:@"cosmetic"] forState:UIControlStateNormal];
    [self.zhengrongButton addTarget:self action:@selector(pushToZRBViewController) forControlEvents:(UIControlEventTouchUpInside)];

    UILabel *find_label = [[UILabel alloc] init];//创建一个label显示这个button的作用
    [self.currentView addSubview:find_label];
    [find_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.zhengrongButton.mas_centerX);
        //        make.width.equalTo(self.zhengrongButton.mas_width).with.offset(20);//w
        make.top.equalTo(self.zhengrongButton.mas_bottom).offset(5);//y
        make.height.offset(20);//h
    }];//加约束
    [find_label setText:@"整容宝"];
    [find_label setFont:[UIFont systemFontOfSize:13.0f]];
    [find_label setTextAlignment:NSTextAlignmentCenter];

    
    /**
     查项目
     */
    UIView *temp_viewfive = [[UIView alloc] init];
    [self.currentView addSubview:temp_viewfive];
    [temp_viewfive mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.equalTo(temp_viewfour.mas_width);
        make.left.equalTo(temp_viewfour.mas_right);
        make.height.equalTo(self.currentView.mas_height);
        make.top.equalTo(self.currentView.mas_top);
    }];

    self.chaButton = [[UIButton alloc] init];
    [temp_viewfive addSubview:self.chaButton];
    [self.chaButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(temp_viewfive.mas_centerX);
        make.top.equalTo(temp_viewfive.mas_top).offset(5);
        make.height.offset(imgW);
        make.width.offset(imgW);
    }];
    [self.chaButton setImage:[UIImage imageNamed:@"search"] forState:UIControlStateNormal];
    [self.chaButton addTarget:self action:@selector(pushToCheckViewController) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel *lesson_label = [[UILabel alloc] init];//创建一个label显示这个button的作用
    [self.currentView addSubview:lesson_label];
    [lesson_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.chaButton.mas_centerX);
        make.top.equalTo(self.chaButton.mas_bottom).offset(5);//y
        make.height.offset(20);//h
    }];//加约束
    [lesson_label setText:@"查项目"];
    [lesson_label setFont:[UIFont systemFontOfSize:13.0f]];
    [lesson_label setTextAlignment:NSTextAlignmentCenter];
}
-(void)viewDidDisappear:(BOOL)animated {

    [super viewDidDisappear:animated];
    isHidden = NO;
}

-(void)goTeacherListVCMethod:(UIButton *)button {

    DDQTeacherListViewController *listVC = [DDQTeacherListViewController new];
    listVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:listVC animated:NO];
}

//11-06
#pragma mark - searchbar for delegate
//- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
//{
//    [searchBar resignFirstResponder];
//    DDQMainSearchViewController *detailView = [[DDQMainSearchViewController alloc]init];
//    
//    detailView.hidesBottomBarWhenPushed = YES;
//    //12-04
//    [self.navigationController pushViewController:detailView animated:NO];   
//    return YES;
//}
- (void)searchBarBegainEditing:(NSString *)text {

    DDQMainSearchViewController *detailView = [[DDQMainSearchViewController alloc]init];
    
    detailView.hidesBottomBarWhenPushed = YES;
    //12-04
    [self.navigationController pushViewController:detailView animated:YES];
}
#pragma mark - button and gesture target action
//button
- (void)qiandaoMethod {
        
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求特惠列表
        NSString *spellString = [SpellParameters getBasePostString];
        NSString *poststr = [NSString stringWithFormat:@"%@*%@",spellString,[[NSUserDefaults standardUserDefaults] valueForKey:@"userId"]];
        //加密
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_String = [postEncryption stringWithPost:poststr];
        
        //接受字典
        NSMutableDictionary *get_postDic = [[PostData alloc] postData:post_String AndUrl:kQD_Url];
        
        NSString *str = get_postDic[@"errorcode"];
        int num = [str intValue];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (num == 0) {
                
                NSString *jifen = [postEncryption stringWithDic:get_postDic];
                [self.qiandao_button setBackgroundImage:[UIImage imageNamed:@"已签到"] forState:UIControlStateNormal];
                
                DDQQiandaoView *qiandao_view = [[DDQQiandaoView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight)];
                qiandao_view.delegate = self;
                qiandao_view.huodefenshu.text = [NSString stringWithFormat:@"恭喜获得积分:+%@",jifen];
                [[UIApplication sharedApplication].keyWindow addSubview:qiandao_view];
                
            } else if (num == 13){
                [self alertController:@"今日已签到"];
            } else if (num == 15) {
                [self alertController:@"签到失败请重试"];
            } else if (num == 11 || num == 12) {
                
                [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"userId"];
                [UIApplication sharedApplication].keyWindow.rootViewController = [DDQLoginViewController new];
                
            } else {
                [self alertController:@"服务器繁忙"];
            }
        });
        
    });
}

- (void)qiandao_view:(DDQQiandaoView *)view {
    
    [view removeFromSuperview];
}

- (void)qiandao_viewSelected:(DDQQiandaoView *)view {
    
    [view removeFromSuperview];
    DDQMyWalletViewController *myWallet = [DDQMyWalletViewController new];
    myWallet.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:myWallet animated:YES];
}

-(void)pushToCheckViewController {
    DDQCheckViewController *checkVC = [[DDQCheckViewController alloc] init];
    checkVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:checkVC animated:YES];
}

-(void)pushToPreferenceViewController {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change" object:nil userInfo:@{@"firstname":@"more1"}];
}

-(void)gesturePushToPreferenceViewController {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"change1" object:nil userInfo:@{@"secondname":@"more2"}];
}
-(void)pushToGroupViewController
{
    [[NSNotificationCenter defaultCenter]postNotificationName:@"changeGroup" object:nil userInfo:@{@"beautiful":@"morebeautiful"}];
}
-(void)pushToZRBViewController {
    DDQZRBViewController *ZRBVC = [[DDQZRBViewController alloc] init];
    ZRBVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ZRBVC animated:YES];
}

-(void)pushToJinDiaryVC {

    DDQJinDiaryViewController *jin_diaryVC = [DDQJinDiaryViewController new];
    jin_diaryVC.hidesBottomBarWhenPushed = YES;

    [self.navigationController pushViewController:jin_diaryVC animated:YES];
}
//10-19
//10-30
//gesture
#pragma mark - 限时特惠点击
-(void)pushToPreferenceDetailViewController:(id)sender
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    
    NSString *pid = [[NSString alloc]init];
    
    switch ([singleTap view].tag) {
        case 101:
        {
            DDQMainViewControllerModel *model = [[DDQMainViewControllerModel alloc]init];
            
            model = [_tehuiArray objectAtIndex:0];
            
            pid= model.IdString;
            
            break;
        }
        case 102:{
            DDQMainViewControllerModel *model = [[DDQMainViewControllerModel alloc]init];
            
            model = [_tehuiArray objectAtIndex:1];
            
            pid = model.IdString;
            
            
            break;
        }
        case 103:
        {
            DDQMainViewControllerModel *model = [[DDQMainViewControllerModel alloc]init];
            
            model = [_tehuiArray objectAtIndex:2];
            
            pid = model.IdString;
            
            break;
        }
            
            
        default:
            
            
            break;
    }
    DDQPreferenceDetailViewController *preferenceDetailVC = [[DDQPreferenceDetailViewController alloc] initWithActivityID:pid];
    
    preferenceDetailVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:preferenceDetailVC animated:NO];
}
#pragma mark - navigationBar item target aciton
-(void)pushToLoginViewController {
    //个人中心
    
    DDQLoginViewController *loginVC  = [[DDQLoginViewController alloc] init];
    loginVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:loginVC animated:NO];
}

-(void)pushToMineViewController {
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"minechange" object:nil userInfo:@{@"mine":@"mine"}];
}

//10-19聊天
-(void)scanQRCode:(UIButton *)button {
    
    for (UIView *view in button.subviews) {
        [view removeFromSuperview];
    }
    
    DDQMessageViewController *message_vc = [[DDQMessageViewController alloc] init];
    message_vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:message_vc animated:YES];
    
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
//12-21
-(UIView *)createViewWithSaleNum:(NSString *)cellNum image:(NSString *)image title:(NSString *)title newPrice:(NSString *)newPrice oldPrice:(NSAttributedString *)oldPrice rect:(CGRect)rect onView:(UIView *)view{
    
    //设一个载体view
    UIView *supportView = [[UIView alloc] initWithFrame:rect];
    [view addSubview:supportView];
    
    [supportView setBackgroundColor:[UIColor whiteColor]];
    
    UIImageView *imageView = [[UIImageView alloc] init];
    [supportView addSubview:imageView];
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(supportView.mas_left).offset(5);
        make.top.equalTo(supportView.mas_top).offset(5);
        make.width.mas_equalTo(rect.size.width - 10);
        make.height.mas_equalTo(imageView.mas_width);

    }];
    //12-21
    [imageView sd_setImageWithURL:[NSURL URLWithString:image] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    
    UILabel *label = [[UILabel alloc] init];
    [supportView addSubview:label];
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(imageView.mas_right);
        make.top.equalTo(imageView.mas_top).offset(2);
        
    }];
    
    [label setTextColor:[UIColor whiteColor]];
    [label setText:cellNum];
    [label setFont:[UIFont systemFontOfSize:13.0f]];
    [label setTextAlignment:NSTextAlignmentRight];
    
    UILabel *secondLabel = [[UILabel alloc] init];
    [supportView addSubview:secondLabel];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(imageView.mas_centerX);
        make.top.equalTo(imageView.mas_bottom);
        
    }];
    
    [secondLabel setTextAlignment:1];
    [secondLabel setText:title];
    [secondLabel setTextColor:[UIColor lightGrayColor]];
    [secondLabel setFont:[UIFont systemFontOfSize:15.0f]];
    
    UILabel *priceLabel = [[UILabel alloc] init];
    [supportView addSubview:priceLabel];
    [priceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.right.equalTo(imageView.mas_centerX);
        make.top.equalTo(secondLabel.mas_bottom).with.offset(5);
        
    }];
    [priceLabel setTextColor:[UIColor colorWithRed:231.0/255.0 green:163.0/255.0 blue:33.0/255.0 alpha:1]];
    [priceLabel setText:newPrice];
    [priceLabel setFont:[UIFont systemFontOfSize:14.0f]];
    
    UILabel *oldLabel = [[UILabel alloc] init];
    [supportView addSubview:oldLabel];
    [oldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(priceLabel.mas_right).offset(6);
        make.bottom.equalTo(priceLabel.mas_bottom);
        
    }];
    [oldLabel setTextColor:[UIColor colorWithRed:149.0/255.0 green:149.0/255.0 blue:149.0/255.0 alpha:1]];
    [oldLabel setAttributedText:oldPrice];
    [oldLabel setTextAlignment:NSTextAlignmentLeft];
    [oldLabel setFont:[UIFont systemFontOfSize:11.0f]];
    return supportView;
}
@end
