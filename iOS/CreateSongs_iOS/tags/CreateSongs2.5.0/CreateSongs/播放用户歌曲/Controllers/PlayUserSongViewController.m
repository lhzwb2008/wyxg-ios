//
//  PlayUserSongViewController.m
//  CreateSongs
//
//  Created by axg on 16/3/19.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PlayUserSongViewController.h"
#import "AXGHeader.h"
#import "MobClick.h"
#import "YSLTransitionAnimator.h"
#import "UIViewController+YSLTransition.h"
#import "UIView+Common.h"
#import "AXGHeader.h"
#import "Masonry.h"
#import "LyricTableViewCell.h"
#import "MBProgressHUD+MJ.h"
#import "UIImageView+WebCache.h"
#import "UserModel.h"
#import "NSString+Common.h"
#import "KVNProgress.h"
#import "PlayUserSongCommentCell.h"
#import "ReplyInputView.h"
#import "PlayUserSongCustomProgressView.h"
#import "PlayUserSongUserCell.h"
#import "PlayUserSongLyricCell.h"
#import "CommentUserModel.h"
#import "KeychainItemWrapper.h"
#import "LyricCellFrameModel.h"
#import "BarrageRenderer.h"
#import "NSSafeObject.h"
#import "UIImage+Extensiton.h"
#import "LXMLyricsLabel.h"
#import "OtherPersonCenterController.h"
#import "PlayUserSongNoneDataCell.h"
#import "MidiParser.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "MBProgressHUD.h"
#import "NSString+Emojize.h"
//#import "MessageIdentifyViewController.h"
#import "UserSongShareView.h"
#import "WXApi.h"
#import "UMSocial.h"
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "BarrageCustomBtn.h"
#import "LoginViewController.h"
#import <Security/Security.h>
#import "MidiParserManager.h"
#import "TYCommonClass.h"
#import "RecoderClass.h"
#import "RecoderController.h"
#import "AXGTools.h"
#import "BarrageWalkTextSprite.h"
#import "BarrageSpriteWithHead.h"
#import "PaySureController.h"
#import "PaySuccessView.h"
#import "BarrageWithFlowers.h"
#import "GiftInfoModel.h"
#import "GiftUserModel.h"
#import "GiftRankTableViewCell.h"
#import "GiftRankViewController.h"
#import "SongModel.h"
#import "MembersTableViewCell.h"

static NSString *const giftRankIdentifier = @"giftRankIdentifier";
static NSString *const memberIdentifier = @"memberIdentifier";

#define SHAREVIEW_HEIGHT ((50 * WIDTH_NIT + 6 * HEIGHT_NIT + 12 * HEIGHT_NIT + 30 * HEIGHT_NIT) * 2 + 10 * HEIGHT_NIT + 33.5 * HEIGHT_NIT)
#define IMAGENAMED(NAME)        [UIImage imageNamed:NAME]

#define SNOW_IMAGENAME         @"图层-%u"
// MainScreen Height&Width
#define Main_Screen_Height      [[UIScreen mainScreen] bounds].size.height
#define Main_Screen_Width       [[UIScreen mainScreen] bounds].size.width
#define IMAGE_X                arc4random()%(int)Main_Screen_Width
//#define IMAGE_X                 arc4random()%15
#define IMAGE_ALPHA            ((float)(arc4random()%10))/10
#define IMAGE_WIDTH            arc4random()%20 + 10
#define PLUS_HEIGHT            Main_Screen_Height/25

@interface PlayUserSongViewController ()<YSLTransitionAnimatorDataSource, UIGestureRecognizerDelegate, UITableViewDataSource, UITableViewDelegate, ParserProtocol, WXApiDelegate, UMSocialUIDelegate>

@property (nonatomic, assign) BOOL isEnd;

@property (nonatomic, strong) UIView *bottomNavView;

@property (nonatomic, strong) UIView *tableViewHeadView;

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *commentsframeArray;

@property (nonatomic, strong) ReplyInputView *replyInputView;

@property (nonatomic, copy) NSString *preCommenter;

@property (nonatomic, assign) BOOL flag;  //用于键盘出现时函数调用多次的情况

@property (nonatomic, strong) PlayUserSongCustomProgressView *progressView;

@property (nonatomic, assign) CGFloat maxOffset;

@property (nonatomic, assign) BOOL isFocus;

@property (nonatomic, assign) BOOL isFocusAtLast;

@property (nonatomic, assign) BOOL isLike;

@property (nonatomic, assign) BOOL isLikeAtLast;


@property (nonatomic, strong) LyricCellFrameModel *lyricFrameModel;

/**
 *  用于判断向上还是向下滑动的中间量
 */
@property (nonatomic, assign) CGFloat markOffset;

@property (nonatomic, assign) BOOL isSendComment;

@property (nonatomic, strong) BarrageRenderer *renderer;

/**
 *  当前显示的弹幕（评论）下标
 */
@property (nonatomic, assign) NSInteger currentIndex;
/**
 *  记录暂停时的弹幕下标
 */
@property (nonatomic, assign) NSInteger toolIndex;

@property (nonatomic, copy) NSString *commentStr;

@property (nonatomic, strong) NSTimer *timer;

@property (nonatomic, strong) UIImage *openImage;
@property (nonatomic, strong) UIImage *closeImage;

/**
 *  被回复人id
 */
@property (nonatomic, copy) NSString *commenterId;

/**
 *  是否显示弹幕
 */
@property (nonatomic, assign) BOOL shouldShowBarrage;

@property (nonatomic, strong) LXMLyricsLabel *lyricsView;

@property (nonatomic, strong) NSTimer *lyricTimer;

@property (nonatomic, copy) NSString *curretnLyric;
@property (nonatomic, assign) CGFloat sentenceTime;
@property (nonatomic, assign) CGFloat totalTime;
@property (nonatomic, strong) MidiParser *midiParser;

/**
 *  分享界面
 */
@property (nonatomic, strong) UserSongShareView *shareView;
@property (nonatomic, strong) UIView *shareMaskView;

// 礼物榜用户
@property (nonatomic, strong) NSMutableArray *giftUserDataSource;

@property (nonatomic, strong) SongModel *songModel;

@property (nonatomic, strong) UILabel *listenLabel;
@property (nonatomic, strong) UIImageView *erjiImageView;

@property (nonatomic, strong) UILabel *navTitleLabel;

@end

#define HOME_HEAD_IMGH  310
#define BLU_MASK_COLOR [UIColor colorWithWhite:0.000 alpha:0.0]
#define MAIN_BLU_COLOR [UIColor colorWithWhite:0.000 alpha:0.10]

/**
 *  评论所在的cell对应得indexPathRow
 */
#define COMMENT_TAG 2

#define ALLOW_BARRAGE   1

@implementation PlayUserSongViewController

- (void)dealloc {
    [self removeNotification];
#if ALLOW_BARRAGE
    [_renderer stop];
    
    [_timer invalidate];
    
    _timer = nil;
#endif
    [_lyricTimer setFireDate:[NSDate distantFuture]];
    
    [_lyricTimer invalidate];
    
    _lyricTimer = nil;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"wxPayResult"];
    }
    return self;
}

#pragma mark - *************懒加载**************

- (UIImageView *)themeImageView {
    if (_themeImageView == nil) {
        _themeImageView = [UIImageView new];
        _themeImageView.clipsToBounds = NO;
        _themeImageView.backgroundColor = [UIColor clearColor];
        _themeImageView.frame = CGRectMake(0, 64, width(self.view), HOME_HEAD_IMGH * HEIGHT_NIT);
//        _themeImageView.image = _themeImage;
//        _themeImageView.image = [UIImage imageNamed:@"个人中心背景"];
        _themeImageView.userInteractionEnabled = YES;
        
        _playImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60 * WIDTH_NIT, 60 * WIDTH_NIT)];
        _playImage.center = _themeImageView.center;
        _playImage.centerY = _themeImageView.centerY - _themeImageView.top;
        [self play];
        _playImage.userInteractionEnabled = NO;
        [_themeImageView addSubview:_playImage];
        
        _progressView = [[PlayUserSongCustomProgressView alloc] initWithFrame:CGRectMake(0, _themeImageView.height - 40 * WIDTH_NIT, width(_themeImageView), 40 * WIDTH_NIT)];
        [_themeImageView addSubview:_progressView];
        [_progressView setProgress:0.0f withAnimated:NO];
        WEAK_SELF;
        _progressView.playBtnBlock = ^(BOOL isPlaying) {
            STRONG_SELF;
            [self pauseAction];
            self.isPlaying = NO;
        };
        _progressView.sliderDidChangedBlock = ^(CGFloat value){
            STRONG_SELF;
            [self sliderValueChanged:value];
        };
        
        _lyricsView = [[LXMLyricsLabel alloc] initWithFrame:CGRectMake(0, _progressView.bottom, width(self.view), 40 * HEIGHT_NIT)];
        _lyricsView.backgroundColor = [UIColor colorWithHexString:@"#1b1b1b"];
//        _lyricsView.backgroundColor = [UIColor redColor];
        [_lyricsView setFont:NORML_FONT(15*WIDTH_NIT)];
        [_lyricsView setTextAlignment:NSTextAlignmentCenter];
        [_themeImageView addSubview:_lyricsView];
        
        
        UILabel *playCount = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 16 * WIDTH_NIT - 100 * WIDTH_NIT, self.lyricsView.top, 100 * WIDTH_NIT, self.lyricsView.height)];
        [_themeImageView addSubview:playCount];
        
        if (self.listenCount > 10000) {
            playCount.text = [NSString stringWithFormat:@"%.2f万", self.listenCount / 10000.0];
        } else {
            playCount.text = [NSString stringWithFormat:@"%ld", self.listenCount];
        }
        
        playCount.textAlignment = NSTextAlignmentRight;
        playCount.textColor = HexStringColor(@"#ffdc74");
        playCount.font = NORML_FONT(10);
        
        self.listenLabel = playCount;
        
        CGFloat width = [AXGTools getTextWidth:playCount.text font:playCount.font];
        
        UIImageView *erjiImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - width - 16 * WIDTH_NIT - 5 * WIDTH_NIT - 15 * WIDTH_NIT, 0, 15 * WIDTH_NIT, 14.5 * WIDTH_NIT)];
        [_themeImageView addSubview:erjiImage];
        erjiImage.center = CGPointMake(erjiImage.centerX, self.lyricsView.centerY);
        erjiImage.image = [UIImage imageNamed:@"试听量"];
        self.erjiImageView = erjiImage;
        
        UIView *tapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _themeImageView.width, _themeImageView.height - self.progressView.height)];
        tapView.backgroundColor = [UIColor clearColor];
        [_themeImageView addSubview:tapView];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
        [tapView addGestureRecognizer:tap];
#if ALLOW_BARRAGE
        self.renderer = [[BarrageRenderer alloc] init];
        
        [_themeImageView addSubview:_renderer.view];
        
        _renderer.canvasMargin = UIEdgeInsetsMake(0, 0, 20, 0);
        
        [_themeImageView sendSubviewToBack:_renderer.view];
#endif
    }
    return _themeImageView;
}

- (void)changeLyricColor {
    [self.lyricsView setTextColor:[UIColor whiteColor]];
}

- (NSMutableArray *)commentsframeArray {
    if (_commentsframeArray == nil) {
        _commentsframeArray = [NSMutableArray array];
    }
    return _commentsframeArray;
}

- (LyricCellFrameModel *)lyricFrameModel {
    if (_lyricFrameModel == nil) {
        _lyricFrameModel = [LyricCellFrameModel new];
    }
    return _lyricFrameModel;
}

#pragma mark - 初始化界面

- (void)createImageView {
//    [self ysl_setUpReturnBtnWithColor:[UIColor lightGrayColor]
//                      callBackHandler:^{
//                          [self.navigationController popViewControllerAnimated:YES];
//                      }];
    // 监听播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.musicPlayer.currentItem];
}

// 创建导航视图
- (void)createNaviView {
    
    self.bottomNavView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [self.view addSubview:self.bottomNavView];
    self.bottomNavView.alpha = 0;
    self.bottomNavView.backgroundColor = [UIColor colorWithHexString:@"#ffdc74"];
    
    self.naviView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];

//    self.gradientLayer = [CAGradientLayer layer];
//    self.gradientLayer.frame = self.naviView.bounds;
//    self.gradientLayer.startPoint = CGPointMake(0, 1);
//    self.gradientLayer.endPoint = CGPointMake(0, 0);
//    
//    self.gradientLayer.colors = @[(__bridge id)[UIColor clearColor].CGColor,
//                                  (__bridge id)[UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:1.0].CGColor];
//    self.gradientLayer.locations = @[@(0.0f), @(1.0f)];
//    
//    [self.naviView.layer addSublayer:self.gradientLayer];

