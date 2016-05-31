//
//  DDQDiaryViewCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/7.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQDiaryViewCell.h"

@implementation DDQDiaryViewCell

@synthesize backgroundView;
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundView = [[UIView alloc] init];
        [self.contentView addSubview:self.backgroundView];
        [self.backgroundView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.mas_top);
            make.left.equalTo(self.mas_left);
            make.right.equalTo(self.mas_right);
            make.bottom.equalTo(self.mas_bottom).offset(-5);
        }];
        [self.backgroundView setBackgroundColor:[UIColor whiteColor]];
        [self.contentView setBackgroundColor:[UIColor backgroundColor]];
    }
    return self;
}

-(void)setArticleModel:(DDQGroupArticleModel *)articleModel {
    //这里判断是日记还是帖子：1、日记,2、帖子
    if ([articleModel.articleType intValue] == 2) {//帖子
#warning 全部帖子
        //是不是精选：1、全部,2、精
        if ([articleModel.isJing intValue] == 1) {//全部
            
            CGRect titleRect = [articleModel.articleTitle boundingRectWithSize:CGSizeMake(kScreenWidth, kScreenHeight*0.5*0.15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]} context:nil];
            
            //标题
            self.titleLabel = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.backgroundView.mas_left).with.offset(10);
                make.right.equalTo(self.backgroundView.mas_right).offset(-10);
                make.top.equalTo(self.backgroundView.mas_top).offset(5);
                make.height.offset(titleRect.size.height);
            }];
            self.titleLabel.text = articleModel.articleTitle;
            self.titleLabel.font = [UIFont systemFontOfSize:17.0f weight:5.0f];
            
            //提示图(如果评论有图就显示)
            if (articleModel.imgArray.count != 0) {//图片数组是否有值
                
                self.placeholderImage = [[UIImageView alloc] init];
                [self.backgroundView addSubview:self.placeholderImage];
                [self.placeholderImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.titleLabel.mas_right);
                    make.width.offset(15);
                    make.centerY.equalTo(self.titleLabel.mas_centerY);
                    make.height.equalTo(self.titleLabel.mas_height).multipliedBy(0.5);
                }];
                self.placeholderImage.image = [UIImage imageNamed:@"main_post_image"];
            }
            
            //文章来源
            NSString *source_string = @"来自小组";
            
            CGRect sourceRect       = [source_string boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, kScreenHeight*0.5*0.1) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
            self.articleSource = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.articleSource];
            [self.articleSource mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleLabel.mas_left);
                make.top.equalTo(self.titleLabel.mas_bottom);
                make.width.offset(sourceRect.size.width);
                make.height.offset(sourceRect.size.height);
            }];
            self.articleSource.textAlignment = NSTextAlignmentLeft;
            self.articleSource.font          = [UIFont systemFontOfSize:12.0f];
            self.articleSource.text          = source_string;


            //来源名称
            NSString *group_name                  = [NSString stringWithFormat:@"[%@]",articleModel.groupName];
            
            CGRect groupName = [group_name boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, kScreenHeight*0.5*0.1) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
            self.sourceName = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.sourceName];
            [self.sourceName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.articleSource.mas_right);
                make.height.offset(groupName.size.height);
                make.centerY.equalTo(self.articleSource.mas_centerY);
                make.width.offset(groupName.size.width);
            }];
            
            NSAttributedString *attributed_string = [[NSAttributedString alloc] initWithString:group_name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:[UIColor meiHongSe]}];
            self.sourceName.attributedText        = attributed_string;
            
            //计算文本内容
            if (articleModel.introString != nil && ![articleModel.introString isEqualToString:@""]) {
                
                self.newRect = [articleModel.introString boundingRectWithSize:CGSizeMake(kScreenWidth, kScreenHeight*0.5*0.5)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
                self.commentInto               = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenHeight*0.5*0.2, self.newRect.size.width, self.newRect.size.height)];
                [self.backgroundView addSubview:self.commentInto];
                self.commentInto.text          = articleModel.introString;
                self.commentInto.numberOfLines = 0;
                self.commentInto.font          = [UIFont systemFontOfSize:14.0f];
                
            }
            
            if (articleModel.imgArray.count > 0) {
                
                CGFloat img_width = kScreenWidth/2;
                CGFloat img_height = kScreenHeight * 0.5 * 0.5;
                CGFloat img_y = kScreenHeight * 0.5 * 0.2;
                for (int i = 0; i< articleModel.imgArray.count; i++) {
                    _user_img = [[UIImageView alloc] init];
                    _user_img.frame = CGRectMake(img_width*i, img_y, img_width, img_height);
                    if (articleModel.imgArray.count != 0 ) {
                        //i不能比图片数组的个数多
                        [_user_img sd_setImageWithURL:[NSURL URLWithString:[articleModel.imgArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
                    } else {
                        [_user_img setImage:[UIImage imageNamed:@"default_pic"]];
                    }
                    [self.backgroundView addSubview:_user_img];
                }
                
            }
            
            
            //华丽丽的分割线
            UIView *line_view = [[UIView alloc] init];
            [self.backgroundView addSubview:line_view];
            [line_view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (articleModel.introString != nil && ![articleModel.introString isEqualToString:@""]) {
                    
                    make.top.equalTo(self.commentInto.mas_bottom).with.offset(kScreenHeight*0.5*0.05);
                    
                } else if (articleModel.imgArray.count > 0) {
                    
                    make.top.equalTo(_user_img.mas_bottom).with.offset(kScreenHeight*0.5*0.05);
                    
                } else {
                    
                    make.top.equalTo(self.sourceName.mas_bottom).with.offset(kScreenHeight*0.5*0.1);
                    
                }
                
                make.left.equalTo(self.backgroundView.mas_left);
                make.width.equalTo(self.backgroundView.mas_width);
                make.height.offset(2);
            }];
            line_view.backgroundColor = [UIColor backgroundColor];

            UIView *tempView = [[UIView alloc] init];
            [self.backgroundView addSubview:tempView];
            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.backgroundView.mas_left);
                make.right.equalTo(self.backgroundView.mas_right);
                make.top.equalTo(line_view.mas_bottom);
                make.bottom.equalTo(self.backgroundView.mas_bottom);
            }];
            
            //用户头像
            self.user_headerImg = [[UIImageView alloc] init];
            [self.backgroundView addSubview:self.user_headerImg];
            [self.user_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(tempView.mas_centerY);
                make.left.equalTo(self.titleLabel.mas_left);
                if (kScreenHeight == 480) {
                    make.width.offset(20);
                    make.height.offset(20);
                } else if (kScreenHeight == 568) {
                    make.width.offset(20);
                    make.height.offset(20);
                } else if (kScreenHeight == 667) {
                    make.width.offset(30);
                    make.height.offset(30);
                } else {
                    make.width.offset(40);
                    make.height.offset(40);

                }

            }];
            [self.user_headerImg sd_setImageWithURL:[NSURL URLWithString:articleModel.userHeaderImg] placeholderImage:[UIImage imageNamed:@"default_pic"]];
            if (kScreenHeight == 480) {
                self.user_headerImg.layer.cornerRadius = 10.0f;

            } else if (kScreenHeight == 568) {
                self.user_headerImg.layer.cornerRadius = 10.0f;

            } else if (kScreenHeight == 667) {
                self.user_headerImg.layer.cornerRadius = 15.0f;

            } else {
                self.user_headerImg.layer.cornerRadius = 20.0f;

            }
            self.user_headerImg.layer.masksToBounds = YES;
            self.user_headerImg.backgroundColor = [UIColor redColor];


            //用户名
            CGRect newNickNameRect = [articleModel.userName boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, 30)
                                                                  options:NSStringDrawingUsesLineFragmentOrigin
                                                               attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
            self.user_name = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.user_name];
            [self.user_name mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.user_headerImg.mas_centerY);
                make.left.equalTo(self.user_headerImg.mas_right).with.offset(5);
                make.width.offset(newNickNameRect.size.width);
                make.height.equalTo(self.user_headerImg.mas_height);
            }];
            self.user_name.font          = [UIFont systemFontOfSize:12.0f];
            self.user_name.text          = articleModel.userName;
            self.user_name.textAlignment = NSTextAlignmentLeft;


            //用户评论时间
            self.plTime = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.plTime];
            [self.plTime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.user_name.mas_right).offset(5);
                make.centerY.equalTo(self.user_name.mas_centerY);
                make.width.equalTo(self.backgroundView.mas_width).with.multipliedBy(0.3);
                make.height.equalTo(self.user_name.mas_height);
            }];
            self.plTime.font          = [UIFont systemFontOfSize:12.0f];
            self.plTime.textAlignment = NSTextAlignmentLeft;
            self.plTime.text          = articleModel.plTime;


            //点赞图片
            self.thumbImageView = [[UIImageView alloc] init];
            [self.backgroundView addSubview:self.thumbImageView];
            [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_centerX).with.offset(kScreenWidth * 0.25);
                make.centerY.equalTo(tempView.mas_centerY);
                make.width.offset(15);
                make.height.offset(15);
            }];
            self.thumbImageView.image = [UIImage imageNamed:@"like"];

            //点赞人数
            self.thumbUpNum = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.thumbUpNum];
            [self.thumbUpNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.thumbImageView.mas_right);
                make.centerY.equalTo(self.thumbImageView.mas_centerY);
                make.width.equalTo(self.user_headerImg.mas_width).with.multipliedBy(0.5);
                make.height.equalTo(self.user_headerImg.mas_height).with.multipliedBy(0.5);
            }];
            self.thumbUpNum.text = articleModel.thumbNum;
            self.thumbUpNum.font = [UIFont systemFontOfSize:13.0f];


            //评论图片
            self.replyImageView = [[UIImageView alloc] init];
            [self.backgroundView addSubview:self.replyImageView];
            [self.replyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.thumbUpNum.mas_right).with.offset(5);
                make.centerY.equalTo(self.thumbImageView.mas_centerY);
                make.width.offset(15);
                make.height.offset(15);
            }];
            self.replyImageView.image = [UIImage imageNamed:@"review"];
            
            //评论人数
            self.replyNum = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.replyNum];
            [self.replyNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.replyImageView.mas_right);
                make.centerY.equalTo(self.thumbImageView.mas_centerY);
                make.width.equalTo(self.user_headerImg.mas_width).with.multipliedBy(0.5);
                make.height.equalTo(self.user_headerImg.mas_height).with.multipliedBy(0.5);
            }];
            self.replyNum.text = articleModel.replyNum;
            self.replyNum.font = [UIFont systemFontOfSize:11.0f];
        
