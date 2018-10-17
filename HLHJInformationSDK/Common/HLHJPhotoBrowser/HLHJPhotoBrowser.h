//
//  SDPhotoBrowser.h
//  photobrowser
//
//  Created by aier on 15-2-3.
//  Copyright (c) 2015年 aier. All rights reserved.
//

#import <UIKit/UIKit.h>


@class SDButton, HLHJPhotoBrowser;

@protocol HLHJPhotoBrowserDelegate <NSObject>

@required

- (UIImage *)photoBrowser:(HLHJPhotoBrowser *)browser placeholderImageForIndex:(NSInteger)index;

@optional

- (NSURL *)photoBrowser:(HLHJPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index;

@end


@interface HLHJPhotoBrowser : UIView <UIScrollViewDelegate>

@property (nonatomic, weak) UIView *sourceImagesContainerView;
@property (nonatomic, assign) NSInteger currentImageIndex;
@property (nonatomic, assign) NSInteger imageCount;

///图片描述(目前只有一个字段)
@property (nonatomic, copy) NSString *imgDes;


@property (nonatomic, weak) id<HLHJPhotoBrowserDelegate> delegate;

- (void)show;

@end
