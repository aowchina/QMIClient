//
//  DDQProjectDetailViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/6.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//
#define WIDTH ([UIScreen mainScreen].bounds.size.width)
#define HEIGHT ([UIScreen mainScreen].bounds.size.height)

#import "DDQProjectDetailViewController.h"
#import "DDQThemeActivityViewController.h"
#import "DDQDetailControllerProjectCell.h"
#import "DDQDetailControllerCell.h"
#import "DDQHotProjectViewCell.h"

//12-09
#import "DDQMainViewControllerModel.h"//gods数据源
#import "DDQMainHotProjectTableViewCell.h"//自定义cell

//12-17
#import "DDQPreferenceDetailViewController.h"

@interface DDQProjectDetailViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (strong,nonatomic) UITableView *mainTableView;
@property (strong,nonatomic) NSString *falseData;
/**
 *  详情按钮
 */
@property (strong,nonatomic) UIButton *descriptionButton;
/**
 *  日记按钮
 */
@property (strong,nonatomic) UIButton *diaryButton;
/**
 *  记录标题label的高
 */
@property (assign,nonatomic) NSInteger titleLabelHeight;

@property (nonatomic,copy)NSString *sfzy;
@property (nonatomic,strong)UIScrollView *scroll;
@property (nonatomic,strong)NSMutableArray *listArray;

//用于接收传过来的值
@property (nonatomic,copy)NSString *project_Id;
@property (nonatomic,copy)NSString *str1;
@property (nonatomic,copy)NSString *str2;
@property (nonatomic,copy)NSString *str3;
@property (nonatomic,copy)NSString *str4;
@property (nonatomic,copy)NSString *str5;
@property (nonatomic,copy)NSString *str6;
@property (nonatomic,copy)NSString *str7;
@property (nonatomic,copy)NSString *str8;
@property (nonatomic,copy)NSString *str9;
@property (nonatomic,copy)NSString *str10;
@property (nonatomic,copy)NSString *str11;
@property (nonatomic,copy)NSString *str12;
@property (nonatomic,copy)NSString *str13;
@property (nonatomic,copy)NSString *str14;
@property (nonatomic,copy)NSString *str15;
@property (nonatomic,copy)NSString *str16;
@property (nonatomic,copy)NSString *str17;

@property (nonatomic,strong)UILabel *neirong;
@property (nonatomic,strong)UILabel *jiage1;
@property (nonatomic,strong)UILabel *fengxian1;
@property (nonatomic,strong)UILabel *chixu1;
@property (nonatomic,strong)UILabel *youdian1;
@property (nonatomic,strong)UILabel *quedian1;
@property (nonatomic,strong)UILabel *shiyi1;
@property (nonatomic,strong)UILabel *lb4;
@property (nonatomic,strong)UILabel *lb5;
@property (nonatomic,strong)UILabel *lb6;
@property (nonatomic,strong)UILabel *lb10;
@property (nonatomic,strong)UILabel *lb11;
@property (nonatomic,strong)UILabel *lb12;
@property (nonatomic,strong)UILabel *label1;
@property (nonatomic,strong)UILabel *label2;
@property (nonatomic,strong)UILabel *label3;
@end

@implementation DDQProjectDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //    self.navigationController.navigationBar.translucent = YES;
    //    self.view.backgroundColor = [UIColor greenColor];
    [self list];
    //    [self addTwoButton];
}

