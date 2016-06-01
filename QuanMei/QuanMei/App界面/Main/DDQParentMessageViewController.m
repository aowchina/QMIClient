//
//  DDQParentMessageViewController.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/11.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQParentMessageViewController.h"

#import "DDQMyReplyedViewController.h"
#import "DDQMyZanedViewController.h"
@interface DDQParentMessageViewController ()
@property (weak, nonatomic) IBOutlet UIButton *pm_replyButton;
@property (weak, nonatomic) IBOutlet UIButton *pm_zanButton;
@property (strong,nonatomic) UIButton *temp_button;

@property (strong,nonatomic) DDQMyReplyedViewController *myReplyedVC;
@property (strong,nonatomic) DDQMyZanedViewController *myZanedVC;

@end

@implementation DDQParentMessageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.pm_replyButton setFrame:CGRectMake(0, 0, kScreenWidth*0.5, 50)];
    [self.pm_zanButton setFrame:CGRectMake(0, 0, kScreenWidth*0.5, 50)];

    self.pm_replyButton.backgroundColor = [UIColor whiteColor];
    [self.pm_replyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.pm_zanButton.backgroundColor = kLeftColor;
    [self.pm_zanButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.temp_button = self.pm_replyButton;

    self.myReplyedVC = [DDQMyReplyedViewController new];
    [self addChildViewController:self.myReplyedVC];
    
    self.myReplyedVC.view.frame = CGRectMake(0, self.pm_replyButton.frame.size.height-5, self.view.frame.size.width, kScreenHeight);
    
    [self.view addSubview:self.myReplyedVC.view];
    
    self.myZanedVC = [DDQMyZanedViewController new];
    [self addChildViewController:self.myZanedVC];
    
    self.myZanedVC.view.frame = CGRectMake(0, self.pm_replyButton.frame.size.height-5, self.view.frame.size.width, kScreenHeight);
    
    [self.view addSubview:self.myZanedVC.view];

    [self.view insertSubview:self.myReplyedVC.view aboveSubview:self.myZanedVC.view];
    
    
    if ([[NSUserDefaults standardUserDefaults] valueForKey:@"zanData"] || [[NSUserDefaults standardUserDefaults] valueForKey:@"replyData"]) {
        
        if ([[NSUserDefaults standardUserDefaults] valueForKey:@"zanData"]) {
            
            UIImageView *cicrle_view = [[UIImageView alloc] init];
            [self.pm_zanButton.titleLabel addSubview:cicrle_view];
            [cicrle_view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.pm_zanButton.titleLabel.mas_right);
                make.top.equalTo(self.pm_zanButton.titleLabel.mas_top);
                make.width.offset(5);
                make.height.offset(5);
            }];
            cicrle_view.image = [UIImage imageNamed:@"椭圆"];
            
        } else {
        
            UIImageView *cicrle_view = [[UIImageView alloc] init];
            [self.pm_replyButton.titleLabel addSubview:cicrle_view];
            [cicrle_view mas_makeConstraints:^(MASConstraintMaker *make) {
                make.right.equalTo(self.pm_replyButton.titleLabel.mas_right);
                make.top.equalTo(self.pm_replyButton.titleLabel.mas_top);
                make.width.offset(5);
                make.height.offset(5);
            }];
            cicrle_view.image = [UIImage imageNamed:@"椭圆"];
        }
    }
    
}

- (IBAction)replyAndZanButtonMethod:(UIButton *)sender {
    
    if (self.temp_button == sender) return;
    
    sender.backgroundColor = [UIColor whiteColor];
    
    [sender setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    
    self.temp_button.backgroundColor = kLeftColor;
    
    [self.temp_button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    self.temp_button = sender;
    
    if (sender.tag == 1) {
        [self.view bringSubviewToFront:self.myReplyedVC.view];
    } else {
    
        [self.view bringSubviewToFront:self.myZanedVC.view];
    }

}


@end
