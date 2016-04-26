//
//  DDQPreferenceViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/6.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQPreferenceViewController.h"
#import "DDQThemeActivityViewController.h"
#import "DDQFirstSectionViewController.h"
#import "DDQSecondSectionViewController.h"
#import "DDQScreenProjectViewController.h"
#import "DDQSecondSectionViewItem.h"
#import "DDQLoginViewController.h"
#import "DDQMineViewController.h"

#import "DDQThemeActivityCell.h"
#import "DDQProjectViewCell.h"
#import "DDQFirstSectionViewItem.h"

#import "TypesModel.h"
#import "ListModel.h"

#import "DDQMineViewController.h"
#import "DDQUserInfoModel.h"


@interface DDQPreferenceViewController ()<MBProgressHUDDelegate>

@property (strong,nonatomic) UITableView *mainTableView;

@property (strong,nonatomic) DDQFirstSectionViewController *firstSectionController;
@property (strong,nonatomic) DDQSecondSectionViewController *secondSectionControler;
@property (strong,nonatomic)NSMutableArray *typesArray;
@property (strong,nonatomic)NSMutableArray *nameArray;
@property (strong,nonatomic)NSMutableArray *array;
//ty数组
@property (strong,nonatomic)NSMutableArray *tArray;

//list
@property (strong,nonatomic)NSMutableArray *act_fitst_array;
@property (strong,nonatomic) NSMutableArray *act_list;
//分区一的属性
@property (copy,nonatomic) NSString *bimg;
@property (copy,nonatomic) NSString *fname;
@property (copy,nonatomic) NSString *name;
@property (copy,nonatomic) NSString *simg;

@property (strong,nonatomic)UICollectionView *myCollectionView;
@property (strong,nonatomic)UICollectionView *myCollectionView1;
@property (strong,nonatomic)UIScrollView *scroll;
@property (strong,nonatomic)UIView *bgView;
//用户传递id
@property (copy,nonatomic)NSString *types_id;
//用于传递name
@property (copy,nonatomic)NSString *types_name;
//头视图跳
@property (nonatomic,copy)NSString *hid;
@property (nonatomic,copy)NSString *pid;
//已有多少人参加
@property (nonatomic,copy)NSString *amount;
//存放用户头像的数组
@property (nonatomic,strong)NSMutableArray *UserArray;

@property (nonatomic,strong)NSMutableArray *QArray;
@property (nonatomic ,strong)MBProgressHUD *hud;

@end

@implementation DDQPreferenceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"特惠";
    self.view.backgroundColor = [UIColor myGrayColor];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    //10-30
    NSDictionary * dict = @{NSForegroundColorAttributeName:[UIColor meiHongSe]};
    self.navigationController.navigationBar.titleTextAttributes = dict;
    self.navigationController.navigationBar.tintColor  = [UIColor meiHongSe];
    
    _typesArray      = [NSMutableArray new];
    _nameArray       = [NSMutableArray new];
    _array = [NSMutableArray new];
    _act_fitst_array = [NSMutableArray new];
    _act_list        = [NSMutableArray new];
    _UserArray       = [NSMutableArray new];
    _QArray          = [NSMutableArray new];
    
    _hud = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:_hud];
    [self.hud show:YES];
    self.hud.detailsLabelText = @"加载中...";
    
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            [self asyProductList];
            
        } else {
            
            [self.hud hide:YES];
            //第一个参数:添加到谁上
            //第二个参数:显示什么提示内容
            //第三个参数:背景阴影
            //第四个参数:设置是否消失
            //第五个参数:设置自定义的view
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
    
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    [self layOutNavigationBar];
  
}

-(void)layOutNavigationBar {
    //拿到单例model
    DDQUserInfoModel *infoModel = [DDQUserInfoModel singleModelByValue];//这是登陆过后的data值
    
    if (infoModel.isLogin == YES) {
        
        if (![infoModel.userimg isEqualToString:@""]&&infoModel.userimg != nil) {//判断用户是否有头像
            
            UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 30, 30)];
            
            [imageView sd_setImageWithURL:[NSURL URLWithString:infoModel.userimg]];
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
        //11-06
        leftItem.tintColor        = [UIColor meiHongSe];
        
        self.navigationItem.leftBarButtonItem = leftItem;
    }
    
}

#pragma mark - navigationBar item target aciton
-(void)pushToLoginViewController {

}

-(void)pushToMineViewController {
    DDQMineViewController *mineVC = [[DDQMineViewController alloc] init];
    mineVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:mineVC animated:YES];
}

