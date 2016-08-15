//
//  DDQTeacherIntroView.m
//  QuanMei
//
//  Created by Min-Fo_003 on 16/1/15.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQTeacherIntroView.h"

@implementation DDQTeacherIntroView

-(void)layoutSubviews {

    self.intro_tableview = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    [self addSubview:self.intro_tableview];
    [self.intro_tableview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.mas_top);
        make.bottom.equalTo(self.mas_bottom).offset(-49);
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
    }];
    
    self.intro_tableview.delegate = self;
    self.intro_tableview.dataSource = self;
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 65)];
    view.backgroundColor = [UIColor whiteColor];
    self.intro_tableview.tableFooterView = view;
    self.intro_tableview.backgroundColor = [UIColor whiteColor];
    self.intro_tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
	
	UIImage *image = [UIImage imageNamed:@"default_big_pic"];
	CGFloat rate = image.size.width / image.size.height;
    self.header_img = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, kScreenWidth / rate)];
    self.header_img.image = image;
    self.intro_tableview.tableHeaderView = self.header_img;
    
    UIView *temp_view = [[UIView alloc] init];
    temp_view.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.5f];
    [self addSubview:temp_view];
    [temp_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.offset(65.0f);
        make.left.equalTo(self.mas_left);
        make.bottom.equalTo(self.mas_bottom).offset(-64);
        make.right.equalTo(self.mas_right);
    }];

    
    UIButton *buy_button = [[UIButton alloc] init];
    [temp_view addSubview:buy_button];
    [buy_button mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(20);
        make.right.equalTo(self.mas_right).offset(-20);
        make.top.equalTo(temp_view.mas_top).offset(9);
        make.bottom.equalTo(temp_view.mas_bottom).offset(-9);
    }];
    [buy_button setImage:[UIImage imageNamed:@"img_-botton"] forState:UIControlStateNormal];
    [buy_button addTarget:self action:@selector(buttonClickedMethod:) forControlEvents:UIControlEventTouchUpInside];
}

//button的点击事件
-(void)buttonClickedMethod:(UIButton *)button {

//    NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:0];
//    DDQRowTwoTableViewCell *cell = [self.intro_tableview cellForRowAtIndexPath:path];
//    if (self.delegate && [self.delegate respondsToSelector:@selector(intro_viewWithOrder:)]) {
//    if (cell.rt_showLabel.text == nil) {
//        
//        [self.delegate intro_viewWithOrder:[cell.rt_showLabel.text integerValue]];
//
//    } else {
//    
//        [self.delegate intro_viewWithOrder:1];
//
//    }
//    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(intro_selectedType)]) {
        
        [self.delegate intro_selectedType];
        
    }
//    if (self.delegate && [self.delegate respondsToSelector:@selector(intro_viewWithOrder:)]) {
//        
//        [self.delegate intro_viewWithOrder:0];
//        
//    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {

    return 10;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {

    return 0.1;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {

    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, 10)];
    view.backgroundColor = [UIColor backgroundColor];
    return view;
}


//tableview的代理方法
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        
        return 2;
    } else {

        return 1;
    }
}
static NSString *one_identifier = @"one";
static NSString *two_identifier = @"two";
static NSString *cell_identifier = @"cell";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && indexPath.row == 0) {
        
        [self.header_img sd_setImageWithURL:[NSURL URLWithString:self.intro_model.course_banner] placeholderImage:[UIImage imageNamed:@"default_big_pic"]];
        
        DDQRowOneTableViewCell *one_cell = [[DDQRowOneTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:one_identifier];
        one_cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
        if (self.intro_model.course_price != nil && ![self.intro_model.course_price isEqualToString:@""]) {
            
            NSAttributedString *atrributedString = [[NSAttributedString alloc] initWithString:[NSString stringWithFormat:@"￥%@",self.intro_model.course_price] attributes:@{NSForegroundColorAttributeName:[UIColor meiHongSe],NSFontAttributeName:[UIFont systemFontOfSize:20.0f]}];
            
            one_cell.RO_priceLabel.attributedText = atrributedString;
        } else {
        
            one_cell.RO_priceLabel.text = @"暂无";
        }
        
        if (self.intro_model.course_name != nil && ![self.intro_model.course_name isEqualToString:@""]) {
        
            one_cell.RO_lessonLabel.text = self.intro_model.course_name;
        } else {
            
            one_cell.RO_priceLabel.text = @"暂无";
        }
        return one_cell;
        
    } else if (indexPath.section == 0 && indexPath.row == 1) {
    
        DDQRowTwoTableViewCell *two_cell = [tableView dequeueReusableCellWithIdentifier:two_identifier];
        
        if (two_cell == nil) {
            two_cell = [[DDQRowTwoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:two_identifier];
        }
        two_cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return two_cell;
        
    } else {
    
        DDQRowThreeTableViewCell *cell = [[DDQRowThreeTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cell_identifier];
        cell.intro_model = self.intro_model;
        self.row_h = cell.row_h;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    }
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        return 60;
    } else {
        return self.row_h;
    }
}


@end
