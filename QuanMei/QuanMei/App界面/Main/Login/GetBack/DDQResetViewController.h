//
//  DDQResetViewController.h
//  QuanMei
//
//  Created by Min-Fo_003 on 15/12/7.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ResetVCDelegate <NSObject>

@optional
-(void)resetVCNotificationMethod;

@end


@interface DDQResetViewController : UIViewController

@property (weak,nonatomic) id <ResetVCDelegate> delegate;

@property (copy,nonatomic) NSString *phoneNum;


@end
