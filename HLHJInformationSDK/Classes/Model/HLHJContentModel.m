//
//  HLHJContentModel.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJContentModel.h"

@implementation HLHJContentModel
+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"author" :@"release",@"subjectList":@"list",@"ID":@"id"};
}
+ (NSDictionary *)modelContainerPropertyGenericClass {
    
    return @{@"data_img":[HLHJData_imgModel class],@"subject":[HLHJSubjectModel class],@"subjectList":[HLHJSubjectListModel class]};
}
@end

@implementation HLHJData_imgModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" :@"id"};
}
@end

@implementation HLHJSubjectModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" :@"id"};
}
@end
@implementation HLHJSubjectListModel

+ (NSDictionary *)modelCustomPropertyMapper {
    return @{@"ID" :@"id",@"author" :@"release"};
}
@end