-(void)initTableView
{
    //114
    _scroll = [[UIScrollView alloc]initWithFrame:CGRectMake(0,0,WIDTH,HEIGHT-(50+HEIGHT*0.02))];
    _scroll.contentSize = CGSizeMake(WIDTH, HEIGHT*3);
    _scroll.delegate = self;
    _scroll.backgroundColor = [UIColor backgroundColor];
    [self.view addSubview:_scroll];
    
    UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(0, 0, WIDTH, HEIGHT*0.25)];
    view1.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:view1];
    
    UILabel *jianjie = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.03, HEIGHT*0.02, WIDTH*0.2, HEIGHT*0.04)];
    jianjie.text = @"简介";
    jianjie.textColor = [UIColor blackColor];
    [view1 addSubview:jianjie];
    
    
    _neirong = [[UILabel alloc]init];
    _neirong.text = _str7;
    _neirong.textColor = [UIColor blackColor];
    _neirong.numberOfLines = 0;
    _neirong.font = [UIFont boldSystemFontOfSize:12];
    CGRect rect3 = [_neirong.text boundingRectWithSize:CGSizeMake(WIDTH*0.94, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_neirong.font.pointSize]} context:nil];
    _neirong.frame = CGRectMake(WIDTH*0.03,HEIGHT*0.08, rect3.size.width,rect3.size.height);
    [view1 addSubview:_neirong];
    
    view1.frame = CGRectMake(0, 0, WIDTH, HEIGHT*0.11 +rect3.size.height);
    
    ///////////////////
    UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT*0.15 +rect3.size.height, WIDTH, HEIGHT*0.8)];
    view2.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:view2];
    
    UILabel *jiage = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT*0.02, WIDTH*0.33, HEIGHT*0.03)];
    jiage.text = @"价格范围";
    jiage.textColor = [UIColor blackColor];
    jiage.font = [UIFont boldSystemFontOfSize:14];
    jiage.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:jiage];
    
    UILabel *fengxian = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.33, HEIGHT*0.02, WIDTH*0.33, HEIGHT*0.03)];
    fengxian.text = @"风险指数";
    fengxian.textColor = [UIColor blackColor];
    fengxian.font = [UIFont boldSystemFontOfSize:14];
    fengxian.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:fengxian];
    
    UILabel *chixu = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.66, HEIGHT*0.02, WIDTH*0.33, HEIGHT*0.03)];
    chixu.text = @"持续时间";
    chixu.textColor = [UIColor blackColor];
    chixu.font = [UIFont boldSystemFontOfSize:14];
    chixu.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:chixu];
    
    _jiage1 = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT*0.07, WIDTH*0.33, HEIGHT*0.03)];
    _jiage1.text = _str6;
    _jiage1.textColor = [UIColor redColor];
    _jiage1.font = [UIFont boldSystemFontOfSize:14];
    _jiage1.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:_jiage1];
    
    _fengxian1 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.33, HEIGHT*0.07, WIDTH*0.33, HEIGHT*0.03)];
    _fengxian1.text = _str15;
    _fengxian1.textColor = [UIColor redColor];
    _fengxian1.font = [UIFont boldSystemFontOfSize:14];
    _fengxian1.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:_fengxian1];
    
    _chixu1 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.66, HEIGHT*0.07, WIDTH*0.33, HEIGHT*0.03)];
    _chixu1.text = _str2;
    _chixu1.textColor = [UIColor redColor];
    _chixu1.font = [UIFont boldSystemFontOfSize:14];
    _chixu1.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:_chixu1];
    
    UIView *lineView1 = [[UIView alloc]initWithFrame:CGRectMake(WIDTH*0.33, 0, 1, HEIGHT*0.12)];
    lineView1.backgroundColor = [UIColor backgroundColor];
    [view2 addSubview:lineView1];
    
    UIView *lineView2 = [[UIView alloc]initWithFrame:CGRectMake(WIDTH*0.66, 0, 1, HEIGHT*0.12)];
    lineView2.backgroundColor = [UIColor backgroundColor];
    [view2 addSubview:lineView2];
    
    UIView *lineView3 = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT*0.12, WIDTH, 1)];
    lineView3.backgroundColor = [UIColor backgroundColor];
    [view2 addSubview:lineView3];
    
    
    UILabel *youdian = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT*0.14, WIDTH*0.2, HEIGHT*0.03)];
    youdian.text = @"优点";
    youdian.textColor = [UIColor blackColor];
    youdian.font = [UIFont boldSystemFontOfSize:14];
    youdian.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:youdian];
    
    
    //WithFrame:CGRectMake(WIDTH*0.03, HEIGHT*0.17, WIDTH*0.94, HEIGHT*0.2)
    _youdian1 = [[UILabel alloc]init];
    _youdian1.text = _str16;
    _youdian1.textColor = [UIColor blackColor];
    _youdian1.font = [UIFont boldSystemFontOfSize:12];
    _youdian1.textAlignment = NSTextAlignmentCenter;
    _youdian1.numberOfLines = 0;
    CGRect rect4 = [_youdian1.text boundingRectWithSize:CGSizeMake(WIDTH*0.94, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_youdian1.font.pointSize]} context:nil];
    _youdian1.frame = CGRectMake(WIDTH*0.03,HEIGHT*0.19, rect4.size.width,rect4.size.height);
    [view2 addSubview:_youdian1];
    
    CGFloat height4 = HEIGHT*0.19+rect4.size.height;
    
    UIView *lineView4 = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT*0.02+height4, WIDTH, 1)];
    lineView4.backgroundColor = [UIColor backgroundColor];
    [view2 addSubview:lineView4];
    
    //缺点
    UILabel *quedian = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT*0.04+height4, WIDTH*0.2, HEIGHT*0.03)];
    quedian.text = @"缺点";
    quedian.textColor = [UIColor blackColor];
    quedian.font = [UIFont boldSystemFontOfSize:14];
    quedian.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:quedian];
    
    //WithFrame:CGRectMake(WIDTH*0.03, HEIGHT*0.47, WIDTH*0.94, HEIGHT*0.05)
    _quedian1 = [[UILabel alloc]init];
    _quedian1.text = _str11;
    _quedian1.textColor = [UIColor blackColor];
    _quedian1.font = [UIFont boldSystemFontOfSize:12];
    _quedian1.textAlignment = NSTextAlignmentLeft;
    _quedian1.numberOfLines = 0;
    _quedian1.font = [UIFont boldSystemFontOfSize:12];
    CGRect rect5 = [_quedian1.text boundingRectWithSize:CGSizeMake(WIDTH*0.94, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_quedian1.font.pointSize]} context:nil];
    _quedian1.frame = CGRectMake(WIDTH*0.03, HEIGHT*0.09+height4, rect5.size.width,rect5.size.height);
    [view2 addSubview:_quedian1];
    
    CGFloat flot5 = HEIGHT*0.09+height4 + rect5.size.height;
    
    UIView *lineView5 = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT*0.02+flot5, WIDTH, 1)];
    lineView5.backgroundColor = [UIColor backgroundColor];
    [view2 addSubview:lineView5];
    
    //适宜人群
    UILabel *shiyi = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.03, HEIGHT*0.04+flot5, WIDTH*0.2, HEIGHT*0.03)];
    shiyi.text = @"事宜人群";
    shiyi.textColor = [UIColor blackColor];
    shiyi.font = [UIFont boldSystemFontOfSize:14];
    shiyi.textAlignment = NSTextAlignmentCenter;
    [view2 addSubview:shiyi];
    
    //WithFrame:CGRectMake(WIDTH*0.03, HEIGHT*0.6, WIDTH*0.94, HEIGHT*0.2)
    _shiyi1 = [[UILabel alloc]init];
    _shiyi1.text = _str12;
    _shiyi1.textColor = [UIColor blackColor];
    _shiyi1.font = [UIFont boldSystemFontOfSize:12];
    _shiyi1.textAlignment = NSTextAlignmentLeft;
    _shiyi1.numberOfLines = 0;
    CGRect rect6 = [_shiyi1.text boundingRectWithSize:CGSizeMake(WIDTH*0.94, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_shiyi1.font.pointSize]} context:nil];
    _shiyi1.frame = CGRectMake(WIDTH*0.03, HEIGHT*0.09+flot5, rect6.size.width,rect6.size.height);
    [view2 addSubview:_shiyi1];
    CGFloat flot6 = HEIGHT*0.09+flot5 + rect6.size.height;
    view2.frame = CGRectMake(0, HEIGHT*0.1 +rect3.size.height, WIDTH, flot6+HEIGHT*0.02);
    CGFloat flot7 = HEIGHT*0.1 +rect3.size.height + flot6+HEIGHT*0.02;
    
    UIView *view6 = [[UIView alloc]initWithFrame:CGRectMake(0, flot7 +HEIGHT*0.02, WIDTH, HEIGHT*0.24)];
    view6.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:view6];
    
    //治疗时长
    UILabel *lb1 = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT*0.02, WIDTH*0.33, HEIGHT*0.03)];
    lb1.text = @"治疗时长";
    lb1.textColor = [UIColor blackColor];
    lb1.font = [UIFont boldSystemFontOfSize:14];
    lb1.textAlignment = NSTextAlignmentCenter;
    [view6 addSubview:lb1];
    
    UILabel *lb2 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.33, HEIGHT*0.02, WIDTH*0.33, HEIGHT*0.03)];
    lb2.text = @"治疗次数";
    lb2.textColor = [UIColor blackColor];
    lb2.font = [UIFont boldSystemFontOfSize:14];
    lb2.textAlignment = NSTextAlignmentCenter;
    [view6 addSubview:lb2];
    
    UILabel *lb3 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.66, HEIGHT*0.02, WIDTH*0.33, HEIGHT*0.03)];
    lb3.text = @"麻醉方法";
    lb3.textColor = [UIColor blackColor];
    lb3.font = [UIFont boldSystemFontOfSize:14];
    lb3.textAlignment = NSTextAlignmentCenter;
    [view6 addSubview:lb3];
    
    _lb4 = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT*0.07, WIDTH*0.33, HEIGHT*0.03)];
    _lb4.text = _str14;
    _lb4.textColor = [UIColor redColor];
    _lb4.font = [UIFont boldSystemFontOfSize:14];
    _lb4.textAlignment = NSTextAlignmentCenter;
    [view6 addSubview:_lb4];
    
    _lb5 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.33, HEIGHT*0.07, WIDTH*0.33, HEIGHT*0.03)];
    _lb5.text = _str13;
    _lb5.textColor = [UIColor redColor];
    _lb5.font = [UIFont boldSystemFontOfSize:14];
    _lb5.textAlignment = NSTextAlignmentCenter;
    [view6 addSubview:_lb5];
    
    _lb6 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.66, HEIGHT*0.07, WIDTH*0.33, HEIGHT*0.03)];
    _lb6.text = _str9;
    _lb6.textColor = [UIColor redColor];
    _lb6.font = [UIFont boldSystemFontOfSize:14];
    _lb6.textAlignment = NSTextAlignmentCenter;
    [view6 addSubview:_lb6];
    
    
    //治疗时长
    UILabel *lb7 = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT*0.13, WIDTH*0.33, HEIGHT*0.03)];
    lb7.text = @"是否住院";
    lb7.textColor = [UIColor blackColor];
    lb7.font = [UIFont boldSystemFontOfSize:14];
    lb7.textAlignment = NSTextAlignmentCenter;
    [view6 addSubview:lb7];
    
    UILabel *lb8 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.33, HEIGHT*0.13, WIDTH*0.33, HEIGHT*0.03)];
    lb8.text = @"恢复时间";
    lb8.textColor = [UIColor blackColor];
    lb8.font = [UIFont boldSystemFontOfSize:14];
    lb8.textAlignment = NSTextAlignmentCenter;
    [view6 addSubview:lb8];
    
    UILabel *lb9 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.66, HEIGHT*0.13, WIDTH*0.33, HEIGHT*0.03)];
    lb9.text = @"折线时间";
    lb9.textColor = [UIColor blackColor];
    lb9.font = [UIFont boldSystemFontOfSize:14];
    lb9.textAlignment = NSTextAlignmentCenter;
    [view6 addSubview:lb9];
    
    _lb10 = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT*0.18, WIDTH*0.33, HEIGHT*0.03)];
    _lb10.text = _sfzy;
    _lb10.textColor = [UIColor redColor];
    _lb10.font = [UIFont boldSystemFontOfSize:14];
    _lb10.textAlignment = NSTextAlignmentCenter;
    [view6 addSubview:_lb10];
    
    _lb11 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.33, HEIGHT*0.18, WIDTH*0.33, HEIGHT*0.03)];
    _lb11.text = _str5;
    _lb11.textColor = [UIColor redColor];
    _lb11.font = [UIFont boldSystemFontOfSize:14];
    _lb11.textAlignment = NSTextAlignmentCenter;
    [view6 addSubview:_lb11];
    
    _lb12 = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.66, HEIGHT*0.18, WIDTH*0.33, HEIGHT*0.03)];
    _lb12.text = _str3;
    _lb12.textColor = [UIColor redColor];
    _lb12.font = [UIFont boldSystemFontOfSize:14];
    _lb12.textAlignment = NSTextAlignmentCenter;
    [view6 addSubview:_lb12];
    
    
    
    UIView *lineView7 = [[UIView alloc]initWithFrame:CGRectMake(WIDTH*0.33, 0, 1, HEIGHT*0.24)];
    lineView7.backgroundColor = [UIColor backgroundColor];
    [view6 addSubview:lineView7];
    
    UIView *lineView8 = [[UIView alloc]initWithFrame:CGRectMake(WIDTH*0.66, 0, 1, HEIGHT*0.24)];
    lineView8.backgroundColor = [UIColor backgroundColor];
    [view6 addSubview:lineView8];
    
    UIView *lineView9 = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT*0.12, WIDTH, 1)];
    lineView9.backgroundColor = [UIColor backgroundColor];
    [view6 addSubview:lineView9];
    ////
    CGFloat flot8 =  flot7 +HEIGHT*0.28;
    
    UIView *view10 = [[UIView alloc]initWithFrame:CGRectMake(0, flot8, WIDTH, HEIGHT*2)];
    view10.backgroundColor = [UIColor whiteColor];
    [_scroll addSubview:view10];
    
    //主意事项
    UILabel *zhuyi = [[UILabel alloc]initWithFrame:CGRectMake(0, HEIGHT*0.02, WIDTH*0.2, HEIGHT*0.03)];
    zhuyi.text = @"主意事项";
    zhuyi.textColor = [UIColor blackColor];
    zhuyi.font = [UIFont boldSystemFontOfSize:14];
    zhuyi.textAlignment = NSTextAlignmentCenter;
    [view10 addSubview:zhuyi];
    
    _label1 = [[UILabel alloc]init];
    _label1.text = _str1;
    _label1.textColor = [UIColor blackColor];
    _label1.font = [UIFont boldSystemFontOfSize:14];
    [_label1 setNumberOfLines:0];
    CGRect rect = [_label1.text boundingRectWithSize:CGSizeMake(WIDTH*0.94, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_label1.font.pointSize]} context:nil];
    _label1.frame = CGRectMake(WIDTH*0.03,HEIGHT * 0.07, rect.size.width,rect.size.height);
    [view10 addSubview:_label1];
    
    UIView *view11 = [[UIView alloc]initWithFrame:CGRectMake(0, HEIGHT * 0.09 + rect.size.height, WIDTH, 1)];
    view11.backgroundColor = [UIColor backgroundColor];
    [view10 addSubview:view11];
    //
    float height1 = HEIGHT * 0.11 + rect.size.height;
    
    UILabel *fxts = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.03, height1+HEIGHT*0.02, WIDTH, HEIGHT*0.03)];
    fxts.text = @"风险提示";
    fxts.textColor = [UIColor blackColor];
    [view10 addSubview:fxts];
    
    
    _label2 = [[UILabel alloc]init];
    _label2.text = _str4;
    _label2.textColor = [UIColor blackColor];
    _label2.font = [UIFont boldSystemFontOfSize:14];
    [_label2 setNumberOfLines:0];
    CGRect rect1 = [_label2.text boundingRectWithSize:CGSizeMake(WIDTH*0.94, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_label2.font.pointSize]} context:nil];
    _label2.frame = CGRectMake(WIDTH*0.03,height1 + HEIGHT*0.07, rect1.size.width,rect1.size.height);
    [view10 addSubview:_label2];
    
    float height2 = height1 + HEIGHT*0.09 + rect1.size.height;
    
    UIView *view12 = [[UIView alloc]initWithFrame:CGRectMake(0,height2, WIDTH, 1)];
    view12.backgroundColor = [UIColor backgroundColor];
    [view10 addSubview:view12];
    ////
    ////    //
    UILabel *jjrq = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.03, height2+HEIGHT*0.02, WIDTH, HEIGHT*0.03)];
    jjrq.text = @"禁忌人群";
    jjrq.textColor = [UIColor blackColor];
    [view10 addSubview:jjrq];
    
    _label3 = [[UILabel alloc]init];
    _label3.text = _str8;
    _label3.textColor = [UIColor blackColor];
    _label3.font = [UIFont boldSystemFontOfSize:14];
    [_label3 setNumberOfLines:0];
    CGRect rect2 = [_label3.text boundingRectWithSize:CGSizeMake(WIDTH*0.94, 3000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:_label3.font.pointSize]} context:nil];
    _label3.frame = CGRectMake(WIDTH*0.03,height2+HEIGHT*0.07, rect2.size.width,rect2.size.height);
    [view10 addSubview:_label3];
    CGFloat flot9 = height2+HEIGHT*0.07 + rect2.size.height;
    
    view10.frame = CGRectMake(0, flot8, WIDTH, HEIGHT*0.02 + flot9);
    
    
    
    UIView *view13 = [[UIView alloc]initWithFrame:CGRectMake(0, flot8+flot9+HEIGHT*0.02, WIDTH, HEIGHT*0.05)];
    view13.backgroundColor = [UIColor backgroundColor];
    [_scroll addSubview:view13];
    
    //高
    CGFloat flot10 = flot8+flot9+HEIGHT*0.02 + HEIGHT*0.05;
    
    UILabel *xgxm = [[UILabel alloc]initWithFrame:CGRectMake(WIDTH*0.03, HEIGHT*0.01, WIDTH*0.5, HEIGHT*0.03)];
    xgxm.text = @"相关项目";
    xgxm.textColor = [UIColor blackColor];
    [view13 addSubview:xgxm];
    
    //    self.falseData = @"这是一首简单的小情歌,唱出我们心头的快乐。这是一首简单的小情歌,唱出我们心头的快乐。这是一首简单的小情歌,唱出我们心头的快乐。这是一首简单的小情歌,唱出我们心头的快乐。这是一首简单的小情歌,唱出我们心头的快乐。";
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, 0, 0) style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [_scroll addSubview:self.mainTableView];
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    //    self.mainTableView.frame = CGRectMake(0, flot10, WIDTH, _listArray.count*HEIGHT*0.2);
    //    self.scroll.contentSize = CGSizeMake(WIDTH, flot10 + _listArray.count*HEIGHT*0.2);
    
    if (_listArray.count ==0) {
        //        self.mainTableView.frame = CGRectMake(0, 0, 0, 0);
        self.scroll.contentSize = CGSizeMake(WIDTH, flot8+flot9+HEIGHT*0.02);
        [view13 removeFromSuperview];
        
    }else{
        self.mainTableView.frame = CGRectMake(0, flot10, WIDTH, _listArray.count*HEIGHT*0.2);
        self.scroll.contentSize = CGSizeMake(WIDTH, flot10 + _listArray.count*HEIGHT*0.2+114);
        
    }
    
    
}

