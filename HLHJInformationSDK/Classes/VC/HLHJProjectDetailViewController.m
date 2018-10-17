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
#import "HLHJNewsCommentTableViewCell.h"
#import "HLHJMoreCommentViewController.h"

#import <SetI001/SetI001LoginViewController.h>
#import <TMSDK/TMHttpUserInstance.h>
#import <TMSDK/TMHttpUser.h>
#import <TMShare/TMShare.h>
#import "HLHJNewsToast.h"
#import "SVProgressHUD.h"
/** 屏幕高度 */
#define ScreenH [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度 */
#define ScreenW [UIScreen mainScreen].bounds.size.width

#define SYRealValue(value) ((value)/375.0f*ScreenW)

#define KBottomHeight  50
@interface HLHJNewsDetailViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>

@property (nonatomic, strong) HLHJNewsDetilModel  *detilModel;

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) UIView *bottomView;//底部菜单栏View

@property (nonatomic, strong) UITextField *contentTF;

@property (nonatomic, strong) UIButton *sendBtn;

@property (nonatomic, strong) UIButton *collectBtn;

@property (nonatomic, strong)NSMutableArray  *commentArr;

@property (nonatomic, assign) NSInteger  star_id; ///文章收藏的ID

@end

@implementation HLHJNewsDetailViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if ([TMHttpUser token].length > 0) {
           [self querrCollection];
    }
 
}
- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"详情";
    
    _star_id = 0;
    self.view.backgroundColor  = [UIColor whiteColor];
    self.edgesForExtendedLayout  =UIRectEdgeNone;
    
    [self setUpBottomView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-KBottomHeight);
    }];
  
    ///加载数据
    [self loadDataSource];
    
    //分享
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/ic_share"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareAction) forControlEvents:UIControlEventTouchUpInside];
    [shareBtn sizeToFit];
    //收藏
    _collectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_collectBtn setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/ic_nottocollect"] forState:UIControlStateNormal];
    [_collectBtn setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/ic_collection"] forState:UIControlStateSelected];
    [_collectBtn addTarget:self action:@selector(collectBtnAction) forControlEvents:UIControlEventTouchUpInside];
    [_collectBtn sizeToFit];

    UIBarButtonItem *item1 = [[UIBarButtonItem alloc]initWithCustomView:shareBtn];
    UIBarButtonItem *item2 = [[UIBarButtonItem alloc]initWithCustomView:_collectBtn];
    
    self.navigationItem.rightBarButtonItems = @[item1,item2];
    
}
- (void)shareAction {
    
    TMShareConfig *config = [[TMShareConfig alloc] initWithTMBaseConfig];
    [[TMShareInstance instance] configWith:config];
    NSString *url = [NSString stringWithFormat:@"%@/application/hlhj_news/asset/article.html?id=%@",[TMEngineConfig instance].domain,_article_id];
    [[TMShareInstance instance]showShare:url thumbUrl:self.thumbUrl title:self.detilModel.title descr:self.detilModel.title currentController:self finish:nil];
}

