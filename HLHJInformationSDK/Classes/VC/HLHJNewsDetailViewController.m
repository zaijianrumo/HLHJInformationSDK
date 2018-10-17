//
//  HLHJProjectDetailViewController.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/12.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewsDetailViewController.h"

#import "HLHJNewsDetilModel.h"
#import "HLHJNewsConmmetModel.h"

#import "HLHJArticleDetailTableViewCell.h"
#import "HLHJMoreTableViewCell.h"
#import "HLHJNewsCommentTableCell.h"
#import "HLHJNewDetailSectionOneCell.h"

#import "HLHJNewDetailCommonToolView.h"

#import "HLHJMoreCommentViewController.h"


#import <SetI001/SetI001LoginViewController.h>
#import <TMSDK/TMHttpUserInstance.h>
#import <TMSDK/TMHttpUser.h>
#import <TMShare/TMShare.h>
#import "HLHJNewsToast.h"
#import "SVProgressHUD.h"

@interface HLHJNewsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HLHJNewDetailCommonToolViewDelegate,UITextFieldDelegate,HLHJNewsCommentTableViewCelllDelegate>

@property (nonatomic, strong) HLHJNewsDetilModel  *detilModel;

@property (nonatomic, strong) HLHJNewDetailCommonToolView  *commonToolView;

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong)NSMutableArray  *commentArr;

@property (nonatomic, assign) NSInteger  star_id; ///文章收藏的ID
///文章ID
@property (nonatomic, copy) NSString  *article_id;
//分享的图片
@property (nonatomic, copy) NSString  *thumbUrl;

@property (nonatomic, strong) NSDictionary  *parma;

@end

@implementation HLHJNewsDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([TMHttpUser token].length > 0) {
           [self querrCollection];
    }
}
- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [SVProgressHUD dismiss];
    
}
- (void)viewDidLoad {
    [super viewDidLoad];

    
    NSDictionary *dict = [self dictionaryWithJsonString:self.paramStr];
    self.article_id  = dict[@"article_id"];
    self.thumbUrl  =  dict[@"thumb"];
    
    
    _star_id = 0;
    self.view.backgroundColor  = [UIColor whiteColor];
    self.edgesForExtendedLayout  =UIRectEdgeNone;
    
   
    self.commonToolView = [[HLHJNewDetailCommonToolView alloc]initWithFrame:CGRectZero];
    self.commonToolView.delegate = self;
    [self.view addSubview:self.commonToolView];
    [self.commonToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.view);
        make.height.mas_equalTo(49);
    }];

    
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.commonToolView.mas_top).mas_offset(-1);
    }];
    
    
    self.commonToolView.seachFiled.delegate = self;
    
    #pragma mark - 加载数据
    [self loadDataSource];

}

