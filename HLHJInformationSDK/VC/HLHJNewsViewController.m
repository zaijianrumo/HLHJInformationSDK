//
//  HLHJNewsViewController.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewsViewController.h"

#import "HLHJRecommendedViewController.h"
#import "UIButton+WebCache.h"
#import "HLHJCategoryNameModel.h"
#import "HLHJNewsSearchViewController.h"

#import "HLHJColumnMenu.h"
#import "UIView+HLHJ.h"
#import "HLHJConfig.h"
#import <TMSDK/TMHttpUserInstance.h>
#import <SetI001/SetI001MainViewController.h>
#import <SetI001/SetI001LoginViewController.h>
#import "SVProgressHUD.h"
#import "HLHJColumnMenuModel.h"

@interface HLHJNewsViewController ()<HLHJColumnMenuDelegate,UITextFieldDelegate>

@property (nonatomic, strong) UIImageView  *logoImage;
///显示的标题
@property (nonatomic, strong) NSMutableArray  *titleArray;
///编辑页面已选择标题
@property (nonatomic, strong) NSMutableArray  *defaultArray;
///编辑页面未选择标题
@property (nonatomic, strong) NSMutableArray  *allArray;

@property (nonatomic, strong) UIButton  *screenBtn;
///个人中心入口
@property (nonatomic, strong) UIButton  *personBtn;

@property (nonatomic, strong) UITextField  *searchFiled;
/** menuView */
@property (nonatomic, strong) HLHJColumnMenu *menu;

@property (nonatomic, strong) HLHJCategoryNameModel  *categoryNameModel;

@end

static CGFloat const kWMMenuViewHeight = 49.0;

static CGFloat const kscreenBtnWidth = 40;

@implementation HLHJNewsViewController

#pragma mark 初始化代码

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    ///NOTE2:视图设置
    [self getLogo];
    
}

- (instancetype)init {
    
    if (self = [super init]) {
        self.titleSizeNormal = 14;
        self.titleSizeSelected = 14;
        self.titleFontName = @"PingFang-SC-Medium";
        self.menuViewStyle = WMMenuViewStyleFloodHollow;
        self.titleColorSelected = [TMEngineConfig instance].themeColor? [TMEngineConfig instance].themeColor:[UIColor redColor];
        self.titleColorNormal = [UIColor colorWithHexString:@"646464"];
        self.automaticallyCalculatesItemWidths = YES;
        self.progressHeight = 25;
        self.showOnNavigationBar = NO;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    NSArray *titArray  = [[NSUserDefaults standardUserDefaults] objectForKey:@"titleArray"];
    if (titArray.count > 0) {
        [self.titleArray addObjectsFromArray:titArray];
        [self reloadData];
    }
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    
    self.view.backgroundColor = [UIColor whiteColor];
    ///NOTE1:导航栏设置
    [self initNavUI];
    ///NOTE3: 获取所有专题名称和ID
    [self getCategoryNameList];
    ///NOTE4:筛选按钮
    [self.view addSubview:self.screenBtn];
    
}
//
- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    
    return UIInterfaceOrientationMaskPortrait;
}