-(void)list
{
    if ([CheckNetWork connectedToNetwork]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            DDQSingleModel *model = [DDQSingleModel singleModelByValue];
            _project_Id = model.projectId;
            //postString
            NSString *post_baseString = [NSString stringWithFormat:@"%@*%@",[SpellParameters getBasePostString],_project_Id];
            //加密
            DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];
            NSString *post_String = [postEncryption stringWithPost:post_baseString];
            //加密字典
            NSMutableDictionary *post_Dic = [[PostData alloc] postData:post_String AndUrl:kProjectDetailUrl];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                
                if ([post_Dic[@"errorcode"] intValue] == 0) {
                    
                    NSDictionary *json_Dic = [DDQPOSTEncryption judgePOSTDic:post_Dic];
                    
                    _listArray = [NSMutableArray new];
                    NSMutableArray *array = [json_Dic objectForKey:@"goods"];
                    for (NSDictionary *dic in array) {
                        //12-09
                        //goods列表
                        DDQMainViewControllerModel *model = [[DDQMainViewControllerModel alloc]init];
                        [model setValuesForKeysWithDictionary:dic];
                        [_listArray addObject:model];
                    }
                    //12-21
                    NSDictionary *get_dic =[DDQPublic nullDic:json_Dic];

                    _str1  = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"zysx"];
                    _str2  = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"cxsj"];
                    _str3  = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"cxsj2"];
                    _str4  = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"fxts"];
                    _str5  = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"hfsj"];
                    _str6  = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"jgfw"];
                    _str7  = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"jj"];
                    _str8  = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"jjrq"];
                    _str9  = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"mzff"];
                    _str10 = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"name"];
                    _str11 = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"qd"];
                    _str12 = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"syrq"];
                    _str13 = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"zlcs"];
                    _str14 = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"zlsc"];
                    _str15 = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"fxzs"];
                    _str16 = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"yd"];
                    NSString *str17 = [[get_dic objectForKey:@"baseinfo"] objectForKey:@"sfzy"];

                    if ([str17 intValue]==0) {
                        _sfzy = @"是";
                    }else
                    {
                        _sfzy = @"否";
                    }
                    [self.mainTableView reloadData];
                    [self initTableView];
                } else {
                    
                    [self alertController:@"系统繁忙"];
                }
                
                
            });
        });
    }else{
        UIAlertView *show = [[UIAlertView alloc] initWithTitle:@"您的设备当前没有连接网络,请检测网络设置!"  message:nil delegate:self cancelButtonTitle:@"确认" otherButtonTitles: nil];
        [show show];
    }
    
    
    
}
#pragma mark - tableView代理
//设置分区
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
//指定每个分区中有多少行，默认为1
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _listArray.count;
}