/// 加载数据
-(void)loadDataSource {
    
    [SVProgressHUD showWithStatus:nil];
    [SVProgressHUD setDefaultStyle: SVProgressHUDStyleDark];
    MJWeakSelf;
    [HLHJInfomationNetWorkTool hlhjRequestWithType:GET requestUrl:@"/HLHJ_news/Api/getArticleDetails" parameter:@{@"id":_article_id} successComplete:^(id  _Nullable responseObject) {
         [SVProgressHUD dismiss];
        
        
        weakSelf.detilModel = [HLHJNewsDetilModel yy_modelWithJSON:responseObject[@"data"]];
        
        NSMutableDictionary *extent = [NSMutableDictionary dictionary];
        [extent setDictionary:@{@"iosInfo":
                                    @{@"native":@"ture",@"src":@"HLHJNewsDetailViewController",
                                      @"paramStr":self.paramStr,
                                      @"wwwFolder":@""
                                      },
                                @"androidInfo" :@{@"native":@"ture",
                                                  @"src":@"hlhj.fhp.newslib.activitys.SpecialInfoAty",
                                                  @"paramStr":self.paramStr,@"wwwFolder":@""}
                                }];
        ///收藏
        _thumbUrl = [self->_thumbUrl stringByReplacingOccurrencesOfString:BASE_URL withString:@""];
        self->_parma = @{@"member_code":[TMHttpUserInstance instance].member_code.length > 0 ? [TMHttpUserInstance instance].member_code:@"",
                   @"title":weakSelf.detilModel.title,
                   @"intro":weakSelf.detilModel.title,
                   @"pic":_thumbUrl,
                   @"app_id":@"HLHJInformationSDK",
                   @"article_id":_article_id,
                   @"extend":[extent yy_modelToJSONString],
                   @"type":@"1"
                   };
        [weakSelf.tableView reloadData];
        ///添加到浏览历史记录
        [weakSelf addFootprint:self->_parma];
        [weakSelf getCommon];
        
    } failureComplete:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}
// 添加到浏览历史记录
- (void)addFootprint:(NSDictionary *)parma {
    
    [HLHJInfomationNetWorkTool hlhjRequestWithType:POST requestUrl:@"/member/Memberfootprint/addFootprint" parameter:parma successComplete:^(id  _Nullable responseObject) {
        
        NSLog(@"添加到浏览历史记录");
        
    } failureComplete:^(NSError * _Nonnull error) {
        
    }];
}

/// 查询单个文章是否收藏
- (void)querrCollection {
    
    NSDictionary *parma = @{@"member_code":[TMHttpUserInstance instance].member_code?[TMHttpUserInstance instance].member_code:@"",
                            @"app_id":@"HLHJInformationSDK",
                            @"article_id":_article_id
                            };
    [HLHJInfomationNetWorkTool hlhjRequestWithType:POST requestUrl:@"/member/Memberstar/checkIsStar" parameter:parma successComplete:^(id  _Nullable responseObject) {
        
        
        NSDictionary *dict = responseObject[@"data"];
        if (dict.allKeys.count == 0) {
               self->_commonToolView.collectBtn.selected = NO;
        }else {
            self->_star_id = [dict[@"star_id"] integerValue];
            self->_commonToolView.collectBtn.selected = YES;
        }
    } failureComplete:^(NSError * _Nonnull error) {
       
    }];
    
}

/// 查询评论数据
- (void)getCommon {
    
    MJWeakSelf;
    [HLHJInfomationNetWorkTool  hlhjRequestWithType:GET requestUrl:@"/HLHJ_news/api/getComment" parameter:@{@"id":_article_id,@"token":[TMHttpUser token]?[TMHttpUser token]:@""} successComplete:^(id  _Nullable responseObject) {
         [SVProgressHUD dismiss];
        [weakSelf.commentArr removeAllObjects];
        NSArray *commArr = [NSArray yy_modelArrayWithClass:[HLHJNewsConmmetModel class] json:responseObject[@"data"]];
        [weakSelf.commentArr addObjectsFromArray:commArr];
        [weakSelf.tableView reloadData];
    } failureComplete:^(NSError * _Nonnull error) {
         [SVProgressHUD dismiss];
    }];
    
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 2) {
        return  self.commentArr.count > 3 ? 4 :self.commentArr.count;
    }
    return self.detilModel ?  1 : 0;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
        HLHJNewDetailSectionOneCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJNewDetailSectionOneCell"];
        if(self.detilModel){
            cell.model = self.detilModel;
        }
        return cell;
    }
    if (indexPath.section == 1) {
    
         HLHJArticleDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJArticleDetailTableViewCell"];
        if(self.detilModel){
            cell.model = self.detilModel;
        }
        return cell;
    }else {
        
        if (self.commentArr.count > 3 && indexPath.row == 3) {
            HLHJMoreTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HLHJMoreTableViewCell"];
            return cell;

        }else {
            HLHJNewsCommentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJNewsCommentTableCell"];
            cell.model = self.commentArr[indexPath.row];
            cell.giveLikeBtn.tag = indexPath.row;
            cell.delegate = self;
           
            return cell;
        }
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    if (indexPath.section == 2 && 3 == indexPath.row) {
        HLHJMoreCommentViewController *more = [HLHJMoreCommentViewController new];
        more.article_id = _article_id;
        more.hidesBottomBarWhenPushed  = YES;
        [self.navigationController pushViewController:more animated:YES];
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return self.tableView.rowHeight  = UITableViewAutomaticDimension;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return .1f;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return .1f;
}

#pragma UITextFiledDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.commonToolView.seachFiled resignFirstResponder];
    [self sendContentAction:nil];
    return YES;
}

#pragma HLHJNewsCommentTableViewCellDelegate

- (void)giveLikeBtnAction:(UIButton *)sender {
    
    
    if (![self isLogin]) return;
    HLHJNewsConmmetModel *model =  self.commentArr[sender.tag];
    
    NSDictionary *parma = @{@"token":[TMHttpUser token],
                            @"id":model.ID,
                            };
    MJWeakSelf;
    [HLHJInfomationNetWorkTool hlhjRequestWithType:POST requestUrl:@"/HLHJ_news/api/laud" parameter:parma successComplete:^(id  _Nullable responseObject) {
        
        NSInteger  code = [responseObject[@"code"] integerValue];
        
        [HLHJNewsToast hsShowBottomWithText:responseObject[@"msg"]];
        
        if (code == 1 ) {
            model.is_laud = !model.is_laud;
            model.laud_num = model.is_laud == YES ? model.laud_num + 1:model.laud_num -1;
            
            [weakSelf.commentArr replaceObjectAtIndex:sender.tag withObject:model];
            //一个cell刷新
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:2];
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }
    } failureComplete:^(NSError * _Nonnull error) {
        
        [HLHJNewsToast hsShowBottomWithText:@"稍后试一试"];
        
    }];
    
}

