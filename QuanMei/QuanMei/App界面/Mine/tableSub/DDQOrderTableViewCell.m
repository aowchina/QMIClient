//
//  DDQOrderTableViewCell.m
//  QuanMei
//
//  Created by Min-Fo-002 on 15/11/10.
//  Copyright © 2015年 min-fo. All rights reserved.
//

#import "DDQOrderTableViewCell.h"

#import "Header.h"


@implementation DDQOrderTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        CGFloat height = kScreenHeight * 0.2f;
        ;
        
        //图
        _godsOrderImageView = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, self.contentView.frame.size.width/3-20, height - 20)];
        
        
        [self.contentView addSubview:_godsOrderImageView];
        
        //标题
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(_godsOrderImageView.frame.origin.x +_godsOrderImageView.frame.size.width +10 , 10, self.contentView.frame.size.width/3*2, (height-20)/3)];
        [self.contentView addSubview:_titleLabel];
        _titleLabel.font = [UIFont systemFontOfSize:17.0f];

        
        //医院
        _hospitalLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x, _titleLabel.frame.origin.y+_titleLabel.frame.size.height, _titleLabel.frame.size.width, _titleLabel.frame.size.height)];
        _hospitalLabel.font = [UIFont systemFontOfSize:13.0f];
        [self.contentView addSubview:_hospitalLabel];
        
        //价格
        _priceLabel = [[UILabel alloc]initWithFrame:CGRectMake(_titleLabel.frame.origin.x  , _hospitalLabel.frame.origin.y +_hospitalLabel.frame.size.height , _hospitalLabel.frame.size.width/3*2, _titleLabel.frame.size.height)];
        _priceLabel.font = [UIFont systemFontOfSize:15.0f];
        _priceLabel.userInteractionEnabled = YES;
        [self.contentView addSubview:_priceLabel];
        
        
        //12-16
        //类型
        _typeLabel = [[UILabel alloc]initWithFrame:CGRectMake(_priceLabel.frame.origin.x + _priceLabel.frame.size.width + 20,    _priceLabel.frame.origin.y  +5, _hospitalLabel.frame.size.width/3-25, _titleLabel.frame.size.height-5)];
        
        _typeLabel.layer.masksToBounds= YES;
        
        _typeLabel.textAlignment = 1;
        _typeLabel.layer.cornerRadius = 5;
        
        _typeLabel.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:66.0/255.0 blue:100.0/255.0 alpha:1];
        _typeLabel.textColor = [UIColor whiteColor];
        _typeLabel.font = [UIFont systemFontOfSize:12.0f];
        [self.contentView addSubview:_typeLabel];
        
    }
    
    
    return self;
}

- (void)setModel:(DDQOrderModel *)model
{
    if (![DDQPublic isBlankString:model.simg])
    {
        [_godsOrderImageView sd_setImageWithURL:[NSURL URLWithString:model.simg] placeholderImage:[UIImage imageNamed:@"default_pic"]];
    }
    else
    {
        [_godsOrderImageView setImage:[UIImage imageNamed:@"default_pic"]];
    }
    
    //名称
    if (![DDQPublic isBlankString:model.name])
    {
        _titleLabel.text = [NSString stringWithFormat:@" [%@]%@",model.fname,model.name];
    }
    else
    {
        _titleLabel.text = [NSString stringWithFormat:@" [%@]%@",model.fname,@"暂无"];
    }
    //医院名
    if (model.hname !=nil) {
        _hospitalLabel.text = model.hname;
    }
    else{
        _hospitalLabel.text = @"暂无";
    }
    
    //定金
    if (![DDQPublic isBlankString:model.dj]) {
        _priceLabel.text =[NSString stringWithFormat:@"定金:%@",model.dj];
    }
    else
    {
        _priceLabel.text =[NSString stringWithFormat:@"定金:%@",@"暂无"];
        
    }
    switch ([model.status intValue]) {
        case 1:
        {
            _typeLabel.text = @"待支付";
            UIButton *button = [[UIButton alloc] init];
            [self.contentView addSubview:button];
            [button mas_makeConstraints:^(MASConstraintMaker *make) {
                make.top.equalTo(_typeLabel.mas_top);
                make.right.equalTo(_typeLabel.mas_left).offset(-10);
                make.width.equalTo(_typeLabel.mas_width);
                make.height.equalTo(_typeLabel.mas_height);
            }];
            [button addTarget:self action:@selector(deleteButtonMethod) forControlEvents:UIControlEventTouchUpInside];
            [button setTitle:@"删除" forState:UIControlStateNormal];
            [button setBackgroundColor:[UIColor backgroundColor]];
            button.titleLabel.font = [UIFont systemFontOfSize:12.0f];
            button.titleLabel.textColor = [UIColor colorWithRed:255.0/255.0 green:66.0/255.0 blue:100.0/255.0 alpha:1];
            button.layer.cornerRadius = 5;

            break;
        }
        case 2:
        {
            _typeLabel.text = @"已支付";
            _typeLabel.backgroundColor = [UIColor colorWithRed:134.0/255 green:220.0/255 blue:213.0/255 alpha:1];
            break;
        }
        case 3:
        {
            _typeLabel.text = @"待评价";
            break;
        }
        case 4:
        {
            _typeLabel.text = @"已结束";
            break;
        }
        default:
            break;
    }
    
}

-(void)deleteButtonMethod {

    if (self.block) {
        
        self.block();
        
    }
    
}

-(void)orderCellCallBackMethod:(OrderCellBlock)block {

    if (block) {
        
         self.block = block;
        
    }
    
}


@end
