//
//  HLHJColumnMenuCell.h
//  HLHJCollectionView
//
//  Created by 刘俊敏 on 2017/12/7.
//  Copyright © 2017年 lHLHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HLHJColumnMenuModel.h"

@interface HLHJColumnMenuCell: UICollectionViewCell

/** title */
@property (nonatomic, strong) UILabel *title;
/** closeBtn */
@property (nonatomic, strong) UIButton *closeBtn;
/** addbtn */
@property (nonatomic, strong) UIButton *addBtn;
/** 数据模型 */
@property (nonatomic, strong) HLHJColumnMenuModel *model;

@end
