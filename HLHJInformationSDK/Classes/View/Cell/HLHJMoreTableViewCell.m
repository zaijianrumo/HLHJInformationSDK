//
//  HLHJMoreTableViewCell.m
//  HLHJProjectSDK
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJMoreTableViewCell.h"

@implementation HLHJMoreTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    
        self.selectionStyle = 0;
        UILabel *moreLab = [UILabel new];
        moreLab.text = @"查看更多";
        moreLab.textColor = [UIColor blueColor];
        moreLab.font = [UIFont systemFontOfSize:16];
        [self.contentView addSubview:moreLab];
        
        [moreLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.contentView);
            make.height.mas_equalTo(60);
        }];
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
 
}

@end
