//
//  HLHJMoreCommentViewController.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/27.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJMoreCommentViewController.h"
#import "HLHJNewsConmmetModel.h"
#import "HLHJNewsCommentTableCell.h"
#import <SetI001/SetI001LoginViewController.h>
#import <TMSDK/TMHttpUserInstance.h>
#import <TMSDK/TMHttpUser.h>
#import "HLHJNewsToast.h"
/** 屏幕高度 */
#define ScreenH [UIScreen mainScreen].bounds.size.height
/** 屏幕宽度 */
#define ScreenW [UIScreen mainScreen].bounds.size.width

#define SYRealValue(value) ((value)/375.0f*ScreenW)

#define KBottomHeight  50
@interface HLHJMoreCommentViewController ()<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate,HLHJNewsCommentTableViewCelllDelegate>

@property (nonatomic, strong) UITableView  *tableView;

@property (nonatomic, strong) UIView *bottomView;//底部菜单栏View

@property (nonatomic, strong) UITextField *contentTF;

@property (nonatomic, strong) UIButton *sendBtn;


@property (nonatomic, strong)NSMutableArray  *commentArr;
@end

@implementation HLHJMoreCommentViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    self.view.backgroundColor  = [UIColor whiteColor];
    self.edgesForExtendedLayout  =UIRectEdgeNone;
    
    [self setUpBottomView];
    [self.view addSubview:self.tableView];
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.view);
        make.bottom.equalTo(self.view).mas_offset(-KBottomHeight);
    }];
    [self loadDataSource];
}
-(void)loadDataSource {
    
    MJWeakSelf;
    [HLHJInfomationNetWorkTool  hlhjRequestWithType:GET requestUrl:@"/HLHJ_news/api/getComment" parameter:@{@"id":_article_id,@"token":[TMHttpUser token] ? [TMHttpUser token]:@""} successComplete:^(id  _Nullable responseObject) {
        [weakSelf.commentArr removeAllObjects];
        NSArray *commArr = [NSArray yy_modelArrayWithClass:[HLHJNewsConmmetModel class] json:responseObject[@"data"]];
        [weakSelf.commentArr addObjectsFromArray:commArr];
        [weakSelf.tableView reloadData];
    } failureComplete:^(NSError * _Nonnull error) {
        
    }];

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return  self.commentArr.count;
    
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
        HLHJNewsCommentTableCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HLHJNewsCommentTableCell"];
        cell.model = self.commentArr[indexPath.row];
        cell.delegate = self;
        cell.giveLikeBtn.tag = indexPath.row;
        return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
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
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [self.contentTF resignFirstResponder];
    [self sendBtnAction];
    return YES;
}

-(void)sendBtnAction {
    
    [self.contentTF resignFirstResponder];
    if(self.contentTF.text.length == 0) {
        
        [HLHJNewsToast hsShowBottomWithText:@"请输入评论内容"];
        return;
    }
    if (![self isLogin]) return;
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
            
            [weakSelf loadDataSource];
        }
        
    } failureComplete:^(NSError * _Nonnull error) {
            weakSelf.contentTF.text = @"";
        [HLHJNewsToast hsShowBottomWithText:@"评论失败"];
        
    }];
    
    
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
            NSIndexPath *indexPath=[NSIndexPath indexPathForRow:sender.tag inSection:0];
            [weakSelf.tableView reloadRowsAtIndexPaths:[NSArray arrayWithObjects:indexPath,nil] withRowAnimation:UITableViewRowAnimationNone];
            
        }
    } failureComplete:^(NSError * _Nonnull error) {
        
        [HLHJNewsToast hsShowBottomWithText:@"稍后试一试"];
        
    }];
    
}

-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
    if ([self.contentTF isFirstResponder]) {
        [self.contentTF resignFirstResponder];
    }
}
#pragma lazy

- (UITableView *)tableView {
    if (!_tableView) {
        _tableView = [[UITableView alloc]initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        _tableView.separatorColor = [UIColor groupTableViewBackgroundColor];
        
        [_tableView registerClass:[HLHJNewsCommentTableCell class] forCellReuseIdentifier:@"HLHJNewsCommentTableCell"];
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
    
    UITextField *tf = [[UITextField alloc] initWithFrame:CGRectMake(10, 4, ScreenW-20, 38)];
    tf.textColor = [UIColor colorWithHexString:@"#333333"];
    tf.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];
    tf.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:14];
    tf.returnKeyType = UIReturnKeySend;//变为搜索按钮
    tf.delegate = self;//设置代理
    tf.placeholder = @"输入您的评论";
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

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