#warning 精帖子
        } else {//精：帖子

            CGRect titleRect = [articleModel.articleTitle boundingRectWithSize:CGSizeMake(kScreenWidth, kScreenHeight*0.5*0.15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]} context:nil];
            
            //精
            self.reOrJing = [[UIImageView alloc] init];
            [self.backgroundView addSubview:self.reOrJing];
            [self.reOrJing mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.backgroundView.mas_left).offset(10);
                make.top.equalTo(self.backgroundView.mas_top).offset(10);
                make.height.offset(15);
                make.width.offset(15);
            }];
            self.reOrJing.image = [UIImage imageNamed:@"main_post_choice"];
            
            //标题
            self.titleLabel = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.reOrJing.mas_right).offset(5);
                make.centerY.equalTo(self.reOrJing.mas_centerY);
                make.right.equalTo(self.backgroundView.mas_right).offset(-10);
                make.height.offset(titleRect.size.height);
            }];
            self.titleLabel.text = articleModel.articleTitle;
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.titleLabel.font = [UIFont systemFontOfSize:17.0f weight:5.0f];
            
            
            //提示图(如果评论有图就显示)
            if (articleModel.imgArray.count != 0) {//图片数组是否有值
                
                self.placeholderImage = [[UIImageView alloc] init];
                [self.backgroundView addSubview:self.placeholderImage];
                [self.placeholderImage mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.equalTo(self.titleLabel.mas_right);
                    make.width.offset(15);
                    make.centerY.equalTo(self.titleLabel.mas_centerY);
                    make.height.equalTo(self.titleLabel.mas_height).multipliedBy(0.5);
                }];
                self.placeholderImage.image = [UIImage imageNamed:@"main_post_image"];
            }
            
            //文章来源
            NSString *source_string = @"来自小组";
            
            CGRect sourceRect       = [source_string boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, kScreenHeight*0.5*0.1) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
            self.articleSource = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.articleSource];
            [self.articleSource mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleLabel.mas_left);
                make.top.equalTo(self.titleLabel.mas_bottom);
                make.width.offset(sourceRect.size.width);
                make.height.offset(sourceRect.size.height);
            }];
            self.articleSource.textAlignment = NSTextAlignmentLeft;
            self.articleSource.font          = [UIFont systemFontOfSize:12.0f];
            self.articleSource.text          = source_string;
            
            
            //来源名称
            NSString *group_name                  = [NSString stringWithFormat:@"[%@]",articleModel.groupName];
            
            CGRect groupName = [group_name boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, kScreenHeight*0.5*0.1) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
            self.sourceName = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.sourceName];
            [self.sourceName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.articleSource.mas_right);
                make.height.offset(groupName.size.height);
                make.centerY.equalTo(self.articleSource.mas_centerY);
                make.width.offset(groupName.size.width);
            }];
            
            NSAttributedString *attributed_string = [[NSAttributedString alloc] initWithString:group_name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:[UIColor meiHongSe]}];
            self.sourceName.attributedText        = attributed_string;
            
            //计算文本内容
            if (articleModel.introString != nil && ![articleModel.introString isEqualToString:@""]) {
                
                self.newRect = [articleModel.introString boundingRectWithSize:CGSizeMake(kScreenWidth, kScreenHeight*0.5*0.5)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
                self.commentInto               = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenHeight*0.5*0.2, self.newRect.size.width, self.newRect.size.height)];
                [self.backgroundView addSubview:self.commentInto];
                self.commentInto.text          = articleModel.introString;
                self.commentInto.numberOfLines = 0;
                self.commentInto.font          = [UIFont systemFontOfSize:14.0f];
                
            }
            
            if (articleModel.imgArray.count > 0) {
                
                CGFloat img_width = kScreenWidth/2;
                CGFloat img_height = kScreenHeight * 0.5 * 0.5;
                CGFloat img_y = kScreenHeight * 0.5 * 0.2;
                for (int i = 0; i< articleModel.imgArray.count; i++) {
                    _user_img = [[UIImageView alloc] init];
                    _user_img.frame = CGRectMake(img_width*i, img_y, img_width, img_height);
                    if (articleModel.imgArray.count != 0 ) {
                        //i不能比图片数组的个数多
                        [_user_img sd_setImageWithURL:[NSURL URLWithString:[articleModel.imgArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
                    } else {
                        [_user_img setImage:[UIImage imageNamed:@"default_pic"]];
                    }
                    [self.backgroundView addSubview:_user_img];
                }
                
            }
            
            
            //华丽丽的分割线
            UIView *line_view = [[UIView alloc] init];
            [self.backgroundView addSubview:line_view];
            [line_view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (articleModel.introString != nil && ![articleModel.introString isEqualToString:@""]) {
                    
                    make.top.equalTo(self.commentInto.mas_bottom).with.offset(kScreenHeight*0.5*0.05);
                    
                } else if (articleModel.imgArray.count > 0) {
                    
                    make.top.equalTo(_user_img.mas_bottom).with.offset(kScreenHeight*0.5*0.05);
                    
                } else {
                    
                    make.top.equalTo(self.sourceName.mas_bottom).with.offset(kScreenHeight*0.5*0.1);
                    
                }
                
                make.left.equalTo(self.backgroundView.mas_left);
                make.width.equalTo(self.backgroundView.mas_width);
                make.height.offset(2);
            }];
            line_view.backgroundColor = [UIColor backgroundColor];
            
            UIView *tempView = [[UIView alloc] init];
            [self.backgroundView addSubview:tempView];
            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.backgroundView.mas_left);
                make.right.equalTo(self.backgroundView.mas_right);
                make.top.equalTo(line_view.mas_bottom);
                make.bottom.equalTo(self.backgroundView.mas_bottom);
            }];
            
            //用户头像
            self.user_headerImg = [[UIImageView alloc] init];
            [self.backgroundView addSubview:self.user_headerImg];
            [self.user_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(tempView.mas_centerY);
                make.left.equalTo(self.titleLabel.mas_left);
                if (kScreenHeight == 480) {
                    make.width.offset(20);
                    make.height.offset(20);
                } else if (kScreenHeight == 568) {
                    make.width.offset(20);
                    make.height.offset(20);
                } else if (kScreenHeight == 667) {
                    make.width.offset(30);
                    make.height.offset(30);
                } else {
                    make.width.offset(40);
                    make.height.offset(40);
                    
                }
                
            }];
            [self.user_headerImg sd_setImageWithURL:[NSURL URLWithString:articleModel.userHeaderImg] placeholderImage:[UIImage imageNamed:@"default_pic"]];
            if (kScreenHeight == 480) {
                self.user_headerImg.layer.cornerRadius = 10.0f;
                
            } else if (kScreenHeight == 568) {
                self.user_headerImg.layer.cornerRadius = 10.0f;
                
            } else if (kScreenHeight == 667) {
                self.user_headerImg.layer.cornerRadius = 15.0f;
                
            } else {
                self.user_headerImg.layer.cornerRadius = 20.0f;
                
            }
            self.user_headerImg.layer.masksToBounds = YES;
            self.user_headerImg.backgroundColor = [UIColor redColor];
            
            
            //用户名
            CGRect newNickNameRect = [articleModel.userName boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, 30)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
            self.user_name = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.user_name];
            [self.user_name mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.user_headerImg.mas_centerY);
                make.left.equalTo(self.user_headerImg.mas_right).with.offset(5);
                make.width.offset(newNickNameRect.size.width);
                make.height.equalTo(self.user_headerImg.mas_height);
            }];
            self.user_name.font          = [UIFont systemFontOfSize:12.0f];
            self.user_name.text          = articleModel.userName;
            self.user_name.textAlignment = NSTextAlignmentLeft;
            
            
            //用户评论时间
            self.plTime = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.plTime];
            [self.plTime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.user_name.mas_right).offset(5);
                make.centerY.equalTo(self.user_name.mas_centerY);
                make.width.equalTo(self.backgroundView.mas_width).with.multipliedBy(0.3);
                make.height.equalTo(self.user_name.mas_height);
            }];
            self.plTime.font          = [UIFont systemFontOfSize:12.0f];
            self.plTime.textAlignment = NSTextAlignmentLeft;
            self.plTime.text          = articleModel.plTime;
            
            
            //点赞图片
            self.thumbImageView = [[UIImageView alloc] init];
            [self.backgroundView addSubview:self.thumbImageView];
            [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_centerX).with.offset(kScreenWidth * 0.25);
                make.centerY.equalTo(tempView.mas_centerY);
                make.width.offset(15);
                make.height.offset(15);
            }];
            self.thumbImageView.image = [UIImage imageNamed:@"like"];
            
            //点赞人数
            self.thumbUpNum = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.thumbUpNum];
            [self.thumbUpNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.thumbImageView.mas_right);
                make.centerY.equalTo(self.thumbImageView.mas_centerY);
                make.width.equalTo(self.user_headerImg.mas_width).with.multipliedBy(0.5);
                make.height.equalTo(self.user_headerImg.mas_height).with.multipliedBy(0.5);
            }];
            self.thumbUpNum.text = articleModel.thumbNum;
            self.thumbUpNum.font = [UIFont systemFontOfSize:13.0f];
            
            
            //评论图片
            self.replyImageView = [[UIImageView alloc] init];
            [self.backgroundView addSubview:self.replyImageView];
            [self.replyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.thumbUpNum.mas_right).with.offset(5);
                make.centerY.equalTo(self.thumbImageView.mas_centerY);
                make.width.offset(15);
                make.height.offset(15);
            }];
            self.replyImageView.image = [UIImage imageNamed:@"review"];
            
            //评论人数
            self.replyNum = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.replyNum];
            [self.replyNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.replyImageView.mas_right);
                make.centerY.equalTo(self.thumbImageView.mas_centerY);
                make.width.equalTo(self.user_headerImg.mas_width).with.multipliedBy(0.5);
                make.height.equalTo(self.user_headerImg.mas_height).with.multipliedBy(0.5);
            }];
            self.replyNum.text = articleModel.replyNum;
            self.replyNum.font = [UIFont systemFontOfSize:11.0f];
            
        }
        
    } else {//日记
#warning 全部类型日记
        if ([articleModel.isJing intValue] == 1) {//全部
            
            CGRect titleRect = [articleModel.articleTitle boundingRectWithSize:CGSizeMake(kScreenWidth, kScreenHeight*0.5*0.15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]} context:nil];
            
            //标题
            self.titleLabel = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.backgroundView.mas_left).with.offset(10);
                make.right.equalTo(self.backgroundView.mas_right).offset(-10);
                make.top.equalTo(self.backgroundView.mas_top).offset(5);
                make.height.offset(titleRect.size.height);
            }];
            self.titleLabel.text = articleModel.articleTitle;
            self.titleLabel.font = [UIFont systemFontOfSize:17.0f weight:5.0f];
            
            //文章来源
            NSString *source_string = @"来自小组";
            
            CGRect sourceRect       = [source_string boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, kScreenHeight*0.5*0.1) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
            self.articleSource = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.articleSource];
            [self.articleSource mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleLabel.mas_left);
                make.top.equalTo(self.titleLabel.mas_bottom);
                make.width.offset(sourceRect.size.width);
                make.height.offset(sourceRect.size.height);
            }];
            self.articleSource.textAlignment = NSTextAlignmentLeft;
            self.articleSource.font          = [UIFont systemFontOfSize:12.0f];
            self.articleSource.text          = source_string;
            
            
            //来源名称
            NSString *group_name                  = [NSString stringWithFormat:@"[%@]",articleModel.groupName];
            
            CGRect groupName = [group_name boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, kScreenHeight*0.5*0.1) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
            self.sourceName = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.sourceName];
            [self.sourceName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.articleSource.mas_right);
                make.height.offset(groupName.size.height);
                make.centerY.equalTo(self.articleSource.mas_centerY);
                make.width.offset(groupName.size.width);
            }];
            
            NSAttributedString *attributed_string = [[NSAttributedString alloc] initWithString:group_name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:[UIColor meiHongSe]}];
            self.sourceName.attributedText        = attributed_string;
            
            //计算文本内容
            if (articleModel.introString != nil && ![articleModel.introString isEqualToString:@""]) {
                
                self.newRect = [articleModel.introString boundingRectWithSize:CGSizeMake(kScreenWidth, kScreenHeight*0.5*0.5)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
                self.commentInto               = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenHeight*0.5*0.2, self.newRect.size.width, self.newRect.size.height)];
                [self.backgroundView addSubview:self.commentInto];
                self.commentInto.text          = articleModel.introString;
                self.commentInto.numberOfLines = 0;
                self.commentInto.font          = [UIFont systemFontOfSize:14.0f];
                
            }
            
            if (articleModel.imgArray.count > 0) {
                
                CGFloat img_width = kScreenWidth/2;
                CGFloat img_height = kScreenHeight * 0.5 * 0.5;
                CGFloat img_y = kScreenHeight * 0.5 * 0.2;
                for (int i = 0; i< articleModel.imgArray.count; i++) {
                    _user_img = [[UIImageView alloc] init];
                    _user_img.frame = CGRectMake(img_width*i, img_y, img_width, img_height);
                    if (articleModel.imgArray.count != 0 ) {
                        //i不能比图片数组的个数多
                        [_user_img sd_setImageWithURL:[NSURL URLWithString:[articleModel.imgArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
                    } else {
                        [_user_img setImage:[UIImage imageNamed:@"default_pic"]];
                    }
                    [self.backgroundView addSubview:_user_img];
                }
                
            }
            
            
            //华丽丽的分割线
            UIView *line_view = [[UIView alloc] init];
            [self.backgroundView addSubview:line_view];
            [line_view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (articleModel.introString != nil && ![articleModel.introString isEqualToString:@""]) {
                    
                    make.top.equalTo(self.commentInto.mas_bottom).with.offset(kScreenHeight*0.5*0.05);
                    
                } else if (articleModel.imgArray.count > 0) {
                    
                    make.top.equalTo(_user_img.mas_bottom).with.offset(kScreenHeight*0.5*0.05);
                    
                } else {
                    
                    make.top.equalTo(self.sourceName.mas_bottom).with.offset(kScreenHeight*0.5*0.1);
                    
                }
                
                make.left.equalTo(self.backgroundView.mas_left);
                make.width.equalTo(self.backgroundView.mas_width);
                make.height.offset(2);
            }];
            line_view.backgroundColor = [UIColor backgroundColor];

            UIView *tempView = [[UIView alloc] init];
            [self.backgroundView addSubview:tempView];
            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.backgroundView.mas_left);
                make.right.equalTo(self.backgroundView.mas_right);
                make.top.equalTo(line_view.mas_bottom);
                make.bottom.equalTo(self.backgroundView.mas_bottom);
            }];
            
            //用户头像
            self.user_headerImg = [[UIImageView alloc] init];
            [self.backgroundView addSubview:self.user_headerImg];
            [self.user_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(tempView.mas_centerY);
                make.left.equalTo(self.titleLabel.mas_left);
                if (kScreenHeight == 480) {
                    make.width.offset(20);
                    make.height.offset(20);
                } else if (kScreenHeight == 568) {
                    make.width.offset(20);
                    make.height.offset(20);
                } else if (kScreenHeight == 667) {
                    make.width.offset(30);
                    make.height.offset(30);
                } else {
                    make.width.offset(40);
                    make.height.offset(40);
                    
                }
                
            }];
            [self.user_headerImg sd_setImageWithURL:[NSURL URLWithString:articleModel.userHeaderImg] placeholderImage:[UIImage imageNamed:@"default_pic"]];
            if (kScreenHeight == 480) {
                self.user_headerImg.layer.cornerRadius = 10.0f;
                
            } else if (kScreenHeight == 568) {
                self.user_headerImg.layer.cornerRadius = 10.0f;
                
            } else if (kScreenHeight == 667) {
                self.user_headerImg.layer.cornerRadius = 15.0f;
                
            } else {
                self.user_headerImg.layer.cornerRadius = 20.0f;
                
            }
            self.user_headerImg.layer.masksToBounds = YES;
            self.user_headerImg.backgroundColor = [UIColor redColor];
            
            
            //用户名
            CGRect newNickNameRect = [articleModel.userName boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, 30)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
            self.user_name = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.user_name];
            [self.user_name mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.user_headerImg.mas_centerY);
                make.left.equalTo(self.user_headerImg.mas_right).with.offset(5);
                make.width.offset(newNickNameRect.size.width);
                make.height.equalTo(self.user_headerImg.mas_height);
            }];
            self.user_name.font          = [UIFont systemFontOfSize:12.0f];
            self.user_name.text          = articleModel.userName;
            self.user_name.textAlignment = NSTextAlignmentLeft;
            
            
            //用户评论时间
            self.plTime = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.plTime];
            [self.plTime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.user_name.mas_right).offset(5);
                make.centerY.equalTo(self.user_name.mas_centerY);
                make.width.equalTo(self.backgroundView.mas_width).with.multipliedBy(0.3);
                make.height.equalTo(self.user_name.mas_height);
            }];
            self.plTime.font          = [UIFont systemFontOfSize:12.0f];
            self.plTime.textAlignment = NSTextAlignmentLeft;
            self.plTime.text          = articleModel.plTime;
            
            
            //点赞图片
            self.thumbImageView = [[UIImageView alloc] init];
            [self.backgroundView addSubview:self.thumbImageView];
            [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_centerX).with.offset(kScreenWidth * 0.25);
                make.centerY.equalTo(tempView.mas_centerY);
                make.width.offset(15);
                make.height.offset(15);
            }];
            self.thumbImageView.image = [UIImage imageNamed:@"like"];
            
            //点赞人数
            self.thumbUpNum = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.thumbUpNum];
            [self.thumbUpNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.thumbImageView.mas_right);
                make.centerY.equalTo(self.thumbImageView.mas_centerY);
                make.width.equalTo(self.user_headerImg.mas_width).with.multipliedBy(0.5);
                make.height.equalTo(self.user_headerImg.mas_height).with.multipliedBy(0.5);
            }];
            self.thumbUpNum.text = articleModel.thumbNum;
            self.thumbUpNum.font = [UIFont systemFontOfSize:13.0f];
            
            
            //评论图片
            self.replyImageView = [[UIImageView alloc] init];
            [self.backgroundView addSubview:self.replyImageView];
            [self.replyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.thumbUpNum.mas_right).with.offset(5);
                make.centerY.equalTo(self.thumbImageView.mas_centerY);
                make.width.offset(15);
                make.height.offset(15);
            }];
            self.replyImageView.image = [UIImage imageNamed:@"review"];
            
            //评论人数
            self.replyNum = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.replyNum];
            [self.replyNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.replyImageView.mas_right);
                make.centerY.equalTo(self.thumbImageView.mas_centerY);
                make.width.equalTo(self.user_headerImg.mas_width).with.multipliedBy(0.5);
                make.height.equalTo(self.user_headerImg.mas_height).with.multipliedBy(0.5);
            }];
            self.replyNum.text = articleModel.replyNum;
            self.replyNum.font = [UIFont systemFontOfSize:11.0f];
            
