//
//  AppDelegate.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/13.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class AEAudioController;
@class DrawerViewController;
@class MMDrawerController;
//#import "CreateSongs-Swift.h"
@class KYDrawerController;

typedef enum : NSUInteger {
    wxShare,
    wxFriend,
    QQShare,
    QZoneShare
} ShareType;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (nonatomic, assign) CGFloat currentY;
@property (nonatomic, assign) float minVolume;

@property (nonatomic, assign) CGFloat personVolume;
@property (nonatomic, assign) CGFloat banzouVolume;

@property (nonatomic, assign) CGFloat midiPlayVolume;

@property (strong, nonatomic) UIWindow *window;

@property (nonatomic, strong) AEAudioController *audioController;

@property (nonatomic, strong) MMDrawerController *drawController;

@property (nonatomic, strong) DrawerViewController *drawerVC;

@property (nonatomic, strong) KYDrawerController *kyDrawer;

@property (nonatomic, copy) NSString *activityId;


/**
 *  播放设备是否已经初始化
 */
@property (nonatomic, assign) BOOL deviceIsReady;

@property (nonatomic, assign) BOOL noteIsChanged;


@property (nonatomic, assign) BOOL wxIsInstall;//在其他地方直接访问此属性判断是否安装微信

@property (nonatomic, assign) BOOL QQIsInstall;//在其他地方直接访问此属性判断是否安装微信

@property (nonatomic, assign) BOOL weiboInstall;//在其他地方直接访问此属性判断是否安装微博

@property (strong, nonatomic) NSString *wbtoken;//使用微博官方API用到的token


@property (nonatomic, assign) ShareType ShareType;//分享类型

@property (nonatomic, assign) BOOL willShowShareToast;

/**
 *  歌曲标签  演唱 改曲
 */
@property (nonatomic, copy) NSString *song_tag;

/**
 *  歌曲id
 */
@property (nonatomic, copy) NSString *songId;

/**
 *  歌曲名称
 */
@property (nonatomic, copy) NSString *songTitle;

/**
 *  歌曲code
 */
@property (nonatomic, copy) NSString *songCode;

/**
 *  原始歌名
 */
@property (nonatomic, copy) NSString *originSongName;

/**
 *  作词
 */
@property (nonatomic, copy) NSString *lyricWriter;

/**
 *  作曲
 */
@property (nonatomic, copy) NSString *songWriter;

/**
 *  演唱者
 */
@property (nonatomic, copy) NSString *songSinger;

@property (nonatomic, assign) BOOL isFanChang;

/**
 *  微博的uid
 */
@property (nonatomic, copy) NSString *weiboUid;
/**
 *  微博的token
 */
@property (nonatomic, copy) NSString *weiboToken;

/**
 *  微信的code
 */
@property (nonatomic, copy) NSString *weChatCode;

/**
 *  是否从推送登录
 */
@property (nonatomic, assign) BOOL isLaunchedByNotification;
/**
 *  登录信息
 */
@property (nonatomic, strong) NSDictionary *remoteNotification;
/**
 *  是否从浏览器打开
 */
@property (nonatomic, assign) BOOL isLaunchedBySafari;
/**
 *  从浏览器打开的参数
 */
@property (nonatomic, copy) NSString *safariString;

/**
 *  走音功能模块上传歌曲需要传入此参数，用于获取时间文件
 */
@property (nonatomic, copy) NSString *template_id;

@property (nonatomic, assign) BOOL rankDataShouldRefresh;

@end

