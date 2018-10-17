//
//  HLHJRecommendedViewController.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/5.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJRecommendedViewController.h"

#import "HLHJProjectListViewController.h"
#import "SDCycleScrollView.h"
#import "UIScrollView+EmptyDataSet.h"

#import "HLHJRecommendOneTableViewCell.h"
#import "HLHJRecommendTwoTableViewCell.h"
#import "HLHJRecommendThreeTableViewCell.h"
#import "HLHJRecommendFiveTableViewCell.h"
#import "HLHJRecommendSix1TableViewCell.h"
#import "HLHJRecommendSix2TableViewCell.h"

///视频播放
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"

#import "HLHJPhotoBrowser.h"

#import "HLHJNewsDetailViewController.h"
#import "HLHJContentModel.h"
#import <TMShare/TMShare.h>


@interface HLHJRecommendedViewController ()<UITableViewDelegate,UITableViewDataSource,HLHJRecommendTwoTableViewCellDelegate,HLHJPhotoBrowserDelegate,SDCycleScrollViewDelegate,DZNEmptyDataSetDelegate,DZNEmptyDataSetSource,HLHJRecommendThreeTableViewCellDelegate,HLHJRecommendOneTableViewCellDelegate>

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) NSMutableArray  *dataArray;

@property (nonatomic, assign) NSInteger  page;

@property (nonatomic, strong) ZFPlayerController *player;

@property (nonatomic, strong) ZFPlayerControlView *controlView;

@property (nonatomic, strong) ZFAVPlayerManager *playerManager;

///视频URL
@property (nonatomic, strong) NSMutableArray *urlsArr;
///图集URL
@property (nonatomic, strong) NSMutableArray *atlssArr;
///轮播
@property (nonatomic, strong) NSMutableArray *brannerArr;
@end

@implementation HLHJRecommendedViewController
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    @weakify(self)
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
   
    }];
}
- (void)dealloc {
    [self.player removeDeviceOrientationObserver];
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.player stop];
    [self.player stopCurrentPlayingCell];
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.view addSubview:self.tableView];
    
    [self.tableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    MJWeakSelf;
    ///NOTE5:下拉刷新加载列表数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.page = 1;
        [weakSelf getDataSourcePage:weakSelf.page];
        
    }];
    ///NOTE6:上拉刷新加载列表数据
    self.tableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.page ++;
        [weakSelf getDataSourcePage:weakSelf.page];
    }];
    
    [self.tableView.mj_header beginRefreshing];
    
    ///NOTE7:视频设置
    [self videoInitUI];
    
}

- (void)videoInitUI{
    /// playerManager
    self.playerManager = [[ZFAVPlayerManager alloc] init];
 
    /// player,tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:self.playerManager containerViewTag:100];
    self.player.controlView = self.controlView;
    self.player.shouldAutoPlay = NO;
    self.player.pauseWhenAppResignActive = YES;
    self.player.statusBarHidden = YES;
    self.player.orientationObserver.allowOrentitaionRotation = NO;
    /// 移动网络依然自动播放
    self.player.WWANAutoPlay = YES;
    

    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        [UIViewController attemptRotationToDeviceOrientation];
        self.tableView.scrollsToTop = !isFullScreen;
    };
    
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
//        if (self.player.playingIndexPath.row < self.urlsArr.count - 1 && !self.player.isFullScreen) {
//            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.playingIndexPath.row+1 inSection:0];
//            [self playTheVideoAtIndexPath:indexPath scrollToTop:YES];
//        } else
            if (self.player.isFullScreen) {
            [self.player enterFullScreen:NO animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.player.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.player stopCurrentPlayingCell];
            });
        }else {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.player.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.player stopCurrentPlayingCell];
            });
        }
    };
    
}
- (BOOL)shouldAutorotate {
    return self.player.shouldAutorotate;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    if (self.player.isFullScreen && self.player.orientationObserver.fullScreenMode == ZFFullScreenModeLandscape) {
        return UIInterfaceOrientationMaskLandscape;
    }
    return UIInterfaceOrientationMaskPortrait;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.player.isFullScreen) {
        return UIStatusBarStyleLightContent;
    }
    return UIStatusBarStyleDefault;
}

- (BOOL)prefersStatusBarHidden {
     return self.player.isStatusBarHidden;
}

- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationSlide;
}

