//
//  HLHJNewDetailCommonToolView.h
//  HLHJInformationSDK
//
//  Created by mac on 2018/9/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol HLHJNewDetailCommonToolViewDelegate<NSObject>

@optional
///分享
- (void)shareActon:(UIButton *)sender;

///收藏
- (void)collectAction:(UIButton *)sender;

///发送评论
- (void)sendContentAction:(UIButton *)sender ;

@end

@interface HLHJNewDetailCommonToolView : UIView

@property (nonatomic, strong) UIButton  *collectBtn;

@property (nonatomic, strong) UITextField  *seachFiled;

@property (nonatomic, weak) id<HLHJNewDetailCommonToolViewDelegate>  delegate;

@end
