//
//  HLHJRecommendOneTableViewCell.h
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLHJContentModel.h"

@protocol HLHJRecommendOneTableViewCellDelegate<NSObject>

-(void)articleShareAction:(HLHJContentModel *)model;

@end
/**
 cell type:1->文章
 */
@interface HLHJRecommendOneTableViewCell : UITableViewCell

@property (nonatomic, weak) id<HLHJRecommendOneTableViewCellDelegate>  delegate;

@property (nonatomic, strong) HLHJContentModel  *model;

@end
