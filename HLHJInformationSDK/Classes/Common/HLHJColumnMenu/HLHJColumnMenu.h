//
//  HLHJColumnMenuController.h
//  HLHJCollectionView
//
//  Created by HLHJ on 2017/12/11.
//  Copyright © 2017年 lHLHJ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, HLHJColumnMenuType) {
    HLHJColumnMenuTypeTencent, //腾讯新闻
    HLHJColumnMenuTypeTouTiao, //今日头条
};

@protocol HLHJColumnMenuDelegate <NSObject>

/**
 * tagsArr 排序后的选择数组
 * otherArr 排序后未选择数组
 */
- (void)columnMenuTagsArr:(NSMutableArray *)tagsArr OtherArr:(NSMutableArray *)otherArr;

/**
 * 点击的标题
 * 对应的index
 */
- (void)columnMenuDidSelectTitle:(NSString *)title Index:(NSInteger)index;

@end

@interface HLHJColumnMenu : UIViewController

/**
 * 初始化方法
 */
+ (instancetype)columnMenuWithTagsArrM:(NSMutableArray *)tagsArrM OtherArrM:(NSMutableArray *)otherArrM Type:(HLHJColumnMenuType)type Delegate:(id<HLHJColumnMenuDelegate>)delegate;

- (instancetype)initWithTagsArrM:(NSMutableArray *)tagsArrM OtherArrM:(NSMutableArray *)otherArrM Type:(HLHJColumnMenuType)type Delegate:(id<HLHJColumnMenuDelegate>)delegate;

/** 代理 */
@property (nonatomic, weak) id <HLHJColumnMenuDelegate>delegate;
/** 类型 */
@property (nonatomic, assign) HLHJColumnMenuType type;

@end
