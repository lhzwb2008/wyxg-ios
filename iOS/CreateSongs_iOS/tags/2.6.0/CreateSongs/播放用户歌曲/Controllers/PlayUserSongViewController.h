//
//  PlayUserSongViewController.h
//  CreateSongs
//
//  Created by axg on 16/3/19.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import "AXGMusicPlayer.h"
#import "BaseViewController.h"
#import <Security/Security.h>

@class MidiParserManager;
@class RecoderController;

@interface PlayUserSongViewController :UIViewController

@property (nonatomic, strong) NSTimer *flowerTimer;
@property (nonatomic, strong) NSMutableArray *imagesArray;

@property (nonatomic, copy) NSString *lyricURL;
@property (nonatomic, copy) NSString *soundURL;
@property (nonatomic, copy) NSString *soundName;


@property (nonatomic, assign) BOOL barrageIsInit;

@property (nonatomic, assign) NSInteger listenCount;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) AXGMusicPlayer *musicPlayer;

@property (nonatomic, strong) UIImage *themeImage;

@property (nonatomic, strong) UIImageView *themeImageView;

@property (nonatomic, strong) UILabel *playCountsLabel;

@property (nonatomic, strong) UIButton *playButton;

@property (nonatomic, strong) UIButton *barageBtn;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) UIImageView *playImage;

@property (nonatomic, assign) BOOL needReload;

// 时间监听
@property (nonatomic, weak) id observer;

@property (nonatomic, strong) UIView *naviView;

@property (nonatomic, strong) UILabel *songName;

@property (nonatomic, strong) UILabel *playCount;
/**
 *  顶部图片和歌词所在view
 */
@property (nonatomic, strong) UIView *topView;

/**
 *  歌曲创作时间
 */
@property (nonatomic, strong) UILabel *createTime;
@property (nonatomic, copy) NSString *createTimeStr;

@property (nonatomic, copy) NSString *user_id;
@property (nonatomic, copy) NSString *song_id;

@property (nonatomic, copy) NSString *user_phone;

@property (nonatomic, copy) NSString *loveCount;

@property (nonatomic, copy) NSString *songCode;

@property (nonatomic, strong) NSMutableDictionary *userInfoDataSource;

@property (nonatomic, copy) NSString *userName;
@property (nonatomic, copy) NSString *gender;

@property (nonatomic, strong) MidiParserManager *midiParserManager;

@property (nonatomic, assign) NSInteger currentTmpIndex;

@property (nonatomic, assign) NSInteger currentGiftBarrageIndex;

@property (nonatomic, assign) BOOL shouldSendBarrage;

@property (nonatomic, assign) CGFloat tmpOffsetY;

@property (nonatomic, assign) BOOL shouldPlay;

@property (nonatomic, strong) RecoderController *rvc;

@property (nonatomic, strong) UIButton *tapMaskView;

@property (nonatomic, strong) UIView *backMaskView;


#pragma mark - 头部个人用户信息
@property (nonatomic, strong) UIImageView *userHeadImage;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIButton *focusBtn;
@property (nonatomic, strong) UIImageView *genderImageView;


@property (nonatomic, copy) NSString *time_file_string;
@property (nonatomic, strong) NSMutableArray *lrcTimeArray;
@property (nonatomic, assign) NSInteger tmpMark;
/**
 self.soundName = @"七夕";
 self.listenCount = 1234;
 self.user_id = @"20590";
 self.createTimeStr = @"2016-07-16 19:14:27";
 self.loveCount = @"4321";
 self.song_id = @"22958";
 self.needReload = YES;
 self.songCode = @"f5a13eca90cbe22dd8a3c412e941e61e_6";
 */


@end