#pragma mark 加载数据
- (void)getDataSourcePage:(NSInteger)page {
    
    NSDictionary *prama = @{@"page":[@(page) stringValue],
                            @"id":_categoryID.length > 0 ? _categoryID :@""
                            };
    __weak typeof(self) weakSelf = self;
    [HLHJInfomationNetWorkTool hlhjRequestWithType:GET requestUrl:@"/HLHJ_news/api/category_list" parameter:prama successComplete:^(id  _Nullable responseObject) {
        if (self.page == 1 && self.dataArray) {
            [self.dataArray removeAllObjects];
        }
        weakSelf.tableView.emptyDataSetDelegate = weakSelf;
        weakSelf.tableView.emptyDataSetSource = weakSelf;
        
        [weakSelf endRefreshing];
        NSDictionary *dict = responseObject[@"data"];
        
        if (![dict isKindOfClass:[NSNull class]] ) {
            NSArray *arr = [NSArray yy_modelArrayWithClass:[HLHJContentModel class] json:responseObject[@"data"][@"list"]];
            
            if (arr.count > 0) {
                [weakSelf.dataArray addObjectsFromArray:arr];
                [weakSelf.tableView.mj_footer resetNoMoreData];
                
            }else {
                /// 变为没有更多数据的状态
                [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
            }
            
            for (HLHJContentModel *model in weakSelf.dataArray) {
                if (model.type == 2) {
                    [weakSelf.urlsArr addObject:[NSURL URLWithString:model.video_url]];
                }
            }
            weakSelf.player.assetURLs = weakSelf.urlsArr;
        }else {
            /// 变为没有更多数据的状态
            [weakSelf.tableView.mj_footer endRefreshingWithNoMoreData];
        }
    
        [weakSelf.tableView reloadData];
        
    } failureComplete:^(NSError * _Nonnull error) {
        [weakSelf endRefreshing];
    }];
    
}
- (void)endRefreshing {
    if ([self.tableView.mj_header isRefreshing]) {
        [self.tableView.mj_header endRefreshing];
    }
    if ([self.tableView.mj_footer isRefreshing]) {
        [self.tableView.mj_footer endRefreshing];
    }
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
     return self.dataArray ? self.dataArray.count:0;;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    HLHJContentModel *model = self.dataArray[section];
    return model.type == 6 ?model.subjectList.count+1:1;
   
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    HLHJContentModel *model = self.dataArray[indexPath.section];
    
    
    if (model.type == 2){ //视频
        
            HLHJRecommendTwoTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJRecommendTwoTableViewCell"];
            [cell setDelegate:self withIndexPath:indexPath];
            cell.model = model;
        
            return cell;
        
    }else if(model.type == 3){ //图集
        
        HLHJRecommendThreeTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJRecommendThreeTableViewCell"];
        cell.model = model;
        cell.delegate = self;
        return cell;
        
    } else if (model.type == 5) { //轮播图
        
        NSMutableArray *bannerArr = [NSMutableArray array];
        NSMutableArray *titleArr = [NSMutableArray array];
        for (HLHJData_imgModel *imgModel in model.data_img) {
            NSString *url  = @"";
            if ([imgModel.cover_img containsString:@"http"]) {
                url = imgModel.cover_img;
            }else {
                url = [NSString stringWithFormat:@"%@%@",BASE_URL,imgModel.cover_img ? imgModel.cover_img:@""];
            }
            [bannerArr addObject:url];
            [titleArr addObject:imgModel.title?imgModel.title:@""];
        }
        [self.brannerArr addObjectsFromArray:model.data_img];
        HLHJRecommendFiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJRecommendFiveTableViewCell"];
        cell.cycleScrollView.imageURLStringsGroup  = bannerArr;
        cell.cycleScrollView.titlesGroup = titleArr;
        cell.cycleScrollView.delegate  = self;
        return cell;
        
    }  else if (model.type == 6){ //专题
        if (indexPath.row == 0) {
            
            HLHJRecommendSix1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJRecommendSix1TableViewCell"];
            HLHJSubjectModel *model1 =model.subject[0];
            HLHJSubjectModel *model2 =model.subject[1];
            
            cell.leftBtn.tag = [model1.ID integerValue];
            cell.rightBtn.tag = [model2.ID integerValue];
            
            [cell.leftBtn setTitle:model1.subject_name forState:UIControlStateNormal];
            [cell.rightBtn setTitle:model2.subject_name forState:UIControlStateNormal];
            [cell.leftBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
            [cell.rightBtn addTarget:self action:@selector(btnAction:) forControlEvents:UIControlEventTouchUpInside];
        
            return cell;
        }
          HLHJRecommendSix2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJRecommendSix2TableViewCell"];
          HLHJSubjectListModel *listModel = model.subjectList[indexPath.row-1];
          cell.listModel = listModel;
          return cell;
        
    }else { ////文章/广告
        
        HLHJRecommendOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJRecommendOneTableViewCell"];
        cell.model = model;
        cell.delegate = self;
        return cell;
    }
 
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    HLHJContentModel *model = self.dataArray[indexPath.section];
    model.click_rate += 1;
    [self.dataArray replaceObjectAtIndex:indexPath.section withObject:model];
    //1.传入要刷新的组数
    NSIndexSet *indexSet=[[NSIndexSet alloc] initWithIndex:indexPath.section];
    //2.传入NSIndexSet进行刷新
    [self.tableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
    
     if (model.type == 1){
         
        HLHJNewsDetailViewController *detil = [HLHJNewsDetailViewController new];
         detil.hidesBottomBarWhenPushed  = YES;
         NSString * article_id = model.ID;
         NSString *thumbUrl = model.extract_img.count > 0 ? model.extract_img[0]:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531470814752&di=49e3232f35fa9c8439160a2d071bf1cb&imgtype=0&src=http%3A%2F%2Fimg382.ph.126.net%2Fp4dMCiiHoUGxf2N0VLspkg%3D%3D%2F37436171903673954.jpg";
         
         NSDictionary *dict= @{@"article_id":article_id,@"thumb":thumbUrl};
         detil.paramStr = [dict yy_modelToJSONString];
        [self.navigationController pushViewController:detil animated:YES];
         
    }else if (model.type == 2){

        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    
    }else  if (model.type == 3) {
        
        [self.atlssArr removeAllObjects];
        
        HLHJPhotoBrowser *photoBrowser = [HLHJPhotoBrowser new];
        
        photoBrowser.delegate = self;
        
        photoBrowser.currentImageIndex = indexPath.row;
        
        photoBrowser.imageCount = model.atlas_img.count;
        
        photoBrowser.imgDes = model.content;
        
        photoBrowser.sourceImagesContainerView = self.tableView;
        
        [self.atlssArr addObjectsFromArray:model.atlas_img];
        
        [photoBrowser show];
        
    }else if (model.type == 4){
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.advertisement_url]];
        
    }else if (model.type == 6){
        
        if(indexPath.row == 0) return;
        
        HLHJProjectListViewController *list = [HLHJProjectListViewController new];
        HLHJSubjectListModel *smodel =  model.subjectList[indexPath.row-1];
        list.ID = smodel.ID;
        list.hidesBottomBarWhenPushed  = YES;
        [self.navigationController pushViewController:list animated:YES]; 
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}
#pragma mark  SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    HLHJData_imgModel *model = self.brannerArr[index];
    HLHJNewsDetailViewController *detil = [HLHJNewsDetailViewController new];
    detil.hidesBottomBarWhenPushed  = YES;
    NSString * article_id= model.ID;
    NSString *thumbUrl = model.cover_img;
    NSDictionary *dict= @{@"article_id":article_id,@"thumb":thumbUrl};
    detil.paramStr = [dict yy_modelToJSONString];
    [self.navigationController pushViewController:detil animated:YES];
}

#pragma mark  HLHJPhotoBrowserDelegate
// 返回高质量图片的url
- (NSURL *)photoBrowser:(HLHJPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {

    return [NSURL URLWithString:self.atlssArr[index]];
}

- (void)btnAction:(UIButton *)sender {
    HLHJProjectListViewController *list = [HLHJProjectListViewController new];
    list.ID = [@(sender.tag) stringValue];
    list.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:list animated:YES];
}

#pragma mark - ZFTableViewCellDelegate
///图集分享
- (void)shareAction:(HLHJContentModel *)model {
   
    TMShareConfig *config = [[TMShareConfig alloc] initWithTMBaseConfig];
    [[TMShareInstance instance] configWith:config];
    
   NSString *url = [NSString stringWithFormat:@"%@/application/hlhj_news/asset/atlas.html?id=%@",[TMEngineConfig instance].domain,model.ID];
    [[TMShareInstance instance]showShare:url thumbUrl:model.atlas_img.count > 0 ? model.atlas_img[0]:@"https://www.baidu.com/img/bd_logo1.png" title:model.title?model.title:@"" descr:model.title?model.title:@"" currentController:self finish:nil];
    
}
///视频分享
-(void)zf_shareAction:(HLHJContentModel *)model {
    
    TMShareConfig *config = [[TMShareConfig alloc] initWithTMBaseConfig];
    [[TMShareInstance instance] configWith:config];
    
    NSString *url = [NSString stringWithFormat:@"%@/application/hlhj_news/asset/article.html?id=%@", [TMEngineConfig instance].domain,model.ID];
    [[TMShareInstance instance]showShare:url thumbUrl:model.video_cover.length > 0 ?model.video_cover:@"https://www.baidu.com/img/bd_logo1.png" title:model.title?model.title:@"" descr:model.title?model.title:@"" currentController:self finish:nil];
    
}

-(void)articleShareAction:(HLHJContentModel *)model {
    
    TMShareConfig *config = [[TMShareConfig alloc] initWithTMBaseConfig];
    [[TMShareInstance instance] configWith:config];
    NSString *url = [NSString stringWithFormat:@"%@/application/hlhj_news/asset/article.html?id=%@",[TMEngineConfig instance].domain,model.ID];
    [[TMShareInstance instance]showShare:url thumbUrl:model.extract_img.count > 0 ?model.extract_img[0]:@"https://www.baidu.com/img/bd_logo1.png" title:model.title?model.title:@"" descr:model.title?model.title:@"" currentController:self finish:nil];
    
}

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];

}

