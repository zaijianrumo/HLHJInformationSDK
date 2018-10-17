//
//  HLHJNewsSearchViewController.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/26.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewsSearchViewController.h"

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
#import "UIScrollView+EmptyDataSet.h"
#import "HLHJNewsToast.h"


#import "HLHJPhotoBrowser.h"

#import "HLHJNewsDetailViewController.h"
#import "HLHJContentModel.h"




@interface HLHJNewsSearchViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource,HLHJRecommendTwoTableViewCellDelegate,HLHJPhotoBrowserDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate>

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
/**评论输入框**/
@property (nonatomic, strong) UITextField  *textFiled;

@end

@implementation HLHJNewsSearchViewController

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    [self.textFiled resignFirstResponder];
  
    @weakify(self)
    [self.tableView zf_filterShouldPlayCellWhileScrolled:^(NSIndexPath *indexPath) {
        @strongify(self)
        [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
    }];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
     self.edgesForExtendedLayout = UIRectEdgeNone;
    
    [self.view addSubview:self.tableView];
    [self.tableView  mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.top.equalTo(self.view);
    }];
    
    
    [self initNavUI];
    ///NOTE7:视频设置
    [self videoInitUI];

}


- (void)initNavUI{
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button addTarget:self action:@selector(searchActon) forControlEvents:UIControlEventTouchUpInside];
    [button setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/ic_sy_shousuo"] forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, 380, 30)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = @" 搜索你感兴趣的";
    textField.layer.cornerRadius = 6;
    textField.clipsToBounds = YES;
    textField.returnKeyType = UIReturnKeySearch;//变为搜索按钮
    textField.delegate = self;//设置代理
    textField.font = [UIFont systemFontOfSize:14];
    _textFiled = textField;
    self.navigationItem.titleView  = textField;

    
    UIView *leftView = [UIView new];
    leftView.frame = CGRectMake(0, 0, 30, 30);
    textField.leftViewMode = UITextFieldViewModeAlways;
    textField.leftView = leftView;
    
    UIImageView *imgView  = [[UIImageView alloc]init];
    imgView.frame = CGRectMake(5, 5, 20, 20);
    imgView.image = [UIImage imageNamed:@"HLHJImageResources.bundle/ic_sy_shousuo1"];
    [leftView addSubview:imgView];
   
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

 
}
-(void)searchActon{
    if (self.textFiled.text.length == 0) {
       [HLHJNewsToast hsShowBottomWithText:@"请输入搜索内容"];
        return;
    }
    
    [_textFiled resignFirstResponder];
    [self.tableView.mj_header beginRefreshing];
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_textFiled resignFirstResponder];
    [self.tableView.mj_header beginRefreshing];
    return YES;
}

