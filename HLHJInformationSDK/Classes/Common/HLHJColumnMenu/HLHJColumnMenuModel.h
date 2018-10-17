//
//  HLHJColumnMenuModel.h
//  HLHJCollectionView
//
//  Created by 刘俊敏 on 2017/12/8.
//  Copyright © 2017年 lHLHJ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HLHJColumnMenu.h"

@interface HLHJColumnMenuModel : NSObject

/** ID */
@property (nonatomic, copy) NSString *ID;
/** title */
@property (nonatomic, copy) NSString *title;
/** 是否选中 */
@property (nonatomic, assign) BOOL selected;
/** 是否允许删除 */
@property (nonatomic, assign) BOOL resident;
/** 是否显示加号 */
@property (nonatomic, assign) BOOL showAdd;
/** type */
@property (nonatomic, assign) HLHJColumnMenuType type;

@end