- (void)getLogo {
    
    MJWeakSelf;
    [HLHJInfomationNetWorkTool hlhjRequestWithType:GET requestUrl:@"/HLHJ_news/Api/getLogo" parameter:nil successComplete:^(id  _Nullable responseObject) {

        //通知主线程刷新（防止主线程堵塞）
        dispatch_async(dispatch_get_main_queue(), ^{
            NSString *url = responseObject[@"data"][@"logo"];
            NSInteger personal = [responseObject[@"data"][@"personal"] integerValue];
            if(url.length != 0) {
                
                [weakSelf.logoImage sd_setImageWithURL:[NSURL URLWithString:url]];
                
                UIView *containView = [[UIView alloc] initWithFrame:CGRectMake(0,0, 80, 18)];
                containView.backgroundColor = [UIColor clearColor];
               
                
                UIView *rightView = [[UIView alloc]init];
                rightView.frame = CGRectMake(70, 0, 10, 18);
                [containView addSubview:rightView];
                
                [containView addSubview:weakSelf.logoImage];
                
                UIBarButtonItem *leftBtnItem = [[UIBarButtonItem alloc]initWithCustomView:containView];
                self.navigationItem.leftBarButtonItem = leftBtnItem;
    
            }
            if(personal == 1){
                if ([TMHttpUserInstance instance].head_pic) {
                    
                    NSString *logoUrl = [TMHttpUserInstance instance].head_pic;
                    if ([logoUrl containsString:@"://"]) {
                        [self.personBtn sd_setImageWithURL:[NSURL URLWithString:logoUrl] forState:UIControlStateNormal];
                        UIView *containView = [[UIView alloc] initWithFrame:weakSelf.personBtn.bounds];
                        containView.backgroundColor = [UIColor clearColor];
                        [containView addSubview:weakSelf.personBtn];
                        UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:containView];
                        self.navigationItem.rightBarButtonItem = rightBtnItem;

                       
                    }else {
                        logoUrl = [NSString stringWithFormat:@"%@%@",BASE_URL,logoUrl];
                        [self.personBtn sd_setImageWithURL:[NSURL URLWithString:logoUrl] forState:UIControlStateNormal];
                         UIView *containView = [[UIView alloc] initWithFrame:weakSelf.personBtn.bounds];
                         containView.backgroundColor = [UIColor clearColor];
                         [containView addSubview:weakSelf.personBtn];
                        UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:containView];
                        self.navigationItem.rightBarButtonItem = rightBtnItem;
              
                       
                    }
                }else {
                    [weakSelf.personBtn setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/doctor"] forState: UIControlStateNormal];
                    UIView *containView = [[UIView alloc] initWithFrame:weakSelf.personBtn.bounds];
                    containView.backgroundColor = [UIColor clearColor];
                    [containView addSubview:weakSelf.personBtn];

                    UIBarButtonItem *rightBtnItem = [[UIBarButtonItem alloc]initWithCustomView:containView];
                    self.navigationItem.rightBarButtonItem = rightBtnItem; 
                }
            }
            
        });
        
    } failureComplete:^(NSError * _Nonnull error) {
        
    }];
}

