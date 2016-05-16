//
//  DDQHospitalEvaluateController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/23.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQHospitalEvaluateController.h"

#import "DDQHospitalEvaluateCell.h"

#import "DDQDashesLine.h"
#import "BarChart.h"
#import "DDQCircleView.h"

#import "DDQHospitalEvaluteModel.h"

@interface DDQHospitalEvaluateController ()<UITableViewDataSource,UITableViewDelegate>

/**
 *  主表示图
 */
@property (strong,nonatomic) UITableView *mainTableView;

@property (strong,nonatomic) UIView *headerView;

@property (assign,nonatomic) CGFloat rowHeight;


@property (strong,nonatomic) NSMutableArray *he_dataArray;

@property (strong,nonatomic) UIButton *temp_button;

@end

@implementation DDQHospitalEvaluateController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self initTableView];
    
    self.he_dataArray = [NSMutableArray array];
    
    self.navigationItem.title = @"医院评价";
}

-(void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:YES];
    [DDQNetWork checkNetWorkWithError:^(NSDictionary *errorDic) {
        
        if (errorDic == nil) {
            
            [self asyHospitalPjNetWorkWithType:@"1"];
        } else {
            
            [MBProgressHUD myCustomHudWithView:self.view andCustomText:errorDic[@"NSLocalizedDescription"] andShowDim:NO andSetDelay:YES andCustomView:nil];
        }
    }];
}


-(void)asyHospitalPjNetWorkWithType:(NSString *)type {

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
        //网络解析一小下
        NSString *spellString             = [SpellParameters getBasePostString];//八段
        
        NSString *post_baseString         = [NSString stringWithFormat:@"%@*%@*%@",spellString,self.hospitalId,type];//post字符串
        
        DDQPOSTEncryption *postEncryption = [[DDQPOSTEncryption alloc] init];//加密类
        
        NSString *post_string             = [postEncryption stringWithPost:post_baseString];//加密下
        
        NSMutableDictionary *post_dic     = [[PostData alloc] postData:post_string AndUrl:kHospital_pjUrl];//发送下
        
        NSString *errorcode_string        = [post_dic valueForKey:@"errorcode"];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if ([errorcode_string intValue] == 0) {
                //12-21
                NSDictionary *get_Dic = [DDQPOSTEncryption judgePOSTDic:post_dic];
                
                NSDictionary *get_jsonDic = [DDQPublic nullDic:get_Dic];
                for (NSDictionary *dataDic in get_jsonDic) {
                    DDQHospitalEvaluteModel *model = [[DDQHospitalEvaluteModel alloc] init];
                    model.fw = dataDic[@"fw"];
                    model.hid = dataDic[@"hid"];
                    model.hua = dataDic[@"hua"];
                    model.iD = dataDic[@"id"];
                    model.orderid = dataDic[@"orderid"];
                    model.pubtime = dataDic[@"pubtime"];
                    model.sm = dataDic[@"sm"];
                    model.stars = dataDic[@"stars"];
                    model.text = dataDic[@"text"];
                    model.userid = dataDic[@"userid"];
                    model.username = dataDic[@"username"];
                    model.simg = dataDic[@"simg"];
                    model.userimg = dataDic[@"userimg"];
                    [self.he_dataArray addObject:model];
                }
                [self.mainTableView reloadData];
            } else {
                
//                [self alertController:@"系统繁忙"];
            }
            
        });
    });

}


-(void)initTableView {
    
    self.mainTableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
    [self.mainTableView setDelegate:self];
    [self.mainTableView setDataSource:self];
    [self.view addSubview:self.mainTableView];
    self.mainTableView.tableHeaderView = [self setTableViewHeaderView];
}

