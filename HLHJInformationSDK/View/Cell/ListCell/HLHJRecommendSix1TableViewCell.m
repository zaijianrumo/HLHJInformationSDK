//
//  HLHJRecommendTwoTableViewCell.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/11.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRecommendSix1TableViewCell.h"

@implementation HLHJRecommendSix1TableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.contentView.backgroundColor  = [UIColor groupTableViewBackgroundColor];
        self.selectionStyle  = 0;
        [self.contentView addSubview:self.leftBtn];
        [self.contentView addSubview:self.rightBtn];
        
        CGFloat KMargin = 10;
        
        [self.leftBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(0);
            make.top.equalTo(self.contentView).mas_offset(KMargin);
            make.bottom.equalTo(self.contentView).mas_offset(-KMargin);
            make.width.equalTo(self.rightBtn.mas_width);
            make.right.equalTo(self.rightBtn.mas_left).mas_offset(-KMargin/2);
            make.height.mas_equalTo(60);
        }];
        
        [self.rightBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.leftBtn);
            make.bottom.equalTo(self.leftBtn);
            make.right.equalTo(self.contentView).mas_offset(0);
        }];
    
        
    }
    return self;
}
- (UIButton *)leftBtn {
    
    if (!_leftBtn) {
        _leftBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_leftBtn setTitle:@"-" forState:UIControlStateNormal];
        UIColor *color = [TMEngineConfig instance].themeColor? [TMEngineConfig instance].themeColor:[UIColor redColor] ;
        [_leftBtn setBackgroundColor:color];
//        _leftBtn.backgroundColor = [UIColor redColor];
        [_leftBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _leftBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    }
    return _leftBtn;
}


-(UIButton *)rightBtn {
    
    if (!_rightBtn) {
        _rightBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_rightBtn setTitle:@"-" forState:UIControlStateNormal];
  
        [_rightBtn setBackgroundColor:[TMEngineConfig instance].themeColor? [TMEngineConfig instance].themeColor:[UIColor redColor] ];
//          _rightBtn.backgroundColor = [UIColor redColor];
        
        [_rightBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _rightBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:18];
    }
    return _rightBtn;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
