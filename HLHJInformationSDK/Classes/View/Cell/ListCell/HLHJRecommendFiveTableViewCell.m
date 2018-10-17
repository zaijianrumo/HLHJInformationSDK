//
//  HLHJRecommendOneTableViewCell.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRecommendFiveTableViewCell.h"

@implementation HLHJRecommendFiveTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self){
        [self.contentView addSubview:self.cycleScrollView];
        
        [self.cycleScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
            make.height.mas_equalTo(180);
        }];
    }
    return self;
    
}
- (SDCycleScrollView *)cycleScrollView {
    if (!_cycleScrollView) {
        _cycleScrollView = [[SDCycleScrollView alloc]init];
        _cycleScrollView.backgroundColor = [UIColor whiteColor];
        _cycleScrollView.pageDotColor = [UIColor whiteColor];
        _cycleScrollView.currentPageDotColor = [TMEngineConfig instance].themeColor;
        _cycleScrollView.bannerImageViewContentMode = UIViewContentModeScaleToFill;
        _cycleScrollView.showPageControl = NO;
    }
    return _cycleScrollView;
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