#pragma mark - headerView
-(UIView *)setTableViewHeaderView {
    
    _headerView                 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight*0.3)];
    _headerView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_headerView];

    
    UIView *topView             = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, _headerView.frame.size.height*0.6)];
    topView.backgroundColor     = [UIColor whiteColor];
    [_headerView addSubview:topView];
    
    NSString *string = [self.hp substringToIndex:self.hp.length - 1];
    CGFloat arcW ;
    
    arcW = 10.0f;
    
    DDQCircleView *circleView = [[DDQCircleView alloc] initWithFrame:CGRectMake(10, 0, topView.frame.size.height, topView.frame.size.height) arcWidth:arcW current:[string floatValue] total:100.0f];
    circleView.backgroundColor = [UIColor whiteColor];
    circleView.layer.borderColor   = [UIColor whiteColor].CGColor;
    [topView addSubview:circleView];

    [circleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(topView.mas_top).offset(15);
        make.left.equalTo(topView.mas_left).offset(15);
        make.bottom.equalTo(topView.mas_bottom).offset(-15);
        make.width.equalTo(circleView.mas_height);
    }];
    
    UILabel *good_label = [[UILabel alloc] init];
    [circleView addSubview:good_label];
    [good_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.mas_equalTo(circleView.mas_centerY);
        make.height.offset(15);
        make.centerX.equalTo(circleView.mas_centerX);
    }];
    
    good_label.text = @"好评率";
    good_label.font = [UIFont systemFontOfSize:11.0f];
    good_label.textColor = [UIColor orangeColor];
    good_label.textAlignment = NSTextAlignmentCenter;
    
    
    UILabel *bate_label = [[UILabel alloc] init];
    [circleView addSubview:bate_label];
    [bate_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(good_label.mas_bottom);
        make.height.equalTo(good_label.mas_height);
        make.centerX.equalTo(circleView.mas_centerX);
    }];
    bate_label.text = self.hp;
    bate_label.font = [UIFont systemFontOfSize:11.0f];
    bate_label.textColor = [UIColor orangeColor];
    bate_label.textAlignment = NSTextAlignmentCenter;
    
    DDQDashesLine *dashesLine   = [[DDQDashesLine alloc] init];
    [topView addSubview:dashesLine];
    [dashesLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(circleView.mas_centerY);
        make.width.offset(100);
        make.height.offset(3);
        make.left.equalTo(circleView.mas_right).offset(10);
    }];
    dashesLine.startPoint       = CGPointMake(0, 1);
    dashesLine.endPoint         = CGPointMake(100, 1);
    dashesLine.lineColor        = kLeftColor;
    dashesLine.backgroundColor  = [UIColor clearColor];
    
    float value1 = ([self.sm floatValue]/5.0)*100;
    float value2 = ([self.fw floatValue]/5.0)*100;
    float value3 = ([self.hj floatValue]/5.0)*100;

    NSArray *values_array       = @[[NSNumber numberWithFloat:value1],[NSNumber numberWithFloat:value3],[NSNumber numberWithFloat:value2]];
    BarChart *barChart          = [[BarChart alloc] initWithFrame:CGRectMake(120, topView.frame.size.height/2 - (topView.frame.size.height*0.6-20)/4 , 100, topView.frame.size.height*0.6-20) values:values_array];
    [topView addSubview:barChart];
    [barChart mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dashesLine.mas_left);
        make.centerY.equalTo(dashesLine.mas_centerY);
        make.width.equalTo(dashesLine.mas_width);
        make.height.equalTo(circleView.mas_height).multipliedBy(0.5);
    }];
    barChart.backgroundColor    = [UIColor clearColor];
    barChart.barColor           = [UIColor redColor];
    
    NSArray *titleArray = @[@"审美",@"服务",@"环境"];
    
    UILabel *label_one = [[UILabel alloc] init];
    [topView addSubview:label_one];
    [label_one mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(barChart.mas_left);
        make.width.equalTo(barChart.mas_width).multipliedBy(0.333);
        make.height.offset(20);
        make.top.equalTo(barChart.mas_bottom);
    }];
    label_one.text          = titleArray[0];
    label_one.textAlignment = NSTextAlignmentCenter;
    label_one.font          = [UIFont systemFontOfSize:12.0f];
    
    UILabel *label_two = [[UILabel alloc] init];
    [topView addSubview:label_two];
    [label_two mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_one.mas_right);
        make.width.equalTo(barChart.mas_width).multipliedBy(0.333);
        make.height.offset(20);
        make.top.equalTo(label_one.mas_top);
    }];
    label_two.text          = titleArray[1];
    label_two.textAlignment = NSTextAlignmentCenter;
    label_two.font          = [UIFont systemFontOfSize:12.0f];
    
    UILabel *label_three = [[UILabel alloc] init];
    [topView addSubview:label_three];
    [label_three mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(label_two.mas_right);
        make.width.equalTo(barChart.mas_width).multipliedBy(0.333);
        make.height.offset(20);
        make.top.equalTo(label_two.mas_top);
    }];
    label_three.text          = titleArray[2];
    label_three.textAlignment = NSTextAlignmentCenter;
    label_three.font          = [UIFont systemFontOfSize:12.0f];
    
    UILabel *average_label = [[UILabel alloc] init];
    [topView addSubview:average_label];
    [average_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(dashesLine.mas_right).offset(10);
        make.centerY.equalTo(dashesLine.mas_centerY);
        make.width.offset(50);
        make.height.offset(10);
    }];
    average_label.font          = [UIFont systemFontOfSize:12.0f];
    average_label.text          = @"平均水平";
    average_label.textColor     = kLeftColor;
    
    
    UIView *lineView            = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.frame.size.height*0.65, kScreenWidth, 1)];
    [topView addSubview:lineView];
    lineView.backgroundColor    = [UIColor backgroundColor];
   
    
    UIView *plant_view = [self plantWithAllEvaluate:@"133" andGoodEvaluate:@"1" andMiddleEvaluate:@"2" andBadEvaluate:@"130"];
    [_headerView addSubview:plant_view];
    
    return _headerView;
}

