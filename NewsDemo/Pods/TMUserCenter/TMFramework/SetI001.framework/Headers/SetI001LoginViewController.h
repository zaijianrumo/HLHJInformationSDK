//
//  SetI001LoginViewController.h
//  TmCompDemo
//
//  Created by ZhouYou on 2018/1/15.
//  Copyright © 2018年 ZhouYou. All rights reserved.
//

#import <TMSDK/Cordova.h>

@interface SetI001LoginViewController : TMViewController

/**
 登录类型，默认为账号密码登录，1：账号密码登录， 2：手机号登录，
 */
@property (nonatomic, assign) NSInteger loginType;

/*
 paramstr:
 {
 "needDismiss":true
 }
 */
@end