#pragma mark - 网络相关
static BOOL isFresh = NO;
-(void)asyProductList {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        //请求特惠列表
        NSString *spellString = [SpellParameters getBasePostString];
        //加密
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
        NSString *post_String = [postEncryption stringWithPost:spellString];
        //接受字典
        NSMutableDictionary *get_postDic = [[PostData alloc] postData:post_String AndUrl:kTeHuiListUrl];
        //11-30-15 判断是否成功
        if([[get_postDic objectForKey:@"errorcode"]intValue]==0 && get_postDic !=nil)
        {
            //12-21
            NSDictionary *get_Dic = [DDQPOSTEncryption judgePOSTDic:get_postDic];
            NSDictionary *get_JsonDic = [DDQPublic nullDic:get_Dic];
            
            NSMutableDictionary *firstArray = [get_JsonDic objectForKey:@"act_first"];
            _tArray = [get_JsonDic objectForKey:@"types"];
            NSMutableArray *act = [get_JsonDic objectForKey:@"act_list"];
            //表视图
    //                for (NSDictionary *dic in firstArray) {
                        _amount = [firstArray objectForKey:@"amount"];
                        _bimg = [firstArray objectForKey:@"bimg"];
                        _fname = [firstArray objectForKey:@"fname"];
                        _hid = [firstArray objectForKey:@"hid"];
                        _name = [firstArray objectForKey:@"name"];
                        _pid = [firstArray objectForKey:@"pid"];
                        _simg = [firstArray objectForKey:@"simg"];
            NSMutableArray *userArr = [firstArray objectForKey:@"yyuser"];

            
            //用户头像
                    for (NSDictionary *dic in userArr) {
                        NSString *userid = [dic objectForKey:@"userid"];
                        NSString *userimg = [dic objectForKey:@"userimg"];
                        NSMutableArray *addArray = [NSMutableArray arrayWithObjects:userid,userimg, nil];
                        [_UserArray addObject:addArray];
                    }
            
            //act_list
            for (NSDictionary *dic in act) {
                
                
                ListModel *model = [[ListModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_act_list addObject:model];
            }

            //特惠列表
            for (NSDictionary *dic in _tArray) {
                NSString *str = [dic objectForKey:@"name"];
                [_nameArray addObject:str];
                
                TypesModel *model = [[TypesModel alloc]init];
                [model setValuesForKeysWithDictionary:dic];
                [_typesArray addObject:model];
                
            }
            if (_nameArray.count>=7) {
                NSArray *arr = [_nameArray objectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 7)]];
                for (NSString *str in arr) {
                    [_array addObject:str];
                }
                [_array addObject:@"更多"];
            }else
            {
                for (NSString *str in _nameArray) {
                    [_QArray addObject:str];
                }
            }
            //把这个数组添加到单利数组里面
            Singleton *model = [Singleton sharedDataTool];
            //判断特惠是否为空
            if (model.TH_TypesArray.count == 0 && model.TH_TypesNameArray.count==0) {
                [model.TH_TypesArray addObject:_tArray];
                [model.TH_TypesNameArray addObject:_nameArray];
            }else
            {
                //添加所有属性
                [model.TH_TypesArray removeAllObjects];
                [model.TH_TypesArray addObject:_tArray];
                //名字用于显示
                [model.TH_TypesNameArray removeAllObjects];
                [model.TH_TypesNameArray addObject:_nameArray];
            }

            

            dispatch_async(dispatch_get_main_queue(), ^{
    //            [self.mainTableView reloadData];
                [self.hud hide:YES];
                [self.myCollectionView reloadData];
                [self.myCollectionView1 reloadData];
                if (isFresh == NO) {
                    [self initTableView];
                    isFresh = YES;
                }

            });
        }
        else
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [self.hud hide:YES];
                UIImageView *imageView = [[UIImageView alloc]initWithFrame:self.view.bounds];
                
                imageView.image = [UIImage imageNamed:@"美女啊"];
                
                
                [self.view addSubview:imageView];
            });
        }
        //11-30-15

    });
}
#pragma mark - tableView
-(void)initTableView {
    //取余进位
    int geshu = 0;
    if(_act_list.count % 2 == 0){
        geshu = (int)_act_list.count / 2;
    }else{
        geshu = (int)(_act_list.count + 1) / 2;
    }
    
    float height = kScreenHeight*0.15*geshu + kScreenHeight*0.64;
    
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0,kScreenWidth,kScreenHeight-64)];
    _scroll.contentSize = CGSizeMake(kScreenWidth, height+49);
    _scroll.delegate = self;
    [self.view addSubview:_scroll];
    [self refresh];

    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.3)];
    [imgView sd_setImageWithURL:[NSURL URLWithString:_bimg] ];
