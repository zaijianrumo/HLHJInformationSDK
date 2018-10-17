//
//  HLHJRecommendTwoTableViewCell.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRecommendTwoTableViewCell.h"

@interface HLHJRecommendTwoTableViewCell()

@property (nonatomic, strong) UIImageView *coverImageView;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong) UILabel  *videoTitleLab;

@property (nonatomic, strong) UILabel *titleLab;

@property (nonatomic, strong) UILabel  *timeLab;

@property (nonatomic, strong) UIButton  *shareBtn;

@property (nonatomic, weak) id<HLHJRecommendTwoTableViewCellDelegate> delegate;

@property (nonatomic, strong) NSIndexPath *indexPath;
@end

@implementation HLHJRecommendTwoTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    
    if (self) {
        
        [self.contentView addSubview:self.coverImageView];
        [self.coverImageView addSubview:self.videoTitleLab];
        [self.coverImageView addSubview:self.playBtn];
        [self.contentView addSubview:self.titleLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.shareBtn];
         self.contentView.backgroundColor = [UIColor whiteColor];
        
         self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        UIView *contentView = self.contentView;
        [self.coverImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.right.equalTo(contentView);
            make.height.mas_equalTo(230);
            make.bottom.equalTo(contentView.mas_bottom).mas_offset(-36);
        }];
        
        [self.videoTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.coverImageView.mas_left).mas_offset(10);
            make.top.equalTo(self.coverImageView.mas_top).mas_offset(10);
            make.right.equalTo(self.coverImageView.mas_right).mas_offset(-10);
        }];
        
        
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.centerY.equalTo(self.coverImageView);
        }];
        
        [self.titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(contentView).mas_offset(10);
            make.top.equalTo(self.coverImageView.mas_bottom);
            make.bottom.equalTo(contentView);
        }];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titleLab.mas_right).mas_offset(10);
            make.centerY.equalTo(self.titleLab);
        }];
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(contentView).mas_offset(-10);
            make.centerY.equalTo(self.titleLab);
        }];
        
    }
    return self;
}

- (void)setModel:(HLHJContentModel *)model {
    _model = model;
    self.timeLab.text = model.add_time;
    NSString *vidoeCover = @"";
    if ([model.video_cover containsString:@"://"]) {
        vidoeCover = model.video_cover;
    }else {
        vidoeCover = [NSString stringWithFormat:@"%@%@",BASE_URL,model.video_cover];
    }
    [self.coverImageView sd_setImageWithURL:[NSURL URLWithString:vidoeCover]];
    self.videoTitleLab.text = model.title;
    self.titleLab.text = model.author;
    
}

- (void)setDelegate:(id<HLHJRecommendTwoTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath {
    self.delegate = delegate;
    self.indexPath = indexPath;
}

- (void)playBtnClick:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(zf_playTheVideoAtIndexPath:)]) {
        [self.delegate zf_playTheVideoAtIndexPath:self.indexPath];
    }
}

- (void)shareAction:(UIButton *)sender {
    if ([self.delegate respondsToSelector:@selector(zf_shareAction:)]) {
        [self.delegate zf_shareAction:_model];
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


- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/ic_sy_bofang"] forState:UIControlStateNormal];
        [_playBtn addTarget:self action:@selector(playBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playBtn;
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
        [_shareBtn setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/ic_sp_gd"] forState:UIControlStateNormal];
        
    }
    return _shareBtn;
}
- (UILabel *)titleLab {
    if (!_titleLab) {
        _titleLab = [UILabel new];
        _titleLab.text = @"成都电视台";
        _titleLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _titleLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
    }
    return _titleLab;
}
- (UILabel *)videoTitleLab {
    if (!_videoTitleLab) {
        _videoTitleLab = [[UILabel alloc]init];
        _videoTitleLab.textColor = [UIColor whiteColor];
        _videoTitleLab.numberOfLines = 5;
        _videoTitleLab.text = @"则是一个发放令肌肤是考虑到封口费死灵法师的看法发送到你看爽肤水！";
        _videoTitleLab.font  = [UIFont fontWithName:@"PingFang-SC-Medium" size:16];
    }
    return _videoTitleLab;
}
- (UIImageView *)coverImageView {
    if (!_coverImageView) {
        _coverImageView = [[UIImageView alloc] init];
        _coverImageView.tag = 100;
        _coverImageView.userInteractionEnabled = YES;
        _coverImageView.contentMode = UIViewContentModeScaleAspectFill;
        _coverImageView.clipsToBounds = YES;
    }
    return _coverImageView;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
