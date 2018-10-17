//
//  HLHJProjectTableViewCell.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRecommendSix2TableViewCell.h"


@interface HLHJRecommendSix2TableViewCell()

@property (nonatomic, strong) UIImageView  *coverImg;

@property (nonatomic, strong) UILabel     *titlelab;

@property (nonatomic, strong) UILabel     *resource_lan;

@property (nonatomic, strong) UILabel     *authorLab;

@property (nonatomic, strong) UILabel     *timeLab;

@property (nonatomic, strong) UIButton    *stickBtn;
@end

@implementation HLHJRecommendSix2TableViewCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        self.selectionStyle = 0;
        
        [self.contentView addSubview:self.coverImg];
        [self.contentView addSubview:self.titlelab];
        [self.contentView addSubview:self.authorLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.stickBtn];
        
        CGFloat masgin  = 10;
        [self.coverImg mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-masgin);
            make.top.equalTo(self.contentView).mas_offset(masgin * 2);
            make.bottom.equalTo(self.contentView).mas_offset(-masgin * 2);
            make.width.mas_equalTo(120);
            make.height.mas_equalTo(90);
        }];
        
        [self.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView).mas_offset(18);
            make.right.equalTo(self.coverImg.mas_left).mas_offset(-masgin);
            make.left.equalTo(self.contentView.mas_left).mas_offset(13);
        }];
        
        
        [self.stickBtn mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titlelab);
            make.top.equalTo(self.titlelab.mas_bottom).mas_offset(11);
        }];
        
//
        [self.authorLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titlelab);
            make.bottom.equalTo(self.coverImg.mas_bottom);
        }];
//
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.authorLab.mas_right).mas_offset(10);
            make.centerY.equalTo(self.authorLab);
        }];
        
    }
    return self;
    
}

- (void)setListModel:(HLHJSubjectListModel *)listModel {
    _listModel = listModel;
    
    
    NSString *url = @"";
    if ([listModel.cover_img containsString:BASE_URL]) {
        url = listModel.cover_img;
    }else {
        url =  [NSString stringWithFormat:@"%@%@",BASE_URL,listModel.cover_img];
    }
    [self.coverImg sd_setImageWithURL:[NSURL URLWithString:url]];
    
    self.titlelab.text = listModel.subject_name;
    self.authorLab.text  = listModel.author;
    self.timeLab.text = listModel.add_time;

}

- (UIImageView *)coverImg {
    
    if (!_coverImg) {
        _coverImg = [UIImageView new];
        _coverImg.backgroundColor = [UIColor clearColor];
        _coverImg.clipsToBounds  = YES;
        _coverImg.contentMode = UIViewContentModeScaleAspectFit;
    }
    return _coverImg;
}

- (UILabel *)titlelab {
    
    if (!_titlelab) {
        _titlelab = [UILabel new];
        _titlelab.numberOfLines  = 2;
        _titlelab.textColor = [UIColor colorWithHexString:@"#323232"];
        _titlelab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
   
    }
    return _titlelab;
    
}

- (UILabel *)authorLab {
    
    if (!_authorLab) {
        _authorLab = [UILabel new];
        _authorLab.numberOfLines  = 1;
        _authorLab.textColor = [UIColor colorWithHexString:@"999999"];
        _authorLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        
    }
    return _authorLab;
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

- (UIButton *)stickBtn {
    if (!_stickBtn) {
        _stickBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [_stickBtn setTitle:@" 置顶" forState:UIControlStateNormal];
        _stickBtn.titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        [_stickBtn setTitleColor:[UIColor colorWithHexString:@"#FF0000"] forState:UIControlStateNormal];
        [_stickBtn setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/zd"] forState:UIControlStateNormal];
    }
    return _stickBtn;
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