//    UIView *backMaskView = [UIView new];
//    backMaskView.backgroundColor = [[UIColor colorWithHexString:@"#000000"] colorWithAlphaComponent:0.5];
//    backMaskView.frame = CGRectMake(0, 0, 35*WIDTH_NIT, 35*WIDTH_NIT);
//    backMaskView.clipsToBounds = YES;
//    backMaskView.layer.cornerRadius = backMaskView.height / 2;
//    backMaskView.alpha = 0.0f;
//    [self.naviView addSubview:backMaskView];
//    self.backMaskView = backMaskView;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, 25, 23*WIDTH_NIT, 20*WIDTH_NIT)];
    imageView.image = [UIImage imageNamed:@"返回"];
    [self.naviView addSubview:imageView];
    imageView.centerY = 42;
    
    self.backMaskView.center = imageView.center;
    
    UIButton *backButton = [UIButton buttonWithType:UIButtonTypeSystem];
    backButton.frame = CGRectMake(0, 0, 64, 64);
    [self.naviView addSubview:backButton];
    backButton.backgroundColor = [UIColor clearColor];
    [backButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, self.naviView.width - 110, self.naviView.height)];
    [self.naviView addSubview:label];
    label.textColor = [UIColor colorWithHexString:@"#451d11"];
    label.text = self.soundName;
    label.center = CGPointMake(label.centerX, label.centerY + 10);
    label.textAlignment = NSTextAlignmentCenter;
    label.font = TECU_FONT(18*WIDTH_NIT);
    self.navTitleLabel = label;
    
    imageView.center = CGPointMake(20 * WIDTH_NIT + width(imageView)/2, label.center.y);
    
    CGFloat barrageBtnW = 50*WIDTH_NIT;
    BarrageCustomBtn *barrageBtn = [BarrageCustomBtn buttonWithType:UIButtonTypeCustom];
    barrageBtn.frame = CGRectMake(self.naviView.width-16-barrageBtnW, 0, barrageBtnW, 30*WIDTH_NIT);
    barrageBtn.center = CGPointMake(barrageBtn.centerX, label.centerY);
    barrageBtn.backgroundColor = [UIColor clearColor];
//    [barrageBtn setTitle:@"弹幕" forState:UIControlStateNormal];
//    [barrageBtn setTitle:@"弹幕" forState:UIControlStateSelected];
    
//    barrageBtn.clipsToBounds = YES;
//    barrageBtn.layer.cornerRadius = barrageBtn.height/2;
#if ALLOW_BARRAGE
    self.closeImage = [[UIImage imageNamed:@"playUser弹幕关"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.openImage = [[UIImage imageNamed:@"playUser弹幕开"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    [barrageBtn setImage:self.closeImage forState:UIControlStateNormal];
    [barrageBtn setImage:self.openImage forState:UIControlStateSelected];
    
//    barrageBtn.titleLabel.backgroundColor = [UIColor clearColor];
//    barrageBtn.titleLabel.font = NORML_FONT(15*WIDTH_NIT);
    
    [barrageBtn setImage:self.closeImage forState:UIControlStateHighlighted];
    
//    barrageBtn.imageView.frame = CGRectMake(0, 0, 20, 13);
    
    [barrageBtn addTarget:self action:@selector(barrageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    [barrageBtn setTitle:@"关闭弹幕" forState:UIControlStateNormal];
//    [barrageBtn setTitle:@"开启弹幕" forState:UIControlStateSelected];
    
    [barrageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [barrageBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateSelected];
    
    barrageBtn.titleLabel.font = [UIFont systemFontOfSize:12];
    
//    [barrageBtn.titleLabel sizeToFit];
    
    barrageBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    barrageBtn.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    
    barrageBtn.adjustsImageWhenHighlighted = NO;
    
//    [barrageBtn setBackgroundImage:self.openImage forState:UIControllStateSelected];
    
//    barrageBtn.imageEdgeInsets = UIEdgeInsetsMake(0, -4.5, 0, 0);
    
//    barrageBtn.titleEdgeInsets = UIEdgeInsetsMake(0, 4.5, 0, 0);
    
    [self.naviView addSubview:barrageBtn];
    
    self.barageBtn = barrageBtn;
    
    [self.view addSubview:self.naviView];
    
    self.naviView.backgroundColor = [UIColor clearColor];
#endif
}

- (void)barrageBtnClick:(UIButton *)btn {
    if (btn.selected) {
        btn.selected = NO;
        [self.renderer start];
        self.shouldShowBarrage = YES;
        [btn setImage:self.closeImage forState:UIControlStateHighlighted];
    } else {
        [self.renderer stop];
        self.shouldShowBarrage = NO;
        [btn setImage:self.openImage forState:UIControlStateHighlighted];
        btn.selected = YES;
    }
}
//dwarfdump --arch=arm64 --lookup 0x1000e3e5f /Users/axg/GIT/CreateSongs.app.dSYM/Contents/Resources/DWARF/CreateSongs
//dwarfdump --arch=x86_64 --lookup 0x100112396 /Users/axg/GIT/CreateSongs.app.dSYM/Contents/Resources/DWARF/CreateSongs
//dwarfdump --arch=x86_64 --lookup 0x1000e3e5f /Users/axg/GIT/CreateSongs.app.dSYM/Contents/Resources/DWARF/CreateSongs
//atos -o LuBao -arch arm64 0x1000e3e5f
// 创建播放器
- (void)creataPlayer {
    self.musicPlayer = [[AXGMusicPlayer alloc] init];
}

// 创建分享界面
- (void)createShareView {
    
    self.shareMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:self.shareMaskView];
    self.shareMaskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    self.shareMaskView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShareView)];
    [self.shareMaskView addGestureRecognizer:tap];
    
    self.shareView = [[UserSongShareView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, SHAREVIEW_HEIGHT)];
    [self.view addSubview:self.shareView];

    WEAK_SELF;
    self.shareView.shareButtonBlock = ^ (NSInteger index) {
        STRONG_SELF;
        
        NSLog(@"分享类型为%ld", index);
        
        [self shareWithChannle:index];
        
    };
    
    self.shareView.cancelBlock = ^ () {
        STRONG_SELF;
        [self hideShareView];
    };
    
}

#pragma mark - 播放结束方法

// 进度条拖动方法
- (void)sliderValueChanged:(CGFloat)value {
    
    //拖动改变视频播放进度
    if (self.musicPlayer.status == AVPlayerStatusReadyToPlay) {
        //    //计算出拖动的当前秒数
        CGFloat total = (CGFloat)self.musicPlayer.currentItem.duration.value / self.musicPlayer.currentItem.duration.timescale;
        
        self.isEnd = NO;
        // 已缓存区域
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration = self.musicPlayer.currentItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        CGFloat maxAvailabelDuration = timeInterval / totalDuration;
        // 选取已缓存区域和手动调节的较小的位置
        CGFloat newValue = MIN(maxAvailabelDuration, value);
        
//        NSInteger dragedSeconds = floorf(total * newValue);
        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(total * newValue, 1);
        
        [self.musicPlayer pause];
        WEAK_SELF;
        [self.musicPlayer seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            STRONG_SELF;
            
            [self play];
            
            [self.musicPlayer play];
            
            self.isPlaying = YES;
        }];
    }
}

- (void)pause {
    self.playImage.image = [UIImage imageNamed:@"playUser播放"];
}

- (void)play {
    self.playImage.image = nil;
//    self.playImage.image = [UIImage imageNamed:@"playUser暂停"];
}

// 可用缓冲区
- (NSTimeInterval)availableDuration {
    
    NSArray *loadedTimeRanges = [self.musicPlayer.currentItem loadedTimeRanges];
    // 获取缓冲区
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    // 计算缓冲总进度
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

// 播放结束方法
- (void)playToEnd:(NSNotification *)sender {
    
    [self pause];
    self.isPlaying = NO;
    self.isEnd = YES;
    self.progressView.currentTime.text = @"00:00";
//    [self.progressView setProgress:0.0f];
    [self.progressView setProgress:0.0f withAnimated:NO];
//    self.currentIndex = 0;
//    [self.renderer stop];
}
#pragma mark - *************图片点击方法(播放/暂停)**************
// 点击图片方法
- (void)tapAction:(UITapGestureRecognizer *)sender {
    if (!self.flag) {
        [[UIResponder currentFirstResponder] resignFirstResponder];
        return;
    }
    if (self.isPlaying) {
        [self pauseAction];
    } else {
        [self continuePlayAction];
    }
    self.isPlaying = !self.isPlaying;
}

- (void)becomeBackGround1 {
//    if (self.isPlaying) {
        [self pauseAction];
        self.isPlaying = NO;
//    }
}

- (void)becomeActive1 {
//    if (!self.isPlaying) {
//        [self continuePlayAction];
//        self.isPlaying = YES;
//    }
    [self pauseAction];
    self.isPlaying = NO;
}


// 暂停方法
- (void)pauseAction {
    [self.musicPlayer pause];
    [self.renderer pause];
    [self.lyricsView stopAnimation];
    [_lyricTimer setFireDate:[NSDate distantFuture]];
    [_timer setFireDate:[NSDate distantFuture]];
    self.toolIndex = self.currentIndex;
    
    [self pause];
}

// 继续播放方法
- (void)continuePlayAction {
    self.currentIndex = self.toolIndex;
    if (self.isEnd) {
        [self.renderer stop];
        self.currentIndex = 0;
        [self.musicPlayer playWithUrl:self.soundURL];
        if (self.lyricFrameModel.lyricStrArray.count > 0) {
            [self.lyricsView setText:self.lyricFrameModel.lyricStrArray[0]];
        }
        
        //            [self.musicPlayer playWithUrl:self.soundURL];
        
        [self getTimeAndProgeress];
        
        //            [self getData];
        
        self.isEnd = NO;
    } else {
        [self.musicPlayer play];
        //            [self.lyricsView reAnimation];
    }
    //        [_timer setFireDate:[NSDate distantPast]];
    
    [_lyricTimer setFireDate:[NSDate distantPast]];
    
    if (self.shouldShowBarrage) {
        [self.renderer start];
    }
    [self play];
}

#pragma mark - *************分享页相关方法**************

// 弹出分享页
- (void)showShareView {
    
    WEAK_SELF;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        STRONG_SELF;
        
        self.shareMaskView.hidden = NO;
        self.shareView.frame = CGRectMake(self.shareView.left, self.view.height - SHAREVIEW_HEIGHT, self.view.width, SHAREVIEW_HEIGHT);

    } completion:^(BOOL finished) {
        
    }];
}

// 收起分享页
- (void)hideShareView {
    WEAK_SELF;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        STRONG_SELF;
        self.shareView.frame = CGRectMake(self.shareView.left, self.view.height, self.view.width, SHAREVIEW_HEIGHT);
    } completion:^(BOOL finished) {
        self.shareMaskView.hidden = YES;
    }];
}

/**
 *  分享按钮方法
 *
 *  @param index 分享渠道
 */
