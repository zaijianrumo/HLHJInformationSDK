//
//  HLHJNewDetailSectionOneCell.m
//  HLHJProjectSDK
//
//  Created by mac on 2018/9/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewDetailSectionOneCell.h"

@interface HLHJNewDetailSectionOneCell()

@property (nonatomic, strong) UILabel  *titleLab ,*timeLabel,*authorLabel;
@end

@implementation HLHJNewDetailSectionOneCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        self.selectionStyle = 0;
        
        
        UIView *leftLineView = [UIView new];
        leftLineView.backgroundColor = [TMEngineConfig instance].themeColor;
        [self.contentView addSubview:leftLineView];
        
        [leftLineView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self.contentView);
            make.width.mas_equalTo(7);
        }];
        
        UILabel *titleLabel = [[UILabel alloc] init];
        titleLabel.text = @"新形势下宣传思想工作怎么做?";
        titleLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:23];
        titleLabel.textColor = [UIColor colorWithRed:51/255.0 green:51/255.0 blue:51/255.0 alpha:1];
        titleLabel.numberOfLines = 0;
        [self.contentView addSubview:titleLabel];
        
        [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftLineView.mas_right).mas_offset(9);
            make.top.mas_equalTo(9);
            make.right.mas_equalTo(-5);
        }];
        self.titleLab = titleLabel;
        
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.text = @"";
        timeLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:10];
        timeLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [self.contentView addSubview:timeLabel];
        [timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(titleLabel);
            make.top.equalTo(titleLabel.mas_bottom).mas_offset(30);
            make.bottom.mas_equalTo(-9);
        }];
        self.timeLabel = timeLabel;
        
        
        UILabel *authorLabel = [[UILabel alloc] init];
        authorLabel.text = @"";
        authorLabel.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:12];
        authorLabel.textColor = [UIColor colorWithRed:153/255.0 green:153/255.0 blue:153/255.0 alpha:1];
        [self.contentView addSubview:authorLabel];
        [authorLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(timeLabel);
            make.right.equalTo(self.contentView).mas_offset(-10);
        }];
        self.authorLabel = authorLabel;
        
    }
    return self;
}

- (void)setModel:(HLHJNewsDetilModel *)model {
    _model = model;
    self.titleLab.text = model.title;
    self.authorLabel.text = model.author;
    self.timeLabel.text  = model.add_time;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
