//
//  DDQHospitalEvaluateCell.m
//  QuanMei
//
//  Created by Min-Fo_003 on 15/10/23.
//  Copyright (c) 2015年 min-fo. All rights reserved.
//

#import "DDQHospitalEvaluateCell.h"

@interface DDQHospitalEvaluateCell ()

@property ( strong, nonatomic) UIView *background_view;

@end

@implementation DDQHospitalEvaluateCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {

    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        self.background_view = [[UIView alloc] init];
        [self.contentView addSubview:self.background_view];
        [self.background_view mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.top.equalTo(self.contentView.mas_top).offset(5);
            make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
            make.left.equalTo(self.contentView.mas_left);
            make.right.equalTo(self.contentView.mas_right);
            
        }];
        
        self.contentView.backgroundColor = [UIColor backgroundColor];
        self.background_view.backgroundColor = [UIColor whiteColor];
        
    }
    
    return self;
    
}

-(void)cellWithUserImageUrl:(NSString *)userImage andUserName:(NSString *)userName andDate:(NSString *)date andStarCount:(int)count andUserComment:(NSString *)userComment andProjectInto:(NSString *)projectIntro andProjectImg:(NSString *)img{
    
    UIImageView *userImageView = [[UIImageView alloc] init];
    [self.background_view addSubview:userImageView];
    [userImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView.mas_left).offset(10);
        make.top.equalTo(self.contentView.mas_top).offset(10);
        if (kScreenHeight == 480) {
            make.width.offset(20);
            make.height.offset(20);
        } else if (kScreenHeight == 568) {
            make.width.offset(25);
            make.height.offset(25);
        } else if (kScreenHeight == 667) {
            make.width.offset(30);
            make.height.offset(30);
        } else {
            make.width.offset(30);
            make.height.offset(30);
        }
    }];
    [userImageView sd_setImageWithURL:[NSURL URLWithString:userImage] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    if (kScreenHeight == 480) {
        userImageView.layer.cornerRadius = 10.0f;
    } else if (kScreenHeight == 568) {
        userImageView.layer.cornerRadius = 12.5f;

    } else if (kScreenHeight == 667) {
        userImageView.layer.cornerRadius = 15.0f;

    } else {
        userImageView.layer.cornerRadius = 15.0f;
    }
    userImageView.layer.masksToBounds = YES;
        
    UILabel *user_nickName = [[UILabel alloc] init];
    [self.background_view addSubview:user_nickName];
//    CGRect nickNameRect;
    [user_nickName mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(userImageView.mas_top);
        make.left.equalTo(userImageView.mas_right).offset(10);
    }];
    user_nickName.font = [UIFont systemFontOfSize:12.0f];
    user_nickName.text = userName;
    user_nickName.textAlignment = NSTextAlignmentLeft;
    
    UILabel *user_date     = [[UILabel alloc] init];
    [self.background_view addSubview:user_date];
//    CGRect dateRect;
    [user_date mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(user_nickName.mas_bottom).offset(5);
        make.left.equalTo(userImageView.mas_right).offset(10);
    }];
    user_date.font = [UIFont systemFontOfSize:12.0f];
    user_date.text = date;
    user_date.textAlignment = NSTextAlignmentLeft;
    
//    UILabel *commentLabel = [[UILabel alloc] init];
//    [self.contentView addSubview:commentLabel];
    
//    CGFloat height         = userImageView.frame.size.height*0.5;
    
