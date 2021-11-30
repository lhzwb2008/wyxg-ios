//
//  UserSongShareView.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/6/25.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXGHeader.h"
#import "AppDelegate.h"
#import <UMCommon/MobClick.h>
#import "AFNetworking.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "KVNProgress.h"

typedef void(^ShareButtonBlock)(NSInteger index);

typedef void(^CancelBlock)();

@interface UserSongShareView : UIView

@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIView *shareMaskView;

@property (nonatomic, strong) UIView *weChatView;
@property (nonatomic, strong) UIView *friendView;
@property (nonatomic, strong) UIView *QQView;
@property (nonatomic, strong) UIView *QZoneView;
@property (nonatomic, strong) UIView *weiboView;
@property (nonatomic, strong) UIView *urlView;

@property (nonatomic, strong) UIButton *weChatShare;
@property (nonatomic, strong) UIButton *friendShare;
@property (nonatomic, strong) UIButton *QQShare;
@property (nonatomic, strong) UIButton *QZoneShare;
@property (nonatomic, strong) UIButton *weiboShare;
@property (nonatomic, strong) UIButton *urlShare;

@property (nonatomic, strong) UILabel *weChatLabel;
@property (nonatomic, strong) UILabel *friendLabel;
@property (nonatomic, strong) UILabel *QQLabel;
@property (nonatomic, strong) UILabel *QZoneLabel;
@property (nonatomic, strong) UILabel *weiboLabel;
@property (nonatomic, strong) UILabel *urlLabel;

@property (nonatomic, strong) UILabel *shareLable;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, copy) NSString *userId;

@property (nonatomic, copy) NSString *uploadCode;

@property (nonatomic, assign) CGRect frame1;

@property (nonatomic, assign) CGRect frame2;

@property (nonatomic, assign) CGRect frame3;

@property (nonatomic, assign) CGRect frame4;

@property (nonatomic, assign) CGRect frame5;

@property (nonatomic, assign) CGRect frame6;

@property (nonatomic, assign) CGRect preFrame1;

@property (nonatomic, assign) CGRect preFrame2;

@property (nonatomic, assign) CGRect preFrame3;

@property (nonatomic, assign) CGRect preFrame4;

@property (nonatomic, assign) CGRect preFrame5;

@property (nonatomic, assign) CGRect preFrame6;

@property (nonatomic, copy) ShareButtonBlock shareButtonBlock;

@property (nonatomic, copy) CancelBlock cancelBlock;

@property (nonatomic, strong) NSDictionary *shareParams;
/**
 shareParams[@"shareTitle"];
 shareParams[@"shareMp3Url"];
 shareParams[@"shareWebUrl"];
 shareParams[@"shareSongWriter"];
 shareParams[@"shareImage"];
 */

- (instancetype)initWithFrame:(CGRect)frame ShareParams:(NSDictionary *)params;

@end
