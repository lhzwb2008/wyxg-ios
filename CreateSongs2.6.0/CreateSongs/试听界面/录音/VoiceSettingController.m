//
//  VoiceSettingController.m
//  CreateSongs
//
//  Created by axg on 16/8/22.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "VoiceSettingController.h"
#import "PlayViewCustomProgress.h"
#import "Volum_SettingView.h"
#import "LyricTableViewCell.h"
#import "AppDelegate.h"
#import "AXGMusicPlayer.h"
#import "AXGMixer.h"
#import "lame.h"
#import "SongLoadingView.h"
#import <UMCommon/MobClick.h>
#import "KVNProgress.h"
#import "AFNetworking.h"
#import "AXGHeader.h"
#import "RecoderHeader.h"
#import "AXGMessage.h"
#import "TianciDBFile.h"
#import "ReleaseViewController.h"
#import "SuperpowerManager.h"
#import <QuartzCore/QuartzCore.h>

@interface VoiceSettingController ()<UITableViewDataSource, UITableViewDelegate> {
    SuperpowerManager *manager;
    CADisplayLink *displayLink;
    int frame, config;
    uint64_t *superpoweredAvgUnits, *superpoweredMaxUnits, *coreaudioAvgUnits, *coreaudioMaxUnits;
}

@property (nonatomic, strong) UITableView *lrcTableView;

@property (nonatomic, strong) UIView *tableBackGround;

@property (nonatomic, strong) PlayViewCustomProgress *set_Progress;

@property (nonatomic, strong) Volum_SettingView *volum_view1;

@property (nonatomic, strong) Volum_SettingView *volum_view2;

@property (nonatomic, assign) CGFloat cellHeight;

@property (nonatomic, assign) NSInteger currentRow;

@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, assign) BOOL isEnd;

@property (nonatomic, assign) BOOL shouldRefreshUI;

@property (nonatomic, assign) BOOL shouldPopBack;

@property (nonatomic, assign) CGFloat totalTime;

@property (nonatomic, assign) CGFloat volume1;

@property (nonatomic, assign) CGFloat volume2;

@property (nonatomic, strong) SongLoadingView *songLoading;

@property (nonatomic, copy) NSString *finalMixPath;//最终MP3路径
/**
 *  用于实时获取播放时间的观察者对象
 */
@property (nonatomic, weak) id observer;

@end

@implementation VoiceSettingController
- (void)viewDidLoad {
    
    [super viewDidLoad];

    self.shouldPopBack = NO;
    self.isEnd = NO;
    self.isPlaying = NO;
    CGSize lyricSize = [@"歌词" getWidth:@"歌词" andFont:ZHONGDENG_FONT(18*HEIGHT_NIT)];
    if (kDevice_Is_iPad || kDevice_Is_iPad3 || kDevice_Is_iPhone4) {
        self.cellHeight = lyricSize.height + 8;
    } else {
        self.cellHeight = lyricSize.height + 15*HEIGHT_NIT;
    }
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    [self createLrcTableView];
    [self createSettingView];
    [self createBottomBtn];
    [self settingNavview];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (
        self.recoderPath.length <= 0 ||
        self.banzouPath.length <= 0 ||
        self.recoderPath == nil ||
        self.banzouPath == nil ||
        ![fileManager fileExistsAtPath:self.recoderPath] ||
        ![fileManager fileExistsAtPath:self.banzouPath]
        )
    {
        [KVNProgress showErrorWithStatus:@"音源文件错误"];
        return;
    }
    [self beginPlayDoubleVoice];
    
    config = 0;
    int bytes = sizeof(uint64_t) * pow(2, NUMFXUNITS);
    superpoweredAvgUnits = (uint64_t *)calloc(1, bytes);
    superpoweredMaxUnits = (uint64_t *)calloc(1, bytes);
    coreaudioAvgUnits = (uint64_t *)calloc(1, bytes);
    coreaudioMaxUnits = (uint64_t *)calloc(1, bytes);
    frame = 0;
    displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(onDisplayLink)];
    displayLink.frameInterval = 1;
    [displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
}

- (void)dealloc {
    NSLog(@"dealloc");
}

