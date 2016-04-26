//
//  MBProgressHUD+EBUsHUD.m
//  EBeautify
//
//  Created by Min-Fo_003 on 15/11/24.
//  Copyright © 2015年 min-fo013. All rights reserved.
//

#import "MBProgressHUD+EBUsHUD.h"

@implementation MBProgressHUD (EBUsHUD)

+(void)myCustomHudWithView:(UIView *)view andCustomText:(NSString *)text andShowDim:(BOOL)isShow andSetDelay:(BOOL)isDelay andCustomView:(UIView *)customView{

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.labelText = text;
    hud.dimBackground = isShow;
    if (customView != nil) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = customView;
        [hud show:YES];
    }
    if (isDelay == YES) {
        [hud hide:YES afterDelay:2];
    }
}

@end
