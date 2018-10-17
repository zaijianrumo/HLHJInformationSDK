//
//  HLHJRecommendOneTableViewCell.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRecommendOneTableViewCell.h"

@interface HLHJRecommendOneTableViewCell()

@property (nonatomic, strong) UILabel     *titlelab;

@property (nonatomic, strong) UILabel     *authorLab;

@property (nonatomic, strong) UILabel     *timeLab;

@property (nonatomic, strong) UIView      *contView;

@property (nonatomic, strong) UIButton  *shareBtn; ///分享按钮

@property (nonatomic, strong) UIImageView  *imgView;

@property (nonatomic, strong) NSMutableArray  *masonryViewArray;
@end

@implementation HLHJRecommendOneTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        _masonryViewArray = [NSMutableArray array];
        self.selectionStyle = 0;
        [self.contentView addSubview:self.titlelab];
        [self.contentView addSubview:self.contView];
        [self.contentView addSubview:self.authorLab];
        [self.contentView addSubview:self.timeLab];
        [self.contentView addSubview:self.shareBtn];
        
        CGFloat KMargin  = 10;
        [self.titlelab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.contentView.mas_left).mas_offset(KMargin);
            make.top.equalTo(self.contentView.mas_top).mas_offset(KMargin);
            make.right.equalTo(self.contentView.mas_right).mas_offset(-KMargin);
        }];
        
        [self.contView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.titlelab.mas_bottom).mas_offset(KMargin);
            make.height.mas_equalTo(0);
        }];
        
        [self.authorLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.titlelab);
            make.top.equalTo(self.contView.mas_bottom).mas_offset(KMargin);
            make.bottom.equalTo(self.contentView.mas_bottom).mas_offset(-KMargin);
        }];
        [self.timeLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.authorLab.mas_right).mas_offset(KMargin);
            make.centerY.equalTo(self.authorLab);
        }];
        
        [self.shareBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(self.contentView).mas_offset(-KMargin);
            make.centerY.equalTo(self.authorLab);
        }];
        
        self.shareBtn.hidden = YES;
        
    }
    return self;
}

- (void)setModel:(HLHJContentModel *)model {
    
    _model = model;
    self.titlelab.text = model.title;
    self.timeLab.text = model.add_time;
    
    NSMutableArray *imgArr = [NSMutableArray array];
    if (model.type == 1) { ///文章
        [imgArr addObjectsFromArray:model.extract_img];
        self.authorLab.text = [NSString stringWithFormat:@"%@  浏览量:%ld",model.author,(long)model.click_rate];
    }else if (model.type == 4){ ///广告
        
        [imgArr addObjectsFromArray:model.advertisement_img];
        
        NSString *contentStr = [NSString stringWithFormat:@"广告  %@",model.advertiser];
        NSMutableAttributedString *str = [[NSMutableAttributedString alloc]initWithString:contentStr];
        [str addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"FFB400"] range:NSMakeRange(0, 2)];
        self.authorLab.attributedText = str;
    }
    if (imgArr.count > 0) {
        ///1.判断图片数量改变对应高度
        NSInteger padding = 10;
        [self.contView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.right.equalTo(self.contentView);
            make.top.equalTo(self.titlelab.mas_bottom).mas_offset(padding);
            if (imgArr.count == 1) {
                 make.height.mas_equalTo(175);
            }else {
                 make.height.mas_equalTo(100);
            }
        }];
           ///2.删除所有已经添加的图片
        [self.imgView removeFromSuperview];
        [[self.contView subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
        
          ///3.单张图片布局
        if (imgArr.count == 1) {
            [self.contView addSubview:self.imgView];
            
              NSString *url = imgArr[0];
            if ([url containsString:@"://"]) {
                url = imgArr[0];
            }else {
                url = [NSString stringWithFormat:@"%@%@",BASE_URL,imgArr[0]];
            }
            [self.imgView sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"HLHJImageResources.bundle/img_holder"]];
            [self.imgView mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.top.bottom.equalTo(self.contView);
                make.left.mas_equalTo(padding);
                make.right.equalTo(self.contView.mas_right).mas_offset(-padding);
            }];
        }else {
            ///4.多张张图片布局
            [_masonryViewArray removeAllObjects];
            for (NSString *imgurl in imgArr) {
                UIImageView  *imgView = [UIImageView new];
                imgView.backgroundColor  = [UIColor groupTableViewBackgroundColor];
                imgView.contentMode = UIViewContentModeScaleAspectFill;
                imgView.clipsToBounds = YES;
                NSString *coverUrl  = @"";
                
                if ([imgurl containsString:@"://"]) {
                    coverUrl = imgurl;
                }else {
                    coverUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,imgurl];
                }
                NSLog(@"coverUrl:%@",coverUrl);
                [imgView sd_setImageWithURL:[NSURL URLWithString:coverUrl] placeholderImage:[UIImage imageNamed:@"HLHJImageResources.bundle/img_holder"]];
                [self.contView addSubview:imgView];
                [_masonryViewArray addObject:imgView];
            }
            [_masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:padding leadSpacing:padding tailSpacing:padding];
           
            [_masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
                        make.top.equalTo(self.contView.mas_top).offset(0);
                        make.height.mas_equalTo(self.contView.mas_height);
            }];
        }
    }
    
    
}
- (void)shareAction:(UIButton *)sender {
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(articleShareAction:)]) {
        [self.delegate articleShareAction:_model];
    }
    
}
- (UILabel *)titlelab {
    
    if (!_titlelab) {
        _titlelab = [[UILabel alloc]init];
        _titlelab.numberOfLines  = 1;
        _titlelab.text = @"印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！印度电影怎么成了香饽饽了！";
        _titlelab.textColor = [UIColor colorWithHexString:@"#323232"];
        _titlelab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:17];
        
    }
    return _titlelab;
}

- (UILabel *)authorLab {
    
    if (!_authorLab) {
        _authorLab = [UILabel new];
        _authorLab.text = @"你是大流氓    浏览量:123";
        _authorLab.numberOfLines  = 1;
        _authorLab.textColor = [UIColor colorWithHexString:@"#999999"];
        _authorLab.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        
    }
    return _authorLab;
}
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

- (UIView *)contView {
    if (!_contView) {
        _contView = [UIView new];
    }
    return _contView;
}

- (UIImageView *)imgView {
    if (!_imgView) {
        _imgView = [UIImageView new];
        _imgView.backgroundColor = [UIColor groupTableViewBackgroundColor];
        _imgView.clipsToBounds = YES;
        _imgView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _imgView;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
}
- (UIButton *)shareBtn {
    if (!_shareBtn) {
        _shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_shareBtn setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/ic_sp_gd"] forState:UIControlStateNormal];
        [_shareBtn addTarget:self action:@selector(shareAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _shareBtn;
}
@end