- (void)leftBackBtnAction:(UIButton *)btn {
    
    [self pause];
    
    if (!self.shouldPopBack) {
        [AXGMessage showTextSelectMessageOnView:self.view title:@"是否放弃已录制歌曲" leftButton:@"继续" rightButton:@"放弃"];
        WEAK_SELF;
        [AXGMessage shareMessageView].leftButtonBlock = ^ () {
        };
        [AXGMessage shareMessageView].rightButtonBlock = ^ () {
            STRONG_SELF;
            [[AXGMessage shareMessageView] removeFromSuperview];
            [self backController];
        };
    } else {
        [self backController];
    }
}

- (void)backController {
    
    [displayLink removeFromRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    [displayLink invalidate];
    displayLink = nil;
    free(superpoweredAvgUnits);
    free(superpoweredMaxUnits);
    free(coreaudioAvgUnits);
    free(coreaudioMaxUnits);
    [manager closeSuperPower];
    manager = nil;
    self.volum_view1.sliderBlock = nil;
    self.volum_view2.sliderBlock = nil;
    [self.volum_view1 removeFromSuperview];
    [self.volum_view2 removeFromSuperview];
    self.volum_view1 = nil;
    self.volum_view2 = nil;
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)onDisplayLink {

    if (frame < 60) {
        frame++;
    } else {
        frame = 0;
        if (manager->playing) {
            superpoweredAvgUnits[config] = manager->avgUnitsPerSecond;
            superpoweredMaxUnits[config] = manager->maxUnitsPerSecond;
        }
        if (coreaudioAvgUnits[config] == 0) {
            
        }
        else if (superpoweredAvgUnits[config] == 0) {
            
        }
            else {
                NSString *str = nil;
                if (superpoweredAvgUnits[config] < coreaudioAvgUnits[config]) {
                    str = [[NSString alloc] initWithFormat:
                           @"Superpowered processes %.1fx\nfaster than Core Audio:\n\n%.1f%% (avg), %.1f%% (peak)\nless CPU.",
                           ((double)coreaudioAvgUnits[config]) / ((double)superpoweredAvgUnits[config]),
                           (1.0 - (((double)superpoweredAvgUnits[config]) / ((double)coreaudioAvgUnits[config]))) * 100.0,
                           (1.0 - (((double)superpoweredMaxUnits[config]) / ((double)coreaudioMaxUnits[config]))) * 100.0
                           ];
                } else {
                    str = [[NSString alloc] initWithFormat:
                           @"Core Audio processes %.1fx\nfaster than Superpowered:\n\n%.1f%% (avg), %.1f%% (peak)\nless CPU.",
                           ((double)superpoweredAvgUnits[config]) / ((double)coreaudioAvgUnits[config]),
                           (1.0 - (((double)coreaudioAvgUnits[config]) / ((double)superpoweredAvgUnits[config]))) * 100.0,
                           (1.0 - (((double)coreaudioMaxUnits[config]) / ((double)superpoweredMaxUnits[config]))) * 100.0
                           ];
                };
            };
    }
    [manager updateProgress:self.set_Progress];
}

- (void)getRow {
    
}

- (void)beginPlayDoubleVoice {
    
    manager = [SuperpowerManager new];
    
    WEAK_SELF;
    manager.pause_block = ^{
        STRONG_SELF;
        [self pause];
    };
    manager.filter_done = ^(NSString *finalPath){
        STRONG_SELF;
        self.finalMixPath = finalPath;
        
        [self uploadMixData];
    };
    manager.progress_change = ^(int currentTime, int totalTime) {
        STRONG_SELF;
        if (currentTime == 0) {
            self.currentRow = 0;
            [self.lrcTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
            [self.lrcTableView reloadData];
        } else {
            // 刷新歌词
            NSInteger currentRow;
            currentRow = ((currentTime+1.0) * self.lrcDataSource.count) / totalTime;
            if (currentRow < self.lrcDataSource.count && totalTime != 0) {
                self.currentRow = currentRow;
                [self.lrcTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                [self.lrcTableView reloadData];
            }
        }
    };
    [manager initFilter];
    [manager playDoubleVoice:self.recoderPath otherUrl:self.banzouPath];
    [manager setFirstVolume:0.5f];
    [manager setSecondVolume:0.5f];
    [self play];
}

- (void)stopDoubleVoice {
    
    [manager pause];
}

- (void)pause {
    
    [manager pause];
    [self.set_Progress.playBtn setSelected:YES];
    self.isPlaying = NO;
}

- (void)replay {
    
    [manager seekTo:0.0f];
    [self play];
}

- (void)play {
    
    [manager play];
    [self.set_Progress.playBtn setSelected:NO];
    self.isPlaying = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self pause];
}

- (void)settingNavview {
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton addTarget:self action:@selector(leftBackBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.navRightButton setTitle:@"保存" forState:UIControlStateNormal];
    [self.navRightButton addTarget:self action:@selector(rightBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navTitle.text = self.songName;
}

- (void)rightBtnAction:(UIButton *)btn {
    
    [self pause];
    
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:DB_NAME];
    [store createTableWithName:RECODER_DB];
    
    NSString *songContent = @"";
    
    for (NSInteger i = 0; i < self.lrcDataSource.count; i++) {
    
        NSString *lrc = self.lrcDataSource[i];
        
        if (i > 0) {
            songContent = [songContent stringByAppendingString:@","];
        }
        songContent = [songContent stringByAppendingString:lrc];
        
        NSLog(@"%@", songContent);
    }
    
    NSString *saveTime = [self getCurrentTime];
    
    NSData *banzouData = [NSData dataWithContentsOfFile:self.banzouPath];
    [TianciDBFile setObject:banzouData forKey:[NSString stringWithFormat:@"%@%@.mp3",  MD5Hash(saveTime), @"banzou"]];
    
    NSData *recoderData = [NSData dataWithContentsOfFile:self.recoderPath];
    [TianciDBFile setObject:recoderData forKey:[NSString stringWithFormat:@"%@%@.mp3",  MD5Hash(saveTime), @"recoder"]];
    [store putObject:@{
                       @"title":self.songName,
                       @"content":songContent,
                       @"saveTime":saveTime,
                       @"shareUrl":self.shareUrl,
                       @"mp3Url":self.mp3Url,
                       @"code":self.code,//
                       @"banzouPath":[NSString stringWithFormat:@"%@%@.mp3",  MD5Hash(saveTime), @"banzou"],
                       @"recoderPath":[NSString stringWithFormat:@"%@%@.mp3",  MD5Hash(saveTime), @"recoder"]
                    
                       } withId:saveTime intoTable:RECODER_DB];
    
    [AXGMessage showImageToastOnView:self.view image:[UIImage imageNamed:@"弹出框_保存草稿"] type:1];
    
    self.shouldPopBack = YES;
    // 2s后按钮恢复点击
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        btn.enabled = YES;
    });
}

// 获取当前时间
- (NSString *)getCurrentTime {
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    //    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    NSString *dataTime = [formatter stringFromDate:[NSDate date]];
    return dataTime;
}

- (void)createLrcTableView {
    
    self.tableBackGround = [UIView new];
    self.tableBackGround.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    self.tableBackGround.frame = CGRectMake(0, self.navView.bottom, self.view.width, 207*HEIGHT_NIT);
    self.lrcTableView = [UITableView new];
    self.lrcTableView.userInteractionEnabled = NO;
    self.lrcTableView.frame = CGRectMake(0, self.navView.bottom, self.view.width, 207*HEIGHT_NIT-50*HEIGHT_NIT);
    self.lrcTableView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    self.lrcTableView.dataSource = self;
    self.lrcTableView.delegate = self;
    self.lrcTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.lrcTableView.showsHorizontalScrollIndicator = NO;
    self.lrcTableView.showsVerticalScrollIndicator = NO;
    
    UIView *tableHeadView = [UIView new];
    tableHeadView.backgroundColor = [UIColor clearColor];
    CGFloat headHeight = 0.00001;
    if (self.lrcDataSource.count < 5) {
        headHeight = (5 - self.lrcDataSource.count) / 2 * self.cellHeight;
    }
    tableHeadView.frame = CGRectMake(0, 0, self.lrcTableView.width, headHeight);
    self.lrcTableView.tableHeaderView = tableHeadView;
    
    
    UIImageView *maskImage = [UIImageView new];
    maskImage.frame = CGRectMake(0, self.lrcTableView.bottom-85*HEIGHT_NIT, self.lrcTableView.width, 85*HEIGHT_NIT);
    maskImage.image = [UIImage imageNamed:@"调音歌词遮罩"];
    
    self.set_Progress = [[PlayViewCustomProgress alloc] initWithFrame:CGRectMake(0, self.tableBackGround.bottom - 50*HEIGHT_NIT, self.view.width, 50*HEIGHT_NIT) andType:PlayingType];
    WEAK_SELF;
    self.set_Progress.playBtnBlock = ^(BOOL isPlaying){
        STRONG_SELF;
        self.isPlaying = !isPlaying;
        [self playBtnClick];
    };
    
    self.set_Progress.sliderDidChangedBlock = ^(CGFloat value) {
        STRONG_SELF;
        [self sliderValueChanged:value];
    };
    
    [self.view addSubview:self.tableBackGround];
    [self.view addSubview:self.lrcTableView];
    [self.view addSubview:maskImage];
    [self.view addSubview:self.set_Progress];
    
    [self.lrcTableView reloadData];
}
// 进度条拖动方法
- (void)sliderValueChanged:(CGFloat)value {
    [manager seekTo:value];
    [self play];
}

- (void)playBtnClick {
    if (self.isEnd) {
        [self replay];
    } else {
        if (self.isPlaying) {
            [self pause];
        } else {
            [self play];
        }
    }
}

- (void)createSettingView {
    
    CGSize titleSize = [@"" getWidth:@"音量调节" andFont:[UIFont boldSystemFontOfSize:12]];
    
    UILabel *title = [UILabel new];
    title.frame = CGRectMake(16*WIDTH_NIT, self.tableBackGround.bottom + 25*HEIGHT_NIT, 100, titleSize.height);
    title.font = [UIFont boldSystemFontOfSize:12];
    title.textColor = [UIColor colorWithHexString:@"#451d11"];
    title.text = @"音量调节";
    [self.view addSubview:title];
    
    WEAK_SELF;
    self.volum_view1 = [[Volum_SettingView alloc] initWithFrame:CGRectMake(0, title.bottom + 50*HEIGHT_NIT, self.view.width, 81*HEIGHT_NIT) withValueBlock:^(CGFloat value) {
        STRONG_SELF;
//        self.loop1.volume = value;
        self.volume1 = value;
        [manager setFirstVolume:value];
//        NSLog(@"~~%f", value);
    }];
    self.volum_view1.set_title.text = @"人声";
    
    self.volum_view2 = [[Volum_SettingView alloc] initWithFrame:CGRectMake(0, self.volum_view1.bottom + 25*HEIGHT_NIT, self.view.width, 81*HEIGHT_NIT) withValueBlock:^(CGFloat value) {
        STRONG_SELF;
//        self.loop2.volume = value;
        self.volume2 = value;
        [manager setSecondVolume:value];
//        NSLog(@"==%f", value);
    }];
    self.volum_view2.set_title.text = @"伴奏";
    
    self.volume1 = 0.5f;
    self.volume2 = 0.5f;
    
    
    [self.view addSubview:self.volum_view1];
    [self.view addSubview:self.volum_view2];
}

- (void)createBottomBtn {
    // 制作歌曲按钮
    UIButton *createButton = [UIButton new];
    [self.view addSubview:createButton];
    createButton.frame = CGRectMake(0, 0, 250 * WIDTH_NIT, 50 * WIDTH_NIT);
    //    createButton.backgroundColor = HexStringColor(@"#879999");
    [createButton setTitle:@"发 布" forState:UIControlStateNormal];
    [createButton setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
    [createButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateHighlighted];
    [createButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色"] forState:UIControlStateNormal];
    [createButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色高亮"] forState:UIControlStateHighlighted];
    createButton.titleLabel.font = JIACU_FONT(18);
    createButton.layer.cornerRadius = createButton.height / 2;
    createButton.layer.masksToBounds = YES;
    createButton.center = CGPointMake(self.view.width / 2, self.view.height - 35 * HEIGHT_NIT - 25 * WIDTH_NIT);
    [createButton addTarget:self action:@selector(releaseBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:createButton];
}



// 播放结束方法
- (void)playToEnd{
    [self stopDoubleVoice];
    self.shouldRefreshUI = NO;
    self.isPlaying = NO;
    self.isEnd = YES;
    self.currentRow = 0;
    [self.set_Progress.playBtn setSelected:YES];
    [self.set_Progress.currentTime setText:@"0:00"];
    [self.set_Progress setProgress:0 withAnimated:NO];
    [self.lrcTableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self.lrcTableView reloadData];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lrcDataSource.count + 2;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyricTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SettingViewLyricTableViewCellIdentifier"];
    if (cell == nil) {
        cell = [[LyricTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingViewLyricTableViewCellIdentifier"];
    }
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
    cell.index = indexPath.row;
    
    if (self.lrcDataSource.count > indexPath.row) {
        NSString *lyr = [self.lrcDataSource[indexPath.row] stringByReplacingOccurrencesOfString:@"-" withString:@"~"];
        cell.lyric.text = lyr;
    } else {
        cell.lyric.text = @"";
    }
    if (self.currentRow == indexPath.row) {
        cell.lyric.font = TECU_FONT(18*HEIGHT_NIT);
        cell.lyric.textColor = [UIColor colorWithHexString:@"#451d11"];
    } else {
        cell.lyric.font = NORML_FONT(18*HEIGHT_NIT);
        cell.lyric.textColor = [UIColor colorWithHexString:@"#879999"];
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 0.0001;
}

/*
 #define ROLLINDEX 2         //鬼畜重复
 #define FILTERINDEX 3       //滤镜
 #define EQINDEX 4           //均衡器
 #define FLANGERINDEX 5      //弗兰格效果
 #define DELAYINDEX 6        //回声
 #define REVERBINDEX 7       //混响
 #define COMPRESSOR  8       //压缩
 #define GATE        9       //门限
 #define LIMITER     10      //限幅器
 #define WHOSSH      11      //嘶嘶声效
 */

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
}

//- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    return nil;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

- (void)releaseBtnAction:(UIButton *)btn {
    [self pause];
    
    self.songLoading = [[SongLoadingView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:self.songLoading];
    
    [self.songLoading initAction];
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.song_tag = @"演唱";
    
    [MobClick event:@"play_sing_complete"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    [self beginMixVoice];
}

- (void)beginMixVoice {

    [manager mixAndAddFilterToFile:@[self.recoderPath, self.banzouPath]];
    
//    self.finalMixPath = self.recoderPath;
//    [self uploadMixData];
}

- (void) toMp3:(NSString *)path {

    NSString *cafFilePath = path;
    
    NSString *mp3FileName = @"VolumeChanged";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
//    self.finalMixPath = mp3FilePath;
    NSLog(@"mp3FilePath  -----  %@", mp3FilePath);
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
        
        const int PCM_SIZE = 640;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        lame_t lame = lame_init();
        lame_set_num_channels(lame, 1);
        lame_set_in_samplerate(lame, 44100.0);//44100.0
        //        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        lame_set_brate(lame, 32);
        lame_set_mode(lame, MONO);
        lame_set_quality(lame, 2);
        lame_set_bWriteVbrTag(lame, 0);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        lame_mp3_tags_fid(lame, mp3);
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
        
        [manager addFilterToFile:mp3FilePath];
    }
}

/*
 067745869ccc43f8e18cbd200361e0f6_28
 http://1.117.109.129/core/music/mp3/067745869ccc43f8e18cbd200361e0f6_28.mp3
 http://www.woyaoxiege.com/home/index/play/067745869ccc43f8e18cbd200361e0f6_28
 */
- (void)uploadMixData {
    NSData *recoderData = [NSData dataWithContentsOfFile:self.finalMixPath];
    AFHTTPSessionManager *manager1 = [AFHTTPSessionManager manager];
    manager1.responseSerializer = [AFHTTPResponseSerializer serializer];
    [manager1 POST:UPLOAD_RECODER parameters:@{@"key":@"value"} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {//70F2EC5A06BD8A9B4D57152CADD3C2A0
        [formData appendPartWithFileData:recoderData name:@"file" fileName:[NSString stringWithFormat:@"%@.mp3", self.code] mimeType:@"audio/mp3"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"--%@", str);
        
        [self.songLoading stopAnimate];
        [self.songLoading removeFromSuperview];
        self.songLoading = nil;
        
        [self pushToShareView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self.songLoading stopAnimate];
        [self.songLoading removeFromSuperview];
        self.songLoading = nil;
        [KVNProgress showErrorWithStatus:@"数据错误:3"];
        NSLog(@"wrong---%@", error.description);
    }];
}

- (void)pushToShareView {
    
    NSLog(@"%@==%@", self.mp3Url, self.shareUrl);
    
    ReleaseViewController *rvc = [ReleaseViewController new];
    
    rvc.webUrl = self.shareUrl;
    rvc.mp3Url = self.mp3Url;
    rvc.songName = self.songName;
    
    [self.navigationController pushViewController:rvc animated:YES];
    
//    [self.player playWithPathUrl:self.finalMixPath];
//    [self.player setVolume:1.0f];
//    [self getRow];
}

@end
