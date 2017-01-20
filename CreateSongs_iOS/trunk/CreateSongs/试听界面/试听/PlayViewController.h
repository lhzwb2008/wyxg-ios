//
//  PlayViewController.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/3/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXGHeader.h"
#import <AVFoundation/AVFoundation.h>
#import "LyricTableViewCell.h"
#import "AXGMusicPlayer.h"
#import "MobClick.h"
#import "WXApi.h"
#import "UMSocial.h"
#import "AppDelegate.h"
#import "ToastView.h"
#import "WeiboSDK.h"
#import "CustomeCreateButton.h"
#import "AFNetworking.h"
#import "Masonry.h"
#import "UIView+Common.h"
#import "NSString+Common.h"
#import "KVNProgress.h"
#import "PlayViewCustomProgress.h"
#import "TYView.h"
#import "TYCommonClass.h"
#import "TYHeader.h"
#import "TYCache.h"
#import "PlayAnimatView.h"
#import "UIImage+Extensiton.h"
#import "XMidiPlayer.h"
#import "TYPopView.h"
#import "UIImage+Extensiton.h"
#import "TYRightBtn.h"
#import "RecoderHeader.h"
#import "RecoderClass.h"

#import "UIButton+Extension.h"
#import "STBottomBtn.h"
#import "BaseViewController.h"
#import "TPOscilloscopeLayer.h"
#define Lines 4
#define kSource 6
#define kGenere 4
#define kEmotion 2

#define TY_NAVI_HEIGHT_4s 24
#define TY_NAVI_HEIGHT    44

//#define FIRST_TAG       10
//#define SECOND_TAG      11
//#define THIRD_TAG       12
//#define RECoding_TAG    13
//#define RECoded_TAG     14
//#define BEGINRecod_TAG  15

typedef enum : NSUInteger {
    TY_BTN_TYPE,
    XL_BTN_TYPE,
} Btn_Type;

@class TYView;

@interface PlayViewController : BaseViewController


//@property (nonatomic, strong) UIButton *firstNumber;
//@property (nonatomic, strong) UIButton *secondNumber;
//@property (nonatomic, strong) UIButton *thirdNumber;
//@property (nonatomic, strong) UIButton *recordingView;
//@property (nonatomic, strong) UIButton *recordedDone;
//@property (nonatomic, strong) UIButton *beginRecord;
//@property (nonatomic, strong) UIView *inputView;
//@property (nonatomic, strong) TPOscilloscopeLayer *inputOscilloscope;
//
//@property (nonatomic, assign) BOOL isAutoToEnd;
//@property (nonatomic, assign) BOOL shouldDone;
//@property (nonatomic, copy) NSString *finalPath;
//@property (nonatomic, strong) NSData *recoderData;
//@property (nonatomic, assign) BOOL isFirstPlay;
//@property (nonatomic, copy) NSString *playMp3Url;

/**
 *  歌词高度
 */
@property (nonatomic, assign) CGFloat cellHeight;
/**
 *  歌名
 */
@property (nonatomic, copy) NSString *titleStr;
/**
 *  返回按钮
 */
@property (nonatomic, strong) UIButton *backButton;
/**
 *  歌名视图
 */
@property (nonatomic, strong) UILabel *titleLabel;
/**
 *  歌词所在视图
 */
@property (nonatomic, strong) UITableView *tableView;
/**
 *  歌词数据源数组
 */
@property (nonatomic, strong) NSMutableArray *lyricDataSource;
/**
 *  播放器对象
 */
@property (nonatomic, strong) AXGMusicPlayer *player;
/**
 *  是否在播放
 */
@property (nonatomic, assign) BOOL isPlaying;
/**
 *  歌曲播放地址
 */
@property (nonatomic, copy) NSString *mp3Url;
/**
 *  歌曲分享地址
 */
@property (nonatomic, copy) NSString *webUrl;
/**
 *  用于实时获取播放时间的观察者对象
 */
@property (nonatomic, weak) id observer;
@property (nonatomic, assign) BOOL isEnd;
@property (nonatomic, assign) BOOL isLoading;

@property (nonatomic, strong) NSString *requestURL;//此地址后边带参数符号 & 所以直接拼接请求
/**
 *  主唱
 */
@property (nonatomic, assign) NSInteger source;
/**
 *  音乐类型
 */
@property (nonatomic, assign) NSInteger genere;
/**
 *  心情
 */
@property (nonatomic, assign) NSInteger emotion;


@property (nonatomic, assign) CGFloat  songSpeed;

@property (nonatomic, strong) NSData *midiData;

@property (nonatomic, copy) NSString *lyricContent;
@property (nonatomic, copy) NSString *postMidiName;
@property (nonatomic, copy) NSString *midiFileName;

@property (nonatomic, copy) NSString *changeSingerAPIName;

