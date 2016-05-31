//
//  DDQSearchBar.h
//  QuanMei
//
//  Created by min－fo018 on 16/4/22.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchDelegate <NSObject>

@optional
- (void)searchBarBegainEditing:(UITextField *)textField;
- (void)searchBarEndEditing:(NSString *)text;


@end

@interface DDQSearchBar : UIView

@property ( strong, nonatomic) NSString *placeholder;

@property ( strong, nonatomic) NSAttributedString *attributeHolder;

@property ( weak, nonatomic) id <SearchDelegate> delegate;

@property ( readonly, nonatomic) UITextField *inputField;

@end

