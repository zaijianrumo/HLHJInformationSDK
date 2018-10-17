//
//  HLHJRecommendTwoTableViewCell.h
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLHJContentModel.h"
/**
 @brief 视频
 */
@protocol HLHJRecommendTwoTableViewCellDelegate <NSObject>

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath;

- (void)zf_shareAction:(HLHJContentModel *)model;
@end

@interface HLHJRecommendTwoTableViewCell : UITableViewCell


- (void)setDelegate:(id<HLHJRecommendTwoTableViewCellDelegate>)delegate withIndexPath:(NSIndexPath *)indexPath;


@property (nonatomic, strong) HLHJContentModel  *model;

@end
