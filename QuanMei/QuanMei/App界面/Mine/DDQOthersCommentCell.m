//
//  DDQOthersCommentCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/11/9.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQOthersCommentCell.h"

@implementation DDQOthersCommentCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    }
    return self;
}

-(void)setCommentModel:(DDQOthersCommentModel *)commentModel {

    UIView *top_view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreenWidth, kScreenHeight * 0.2 * 0.3)];
    [self.contentView addSubview:top_view];
    
    //用户头像
    UIImageView *user_image = [[UIImageView alloc] init];
    [top_view addSubview:user_image];
    [user_image mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(top_view.mas_centerY);
        make.left.equalTo(top_view.mas_left).offset(10);
        make.height.equalTo(top_view.mas_height).multipliedBy(0.8);
        make.width.equalTo(user_image.mas_height);
    }];
    user_image.layer.cornerRadius  = kScreenHeight * 0.2 * 0.3 * 0.8 * 0.5;
    user_image.layer.masksToBounds = YES;
    user_image.backgroundColor     = [UIColor greenColor];
    
    //用户昵称
    CGRect nickNameRect = [commentModel.nickName boundingRectWithSize:CGSizeMake(kScreenWidth*0.8, top_view.frame.size.height * 0.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil];
    
    UILabel *nickLabel = [[UILabel alloc] init];
    [top_view addSubview:nickLabel];
    [nickLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(user_image.mas_right).offset(10);
        make.centerY.equalTo(top_view.mas_centerY);
        make.width.offset(nickNameRect.size.width);
        make.height.offset(nickNameRect.size.height);
    }];
    NSAttributedString *attributed_nick = [[NSAttributedString alloc] initWithString:commentModel.nickName attributes:@{NSForegroundColorAttributeName:[UIColor meiHongSe],NSFontAttributeName:[UIFont systemFontOfSize:11.0f]}];
    nickLabel.attributedText= attributed_nick;
    nickLabel.font          = [UIFont systemFontOfSize:11.0f];
    nickLabel.textAlignment = NSTextAlignmentLeft;
    
    //发布时间
    CGRect pubTimeRect = [commentModel.pubtime boundingRectWithSize:CGSizeMake(kScreenWidth*0.8, top_view.frame.size.height * 0.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f]} context:nil];
    
    UILabel *pubLabel = [[UILabel alloc] init];
    [top_view addSubview:pubLabel];
    [pubLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickLabel.mas_right).offset(15);
        make.centerY.equalTo(top_view.mas_centerY);
        make.width.offset(pubTimeRect.size.width);
        make.height.offset(pubTimeRect.size.height);
    }];
    NSAttributedString *attributed_pub = [[NSAttributedString alloc] initWithString:commentModel.pubtime attributes:@{NSForegroundColorAttributeName:[UIColor grayColor],NSFontAttributeName:[UIFont systemFontOfSize:11.0f]}];
    pubLabel.attributedText= attributed_pub;
    pubLabel.font          = [UIFont systemFontOfSize:11.0f];
    pubLabel.textAlignment = NSTextAlignmentLeft;
    
    //评论内容
    CGRect commentRect = [commentModel.intro boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
    
    UILabel *commentLabel = [[UILabel alloc] init];
    [self.contentView addSubview:commentLabel];
    [commentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(nickLabel.mas_left);
        make.top.equalTo(top_view.mas_bottom).offset(5);
        make.right.equalTo(top_view.mas_right);
        make.height.offset(commentRect.size.height);
    }];
    commentLabel.text          = commentModel.intro;
    commentLabel.font          = [UIFont systemFontOfSize:14.0f];
    commentLabel.textAlignment = NSTextAlignmentLeft;
    commentLabel.numberOfLines = 0;
    
    //打酱油的灰色背景图
//    CGRect replyRect = [commentModel.commentString boundingRectWithSize:CGSizeMake(kScreenWidth, 100) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.0f]} context:nil];
    
    UILabel *background_label = [[UILabel alloc] init];
    [self.contentView addSubview:background_label];
    [background_label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(commentLabel.mas_bottom).offset(10);
        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
        make.left.equalTo(commentLabel.mas_left);
        make.right.equalTo(self.contentView.mas_right).offset(-5);
    }];
    NSMutableAttributedString *mutable_string = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:%@",commentModel.commentUser,commentModel.commentString]];
    NSAttributedString *attributed_comment    = [[NSAttributedString alloc] initWithString:commentModel.commentUser attributes:@{NSForegroundColorAttributeName:[UIColor greenColor],NSFontAttributeName:[UIFont systemFontOfSize:13.0f]}];
    [mutable_string replaceCharactersInRange:NSMakeRange(0, commentModel.commentUser.length) withAttributedString:attributed_comment];
    background_label.backgroundColor = [UIColor backgroundColor];
    background_label.font            = [UIFont systemFontOfSize:13.0f];
    background_label.attributedText  = mutable_string;
    background_label.numberOfLines   = 0;
}
@end
