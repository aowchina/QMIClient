//
//  DDQSearchBar.m
//  QuanMei
//
//  Created by min－fo018 on 16/4/22.
//  Copyright © 2016年 min-fo. All rights reserved.
//

#import "DDQSearchBar.h"

@interface DDQSearchBar ()<UITextFieldDelegate>

@property ( strong, nonatomic) UIImageView *leftImage;
@property ( readwrite, nonatomic) UITextField *inputField;

@end


@implementation DDQSearchBar

- (instancetype)initWithFrame:(CGRect)frame {

    self = [super initWithFrame:frame];
    
    if (self) {
        
        self.leftImage = [[UIImageView alloc] init];
        [self addSubview:self.leftImage];
        [self.leftImage mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.equalTo(self.mas_centerY);
            make.left.equalTo(self.mas_left).offset(self.frame.size.height/2);
            make.width.and.height.offset(15);
            
        }];
        self.leftImage.image = [UIImage imageNamed:@"chat_group_iconserch"];
        
        self.inputField = [[UITextField alloc] init];
        [self addSubview:self.inputField];
        [self.inputField mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.leftImage.mas_right).offset(5);
            make.height.offset(35);
            make.right.equalTo(self.mas_right).offset(- self.frame.size.height/2);
            make.centerY.equalTo(self.mas_centerY).offset(2);
            
        }];
        self.inputField.borderStyle = UITextBorderStyleNone;
        
    }
    
    return self;
    
}

- (void)layoutSubviews {
    
    [super layoutSubviews];
    
    if (self.placeholder != nil) {
        
        self.inputField.placeholder = self.placeholder;
        
    }
    
    if (self.attributeHolder != nil) {
        
        self.inputField.attributedPlaceholder = self.attributeHolder;
        
    }
    
    self.inputField.delegate = self;
    
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarBegainEditing:)]) {
        
        [self.delegate searchBarBegainEditing:textField];
        
    }
    
}

- (BOOL)textFieldShouldClear:(UITextField *)textField {

    return YES;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchBarEndEditing:)]) {
        
        [self.delegate searchBarEndEditing:textField.text];
        
    }
    
}

@end
