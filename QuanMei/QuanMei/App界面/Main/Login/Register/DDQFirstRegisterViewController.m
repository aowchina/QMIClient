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
@property (strong,nonatomic) UILabel *inputAgeLabel;
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
        
        make.height.mas_equalTo(40);//h

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

    //小手机
    self.userImageView = [[UIImageView alloc] init];
    [self.backgroundView addSubview:self.userImageView];
    
    [self.userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.centerY.equalTo(self.backgroundView.mas_centerY);
        make.width.and.height.mas_equalTo(12.0);
        make.left.equalTo(self.backgroundView.mas_left).offset(8.0);
        
    }];
    
    [self.userImageView setImage:[UIImage imageNamed:@"nick_sign"]];
    self.userImageView.contentMode   = UIImageResizingModeStretch;
    
    self.inputNameField = [[UITextField alloc] init];
    [self.backgroundView addSubview:self.inputNameField];
    
    [self.inputNameField mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.left.equalTo(self.userImageView.mas_right).offset(3.0);
        make.centerY.equalTo(self.userImageView.mas_centerY);
        make.right.equalTo(self.backgroundView.mas_right);
        make.height.equalTo(self.backgroundView.mas_height);

    }];
    self.inputNameField.delegate = self;
    [self.inputNameField setPlaceholder:@"请输入昵称"];
    
}

#pragma mark - toolBar item target action
-(void)sureItemTouchEvent{
    self.inputAgeLabel.text = [NSString stringWithFormat:@"%@-%@-%@",[self.yearArray objectAtIndex:[self.pickerView selectedRowInComponent:0]],[self.monthArray objectAtIndex:[self.pickerView selectedRowInComponent:1]],[self.DaysArray objectAtIndex:[self.pickerView selectedRowInComponent:2]]];
    
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
        
    }  else {
        
        return YES;
        
    }
    
}

#pragma mark - navigationBar item target action
-(void)goToSecondViewController {
    DDQSecondRegisterViewController *secondRVC = [[DDQSecondRegisterViewController alloc] init];
    
    //获取当前时间
    NSDate *date = [NSDate date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    unsigned int unitFlags = NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit;
    NSDateComponents *components = [calendar components:unitFlags fromDate:date];
    NSArray *dateArray = @[@(components.month).stringValue, @(components.day).stringValue];
    
    NSMutableString *dateFormatter = [[NSMutableString alloc] initWithString:@(components.year).stringValue];
    
    for (NSInteger i = 0; i < dateArray.count; i++) {
        
        [dateFormatter appendFormat:@"-%@", [dateArray objectAtIndex:i]];
        
    }
    
    DDQLoginSingleModel *model = [DDQLoginSingleModel singleModelByValue];
    model.nameString = self.inputNameField.text;
    model.userBorn = dateFormatter;
    [self.navigationController pushViewController:secondRVC animated:NO];
    
}

-(void)goBackLoginViewController {
    
    self.inputNameField.text = nil;
    self.inputAgeLabel.text = nil;
    [self.view endEditing:YES];
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
//- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
//    if (component == 0){
//        self.selectedYearRow = row;
//        [self.pickerView reloadAllComponents];
//    }else if (component == 1){
//        self.selectedMonthRow = row;
//        [self.pickerView reloadAllComponents];
//    }else if (component == 2){
//        self.selectedDayRow = row;
//        [self.pickerView reloadAllComponents];
//    }
//    
//}
//- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view {
//    UILabel *pickerLabel = (UILabel *)view;
//    
//    if (pickerLabel == nil) {
//        CGRect frame = CGRectMake(0.0, 0.0, 50, 60);
//        pickerLabel = [[UILabel alloc] initWithFrame:frame];
//        [pickerLabel setTextAlignment:NSTextAlignmentCenter];
//        [pickerLabel setBackgroundColor:[UIColor whiteColor]];
//        [pickerLabel setFont:[UIFont systemFontOfSize:15.0f]];
//        pickerLabel.font = [UIFont fontWithName:@"HelveticaNeue-Bold" size:15.0];
//        pickerLabel.textColor = [UIColor meiHongSe];
//        
//    }
//    if (component == 0){
//        pickerLabel.text =  [self.yearArray objectAtIndex:row]; // Year
//    }else if (component == 1){
//        pickerLabel.text =  [self.monthArray objectAtIndex:row];  // Month
//    }else if (component == 2){
//        pickerLabel.text =  [self.DaysArray objectAtIndex:row]; // Date
//    }
//    return pickerLabel;
//}
//- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
//    return 3;
//}
//- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
//    
//    if (component == 0){
//        return [self.yearArray count];
//    }else if (component == 1){
//        return [self.monthArray count];
//    }else { // day
//        
//        if (self.firstTimeLoad){
//            if ([_currentMonthString integerValue] == 1 || [_currentMonthString integerValue] == 3 || [_currentMonthString integerValue] == 5 || [_currentMonthString integerValue] == 7 || [_currentMonthString integerValue] == 8 || [_currentMonthString integerValue] == 10 || [_currentMonthString integerValue] == 12) {
//                return 31;
//            }else if ([_currentMonthString integerValue] == 2) {
//                int yearint = [[self.yearArray objectAtIndex:self.selectedYearRow]intValue ];
//                
//                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
//                    return 29;
//                }else{
//                    return 28; // or return 29
//                }
//            }else{
//                return 30;
//            }
//        }else{
//            
//            if (_selectedMonthRow == 0 || _selectedMonthRow == 2 || _selectedMonthRow == 4 || _selectedMonthRow == 6 || _selectedMonthRow == 7 || _selectedMonthRow == 9 || _selectedMonthRow == 11){
//                return 31;
//            }else if (_selectedMonthRow == 1){
//                int yearint = [[_yearArray objectAtIndex:_selectedYearRow]intValue ];
//                
//                if(((yearint %4==0)&&(yearint %100!=0))||(yearint %400==0)){
//                    return 29;
//                }else{
//                    return 28; // or return 29
//                }
//            }else{
//                return 30;
//            }
//        }
//    }
//}
#pragma mark - textField delegate
//- (void)showPickView {
//
//    [UIView animateWithDuration:1.0 animations:^{
//        
//        self.pickerToolBar.hidden = NO;
//        self.pickerView.hidden = NO;
//        self.inputAgeLabel.text = @"";
//        
//    }];
//
//}


@end