- (void)collectBtnAction {
    
    if ([TMHttpUserInstance instance].member_code.length == 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"您还未登陆,请您先登陆"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  SetI001LoginViewController *login = [SetI001LoginViewController new];
                                                                  login.edgesForExtendedLayout = UIRectEdgeNone;
                                                                  [self.navigationController pushViewController:login animated:YES];
                                                                  
                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {
                                                                 
                                                             }];
        
        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        return;
    }
    
    if (!_collectBtn.selected) {
        ///收藏
        _thumbUrl = [_thumbUrl stringByReplacingOccurrencesOfString:BASE_URL withString:@""];
        NSDictionary *parma = @{@"member_code":[TMHttpUserInstance instance].member_code,
                                @"title":self.detilModel.title,
                                @"intro":self.detilModel.title,
                                @"pic":_thumbUrl,
                                @"url":@"/application/hlhj_news/asset/article.html",
                                @"app_id":@"HLHJInformationSDK",
                                @"article_id":_article_id
                                };
        [HLHJInfomationNetWorkTool hlhjRequestWithType:POST requestUrl:@"/member/Memberstar/addStar" parameter:parma successComplete:^(id  _Nullable responseObject) {
            
            [HLHJNewsToast hsShowBottomWithText:responseObject[@"msg"]];
     
            
            self->_star_id = [responseObject[@"data"][@"star_id"] integerValue];
            
            self->_collectBtn.selected = YES;
            
        } failureComplete:^(NSError * _Nonnull error) {
            
            [HLHJNewsToast hsShowBottomWithText:@"收藏失败"];
        }];
    }else {
        ///取消收藏
        NSDictionary *parma = @{@"star_id":@(_star_id)};
        
        [HLHJInfomationNetWorkTool hlhjRequestWithType:POST requestUrl:@"/member/Memberstar/deleteStar" parameter:parma successComplete:^(id  _Nullable responseObject) {
            
            
            self->_star_id = 0;
            
            self->_collectBtn.selected = NO;
            
            [HLHJNewsToast hsShowBottomWithText:responseObject[@"msg"]];

        } failureComplete:^(NSError * _Nonnull error) {
            
            [HLHJNewsToast hsShowBottomWithText:@"取消失败"];
        }];
        
    }
    
}
#pragma mark 加载数据
-(void)loadDataSource {
    
    [SVProgressHUD showWithStatus:nil];
    [SVProgressHUD setDefaultStyle: SVProgressHUDStyleDark];
    MJWeakSelf;
    [HLHJInfomationNetWorkTool hlhjRequestWithType:GET requestUrl:@"/HLHJ_news/Api/getArticleDetails" parameter:@{@"id":_article_id} successComplete:^(id  _Nullable responseObject) {

        weakSelf.detilModel = [HLHJNewsDetilModel yy_modelWithJSON:responseObject[@"data"]];
        
        [weakSelf getCommon];
        
    } failureComplete:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];
}
#pragma mark 查询单个文章是否收藏
- (void)querrCollection {
    
    NSDictionary *parma = @{@"member_code":[TMHttpUserInstance instance].member_code?[TMHttpUserInstance instance].member_code:@"",
                            @"app_id":@"HLHJInformationSDK",
                            @"article_id":_article_id
                            };
    [HLHJInfomationNetWorkTool hlhjRequestWithType:POST requestUrl:@"/member/Memberstar/checkIsStar" parameter:parma successComplete:^(id  _Nullable responseObject) {
        
         id dict = responseObject[@"data"];
        if([dict isKindOfClass:[NSArray class]]){
             self->_collectBtn.selected = NO;
        }else if([dict isKindOfClass:[NSDictionary class]]) {
            self->_star_id = [dict[@"star_id"] integerValue];
            self->_collectBtn.selected = YES;
        }
    } failureComplete:^(NSError * _Nonnull error) {
       
    }];
    
}
#pragma mark 查询评论数据
- (void)getCommon {
    
    MJWeakSelf;
    [HLHJInfomationNetWorkTool  hlhjRequestWithType:GET requestUrl:@"/HLHJ_news/api/getComment" parameter:@{@"id":_article_id} successComplete:^(id  _Nullable responseObject) {
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

    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        
        return self.detilModel ?  1 : 0;
    }
    return  self.commentArr.count > 3 ? 4 :self.commentArr.count;

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
    
        HLHJArticleDetailTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJArticleDetailTableViewCell"];
        if(self.detilModel){
            cell.model = self.detilModel;
        }
        return cell;
    }
    
    if (indexPath.row == 3) {
        HLHJMoreTableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"HLHJMoreTableViewCell"];
        return cell;
        
    }else {
        HLHJNewsCommentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJNewsCommentTableViewCell"];
        cell.model = self.commentArr[indexPath.row];
        return cell;
    }
    
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [self.view endEditing:YES];
    if (indexPath.section != 0 && 3 == indexPath.row) {
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
    if (section == 1) {
        return 10;
    }
    return .1f;
}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if ([self.contentTF isFirstResponder]) {
        [self.contentTF resignFirstResponder];
    }
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.contentTF resignFirstResponder];
    [self sendBtnAction];
    return YES;
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    
    if (textField == self.contentTF) {
        //这里的if时候为了获取删除操作,如果没有次if会造成当达到字数限制后删除键也不能使用的后果.
        if (range.length == 1 && string.length == 0) {
            return YES;
        }
        //so easy
        else if (self.contentTF.text.length >= 200) {
            self.contentTF.text = [textField.text substringToIndex:200];
            return NO;
        }
    }
    return YES;
}


