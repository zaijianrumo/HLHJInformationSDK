//
//  HLHJNewsDetilModel.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewsDetilModel.h"

@implementation HLHJNewsDetilModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" :@"id",@"author" :@"release"};
}
@end