- (void)sendContentAction:(UIButton *)sender {
    
    [self.commonToolView.seachFiled resignFirstResponder];
    if(self.commonToolView.seachFiled.text.length == 0) {

      [HLHJNewsToast hsShowBottomWithText:@"请输入评论内容"];
      return;
    }

    if (![self isLogin]) return;
    
    MJWeakSelf;
    NSDictionary *parma = @{@"uid":@([TMHttpUserInstance instance].member_id),
                            @"aid":_article_id,
                            @"content":self.commonToolView.seachFiled.text,
                            @"token":[TMHttpUser token],
                            };
    [HLHJInfomationNetWorkTool hlhjRequestWithType:GET requestUrl:@"/HLHJ_news/user_api/postComment" parameter:parma successComplete:^(id  _Nullable responseObject) {
       
        weakSelf.commonToolView.seachFiled.text = @"";
        NSInteger  code = [responseObject[@"code"] integerValue];
        if (code == 1 ) {
              [weakSelf getCommon];
        }
      [HLHJNewsToast hsShowBottomWithText:responseObject[@"message"]];
    } failureComplete:^(NSError * _Nonnull error) {
       weakSelf.commonToolView.seachFiled.text = @"";
        [HLHJNewsToast hsShowBottomWithText:@"评论失败"];

    }];
    
}
///收藏
- (void)collectAction:(UIButton *)sender {
    
    if (![self isLogin]) return;
    
    if (!self.commonToolView.collectBtn.selected) {
        
        [self addCollect:_parma];
        
    }else {
        ///取消收藏
        NSDictionary *parma = @{@"star_id":@(_star_id)};
        
        [HLHJInfomationNetWorkTool hlhjRequestWithType:POST requestUrl:@"/member/Memberstar/deleteStar" parameter:parma successComplete:^(id  _Nullable responseObject) {
            
            
            self->_star_id = 0;
            
            self->_commonToolView.collectBtn.selected = NO;
            
            [HLHJNewsToast hsShowBottomWithText:responseObject[@"msg"]];
            
        } failureComplete:^(NSError * _Nonnull error) {
            
            [HLHJNewsToast hsShowBottomWithText:@"取消失败"];
        }];
        
    }
}
/// 添加收藏
- (void)addCollect:(NSDictionary *)parma {
    
    [HLHJInfomationNetWorkTool hlhjRequestWithType:POST requestUrl:@"/member/Memberstar/addStar" parameter:parma successComplete:^(id  _Nullable responseObject) {
        
        [HLHJNewsToast hsShowBottomWithText:responseObject[@"msg"]];
        
        self->_star_id = [responseObject[@"data"][@"star_id"] integerValue];
        
        self->_commonToolView.collectBtn.selected = YES;
        
    } failureComplete:^(NSError * _Nonnull error) {
        
        [HLHJNewsToast hsShowBottomWithText:@"收藏失败"];
    }];
    
}
///分享
- (void)shareActon:(UIButton *)sender {
    
    TMShareConfig *config = [[TMShareConfig alloc] initWithTMBaseConfig];
    [[TMShareInstance instance] configWith:config];
    
    NSString *url = [NSString stringWithFormat:@"%@/application/hlhj_news/asset/article.html?id=%@",[TMEngineConfig instance].domain,_article_id];
    [[TMShareInstance instance]showShare:url thumbUrl:self.thumbUrl title:self.detilModel.title descr:self.detilModel.title currentController:self finish:nil];
}


#pragma lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        
        [_tableView registerClass:[HLHJNewsCommentTableCell class] forCellReuseIdentifier:@"HLHJNewsCommentTableCell"];
        [_tableView registerClass:[HLHJArticleDetailTableViewCell class] forCellReuseIdentifier:@"HLHJArticleDetailTableViewCell"];
        [_tableView registerClass:[HLHJMoreTableViewCell class] forCellReuseIdentifier:@"HLHJMoreTableViewCell"];
        [_tableView registerClass:[HLHJNewDetailSectionOneCell class] forCellReuseIdentifier:@"HLHJNewDetailSectionOneCell"];
        
        
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.estimatedRowHeight = 100;
        _tableView.estimatedSectionFooterHeight = 0;
        _tableView.estimatedSectionHeaderHeight = 0;
        if (@available(iOS 11.0, *)) {
          _tableView.contentInsetAdjustmentBehavior = UIScrollViewContentInsetAdjustmentNever;
        }
    }
    return _tableView;
}

- (NSMutableArray *)commentArr {
    if (!_commentArr) {
        _commentArr = [NSMutableArray array];
    }
    return _commentArr;
}

- (NSDictionary *)dictionaryWithJsonString:(NSString *)jsonString {
    if (jsonString == nil) {
        return nil ;
    }
    NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers error:&err];
    if(err) {
        NSLog(@"json解析失败：%@",err);
        return nil;
    }
    return dic;
}
- (BOOL)isLogin {
    
    if ([TMHttpUser token].length == 0) {
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"您还未登陆,请您先登陆"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"去登陆" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  //响应事件
                                                                  SetI001LoginViewController *login = [SetI001LoginViewController new];
                                                                  login.edgesForExtendedLayout = UIRectEdgeNone;
                                                                  [self.navigationController pushViewController:login animated:YES];
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 //响应事件
                                                                 
                                                             }];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return NO;
    }else {
        return YES;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
