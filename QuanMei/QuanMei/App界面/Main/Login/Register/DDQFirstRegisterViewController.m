//
//  DDQFirstRegisterViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/6.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQFirstRegisterViewController.h"
#import "DDQLoginViewController.h"
#import "DDQSecondRegisterViewController.h"

#import "DDQLoginSingleModel.h"

@interface DDQFirstRegisterViewController ()<UIPickerViewDataSource,UIPickerViewDelegate,UITextFieldDelegate>

/**
 *  我要作为载体View
 */
@property (strong,nonatomic) UIView *backgroundView;
/**
 *  显示两个小的图片
 */
@property (strong,nonatomic) UIImageView *userImageView;
@property (strong,nonatomic) UIImageView *dateImageView;
/**
 *  输入电话号码，密码的field
 */
@property (strong,nonatomic) UITextField *inputNameField;
@property (strong,nonatomic) UITextField *inputAgeField;
/**
 *  我要做一条华丽丽的分割线
 */
@property (strong,nonatomic) UIView *cuttingLineView;

@property (strong,nonatomic) UIPickerView *pickerView;
@property (strong,nonatomic) UIToolbar *pickerToolBar;

@property (strong,nonatomic) UIBarButtonItem *leftItem;
@property (strong,nonatomic) UIBarButtonItem *rightItem;

/**
 *  年
 */
@property (strong,nonatomic) NSMutableArray *yearArray;
/**
 *  月
 */
@property (strong,nonatomic) NSArray *monthArray;
/**
 *  日
 */
@property (strong,nonatomic) NSMutableArray *DaysArray;
/**
 *  UIPickView
 */
@property (strong,nonatomic) NSString *currentMonthString;
@property (assign,nonatomic) NSInteger selectedYearRow;
@property (assign,nonatomic) NSInteger selectedMonthRow;
@property (assign,nonatomic) NSInteger selectedDayRow;
@property (assign,nonatomic) BOOL firstTimeLoad;
@end

@implementation DDQFirstRegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view setBackgroundColor:[UIColor myGrayColor]];
    //初始化
    [self setPickerViewDataSource];
    [self layoutNavigationBar];
    [self layoutControlerView];
    self.firstTimeLoad = YES;
    self.pickerToolBar.hidden = YES;
    self.pickerView.hidden = YES;
}

//取消键盘
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

#pragma mark - layout navigationBar pickView controls
-(void)layoutNavigationBar {
    self.navigationItem.title = @"个人信息";
    UIBarButtonItem *rigthItem = [[UIBarButtonItem alloc] initWithTitle:@"下一步" style:UIBarButtonItemStyleDone target:self action:@selector(goToSecondViewController)];
    self.navigationItem.rightBarButtonItem = rigthItem;
    
    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"返回"] style:UIBarButtonItemStyleDone target:self action:@selector(goBackLoginViewController)];
    self.navigationItem.leftBarButtonItem = leftItem;
    
    self.navigationController.edgesForExtendedLayout = UIRectEdgeNone;
    
}

-(void)setPickerViewDataSource {
    NSDate *date = [NSDate date];
    
    //年
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//    [formatter setDateFormat:@"yyyy"];
    [formatter setDateFormat:@"yyyy-MM-dd"];

    
    NSString *yearString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];
    self.yearArray = [NSMutableArray array];
    for (int i = 1970; i<2050; i++) {
        [self.yearArray addObject:[NSString stringWithFormat:@"%d",i]];
    }
    
    //月
//    [formatter setDateFormat:@"MM"];
    self.currentMonthString = [NSString stringWithFormat:@"%ld",[[formatter stringFromDate:date] integerValue]];
    self.monthArray = @[@"1",@"2",@"3",@"4",@"5",@"6",@"7",@"8",@"9",@"10",@"11",@"12",];
    
    //日