-(void)sendBtnAction {
    
    [self.contentTF resignFirstResponder];
    if(self.contentTF.text.length == 0) {

      [HLHJNewsToast hsShowBottomWithText:@"请输入评论内容"];
      return;
    }
    if ([TMHttpUserInstance instance].member_id == 0) {

        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"您还未登陆,请您先登陆"
                                                                preferredStyle:UIAlertControllerStyleAlert];

        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  SetI001LoginViewController *login = [SetI001LoginViewController new];
                                                                  login.edgesForExtendedLayout = UIRectEdgeNone;
                                                                  [self.navigationController pushViewController:login animated:YES];

                                                              }];
        UIAlertAction* cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault
                                                             handler:^(UIAlertAction * action) {

                                                             }];

        [alert addAction:defaultAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];

        return;
    }
    MJWeakSelf;
    NSDictionary *parma = @{@"uid":@([TMHttpUserInstance instance].member_id),
                            @"aid":_article_id,
                            @"content":self.contentTF.text,
                            @"token":[TMHttpUser token],
                            };
    [HLHJInfomationNetWorkTool hlhjRequestWithType:GET requestUrl:@"/HLHJ_news/user_api/postComment" parameter:parma successComplete:^(id  _Nullable responseObject) {
       
        weakSelf.contentTF.text = @"";
        NSInteger  code = [responseObject[@"code"] integerValue];
        if (code == 100 ) {
            [HLHJNewsToast hsShowBottomWithText:responseObject[@"message"]];
        }else {
            [HLHJNewsToast hsShowBottomWithText:@"评论成功"];
            [weakSelf getCommon];
        }

    } failureComplete:^(NSError * _Nonnull error) {
       weakSelf.contentTF.text = @"";
        [HLHJNewsToast hsShowBottomWithText:@"评论失败"];

    }];
    
}

#pragma lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        
        [_tableView registerClass:[HLHJNewsCommentTableViewCell class] forCellReuseIdentifier:@"HLHJNewsCommentTableViewCell"];
        [_tableView registerClass:[HLHJArticleDetailTableViewCell class] forCellReuseIdentifier:@"HLHJArticleDetailTableViewCell"];
        [_tableView registerClass:[HLHJMoreTableViewCell class] forCellReuseIdentifier:@"HLHJMoreTableViewCell"];
        
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
-(void)setUpBottomView {
    
    self.bottomView = [UIView new];
    self.bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.bottomView];
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.bottom.left.equalTo(self.view);
        make.height.mas_equalTo(KBottomHeight);
    }];
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 1)];
    line.backgroundColor = [UIColor colorWithHexString:@"#F4F4F4"];
    [self.bottomView addSubview:line];
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, ScreenW-20, 30)];
    tf.textColor = [UIColor colorWithHexString:@"#333333"];
    tf.font = [UIFont systemFontOfSize:14];
    tf.placeholder = @"输入您的评论";
    tf.returnKeyType = UIReturnKeySend;//变为搜索按钮
    tf.delegate = self;//设置代理
    tf.layer.cornerRadius = tf.frame.size.height/2;
    tf.layer.borderColor = [UIColor colorWithHexString:@"#F4F4F4"].CGColor;
    tf.layer.borderWidth = 1;
    tf.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 10, 10)];
    tf.leftViewMode = UITextFieldViewModeAlways;
    tf.clearButtonMode = UITextFieldViewModeWhileEditing;
    [self.bottomView addSubview:tf];
    self.contentTF = tf;
    
    
    UIButton *sendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [sendBtn setTitle:@"发送" forState:UIControlStateNormal];
    [sendBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    sendBtn.titleLabel.font  = [UIFont systemFontOfSize:14];
    [sendBtn addTarget:self action:@selector(sendBtnAction) forControlEvents:UIControlEventTouchUpInside];
    sendBtn.frame = CGRectMake(0, 0, 50, 30);
    self.contentTF.rightView = sendBtn;
    self.contentTF.rightViewMode = UITextFieldViewModeAlways;

}
- (NSMutableArray *)commentArr {
    if (!_commentArr) {
        _commentArr = [NSMutableArray array];
    }
    return _commentArr;
}
+ (BOOL)iPhoneX{
    return [UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(1125, 2436), [[UIScreen mainScreen] currentMode].size) : NO;
}
+ (CGFloat)getButtomHeight{
    if ([self iPhoneX]) {
        return 34.0;
    } else {
        return 0.0;
    }
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
