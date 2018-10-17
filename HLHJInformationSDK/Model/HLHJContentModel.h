//
//  HLHJContentModel.h
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/25.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>


@class HLHJData_imgModel,HLHJSubjectModel,HLHJSubjectListModel;

@interface HLHJContentModel : NSObject

@property (nonatomic, copy) NSString  *ID;
//1文章 2视频 3图集 4广告 5轮播图 6专题
@property (nonatomic, assign) NSInteger  type;

@property (nonatomic, copy) NSString  *category_id;

@property (nonatomic, copy) NSString  *subject_id;

@property (nonatomic, copy) NSString  *title;

@property (nonatomic, strong) NSArray  *extract_img;

@property (nonatomic, copy) NSString  *content;

@property (nonatomic, copy) NSString  *is_top;

@property (nonatomic, copy) NSString  *is_hot;

@property (nonatomic, assign) NSInteger  click_rate;

@property (nonatomic, copy) NSString  *author;

@property (nonatomic, copy) NSString  *video_cover;

@property (nonatomic, copy) NSString  *video_url;

@property (nonatomic, strong) NSArray  *atlas_img;

@property (nonatomic, strong) NSArray  *advertisement_img;

@property (nonatomic, copy) NSString  *advertisement_url;

@property (nonatomic, copy) NSString  *advertiser;

@property (nonatomic, copy) NSString  *add_time;
///轮播图
@property (nonatomic,strong) NSArray<HLHJData_imgModel *>  *data_img;
///专题(测试数据为：书记专题，和市长专题)
@property (nonatomic,strong) NSArray<HLHJSubjectModel *>   *subject;
///专题列表
@property (nonatomic,strong) NSArray<HLHJSubjectListModel *>   *subjectList;

@end


///轮播图
@interface HLHJData_imgModel:NSObject

@property (nonatomic, copy) NSString  *ID;
@property (nonatomic, copy) NSString  *cover_img;
@property (nonatomic, copy) NSString  *title;

@end

///专题
@interface HLHJSubjectModel:NSObject

@property (nonatomic, copy) NSString  *ID;
@property (nonatomic, copy) NSString  *subject_name;
@property (nonatomic, copy) NSString  *is_show;
@property (nonatomic, copy) NSString  *add_time;
@end

///专题列表
@interface HLHJSubjectListModel:NSObject

@property (nonatomic, copy) NSString  *ID;
@property (nonatomic, copy) NSString  *subject_name;
@property (nonatomic, copy) NSString  *cover_img;
@property (nonatomic, copy) NSString  *explain;
@property (nonatomic, copy) NSString  *author;
@property (nonatomic, copy) NSString  *is_top;
@property (nonatomic, assign) NSInteger  is_hot;
@property (nonatomic, assign) NSInteger  click_rate;
@property (nonatomic, copy) NSString  *add_time;

@end