/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    HLHJContentModel *model = self.dataArray[indexPath.section];
    [self.controlView showTitle:model.title
                 coverURLString:model.video_cover
                 fullScreenMode:ZFFullScreenModeLandscape];
}
#pragma mark  DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    
    return [UIImage imageNamed:@"HLHJImageResources.bundle/ic-wushuju"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"暂无相关内容";
    
    NSMutableParagraphStyle *paragraph = [NSMutableParagraphStyle new];
    paragraph.lineBreakMode = NSLineBreakByWordWrapping;
    paragraph.alignment = NSTextAlignmentCenter;
    
    NSDictionary *attributes = @{
                                 NSFontAttributeName:[UIFont systemFontOfSize:14.0f],
                                 NSForegroundColorAttributeName:[UIColor lightGrayColor],
                                 NSParagraphStyleAttributeName:paragraph
                                 };
    
    return [[NSAttributedString alloc] initWithString:text attributes:attributes];
}

#pragma lazy
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
        ///文章、广告
        [_tableView registerClass:[HLHJRecommendOneTableViewCell class] forCellReuseIdentifier:@"HLHJRecommendOneTableViewCell"];
        ///视频
        [_tableView registerClass:[HLHJRecommendTwoTableViewCell class] forCellReuseIdentifier:@"HLHJRecommendTwoTableViewCell"];
        ///图集
        [_tableView registerClass:[HLHJRecommendThreeTableViewCell class] forCellReuseIdentifier:@"HLHJRecommendThreeTableViewCell"];
        ///轮播图
        [_tableView registerClass:[HLHJRecommendFiveTableViewCell class] forCellReuseIdentifier:@"HLHJRecommendFiveTableViewCell"];
        ///市长、书记 活动集
        [_tableView registerClass:[HLHJRecommendSix1TableViewCell class] forCellReuseIdentifier:@"HLHJRecommendSix1TableViewCell"];
        ///专题
        [_tableView registerClass:[HLHJRecommendSix2TableViewCell class] forCellReuseIdentifier:@"HLHJRecommendSix2TableViewCell"];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.tableFooterView = [UIView new];
        _tableView.rowHeight = UITableViewAutomaticDimension;
        
        /// 停止的时候找出最合适的播放
        @weakify(self)
        _tableView.scrollViewDidStopScroll = ^(NSIndexPath * _Nonnull indexPath) {
            @strongify(self)
            [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
        };
        
    }
    return _tableView;
}
- (NSMutableArray *)urlsArr {
    if (!_urlsArr) {
        _urlsArr = [NSMutableArray array];
    }
    return _urlsArr;
}
- (NSMutableArray *)atlssArr {
    if (!_atlssArr) {
        _atlssArr = [NSMutableArray array];
    }
    return _atlssArr;
}
- (NSMutableArray *)brannerArr {
    if (!_brannerArr) {
        _brannerArr = [NSMutableArray array];
    }
    return _brannerArr;
}

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
    }
    return _controlView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}
@end
