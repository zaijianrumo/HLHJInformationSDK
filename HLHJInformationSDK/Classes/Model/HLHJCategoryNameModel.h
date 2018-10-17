//
//  HLHJCategoryNameModel.h
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HLHJDefaultModel,HLHJAllModel;

@interface HLHJCategoryNameModel : NSObject


@property (nonatomic, strong) NSArray<HLHJDefaultModel *>  * defaults;

@property (nonatomic, strong) NSArray<HLHJAllModel *>  *all;

@end

@interface HLHJDefaultModel : NSObject


@property (nonatomic, copy) NSString  *ID;
@property (nonatomic, copy) NSString  *category_name;
@property (nonatomic, copy) NSString  *is_top;
@property (nonatomic, copy) NSString  *add_time;
@property (nonatomic, copy) NSString  *is_must;
@property (nonatomic, copy) NSString  *is_default;
@property (nonatomic, copy) NSString  *is_delete;

@end
@interface HLHJAllModel : NSObject


@property (nonatomic, copy) NSString  *ID;
@property (nonatomic, copy) NSString  *category_name;
@end