//    [formatter setDateFormat:@"dd"];
    NSString *dateString = [NSString stringWithFormat:@"%@",[formatter stringFromDate:date]];

    self.DaysArray = [NSMutableArray array];
    for (int i = 1; i <= 31; i++){
        [self.DaysArray addObject:[NSString stringWithFormat:@"%d",i]];
        
    }
    
    [self.pickerView selectRow:[self.yearArray indexOfObject:yearString] inComponent:0 animated:YES];
    
    [self.pickerView selectRow:[self.monthArray indexOfObject:self.currentMonthString] inComponent:1 animated:YES];
    
    [self.pickerView selectRow:[self.DaysArray indexOfObject:dateString] inComponent:2 animated:YES];
}

-(void)layoutControlerView {
    //布局载体view
    self.backgroundView = [[UIView alloc] init];
    [self.view addSubview:self.backgroundView];
    
    [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
        if (kScreenHeight >= 667) {
            make.height.equalTo(self.view.mas_height).with.multipliedBy(0.15);//h
        } else {
            make.height.equalTo(self.view.mas_height).with.multipliedBy(0.15);//h
        }
        make.left.equalTo(self.view.mas_left);//x
        make.right.equalTo(self.view.mas_right);//w
        if (kScreenHeight == 480) {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.2);//y
        } else if (kScreenHeight == 568) {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.2);//y
        } else if (kScreenHeight == 667) {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.15);//y
        } else {
            make.top.equalTo(self.view.mas_top).with.offset(self.view.bounds.size.height*0.15);//y
        }
    }];
    
    [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
    
    //华丽丽的分割线
    self.cuttingLineView = [[UIView alloc] init];
    [self.backgroundView addSubview:self.cuttingLineView];
    
    [self.cuttingLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.height.equalTo(@1);//h
        make.centerX.equalTo(self.backgroundView.mas_centerX);//x
        make.centerY.equalTo(self.backgroundView.mas_centerY);//y
        make.width.equalTo(self.backgroundView.mas_width);//w
    }];
    
    [self.cuttingLineView setBackgroundColor:[UIColor myGrayColor]];
    
    //小手机
    self.userImageView = [[UIImageView alloc] init];
    [self.backgroundView addSubview:self.userImageView];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.view.bounds.size.width*0.05);//w
        make.bottom.equalTo(self.cuttingLineView.mas_bottom).with.offset(-self.view.bounds.size.height*0.02);//h
        make.left.equalTo(self.backgroundView.mas_left).with.offset(self.view.bounds.size.width*0.02);//x
        make.top.equalTo(self.backgroundView.mas_top).with.offset(self.view.bounds.size.height*0.02);//y
    }];
    
    [self.userImageView setImage:[UIImage imageNamed:@"nick_sign"]];
    self.userImageView.contentMode   = UIImageResizingModeStretch;
    
    //
    self.dateImageView = [[UIImageView alloc] init];
    [self.backgroundView addSubview:self.dateImageView];
    
    [self.dateImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.offset(self.view.bounds.size.width*0.05);//w
        make.bottom.equalTo(self.backgroundView.mas_bottom).with.offset(-self.view.bounds.size.height*0.02);//h
        make.left.equalTo(self.backgroundView.mas_left).with.offset(self.view.bounds.size.width*0.02);//x
        make.top.equalTo(self.cuttingLineView.mas_top).with.offset(self.view.bounds.size.height*0.02);//y
    }];
    
    [self.dateImageView setImage:[UIImage imageNamed:@"age_sign"]];
    self.dateImageView.contentMode   = UIImageResizingModeStretch;
    
    //
    self.inputNameField = [[UITextField alloc] init];
    [self.backgroundView addSubview:self.inputNameField];
    
    [self.inputNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.backgroundView.mas_top);//y
        make.left.equalTo(self.userImageView.mas_right).with.offset(self.view.bounds.size.width*0.02);//x
        make.height.equalTo(self.backgroundView.mas_height).with.multipliedBy(0.5);//h
        make.right.equalTo(self.backgroundView.mas_right);//w
    }];
    self.inputNameField.delegate = self;
    [self.inputNameField setPlaceholder:@"请输入昵称"];
    
    //输入密码
    self.inputAgeField = [[UITextField alloc] init];
    [self.backgroundView addSubview:self.inputAgeField];
    
    [self.inputAgeField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.userImageView.mas_right).with.offset(self.view.bounds.size.width*0.02);//x
        make.top.equalTo(self.cuttingLineView.mas_bottom);//y
        make.right.equalTo(self.backgroundView.mas_right);//w
        make.height.equalTo(self.inputNameField.mas_height);//h
    }];
    
    [self.inputAgeField setPlaceholder:@"请输入年龄"];
    self.inputAgeField.delegate = self;
    
    //布局pickerView
    self.pickerView = [[UIPickerView alloc] init];
    [self.view addSubview:self.pickerView];
    [self.pickerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left);
        make.right.equalTo(self.view.mas_right);
        make.height.equalTo(self.view.mas_height).with.multipliedBy(0.3);
        make.bottom.equalTo(self.view.mas_bottom);
    }];
    self.pickerView.delegate = self;
    self.pickerView.dataSource = self;
    
    self.pickerToolBar = [[UIToolbar alloc] init];
    [self.view addSubview:self.pickerToolBar];
    [self.pickerToolBar mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.pickerView.mas_top);
        make.left.equalTo(self.pickerView.mas_left);
        make.right.equalTo(self.pickerView.mas_right);
        make.height.equalTo(self.pickerView.mas_height).with.multipliedBy(0.3);
    }];
    self.leftItem = [[UIBarButtonItem alloc] initWithTitle:@"确定" style:UIBarButtonItemStyleDone target:self action:@selector(sureItemTouchEvent)];
    
    UIBarButtonItem *middleItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    
    self.rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelItemTouchEvent)];
    
    self.pickerToolBar.items = @[self.leftItem,middleItem,self.rightItem];
    
}
#pragma mark - toolBar item target action
-(void)sureItemTouchEvent{
    self.inputAgeField.text = [NSString stringWithFormat:@"%@-%@-%@",[self.yearArray objectAtIndex:[self.pickerView selectedRowInComponent:0]],[self.monthArray objectAtIndex:[self.pickerView selectedRowInComponent:1]],[self.DaysArray objectAtIndex:[self.pickerView selectedRowInComponent:2]]];
    
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.pickerView.hidden = YES;
                         self.pickerToolBar.hidden = YES;
                     }
                     completion:^(BOOL finished){
                         
                     }];
    
}