- (void)videoInitUI{
    /// playerManager
    self.playerManager = [[ZFAVPlayerManager alloc] init];
    
    /// player,tag值必须在cell里设置
    self.player = [ZFPlayerController playerWithScrollView:self.tableView playerManager:self.playerManager containerViewTag:100];
    self.player.controlView = self.controlView;
    self.player.shouldAutoPlay = NO;
    
    
    @weakify(self)
    self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {
        @strongify(self)
        [self setNeedsStatusBarAppearanceUpdate];
        self.tableView.scrollsToTop = !isFullScreen;
    };
    
    self.player.playerDidToEnd = ^(id  _Nonnull asset) {
        @strongify(self)
        if (self.player.playingIndexPath.row < self.urlsArr.count - 1 && !self.player.isFullScreen) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.player.playingIndexPath.row+1 inSection:0];
            [self playTheVideoAtIndexPath:indexPath scrollToTop:YES];
        } else if (self.player.isFullScreen) {
            [self.player enterFullScreen:NO animated:YES];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(self.player.orientationObserver.duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self.player stopCurrentPlayingCell];
            });
        }
    };
    
    
}
#pragma mark 加载数据
- (void)getDataSourcePage:(NSInteger)page {
    
    NSDictionary *prama = @{@"page":@(page),
                            @"keyword":_textFiled.text.length > 0 ? _textFiled.text:@""
                            };
    __weak typeof(self) weakSelf = self;
    [HLHJInfomationNetWorkTool hlhjRequestWithType:POST requestUrl:@"/HLHJ_news/api/search_list" parameter:prama successComplete:^(id  _Nullable responseObject) {
        if (self.page == 1 && self.dataArray) {
            [self.dataArray removeAllObjects];
        }
        [weakSelf endRefreshing];
        NSArray *arr = [NSArray yy_modelArrayWithClass:[HLHJContentModel class] json:responseObject[@"data"][@"list"]];
        if (arr.count > 0) {
            [self.dataArray addObjectsFromArray:arr];
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
        [self.tableView reloadData];
        
    } failureComplete:^(NSError * _Nonnull error) {
        [weakSelf endRefreshing];
    }];
    
}
- (void)endRefreshing {
    
    if ([_textFiled isFirstResponder]) {
        [_textFiled resignFirstResponder];
    }
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
        return cell;
        
    } else if (model.type == 5) { //轮播图
        
        NSMutableArray *bannerArr = [NSMutableArray array];
        for (HLHJData_imgModel *imgModel in model.data_img) {
            [bannerArr addObject:imgModel.cover_img];
        }
        HLHJRecommendFiveTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJRecommendFiveTableViewCell"];
        cell.cycleScrollView.imageURLStringsGroup  = bannerArr;
        return cell;
        
    }  else if (model.type == 6){ //专题
        if (indexPath.row == 0) {
            HLHJRecommendSix1TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJRecommendSix1TableViewCell"];
            HLHJSubjectModel *model1 =model.subject[0];
            HLHJSubjectModel *model2 =model.subject[1];
            [cell.leftBtn setTitle:model1.subject_name forState:UIControlStateNormal];
            [cell.rightBtn setTitle:model2.subject_name forState:UIControlStateNormal];
            return cell;
        }
        HLHJRecommendSix2TableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJRecommendSix2TableViewCell"];
        HLHJSubjectListModel *listModel = model.subjectList[indexPath.row-1];
        cell.listModel = listModel;
        return cell;
        
    }else { ////文章/广告
        
        HLHJRecommendOneTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJRecommendOneTableViewCell"];
        cell.model = model;
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
        NSString *article_id = model.ID;
        NSString *thumbUrl = model.extract_img.count > 0 ? model.extract_img[0]:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531470814752&di=49e3232f35fa9c8439160a2d071bf1cb&imgtype=0&src=http%3A%2F%2Fimg382.ph.126.net%2Fp4dMCiiHoUGxf2N0VLspkg%3D%3D%2F37436171903673954.jpg";
        
        NSDictionary *dict= @{@"article_id":article_id,@"thumb":thumbUrl};
        detil.paramStr = [dict yy_modelToJSONString];
        detil.hidesBottomBarWhenPushed = YES;
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
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}
- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return nil;
}
- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return nil;
}

// 返回高质量图片的url
- (NSURL *)photoBrowser:(HLHJPhotoBrowser *)browser highQualityImageURLForIndex:(NSInteger)index {
    
    return [NSURL URLWithString:self.atlssArr[index]];
}

#pragma mark - ZFTableViewCellDelegate

- (void)zf_playTheVideoAtIndexPath:(NSIndexPath *)indexPath {
    [self playTheVideoAtIndexPath:indexPath scrollToTop:NO];
}
/// play the video
- (void)playTheVideoAtIndexPath:(NSIndexPath *)indexPath scrollToTop:(BOOL)scrollToTop {
    [self.player playTheIndexPath:indexPath scrollToTop:scrollToTop];
    HLHJContentModel *model = self.dataArray[indexPath.section];
    [self.controlView showTitle:model.title
                 coverURLString:model.video_cover
                 fullScreenMode:ZFFullScreenModePortrait];
}
#pragma mark  DZNEmptyDataSetDelegate
- (UIImage *)imageForEmptyDataSet:(UIScrollView *)scrollView {
    return [UIImage imageNamed:@"HLHJImageResources.bundle/ic-wushuju"];
}
- (NSAttributedString *)descriptionForEmptyDataSet:(UIScrollView *)scrollView {
    NSString *text = @"没有数据哦,搜一下试试";
    
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
- (void)emptyDataSetWillAppear:(UIScrollView *)scrollView {
       scrollView.contentOffset = CGPointZero;
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
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
  
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
        _tableView.emptyDataSetSource = self;
        _tableView.emptyDataSetDelegate = self;
        
        _tableView.estimatedRowHeight = 100;
        _tableView.rowHeight = UITableViewAutomaticDimension;
        _tableView.tableFooterView = [UIView new];
      
        if (@available(iOS 11.0, *)) {
            _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        } else {
            self.automaticallyAdjustsScrollViewInsets = NO;
        }
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

- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
    }
    return _controlView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
