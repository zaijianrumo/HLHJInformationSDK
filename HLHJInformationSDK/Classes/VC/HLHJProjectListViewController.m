//
//  HLHJProjectListViewController.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJProjectListViewController.h"
#import "HLHJNewProjectListCell.h"

#import "HLHJNewsDetailViewController.h"
#import "HLHJContentModel.h"
@interface HLHJProjectListViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (nonatomic, strong) UITableView  *tableView;
@property (nonatomic, strong) NSMutableArray  *dataArray;
@property (nonatomic, copy) NSString  *cover_img;
@end

@implementation HLHJProjectListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    
    }];
    
    MJWeakSelf;
    ///NOTE5:下拉刷新加载列表数据
    self.tableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
            [weakSelf getSubjectNameList];
    }];
    [self.tableView.mj_header beginRefreshing];
    

}
- (void)getSubjectNameList {
    
    MJWeakSelf;
    [HLHJInfomationNetWorkTool hlhjRequestWithType:GET requestUrl:@"/HLHJ_news/Api/subjectList" parameter:@{@"id":_ID} successComplete:^(id  _Nullable responseObject) {
        
        if ([weakSelf.tableView.mj_header isRefreshing]) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
        [weakSelf.dataArray removeAllObjects];
        NSArray *subTitleArr = [NSArray yy_modelArrayWithClass:[HLHJContentModel class] json:responseObject[@"data"][@"list"]];
        [weakSelf.dataArray addObjectsFromArray:subTitleArr];
        
        weakSelf.navigationItem.title = responseObject[@"data"][@"name"];
        weakSelf.cover_img = responseObject[@"data"][@"cover_img"];
        [weakSelf.tableView reloadData];
        
    } failureComplete:^(NSError * _Nonnull error) {
        if ([weakSelf.tableView.mj_header isRefreshing]) {
            [weakSelf.tableView.mj_header endRefreshing];
        }
    }];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count+1;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 167;
    }
    return  110;
    
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
        if (!cell) {
            cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"UITableViewCell"];
        }
        UIImageView *imgView = [UIImageView new];
        imgView.contentMode = UIViewContentModeScaleToFill;
        imgView.clipsToBounds = YES;
        NSString *url = @"";
        if ([self.cover_img containsString:@"://"]) {
            url = self.cover_img;
        }else {
            url = [NSString stringWithFormat:@"%@%@",BASE_URL,self.cover_img];
        }
        
        [imgView sd_setImageWithURL:[NSURL URLWithString: url]];
        imgView.frame = cell.contentView.frame;
        [cell addSubview:imgView];
        return  cell;
        
    }
    HLHJNewProjectListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJNewProjectListCell"];
    cell.model = self.dataArray[indexPath.row-1];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
   
    if (indexPath.row == 0) return;
    
     HLHJContentModel *model =  self.dataArray[indexPath.row-1];
    
     model.click_rate += 1;
    
    [self.dataArray replaceObjectAtIndex:indexPath.row-1 withObject:model];
    
    NSIndexPath *indexSet = [NSIndexPath indexPathForRow:indexPath.row inSection:0];
    
    [self.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexSet,nil] withRowAnimation:UITableViewRowAnimationAutomatic];

    if (model.type == 1) {
        HLHJNewsDetailViewController *detil = [HLHJNewsDetailViewController new];
        
        NSString * article_id= model.ID;
        NSString * thumbUrl = model.extract_img.count > 0 ? model.extract_img[0]:@"https://timgsa.baidu.com/timg?image&quality=80&size=b9999_10000&sec=1531470814752&di=49e3232f35fa9c8439160a2d071bf1cb&imgtype=0&src=http%3A%2F%2Fimg382.ph.126.net%2Fp4dMCiiHoUGxf2N0VLspkg%3D%3D%2F37436171903673954.jpg";
        
        NSDictionary *dict= @{@"article_id":article_id,@"thumb":thumbUrl};
        detil.paramStr = [dict yy_modelToJSONString];
        detil.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:detil animated:YES];
    }else  if (model.type == 4){
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:model.advertisement_url]];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}
- (NSMutableArray *)dataArray {
    
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}
#pragma lazy
- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        [_tableView registerClass:[HLHJNewProjectListCell class] forCellReuseIdentifier:@"HLHJNewProjectListCell"];
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 125;
    }
    return _tableView;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