- (void)shareWithChannle:(NSInteger)index {
    
    NSString *title = self.soundName;
    NSString *mp3Url = self.soundURL;
    NSString *webUrl = [NSString stringWithFormat:HOME_SHARE, self.songCode];
    UIImage *image = self.themeImageView.image;
    NSString *songWriter = self.userInfoDataSource[@"name"];
    
    switch (index) {
        case 0:
            [self weChatShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
            break;
        case 1:
            [self friendShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
            break;
        case 2:
            [self QQShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
            break;
        case 3:
            [self QZoneShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
            break;
        case 4:
            [self WeiboShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
        case 5: {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = webUrl;
            
            [MBProgressHUD showSuccess:@"已复制的剪贴板"];
        }
            break;
            
        default:
            break;
    }
    
    
}

//            ShareOtherSongViewController *shareOtherVC = [[ShareOtherSongViewController alloc] init];
//
//            shareOtherVC.songTitle = self.soundName;
//            shareOtherVC.mp3Url = self.soundURL;
//            shareOtherVC.webUrl = [NSString stringWithFormat:HOME_SHARE, self.songCode];
//            shareOtherVC.lrcUrl = self.lyricURL;
//            shareOtherVC.image = self.themeImageView.image;
//            shareOtherVC.songWriter = self.userInfoDataSource[@"name"];
//
//            [self.navigationController pushViewController:shareOtherVC animated:YES];

// 微信分享按钮
- (void)weChatShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    
    // 点击分享微信的按钮统计
    [MobClick event:@"play_shareWechat"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    
    message.description = writer;
    [message setThumbImage:[UIImage imageNamed:@"shareIcon"]];
    
    if (image != nil) {
        [message setThumbImage:image];
    }
    
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = web;
    ext.musicLowBandUrl = ext.musicUrl;
    ext.musicDataUrl = mp3;
    ext.musicLowBandDataUrl = ext.musicDataUrl;
    message.mediaObject = ext;
    
    SendMessageToWXReq  *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
    [WXApi sendReq:req];
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myAppDelegate.ShareType = wxShare;
    
}

// 朋友圈分享按钮
- (void)friendShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    
    
    // 点击分享朋友圈按钮统计
    [MobClick event:@"play_shareFriend"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = writer;
    [message setThumbImage:[UIImage imageNamed:@"shareIcon"]];
    
    if (image != nil) {
        [message setThumbImage:image];
    }
    
    WXMusicObject *ext = [WXMusicObject object];
    ext.musicUrl = web;
    ext.musicLowBandUrl = ext.musicUrl;
    ext.musicDataUrl = mp3;
    ext.musicLowBandDataUrl = ext.musicDataUrl;
    message.mediaObject = ext;
    
    SendMessageToWXReq  *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
    [WXApi sendReq:req];
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myAppDelegate.ShareType = wxFriend;
    
    
}

// QQ分享按钮
- (void)QQShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    
    // 点击分享QQ按钮统计
    [MobClick event:@"play_shareQQ"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shareIcon" ofType:@"png"]];
    
    if (image != nil) {
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        } else {
            data = UIImagePNGRepresentation(image);
        }
    }
    
    QQApiAudioObject *audioObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:web] title:title description:writer previewImageData:data];
    
    
    //    QQApiAudioObject *audioObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:self.webUrl] title:self.songTitle description:@"快来听我写的歌吧" previewImageData:data];
    [audioObj setFlashURL:[NSURL URLWithString:mp3]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:audioObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    //    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myAppDelegate.ShareType = QQShare;
    
    NSLog(@"%d", sent);
    if (sent == 0) {
        [MobClick event:@"play_shareQQSuccess"];
        //        [KVNProgress showSuccessWithStatus:@"已分享"];
        myAppDelegate.willShowShareToast = YES;
    }
}

// QZone分享按钮
- (void)QZoneShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    // 点击分享到QQ空间按钮
    [MobClick event:@"play_shareQZone"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shareIcon" ofType:@"png"]];
    
    if (image != nil) {
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        } else {
            data = UIImagePNGRepresentation(image);
        }
    }
    
    QQApiAudioObject *audioObj = [QQApiAudioObject objectWithURL:[NSURL URLWithString:web] title:title description:writer previewImageData:data];
    
    [audioObj setFlashURL:[NSURL URLWithString:mp3]];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:audioObj];
    //    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    
    NSLog(@"%d", sent);
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myAppDelegate.ShareType = QZoneShare;
    
    if (sent == 0) {
        [MobClick event:@"play_shareQZoneSuccess"];
        //        [KVNProgress showSuccessWithStatus:@"已分享"];
        myAppDelegate.willShowShareToast = YES;
    }
    
}


- (void)WeiboShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    
    
    [MobClick event:@"play_weiboShare"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    [[UMSocialDataService defaultDataService] postSNSWithTypes:@[UMShareToSina] content:web image:nil location:nil urlResource:nil presentedController:self completion:^(UMSocialResponseEntity *response) {
        if (response.responseCode == UMSResponseCodeSuccess) {
            NSLog(@"分享成功");
            AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
            myAppDelegate.willShowShareToast = YES;
            [MobClick event:@"play_weiboShareSuccess"];
        }
    }];
    
}

#pragma mark - *************返回按钮**************
// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - *************获取歌词数据**************
// 获取数据
- (void)getData {
    
    if (![XWAFNetworkTool checkNetwork]) {
//        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    WEAK_SELF;
    [XWAFNetworkTool getUrl:self.lyricURL body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
//        NSLog(@"%@", resposeObject);
       
        NSString *lyric = [[NSString alloc] initWithData:resposeObject encoding:NSUTF8StringEncoding];
        
        self.lyricFrameModel.lyric = [lyric stringByReplacingOccurrencesOfString:@"-" withString:@"～"];
        
        self.curretnLyric = [self.lyricFrameModel.lyricStrArray firstObject];
        
        [self requestMidiData];
        
        [self.lyricsView setText: self.curretnLyric];
        
        [self changeLyricColor];
        /**
         *  刷新歌词所在区
         */
        NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:3];
        [self.mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        [self getCommentsData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        if (error.code == -1001) {
//            [MBProgressHUD showError:@"网络不给力"];
            [KVNProgress showErrorWithStatus:@"网络不给力"];
        } else {
//            [MBProgressHUD showError:@"服务器开小差了"];
            [KVNProgress showErrorWithStatus:@"服务器开小差了"];
        }
    }];
}

#pragma mark - ***************获取礼物信息***************
- (void)getGiftData {
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_SONG_GIFT, self.song_id] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            
            NSMutableArray *mutArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            NSArray *array = resposeObject[@"items"];
            for (NSDictionary *dic in array) {
                GiftInfoModel *model = [[GiftInfoModel alloc] initWithDictionary:dic error:nil];
                
                NSDictionary *modelDic = @{@"user_id":model.user_id, @"user_name":model.user_name, @"phone":model.phone, @"giftNumber":@"1", @"gift_type":@"1"};
                
                GiftUserModel *giftUserModel = [[GiftUserModel alloc] initWithDictionary:modelDic error:nil];
                
                [mutArray addObject:giftUserModel];
                
            }
            
            [self orderResult:mutArray];
            
            /**
             *  刷新礼物榜单
             */
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:2];
            [self.mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

// 合并和排序
- (void)orderResult:(NSArray *)dataSource {
    
    NSMutableArray *originDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    for (GiftUserModel *giftUserModel in dataSource) {
        
        int i = 0;
        for (i = 0; i < originDataSource.count; i++) {
            GiftUserModel *dataModel = originDataSource[i];
            if ([giftUserModel.user_id isEqualToString:dataModel.user_id]) {
                NSInteger number = [dataModel.giftNumber integerValue];
                dataModel.giftNumber = [NSString stringWithFormat:@"%ld", number + 1];
                break;
            }
        }
        if (i == originDataSource.count) {
            [originDataSource addObject:giftUserModel];
        }
        
    }
    
    for (int j = 0; j < originDataSource.count; j++) {
        for (int k = 0; k < originDataSource.count - j - 1; k++) {
            GiftUserModel *user1 = originDataSource[k];
            GiftUserModel *user2 = originDataSource[k + 1];
            NSInteger number1 = [user1.giftNumber integerValue];
            NSInteger number2 = [user2.giftNumber integerValue];
            if (number1 < number2) {
                [originDataSource exchangeObjectAtIndex:k withObjectAtIndex:k + 1];
            }
        }
    }
    
    [self.giftUserDataSource removeAllObjects];
    [self.giftUserDataSource addObjectsFromArray:originDataSource];
    
}

#pragma mark - *************获取用户信息数据**************
/**
 *  获取用户信息
 */
- (void)getUserMessage {
    
    WEAK_SELF;
    //http://service.woyaoxiege.com/core/home/data/getUserById?id=48
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:@"%@?id=%@", GET_USER_ID_URL,self.user_id] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        UserModel *userModel = [[UserModel alloc] initWithDictionary:resposeObject error:nil];
        
        NSLog(@"1status ======== %@", userModel.status);
        
        if (![userModel.status isEqualToString:@"-1"]) {
            self.userName = userModel.name;
            self.gender = userModel.gender;
            /**
             *  刷新用户信息所在区
             */
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
            
            [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
            self.isSendComment = NO;
            
//            [self getCommentsData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark - *************获取评论数据**************
- (void)getCommentsData {
    WEAK_SELF;
    [self.commentsframeArray removeAllObjects];
    NSLog(@"%@", [NSString stringWithFormat:GET_COMMENTS, self.song_id]);
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_COMMENTS, self.song_id] body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        
        NSLog(@"评论URL%@", [NSString stringWithFormat:GET_COMMENTS, self.song_id]);
        
        CommentUserModel *model = [[CommentUserModel alloc] initWithData:resposeObject error:nil];
        
        NSLog(@"2status ======== %@", model.status);
        
        if ([model.status isEqualToString:@"0"]) {
            for (UserCommentsModel *comments in model.comments) {
                CommentUserFrameModel *frameModel = [CommentUserFrameModel new];
                frameModel.commentModel = comments;
                frameModel.commentModel.content = [frameModel.commentModel.content emojizedString];
                [self.commentsframeArray addObject:frameModel];
            }
            /**
             *  刷新评论区
             */
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:4];
            [self.mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
//            if (self.isSendComment) {
//                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.commentsframeArray.count - 1) inSection:2];
//                [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//            }
        } else {
            NSLog(@"请求评论失败");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
#pragma mark - *************实时获取播放进度**************
// 改变时间和进度条
- (void)getTimeAndProgeress {
    if (self.observer) {
        [self.musicPlayer removeTimeObserver:self.observer];
    }
    
    __weak typeof(self)  weakSelf = self;
    self.observer = [self.musicPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        STRONG_SELF;
        
        CMTime time1 = self.musicPlayer.currentItem.duration;
        
        CGFloat totalTime1 = time1.value / time1.timescale;
        
        CGFloat totalTime = [TYCommonClass sharedTYCommonClass].sentenceTime * self.lyricFrameModel.lyricStrArray.count;
        
        if (totalTime > 0 && !isnan(totalTime) && self.commentsframeArray.count > 0 && !self.barrageIsInit) {
            self.barrageIsInit = YES;
#if ALLOW_BARRAGE
            [self beginShowBarrage:totalTime];
            [self.renderer start];
#endif
        }
        
        if (self.lrcTimeArray.count > 0) {
            totalTime = totalTime1;
        }
        
        CGFloat currentTime = time.value * 1.0 / time.timescale;
        // 当前时间
        NSInteger minTime1 = currentTime / 60;
        NSInteger secondTime1 = fmodf(currentTime, 60);
        NSString *timeStr1 = [NSString stringWithFormat:@"%02ld:%02ld", (long)minTime1,(long)secondTime1];
        
        self.progressView.currentTime.text =timeStr1;
        
        // 总时间(字幕)
//        NSInteger minTime2 = totalTime / 60;
//        NSInteger secondTime2 = fmodf(totalTime, 60);
//        NSString *timeStr2 = [NSString stringWithFormat:@"%02ld:%02ld", (long)minTime2,(long)secondTime2];
        
        
        // 总时间(MP3)
        NSInteger minTime3 = totalTime1 / 60;
        NSInteger secondTime3 = fmodf(totalTime1, 60);
        NSString *timeStr3 = [NSString stringWithFormat:@"%02ld:%02ld", (long)minTime3,(long)secondTime3];
        
        self.progressView.totalTime.text = timeStr3;
        
        if (isnan((CGFloat)currentTime * 1.0 / totalTime)) {
            [self.progressView setProgress:0 withAnimated:YES];
        } else {
            [self.progressView setProgress:(CGFloat)currentTime / totalTime withAnimated:YES];
        }
        NSInteger intCurrentTime = (NSInteger)currentTime;
        NSLog(@"%ld--%f", intCurrentTime, totalTime);
        // 刷新歌词
        NSInteger currentRow = 0;
    
        if (self.lrcTimeArray.count > 0) {
            for (NSInteger i = 0; i < self.lrcTimeArray.count-1; i++) {
                NSString *currentStr = self.lrcTimeArray[i];
                NSString *nextStr = self.lrcTimeArray[i+1];
                
                NSInteger currentNum = [currentStr integerValue];
                NSInteger nextNum = [nextStr integerValue];
                
                if (intCurrentTime >= 0 && intCurrentTime < [self.lrcTimeArray[0] integerValue]) {
                    currentRow = 0;
                } else if (intCurrentTime >= currentNum && intCurrentTime < nextNum) {
                    currentRow = i;
                }
            }
        } else {
            currentRow = ((currentTime+1.0) * self.lyricFrameModel.lyricStrArray.count) / totalTime;
        }
        if (currentRow < self.lyricFrameModel.lyricStrArray.count && totalTime != 0) {
            self.curretnLyric = self.lyricFrameModel.lyricStrArray[currentRow];
            [self.lyricsView setText: self.curretnLyric];
        }
    }];
}

#pragma mark - *************tableView代理方法**************

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 4) {
        if (self.commentsframeArray.count < 1) {
            return 216 + 18 + 30 + 35;
        } else {
            CommentUserFrameModel *model = self.commentsframeArray[indexPath.row];
            return model.cellHeight;
        }
    } else if (indexPath.section == 3) {
        return self.lyricFrameModel.cellHeight;
    } else if (indexPath.section == 0) {

        if (self.needReload) {
            return (15+60)*WIDTH_NIT;
        } else {
            return CGFLOAT_MIN;
        }
    } else if (indexPath.section == 2) {
        return 106 * WIDTH_NIT;
    } else if (indexPath.section == 1) {
        return 123 * WIDTH_NIT;
    }
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (section == 1) {
//        return CGFLOAT_MIN;
//    } else
    if (section == 4) {
        return (15+15+20)*WIDTH_NIT;
    } else if (section == 2) {
        return 5 * WIDTH_NIT + 15 * WIDTH_NIT + 24 * WIDTH_NIT;
    }
//    else if (section == 0) {
//         return HOME_HEAD_IMGH * HEIGHT_NIT + 40 * HEIGHT_NIT;
//    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
//    if (section == 0) {
//        UIView *header = [UIView new];
//        header.frame = CGRectMake(0, 0, self.view.width, HOME_HEAD_IMGH * HEIGHT_NIT + 40 * HEIGHT_NIT);
//        header.backgroundColor = [UIColor colorWithHexString:@"#1b1b1b"];
//        [header addSubview:self.themeImageView];
//        
//        _lyricsView = [[LXMLyricsLabel alloc] initWithFrame:CGRectMake(0, _progressView.bottom, width(self.view), 40)];
//        _lyricsView.backgroundColor = [UIColor clearColor];
//        [_lyricsView setFont:NORML_FONT(15*WIDTH_NIT)];
//        [_lyricsView setTextAlignment:NSTextAlignmentCenter];
//        [header addSubview:_lyricsView];
//        
//        tableView.tableHeaderView = header;
//        return header;
//    } else
    if (section == 4) {
        
            return [self getSection2Header];
    } else if (section == 2) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 5 * WIDTH_NIT + 15 * WIDTH_NIT + 24 * WIDTH_NIT)];
        view.backgroundColor = HexStringColor(@"#ffffff");
        UIView *gapView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 5 * WIDTH_NIT)];
        [view addSubview:gapView];
        gapView.backgroundColor = HexStringColor(@"#eeeeee");
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, 15 * WIDTH_NIT, 100, 24 * WIDTH_NIT)];
        [view addSubview:label];
        label.text = @"礼物榜";
        label.textColor = HexStringColor(@"#535353");
        label.font = JIACU_FONT(12 * WIDTH_NIT);
        return view;
    }
