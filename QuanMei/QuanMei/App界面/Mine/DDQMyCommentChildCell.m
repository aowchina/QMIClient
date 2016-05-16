//
//  DDQMyCommentChildCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/10.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQMyCommentChildCell.h"

@interface DDQMyCommentChildCell ()

@property ( strong, nonatomic) UIView *background_view;

@end

@implementation DDQMyCommentChildCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.background_view = [[UIView alloc] init];
        [self.contentView addSubview:self.background_view];
        self.backgroundColor = [UIColor backgroundColor];
        self.background_view.backgroundColor = [UIColor whiteColor];
        [self.background_view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);

        }];
        
    }
    
    return self;
    
}

-(void)setCommentChildModel:(DDQMyCommentChildModel *)commentChildModel {

    self.hfId = commentChildModel.iD;
    //用户头像
    CGFloat img_w;
    CGFloat img_h;
    if (kScreenWidth == 320) {
        img_w = 35;
        img_h = 35;
    } else {
        img_w = 35;
        img_h = 35;
    }
    UIImageView *userimg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, img_w, img_h)];
    [self.background_view addSubview:userimg];
    [userimg sd_setImageWithURL:[NSURL URLWithString:commentChildModel.userimg] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    userimg.layer.cornerRadius = img_h*0.5;
    userimg.layer.masksToBounds= YES;
    userimg.tag                = 1;
    
    //用户名
    CGRect nickRect = [commentChildModel.username boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil];
    
    UILabel *username_label = [[UILabel alloc] init];
    [self.background_view addSubview:username_label];
    [username_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(userimg.mas_centerY);
        make.width.offset(nickRect.size.width);
        make.height.offset(nickRect.size.height);
        make.left.equalTo(userimg.mas_right).offset(10);
    }];
    username_label.numberOfLines = 0;
    username_label.text          = commentChildModel.username;
    username_label.font          = [UIFont systemFontOfSize:11.0f];
    username_label.tag           = 2;
    
    //发布时间
    CGRect pubtimeRect = [commentChildModel.pubtime boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil];
    
    UILabel *pubtime_label = [[UILabel alloc] init];
    [self.background_view addSubview:pubtime_label];
    [pubtime_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(username_label.mas_centerY);
        make.width.offset(pubtimeRect.size.width);
        make.height.offset(pubtimeRect.size.height);
        make.left.equalTo(username_label.mas_right).offset(10);
    }];
    pubtime_label.numberOfLines = 0;
    pubtime_label.text          = commentChildModel.pubtime;
    pubtime_label.font          = [UIFont systemFontOfSize:11.0f];
    pubtime_label.tag           = 3;

    //评论内容
    CGRect introRect = [commentChildModel.title boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];;

//    if ([commentChildModel.title isKindOfClass:[NSNull class]]) {
//        introRect = [commentChildModel.title boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
//        commentChildModel.title = @"";
//    }
    
    UILabel *intro_label = [[UILabel alloc] initWithFrame:CGRectMake(img_w, 20+img_h, kScreenWidth - 20, introRect.size.height)];
    [self.background_view addSubview:intro_label];
    intro_label.numberOfLines = 0;
    intro_label.font          = [UIFont systemFontOfSize:13.0f];
    intro_label.text          = commentChildModel.title;
    intro_label.tag           = 4;
    
//    if (![commentChildModel.intro isKindOfClass:[NSNull class]]) {
        //对谁回复
    NSString *new_string;
    
    if (![commentChildModel.username2 isEqualToString:@""]) {
         new_string = [NSString stringWithFormat:@"%@:%@",commentChildModel.username2,commentChildModel.intro];
    } else {
        new_string = [NSString stringWithFormat:@"%@",commentChildModel.intro];

    }
    
        CGRect newRect = [new_string boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
        
        NSMutableAttributedString *mutable_string = [[NSMutableAttributedString alloc] initWithString:new_string];
        NSAttributedString *attributed_comment    = [[NSAttributedString alloc] initWithString:commentChildModel.username2 attributes:@{NSForegroundColorAttributeName:[UIColor meiHongSe],NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
        [mutable_string replaceCharactersInRange:NSMakeRange(0, commentChildModel.username2.length) withAttributedString:attributed_comment];
        
        UILabel *background_label = [[UILabel alloc] init];
        [self.background_view addSubview:background_label];
        [background_label mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(intro_label.mas_left);
            make.top.equalTo(intro_label.mas_bottom).offset(10);
            make.right.equalTo(self.contentView.mas_right).offset(-10);
            make.height.offset(newRect.size.height);
        }];
        
        background_label.backgroundColor = [UIColor backgroundColor];
        background_label.font            = [UIFont systemFontOfSize:13.0f];
        background_label.attributedText  = mutable_string;
        background_label.numberOfLines   = 0;
        background_label.tag             = 5;
//    }
    
    //删除
    CGFloat imgW;
    CGFloat imgH;
    if (kScreenWidth == 320) {
        imgW = 15;
        imgH = 15;
    } else {
        imgW = 20;
        imgH = 20;
    }
    
    NSString *edit_string = @"编辑";
    CGRect editRect = [edit_string boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
    
    UIView *delete_view = [[UIView alloc] init];
    [self.background_view addSubview:delete_view];
    [delete_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(background_label.mas_bottom).offset(5);
        make.width.offset(imgW+editRect.size.width+5);
        make.height.offset(imgH);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
    }];
    delete_view.tag = 7;
    
    UIImageView *delete_image = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, imgW, imgH)];
    [delete_view addSubview:delete_image];
    delete_image.contentMode  = UIImageResizingModeStretch;
    delete_image.image        = [UIImage imageNamed:@"topic_delete"];
    delete_image.tag          = 8;
    
    UILabel *delete_label = [[UILabel alloc] init];
    [delete_view addSubview:delete_label];
    [delete_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(delete_image.mas_centerY);
        make.width.offset(editRect.size.width);
        make.height.offset(editRect.size.height);
        make.left.equalTo(delete_image.mas_right).offset(5);
    }];
    delete_label.numberOfLines = 0;
    delete_label.text          = @"删除";
    delete_label.font          = [UIFont systemFontOfSize:12.0f];
    delete_label.tag           = 9;

    UITapGestureRecognizer *view_tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewClickMethod:)];
    [delete_view addGestureRecognizer:view_tap];
    
    //新的高度
    self.cell_height = img_w+45+introRect.size.height+newRect.size.height+imgH;

}

-(void)viewClickMethod:(UITapGestureRecognizer *)tap {

    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(myCommentCellDelegateWithTapMethodAndWenzhangId:)]) {
        [self.delegate myCommentCellDelegateWithTapMethodAndWenzhangId:self.hfId];
    }
}

@end
