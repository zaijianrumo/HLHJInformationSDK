//
//  ViewController.m
//  NewsDemo
//
//  Created by mac on 2018/6/4.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "ViewController.h"
#import <HLHJInformationSDK/HLHJNewsViewController.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)buttonSender:(UIButton *)sender {
    
    HLHJNewsViewController *hlhj = [[HLHJNewsViewController alloc]init];
    UINavigationController *nav = [[UINavigationController alloc]initWithRootViewController:hlhj];
    [self presentViewController:nav animated:YES completion:nil];
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
