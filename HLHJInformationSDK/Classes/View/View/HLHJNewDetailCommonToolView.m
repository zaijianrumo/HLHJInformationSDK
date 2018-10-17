//
//  HLHJNewDetailCommonToolView.m
//  HLHJInformationSDK
//
//  Created by mac on 2018/9/8.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJNewDetailCommonToolView.h"


@interface HLHJNewDetailCommonToolView()

@property (nonatomic, strong) NSMutableArray *masonryViewArray;

@property (nonatomic, strong) UIView  *rightView;
@end

@implementation HLHJNewDetailCommonToolView


- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self == [super initWithFrame:frame ]) {
        
        self.backgroundColor = [UIColor whiteColor];
        UIView *leftView = [[UIView alloc]init];
        leftView.backgroundColor = [UIColor whiteColor];
        [self addSubview:leftView];
        
        _rightView = [[UIView alloc]init];
        _rightView.backgroundColor = [UIColor whiteColor];
        [self addSubview:_rightView];
        
        [leftView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.top.bottom.equalTo(self);
            make.right.equalTo(self->_rightView.mas_left);
        }];
        
        [_rightView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.bottom.top.equalTo(self);
            make.width.mas_equalTo(120);
        }];
        [self masonry_horizontal_fixSpace];
        
        
        UITextField *seachFiled = [[UITextField alloc]init];
        seachFiled.layer.cornerRadius = 18;
        seachFiled.clipsToBounds  = YES;
        seachFiled.backgroundColor = [UIColor colorWithHexString:@"#E0E0E0"];
        seachFiled.placeholder = @"说点什么吧~";
        seachFiled.font = [UIFont fontWithName:@"PingFang-SC-Medium" size:13];
        [leftView addSubview:seachFiled];
        [seachFiled mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(leftView).mas_offset(15);
            make.right.equalTo(leftView).mas_offset(-5);
            make.top.mas_equalTo(7);
            make.bottom.mas_equalTo(-7);
        }];
        
        seachFiled.leftView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 10, 10)];
        seachFiled.leftViewMode = UITextFieldViewModeAlways;
        seachFiled.returnKeyType = UIReturnKeySend;
        self.seachFiled = seachFiled;
   
        
    }
    return self;
}


- (void)toolBtnAction:(UIButton *)sender {
    NSInteger tag = sender.tag;
    switch (tag) {
        case 1000:{
            if (self.delegate && [self.delegate respondsToSelector:@selector(sendContentAction:)]) {
                [self.delegate sendContentAction:sender];
            }
        } break;
        case 1001:{
            if (self.delegate && [self.delegate respondsToSelector:@selector(collectAction:)]) {
                [self.delegate collectAction:sender];
            }
        } break;
        case 1002:{
            if (self.delegate && [self.delegate respondsToSelector:@selector(shareActon:)]) {
                [self.delegate shareActon:sender];
            }
        } break;
        default:
            break;
    } 
}


- (NSMutableArray *)masonryViewArray {
    
    if (!_masonryViewArray) {
        
        _masonryViewArray = [NSMutableArray array];
        
        
        UIButton *toolBtn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        [toolBtn1 setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/ic_comments"] forState:UIControlStateNormal];
        toolBtn1.tag =  1000;
        [toolBtn1 addTarget:self action:@selector(toolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightView addSubview:toolBtn1];
        [_masonryViewArray addObject:toolBtn1];
        
        
        UIButton *toolBtn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        [toolBtn2 setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/ic_sc_normal"] forState:UIControlStateNormal];
        [toolBtn2 setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/ic_sc_select"] forState:UIControlStateSelected];
        toolBtn2.tag =  1001;
        [toolBtn2 addTarget:self action:@selector(toolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightView addSubview:toolBtn2];
        [_masonryViewArray addObject:toolBtn2];
        self.collectBtn = toolBtn2;
        
        
        UIButton *toolBtn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        [toolBtn3 setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/tabar-ic_share"] forState:UIControlStateNormal];
        toolBtn3.tag =  1002;
        [toolBtn3 addTarget:self action:@selector(toolBtnAction:) forControlEvents:UIControlEventTouchUpInside];
        [_rightView addSubview:toolBtn3];
        [_masonryViewArray addObject:toolBtn3];
        
    }
    return _masonryViewArray;
    
}

- (void)masonry_horizontal_fixSpace {
    
    // 实现masonry水平固定间隔方法
    [self.masonryViewArray mas_distributeViewsAlongAxis:MASAxisTypeHorizontal withFixedSpacing:10 leadSpacing:10 tailSpacing:10];
    
    // 设置array的垂直方向的约束
    [self.masonryViewArray mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.top.equalTo(self);
        make.height.equalTo(self);
    }];
    
    
}

@end
