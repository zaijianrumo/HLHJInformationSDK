//
//  HLHJNewProjectListCell.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/9/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewProjectListCell.h"

@interface HLHJNewProjectListCell()

@property (nonatomic, strong) UIImageView  *coverImg;

@property (nonatomic, strong) UILabel     *titlelab;

@property (nonatomic, strong) UILabel     *resource_lan;

@property (nonatomic, strong) UILabel     *timeLab;

@property (nonatomic, strong) UIButton    *trafficBtn;


@end


@implementation HLHJNewProjectListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = 0;
        
        [self.contentView addSubview:self.coverImg];
        [self.contentView addSubview:self.titlelab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.trafficBtn];
        
        CGFloat masgin  = 10;
        [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView).mas_offset(0);
            make.top.equalTo(self.contentView).mas_offset(0);
            make.bottom.equalTo(self.contentView).mas_offset(0);
            make.width.mas_equalTo(171);
        }];
        
        [self.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).mas_offset(14);
            make.right.equalTo(self.contentView.mas_right).mas_offset(-masgin);
            make.left.equalTo(self.coverImg.mas_right).mas_offset(masgin);
        }];
        
        
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titlelab);
            make.bottom.equalTo(self.contentView.mas_bottom).mas_offset(-12);
        }];
        
        [self.trafficBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.timeLab);
            make.right.equalTo(self.contentView).mas_offset(-10);
        }];
        
    }
    return self;
    
}

- (void)setModel:(HLHJContentModel *)model {
    
    _model = model;
    
    _titlelab.text = model.title;
    

    
    if (model.type == 4) {
         ///广告
        NSString *imgUrl = model.advertisement_img.count > 0 ? model.advertisement_img[0]:@"";
        
        if ([imgUrl containsString:@"://"]) {
            [_coverImg sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        }else {
            [_coverImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,imgUrl]]];
        }
        
    }else {
        
        NSString *imgUrl = model.extract_img.count > 0 ? model.extract_img[0]:@"";
        
        if ([imgUrl containsString:@"://"]) {
            [_coverImg sd_setImageWithURL:[NSURL URLWithString:imgUrl]];
        }else {
            [_coverImg sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@",BASE_URL,imgUrl]]];
        }
    }
    
    _timeLab.textColor = model.type == 4 ? [UIColor orangeColor]:[UIColor colorWithHexString:@"999999"];

    _timeLab.text = model.type == 4 ? @"广告":model.add_time;
    
    NSInteger browse = _model.click_rate;
    
    if (browse < 1000) {
        [self.trafficBtn setTitle:[NSString stringWithFormat:@" %ld",(long)browse] forState:UIControlStateNormal];
    }else {
        double brow = browse/1000;
        [self.trafficBtn setTitle:[NSString stringWithFormat:@" %.lfk",brow] forState:UIControlStateNormal];
    }

}

- (UIImageView *)coverImg {
    
    if (!_coverImg) {
        _coverImg = [UIImageView new];
        _coverImg.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _coverImg.clipsToBounds  = YES;
        _coverImg.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _coverImg;
}

- (UILabel *)titlelab {
    
    if (!_titlelab) {
        _titlelab = [UILabel new];
        _titlelab.numberOfLines  = 2;
        _titlelab.textColor = [UIColor colorWithHexString:@"#333333"];
        _titlelab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
        
    }
    return _titlelab;
    
}

- (UILabel *)timeLab {
    
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.numberOfLines  = 1;
        _timeLab.textColor = [UIColor colorWithHexString:@"999999"];
        _timeLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        
    }
    return _timeLab;
}

- (UIButton *)trafficBtn {
    if (!_trafficBtn) {
        _trafficBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_trafficBtn setTitle:@" 0" forState:UIControlStateNormal];
        [_trafficBtn setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/ic_views"] forState:UIControlStateNormal];
        [_trafficBtn setTitleColor:[UIColor colorWithHexString:@"999999"] forState:UIControlStateNormal];
        _trafficBtn .titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    }
    return _trafficBtn;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