//    else if (section == 1) {
//        UIView *header = [UIView new];
//        header.backgroundColor = [UIColor redColor];
//        return header;
//    }
    return nil;
}

- (UIView *)getSection2Header {
    UIView *header = [UIView new];
    
    header.backgroundColor = [UIColor clearColor];
    header.frame = CGRectMake(0, 0, self.view.width, (15+15+20)*WIDTH_NIT);
    
    UIView *headBg = [UIView new];
    headBg.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    headBg.frame = CGRectMake(0, 0, width(self.mainTableView), (15+15+20)*WIDTH_NIT);
    [header addSubview:headBg];
    
    UILabel *titleLabel = [UILabel new];
    titleLabel.backgroundColor = [UIColor clearColor];
    titleLabel.text = @"评论";
    titleLabel.textColor = [UIColor colorWithHexString:@"#879999"];
    titleLabel.font = JIACU_FONT(12*WIDTH_NIT);
    titleLabel.frame = CGRectMake(16*WIDTH_NIT, 15*WIDTH_NIT, width(self.mainTableView), 15);
    [header addSubview:titleLabel];
    
    CGSize titleSize = [@"评论" getWidth:@"评论" andFont:titleLabel.font];
    UILabel *commontCount = [UILabel new];
    
    commontCount.backgroundColor = [UIColor colorWithHexString:@"#451d11"];
    commontCount.font = NORML_FONT(12*WIDTH_NIT);
    commontCount.textAlignment = NSTextAlignmentCenter;
    commontCount.frame = CGRectMake(16*WIDTH_NIT + titleSize.width + 10*WIDTH_NIT, titleLabel.top, 40*WIDTH_NIT, 15*WIDTH_NIT);
    commontCount.textColor = [UIColor colorWithHexString:@"#ffffff"];
    commontCount.text = [NSString stringWithFormat:@"%ld", self.commentsframeArray.count];
    commontCount.clipsToBounds = YES;
    commontCount.layer.cornerRadius = commontCount.height/2;
    [header addSubview:commontCount];
    
    
    return header;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.section == 0) {
 
        PlayUserSongUserCell *cell = [PlayUserSongUserCell customCommentCell:tableView];
        WEAK_SELF;
        cell.fanChangeBlock = ^{
            STRONG_SELF;
            [self turnToSingPage];
        };
        cell.userId = self.user_id;
        cell.code = self.songCode;
        [cell.loveBtn setTitle:self.loveCount forState:UIControlStateNormal];
        
        cell.songName = self.soundName;
        cell.gender = self.gender;
        cell.hasSetCheat = [self isCheatByDataBase];
        cell.songId = self.song_id;
        
        if (!self.needReload) {
            cell.hidden = YES;
        }
        cell.userInfoDic = self.userInfoDataSource;

        [self.userHeadImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_USER_HEAD, [NSString stringWithFormat:@"%@", [XWAFNetworkTool md5HexDigest:cell.userInfoDic[@"phone"]]]]] placeholderImage:[UIImage imageNamed:@"头像"]];
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
        NSString *phone = [wrapper objectForKey:(id)kSecAttrAccount];
        if ([phone isEqualToString:@"13564988559"]) {
            self.userNameLabel.text = cell.userId;
        } else {
            self.userNameLabel.text = cell.userInfoDic[@"name"];
        }
//        self.userNameLabel.text = cell.userId;
        CGSize nameSize = [self.userNameLabel.text getWidth:self.userNameLabel.text andFont:self.userNameLabel.font];
        if (nameSize.width > 100) nameSize.width = 100;
        self.genderImageView.frame = CGRectMake(self.userNameLabel.left + nameSize.width + 7*WIDTH_NIT, 0, 12*WIDTH_NIT, 12*WIDTH_NIT);
        self.genderImageView.centerY = self.userNameLabel.centerY;
        self.timeLabel.text = [cell.userInfoDic[@"createTime"] intervalSinceNow:cell.userInfoDic[@"createTime"]];
        self.timeLabel.frame = CGRectMake(self.genderImageView.right + 6*WIDTH_NIT, 0, 150, nameSize.height);
        self.timeLabel.centerY = self.userHeadImage.centerY;
        if ([self.gender isEqualToString:@"1"]) {
            self.genderImageView.image = [UIImage imageNamed:@"男icon"];
        } else {
            self.genderImageView.image = [UIImage imageNamed:@"女icon"];
        }
        
        // 调到用户界面
        cell.turnToUserPageBlock = ^(NSString *userId) {
            STRONG_SELF;
            OtherPersonCenterController *personCenter = [[OtherPersonCenterController alloc] initWIthUserId:userId];
            [self.navigationController pushViewController:personCenter animated:YES];
        };
        
        cell.shareBlock = ^() {
            STRONG_SELF;
            
            [self showShareView];
            
//            ShareOtherSongViewController *shareOtherVC = [[ShareOtherSongViewController alloc] init];
//            
//            shareOtherVC.songTitle = self.soundName;
//            shareOtherVC.mp3Url = self.soundURL;
//            shareOtherVC.webUrl = [NSString stringWithFormat:HOME_SHARE, self.songCode];
//            shareOtherVC.lrcUrl = self.lyricURL;
//            shareOtherVC.image = self.themeImageView.image;
//            shareOtherVC.songWriter = self.userInfoDataSource[@"name"];
//            
//            [self.navigationController pushViewController:shareOtherVC animated:YES];
        };
        
        cell.addOrSubLikeBlock = ^(BOOL flag) {
            STRONG_SELF;
            if (flag) {
                self.loveCount = [NSString stringWithFormat:@"%ld", self.loveCount.integerValue + 1];
            } else {
                NSInteger count = self.loveCount.integerValue - 1;
                if (count < 0) {
                    count = 0;
                }
                self.loveCount = [NSString stringWithFormat:@"%ld", count];
            }
        };
        
        cell.pauseBlock = ^ {
            STRONG_SELF;
            if (self.isPlaying) {
                [self pauseAction];
            }
            
            self.isPlaying = NO;
        };
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else if (indexPath.section == 1) {
        
        MembersTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:memberIdentifier];
        
        if (self.songModel) {
            NSArray *array = @[self.songModel.yanchang_id, self.songModel.zuoci_id, self.songModel.zuoqu_id, self.songModel.user_id];
            cell.memberArray = array;
        }
        
        WEAK_SELF;
        cell.refreshFocusBlock = ^ () {
            STRONG_SELF;
            
            NSIndexSet *indexSet = [NSIndexSet indexSetWithIndex:1];
            [self.mainTableView reloadSections:indexSet withRowAnimation:UITableViewRowAnimationNone];
            
        };
        
        cell.memberToUserCenterBlock = ^ (NSString *userId) {
            STRONG_SELF;
            
            OtherPersonCenterController *personCenter = [[OtherPersonCenterController alloc] initWIthUserId:userId];
            [self.navigationController pushViewController:personCenter animated:YES];
            
        };
        
        return cell;
        
    } else if (indexPath.section == 2) {
        
        GiftRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:giftRankIdentifier];
        
        cell.giftDataSource = self.giftUserDataSource;
        
        WEAK_SELF;
        cell.selectUserBlock = ^ (NSString *userId) {
            STRONG_SELF;
            OtherPersonCenterController *personCenter = [[OtherPersonCenterController alloc] initWIthUserId:userId];
            [self.navigationController pushViewController:personCenter animated:YES];
        };
        cell.moreUserBlock = ^ () {
            STRONG_SELF;
            
            GiftRankViewController *giftVC = [[GiftRankViewController alloc] init];
            giftVC.dataSource = self.giftUserDataSource;
            [self.navigationController pushViewController:giftVC animated:YES];
            
        };
        
        return cell;
        
    } else if (indexPath.section == 3) {
        PlayUserSongLyricCell *cell = [PlayUserSongLyricCell customCommentCell:tableView];
        cell.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        cell.lyricFrameModel = self.lyricFrameModel;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        return cell;
    } else {
        if (self.commentsframeArray.count < 1) {
            PlayUserSongNoneDataCell *cell = [PlayUserSongNoneDataCell customNoneDataCellWithTableView:tableView];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            cell.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
            return cell;
        } else {
            PlayUserSongCommentCell *cell = [PlayUserSongCommentCell customCommentCell:tableView];
            cell.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
            cell.userFrameModel = self.commentsframeArray[indexPath.row];
            
            WEAK_SELF;
            cell.headClickBlock = ^(NSString *user_id) {
                STRONG_SELF;
                NSLog(@"%@", user_id);
                [self turnToPersonCenter:user_id];
            };
            
            cell.commentClickBlock = ^(NSString *userName, NSString *user_id, NSString *commentsId) {
                STRONG_SELF;
                
#warning 删除评论位置
                
                NSLog(@"%@---commentsId %@", userName, commentsId);
                
                [self clickCommentsAction:userName userId:user_id commentsId:commentsId];
                
            };
            
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            return cell;
        }
    }
}

// 点击评论方法
- (void)clickCommentsAction:(NSString *)userName userId:(NSString *)userId commentsId:(NSString *)commentsId {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *selfUserId = [wrapper objectForKey:(id)kSecValueData];
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAK_SELF;
    UIAlertAction *replyAction = [UIAlertAction actionWithTitle:@"回复" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF;
        [self replayTopreCommenter:userName];
        self.commenterId = userId;
        
    }];
    
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF;
        
        WEAK_SELF;
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:DEL_COMMENTS_BY_ID, commentsId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            [self getCommentsData];
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:replyAction];
    
    if ([self.user_id isEqualToString:selfUserId]) {
        [alert addAction:delAction];
    }
    
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:nil];
    
}

