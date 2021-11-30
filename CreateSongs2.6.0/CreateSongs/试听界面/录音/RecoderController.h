//
//  RecoderController.h
//  CreateSongs
//
//  Created by axg on 16/7/8.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PlayViewController.h"
#import "XMidiPlayer.h"

#define RECODER_FILE    @"Recodering.wav"
#define FIRST_TAG       10
#define SECOND_TAG      11
#define THIRD_TAG       12
#define RECoding_TAG    13
#define RECoded_TAG     14
#define BEGINRecod_TAG  15

#define kFourLyricHeight (20+15)*HEIGHT_NIT

#define ZOUYIN_URL  @"http://1.117.109.129/core/home/index/template"
//http://1.117.109.129/core/music/zouyin_lrc/frx.lrc
//#define ZOUYIN_LRC  @"http://1.117.109.129/core/music/zouyin_lrc/%@_play.lrc"
#define ZOUYIN_BANXOU   @"http://1.117.109.129/core/music/zouyin_acc/%@.mp3"
@interface RecoderController : PlayViewController

@property (nonatomic, strong) XMidiPlayer *midiPlayer;

@property (nonatomic, strong) UIButton *beginRecord;
@property (nonatomic, strong) UIButton *firstNumber;

@property (nonatomic, strong) UIImageView *bottomBgImage;

@property (nonatomic, assign) BOOL isShared;

//@property (nonatomic, copy) NSString *zouyin_banzouUrl;

//@property (nonatomic, copy) NSString *songName;

//@property (nonatomic, assign) BOOL isFirstPlay;

//@property (nonatomic, strong) NSMutableArray *lrcTimeArray;

@property (nonatomic, strong) NSData *recoderData;

//@property (nonatomic, assign) BOOL isFromPlayView;

@property (nonatomic, assign) BOOL isAutoToEnd;
/**
 *  最终录音文件
 */
@property (nonatomic, copy) NSString *finalPath;
@property (nonatomic, copy) NSString *finalBanzouPath;

@property (nonatomic, assign) BOOL shouldDone;

@property (nonatomic, copy) NSString *shareMp3Url;
@property (nonatomic, copy) NSString *shareWebUrl;
@property (nonatomic, copy) NSString *shareSongName;
@property (nonatomic, copy) NSString *firstSongCode;

//@property (nonatomic, copy) NSDictionary *zouyinUrl;
//@property (nonatomic, copy) NSString *requestHeadName;

@property (nonatomic, assign) BOOL isFromUserSong;

//@property (nonatomic, assign) BOOL isFromTianciPage;

//@property (nonatomic, assign) BOOL isFirstGetZouyinMp3;

@property (nonatomic, assign) NSInteger tmpMark;
/**
 *  是否点击过录音按钮
 */
@property (nonatomic, assign) BOOL isRecorded;

- (void)beforeRecoder:(UIButton *)sender;
- (void)beginRecoder:(UIButton *)sender;
- (void)recodeDoneState;
- (void)stopRecorder;
// 可用缓冲区
- (NSTimeInterval)availableDuration;
- (void)createBottomBtn;
@end