/**
 *  调音页面用男的还是女的  1 男  2 女
 */
@property (nonatomic, assign) NSInteger tyViewShowType;


@property (nonatomic, strong) UIView *tyGuidView;
/**
 *  保证点击重复按钮的不相应的临时变量
 */
@property (nonatomic, assign) NSInteger tmpIndex;

@property (nonatomic, strong) TYView *tyView;

@property (nonatomic, assign) BOOL needShowError;

@property (nonatomic, assign) NSInteger currentRow;

@property (nonatomic, strong) AFHTTPSessionManager *manager;
/**
 *  小圆点
 */
@property (nonatomic, strong) UIView *littleView;

@property (nonatomic, strong) PlayViewCustomProgress *customProgressView;

@property (nonatomic, strong) UIView *firstBgView;
@property (nonatomic, strong) UIView *secondBgView;


@property (nonatomic, strong) UIScrollView *zoomScrollVeiw;
// 歌曲总时间
@property (nonatomic, assign) CGFloat totalTime;
// 选中的歌曲行数
@property (nonatomic, assign) NSInteger selectedSentenceIndex;
// 是否是被修改过的歌曲
@property (nonatomic, assign) BOOL isChanged;
// 能否进入调音界面
@property (nonatomic, assign) BOOL midiIsReady;

//@property (nonatomic, assign) BOOL midiViewIsReady;
@property (nonatomic, assign) BOOL playerIsReady;

@property (nonatomic, strong) TYPopView *tyPopView;

@property (nonatomic, strong) UILabel *tySentenceLabel;

@property (nonatomic, strong) UIImageView *tyTitleBtn;

// 第十一句之前的标题尺寸
@property (nonatomic, assign) CGRect titleNormalFrame;
// 第十一句之后的标题尺寸，这时候如果还按照之前的会显示不全
@property (nonatomic, assign) CGRect titleChangeFrame;

@property (nonatomic, assign) CGRect titleBtnNormalFrame;
@property (nonatomic, assign) CGRect titleBtnChangeFrame;


@property (nonatomic, assign) NSInteger currentTyIndex;

// 右边切换8/16分音符按钮
@property (nonatomic, strong) TYRightBtn *tyRightBtn;

// 点击用来隐藏切换句数视图的view
@property (nonatomic, strong) UIView *maskHideView;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UIButton *banzouBtn;
@property (nonatomic, strong) UIButton *gaiquBtn;
@property (nonatomic, strong) UIButton *yanchangBtn;
@property (nonatomic, strong) UIButton *mixVoiceBtn;
@property (nonatomic, strong) UIButton *restartRecorder;
@property (nonatomic, strong) UIButton *shitingRecoBtn;

@property (nonatomic, strong) UILabel *navTitleLabel;

@property (nonatomic, assign) BOOL allowTY;

@property (nonatomic, assign) Btn_Type btnType;


/********************************/
#pragma mark - 试听页面变量
/*
 xqc.zouyinUrl = @{@"title":self.tianciName,
 @"content":content,
 @"id":self.itemModel.id,
 @"singer":self.itemModel.singer};
 
 xqc.lyricDataSource = self.finalLyricArray;
 xqc.isFirstPlay = YES;
 xqc.isFromPlayView = NO;
 xqc.isFromTianciPage = YES;
 xqc.isFirstGetZouyinMp3 = YES;
 xqc.titleStr = self.tianciName;
 xqc.songName = xqc.titleStr;
 xqc.requestHeadName = self.requestHeadName;
 xqc.zouyin_banzouUrl = self.itemModel.acc_mp3;
 */
#if XUANQU_FROME_NET
@property (nonatomic, strong) NSDictionary *zouyinUrl;
#elif !XUANQU_FROME_NET
@property (nonatomic, copy) NSString *zouyinUrl;
#endif
@property (nonatomic, assign) BOOL isFirstPlay;
@property (nonatomic, assign) BOOL isFromPlayView;
@property (nonatomic, assign) BOOL isFromTianciPage;
@property (nonatomic, assign) BOOL isFirstGetZouyinMp3;
@property (nonatomic, copy) NSString *songName;
@property (nonatomic, copy) NSString *requestHeadName;//时间轴
@property (nonatomic, copy) NSString *zouyin_banzouUrl;
@property (nonatomic, strong) NSMutableArray *lrcTimeArray;

/**
 *  歌曲缩写名(读取本地曲目使用)
 */
@property (nonatomic, copy) NSString *requestSongName;
/********************************/

+ (instancetype)sharePlayVC;

- (void)getRow;

- (void)removeOldTyView;

- (void)playDelegate;
- (void)sliderValueChanged:(CGFloat)value;

- (void)pause;
- (void)play;

- (void)changeBtnType:(Btn_Type)btnType;

- (void)createLyric;
- (void)sendRightBtnClick:(UIButton *)btn;

@end
