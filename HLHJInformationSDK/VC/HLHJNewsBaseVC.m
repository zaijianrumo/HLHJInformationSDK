//
//  HLHJNewsBaseVC.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewsBaseVC.h"

#import "IQKeyboardManager/IQKeyboardManager.h"

@interface HLHJNewsBaseVC ()

@end

@implementation HLHJNewsBaseVC

//- (instancetype)init {
//  self = [super init];
//    if (self) {
//        self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//        self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
//        self.navigationController.navigationBar.barTintColor = [TMEngineConfig instance].navigationBarTintColor;
//    }
//    return self;
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    
     self.edgesForExtendedLayout = UIRectEdgeNone;
    
      [IQKeyboardManager sharedManager].enable = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