- (void)personAction {
    
    SetI001MainViewController *main = [[SetI001MainViewController alloc]init];
    main.edgesForExtendedLayout = UIRectEdgeNone;
    main.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:main animated:YES];
    
}
- (void)getCategoryNameList {
    
    NSInteger user_id = [TMHttpUserInstance instance].member_id;
    MJWeakSelf;
    
    [HLHJInfomationNetWorkTool hlhjRequestWithType:GET requestUrl:@"/HLHJ_news/Api/categoryNameList" parameter:@{@"id":@(user_id)} successComplete:^(id  _Nullable responseObject) {
        
        [weakSelf.titleArray removeAllObjects];
        HLHJCategoryNameModel *model = [HLHJCategoryNameModel yy_modelWithJSON:responseObject[@"data"]];
        
        weakSelf.categoryNameModel = model;
        
        for (HLHJDefaultModel  *dmodel in model.defaults) {
            
            [weakSelf.titleArray addObject:dmodel.category_name];
        }
        [[NSUserDefaults standardUserDefaults]setObject:weakSelf.titleArray forKey:@"titleArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [weakSelf.defaultArray addObjectsFromArray:model.defaults];
        
        [weakSelf.allArray addObjectsFromArray:model.all];
        
        [weakSelf reloadData];
    } failureComplete:^(NSError * _Nonnull error) {
        
    }];
}
- (void)initNavUI{
    
    UITextField *textField = [[UITextField alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width-155, 30)];
    textField.backgroundColor = [UIColor whiteColor];
    textField.placeholder = @"";
    textField.tintColor= [UIColor clearColor];
    textField.layer.cornerRadius = 15;
    textField.clipsToBounds = YES;
    textField.delegate = self;
    textField.font = [UIFont systemFontOfSize:14];
    _searchFiled = textField;
    self.navigationItem.titleView  = textField;
    
    UIView *leftView = [UIView new];
    leftView.frame = CGRectMake(0, 0, 10, 30);
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    
    
    UIButton *seracnBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    seracnBtn.frame = CGRectMake(0, 0, 40, 30);
    [seracnBtn setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/searchicon"] forState:UIControlStateNormal];
    [seracnBtn addTarget:self action:@selector(searchAction) forControlEvents:UIControlEventTouchUpInside];
    seracnBtn.backgroundColor = [[TMEngineConfig instance].themeColor colorWithAlphaComponent:.8];
    textField.rightView = seracnBtn;
    textField.rightViewMode = UITextFieldViewModeAlways;
    
    
}
#pragma mark - Datasource & Delegate
- (NSInteger)numbersOfChildControllersInPageController:(WMPageController *)pageController {
    
    return self.titleArray.count;
}

- (UIViewController *)pageController:(WMPageController *)pageController viewControllerAtIndex:(NSInteger)index {
    
    HLHJRecommendedViewController *vc = [[HLHJRecommendedViewController alloc] init];
    HLHJDefaultModel *model =   self.categoryNameModel.defaults[index];
    vc.categoryID = model.ID;
    return vc;
}

- (NSString *)pageController:(WMPageController *)pageController titleAtIndex:(NSInteger)index {
    return [NSString stringWithFormat:@" %@  ",self.titleArray[index]];
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForMenuView:(WMMenuView *)menuView {
    return CGRectMake(0, 0, self.view.frame.size.width-kscreenBtnWidth, kWMMenuViewHeight);
}

- (CGRect)pageController:(WMPageController *)pageController preferredFrameForContentView:(WMScrollView *)contentView {
    return CGRectMake(0, kWMMenuViewHeight, self.view.frame.size.width, self.view.frame.size.height-kWMMenuViewHeight);
}
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == _searchFiled) {
        [_searchFiled resignFirstResponder];
    }
    [self.view endEditing:YES];
    
    [self searchAction];
    
}
- (void)searchAction {
    
    HLHJNewsSearchViewController *search = [HLHJNewsSearchViewController new];
    search.hidesBottomBarWhenPushed  = YES;
    [self.navigationController pushViewController:search animated:YES];
    
}
#pragma mrak - > Btn Action
-(void)screenBtnAction:(UIButton *)sender {

    NSInteger user_id = [TMHttpUserInstance instance].member_id;
    if (user_id == 0) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:@"您还未登陆,请您先登陆"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"登陆" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {
                                                                  SetI001LoginViewController *login = [SetI001LoginViewController new];
                                                                  login.edgesForExtendedLayout = UIRectEdgeNone;
                                                                  login.hidesBottomBarWhenPushed = YES;
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
    [SVProgressHUD showWithStatus:nil];
    [HLHJInfomationNetWorkTool hlhjRequestWithType:GET requestUrl:@"/HLHJ_news/Api/categoryNameList" parameter:@{@"id":@(user_id)} successComplete:^(id  _Nullable responseObject) {
        [SVProgressHUD dismiss];
        [weakSelf.titleArray removeAllObjects];
        [weakSelf.defaultArray removeAllObjects];
        [weakSelf.allArray removeAllObjects];
        HLHJCategoryNameModel *model = [HLHJCategoryNameModel yy_modelWithJSON:responseObject[@"data"]];
        
        weakSelf.categoryNameModel = model;
        
        for (HLHJDefaultModel  *dmodel in model.defaults) {
            
            [weakSelf.titleArray addObject:dmodel.category_name];
        }
        [[NSUserDefaults standardUserDefaults]setObject:weakSelf.titleArray forKey:@"titleArray"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        [weakSelf.defaultArray addObjectsFromArray:model.defaults];
        
        [weakSelf.allArray addObjectsFromArray:model.all];
        
        
        HLHJColumnMenu *menuVC = [HLHJColumnMenu columnMenuWithTagsArrM:self.defaultArray OtherArrM:self.allArray Type:HLHJColumnMenuTypeTencent Delegate:self];
        [self presentViewController:menuVC animated:YES completion:nil];
        
        
        [weakSelf reloadData];
    } failureComplete:^(NSError * _Nonnull error) {
        [SVProgressHUD dismiss];
    }];

}

#pragma mark - HLHJColumnMenuDelegate
- (void)columnMenuTagsArr:(NSMutableArray *)tagsArr OtherArr:(NSMutableArray *)otherArr {
    
    NSMutableArray *defatulsArr = [NSMutableArray array];
    
    NSMutableArray *allArr = [NSMutableArray array];
    
    for (HLHJColumnMenuModel *model in tagsArr) {
        [defatulsArr addObject:model.ID];
    }
    for (HLHJColumnMenuModel *model in otherArr) {
        [allArr addObject:model.ID];
    }
    NSInteger user_id = [TMHttpUserInstance instance].member_id;
    
    NSString *defatultString = [defatulsArr componentsJoinedByString:@","];
    
    NSString *allString = [allArr componentsJoinedByString:@","];
    
    MJWeakSelf;
    NSDictionary *prama = @{@"id":@(user_id),@"default":defatultString,@"all":allString};
    
    
    [HLHJInfomationNetWorkTool hlhjRequestWithType:POST requestUrl:@"/HLHJ_news/Api/post_user_category" parameter:prama successComplete:^(id  _Nullable responseObject) {
        
        [weakSelf.titleArray removeAllObjects];
        [weakSelf.defaultArray removeAllObjects];
        [weakSelf.allArray removeAllObjects];
        
        for (HLHJColumnMenuModel *model in tagsArr) {
            [weakSelf.titleArray addObject:model.title];
            HLHJDefaultModel *dmodel = [[HLHJDefaultModel alloc]init];
            dmodel.ID = model.ID;
            dmodel.category_name = model.title;
            [weakSelf.defaultArray addObject:dmodel];
        }
        for (HLHJColumnMenuModel *model in otherArr) {
            [allArr addObject:model.ID];
            HLHJAllModel *amodel = [[HLHJAllModel alloc]init];
            amodel.ID = model.ID;
            amodel.category_name = model.title;
            [weakSelf.allArray addObject:amodel];
        }
        [weakSelf reloadData];
    } failureComplete:^(NSError * _Nonnull error) {
    }];
}

#pragma mark -Lazy
- (NSMutableArray *)titleArray {
    if (!_titleArray) {
        _titleArray = [NSMutableArray array];
    }
    return _titleArray;
    
}
- (NSMutableArray *)defaultArray {
    if (!_defaultArray) {
        _defaultArray = [NSMutableArray array];
    }
    return _defaultArray;
    
}
- (NSMutableArray *)allArray {
    if (!_allArray) {
        _allArray = [NSMutableArray array];
    }
    return _allArray;
    
}
- (UIImageView *)logoImage {
    if (!_logoImage) {
        _logoImage = [UIImageView new];
        _logoImage.backgroundColor = [UIColor clearColor];
        _logoImage.frame = CGRectMake(0, 0, 70, 18);
    }
    return _logoImage;
}

- (UIButton *)screenBtn {
    if (!_screenBtn) {
        _screenBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_screenBtn addTarget:self action:@selector(screenBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        _screenBtn.frame = CGRectMake(self.view.frame.size.width-kscreenBtnWidth, 0, kscreenBtnWidth, kWMMenuViewHeight);
        [_screenBtn setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/ic_sy_gengduo"] forState:UIControlStateNormal];
    }
    return _screenBtn;
}

- (UIButton *)personBtn {
    if (!_personBtn) {
        _personBtn = [UIButton buttonWithType:UIButtonTypeCustom];
         [_personBtn addTarget:self action:@selector(personAction) forControlEvents:UIControlEventTouchUpInside];
        _personBtn.frame = CGRectMake(0, 0, 28, 28);
        _personBtn.layer.cornerRadius = 14;
        _personBtn.clipsToBounds = YES;
        
    }
    return _personBtn;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
