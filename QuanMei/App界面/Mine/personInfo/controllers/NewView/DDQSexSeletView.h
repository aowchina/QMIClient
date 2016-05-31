//
//  DDQSexSeletView.h
//  QuanMei
//
//  Created by min－fo018 on 16/5/23.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DDQSexSeletView;
typedef void(^Man)(DDQSexSeletView *view);
typedef void(^Woman)(DDQSexSeletView *view);

@interface DDQSexSeletView : UIView

@property (weak, nonatomic) IBOutlet UIButton *man_button;
@property (weak, nonatomic) IBOutlet UIButton *women_button;

@property ( copy, nonatomic) Man man_block;
@property ( copy, nonatomic) Woman woman_block;

- (void)sex_manSelected:(Man)man;
- (void)sex_womanSelected:(Woman)woman;

@end