- (void)turnToPersonCenter:(NSString *)user_id {
    // 进入评论者个人主页
    OtherPersonCenterController *personCenter = [[OtherPersonCenterController alloc] initWIthUserId:user_id];
    personCenter.userId = user_id;
    [self.navigationController pushViewController:personCenter animated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 5;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 4) {
        if (self.commentsframeArray.count < 1) {
            return 1;
        } else {
            
            return self.commentsframeArray.count;
        }
    } else {
        return 1;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
}

#pragma mark - 处理个人信息界面信息

// 根据本地数据库判断是否点赞
//- (BOOL)islovedByDataBase {
//    
//    [XWAFNetworkTool postInfoWithUrl:[NSString stringWithFormat:GET_SONG_BY_ID, _song_id] paramter:@{} success:^(id responseObject) {
//        if ([responseObject[@"status"] isEqualToNumber:@0]) {
//            NSArray *items = responseObject[@"items"];
//            for (NSDictionary *dic in items) {
//                NSString *songId = dic[@"song_id"];
//                if ([songId isEqualToString:self.song_id]) {
//                    return self.;
//                }
//            }
//            return NO;
//        }
//    } fail:^{
//        
//    }];
//    
//    
//    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"CreateSongsLove.db"];
//    
//    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
//    NSString *account = [wrapper objectForKey:(id)kSecAttrAccount];
//
//    if (account.length == 0) {
//        
//        [store createTableWithName:@"woyaoxiegeUnLogin"];
//        NSArray *array = [store getAllItemsFromTable:@"woyaoxiegeUnLogin"];
//        for (YTKKeyValueItem * item in array) {
//            NSString *str = [item.itemObject firstObject];
//            if ([str isEqualToString:self.songCode]) {
//                return YES;
//            }
//        }
//        return NO;
//        
//    } else {
//        [store createTableWithName:[NSString stringWithFormat:@"woyaoxiege%@", account]];
//        NSArray *array = [store getAllItemsFromTable:[NSString stringWithFormat:@"woyaoxiege%@", account]];
//        for (YTKKeyValueItem * item in array) {
//            NSString *str = [item.itemObject firstObject];
//            if ([str isEqualToString:self.songCode]) {
//                return YES;
//            }
//        }
//        return NO;
//    }
//}

// 根据本地数据库判断是够举报
- (BOOL)isCheatByDataBase {
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"CreateSongsCheat.db"];
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *account = [wrapper objectForKey:(id)kSecAttrAccount];
    
    if (account.length == 0) {
        
        [store createTableWithName:@"woyaoxiegeUnLogin"];
        NSArray *array = [store getAllItemsFromTable:@"woyaoxiegeUnLogin"];
        for (YTKKeyValueItem * item in array) {
            NSString *str = [item.itemObject firstObject];
            if ([str isEqualToString:self.songCode]) {
                return YES;
            }
        }
        return NO;
        
    } else {
        [store createTableWithName:[NSString stringWithFormat:@"woyaoxiege%@", account]];
        NSArray *array = [store getAllItemsFromTable:[NSString stringWithFormat:@"woyaoxiege%@", account]];
        for (YTKKeyValueItem * item in array) {
            NSString *str = [item.itemObject firstObject];
            if ([str isEqualToString:self.songCode]) {
                return YES;
            }
        }
        return NO;
    }
}

// 弹出举报窗口
- (void)popCheatView {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAK_SELF;
    
    UIAlertAction *cheatAction = [UIAlertAction actionWithTitle:@"举报" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF;
        [self setCheatAction];
    }];

    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
        NSString *userId = [wrapper objectForKey:(id)kSecValueData];
        
        NSLog(@"self.userid = %@--- userId = %@", self.user_id, userId);
        
        if ([self.user_id isEqualToString:userId]) {
            UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                STRONG_SELF;
//                [self delByCodeAction];
                [self popConfirmDelete];
            }];
            [alert addAction:delAction];
        }
    }
    
    [alert addAction:cheatAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
// 关注按钮方法
- (void)focusButtonAction:(UIButton *)sender {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    
    __weak typeof(self)weakSelf = self;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        // 已登录状态
        
        if (self.isFocus) {
            
            [weakSelf.focusBtn setImage:[UIImage imageNamed:@"playUser加关注"] forState:UIControlStateNormal];
            
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:DEL_FOCUS, weakSelf.user_id, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                    NSLog(@"取消关注成功");
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        } else {
            [weakSelf.focusBtn setImage:[UIImage imageNamed:@"playUser已关注"] forState:UIControlStateNormal];
            //                self.focusBtn.backgroundColor = BUTTON_UNABLE_COLOR;
            
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_FOCUS, weakSelf.user_id, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                    NSLog(@"添加关注成功");
#if ALLOW_MSG
                    if (![self.user_id isEqualToString:userId]) {
                        /*msg type 2 关注*/
                        [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, self.user_id, userId, @"2", weakSelf.user_id, @"", @""] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                            
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            
                        }];
                    }
#endif
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        }
        self.isFocus = !self.isFocus;
        
    } else {
        // 未登录状态

        AXG_LOGIN(LOGIN_LOCATION_USERSONG_FOCUS);
    }
}
#pragma mark - 进入演唱界面
- (void)turnToSingPage {
    
#warning add lyric writer
    // 这里使用从网络获取的lyricWriter 目前还没添加  还有添加songwriter
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    app.lyricWriter = self.lr
    app.songSinger = @"";
    app.songWriter = self.songModel.zuoqu_id;
    app.lyricWriter = self.songModel.zuoci_id;
    
    [MobClick event:@"otherSong_sing"];
    
    [self pauseAction];
    self.shouldPlay = NO;
    
    self.rvc.lyricDataSource = self.lyricFrameModel.lyricStrArray;
    self.rvc.titleStr = self.soundName;
    self.rvc.songName = self.soundName;
    self.rvc.isFirstPlay = YES;
    self.rvc.isFromPlayView = YES;
    self.rvc.shouldDone = NO;
    self.rvc.shareSongName = self.soundName;
    self.rvc.firstSongCode = self.songCode;
    self.rvc.isFromUserSong = YES;
    
    [self.navigationController pushViewController:self.rvc animated:YES];
}
/*
 [self.player pause];
 [RecoderClass sharedRecoderClass].shouldChangeEar = YES;
 self.isPlaying = NO;
 self.rvc.lyricDataSource = self.lyricDataSource;
 self.rvc.titleStr = self.titleStr;
 self.rvc.songName = self.titleStr;
 self.rvc.isFirstPlay = YES;
 self.rvc.changeSingerAPIName = self.changeSingerAPIName;
 self.rvc.isFromPlayView = YES;
 self.rvc.shouldDone = NO;
 [self.navigationController pushViewController:self.rvc animated:YES];
 
 */

// 弹出确认删除窗口
- (void)popConfirmDelete {

    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:[NSString stringWithFormat:@"是否删除歌曲\n%@", self.soundName] preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        [self delByCodeAction];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:OKAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

// 举报按钮方法
- (void)setCheatAction {
    if (![self isCheatByDataBase]) {
        [self cheatSaveToDataBase];
        
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:CHEAT_SONGS, self.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                [MBProgressHUD showError:@"已举报"];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    } else {
        NSLog(@"已经举报了");
        [MBProgressHUD showError:@"已举报"];
    }
}

// 删除按钮方法
- (void)delByCodeAction {
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:DEL_BY_CODE, self.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSLog(@"删除歌曲成功");
//            [self.navigationController popViewControllerAnimated:YES];
//            
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"refreshHomeAfterDelete" object:nil];
            
            if ([[self.navigationController.viewControllers firstObject] isKindOfClass:[HomeViewController class]]) {
                HomeViewController *homeVC = [self.navigationController.viewControllers firstObject];
                [homeVC reloadHome];
            }
            
            [self.navigationController popToRootViewControllerAnimated:YES];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

// 举报完储存到数据库
- (void)cheatSaveToDataBase {
    
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"CreateSongsCheat.db"];
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
//    NSLog(@"dateString:%@",dateString);
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *account = [wrapper objectForKey:(id)kSecAttrAccount];
    
    if (account.length == 0) {
        
        [store createTableWithName:@"woyaoxiegeUnLogin"];
        [store putString:self.songCode withId:dateString intoTable:@"woyaoxiegeUnLogin"];
//        NSLog(@"!!!!!!!!!!!!!%@", [store getAllItemsFromTable:@"woyaoxiegeUnLogin"]);
        
    } else {
        [store createTableWithName:[NSString stringWithFormat:@"woyaoxiege%@", account]];
        [store putString:self.songCode withId:dateString intoTable:[NSString stringWithFormat:@"woyaoxiege%@", account]];
//        NSLog(@"!!!!!!!!!!!!%@", [store getAllItemsFromTable:[NSString stringWithFormat:@"woyaoxiege%@", account]]);
    }
}