//    if (kScreenHeight == 480) {
//        userImageView.layer.cornerRadius  = 20.0f;
//        userImageView.layer.masksToBounds = YES;
//        
//        nickNameRect        = [userName boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil];
//        user_nickName.frame = CGRectMake(55, 10, nickNameRect.size.width, nickNameRect.size.height);
//        user_nickName.font  = [UIFont systemFontOfSize:15.0f];
//        user_nickName.text  = userName;
//        
//        dateRect            = [date boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
//        user_date.frame     = CGRectMake(55, 15+nickNameRect.size.height, dateRect.size.width, dateRect.size.height);
//        user_date.text      = date;
//        user_date.font      = [UIFont systemFontOfSize:12.0f];
//        
//        _newRect            = [userComment boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
//        commentLabel.frame  = CGRectMake(55, 20+nickNameRect.size.height+dateRect.size.height, _newRect.size.width, _newRect.size.height);
//        commentLabel.text   = userComment;
//        commentLabel.numberOfLines = 0;
//        commentLabel.font   = [UIFont systemFontOfSize:14.0f];
//        
//        
//    } else if (kScreenHeight == 568) {
//        userImageView.layer.cornerRadius  = 25.0f;
//        userImageView.layer.masksToBounds = YES;
//
//        nickNameRect        = [userName boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, userImageView.frame.size.height*0.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil];
//        user_nickName.frame = CGRectMake(65, 10, nickNameRect.size.width, nickNameRect.size.height);
//        user_nickName.font  = [UIFont systemFontOfSize:15.0f];
//        user_nickName.text  = userName;
//        
//        dateRect            = [date boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
//        user_date.frame     = CGRectMake(65, 15+nickNameRect.size.height, dateRect.size.width, dateRect.size.height);
//        user_date.text      = date;
//        user_date.font      = [UIFont systemFontOfSize:12.0f];
//        
//        _newRect            = [userComment boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
//        commentLabel.frame  = CGRectMake(65, 20+nickNameRect.size.height+dateRect.size.height, _newRect.size.width, _newRect.size.height);
//        commentLabel.text   = userComment;
//        commentLabel.numberOfLines = 0;
//        commentLabel.font   = [UIFont systemFontOfSize:14.0f];
//        
//
//    } else if (kScreenHeight == 667) {
//        userImageView.layer.cornerRadius  = 30.0f;
//        userImageView.layer.masksToBounds = YES;
//
//        nickNameRect        = [userName boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, userImageView.frame.size.height*0.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil];
//        user_nickName.frame = CGRectMake(75, 15+nickNameRect.size.height, nickNameRect.size.width, nickNameRect.size.height);
//        user_nickName.font  = [UIFont systemFontOfSize:15.0f];
//        user_nickName.text  = userName;
//        
//        dateRect            = [date boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
//        user_date.frame     = CGRectMake(75, 15+nickNameRect.size.height, dateRect.size.width, dateRect.size.height);
//        user_date.text      = date;
//        user_date.font      = [UIFont systemFontOfSize:12.0f];
//        
//        _newRect            = [userComment boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
//        commentLabel.frame  = CGRectMake(75, 20+nickNameRect.size.height+dateRect.size.height, _newRect.size.width, _newRect.size.height);
//        commentLabel.text   = userComment;
//        commentLabel.numberOfLines = 0;
//        commentLabel.font   = [UIFont systemFontOfSize:14.0f];
//        
//        
//    } else {
//        userImageView.layer.cornerRadius  = 35.0f;
//        userImageView.layer.masksToBounds = YES;
//        
//        nickNameRect        = [userName boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, userImageView.frame.size.height*0.5) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16.0f]} context:nil];
//        user_nickName.frame = CGRectMake(85, 10, nickNameRect.size.width, nickNameRect.size.height);
//        user_nickName.font  = [UIFont systemFontOfSize:15.0f];
//        user_nickName.text  = userName;
//        
//        dateRect            = [date boundingRectWithSize:CGSizeMake(kScreenWidth*0.5, height) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f]} context:nil];
//        user_date.frame     = CGRectMake(85, 15+nickNameRect.size.height, dateRect.size.width, dateRect.size.height);
//        user_date.text      = date;
//        user_date.font      = [UIFont systemFontOfSize:12.0f];
//        
//        _newRect            = [userComment boundingRectWithSize:CGSizeMake(kScreenWidth, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
//        commentLabel.frame  = CGRectMake(85, 20+nickNameRect.size.height+dateRect.size.height, _newRect.size.width, _newRect.size.height);
//        commentLabel.text   = userComment;
//        commentLabel.numberOfLines = 0;
//        commentLabel.font   = [UIFont systemFontOfSize:14.0f];
//    }
//    userImageView.backgroundColor         = [UIColor orangeColor];
    
    
    UIView *star_view = [[UIView alloc] init];
    [self.contentView addSubview:star_view];
    [star_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(user_nickName.mas_centerY);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        make.width.offset(kScreenWidth*0.3);
        make.height.equalTo(user_nickName.mas_height);
    }];
    
    CGFloat imageWidth  = kScreenWidth * 0.3/ count/ 2;
    CGFloat imageHeight = 10;
    for (int i = 0; i<count; i++) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(imageWidth*i + 5*i , 5, imageWidth, imageHeight)];
        imageView.image        = [UIImage imageNamed:@"icon_little_star_fill"];
        [star_view addSubview:imageView];
    }
    
    UIView *temp_view         = [[UIView alloc] init];
    [self.background_view addSubview:temp_view];
    [temp_view mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(user_date.mas_left);
        make.top.equalTo(user_date.mas_bottom).offset(10);
        make.right.equalTo(self.contentView.mas_right).offset(-10);
        if (kScreenHeight == 480) {
            make.height.offset(30);
        } else if (kScreenHeight == 568) {
            make.height.offset(40);
        } else if (kScreenHeight == 667) {
            make.height.offset(50);
        } else {
            make.height.offset(50);
        }
    }];
    temp_view.backgroundColor  = [UIColor backgroundColor];
    
    
    UIImageView *projectImage    = [[UIImageView alloc] init];
    [temp_view addSubview:projectImage];
    [projectImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(temp_view.mas_left).offset(5);
        make.centerY.equalTo(temp_view.mas_centerY);
        if (kScreenHeight == 480) {
            make.width.offset(20);
            make.height.offset(20);
        } else if (kScreenHeight == 568) {
            make.width.offset(30);
            make.height.offset(30);
            
        } else if (kScreenHeight == 667) {
            make.width.offset(40);
            make.height.offset(40);
            
        } else {
            make.width.offset(40);
            make.height.offset(40);
        };
    }];