-(UIView *)plantWithAllEvaluate:(NSString *)allEvaluate andGoodEvaluate:(NSString *)goodEvaluate andMiddleEvaluate:(NSString *)middleEvaluate andBadEvaluate:(NSString *)badEvaluate {
    
    UIView *current_View         = [[UIView alloc] initWithFrame:CGRectMake(0, _headerView.frame.size.height*0.7 + 1, kScreenWidth, _headerView.frame.size.height*0.3)];
    
    CGFloat view_height       = _headerView.frame.size.height*0.3;
    
    //分区1
    UIView *firstView         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth*0.25,view_height)];
    firstView.backgroundColor = [UIColor whiteColor];
    [current_View addSubview:firstView];
    
    UIView *first_line         = [[UIView alloc] init];
    [firstView addSubview:first_line];
    [first_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(firstView.mas_right);
        make.width.offset(1);
        make.centerY.equalTo(firstView.mas_centerY);
        make.height.equalTo(firstView.mas_height).multipliedBy(1).offset(-40);
    }];
    first_line.backgroundColor = kLeftColor;
    
    UIButton *first_button      = [[UIButton alloc] init];
    [firstView addSubview:first_button];
    [first_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(firstView.mas_centerX);
        make.centerY.equalTo(firstView.mas_centerY);
        make.width.equalTo(firstView.mas_width);
        make.height.equalTo(firstView.mas_height);
    }];
    [first_button setTitle:@"全部评价" forState:UIControlStateNormal];
    first_button.tag = 1;
    [first_button setTitleColor:[UIColor meiHongSe] forState:UIControlStateNormal];
    [first_button addTarget:self action:@selector(typeButtonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    //分区2
    UIView *secondView         = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth*0.25,0 , kScreenWidth*0.25,view_height)];
    secondView.backgroundColor = [UIColor whiteColor];
    [current_View addSubview:secondView];
    
    UIView *second_line         = [[UIView alloc] init];
    [secondView addSubview:second_line];
    [second_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(secondView.mas_right);
        make.width.offset(1);
        make.centerY.equalTo(secondView.mas_centerY);
        make.height.equalTo(secondView.mas_height).multipliedBy(1).offset(-40);
    }];
    second_line.backgroundColor = kLeftColor;

    UIButton *second_button      = [[UIButton alloc] init];
    [secondView addSubview:second_button];
    [second_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(secondView.mas_centerX);
        make.centerY.equalTo(secondView.mas_centerY);
        make.width.equalTo(secondView.mas_width);
        make.height.equalTo(secondView.mas_height);
    }];
    [second_button setTitle:@"好评" forState:UIControlStateNormal];
    second_button.tag = 2;
    [second_button setTitleColor:kLeftColor forState:UIControlStateNormal];
    [second_button addTarget:self action:@selector(typeButtonClickMethod:) forControlEvents:UIControlEventTouchUpInside];
    
    
    //分区3
    UIView *thirdView         = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth*0.5, 0, kScreenWidth*0.25,view_height)];
    thirdView.backgroundColor = [UIColor whiteColor];
    [current_View addSubview:thirdView];
    
    UIView *third_line         = [[UIView alloc] init];
    [thirdView addSubview:third_line];
    [third_line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(thirdView.mas_right);
        make.width.offset(1);
        make.centerY.equalTo(thirdView.mas_centerY);
        make.height.equalTo(thirdView.mas_height).multipliedBy(1).offset(-40);
    }];
    third_line.backgroundColor = kLeftColor;

    
    UIButton *third_button      = [[UIButton alloc] init];
    [thirdView addSubview:third_button];
    [third_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(thirdView.mas_centerX);
        make.centerY.equalTo(thirdView.mas_centerY);
        make.width.equalTo(thirdView.mas_width);
        make.height.equalTo(thirdView.mas_height);
    }];
    [third_button setTitle:@"中评" forState:UIControlStateNormal];
    third_button.tag = 3;
    [third_button setTitleColor:kLeftColor forState:UIControlStateNormal];
    [third_button addTarget:self action:@selector(typeButtonClickMethod:) forControlEvents:UIControlEventTouchUpInside];

    //分区4
    UIView *fourthView         = [[UIView alloc] initWithFrame:CGRectMake(kScreenWidth*0.75, 0, kScreenWidth*0.25,view_height)];
    fourthView.backgroundColor = [UIColor whiteColor];
    [current_View addSubview:fourthView];

    
    UIButton *fourth_button      = [[UIButton alloc] init];
    [fourthView addSubview:fourth_button];
    [fourth_button mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerX.equalTo(fourthView.mas_centerX);
        make.centerY.equalTo(fourthView.mas_centerY);
        make.width.equalTo(fourthView.mas_width);
        make.height.equalTo(fourthView.mas_height);

    }];
    [fourth_button setTitle:@"差评" forState:UIControlStateNormal];
    fourth_button.tag = 4;
    [fourth_button setTitleColor:kLeftColor forState:UIControlStateNormal];
    [fourth_button addTarget:self action:@selector(typeButtonClickMethod:) forControlEvents:UIControlEventTouchUpInside];

    self.temp_button = first_button;

    return current_View;
}