// 判断是否关注
- (void)isFocusAndLikeByNetWork {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    
    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    NSLog(@"  userid   %@", userId);
    NSLog(@"  song user id  %@", self.user_id);
    
    __weak typeof(self)weakSelf = self;
    
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_FOCUS, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        NSLog(@"%@", resposeObject);
        
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSArray *array = resposeObject[@"items"];
            for (NSDictionary *dic in array) {
                if ([dic[@"focus_id"] isEqualToString:weakSelf.user_id]) {
                    weakSelf.isFocus = YES;
                    weakSelf.isFocusAtLast = weakSelf.isFocus;
                    [weakSelf.mainTableView reloadData];
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_LIKE, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSArray *array = resposeObject[@"items"];
            for (NSDictionary *dic in array) {
                if ([dic[@"song_id"] isEqualToString:weakSelf.song_id]) {
                    weakSelf.isLike = YES;
                    weakSelf.isLikeAtLast = weakSelf.isLike;
                    [weakSelf.mainTableView reloadData];
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}
// 通知方法
- (void)userSongShareAction:(NSNotification *)message {
    
    [self showShareView];
    
//    ShareOtherSongViewController *shareOtherVC = [[ShareOtherSongViewController alloc] init];
//
//    shareOtherVC.songTitle = self.soundName;
//    shareOtherVC.mp3Url = self.soundURL;
//    shareOtherVC.webUrl = [NSString stringWithFormat:HOME_SHARE, self.songCode];
//    shareOtherVC.lrcUrl = self.lyricURL;
//    shareOtherVC.image = self.themeImageView.image;
//    
//    [self.navigationController pushViewController:shareOtherVC animated:YES];

}

// 跳转到其他用户主页
- (void)turnToSongWriterPage:(NSNotification *)message {
    OtherPersonCenterController *personVC = [[OtherPersonCenterController alloc] initWIthUserId:self.user_id];
    
    [self.navigationController pushViewController:personVC animated:YES];
    
}

// 设置关注状态
- (void)setFocusAction {
    self.isFocusAtLast = !self.isFocusAtLast;
}

- (void)setLikeAction {
    self.isLikeAtLast = !self.isLikeAtLast;
}

#pragma mark -创建大的tableView(包括播放视图歌词视图和评论)

- (void)createMainTableView {
    
    self.mainTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height) style:UITableViewStyleGrouped];
    
    self.mainTableView.scrollsToTop = YES;
    self.mainTableView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    self.mainTableView.bounces = NO;
    self.mainTableView.dataSource = self;
    self.mainTableView.delegate = self;
    self.mainTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.mainTableView.allowsSelection = NO;
    
    [self.mainTableView registerClass:[GiftRankTableViewCell class] forCellReuseIdentifier:giftRankIdentifier];
    [self.mainTableView registerClass:[MembersTableViewCell class] forCellReuseIdentifier:memberIdentifier];
    
    UIView *header = [UIView new];
    header.frame = CGRectMake(0, 0, self.view.width, HOME_HEAD_IMGH * HEIGHT_NIT + 40 * HEIGHT_NIT + 64);
    header.backgroundColor = [UIColor whiteColor];
    
//    UILabel *line = [UILabel new];
//    line.backgroundColor = [UIColor redColor];
//    line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
//    line.frame = CGRectMake(0, 64, self.view.width, 0.5);
//    [header addSubview:line];
//    
//    UIImageView *userHead = [UIImageView new];
//    userHead.frame  =CGRectMake(16*WIDTH_NIT, 0, 45, 45);
//    userHead.centerY = 64 + 25;
//    userHead.clipsToBounds = YES;
//    userHead.layer.borderColor = [UIColor whiteColor].CGColor;
//    userHead.layer.borderWidth = 1.0f;
//    userHead.layer.cornerRadius = userHead.height / 2;
//    userHead.userInteractionEnabled = YES;
//    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(turnToOtherUserPage:)];
//    [userHead addGestureRecognizer:tag];
//    
//    [header addSubview:userHead];
//    
//    UILabel *userName = [UILabel new];
//    
//    userName.font = TECU_FONT(12*WIDTH_NIT);
//    CGSize userNameSize = [@"我" getWidth:@"我" andFont:userName.font];
//    userName.frame = CGRectMake(userHead.right + 16*WIDTH_NIT, 0, 100, 30);
//
//    userName.centerY = userHead.centerY;
//    userName.textColor  =[UIColor colorWithHexString:@"#535353"];
//    userName.backgroundColor = [UIColor clearColor];
//    [header addSubview:userName];
//    
//    UILabel *timeLabel = [UILabel new];
//    timeLabel.centerY = userHead.centerY;
//    timeLabel.font = NORML_FONT(12*WIDTH_NIT);
//    timeLabel.textColor = [UIColor colorWithHexString:@"#879999"];
//    [header addSubview:timeLabel];
//    
//    UIButton *focusBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    focusBtn.frame = CGRectMake(self.view.width - 16 - 50*WIDTH_NIT, 0, 50*WIDTH_NIT, 18*WIDTH_NIT);
//    focusBtn.centerY = userHead.centerY;
//    [focusBtn setImage:@"playUser加关注"];
//    [focusBtn addTarget:self action:@selector(focusButtonAction:)];
//    focusBtn.backgroundColor = [UIColor clearColor];
//    focusBtn.enabled = NO;
//    [header addSubview:focusBtn];
//    
//    self.genderImageView = [UIImageView new];
//    [header addSubview:self.genderImageView];
//    
//    self.userHeadImage = userHead;
//    self.userNameLabel = userName;
//    self.timeLabel = timeLabel;
//    self.focusBtn = focusBtn;
//    
    [header addSubview:self.themeImageView];
//    [self.view addSubview:header];
    
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    if ([userId isEqualToString:self.user_id]) {
        self.focusBtn.hidden = YES;
    }
    
    
    self.mainTableView.tableHeaderView = header;
    
    
    UIView *footView = [UIView new];
    footView.backgroundColor = [UIColor clearColor];
    footView.frame = CGRectMake(0, 0, self.view.width,50*WIDTH_NIT);
    self.mainTableView.tableFooterView = footView;
    
    [self.view addSubview:self.mainTableView];
}

- (void)turnToOtherUserPage:(UITapGestureRecognizer *)tgr {
    OtherPersonCenterController *personCenter = [[OtherPersonCenterController alloc] initWIthUserId:self.user_id];
    [self.navigationController pushViewController:personCenter animated:YES];
}



#pragma mark - *************发送评论**************
/**
 *  发送评论视图
 */
- (void)createReplyView {
    ReplyInputView *replyInputView = [[ReplyInputView alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y + self.view.frame.size.height - 50*WIDTH_NIT, screenWidth(), 50*WIDTH_NIT) andAboveView:self.view];
    replyInputView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    WEAK_SELF;
    //回调输入框的contentSize,改变工具栏的高度
    [replyInputView setContentSizeBlock:^(CGSize contentSize) {
        
        STRONG_SELF;
        [self updateHeight:contentSize];
    }];
    
    
    [replyInputView setReplyAddBlock:^(NSString *replyText, NSInteger inputTag) {
        STRONG_SELF;
//        replyText = [@"用户名" stringByAppendingString:replyText];
        if (replyText.length > 0) {
            self.isSendComment = YES;
            [self sendComments:replyText];
        }
//        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:inputTag inSection:2];
//        [self.mainTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
    }];
    
    replyInputView.sendGiftBlock = ^(){
        STRONG_SELF;
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
            if (self.user_id.length > 0 && self.song_id.length > 0) {
                [self pauseAction];
                self.isPlaying = NO;
                PaySureController *payController = [PaySureController new];
                payController.user_id = self.user_id;
                payController.song_id = self.song_id;
                [self.navigationController pushViewController:payController animated:YES];
            } else {
                [KVNProgress showErrorWithStatus:@"未能获取歌曲信息"];
                NSLog(@"");
            }
        } else {
            AXG_LOGIN(LOGIN_LOCATION_USERSONG_COMMENT);
        }
        
    };
    
    replyInputView.replyTag = COMMENT_TAG;
    [self.view addSubview:replyInputView];
    self.replyInputView = replyInputView;
    
//    NSLog(@"%@", NSStringFromCGRect(self.replyInputView.frame));
}

- (void)sendCommentAfterLogin {
     NSString *userId = [[NSUserDefaults standardUserDefaults] objectForKey:INFO_USER_ID];
    if (![userId isEqualToString:NULL_USER_ID] && userId != nil) {
        //        [_renderer start];
        [self beginSendCommentWithUser:userId];
    } else {
        NSLog(@"登录失败，不能发送评论");
    }
}

//更新replyView的高度约束
-(void)updateHeight:(CGSize)contentSize {// 31 + x - 31
//    NSLog(@"---%@", NSStringFromCGSize(contentSize));
//    NSLog(@"===%@", NSStringFromCGRect(self.replyInputView.frame));
//    NSLog(@"%f", 50*WIDTH_NIT));
    float height = contentSize.height + (50*WIDTH_NIT-31);
    CGRect frame = self.replyInputView.frame;
    frame.origin.y -= height - frame.size.height;  //高度往上拉伸
    frame.size.height = height;
    self.replyInputView.frame = frame;
}

// 回复评论
- (void)replayTopreCommenter:(NSString *)preCommenter {
    self.replyInputView.preCommenter = preCommenter;
    self.replyInputView.lblPlaceholder.text = [NSString stringWithFormat:@"回复%@", preCommenter];
    [self.replyInputView.sendTextView becomeFirstResponder];
}

#pragma mark - *************弹幕设置**************
///// 生成精灵描述 - 过场文字弹幕
//- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction content:(NSString *)content textColor:(UIColor *)textColor{
//    
//    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
//    descriptor.spriteName = NSStringFromClass([BarrageWalkTextSprite class]);
//    descriptor.params[@"text"] = content;
//    
//    //    CGFloat hue = arc4random() % 230/256.0; //0.0 to 1.0
//    //
//    //    CGFloat saturation = ( arc4random() % 179 / 256.0 ); // 0-0.7,away from white
//    //
//    //    CGFloat brightness = ( arc4random() % 179 / 256.0 ) + 0.3; //0.5 to 1.0,away from black
//    
//    
//    //    NSLog(@"%f", hue);
//    
//    descriptor.params[@"textColor"] = textColor;
//    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+30);
//    descriptor.params[@"direction"] = @(direction);
//    descriptor.params[@"clickAction"] = ^{
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//        [alertView show];
//    };
//    return descriptor;
//}
/// 生成精灵描述 - 过场文字弹幕
- (BarrageDescriptor *)walkTextSpriteDescriptorWithDirection:(NSInteger)direction model:(UserCommentsModel *)comments textColor:(UIColor *)textColor{
    
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageSpriteWithHead class]);
    descriptor.params[@"text"] = comments.content;
    descriptor.params[@"trackNumber"] = @4;
    /**
     *imageUrl;
     *userName;
     *upCount;
     */
    NSString *userHead = [NSString stringWithFormat:GET_USER_HEAD, [NSString stringWithFormat:@"%@", [XWAFNetworkTool md5HexDigest:comments.phone]]];
    descriptor.params[@"imageUrl"] = userHead;
    descriptor.params[@"userName"] = [comments.user_name stringByAppendingString:@":"];
    descriptor.params[@"upCount"] = comments.up_count;
//    descriptor.params[@"trackNumber"] = @3;
    descriptor.params[@"textColor"] = textColor;
    descriptor.params[@"speed"] = @(100 * (double)random()/RAND_MAX+50);
//    descriptor.params[@"speed"] = @30;
    descriptor.params[@"direction"] = @(direction);
    descriptor.params[@"clickAction"] = ^{
//        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"弹幕被点击" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil];
//        [alertView show];
    };
    return descriptor;
}


- (void)autoSendBarrage {
//    [self.renderer start];
    
    
    NSInteger spriteNumber = [_renderer spritesNumberWithName:nil];
    if (spriteNumber <= 6) { // 用来演示如何限制屏幕上的弹幕量
        
        if (self.giftUserDataSource.count > 0 && self.currentGiftBarrageIndex < self.giftUserDataSource.count) {
            self.shouldSendBarrage = NO;
            GiftUserModel *model = self.giftUserDataSource[self.currentGiftBarrageIndex];
            [self sendGiftBarrage:[NSString stringWithFormat:@"送出了%@朵鲜花", model.giftNumber] userName:model.user_name userPhone:model.phone];
            self.currentGiftBarrageIndex ++;
        } else {
            self.shouldSendBarrage = YES;
        }
        
        if (self.commentsframeArray.count > 0 && self.currentIndex < self.commentsframeArray.count && self.shouldSendBarrage) {
            CommentUserFrameModel *frameModel = self.commentsframeArray[self.currentIndex];

            
//            CGFloat hue = arc4random() % 230/256.0; //0.0 to 1.0
            
//            CGFloat saturation = ( arc4random() % 179 / 256.0 ); // 0-0.7,away from white
            
//            CGFloat brightness = ( arc4random() % 179 / 256.0 ) + 0.3; //0.5 to 1.0,away from black
            
            //[UIColor colorWithHue:hue saturation:saturation brightness:brightness alpha:1.0f]
            
            [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L model:frameModel.commentModel textColor:[UIColor blueColor]]];
          
            self.currentIndex += 1;
        } else if (self.currentIndex >= self.commentsframeArray.count) {
            //            i = 0;
//            [self.renderer stop];
//            NSLog(@"%ld--%ld", self.currentIndex, self.commentsframeArray.count);
//            [_timer setFireDate:[NSDate distantFuture]];
        }
        
    }
}

- (void)sendComments:(NSString *)commentStr {
    
    self.commentStr = commentStr;
    /**
     *  没有登录 本地不能找到userId则弹出登录页面
     */
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        
        
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
        NSString *userId = [wrapper objectForKey:(id)kSecValueData];
        [self beginSendCommentWithUser:userId];
    } else {
        AXG_LOGIN(LOGIN_LOCATION_USERSONG_COMMENT);
    }
    
    self.replyInputView.sendTextView.text = @"";
    [self.replyInputView updateInputHeight];
//    self.replyInputView.replyBlock(self.replyInputView.sendTextView.text, self.replyInputView.replyTag);
}

- (void)beginSendCommentWithUser:(NSString *)userId {
    
    if (_commentStr.length != 0) {
#if ALLOW_BARRAGE
        
        
        NSString *mySelfName = [[NSUserDefaults standardUserDefaults] objectForKey:@"mySelfName"];
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
        NSString *phone = [wrapper objectForKey:(id)kSecAttrAccount];
        
        
        UserCommentsModel *model = [UserCommentsModel new];
        
        model.content = _commentStr;
        model.up_count = @"0";
        model.user_name = mySelfName;
        model.phone = phone;
        
        [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L model:model textColor:[UIColor redColor]]];
#endif
        
        NSString *preComment = self.commentStr;
//        NSString *preComment = [self.commentStr preEmojizedString];
        
        NSLog(@"预处理过的评论%@", preComment);

        NSString *commentUrl = @"";
        if (self.replyInputView.preCommenter.length != 0) {
            commentUrl = [NSString stringWithFormat:ADD_COMMENTS, userId, self.song_id, preComment, self.replyInputView.preCommenter];
            
            WEAK_SELF;
            NSLog(@"%@", commentUrl);
            [XWAFNetworkTool getUrl:commentUrl body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                STRONG_SELF;
                NSLog(@"评论成功%@",resposeObject);
                
#if ALLOW_MSG
                if (![self.commenterId isEqualToString:userId]) {
                    /*msg type 3 回复评论*/
                    [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, self.commenterId, userId, @"3", self.song_id, preComment, self.soundName] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                        
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        
                    }];
                }
                
                if (![self.user_id isEqualToString:userId]) {
                    /*msg type 1 评论*/
                    [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, self.user_id, userId, @"1", self.song_id, preComment, self.soundName] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                        
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        
                    }];
                }
                
#endif
                
                self.replyInputView.preCommenter = @"";
                [self getCommentsData];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"发送评论失败%@", error.description);
                self.replyInputView.preCommenter = @"";
            }];
            
        } else {
            commentUrl = [NSString stringWithFormat:ADD_COMMENTS, userId, self.song_id, preComment, @""];
            
            WEAK_SELF;
            NSLog(@"%@", commentUrl);
            [XWAFNetworkTool getUrl:commentUrl body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                STRONG_SELF;
                NSLog(@"评论成功%@",resposeObject);
                
#if ALLOW_MSG
                if (![self.user_id isEqualToString:userId]) {
                    /*msg type 1 评论*/
                    [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, self.user_id, userId, @"1", self.song_id, preComment, self.soundName] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                        
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        
                    }];
                }
                
