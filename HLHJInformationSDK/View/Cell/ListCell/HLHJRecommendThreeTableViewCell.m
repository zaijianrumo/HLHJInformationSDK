//
//  HLHJRecommendThreeTableViewCell.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRecommendThreeTableViewCell.h"



@interface HLHJRecommendThreeTableViewCell()


@property (nonatomic, strong) UIImageView  *imageVsiew;

@property (nonatomic, strong) UILabel *titleLab; ///标题

@property (nonatomic, strong) UILabel *source_Lab; ///来源

@property (nonatomic, strong) UIButton  *shareBtn; ///分享按钮

@property (nonatomic, strong) UILabel  *timeLab;



@property (nonatomic, strong) UIView   *bottomView;

@property (nonatomic, strong) UILabel  *countLab;

@end

@implementation HLHJRecommendThreeTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
    
        self.selectionStyle  = UITableViewCellSelectionStyleNone;
        
        [self.contentView addSubview:self.imageVsiew];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.bottomView];
        
        [self.bottomView addSubview:self.shareBtn];
        [self.bottomView addSubview:self.source_Lab];
        [self.bottomView addSubview:self.timeLab];
      
        [self.imageVsiew addSubview:self.countLab];
        
        [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.bottom.equalTo(self.contentView);
            make.height.mas_equalTo(40);
        }];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).mas_offset(10);
            make.right.equalTo(self.contentView.mas_right).mas_offset(-10);
            make.top.equalTo(self.contentView.mas_top).mas_offset(12);
        }];
        
        [self.imageVsiew mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.titleLab.mas_bottom).mas_offset(12);
            make.height.mas_equalTo(180);
            make.bottom.equalTo(self.bottomView.mas_top).mas_offset(0);
        }];
        
        [self.countLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.imageVsiew).mas_offset(-10);
            make.bottom.equalTo(self.imageVsiew).mas_offset(-10);
            make.height.mas_equalTo(18);
        }];
        

        [self.source_Lab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomView.mas_left).mas_offset(10);
            make.centerY.equalTo(self.bottomView.mas_centerY);
        }];
        
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.source_Lab.mas_right).mas_offset(10);
            make.centerY.equalTo(self.source_Lab);
        }];
        
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.bottomView).mas_offset(-10);
            make.centerY.equalTo(self.source_Lab);
        }];

    }
    return self;
}

- (void)setModel:(HLHJContentModel *)model {
    _model = model;
    self.titleLab.text = model.title;
    self.timeLab.text = model.add_time;
    
    NSString *atlasimg = @"";
    if (model.atlas_img.count > 0 ) {
        if ([model.atlas_img[0] containsString:@"://"]) {
             atlasimg = model.atlas_img[0];
        }else {
            atlasimg = [NSString stringWithFormat:@"%@%@",BASE_URL,model.atlas_img[0]];
        }
    }else {
        atlasimg = @"";
    }
    
    [self.imageVsiew sd_setImageWithURL:[NSURL URLWithString:atlasimg]];
    
    self.source_Lab.text = [NSString stringWithFormat:@"%@ 浏览量:%ld",model.author,model.click_rate +1];
    self.countLab.text = [NSString stringWithFormat:@"  %lu图  ",(unsigned long)model.atlas_img.count];    
}
- (void)shareAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(shareAction:)]) {
        [self.delegate shareAction:_model];
    }
    
}

#pragma mark - getter

- (UILabel *)timeLab {
    
    if (!_timeLab) {
        _timeLab = [UILabel new];
        _timeLab.text = @"";
        _timeLab.numberOfLines  = 1;
        _timeLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _timeLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        
    }
    return _timeLab;
}


- (UIView *)bottomView {
    
    if (!_bottomView) {
        _bottomView = [UIView new];
        _bottomView.backgroundColor = [UIColor clearColor];
    }
    return _bottomView;
}

- (UIImageView * )imageVsiew {
    
    if(!_imageVsiew){
        _imageVsiew = [[UIImageView alloc]init];
        _imageVsiew.image = [UIImage imageNamed:@"HLHJImageResources.bundle/test1"];
        _imageVsiew.clipsToBounds = YES;
        _imageVsiew.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imageVsiew;
    
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/ic_sp_gd"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"眼绿江尽然挖出1米8条的大雨，厉害了大爷眼绿江尽然挖出1米8条的大雨，厉害了大爷眼绿江尽然挖出1米8条的大雨，厉害了大爷眼绿江尽然挖出1米8条的大雨，厉害了大爷眼绿江尽然挖出1米8条的大雨，厉害了大爷";
        _titleLab.textColor = [UIColor colorWithHexString:@"#323232"];
        _titleLab.numberOfLines = 1;
        _titleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
    }
    return _titleLab;
}
- (UILabel *)source_Lab {
    if (!_source_Lab) {
        _source_Lab = [UILabel new];
        _source_Lab.text = @"成都电视台";
        _source_Lab.textColor = [UIColor colorWithHexString:@"#999999"];
        _source_Lab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    }
    return _source_Lab;
}
-(UILabel *)countLab {
    
    if (!_countLab) {
        _countLab = [UILabel new];
        _countLab.text = @"    10图   ";
        _countLab.textColor = [UIColor whiteColor];
        _countLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:11];
        _countLab.backgroundColor = [[UIColor blackColor]colorWithAlphaComponent:.5];
        _countLab.clipsToBounds = YES;
        _countLab.layer.cornerRadius = 6;

    }
    return _countLab;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