//    imgView.backgroundColor = [UIColor redColor];
    [_scroll addSubview:imgView];
    imgView.userInteractionEnabled=YES;
    UITapGestureRecognizer *Tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(titleImg)];
    [imgView addGestureRecognizer:Tap1];

    
    
    UILabel *zhuti = [[UILabel alloc]initWithFrame:CGRectMake(kScreenWidth*0.01, kScreenHeight*0.01, kScreenWidth*0.4, kScreenHeight*0.04)];
    zhuti.text = @"主题";
    zhuti.textColor = [UIColor whiteColor];
    [imgView addSubview:zhuti];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, kScreenHeight*0.25, kScreenWidth, kScreenHeight*0.05)];
    view1.backgroundColor = [UIColor blackColor];
    view1.alpha = 0.1;
    [imgView addSubview:view1];
    
    ///////
    //计算最后的距离
    CGFloat allWith = 0;
    CGFloat jiange = kScreenWidth * 0.01;
    for (int i = 0; i<_UserArray.count; i++) {
        
        //获取下img
        NSString *URLStr = [_UserArray[i] objectAtIndex:1];
        
        UIImageView *img = [[UIImageView alloc]init];
        [img sd_setImageWithURL:[NSURL URLWithString:URLStr] placeholderImage:[UIImage imageNamed:@"default_pic"]];
        img.frame = CGRectMake(kScreenWidth*0.02 + i * kScreenHeight*0.04 +jiange * i, kScreenHeight*0.257, kScreenHeight*0.04, kScreenHeight*0.04);
//        img.backgroundColor = [UIColor redColor];
        img.layer.masksToBounds = YES;
        img.layer.cornerRadius = kScreenHeight*0.02;
        img.tag = i;
        [imgView addSubview:img];
        img.userInteractionEnabled=YES;
        UITapGestureRecognizer *Tap1 =[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(userImg:)];
        UIView *sing = [Tap1 view];
        sing.tag = i;
        [img addGestureRecognizer:Tap1];
        allWith  +=  jiange * i;
    }
    allWith += kScreenHeight*0.04 * _UserArray.count + kScreenWidth*0.03;
//    allWith, kScreenHeight*0.25, kScreenWidth-allWith,kScreenHeight*0.05
    UILabel *promptLB = [[UILabel alloc]initWithFrame:CGRectMake(allWith, kScreenHeight*0.25, kScreenWidth-allWith,kScreenHeight*0.05)];
    promptLB.text = [NSString stringWithFormat:@"已有%@人参加",_amount];
    promptLB.textColor = [UIColor whiteColor];
    promptLB.font = [UIFont boldSystemFontOfSize:13];
    [imgView addSubview:promptLB];
    
    
    
    //列表
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    self.myCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kScreenHeight*0.32, kScreenWidth, kScreenHeight*0.3) collectionViewLayout:layout];
    [self.myCollectionView setDelegate:self];
    [self.myCollectionView setDataSource:self];
    [self.myCollectionView setBackgroundColor:[UIColor whiteColor]];
    [self.myCollectionView setShowsVerticalScrollIndicator:NO];
    [self.myCollectionView registerClass:[DDQFirstSectionViewItem class] forCellWithReuseIdentifier:@"cell"];
    [_scroll addSubview:self.myCollectionView];

    //
    UICollectionViewFlowLayout *layout1 = [[UICollectionViewFlowLayout alloc] init];
    self.myCollectionView1 = [[UICollectionView alloc] initWithFrame:CGRectMake(0, kScreenHeight*0.64, kScreenWidth, kScreenHeight*0.15*geshu) collectionViewLayout:layout1];
    [self.myCollectionView1 setDelegate:self];
    [self.myCollectionView1 setDataSource:self];
    [self.myCollectionView1 setBackgroundColor:[UIColor whiteColor]];
    [self.myCollectionView1 setShowsVerticalScrollIndicator:NO];
    [self.myCollectionView1 registerClass:[DDQSecondSectionViewItem class] forCellWithReuseIdentifier:@"cell"];
    [_scroll addSubview:self.myCollectionView1];

}