#endif
                
                self.replyInputView.preCommenter = @"";
                [self getCommentsData];
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                NSLog(@"发送评论失败%@", error.description);
                self.replyInputView.preCommenter = @"";
            }];
            
        }
    }

}

#pragma mark - *************键盘通知**************

- (void)keyboardWillChangeFrame:(NSNotification *)notify {
    NSDictionary *dic = notify.userInfo;
    CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    //    if (keyboardRect.size.height >250 && self.flag) {
    if (keyboardRect.size.height >100) {
        WEAK_SELF;
        [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            STRONG_SELF;
            [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
            
            self.replyInputView.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
            
        }];
    }
}

//键盘出来的时候调整replyView的位置
- (void) keyChangeShow:(NSNotification *) notify {
    
    self.tapMaskView.hidden = NO;
    
    if ([UIResponder currentFirstResponder] == self.replyInputView.sendTextView) {
        [self pauseAction];
        self.isPlaying = NO;
        if (self.replyInputView.preCommenter.length == 0) {
            self.replyInputView.lblPlaceholder.text = [NSString stringWithFormat:@"在%@处评论", self.progressView.currentTime.text];
        }
    }
    
    
    NSDictionary *dic = notify.userInfo;
    CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
//    if (keyboardRect.size.height >250 && self.flag) {
    if (keyboardRect.size.height >100 && self.flag) {
        WEAK_SELF;
        [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
            STRONG_SELF;
            [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
        
            self.replyInputView.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
            
            if (self.commentsframeArray.count > 0) {
//                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:(self.commentsframeArray.count - 1) inSection:2];
                
//                [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//                self.mainTableView.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height);
            } else {
//                 NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:1];
//                [self.mainTableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionBottom animated:YES];
//                self.mainTableView.transform = CGAffineTransformMakeTranslation(0, -keyboardRect.size.height - 15 - 13 - 15);
            }
        }];
        self.flag = NO;
    }
}

//键盘出来的时候调整replyView的位置
-(void) keyChangeHide:(NSNotification *) notify {
    
    
    self.tapMaskView.hidden = YES;
    
    if ([UIResponder currentFirstResponder] == self.replyInputView.sendTextView) {
        [self continuePlayAction];
        self.isPlaying = YES;
    }

    self.replyInputView.preCommenter = @"";
    self.replyInputView.lblPlaceholder.text = @"输入评论";
    
    NSDictionary *dic = notify.userInfo;
//    CGRect keyboardRect = [dic[@"UIKeyboardFrameEndUserInfoKey"] CGRectValue];
    WEAK_SELF;
    [UIView animateWithDuration:[dic[UIKeyboardAnimationDurationUserInfoKey] floatValue] animations:^{
        STRONG_SELF;
        [UIView setAnimationCurve:[dic[UIKeyboardAnimationCurveUserInfoKey] doubleValue]];
        
        self.replyInputView.transform = CGAffineTransformIdentity;
        
        //        self.mainTableView.transform = CGAffineTransformIdentity;
        
    }completion:^(BOOL finished) {
//        NSLog(@"%@", NSStringFromCGRect(self.replyInputView.frame));
    }];
    self.flag = YES;
}

- (void)tapHide {
    [[UIResponder currentFirstResponder] resignFirstResponder];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
    CGFloat offsetY = scrollView.contentOffset.y;
    
    if (offsetY - self.markOffset < -5) {
        [[UIResponder currentFirstResponder] resignFirstResponder];
    }
    self.markOffset = offsetY;
    
    
    if (offsetY == 0) {
        [self resetNavView];
    } else {
        [self changeNaviOffset:offsetY];
        self.barageBtn.hidden = YES;
    }

    self.tmpOffsetY = offsetY;
    

//    NSLog(@"=----%f", scrollView.contentOffset.y / 240 * HEIGHT_NIT);
    
    CGFloat alpha = scrollView.contentOffset.y / 240 * HEIGHT_NIT;
    if (alpha > 1) {
        alpha = 1.0f;
    } else if (alpha < 0) {
        alpha = 0.0f;
    }
    self.backMaskView.alpha = 1 - alpha;
    self.bottomNavView.alpha = alpha;
}

- (void)resetNavView {
    CGRect frame1 = self.naviView.frame;
    CGRect frame2 = self.bottomNavView.frame;

    frame1.origin.y = 0;
    frame2.origin.y = 0;
    
    self.naviView.frame = frame1;
    self.bottomNavView.frame = frame2;
    
    self.barageBtn.hidden = NO;
}

- (void)changeNaviOffset:(CGFloat)offset {
    
    
    CGFloat gap = offset - self.tmpOffsetY;
    
    CGRect frame1 = self.naviView.frame;
    CGRect frame2 = self.bottomNavView.frame;
    
   
    frame1.origin.y -= gap;
    frame2.origin.y -= gap;
    
    if (frame1.origin.y > 0) {
        frame1.origin.y = 0;
    }
    if (frame1.origin.y < -self.naviView.height) {
        frame1.origin.y = -self.naviView.height;
    }
    
    if (frame2.origin.y > 0) {
        frame2.origin.y = 0;
    }
    if (frame2.origin.y < -self.bottomNavView.height) {
        frame2.origin.y = -self.bottomNavView.height;
    }
    
    self.naviView.frame = frame1;
    self.bottomNavView.frame = frame2;
}

- (void)showNavi {//naviView
    
    [UIView animateWithDuration:0.1 animations:^{
        self.naviView.transform = CGAffineTransformIdentity;
        self.bottomNavView.transform = CGAffineTransformIdentity;
    }];
}

- (void)hideNavi {
    [UIView animateWithDuration:0.1 animations:^{
        self.naviView.transform = CGAffineTransformMakeTranslation(0, -self.naviView.height);
        self.bottomNavView.transform = CGAffineTransformMakeTranslation(0, -self.bottomNavView.height);
    }];
}

- (void)removeNotification {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)createFlowerImages {
    UIImageView *tmpImageView = nil;
    [self.imagesArray removeAllObjects];
    for (int i = 0; i < 60; ++ i) {
        NSString *imageName = [NSString stringWithFormat:SNOW_IMAGENAME, arc4random()%24 + 2];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:IMAGENAMED(imageName)];
        
        float x = IMAGE_WIDTH;
        imageView.frame = CGRectMake(IMAGE_X, -30, x, x);
        imageView.alpha = IMAGE_ALPHA;
        [self.themeImageView addSubview:imageView];
        [self.imagesArray addObject:imageView];
        
        tmpImageView = imageView;
    }
    self.flowerTimer = [NSTimer scheduledTimerWithTimeInterval:.01 target:self selector:@selector(makeSnow) userInfo:nil repeats:YES];
    [self.flowerTimer setFireDate:[NSDate distantFuture]];
}

static int i = 0;
- (void)makeSnow {
    i = i + 1;
    if ([self.imagesArray count] > 0) {
        UIImageView *imageView = [_imagesArray objectAtIndex:0];
        imageView.tag = i;
        [self.imagesArray removeObjectAtIndex:0];
        [self snowFall:imageView];
    }
}

- (void)snowFall:(UIImageView *)aImageView {
    [UIView beginAnimations:[NSString stringWithFormat:@"%i",aImageView.tag] context:nil];
    [UIView setAnimationDuration:1.5];
    [UIView setAnimationDelegate:self];
    aImageView.frame = CGRectMake(aImageView.frame.origin.x, HOME_HEAD_IMGH * HEIGHT_NIT, aImageView.frame.size.width, aImageView.frame.size.height);
    aImageView.alpha = IMAGE_ALPHA;
    //    NSLog(@"%@",aImageView);
    [UIView commitAnimations];
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context {
    UIImageView *imageView = (UIImageView *)[self.view viewWithTag:[animationID intValue]];
    float x = IMAGE_WIDTH;
    imageView.frame = CGRectMake(IMAGE_X, -30, x, x);
    imageView.alpha = 1.0f;
    [_imagesArray addObject:imageView];
}

#pragma mark - *************生命周期**************
- (void)viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.currentY = 15 * HEIGHT_NIT;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.tapMaskView = [UIButton new];
    self.tapMaskView.backgroundColor = [UIColor clearColor];
    self.tapMaskView.frame = self.view.bounds;
    self.tapMaskView.hidden = YES;
    [self.tapMaskView addTarget:self action:@selector(tapHide)];
    
    self.rvc = [RecoderController new];
    self.needReload = YES;
    self.midiParserManager = [MidiParserManager new];
    [[NSUserDefaults standardUserDefaults] setObject:IS_TEST_NO forKey:IS_TEST];
    
    self.needReload = YES;

    self.lyricURL = [NSString stringWithFormat:HOME_LYRIC, self.songCode];
    self.soundURL = [NSString stringWithFormat:HOME_SOUND, self.songCode];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    //获取通知中心
    NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    //注册为被通知者
    [notificationCenter addObserver:self selector:@selector(keyChangeShow:) name:UIKeyboardWillShowNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyboardWillChangeFrame:) name:UIKeyboardWillChangeFrameNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(keyChangeHide:) name:UIKeyboardWillHideNotification object:nil];
    [notificationCenter addObserver:self selector:@selector(sendCommentAfterLogin) name:SEND_COMMENT_AFTER_LOGIN object:nil];
    [notificationCenter addObserver:self selector:@selector(userSongShareAction:) name:@"userSongShare" object:nil];
    [notificationCenter addObserver:self selector:@selector(popCheatView) name:@"popCheatView" object:nil];

//    [[NSNotificationCenter defaultCenter] postNotificationName:@"wxPaySuccess" object:nil];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeBackGround1) name:@"applicationBackGround" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive1) name:@"applicationActive" object:nil];
    
    self.tableViewHeadView = [UIView new];
    self.tableViewHeadView.frame = self.view.bounds;
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.barrageIsInit = NO;
    
    [self createMainTableView];
    [self createImageView];
    [self createNaviView];
    [self creataPlayer];
    [self.view addSubview:self.tapMaskView];
    [self createReplyView];
    [self createShareView];
    
    self.isFocus = NO;
    self.isFocusAtLast = self.isFocus;
//    [self isFocusAndLikeByNetWork];

    self.userInfoDataSource = [[NSMutableDictionary alloc] initWithCapacity:0];
    self.giftUserDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self tmpRequest];
}


- (void)tmpRequest {
    
    self.currentGiftBarrageIndex = 0;
    self.currentIndex = 0;
    self.sentenceTime = 0;
    self.totalTime = 0;
    self.currentIndex = 0;
    self.currentTmpIndex = 0;
    //https://service.woyaoxiege.com/core/home/data/getSongByCode?code=a93beac3bc8c0b27679b0054cb504399_2651
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_SONG_MESS, self.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        
        STRONG_SELF;
        
        NSDictionary *dic = resposeObject;
        
        self.songModel = [[SongModel alloc] initWithDictionary:dic error:nil];
        
        AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        
        app.template_id = self.songModel.template_id;
        
        self.lyricURL = [NSString stringWithFormat:HOME_LYRIC, self.songCode];
        self.soundURL = [NSString stringWithFormat:HOME_SOUND, self.songCode];
        self.soundName = self.songModel.title;
        
        
        self.listenCount = [self.songModel.play_count integerValue];
        
        if (self.listenCount > 10000) {
            self.listenLabel.text = [NSString stringWithFormat:@"%.2f万", self.listenCount / 10000.0];
        } else {
            self.listenLabel.text = [NSString stringWithFormat:@"%ld", self.listenCount];
        }
        CGFloat width = [AXGTools getTextWidth:self.listenLabel.text font:self.listenLabel.font];
        
        self.erjiImageView.frame = CGRectMake(self.view.width - width - 16 * WIDTH_NIT - 5 * WIDTH_NIT - 15 * WIDTH_NIT, 0, 15 * WIDTH_NIT, 14.5 * WIDTH_NIT);
        self.erjiImageView.center = CGPointMake(self.erjiImageView.centerX, self.lyricsView.centerY);
        
        
        self.user_id = self.songModel.user_id;
        self.createTimeStr = self.songModel.create_time;
        self.loveCount = self.songModel.up_count;
        self.song_id = self.songModel.dataId;
        self.needReload = YES;
        self.navTitleLabel.text = self.soundName;
        NSString *imgUrl = [NSString stringWithFormat:GET_SONG_IMG, self.songCode];
        UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:imgUrl]]];
        self.themeImageView.image = image;
        
        [self themeImageView];
        
        [self.progressView setProgress:0.0 withAnimated:NO];
        
        [self getGiftData];
        
        [self requestOtherData];
        
        NSLog(@"%@--------%@", self.soundURL, self.lyricURL);
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_PLAYCOUNT, self.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error.description);
    }];
    
}


