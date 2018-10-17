//
//  HLHJRecommendThreeTableViewCell.h
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HLHJContentModel.h"

@protocol HLHJRecommendThreeTableViewCellDelegate<NSObject>

-(void)shareAction:(HLHJContentModel *)model;

@end

/**
 @brief 图集
 */
@interface HLHJRecommendThreeTableViewCell : UITableViewCell

@property (nonatomic, strong) HLHJContentModel  *model;

@property (nonatomic, weak) id<HLHJRecommendThreeTableViewCellDelegate>  delegate;

@end