- (void)cancelItemTouchEvent{
    [UIView animateWithDuration:0.5
                          delay:0.1
                        options: UIViewAnimationOptionCurveEaseIn
                     animations:^{
                         self.pickerView.hidden = YES;
                         self.pickerToolBar.hidden = YES;
                     }
                     completion:^(BOOL finished){
                     }];
    
}

#pragma mark - 正则表达式
+ (BOOL)validateNickName:(NSString *)nickName{
    NSString *passWordRegex = @"^[(\u4e00-\u9fa5)|(a-zA-Z)]{2,10}$";
    NSPredicate *passWordPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",passWordRegex];
    return [passWordPredicate evaluateWithObject:nickName];
}

#pragma mark - 本地验证 返回BOOL值
-(BOOL)LocalValidation {
    
    if (_inputNameField.text == nil || [_inputNameField.text isEqualToString:@""]) {
        
        [self alertController:@"请输入昵称"];
        return NO;
        
    }else if (![DDQFirstRegisterViewController validateNickName:_inputNameField.text]){
        
        [self alertController:@"昵称不符合要求"];
        return NO;
        
    } else if ([_inputAgeField.text isEqualToString:@""] || _inputAgeField == nil) {
        
        [self alertController:@"请输入年龄"];
        return NO;
        
    } else {
    
        return YES;

    }
    
}

