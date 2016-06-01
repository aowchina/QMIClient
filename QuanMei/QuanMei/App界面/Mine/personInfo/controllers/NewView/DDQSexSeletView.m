//
//  DDQSexSeletView.m
//  QuanMei
//
//  Created by min－fo018 on 16/5/23.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQSexSeletView.h"

@implementation DDQSexSeletView

- (IBAction)man_buttonSelectedMethod:(UIButton *)sender {
    
//    if (sender.isSelected == NO) {
//        
//        [sender setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
//        [sender setSelected:YES]
//        ;
//        self.w
//    } else {
//    
//        [sender setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
//        [sender setSelected:NO]
//        ;
//    }

    if (self.man_block) {
        
        self.man_block(self);
        
    }
    
}
- (IBAction)women_buttonSelectedMethod:(UIButton *)sender {
//    
//    if (sender.isSelected == NO) {
//        
//        [sender setBackgroundImage:[UIImage imageNamed:@"选中"] forState:UIControlStateNormal];
//        [sender setSelected:YES]
//        ;
//    } else {
//        
//        [sender setBackgroundImage:[UIImage imageNamed:@"未选中"] forState:UIControlStateNormal];
//        [sender setSelected:NO]
//        ;
//    }

    if (self.woman_block) {
        
        self.woman_block(self);
        
    }
    
}

- (void)sex_manSelected:(Man)man {

    if (man) {
        
        self.man_block = man;
        
    }
    
}

- (void)sex_womanSelected:(Woman)woman {

    if (woman) {
        
        self.woman_block = woman;
        
    }
    
}

@end