//    projectImage.backgroundColor = [UIColor purpleColor];
    [projectImage sd_setImageWithURL:[NSURL URLWithString:img] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    
    UILabel *projectLabel = [[UILabel alloc] init];
    [temp_view addSubview:projectLabel];
    [projectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(projectImage.mas_right);
        make.centerY.equalTo(projectImage.mas_centerY);
        make.height.equalTo(projectImage.mas_height);
        make.right.equalTo(temp_view.mas_right).offset(-5);
    }];
    projectLabel.text = projectIntro;
    projectLabel.font = [UIFont systemFontOfSize:12.0f];

//    self.height = 40 + 50;
//    CGRect projectRec = [projectIntro boundingRectWithSize:CGSizeMake(kScreenWidth, 30) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15.0f]} context:nil];
//    if (kScreenHeight == 480) {
//        projectLabel.frame = CGRectMake(35, 5, projectRec.size.width, projectRec.size.height);
//        projectLabel.text  = projectIntro;
//        projectLabel.font  = [UIFont systemFontOfSize:14.0f];
//        
//    } else if (kScreenHeight == 568) {
//        projectLabel.frame = CGRectMake(45, 5, projectRec.size.width, projectRec.size.height);
//        projectLabel.text  = projectIntro;
//        projectLabel.font  = [UIFont systemFontOfSize:14.0f];
//        
//    } else if (kScreenHeight == 667) {
//        projectLabel.frame = CGRectMake(55, 5, projectRec.size.width, projectRec.size.height);
//        projectLabel.text  = projectIntro;
//        projectLabel.font  = [UIFont systemFontOfSize:14.0f];
//        
//    } else {
//        projectLabel.frame = CGRectMake(65, 5, projectRec.size.width, projectRec.size.height);
//        projectLabel.text  = projectIntro;
//        projectLabel.font  = [UIFont systemFontOfSize:14.0f];
//    };
    
//    UIView *replyView = [[UIView alloc] init];
//    [self.contentView addSubview:replyView];
//    [replyView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView.mas_right).offset(-10);
//        make.bottom.equalTo(self.contentView.mas_bottom).offset(-5);
//        if (kScreenHeight == 480) {
//            make.width.offset(60);
//            
//        } else if (kScreenHeight == 568) {
//            make.width.offset(70);
//            
//        } else if (kScreenHeight == 667) {
//            make.width.offset(80);
//            
//        } else {
//            make.width.offset(90);
//        };
//        make.height.offset(25);
//    }];
//    replyView.backgroundColor   = [UIColor whiteColor];
//    replyView.layer.borderWidth = 0.5f;
//    
//    UIImageView *replyImage   = [[UIImageView alloc] init];
//    [replyView addSubview:replyImage];
//    [replyImage mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(replyView.mas_left).offset(5);
//        make.top.equalTo(replyView.mas_top).offset(5);
//        make.bottom.equalTo(replyView.mas_bottom).offset(-5);
//        make.width.equalTo(replyView.mas_width).multipliedBy(0.4).offset(-5);
//    }];
//    replyImage.image          = [UIImage imageNamed:@"reply"];
//    
//    UILabel *replyLabel      = [[UILabel alloc] init];
//    [replyView addSubview:replyLabel];
//    [replyLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.equalTo(replyImage.mas_right);
//        make.centerY.equalTo(replyImage.mas_centerY);
//        make.width.equalTo(replyView.mas_width).multipliedBy(0.6);
//        make.height.equalTo(replyImage.mas_height);
//    }];
//    replyLabel.font          = [UIFont systemFontOfSize:15.0f];
//    replyLabel.text          = @"回复";
//    replyLabel.textAlignment = NSTextAlignmentCenter;
}

@end
