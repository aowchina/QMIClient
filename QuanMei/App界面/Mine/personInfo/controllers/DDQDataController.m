//
//  DDQDataController.m
//  QuanMei
//
//  Created by superlian on 15/12/1.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQDataController.h"
#import "ZHPickView.h"
#import "SLValue Singleton.h"
#import "DDQPersonalDataViewController.h"

@interface DDQDataController ()<ZHPickViewDelegate>

//时间选择
@property (nonatomic, strong) ZHPickView *dataPickView;

@end

@implementation DDQDataController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self buildView];
}

- (void)buildView {
    UIView *backgroundView = [[UIView alloc] initWithFrame:self.view.bounds];
    backgroundView.backgroundColor = [UIColor whiteColor];
    backgroundView.alpha = 0.1;
    NSDate *date=[NSDate dateWithTimeIntervalSinceNow:9000000];
    self.dataPickView=[[ZHPickView alloc] initDatePickWithDate:date datePickerMode:UIDatePickerModeDate isHaveNavControler:NO];

    [self.dataPickView setToolbarTintColor:[UIColor whiteColor]];
    [self.dataPickView setTintColor:[UIColor blackColor]];
    self.dataPickView.center = self.view.center;
    self.dataPickView.delegate = self;
    
    self.dataPickView.backgroundColor = [UIColor whiteColor];
    
    backgroundView.alpha = 0.1;
    [self.view addSubview:backgroundView];
    [self.view addSubview:self.dataPickView];
}


#pragma mark - ZHPickViewDelegate
-(void)toobarDonBtnHaveClick:(ZHPickView *)pickView resultString:(NSString *)resultString {
    [SLValue_Singleton shareInstance].pickTimeStr = resultString;
    [self dismissViewControllerAnimated:YES completion:^{
        [[NSNotificationCenter defaultCenter] postNotificationName:@"age" object:nil];
    }];
}
-(void)ZHPickView:(ZHPickView *)pickView cancelBtnDidClick:(UIBarButtonItem *)barButtonItem {
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
@end