-(void)typeButtonClickMethod:(UIButton *)button {

    if (self.temp_button == button) {
        return;
    } else{
    
        [button setTitleColor:[UIColor meiHongSe] forState:UIControlStateNormal];
        [self.temp_button setTitleColor:kLeftColor forState:UIControlStateNormal];
        self.temp_button = button;
        if (button.tag == 1) {
            
            [self.he_dataArray removeAllObjects];
            [self asyHospitalPjNetWorkWithType:@"1"];
            
        } else if (button.tag == 2) {
            
            [self.he_dataArray removeAllObjects];
            [self asyHospitalPjNetWorkWithType:@"2"];
            
        } else if (button.tag == 3) {
            
            [self.he_dataArray removeAllObjects];
            [self asyHospitalPjNetWorkWithType:@"3"];
            
        } else {
            
            [self.he_dataArray removeAllObjects];
            [self asyHospitalPjNetWorkWithType:@"4"];
        }
    }
}


#pragma mark - delegate and datasource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.he_dataArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    static NSString *identifier = @"cell";
    DDQHospitalEvaluateCell *evaluateCell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!evaluateCell)
    {
        DDQHospitalEvaluteModel *model;
        if (self.he_dataArray.count != 0) {
            model = self.he_dataArray[indexPath.row];
        }
        evaluateCell = [[DDQHospitalEvaluateCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        [evaluateCell cellWithUserImageUrl:model.userimg
                               andUserName:model.username
                                   andDate:model.pubtime
                              andStarCount:[model.stars intValue]
                            andUserComment:nil
                            andProjectInto:model.text
                             andProjectImg:model.simg];
        self.rowHeight              = evaluateCell.newRect.size.height;
        evaluateCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return evaluateCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (kScreenHeight == 480) {
        return 40 + self.rowHeight + 100;
        
    } else if (kScreenHeight == 568) {
        return 50 + self.rowHeight + 110;
        
    } else if (kScreenHeight == 667) {
        return 60 + self.rowHeight + 120;
        
    } else {
        return 70 + self.rowHeight + 130;
        
    }

}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 10;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view         = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor backgroundColor];
    return view;
}


@end
