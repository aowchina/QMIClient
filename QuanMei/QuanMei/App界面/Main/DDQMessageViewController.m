  //
//  DDQMessageViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/11.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQMessageViewController.h"
#import "DDQParentMessageViewController.h"
#import "DDQMessageCell.h"

@interface DDQMessageViewController ()<UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *message_mainTableView;

@property (strong,nonatomic) NSString *dateString;

@end

@implementation DDQMessageViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self.message_mainTableView registerNib:[UINib nibWithNibName:@"DDQMessageCell" bundle:nil]
    forCellReuseIdentifier:@"message"];
    
    self.message_mainTableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.message_mainTableView.backgroundColor = [UIColor backgroundColor];
    self.message_mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.messageVC_replyCnt = [[[NSUserDefaults standardUserDefaults] valueForKey:@"replyCount"] intValue];
    
    self.messageVC_zanCnt = [[[NSUserDefaults standardUserDefaults] valueForKey:@"zanCount"] intValue];
}

- (void)viewWillAppear:(BOOL)animated {

    [super viewWillAppear:animated];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 50)];
    label.text = @"消息提示";
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor meiHongSe];
    self.navigationItem.titleView = label;
    self.navigationController.navigationBar.tintColor = [UIColor meiHongSe];
    self.navigationController.navigationBar.translucent = NO;

}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 1;
}

static NSString *identifier = @"cell";

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    
    DDQMessageCell *messageCell = [tableView dequeueReusableCellWithIdentifier:@"message"];
    
//    if (!messageCell) {
    
//        messageCell = [[DDQMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
    
        if (self.messageVC_replyCnt != 0 || self.messageVC_zanCnt != 0) {
            
            if (self.messageVC_replyCnt != 0) {
                messageCell.mesCell_introLabel.text = [NSString stringWithFormat:@"你有%d个回复",self.messageVC_replyCnt];
            } else {
            
                 messageCell.mesCell_introLabel.text = [NSString stringWithFormat:@"你有%d个赞",self.messageVC_zanCnt];
            }
            
        } else if (self.messageVC_replyCnt != 0 && self.messageVC_zanCnt != 0 ) {
        
            messageCell.mesCell_introLabel.text = [NSString stringWithFormat:@"你有%d个赞+%d个回复",self.messageVC_zanCnt,self.messageVC_replyCnt];
        }
    if (![[[NSUserDefaults standardUserDefaults] valueForKey:@"zanData"] isEqual:nil] || ![[[NSUserDefaults standardUserDefaults] valueForKey:@"replyData"] isEqual:nil]) {
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"zanData"]) {
            
            messageCell.mesCell_pubtimeLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"zanData"];
        } else {
            
            messageCell.mesCell_pubtimeLabel.text = [[NSUserDefaults standardUserDefaults] valueForKey:@"replyData"];

        }
    }
    messageCell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return messageCell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 60;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    DDQParentMessageViewController *parentMessageVC = [DDQParentMessageViewController new];
    parentMessageVC.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:parentMessageVC animated:YES];
}

@end
