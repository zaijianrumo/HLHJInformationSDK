//
//  HLHJColumnMenuHeaderView.h
//  HLHJCollectionView
//
//  Created by 刘俊敏 on 2017/12/7.
//  Copyright © 2017年 lHLHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HLHJColumnMenuHeaderView : UICollectionReusableView

/** 标题str */
@property (nonatomic, copy) NSString *titleStr;
/** 描述str */
@property (nonatomic, copy) NSString *detailStr;

/** 编辑按钮 */
@property (nonatomic, strong) UIButton *editBtn;

@end