- (void)requestMidiData {
    if (![XWAFNetworkTool checkNetwork]) {
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    NSString *getMidiUrl = [NSString stringWithFormat:GET_MIDI_FILE, self.songCode];
    WEAK_SELF;
    [XWAFNetworkTool getUrl:getMidiUrl body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        if (self.shouldPlay) {
            
            [self.midiParserManager parserMidi:resposeObject lyricContent:nil];
            
            [self.musicPlayer playWithUrl:self.soundURL];
            self.isPlaying = YES;
            [self play];
  
            [self getTimeAndProgeress];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"midi数据错误%@", error.description);
        STRONG_SELF;
        [self tryToRequestXianQuMid];
    }];
}

#define XIANQU_MID  @"https://service.woyaoxiege.com/music/zouyin_mid/%@.mid"

- (void)tryToRequestXianQuMid {
    if (![XWAFNetworkTool checkNetwork]) {
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    NSString *getMidiUrl = [NSString stringWithFormat:TEMPLATE_BY_ID, self.songModel.template_id];
    WEAK_SELF;
    [XWAFNetworkTool getUrl:getMidiUrl body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
        
        NSString *time_file = dic[@"time_file"];
        
        
        
        [XWAFNetworkTool getUrl:time_file body:nil response:XWData requestHeadFile:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id resposeObjects) {
            STRONG_SELF;
            unsigned long encode1 = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
            NSString *str_gb180301 = [[NSString alloc] initWithData:resposeObjects encoding:encode1];
            
            if (!str_gb180301) {
                str_gb180301 = [[NSString alloc] initWithData:resposeObjects encoding:NSUTF8StringEncoding];
            }
            self.time_file_string = str_gb180301;
            if (self.time_file_string.length > 0) {
                NSString *str = self.time_file_string;
                
                str = [str stringByReplacingOccurrencesOfString:@"," withString:@"，"];
                str = [str stringByReplacingOccurrencesOfString:@"：" withString:@":"];
                NSArray *tmpArr = [str componentsSeparatedByString:@"，"];
                self.lrcTimeArray = [[NSMutableArray alloc] initWithCapacity:tmpArr.count];
                for (NSString *time in tmpArr) {
                    NSInteger timeNum = 0;
                    NSArray *tmpA = [time componentsSeparatedByString:@":"];
                    NSInteger minNum = [tmpA[0] integerValue];
                    NSInteger secNum = [tmpA[1] integerValue];
                    timeNum = minNum * 60 + secNum;
                    [self.lrcTimeArray addObject:[NSString stringWithFormat:@"%ld", timeNum]];
                }
            }
            
            [self playAfterRequest];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error.description);
            [KVNProgress showErrorWithStatus:@"时间轴错误"];
            [self playAfterRequest];
        }];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"走音歌曲请求错误%@", error.description);
        [self playAfterRequest];
    }];
}

//- (NSMutableArray *)lrcTimeArray {
//    if (_lrcTimeArray) {
//        _lrcTimeArray = [NSMutableArray array];
//    }
//    return _lrcTimeArray;
//}

- (void)playAfterRequest {

    if (self.shouldPlay) {
        
        [self.musicPlayer playWithUrl:self.soundURL];
        self.isPlaying = YES;
        [self play];
#if ALLOW_BARRAGE
        [_renderer start];
#endif
        [self getTimeAndProgeress];
    }

}

- (void)requestOtherData {
    
    if (self.listenCount >= 10000) {
        self.playCount.text = [NSString stringWithFormat:@"%.1f万", self.listenCount / 10000.0];
    }
//    self.playCount.text = [NSString stringWithFormat:@"%ld", self.listenCount];
    __weak typeof(self)weakSelf = self;
    
    if (self.needReload && self.user_id) {
        
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, self.user_id] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            NSLog(@" userinfo %@", resposeObject);
            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                [weakSelf.userInfoDataSource setObject:[resposeObject[@"name"] emojizedString] forKey:@"name"];
                [weakSelf.userInfoDataSource setObject:resposeObject[@"phone"] forKey:@"phone"];
//                weakSelf.createTimeStr = [weakSelf.createTimeStr substringToIndex:10];
//                weakSelf.createTimeStr = [weakSelf.createTimeStr stringByReplacingOccurrencesOfString:@"-" withString:@"/"];
                [weakSelf.userInfoDataSource setObject:weakSelf.createTimeStr forKey:@"createTime"];

                [self.mainTableView reloadData];
                //http://service.woyaoxiege.com/core/home/data/getUserById?id=20590
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {

        }];
    }
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_FOCUS, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        NSLog(@"%@", resposeObject);
        
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            weakSelf.focusBtn.enabled = YES;
            NSArray *array = resposeObject[@"items"];
            
            weakSelf.isFocus = NO;
            
            for (NSDictionary *dic in array) {
                if ([dic[@"focus_id"] isEqualToString:weakSelf.self.user_id]) {
                    weakSelf.isFocus = YES;
                    
                    if (!weakSelf.isFocus) {
                        
                        [weakSelf.focusBtn setImage:[UIImage imageNamed:@"playUser加关注"] forState:UIControlStateNormal];
                        
                    } else {
                        [weakSelf.focusBtn setImage:[UIImage imageNamed:@"playUser已关注"] forState:UIControlStateNormal];
                    }
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    [self getData];
}

- (void)beginShowBarrage:(CGFloat)totalTime {
#if ALLOW_BARRAGE
    
    NSInteger totalCount = self.commentsframeArray.count;
    
    CGFloat duration = totalTime / totalCount;
    
    NSLog(@"弹幕时间间隔为---%f", duration);
    
    [_renderer start];
    
    NSSafeObject * safeObj = [[NSSafeObject alloc]initWithObject:self withSelector:@selector(autoSendBarrage)];
    
    _timer = [NSTimer scheduledTimerWithTimeInterval:duration target:safeObj selector:@selector(excute) userInfo:nil repeats:YES];
    
    [_timer setFireDate:[NSDate distantPast]];
#endif
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.shouldPlay = YES;
    NSString *vcName = NSStringFromClass([self class]);
    [MobClick beginLogPageView:vcName];
    
    self.isFocus = NO;
    self.shouldShowBarrage = YES;
    self.flag = YES;
    self.isPlaying = YES;
    self.isEnd = NO;
    
    if (!self.isPlaying) {
        [self continuePlayAction];
        self.isPlaying = YES;
    }
    if ([[NSUserDefaults standardUserDefaults] boolForKey:@"wxPayResult"]) {
        [self showPaySuccessView];
    }
}

- (NSMutableArray *)imagesArray {
    if (_imagesArray == nil) {
        _imagesArray = [NSMutableArray array];
    }
    return _imagesArray;
}

- (void)showPaySuccessView {
    
    // 发送送礼物的消息
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    
    if (![self.user_id isEqualToString:userId]) {
        /*msg type 5 礼物*/
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, self.user_id, userId, @"5", self.song_id, @"", self.soundName] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
    PaySuccessView *successView = [[PaySuccessView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:successView];
    [UIView animateWithDuration:1 delay:3 options:0 animations:^{
        successView.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [successView removeFromSuperview];
        
//        [_renderer receive:[self walkTextSpriteDescriptorWithDirection:BarrageWalkDirectionR2L model:model textColor:[UIColor redColor]]];
        
        [self showFlowers];
    }];
    
}

- (void)sendGiftBarrage:(NSString *)content userName:(NSString *)userName userPhone:(NSString *)phone{
    
//    [self sendComments:content];
    
    BarrageDescriptor * descriptor = [[BarrageDescriptor alloc]init];
    descriptor.spriteName = NSStringFromClass([BarrageWithFlowers class]);
    descriptor.params[@"text"] = content;
    descriptor.params[@"trackNumber"] = @4;
    /**
     *imageUrl;
     *userName;
     *upCount;
     */
    NSString *userHead = [NSString stringWithFormat:GET_USER_HEAD, [NSString stringWithFormat:@"%@", [XWAFNetworkTool md5HexDigest:phone]]];
    descriptor.params[@"imageUrl"] = userHead;
    descriptor.params[@"userName"] = [userName stringByAppendingString:@":"];
    descriptor.params[@"upCount"] = @"";
    descriptor.params[@"speed"] = @80;
    descriptor.params[@"direction"] = @(BarrageWalkDirectionR2L);
    descriptor.params[@"clickAction"] = ^{
    };
    [_renderer receive:descriptor];
}

- (void)showFlowers {
    [self continuePlayAction];
    self.isPlaying = YES;
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *phone = [wrapper objectForKey:(id)kSecAttrAccount];
    [self sendGiftBarrage:@"一朵鲜花送给你" userName:@"我" userPhone:phone];
//    [self createFlowerImages];
//    [self.flowerTimer setFireDate:[NSDate distantPast]];
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        [self.flowerTimer setFireDate:[NSDate distantFuture]];
//    });
}

- (void)changeLyricStrWithTime:(NSInteger)currentTime {
    
    if (self.sentenceTime >= 0) {
//        static NSInteger time = 0;
//        static NSInteger index = 0;
        double inter = 0;
        modf(self.sentenceTime, &inter);
        
        double inter1 = 0;
        
        modf(currentTime, &inter1);
        
//        NSLog(@"%f--%f", inter, inter1);
        
        if (inter1 == inter * (self.currentTmpIndex+1) && inter != 0) {
            self.currentTmpIndex++;
            if (self.currentTmpIndex < self.lyricFrameModel.lyricStrArray.count) {
                [self.lyricsView setText:self.lyricFrameModel.lyricStrArray[self.currentTmpIndex]];
                [self changeLyricColor];
            } else {
//                [_lyricTimer setFireDate:[NSDate distantFuture]];
                [self.lyricsView stopAnimation];
                self.currentTmpIndex = 0;
            }
//            time = 0;
        }
//        time ++;
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.shouldPlay = NO;
    NSString *vcName = NSStringFromClass([self class]);
    [MobClick endLogPageView:vcName];

    
    [self pauseAction];
    
    self.isPlaying = NO;
    // 根据最终结果判断是否改变关注状态
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
}

// 根据最终结果改变是否关注
- (void)changeFocusAndLikeStatus {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    
    if (self.isFocusAtLast != self.isFocus) {
        
        __weak typeof(self)weakSelf = self;
        
        if (self.isFocusAtLast) {
            
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_FOCUS, weakSelf.user_id, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                    NSLog(@"添加关注成功");
#if ALLOW_MSG
                    if (![self.user_id isEqualToString:userId]) {
                        /*msg type 2 关注*/
                        [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, self.user_id, userId, @"2", self.song_id, @"", @""] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                            
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            
                        }];
                    }
                    
#endif
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        } else {

            [XWAFNetworkTool getUrl:[NSString stringWithFormat:DEL_FOCUS, weakSelf.user_id, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                    NSLog(@"取消关注成功");
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        }
    }
    
    if (self.isLikeAtLast != self.isLike) {
        
        __weak typeof(self)weakSelf = self;
        
        if (self.isLikeAtLast) {
            
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_LIKE, userId, weakSelf.song_id] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                    NSLog(@"添加收藏成功");
                    
#if ALLOW_MSG
                    if (![self.user_id isEqualToString:userId]) {
                        /*msg type 0 点赞*/
                        [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, self.user_id, userId, @"0", self.song_id, @"", @""] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                            
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            
                        }];
                    }
                   
#endif
                    
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        } else {
            
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:DEL_LIKE, userId, weakSelf.user_id] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                    NSLog(@"取消收藏成功");
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.navigationController setNavigationBarHidden:YES];
//    [self delaShow];
//    [self ysl_addTransitionDelegate:self];
//    [self ysl_popTransitionAnimationWithCurrentScrollView:nil
//                                    cancelAnimationPointY:0
//                                        animationDuration:0.3
//                                  isInteractiveTransition:YES];
}

/**
 *  解析midi完成 YES成功 NO失败
 */
- (void)midiParserDone:(BOOL)result {
    if (result) {
        self.sentenceTime = self.midiParser.baseTicks * 4.0 * 2.0 / self.midiParser.baseTicks * (60.0 / self.midiParser.currentBpm)+0;
        NSLog(@"每一句的时间为%f", self.sentenceTime);
        [self requestOtherData];
    }
}

- (void)delaShow {
    WEAK_SELF;
    [UIView animateWithDuration:0.8f animations:^{
        STRONG_SELF;
//        self.naviView.alpha = 0.5f;
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark -- YSLTransitionAnimatorDataSource
- (UIImageView *)popTransitionImageView {
    return self.themeImageView;
}

- (UIImageView *)pushTransitionImageView {
    return nil;
}

#pragma mark - 屏幕方向

- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
