//
//  UserSongShareView.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/6/25.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "UserSongShareView.h"
#import "PopShareButton.h"
#import "ShareBottomButton.h"
#import "ShareManager.h"



@implementation UserSongShareView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createView];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame ShareParams:(NSDictionary *)params {
    self = [super initWithFrame:frame];
    if (self) {
        self.shareParams = params;
        [self createView];
    }
    return self;
}
- (void)createView {
    [self createShareView];
}

/**
 *  创建分享界面
 */
- (void)createShareView {
    
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    [self addSubview:self.shareView];
    self.shareView.backgroundColor = [UIColor clearColor];
    
//    CGRect frame1;// 微信
//    CGRect frame2;// 朋友圈
//    CGRect frame3;// QQ
//    CGRect frame4;// qq空间
//    CGRect frame5;// 新浪微博
//    CGRect frame6;// 链接
    NSString *title1 = nil;
    NSString *title2 = nil;
    NSString *title3 = nil;
    NSString *title4 = nil;
    NSString *title5 = nil;
    NSString *title6 = nil;
    
    title1 = @"微信";
    title2 = @"朋友圈";
    title3 = @"QQ";
    title4 = @"QQ空间";
    title5 = @"微博";
    title6 = @"复制链接";

    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
#warning fortest remember delete
    // 测试用
    //        app.wxIsInstall = YES;
    //        app.QQIsInstall = YES;
    //        app.weiboInstall = YES;
    
    if (app.wxIsInstall == YES && app.QQIsInstall == YES) {
        
        self.frame1 = CGRectMake(55 * WIDTH_NIT, 0, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
        self.frame2 = CGRectMake(self.frame1.origin.x + self.frame1.size.width + 57.5 * WIDTH_NIT, self.frame1.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
        self.frame5 = CGRectMake(self.frame2.origin.x + self.frame2.size.width + 57.5 * WIDTH_NIT, self.frame1.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
        
        self.frame3 = CGRectMake(self.frame1.origin.x, self.frame1.origin.y + self.frame1.size.height + 24 * HEIGHT_NIT, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
        self.frame4 = CGRectMake(self.frame3.origin.x + self.frame3.size.width + 57.5 * WIDTH_NIT, self.frame3.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
        self.frame6 = CGRectMake(self.frame4.origin.x + self.frame4.size.width + 57.5 * WIDTH_NIT, self.frame4.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
        
    } else if (app.wxIsInstall == NO && app.QQIsInstall == YES) {
        self.frame1 = CGRectZero;
        self.frame2 = CGRectZero;
        self.frame5 = CGRectMake(55 * WIDTH_NIT, 0, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
        
        self.frame3 = CGRectMake(self.frame5.origin.x + self.frame5.size.width + 57.5 * WIDTH_NIT, self.frame5.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
        self.frame4 = CGRectMake(self.frame3.origin.x + self.frame3.size.width + 57.5 * WIDTH_NIT, self.frame3.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
        self.frame6 = CGRectMake(self.frame5.origin.x, self.frame5.origin.y + self.frame5.size.height + 24 * HEIGHT_NIT, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
        
    } else if (app.wxIsInstall == YES && app.QQIsInstall == NO) {
        self.frame1 = CGRectMake(55 * WIDTH_NIT, 0, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
        self.frame2 = CGRectMake(self.frame1.origin.x + self.frame1.size.width + 57.5 * WIDTH_NIT, self.frame1.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
        self.frame5 = CGRectMake(self.frame2.origin.x + self.frame2.size.width + 57.5 * WIDTH_NIT, self.frame1.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
        
        self.frame3 = CGRectZero;
        self.frame4 = CGRectZero;
        self.frame6 = CGRectMake(self.frame1.origin.x, self.frame1.origin.y + self.frame1.size.height + 24 * HEIGHT_NIT, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
    } else {
        self.frame1 = CGRectZero;
        self.frame2 = CGRectZero;
        self.frame5 = CGRectMake(55 * WIDTH_NIT, 0, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
        
        self.frame3 = CGRectZero;
        self.frame4 = CGRectZero;
        self.frame6 = CGRectMake(self.frame1.origin.x + self.frame1.size.width + 57.5 * WIDTH_NIT, self.frame1.origin.y, 50 * WIDTH_NIT, 50 * WIDTH_NIT + 24 * HEIGHT_NIT);
    }
    
    self.preFrame1 = CGRectMake(self.frame1.origin.x, self.frame1.origin.y, self.frame1.size.width, self.frame1.size.height);
    self.preFrame2 = CGRectMake(self.frame2.origin.x, self.frame2.origin.y, self.frame2.size.width, self.frame2.size.height);
    self.preFrame3 = CGRectMake(self.frame3.origin.x, self.frame3.origin.y, self.frame3.size.width, self.frame3.size.height);
    self.preFrame4 = CGRectMake(self.frame4.origin.x, self.frame4.origin.y, self.frame4.size.width, self.frame4.size.height);
    self.preFrame5 = CGRectMake(self.frame5.origin.x, self.frame5.origin.y, self.frame5.size.width, self.frame5.size.height);
    self.preFrame6 = CGRectMake(self.frame6.origin.x, self.frame6.origin.y, self.frame6.size.width, self.frame6.size.height);
    
    self.weChatView = [UIView new];
    self.weChatView.backgroundColor = [UIColor clearColor];
    self.weChatView.frame = self.frame1;
    
    self.weChatShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.weChatShare.userInteractionEnabled = NO;
    self.weChatShare.frame = CGRectMake(0, 0, self.frame1.size.width, self.frame1.size.width);
//    [self.weChatShare setBackgroundImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    [self.weChatView addSubview:self.weChatShare];
    
    self.friendView = [UIView new];
    self.friendView.backgroundColor = [UIColor clearColor];
    self.friendView.frame = self.frame2;
    
    self.friendShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.friendShare.userInteractionEnabled = NO;
    self.friendShare.frame = CGRectMake(0, 0, self.frame2.size.width, self.frame2.size.width);
//    [self.friendShare setBackgroundImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
    [self.friendView addSubview:self.friendShare];
    
    if (app.wxIsInstall) {
        self.weChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.weChatShare.left - self.weChatShare.width * 0.25, self.weChatShare.bottom, self.weChatShare.width * 1.5, 24 * HEIGHT_NIT)];
//        self.weChatLabel.text = title1;
        self.weChatLabel.font = NORML_FONT(12 * WIDTH_NIT);
        self.weChatLabel.textAlignment = NSTextAlignmentCenter;
        self.weChatLabel.textColor = HexStringColor(@"#ffffff");
        
        [self.shareView addSubview:self.weChatView];
        [self.weChatView addSubview:self.weChatLabel];
        
        PopShareButton *weChatButton = [PopShareButton buttonWithType:UIButtonTypeCustom];
        [self.weChatView addSubview:weChatButton];
        weChatButton.frame = CGRectMake(self.weChatLabel.left, self.weChatShare.top, self.weChatLabel.width, self.weChatLabel.bottom - self.weChatShare.top);
        weChatButton.tag = 100;
        [weChatButton setTitle:title1 forState:UIControlStateNormal];
        [weChatButton setImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
        [weChatButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.friendShare.left - self.friendShare.width * 0.25, self.friendShare.bottom, self.friendShare.width * 1.5, 24 * HEIGHT_NIT)];
//        self.friendLabel.text = title2;
        self.friendLabel.font = NORML_FONT(12 * WIDTH_NIT);
        self.friendLabel.textAlignment = NSTextAlignmentCenter;
        self.friendLabel.textColor = HexStringColor(@"#ffffff");
        
        [self.shareView addSubview:self.friendView];
        [self.friendView addSubview:self.friendLabel];
        
        PopShareButton *friendButton = [PopShareButton buttonWithType:UIButtonTypeCustom];
        [self.friendView addSubview:friendButton];
        friendButton.frame = CGRectMake(self.friendLabel.left, self.friendShare.top, self.friendLabel.width, self.friendLabel.bottom - self.friendShare.top);
        [friendButton setImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];
        [friendButton setTitle:title2 forState:UIControlStateNormal];
        friendButton.tag = 101;
        [friendButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    self.QQView = [UIView new];
    self.QQView.backgroundColor = [UIColor clearColor];
    self.QQView.frame = self.frame3;
    [self.shareView addSubview:self.QQView];
    
    self.QQShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.QQShare.userInteractionEnabled = NO;
    self.QQShare.frame = CGRectMake(0, 0, self.frame3.size.width, self.frame3.size.width);
//    [self.QQShare setBackgroundImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
    [self.QQView addSubview:self.QQShare];
    
    self.QZoneView = [UIView new];
    self.QZoneView.backgroundColor = [UIColor clearColor];
    self.QZoneView.frame = self.frame4;
    [self.shareView addSubview:self.QZoneView];
    
    self.QZoneShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.QZoneShare.userInteractionEnabled = NO;
    self.QZoneShare.frame = CGRectMake(0, 0, self.frame4.size.width, self.frame4.size.width);
//    [self.QZoneShare setBackgroundImage:[UIImage imageNamed:@"QQ空间"] forState:UIControlStateNormal];
    [self.QZoneView addSubview:self.QZoneShare];
    
    if (app.QQIsInstall) {
        self.QQLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.QQShare.left - self.QQShare.width * 0.25, self.QQShare.bottom, self.QQShare.width * 1.5, 24 * HEIGHT_NIT)];
//        self.QQLabel.text = title3;
        self.QQLabel.font = NORML_FONT(12 * WIDTH_NIT);
        self.QQLabel.textAlignment = NSTextAlignmentCenter;
        self.QQLabel.textColor = HexStringColor(@"#ffffff");
        [self.QQView addSubview:self.QQLabel];
        
        PopShareButton *QQButton = [PopShareButton buttonWithType:UIButtonTypeCustom];
        [self.QQView addSubview:QQButton];
        QQButton.frame = CGRectMake(self.QQLabel.left, self.QQShare.top, self.QQLabel.width, self.QQLabel.bottom - self.QQShare.top);
        [QQButton setTitle:title3 forState:UIControlStateNormal];
        [QQButton setImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
        QQButton.tag = 102;
        [QQButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.QZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.QZoneShare.left - self.QZoneShare.width * 0.25, self.QZoneShare.bottom, self.QZoneShare.width * 1.5, 24 * HEIGHT_NIT)];
//        self.QZoneLabel.text = title4;
        self.QZoneLabel.font = NORML_FONT(12 * WIDTH_NIT);
        self.QZoneLabel.textAlignment = NSTextAlignmentCenter;
        self.QZoneLabel.textColor = HexStringColor(@"#ffffff");
        [self.QZoneView addSubview:self.QZoneLabel];
        
        PopShareButton *QZoneButton = [PopShareButton buttonWithType:UIButtonTypeCustom];
        [self.QZoneView addSubview:QZoneButton];
        QZoneButton.frame = CGRectMake(self.QZoneLabel.left, self.QZoneShare.top, self.QZoneLabel.width, self.QZoneLabel.bottom - self.QZoneShare.top);
        QZoneButton.tag = 103;
        [QZoneButton setImage:[UIImage imageNamed:@"QQ空间"] forState:UIControlStateNormal];
        [QZoneButton setTitle:title4 forState:UIControlStateNormal];
        [QZoneButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    self.weiboView = [UIView new];
    self.weiboView.backgroundColor = [UIColor clearColor];
    self.weiboView.frame = self.frame5;
    [self.shareView addSubview:self.weiboView];
    
    self.weiboShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.weiboShare.frame = CGRectMake(0, 0, self.frame5.size.width, self.frame5.size.width);
//    [self.weiboShare setBackgroundImage:[UIImage imageNamed:@"微博"] forState:UIControlStateNormal];
    self.weiboShare.userInteractionEnabled = NO;
    [self.weiboView addSubview:self.weiboShare];
    
    self.weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.weiboShare.left - self.weiboShare.width * 0.25, self.weiboShare.bottom, self.weiboShare.width * 1.5, 24 * HEIGHT_NIT)];
//    self.weiboLabel.text = title5;
    self.weiboLabel.font = NORML_FONT(12 * WIDTH_NIT);
    self.weiboLabel.textAlignment = NSTextAlignmentCenter;
    self.weiboLabel.textColor = HexStringColor(@"#ffffff");
    [self.weiboView addSubview:self.weiboLabel];
    
    PopShareButton *weiboButton = [PopShareButton buttonWithType:UIButtonTypeCustom];
    [self.weiboView addSubview:weiboButton];
    weiboButton.frame = CGRectMake(self.weiboLabel.left, self.weiboShare.top, self.weiboLabel.width, self.weiboLabel.bottom - self.weiboShare.top);
    weiboButton.tag = 104;
    [weiboButton setTitle:title5 forState:UIControlStateNormal];
    [weiboButton setImage:[UIImage imageNamed:@"微博"] forState:UIControlStateNormal];
    [weiboButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!app.weiboInstall) {
        self.weiboLabel.hidden = YES;
        self.weiboShare.hidden = YES;
        weiboButton.hidden = YES;
    }
    
    self.urlView = [UIView new];
    self.urlView.backgroundColor = [UIColor clearColor];
    self.urlView.frame = self.frame6;
    [self.shareView addSubview:self.urlView];
    
    self.urlShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.urlShare.frame = CGRectMake(0, 0, self.frame6.size.width, self.frame6.size.width);
//    [self.urlShare setBackgroundImage:[UIImage imageNamed:@"链接"] forState:UIControlStateNormal];
    self.urlShare.userInteractionEnabled = NO;
    [self.urlView addSubview:self.urlShare];
    
    self.urlLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.urlShare.left - self.urlShare.width * 0.25, self.urlShare.bottom, self.urlShare.width * 1.5, 24 * HEIGHT_NIT)];
//    self.urlLabel.text = title6;
    self.urlLabel.font = NORML_FONT(12 * WIDTH_NIT);
    self.urlLabel.textAlignment = NSTextAlignmentCenter;
    self.urlLabel.textColor = HexStringColor(@"#ffffff");
    [self.urlView addSubview:self.urlLabel];
    
    PopShareButton *urlButton = [PopShareButton buttonWithType:UIButtonTypeCustom];
    [self.urlView addSubview:urlButton];
    urlButton.frame = CGRectMake(self.urlLabel.left, self.urlShare.top, self.urlLabel.width, self.urlLabel.bottom - self.urlShare.top);
    urlButton.tag = 105;
    [urlButton setImage:[UIImage imageNamed:@"链接"] forState:UIControlStateNormal];
    [urlButton setTitle:title6 forState:UIControlStateNormal];
//    [urlButton setTitle:title6 forState:UIControlStateHighlighted];
    [urlButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 50 * HEIGHT_NIT, self.width, 0.5)];
//    lineView.backgroundColor = HexStringColor(@"#FFDC74");
//    [self addSubview:lineView];
    
    ShareBottomButton *cancelButton = [ShareBottomButton new];
    cancelButton.frame = CGRectMake(0, self.height - 50 * HEIGHT_NIT, self.width, 50 * HEIGHT_NIT);
    [self addSubview:cancelButton];
    cancelButton.titleLabel.font = JIACU_FONT(15);
    [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:HexStringColor(@"#FFDC74") forState:UIControlStateNormal];
    [cancelButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateHighlighted];
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 分享按钮方法
- (void)shareButtonAction:(UIButton *)sender {
    if (self.shareButtonBlock) {
        self.shareButtonBlock(sender.tag - 100);
    }
    AXGShrareType shareType = 0;
    switch (sender.tag - 100) {
        case 0: {
            shareType = WECHAT_SHARE;
        }
            break;
        case 1: {
            shareType = FREND_SHARE;
        }
            break;
        case 2: {
            shareType = QQ_SHARE;
        }
            break;
        case 3: {
            shareType = QQZONE_SHARE;
        }
            break;
        case 4: {
            shareType = WEIBO_SHARE;
        }
            break;
        case 5: {
            shareType = COPY_SHARE;
        }
            
        default:
            break;
    }
    [ShareManager AXGShare:shareType params:self.shareParams];
}

// 取消按钮方法
- (void)cancelButtonAction:(UIButton *)sender {
    NSLog(@"是否点击");
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    NSLog(@"取消按钮方法");
}




/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
