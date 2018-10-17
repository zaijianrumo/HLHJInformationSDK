//
//  HLHJNewsCommentTableCell.h
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "HLHJNewsConmmetModel.h"


@protocol HLHJNewsCommentTableViewCelllDelegate<NSObject>

@optional
- (void)giveLikeBtnAction:(UIButton *)sender;

@end


@interface HLHJNewsCommentTableCell : UITableViewCell

@property (nonatomic, strong) HLHJNewsConmmetModel  *model;

@property (nonatomic, strong) UIButton  *giveLikeBtn;

@property (nonatomic, weak) id<HLHJNewsCommentTableViewCelllDelegate>  delegate;

@end
