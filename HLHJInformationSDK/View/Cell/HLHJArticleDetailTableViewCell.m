//
//  HLHJArticleDetailTableViewCell.m
//  HLHJProjectSDK
//
//  Created by mac on 2018/6/14.
//  Copyright © 2018年 mac. All rights reserved.
//

#import "HLHJArticleDetailTableViewCell.h"
#import "ZFPlayer.h"
#import "ZFAVPlayerManager.h"
#import "ZFPlayerControlView.h"
/** 屏幕宽度 */
#define ScreenW [UIScreen mainScreen].bounds.size.width

static const CGFloat Kmargin =  10;

@interface HLHJArticleDetailTableViewCell()

@property (nonatomic, strong) UILabel  *contentLab;

@property (nonatomic, strong) UILabel  *autorLab;

@property (nonatomic, strong) ZFPlayerController *player;

@property (nonatomic, strong) UIView *containerView;

@property (nonatomic, strong) UIButton *playBtn;

@property (nonatomic, strong)  ZFAVPlayerManager *playerManager ;

@property (nonatomic, strong) ZFPlayerControlView *controlView;


@end

@implementation HLHJArticleDetailTableViewCell



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = 0;
;
        [self.contentView addSubview:self.containerView];
        [self.containerView addSubview:self.playBtn];
        [self.contentView addSubview:self.contentLab];

        [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.contentView.mas_top).mas_offset(Kmargin/2);
            make.left.equalTo(self.contentView.mas_left).mas_offset(Kmargin);
            make.right.equalTo(self.contentView.mas_right).mas_offset(-Kmargin);
            make.height.mas_equalTo(0);
        }];
    
        [self.playBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.containerView);
        }];
        
        [self.contentLab mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.containerView.mas_bottom).mas_offset(Kmargin);
            make.left.equalTo(self.contentView.mas_left).mas_offset(Kmargin);
            make.right.equalTo(self.contentView.mas_right).mas_offset(-Kmargin);
            make.bottom.equalTo(self.contentView.mas_bottom).mas_offset(-Kmargin/2);
        }];


        self.playerManager = [[ZFAVPlayerManager alloc] init];
        /// 播放器相关
        self.player = [ZFPlayerController playerWithPlayerManager:self.playerManager containerView:self.containerView];
        self.player.controlView = self.controlView;
        
        self.player.orientationWillChange = ^(ZFPlayerController * _Nonnull player, BOOL isFullScreen) {

        };
    }
    return self;
}
- (void)setModel:(HLHJNewsDetilModel *)model {
    
    
    _model = model;
    
    NSString *content = model.content;
//    NSString *content = [self autoWebAutoImageSize:model.content];

    if ([content containsString:@"<img alt="""]) {
        
        content =  [content stringByReplacingOccurrencesOfString:@"<img alt=""" withString:[NSString stringWithFormat:@"<img style='width:%lf;height:auto;'",ScreenW-20]];

    }else {
        content =  [content stringByReplacingOccurrencesOfString:@"<img src=\"" withString:[NSString stringWithFormat:@"<img style='width:%lf;height:auto;' src=\"%@",ScreenW-20,BASE_URL]];
    }
    
    NSMutableAttributedString * attributedText = [[NSMutableAttributedString alloc] initWithData:[content dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes: nil error:nil];

    self.contentLab.attributedText = attributedText;

    
    if (model.video_url.length > 0) {
        
        [self.containerView mas_updateConstraints:^(MASConstraintMaker *make) {
            make.height.mas_equalTo(250);
        }];
        NSString *URLString = [model.video_url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        self.playerManager.assetURL = [NSURL URLWithString:URLString];
        
        [self.controlView showTitle:model.title coverURLString:model.video_url fullScreenMode:ZFFullScreenModeLandscape];
    }
 
}



- (NSString *)autoWebAutoImageSize:(NSString *)html{

    NSString * regExpStr = @"<img\\s+.*?\\s+(style\\s*=\\s*.+?\")";
    NSRegularExpression *regex=[NSRegularExpression regularExpressionWithPattern:regExpStr options:NSRegularExpressionCaseInsensitive error:nil];

    NSArray *matches=[regex matchesInString:html
                                    options:0
                                      range:NSMakeRange(0, [html length])];


    NSMutableArray * mutArray = [NSMutableArray array];
    for (NSTextCheckingResult *match in matches) {
        NSString* group1 = [html substringWithRange:[match rangeAtIndex:1]];
        [mutArray addObject: group1];
    }

    NSUInteger len = [mutArray count];
    for (int i = 0; i < len; ++ i) {
        html = [html stringByReplacingOccurrencesOfString:mutArray[i] withString:[NSString stringWithFormat:@"style=\"width:%lf; height:auto;\"",ScreenW-20]];
    }

    return html;
}


- (UILabel *)contentLab {
    if (!_contentLab) {
        _contentLab = [UILabel new];
        _contentLab.numberOfLines = 0;
    }
    return _contentLab;
}

- (UIView *)containerView {
    if (!_containerView) {
         _containerView = [UIView new];
        _containerView.backgroundColor = [UIColor blackColor];
    }
    return _containerView;
}
- (ZFPlayerControlView *)controlView {
    if (!_controlView) {
        _controlView = [ZFPlayerControlView new];
    }
    return _controlView;
}
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_playBtn setImage:[UIImage imageNamed:@"HLHJImageResources.bundle/ic_sy_bofang"] forState:UIControlStateNormal];
    }
    return _playBtn;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
