//
//  DDQMessageSetViewController.m
//  QuanMei
//
//  Created by min-fo013 on 15/10/15.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQMessageSetViewController.h"

#import "DDQSetMessageCell.h"




@interface DDQMessageSetViewController ()<UITableViewDataSource,UITableViewDelegate,DDQSetMessageCellDelegate>

@property (nonatomic, strong)UITableView *tableView;
//@property (nonatomic, strong)NSArray *cellConnfigArray;
@property (nonatomic, strong)NSArray *textArray;

@end

static NSString *kcellWithSwitch = @"switchCell";
static NSString *kcell = @"noSwitchCell";

@implementation DDQMessageSetViewController

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
//title数据源 懒加载
-(NSArray *)textArray {
    if (_textArray == nil) {
        self.textArray = [NSArray array];
    }
    return _textArray;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.textArray = @[@"新消息通知",@"声音",@"振动",@"免扰时段",@"清空所有消息"];
    [self buildTableView];
    //注册cell
    [self.tableView registerClass:[DDQSetMessageCell class] forCellReuseIdentifier:kcellWithSwitch];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    self.tableView.frame = self.view.bounds;
}
- (void)buildTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.tableHeaderView = [[UIView alloc] init];
    [self.view addSubview:self.tableView];
}


#pragma mark - tableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else if (section == 1) {
        return 2;
    }else if (section == 2) {
        return 1;
    }else {
        return 1;
    }
}
//分区
- (nullable NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        NSString *string = @"23:00 - 8:00接收通知将不会有声音和振动";
        
        return string;
    }else {
        return nil;
    }
}
//分区区头设置
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 3) {
        return 40;
    }else {
        return 10;
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
   
        return 0;
    
}
//分行
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//    return 10;
//}

#pragma mark - tableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //第四分区
    if (indexPath.section == 3) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kcell];
        if (!cell) {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kcell];
        }
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = self.textArray.lastObject;
        cell.textLabel.font = [UIFont systemFontOfSize:17.f];
        cell.textLabel.textColor = [UIColor blackColor];
        cell.textLabel.textAlignment = NSTextAlignmentLeft;
        return cell;
    }else {   //其他分区
        DDQSetMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:kcellWithSwitch];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.delegate = self;
        if (indexPath.section == 0 && indexPath.row == 0) {
            
            cell.textLabel.text = self.textArray[0];
            cell.tag = 0;
            
        }else if (indexPath.section == 1 && indexPath.row == 0) {
            
            cell.textLabel.text = self.textArray[1];
            cell.tag = 1;
            
        }else if (indexPath.section == 1 && indexPath.row == 1) {
            
            cell.textLabel.text = self.textArray[2];
            cell.tag = 2;
            
        }else {
            cell.tag = 3;
            cell.textLabel.text = self.textArray[3];
        }
        return cell;
    }
}

#pragma mark -   设置开关按钮的代理方法
- (void)DDQSettingCell:(DDQSetMessageCell *)cell DidChangeSwitchState:(BOOL)switchState {
    //分别在此设置4个switch的功能
    if (cell.tag == 0) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"notification"];

        if (switchState != [[[NSUserDefaults standardUserDefaults] valueForKey:@"notification"] boolValue]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"notification"];
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:switchState] forKey:@"notification"];
        }
        
    }else if (cell.tag == 1) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"voice"];
        
        if (switchState != [[[NSUserDefaults standardUserDefaults] valueForKey:@"voice"] boolValue]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"voice"];
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:switchState] forKey:@"voice"];
        }


    }else if (cell.tag == 2) {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"vibrate"];
        
        if (switchState != [[[NSUserDefaults standardUserDefaults] valueForKey:@"vibrate"] boolValue]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"vibrate"];
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:switchState] forKey:@"vibrate"];
        }

    }else {
        [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:NO] forKey:@"free"];
        
        if (switchState != [[[NSUserDefaults standardUserDefaults] valueForKey:@"free"] boolValue]) {
            [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"free"];
            [[NSUserDefaults standardUserDefaults] setValue:[NSNumber numberWithBool:switchState] forKey:@"free"];
        }

    }
}


@end
