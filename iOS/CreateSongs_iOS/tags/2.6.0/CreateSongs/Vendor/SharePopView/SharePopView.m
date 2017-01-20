//
//  SharePopView.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/25.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SharePopView.h"
#import "AXGHeader.h"
#import "AppDelegate.h"

#define BOTTOM_HEIGHT 184 * HEIGHT_NIT

#define ANIMAT_TIME 0.3

@implementation SharePopView

static SharePopView *popView = nil;
+ (instancetype)defaultPopView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        popView = [[SharePopView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return popView;
}

+ (void)popShareViewOnView:(UIView *)view {
    SharePopView *popView = [SharePopView defaultPopView];
    [popView createShareView];
    [view addSubview:popView];
    
    [UIView animateWithDuration:ANIMAT_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        popView.shareView.frame = CGRectMake(0, popView.height - BOTTOM_HEIGHT, popView.width, BOTTOM_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
    
}

// 创建分享页面
- (void)createShareView {
    
    self.shareMaskView = [[UIView alloc] initWithFrame:self.bounds];
    self.shareMaskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    [self addSubview:self.shareMaskView];
    self.shareMaskView.alpha = 1;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(maskDidTap:)];
    [self.shareMaskView addGestureRecognizer:tap];
    
    self.shareView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height, self.width, BOTTOM_HEIGHT)];
    [self addSubview:self.shareView];
    self.shareView.backgroundColor = HexStringColor(@"#dbdbdb");
    
    self.shareLable = [[UILabel alloc] initWithFrame:CGRectMake(0, 12 * HEIGHT_NIT, self.width, 15 * HEIGHT_NIT)];
    self.shareLable.text = @"分享到";
    self.shareLable.textColor = HexStringColor(@"#535353");
    self.shareLable.font = JIACU_FONT(15 * HEIGHT_NIT);
    self.shareLable.textAlignment = NSTextAlignmentCenter;
    self.shareLable.center = CGPointMake(self.centerX, self.shareLable.centerY);
    [self.shareView addSubview:self.shareLable];
    
    CGRect frame1;// 微信
    CGRect frame2;// 朋友圈
    CGRect frame3;// QQ
    CGRect frame4;// qq空间
    CGRect frame5;// 新浪微博
    NSString *title1 = nil;
    NSString *title2 = nil;
    NSString *title3 = nil;
    NSString *title4 = nil;
    NSString *title5 = nil;
    
    title1 = @"微信";
    title2 = @"朋友圈";
    title3 = @"QQ";
    title4 = @"QQ空间";
    title5 = @"微博";
    
    CGFloat leftGap = 25 * WIDTH_NIT;
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    
    if (app.wxIsInstall == YES && app.QQIsInstall == YES) {
        
        frame1 = CGRectMake(leftGap, self.shareLable.bottom + 20 * HEIGHT_NIT, 41 * HEIGHT_NIT, 41 * HEIGHT_NIT);
        frame2 = CGRectMake(frame1.origin.x + frame1.size.width + 30 * WIDTH_NIT, frame1.origin.y, 41 * HEIGHT_NIT, 41 * HEIGHT_NIT);
        frame3 = CGRectMake(frame2.origin.x + frame2.size.width + 30 * WIDTH_NIT, frame1.origin.y, 41 * HEIGHT_NIT, 41 * HEIGHT_NIT);
        frame4 = CGRectMake(frame3.origin.x + frame3.size.width + 30 * WIDTH_NIT, frame1.origin.y, 41 * HEIGHT_NIT, 41 * HEIGHT_NIT);
        frame5 = CGRectMake(frame4.origin.x + frame4.size.width + 30 * WIDTH_NIT, frame1.origin.y, 41 * HEIGHT_NIT, 41 * HEIGHT_NIT);
        
    } else if (app.wxIsInstall == NO && app.QQIsInstall == YES) {
        frame1 = CGRectZero;
        frame2 = CGRectZero;
        frame3 = CGRectMake(leftGap, self.shareLable.bottom + 20 * HEIGHT_NIT, 41 * HEIGHT_NIT, 41 * HEIGHT_NIT);
        frame4 = CGRectMake(frame3.origin.x + frame3.size.width + 30 * WIDTH_NIT, frame3.origin.y, 41 * HEIGHT_NIT, 41 * HEIGHT_NIT);
        frame5 = CGRectMake(frame4.origin.x + frame4.size.width + 30 * WIDTH_NIT, frame3.origin.y, 41 * HEIGHT_NIT, 41 * HEIGHT_NIT);
    } else if (app.wxIsInstall == YES && app.QQIsInstall == NO) {
        frame1 = CGRectMake(leftGap, self.shareLable.bottom + 20 * HEIGHT_NIT, 41 * HEIGHT_NIT, 41 * HEIGHT_NIT);
        frame2 = CGRectMake(frame1.origin.x + frame1.size.width + 30 * WIDTH_NIT, frame1.origin.y, 41 * HEIGHT_NIT, 41 * HEIGHT_NIT);
        frame3 = CGRectZero;
        frame4 = CGRectZero;
        frame5 = CGRectMake(frame2.origin.x + frame2.size.width + 30 * WIDTH_NIT, self.shareLable.bottom + 20 * HEIGHT_NIT, 41 * HEIGHT_NIT, 41 * HEIGHT_NIT);
    } else {
        frame1 = CGRectZero;
        frame2 = CGRectZero;
        frame3 = CGRectZero;
        frame4 = CGRectZero;
        frame5 = CGRectMake(leftGap, self.shareLable.bottom + 20 * HEIGHT_NIT, 41 * HEIGHT_NIT, 41 * HEIGHT_NIT);
    }
    
    self.weChatShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.weChatShare.userInteractionEnabled = NO;
    self.weChatShare.frame = frame1;
    [self.weChatShare setBackgroundImage:[UIImage imageNamed:@"微信"] forState:UIControlStateNormal];
    
    self.friendShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.friendShare.userInteractionEnabled = NO;
    self.friendShare.frame = frame2;
    [self.friendShare setBackgroundImage:[UIImage imageNamed:@"朋友圈"] forState:UIControlStateNormal];

    if (app.wxIsInstall) {
        self.weChatLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.weChatShare.left - self.weChatShare.width * 0.25, self.weChatShare.bottom + 8 * HEIGHT_NIT, self.weChatShare.width * 1.5, 15 * HEIGHT_NIT)];
        self.weChatLabel.text = title1;
        self.weChatLabel.font = NORML_FONT(12 * WIDTH_NIT);
        self.weChatLabel.textAlignment = NSTextAlignmentCenter;
        self.weChatLabel.textColor = HexStringColor(@"#535353");
        
        [self.shareView addSubview:self.weChatShare];
        [self.shareView addSubview:self.weChatLabel];
        
        UIButton *weChatButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareView addSubview:weChatButton];
        weChatButton.frame = CGRectMake(self.weChatLabel.left, self.weChatShare.top, self.weChatLabel.width, self.weChatLabel.bottom - self.weChatShare.top + 10 * HEIGHT_NIT);
        weChatButton.tag = 100;
        [weChatButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.friendShare.left - self.friendShare.width * 0.25, self.friendShare.bottom + 8 * HEIGHT_NIT, self.friendShare.width * 1.5, 15 * HEIGHT_NIT)];
        self.friendLabel.text = title2;
        self.friendLabel.font = NORML_FONT(12 * WIDTH_NIT);
        self.friendLabel.textAlignment = NSTextAlignmentCenter;
        self.friendLabel.textColor = HexStringColor(@"#535353");
        
        [self.shareView addSubview:self.friendShare];
        [self.shareView addSubview:self.friendLabel];
        
        UIButton *friendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareView addSubview:friendButton];
        friendButton.frame = CGRectMake(self.friendLabel.left, self.friendShare.top, self.friendLabel.width, self.friendLabel.bottom - self.friendShare.top);
        friendButton.tag = 101;
        [friendButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];

        
    }
    
    self.QQShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.QQShare.userInteractionEnabled = NO;
    self.QQShare.frame = frame3;
    [self.QQShare setBackgroundImage:[UIImage imageNamed:@"QQ"] forState:UIControlStateNormal];
    [self.shareView addSubview:self.QQShare];
    
    self.QZoneShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.QZoneShare.userInteractionEnabled = NO;
    self.QZoneShare.frame = frame4;
    [self.QZoneShare setBackgroundImage:[UIImage imageNamed:@"QQ空间"] forState:UIControlStateNormal];
    [self.shareView addSubview:self.QZoneShare];
    
    if (app.QQIsInstall) {
        self.QQLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.QQShare.left - self.QQShare.width * 0.25, self.QQShare.bottom + 8 * HEIGHT_NIT, self.QQShare.width * 1.5, 15 * HEIGHT_NIT)];
        self.QQLabel.text = title3;
        self.QQLabel.font = NORML_FONT(12 * WIDTH_NIT);
        self.QQLabel.textAlignment = NSTextAlignmentCenter;
        self.QQLabel.textColor = HexStringColor(@"#535353");
        [self.shareView addSubview:self.QQLabel];
        
        UIButton *QQButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareView addSubview:QQButton];
        QQButton.frame = CGRectMake(self.QQLabel.left, self.QQShare.top, self.QQLabel.width, self.QQLabel.bottom - self.QQShare.top);
        QQButton.tag = 102;
        [QQButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
        self.QZoneLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.QZoneShare.left - self.QZoneShare.width * 0.25, self.QZoneShare.bottom + 8 * HEIGHT_NIT, self.QZoneShare.width * 1.5, 15 * HEIGHT_NIT)];
        self.QZoneLabel.text = title4;
        self.QZoneLabel.font = NORML_FONT(12 * WIDTH_NIT);
        self.QZoneLabel.textAlignment = NSTextAlignmentCenter;
        self.QZoneLabel.textColor = HexStringColor(@"#535353");
        [self.shareView addSubview:self.QZoneLabel];
        
        UIButton *QZoneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [self.shareView addSubview:QZoneButton];
        QZoneButton.frame = CGRectMake(self.QZoneLabel.left, self.QZoneShare.top, self.QZoneLabel.width, self.QZoneLabel.bottom - self.QZoneShare.top);
        QZoneButton.tag = 103;
        [QZoneButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
        
    }
    
    self.weiboShare = [UIButton buttonWithType:UIButtonTypeSystem];
    self.weiboShare.frame = frame5;
    [self.weiboShare setBackgroundImage:[UIImage imageNamed:@"微博"] forState:UIControlStateNormal];
    self.weiboShare.userInteractionEnabled = NO;
    [self.shareView addSubview:self.weiboShare];
    
    self.weiboLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.weiboShare.left - self.weiboShare.width * 0.25, self.weiboShare.bottom + 8 * HEIGHT_NIT, self.weiboShare.width * 1.5, 15 * HEIGHT_NIT)];
    self.weiboLabel.text = title5;
    self.weiboLabel.font = NORML_FONT(12 * WIDTH_NIT);
    self.weiboLabel.textAlignment = NSTextAlignmentCenter;
    self.weiboLabel.textColor = HexStringColor(@"#535353");
    [self.shareView addSubview:self.weiboLabel];
    
    UIButton *weiboButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.shareView addSubview:weiboButton];
    weiboButton.frame = CGRectMake(self.weiboLabel.left, self.weiboShare.top, self.weiboLabel.width, self.weiboLabel.bottom - self.weiboShare.top);
    weiboButton.tag = 104;
    [weiboButton addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    if (!app.weiboInstall) {
        self.weiboLabel.hidden = YES;
        self.weiboShare.hidden = YES;
        weiboButton.hidden = YES;
    }
    
    self.closeButton = [UIButton new];
    [self.shareView addSubview:self.closeButton];
    self.closeButton.backgroundColor = [UIColor whiteColor];
    [self.closeButton setTitle:@"取消" forState:UIControlStateNormal];
    self.closeButton.titleLabel.font = JIACU_FONT(18 * HEIGHT_NIT);
    [self.closeButton setTitleColor:HexStringColor(@"#535353") forState:UIControlStateNormal];
    self.closeButton.frame = CGRectMake(0, self.shareView.height - 44 * HEIGHT_NIT, self.shareView.width, 44 * HEIGHT_NIT);
    [self.closeButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

// 分享按钮方法
- (void)shareButtonAction:(UIButton *)sender {
    if (self.shareBlock) {
        self.shareBlock(sender.tag - 100);
    }
}

// 取消按钮方法
- (void)cancelButtonAction:(UIButton *)sender {
    [self hideAction];
}

// 背景点击隐藏方法
- (void)maskDidTap:(UITapGestureRecognizer *)tap {
    [self hideAction];
}

// 隐藏方法
- (void)hideAction {
    
    SharePopView *popView = [SharePopView defaultPopView];
    
    [UIView animateWithDuration:ANIMAT_TIME delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        popView.shareView.frame = CGRectMake(0, popView.height, popView.width, BOTTOM_HEIGHT);
        popView.shareMaskView.alpha = 0;
    } completion:^(BOOL finished) {
        [popView removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