//行高
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    return HEIGHT*0.2;
}
//12-09
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell4";
    
    DDQMainHotProjectTableViewCell *cell = [[DDQMainHotProjectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    if (cell ==nil) {
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;//取消选中高亮
    [cell setBackgroundColor:[UIColor myGrayColor]];
    
    DDQMainViewControllerModel *model1 = _listArray[indexPath.row];
    
    //12-09填数据
    //12-17
    
    //图
    if (![DDQPublic isBlankString:model1.simgString])
    {
        NSURL *url = [NSURL URLWithString:model1.simgString];
        [cell.modelImageView sd_setImageWithURL:url placeholderImage:[UIImage imageNamed:@"default_pic"]];
//        NSData *data = [NSData dataWithContentsOfURL:url];
//        
//        if ([[UIImage imageWithData:data] isKindOfClass:[UIImage class]]) {
//            cell.modelImageView.image =[UIImage imageWithData:data];
//        }
//        else
//        {
//            cell.modelImageView.image = [UIImage imageNamed:@"default_pic"];
//        }
    }
    else
    {
        cell.modelImageView.image = [UIImage imageNamed:@"default_pic"];
    }
    
    //名称
    if(![DDQPublic isBlankString:model1.nameString])
    {
        cell.projectIntro.text = [NSString stringWithFormat:@"【%@】 %@",model1.fnameString,model1.nameString];
    }
    else
    {
        cell.projectIntro.text = [NSString stringWithFormat:@"【%@】 %@",model1.fnameString,@"暂无"];
    }
    
    //医院名称
    BOOL a = [DDQPublic isBlankString:model1.hname];
    if (a) {
        cell.projectHospital.text = @"暂无";
    }
    else
    {
        cell.projectHospital.text = model1.hname;
        
    }
    
    cell.sellNum.text = [NSString stringWithFormat:@"已售:%@", model1.sellout];
    
    //新价格
    if ([DDQPublic isBlankString:model1.newvalString])
    {
        cell.projectPrice.text = @"暂无";
    }
    else
    {
        cell.projectPrice.text =[NSString stringWithFormat:@"￥%@", model1.newvalString];
    }
    
    //旧价格
    if ([DDQPublic isBlankString:model1.oldvalString])
    {
        cell.oldPrice.text = @"暂无";
    }
    else
    {
        NSAttributedString *string = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@", model1.oldvalString] attributes:@{NSStrikethroughStyleAttributeName:@(NSUnderlineStyleSingle),NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
        
        cell.oldPrice.attributedText = string;
    }
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    DDQMainViewControllerModel *model1 = _listArray[indexPath.row];
    
    DDQPreferenceDetailViewController *detailVC = [[DDQPreferenceDetailViewController alloc]initWithActivityID:model1.IdString];
    
    detailVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:detailVC animated:YES];
}
//-(void)addTwoButton {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, 50)];
//    [self.view addSubview:view];
//
//    self.descriptionButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width*0.5, view.frame.size.height)];
//    [self.descriptionButton setBackgroundColor:[UIColor whiteColor]];
//    [self.descriptionButton setTitle:@"项目简介" forState:UIControlStateNormal];
//    [self.descriptionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
//    [self.descriptionButton addTarget:self action:@selector(changeToProjectDetailViewController) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:self.descriptionButton];
//
//    self.diaryButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.bounds.size.width*0.5, 0, self.view.bounds.size.width*0.5, view.frame.size.height)];
//    [self.diaryButton setBackgroundColor:[UIColor grayColor]];
//    [self.diaryButton setTitle:@"相关日记" forState:UIControlStateNormal];
//    [self.diaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
//    [self.diaryButton addTarget:self action:@selector(changeToUserDiaryViewController) forControlEvents:UIControlEventTouchUpInside];
//    [view addSubview:self.diaryButton];
//
//    [view setBackgroundColor:[UIColor whiteColor]];
//}
-(void)changeToUserDiaryViewController {
    //    [self.diaryButton setBackgroundColor:[UIColor whiteColor]];
    //    [self.diaryButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //
    //    //    [self transitionFromViewController:_projectDetailVC toViewController:_diaryVC duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
    //    //        if (!finished) {
    //    //            [_diaryVC didMoveToParentViewController:self];
    //    //            [_projectDetailVC willMoveToParentViewController:nil];
    //    //            [_projectDetailVC removeFromParentViewController];
    //    //        }
    //    //    }];
    //    [self.descriptionButton setBackgroundColor:[UIColor grayColor]];
    //    [self.descriptionButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //
    //    [_diaryVC.view bringSubviewToFront:self.view];
    
}

-(void)changeToProjectDetailViewController {
    //    [self.descriptionButton setBackgroundColor:[UIColor whiteColor]];
    //    [self.descriptionButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    //
    //    //    [self transitionFromViewController:_diaryVC toViewController:_projectDetailVC duration:0 options:UIViewAnimationOptionTransitionNone animations:nil completion:^(BOOL finished) {
    //    //        if (!finished) {
    //    //            [_projectDetailVC didMoveToParentViewController:self];
    //    //            [_diaryVC willMoveToParentViewController:nil];
    //    //            [_diaryVC removeFromParentViewController];
    //    //        }
    //    //    }];
    //    [self.diaryButton setBackgroundColor:[UIColor grayColor]];
    //    [self.diaryButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    //
    //    [self.view bringSubviewToFront:_diaryVC.view];
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