#warning 日记精
        } else {//精：日记
            
            CGRect titleRect = [articleModel.articleTitle boundingRectWithSize:CGSizeMake(kScreenWidth, kScreenHeight*0.5*0.15) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:18.0f]} context:nil];
      
            //精
            self.reOrJing = [[UIImageView alloc] init];
            [self.backgroundView addSubview:self.reOrJing];
            [self.reOrJing mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.backgroundView.mas_left).offset(10);
                make.top.equalTo(self.backgroundView.mas_top).offset(10);
                make.height.offset(15);
                make.width.offset(15);
            }];
            self.reOrJing.image = [UIImage imageNamed:@"main_post_choice"];
            
            //标题
            self.titleLabel = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.titleLabel];
            [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.reOrJing.mas_right).offset(5);
                make.centerY.equalTo(self.reOrJing.mas_centerY);
                make.right.equalTo(self.backgroundView.mas_right).offset(-10);
                make.height.offset(titleRect.size.height);
            }];
            self.titleLabel.text = articleModel.articleTitle;
            self.titleLabel.textAlignment = NSTextAlignmentLeft;
            self.titleLabel.font = [UIFont systemFontOfSize:17.0f weight:5.0f];
            //文章来源
            NSString *source_string = @"来自小组";
            
            CGRect sourceRect       = [source_string boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, kScreenHeight*0.5*0.1) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
            
            self.articleSource = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.articleSource];
            [self.articleSource mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.titleLabel.mas_left);
                make.top.equalTo(self.titleLabel.mas_bottom);
                make.width.offset(sourceRect.size.width);
                make.height.offset(sourceRect.size.height);
            }];
            self.articleSource.textAlignment = NSTextAlignmentLeft;
            self.articleSource.font          = [UIFont systemFontOfSize:12.0f];
            self.articleSource.text          = source_string;
            
            //来源名称
            NSString *group_name                  = [NSString stringWithFormat:@"[%@]",articleModel.groupName];
            
            CGRect groupName = [group_name boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, kScreenHeight*0.5*0.1) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];

            self.sourceName = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.sourceName];
            [self.sourceName mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.articleSource.mas_right);
                make.height.offset(groupName.size.height);
                make.centerY.equalTo(self.articleSource.mas_centerY);
                make.width.offset(groupName.size.width);
            }];
            
            NSAttributedString *attributed_string = [[NSAttributedString alloc] initWithString:group_name attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:12.0f],NSForegroundColorAttributeName:[UIColor meiHongSe]}];
            self.sourceName.attributedText        = attributed_string;
            
            //计算文本内容
            if (articleModel.introString != nil && ![articleModel.introString isEqualToString:@""]) {
                
                self.newRect = [articleModel.introString boundingRectWithSize:CGSizeMake(kScreenWidth, kScreenHeight*0.5*0.5)
                                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
                self.commentInto               = [[UILabel alloc] initWithFrame:CGRectMake(10, kScreenHeight*0.5*0.2, self.newRect.size.width, self.newRect.size.height)];
                [self.backgroundView addSubview:self.commentInto];
                self.commentInto.text          = articleModel.introString;
                self.commentInto.numberOfLines = 0;
                self.commentInto.font          = [UIFont systemFontOfSize:14.0f];

            }
            
            if (articleModel.imgArray.count > 0) {
                
                CGFloat img_width = kScreenWidth/2;
                CGFloat img_height = kScreenHeight * 0.5 * 0.5;
                CGFloat img_y = kScreenHeight * 0.5 * 0.2;
                for (int i = 0; i< articleModel.imgArray.count; i++) {
                    _user_img = [[UIImageView alloc] init];
                    _user_img.frame = CGRectMake(img_width*i, img_y, img_width, img_height);
                    if (articleModel.imgArray.count != 0 ) {
                        //i不能比图片数组的个数多
                        [_user_img sd_setImageWithURL:[NSURL URLWithString:[articleModel.imgArray objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"default_pic"]];
                    } else {
                        [_user_img setImage:[UIImage imageNamed:@"default_pic"]];
                    }
                    [self.backgroundView addSubview:_user_img];
                }
                
            }
            

            //华丽丽的分割线
            UIView *line_view = [[UIView alloc] init];
            [self.backgroundView addSubview:line_view];
            [line_view mas_makeConstraints:^(MASConstraintMaker *make) {
                
                if (articleModel.introString != nil && ![articleModel.introString isEqualToString:@""]) {
                    
                    make.top.equalTo(self.commentInto.mas_bottom).with.offset(kScreenHeight*0.5*0.05);
                    
                } else if (articleModel.imgArray.count > 0) {
                
                    make.top.equalTo(_user_img.mas_bottom).with.offset(kScreenHeight*0.5*0.05);

                } else {
                
                    make.top.equalTo(self.sourceName.mas_bottom).with.offset(kScreenHeight*0.5*0.1);

                }
                
                make.left.equalTo(self.backgroundView.mas_left);
                make.width.equalTo(self.backgroundView.mas_width);
                make.height.offset(2);
            }];
            line_view.backgroundColor = [UIColor backgroundColor];
            
            UIView *tempView = [[UIView alloc] init];
            [self.backgroundView addSubview:tempView];
            [tempView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.backgroundView.mas_left);
                make.right.equalTo(self.backgroundView.mas_right);
                make.top.equalTo(line_view.mas_bottom);
                make.bottom.equalTo(self.backgroundView.mas_bottom);
            }];
            
            //用户头像
            self.user_headerImg = [[UIImageView alloc] init];
            [self.backgroundView addSubview:self.user_headerImg];
            [self.user_headerImg mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(tempView.mas_centerY);
                make.left.equalTo(self.reOrJing.mas_left);
                if (kScreenHeight == 480) {
                    make.width.offset(20);
                    make.height.offset(20);
                } else if (kScreenHeight == 568) {
                    make.width.offset(20);
                    make.height.offset(20);
                } else if (kScreenHeight == 667) {
                    make.width.offset(30);
                    make.height.offset(30);
                } else {
                    make.width.offset(40);
                    make.height.offset(40);
                }
                
            }];
            [self.user_headerImg sd_setImageWithURL:[NSURL URLWithString:articleModel.userHeaderImg] placeholderImage:[UIImage imageNamed:@"default_pic"]];
            if (kScreenHeight == 480) {
                self.user_headerImg.layer.cornerRadius = 10.0f;
                
            } else if (kScreenHeight == 568) {
                self.user_headerImg.layer.cornerRadius = 10.0f;
                
            } else if (kScreenHeight == 667) {
                self.user_headerImg.layer.cornerRadius = 15.0f;
                
            } else {
                self.user_headerImg.layer.cornerRadius = 20.0f;
                
            }
            self.user_headerImg.layer.masksToBounds = YES;
            self.user_headerImg.backgroundColor = [UIColor redColor];
            
            
            //用户名
            CGRect newNickNameRect = [articleModel.userName boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, 30)
                                                                         options:NSStringDrawingUsesLineFragmentOrigin
                                                                      attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
            self.user_name = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.user_name];
            [self.user_name mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerY.equalTo(self.user_headerImg.mas_centerY);
                make.left.equalTo(self.user_headerImg.mas_right).with.offset(5);
                make.width.offset(newNickNameRect.size.width);
                make.height.equalTo(self.user_headerImg.mas_height);
            }];
            self.user_name.font          = [UIFont systemFontOfSize:12.0f];
            self.user_name.text          = articleModel.userName;
            self.user_name.textAlignment = NSTextAlignmentLeft;
            
            
            //用户评论时间
            self.plTime = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.plTime];
            [self.plTime mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.user_name.mas_right).offset(5);
                make.centerY.equalTo(self.user_name.mas_centerY);
                make.width.equalTo(self.backgroundView.mas_width).with.multipliedBy(0.3);
                make.height.equalTo(self.user_name.mas_height);
            }];
            self.plTime.font          = [UIFont systemFontOfSize:12.0f];
            self.plTime.textAlignment = NSTextAlignmentLeft;
            self.plTime.text          = articleModel.plTime;
            
            
            //点赞图片
            self.thumbImageView = [[UIImageView alloc] init];
            [self.backgroundView addSubview:self.thumbImageView];
            [self.thumbImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(tempView.mas_centerX).with.offset(kScreenWidth * 0.25);
                make.centerY.equalTo(tempView.mas_centerY);
                make.width.offset(15);
                make.height.offset(15);
            }];
            self.thumbImageView.image = [UIImage imageNamed:@"like"];
            
            //点赞人数
            self.thumbUpNum = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.thumbUpNum];
            [self.thumbUpNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.thumbImageView.mas_right);
                make.centerY.equalTo(self.thumbImageView.mas_centerY);
                make.width.equalTo(self.user_headerImg.mas_width).with.multipliedBy(0.5);
                make.height.equalTo(self.user_headerImg.mas_height).with.multipliedBy(0.5);
            }];
            self.thumbUpNum.text = articleModel.thumbNum;
            self.thumbUpNum.font = [UIFont systemFontOfSize:13.0f];
            
            
            //评论图片
            self.replyImageView = [[UIImageView alloc] init];
            [self.backgroundView addSubview:self.replyImageView];
            [self.replyImageView mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.thumbUpNum.mas_right).with.offset(5);
                make.centerY.equalTo(self.thumbImageView.mas_centerY);
                make.width.offset(15);
                make.height.offset(15);
            }];
            self.replyImageView.image = [UIImage imageNamed:@"review"];
            
            //评论人数
            self.replyNum = [[UILabel alloc] init];
            [self.backgroundView addSubview:self.replyNum];
            [self.replyNum mas_makeConstraints:^(MASConstraintMaker *make) {
                make.left.equalTo(self.replyImageView.mas_right);
                make.centerY.equalTo(self.thumbImageView.mas_centerY);
                make.width.equalTo(self.user_headerImg.mas_width).with.multipliedBy(0.5);
                make.height.equalTo(self.user_headerImg.mas_height).with.multipliedBy(0.5);
            }];
            self.replyNum.text = articleModel.replyNum;
            self.replyNum.font = [UIFont systemFontOfSize:11.0f];
        }
    
    }

}

@end
