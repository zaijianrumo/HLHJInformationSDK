//
//  HLHJCategoryNameModel.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJCategoryNameModel.h"

@implementation HLHJCategoryNameModel
+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"defaults" :@"default"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"defaults":[HLHJDefaultModel class],@"all":[HLHJAllModel class]};
}

@end

@implementation HLHJDefaultModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"ID" :@"id"};
}
@end


@implementation HLHJAllModel

+ (NSDictionary *)modelCustomPropertyMapper {
    
    return @{@"ID" :@"id"};
}
@end

