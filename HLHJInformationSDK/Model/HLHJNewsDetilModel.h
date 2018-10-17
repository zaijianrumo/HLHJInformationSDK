//
//  HLHJNewsDetilModel.h
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface HLHJNewsDetilModel : NSObject

@property (nonatomic, copy) NSString  *ID;
@property (nonatomic, copy) NSString  *category_id;
@property (nonatomic, copy) NSString  *subject_id;
@property (nonatomic, copy) NSString  *type;
@property (nonatomic, copy) NSString  *title;
@property (nonatomic, copy) NSString  *extract;
@property (nonatomic, copy) NSString  *extract_img;
@property (nonatomic, copy) NSString  *content;
@property (nonatomic, copy) NSString  *is_top;
@property (nonatomic, copy) NSString  *is_hot;
@property (nonatomic, copy) NSString  *is_banner;
@property (nonatomic, copy) NSString  *tag;
@property (nonatomic, assign) NSInteger  click_rate;
@property (nonatomic, copy) NSString  *author;
@property (nonatomic, copy) NSString  *video_url;
@property (nonatomic, copy) NSString  *atlas_img;
@property (nonatomic, copy) NSString  *advertisement_img;
@property (nonatomic, copy) NSString  *advertisement_url;
@property (nonatomic, copy) NSString  *advertiser;
@property (nonatomic, copy) NSString  *start_time;
@property (nonatomic, copy) NSString  *end_time;
@property (nonatomic, copy) NSString  *add_time;
@property (nonatomic, copy) NSString  *up_time;
@property (nonatomic, copy) NSString  *is_delete;

@end