#pragma mark - navigationBar item target action
-(void)goToSecondViewController {
    DDQSecondRegisterViewController *secondRVC = [[DDQSecondRegisterViewController alloc] init];
    BOOL yesOrNo = [self LocalValidation];
    if (yesOrNo == YES) {
        NSDateFormatter *date_formatter = [[NSDateFormatter alloc] init];
        [date_formatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [date_formatter dateFromString:self.inputAgeField.text];
        NSLog(@"%@",date);
        NSComparisonResult result = [date compare:[NSDate date]];
        NSLog(@"%ld",result);
        if (result == -1) {
            DDQLoginSingleModel *model = [DDQLoginSingleModel singleModelByValue];
            model.nameString = self.inputNameField.text;
            model.userBorn = self.inputAgeField.text;
            [self.navigationController pushViewController:secondRVC animated:NO];
        } else {
        
            [self alertController:@"日期不能超过当前时间"];

        }
            
//        }
    }
}

-(void)goBackLoginViewController {
    self.inputNameField.text = nil;
    self.inputAgeField.text = nil;
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark - other method 
-(void)alertController:(NSString *)message {
    UIAlertController *userNameAlert = [UIAlertController alertControllerWithTitle:@"提示" message:message preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *actionOne = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
    UIAlertAction *actionTwo = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
    [userNameAlert addAction:actionOne];
    [userNameAlert addAction:actionTwo];
    [self presentViewController:userNameAlert animated:YES completion:nil];
}

#pragma mark - pickView delegate and dataSource
- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (component == 0){
        self.selectedYearRow = row;
        [self.pickerView reloadAllComponents];
    }else if (component == 1){
        self.selectedMonthRow = row;
        [self.pickerView reloadAllComponents];
    }else if (component == 2){
        self.selectedDayRow = row;
        [self.pickerView reloadAllComponents];
    }
    
}
- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
    UILabel *pickerLabel = (UILabel *)view;
    
    if (pickerLabel == nil) {
        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
        pickerLabel = [[UILabel alloc] initWithFrame:frame];
        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
        [pickerLabel setBackgroundColor:[UIColor whiteColor]];
        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
        pickerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
        pickerLabel.textColor = [UIColor meiHongSe];
        
    }
    if (component == 0){
        pickerLabel.text =  [self.yearArray objectAtIndex:row]; // Year
    }else if (component == 1){
        pickerLabel.text =  [self.monthArray objectAtIndex:row];  // Month
    }else if (component == 2){
        pickerLabel.text =  [self.DaysArray objectAtIndex:row]; // Date
    }
    return pickerLabel;
}
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    return 3;
}
- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    if (component == 0){
        return [self.yearArray count];
    }else if (component == 1){
        return [self.monthArray count];
    }else { // day
        
        if (self.firstTimeLoad){
            if ([_currentMonthString integerValue] == 1 || [_currentMonthString integerValue] == 3 || [_currentMonthString integerValue] == 5 || [_currentMonthString integerValue] == 7 || [_currentMonthString integerValue] == 8 || [_currentMonthString integerValue] == 10 || [_currentMonthString integerValue] == 12) {
                return 31;
            }else if ([_currentMonthString integerValue] == 2) {
                int yearint = [[self.yearArray objectAtIndex:self.selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }else{
                    return 28; // or return 29
                }
            }else{
                return 30;
            }
        }else{
            
            if (_selectedMonthRow == 0 || _selectedMonthRow == 2 || _selectedMonthRow == 4 || _selectedMonthRow == 6 || _selectedMonthRow == 7 || _selectedMonthRow == 9 || _selectedMonthRow == 11){
                return 31;
            }else if (_selectedMonthRow == 1){
                int yearint = [[_yearArray objectAtIndex:_selectedYearRow]intValue ];
                
                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
                    return 29;
                }else{
                    return 28; // or return 29
                }
            }else{
                return 30;
            }
        }
    }
}
#pragma mark - textField delegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    if (textField == self.inputAgeField) {
        [self.view endEditing:YES];
    }
}

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    if (textField == self.inputAgeField) {
        [UIView animateWithDuration:0.5
                              delay:0.1
                            options: UIViewAnimationOptionCurveEaseIn
                         animations:^{
                             self.pickerToolBar.hidden = NO;
                             self.pickerView.hidden = NO;
                             self.inputAgeField.text = @"";
                         }
                         completion:^(BOOL finished){
                             
                         }];
        self.pickerView.hidden = NO;
        self.pickerToolBar.hidden = NO;
        self.inputAgeField.text = @"";
        [self.view endEditing:YES];
        return YES;
    } else {
        return YES;
    }
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    textField.returnKeyType = UIReturnKeyDone;
    [textField resignFirstResponder];
    return  YES;
}

@end