#pragma mark - collectionView Delegate And DataSource
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if ([collectionView isEqual:_myCollectionView]) {
        if (_typesArray.count<=6) {
            return _typesArray.count;
        }else
        {
            return 8;
        }
    }else{
        
        return _act_list.count;
    }
    
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([collectionView isEqual:_myCollectionView]) {
        return CGSizeMake(kScreenWidth*0.25, kScreenHeight*0.15);
    }else{
        return CGSizeMake(kScreenWidth*0.5, kScreenHeight*0.15);
    }
    
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;

}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    
    if ([collectionView isEqual:_myCollectionView]) {
        DDQFirstSectionViewItem *firstItem = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];

        if (_typesArray.count<=6) {
            
            [firstItem.positionLabel setText:[_QArray objectAtIndex:indexPath.row]];

            return firstItem;
        }else
        {
            [firstItem.positionLabel setText:[_array objectAtIndex:indexPath.row]];
            return firstItem;
        }
    }else{
        DDQSecondSectionViewItem *secondCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        ListModel *model = [_act_list objectAtIndex:indexPath.row];
        secondCell.model = model;
        return secondCell;
    }
    
    
    
    
}
-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Singleton *Datamodel = [Singleton sharedDataTool];
    
    if ([collectionView isEqual:_myCollectionView]) {
        DDQScreenProjectViewController *screenProjectVC = [[DDQScreenProjectViewController alloc] init];
        screenProjectVC.hidesBottomBarWhenPushed = YES;

        if (_typesArray.count<=6)
        {
            TypesModel *model = [_typesArray objectAtIndex:indexPath.row];
            screenProjectVC.ID = model.ID;
            screenProjectVC.Name = model.name;
            
            if (Datamodel.CellName ==nil) {
                Datamodel.CellName = model.name;
            }else{
                Datamodel.CellName = @"";
                Datamodel.CellName = model.name;
            }
            Datamodel.CellID = [NSString stringWithFormat:@"%@",model.ID];
            
            [self.navigationController pushViewController:screenProjectVC animated:YES];
        }
        else
        {
            NSString *str = [_array objectAtIndex:indexPath.row];
            for (int i = 0; i<_tArray.count; i++) {
                if ([str isEqualToString:[_tArray[i] objectForKey:@"name"]]) {
                    _types_id = [_tArray[i] objectForKey:@"id"];
                }

            }
                Datamodel.CellName = str;
                Datamodel.CellID = _types_id;
            screenProjectVC.Name = Datamodel.CellName;
            [self.navigationController pushViewController:screenProjectVC animated:YES];
        }

    }else{
        
        DDQThemeActivityViewController *activityVC = [[DDQThemeActivityViewController alloc] init];
        ListModel *model = [_act_list objectAtIndex:indexPath.row];
        activityVC.hid = model.act_list_hid;
        activityVC.pid = model.act_list_pid;
        activityVC.ImgURL = model.act_list_simg;
        activityVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:activityVC animated:YES];

    }
    
}

-(void)leftitem
{
    
    DDQMineViewController *ddqmainVC = [[DDQMineViewController alloc]init];
    ddqmainVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:ddqmainVC animated:YES];
    
    
    
}

-(void)titleImg
{
    DDQThemeActivityViewController *themeVC = [[DDQThemeActivityViewController alloc] init];
    themeVC.hid = _hid;
    themeVC.pid = _pid;
    themeVC.ImgURL = _bimg ;

    [self.navigationController pushViewController:themeVC animated:YES];

}
//用户头像点击事件
-(void)userImg:(id)sender
{
    UITapGestureRecognizer *singleTap = (UITapGestureRecognizer *)sender;
    NSInteger tag = [singleTap view].tag;
    for (int i = 0; i<_UserArray.count; i++) {
        if (tag == i) {
            NSString *userid = [_UserArray[i] objectAtIndex:0];
            //可以写点击事件
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:userid message:nil delegate:sender cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
            [alert show];
        }
    }
    
    
}


//下拉刷新
- (void)refresh
{
    
    // 下拉刷新
    self.scroll.header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //再次请求接口先判断数组是否为nil
        [_typesArray removeAllObjects];
        [_nameArray removeAllObjects];
        [_array removeAllObjects];
        [_act_fitst_array removeAllObjects];
        [_act_list removeAllObjects];
        [_UserArray removeAllObjects];
        [_QArray removeAllObjects];
//        [_scroll removeFromSuperview];
//
        [self asyProductList];
        // 结束刷新
        [self.scroll.header endRefreshing];
    }];
    
}

@end
