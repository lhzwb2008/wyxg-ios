//
//  PlayViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/3/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PlayViewController.h"
#import "RecoderController.h"
#import "RecoderHeader.h"
#import "ReleaseViewController.h"
#import "SongLoadingView.h"
#import "TyDoneBtn.h"
#import "LoginViewController.h"
#import "AXGMessage.h"
#import "lame.h"
#import "NavRightButton.h"
#import "AXGGuidManager.h"

#define TYBTN_TAG   100
#define BANZOU_TAG  101
#define RECODER_TAG 102
#define XUANLV_TAG  103


@interface PlayViewController ()<UITableViewDataSource, UITableViewDelegate, UIGestureRecognizerDelegate> {
    CGFloat lastScale;
}

@property (nonatomic, strong) RecoderController *rvc;



@end

@implementation PlayViewController

static PlayViewController *sharePlayVC = nil;

+ (instancetype)sharePlayVC {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharePlayVC = [[PlayViewController alloc] init];
        sharePlayVC.lyricDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    });
    return sharePlayVC;
}

- (void)delaySetProgress {
    [self sliderValueChanged:[TYCommonClass sharedTYCommonClass].sentenceTime * self.selectedSentenceIndex * 1.0 / self.totalTime];
//    [self sliderValueChanged:[TYCommonClass sharedTYCommonClass].sentenceTime * 0 * 1.0 / self.totalTime];
    [[ToastView sharedToastView] forceHide];
}

- (UIView *)maskHideView {
    if (_maskHideView == nil) {
        _maskHideView = [UIView new];
    }
    return _maskHideView;
}

- (void)createTyView {
    NSLog(@"加载调音界面");
    self.midiIsReady = YES;

    if (self.isChanged) {
        [self performSelector:@selector(delaySetProgress) withObject:nil afterDelay:1];
        if (self.tyView) {
            return;
        }
    }
    [self.player playWithUrl:self.mp3Url];
    
    [self getRow];
    
    [self play];
    
    if (self.tyView) {
        [[ToastView sharedToastView] forceHide];
        return;
    }
    
    CGFloat naviHeight = 0;
    if (kDevice_Is_iPhone4 || kDevice_Is_iPad || kDevice_Is_iPad) {
        naviHeight = TY_NAVI_HEIGHT_4s;
    } else {
        naviHeight = TY_NAVI_HEIGHT;
    }
    if (kDevice_Is_iPhoneX) {
        naviHeight = 88;
    }
    
    _tyView = [[TYView alloc] initWithFrame:CGRectMake(0, naviHeight, width(self.view), height(self.view)-naviHeight)];
//    _tyView.backgroundColor = [UIColor clearColor];
    WEAK_SELF;
    _tyView.tyNextBlock = ^{
        STRONG_SELF;
        if (self.currentTyIndex < self.lyricDataSource.count - 1) {
            self.currentTyIndex += 1;
        } else if (self.currentTyIndex == self.lyricDataSource.count - 1) {
            self.currentTyIndex = 0;
        }
        [self changeShowTyViewWithIndex:self.currentTyIndex];
    };
    _tyView.tyLastBlock = ^{
        STRONG_SELF;
        if (self.currentTyIndex > 0) {
            self.currentTyIndex -= 1;
        } else if (self.currentTyIndex == 0) {
            self.currentTyIndex = self.lyricDataSource.count - 1;
        }
        [self changeShowTyViewWithIndex:self.currentTyIndex];
    };
    NSLog(@"sentenceTime = %f s", [TYCommonClass sharedTYCommonClass].sentenceTime);
    [self.secondBgView addSubview:_tyView];
    
    
    if (![[NSUserDefaults standardUserDefaults] boolForKey:@"tyGuidIsShowed"]) {
    
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"tyGuidIsShowed"];
        
        [AXGGuidManager showTYGuidUnderView:[PlayViewController sharePlayVC].secondBgView];
    
        [AXGGuidManager beginAnimageForNote];
    
        self.tyGuidView = [AXGGuidManager sharedAXGGuidManager].tyGuidView;

    } else {
        self.tyGuidView = nil;
    }
    
    [[ToastView sharedToastView] forceHide];
}

- (void)scaGesture:(id)sender {
    
    [self.view bringSubviewToFront:[(UIPinchGestureRecognizer*)sender view]];
    
    //当手指离开屏幕时,将lastscale设置为1.0
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        lastScale = 1.0;
        
        return;
        
    }
    
    CGFloat scale = 1.0 - (lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
//    if (scale < 1) {
//        scale = 1.0f;
//    }
    
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer*)sender view].transform;
    
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [[(UIPinchGestureRecognizer*)sender view]setTransform:newTransform];
    
    lastScale = [(UIPinchGestureRecognizer*)sender scale];
    
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer {
    
    return ![gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]];
}

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView {
    return self.tyView;
}

/**
 *  完成调音按钮方法
 */
- (void)compleBtnClick:(UIButton *)btn {
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    [self.customProgressView.playBtn setSelected:NO];
    self.isChanged = YES;
    [self flip:nil];
    [[PlayAnimatView sharePlayAnimatView] stopAnimating];
    
    [self.tyView clickDoneBtn];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"musicMode"] isEqualToString:@"moreMode"]) {
        [self nextSongDelegate];
    }
    [self hideTyPopView];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    if (app.noteIsChanged) {
        [MobClick event:@"play_gaiqu"];
    }
}
/**
 *  返回按钮方法
 */
- (void)backBtnClick:(UIButton *)btn {
    [[NSNotificationCenter defaultCenter] postNotificationName:STOP_PLAY_MID object:nil];
    self.isChanged = NO;
    self.isPlaying = NO;
    [[PlayAnimatView sharePlayAnimatView] stopAnimating];
    [self flip:nil];
    [self pause];
}

- (void)hideTyPopView {
    self.tyPopView.hidden = YES;
    self.tyPopView.alpha = 0.0f;
    self.maskHideView.hidden = YES;
}


- (void)removeNoti {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)registNoti {
    // 监听播放结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playToEnd:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playViewNoneEar) name:@"noneEarPod" object:nil];
    // 登录后推到分享页
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToShareView) name:@"pushToShare" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeBackGround) name:@"applicationBackGround" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:@"applicationActive" object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
}

- (void)playViewNoneEar {
    NSLog(@"耳机拔出 暂停播放");
    [self.customProgressView.playBtn setSelected:YES];
    self.isPlaying = NO;
}


//处理中断事件
-(void)handleInterreption:(NSNotification *)sender
{
//    AppDelegate *app = [[UIApplication sharedApplication] delegate];
//    [XMidiPlayer xInit];
//    app.deviceIsReady = YES;
    NSLog(@"%@", sender);
    NSLog(@"接到电话");
}


- (void)becomeBackGround {
//    if (self.isPlaying) {
        [self.player pause];
        self.isPlaying = NO;
//    }
}

- (void)becomeActive {
//    if (!self.isPlaying) {
//        [self.player play];
//        self.isPlaying = YES;
//    }
    [self.player pause];
    self.isPlaying = NO;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"status"]) {
        AXGMusicPlayer *player = object;
        NSLog(@"%ld", (long)player.status);
        NSLog(@"%ld", AVPlayerStatusReadyToPlay);
        if (player.status == AVPlayerStatusReadyToPlay && self.isChanged) {

            NSLog(@"changed = %f", [TYCommonClass sharedTYCommonClass].sentenceTime * self.selectedSentenceIndex * 1.0 / self.totalTime);
            [self sliderValueChanged:[TYCommonClass sharedTYCommonClass].sentenceTime * self.selectedSentenceIndex * 1.0 / self.totalTime];
            self.isChanged = NO;
            //        [self getRow];

        }
    }
}

- (void)sendToFriends:(id)sender {
    
//    self.nextButton.enabled = NO;
    self.navRightButton.enabled = NO;
    WEAK_SELF;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        STRONG_SELF;
//        self.nextButton.enabled = YES;
        self.navRightButton.enabled = YES;
    });
    
    [self shareDelegate];
}

- (void)gqBtnAction {
    
    [self.player pause];
    
    self.isPlaying = NO;
    
    [MobClick event:@"play_gaiqu"];
}

- (void)fxBtnAction {
    [self shareDelegate];
}

// 播放结束方法
- (void)playToEnd:(NSNotification *)sender {
    self.isPlaying = NO;
    self.isEnd = YES;
    [self.customProgressView.playBtn setSelected:YES];
    [self.customProgressView.currentTime setText:@"0:00"];
    [self.customProgressView setProgress:0.0f withAnimated:NO];
    self.currentRow = 0;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self.tableView reloadData];
//    if (!self.mixVoiceBtn.hidden) {
//        [RecoderClass turnOffRecorder];
//        if (![self.mixVoiceBtn.titleLabel.text isEqualToString:@"播放"]) {
//            [self.mixVoiceBtn setTitle:@"播放" forState:UIControlStateNormal];
//        } else {
//            [self.mixVoiceBtn setTitle:@"开始" forState:UIControlStateNormal];
//        }
//    }
}
- (NSMutableArray *)lrcTimeArray {
    if (_lrcTimeArray == nil) {
        _lrcTimeArray = [NSMutableArray array];
    }
    return _lrcTimeArray;
}
// 改变当前行字体颜色
- (void)getRow {
    NSLog(@"开始刷新歌词");
    self.isEnd = NO;
    self.isPlaying = YES;
    [self.customProgressView.playBtn setSelected:NO];
    self.currentRow = 0;
    self.titleLabel.text = self.titleStr;
//    self.customProgressView.songName.text = self.titleStr;
    if (self.observer) {
        [self.player removeTimeObserver:self.observer];
        self.currentRow = 0;
    }
    [self.customProgressView setProgress:0 withAnimated:NO];
    NSInteger arrCount = self.lyricDataSource.count;
    
    WEAK_SELF;
    self.observer = [self.player addPeriodicTimeObserverForInterval:CMTimeMake(1, 1) queue:NULL usingBlock:^(CMTime time) {
        STRONG_SELF;
        
        CGFloat totalTime = [TYCommonClass sharedTYCommonClass].sentenceTime * arrCount;
        if (self.totalTime != totalTime && totalTime > 0) {
            self.totalTime = totalTime;
            self.playerIsReady = YES;
            if (self.midiIsReady) {
                [[ToastView sharedToastView] forceHide];
            }
        }
        // 当前时间
        CGFloat currentTime = time.value * 1.0 / time.timescale;
        NSInteger minTime1 = currentTime / 60;
        NSInteger secondTime1 = fmodf(currentTime, 60);
        NSString *timeStr1 = [NSString stringWithFormat:@"%02ld:%02ld", (long)minTime1,(long)secondTime1];
        
        self.customProgressView.currentTime.text = timeStr1;
        // 总时间
        NSInteger minTime2 = totalTime / 60;
        NSInteger secondTime2 = fmodf(totalTime, 60);
        NSString *timeStr2 = [NSString stringWithFormat:@"%02ld:%02ld", (long)minTime2,(long)secondTime2];
        
        self.customProgressView.totalTime.text = timeStr2;
        if (isnan((CGFloat)currentTime * 1.0 / totalTime)) {
            [self.customProgressView setProgress:0 withAnimated:YES];
        } else {
            [self.customProgressView setProgress:(CGFloat)currentTime * 1.0 / totalTime withAnimated:YES];
        }
        if (![XWAFNetworkTool checkNetwork] && self.needShowError) {
            [KVNProgress showErrorWithStatus:@"网络不给力"];
            self.needShowError = NO;
        }
        // 刷新歌词
        NSInteger currentRow;
        currentRow = ((currentTime+1.0) * arrCount) / totalTime;
        if (currentRow < arrCount && totalTime != 0) {
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.currentRow = currentRow;
                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                [self.tableView reloadData];
            });
        }
    }];
}


// 网络请求
- (void)getData {
    
    if (![XWAFNetworkTool checkNetwork]) {
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    NSString *parameter = @"";
    
    if (self.btnType == TY_BTN_TYPE) {
        parameter = [NSString stringWithFormat:PARAMETER, (long)self.source, (long)self.genere, (long)self.emotion
                     , self.songSpeed
                     ];
    } else if (self.btnType == XL_BTN_TYPE) {
        parameter = [NSString stringWithFormat:@"source=%ld&genre=%ld&emotion=%ld&rate=%.1f&hasweak=%d", (long)self.source, (long)self.genere, (long)self.emotion
                     , self.songSpeed, -1
                     ];
    }
    
    
    
    NSString *url = [NSString stringWithFormat:@"%@%@", self.requestURL, parameter];
    
    NSLog(@"请求url为%@", url);
    // 提交midi
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"musicMode"] isEqualToString:@"moreMode"]) {
        
        if (self.midiData == nil) {
            NSLog(@"没有可用的midi数据");
        }
        [self.player pause];
        self.isLoading = YES;
        NSDictionary *parameters = @{@"title":self.titleStr,
                                     @"content":self.lyricContent,
                                     @"source":[NSString stringWithFormat:@"%ld", (long)self.source],
                                     @"genre":[NSString stringWithFormat:@"%ld", (long)self.genere],
                                     @"emotion":[NSString stringWithFormat:@"%ld", (long)self.emotion],
                                     @"name":self.postMidiName,
                                     @"rate":[NSString stringWithFormat:@"%.1f", self.songSpeed]};
        /**
         @"title"
         @"content"
         @"source"
         @"genre"
         @"emotion"
         @"name"
         @"rate"
         */
        NSString *urlStr = TY_CALL_MID;
        _manager  = [AFHTTPSessionManager manager];
        _manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        _manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        _manager.requestSerializer.timeoutInterval = 60;
//        [[ToastView sharedToastView] showLoadingViewWithMessage:nil inView:[[[UIApplication sharedApplication] delegate] window]];
        
        // 加载窗口
        SongLoadingView *songLoading = [[SongLoadingView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:songLoading];
        [songLoading initAction];
        
        self.isPlaying = NO;
        
        self.needShowError = YES;
        
        [_manager POST:urlStr parameters:parameters constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {//real_%@.mp3
            [formData appendPartWithFileData:self.midiData name:@"file" fileName:[NSString stringWithFormat:@"%@.mid", self.midiFileName] mimeType:@"audio/midi"];
        } progress:^(NSProgress * _Nonnull uploadProgress) {
            
        } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
            
            [songLoading stopAnimate];
            
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
            self.mp3Url = dic[@"url"];
            self.webUrl = dic[@"fenxiang"];
            
//            NSArray *tmp = [self.mp3Url componentsSeparatedByString:@":"];
//            NSString *tmpUrl = [NSString stringWithFormat:@"https%@", [tmp lastObject]];
//            self.mp3Url = tmpUrl;
//            
//            NSArray *tmp1 = [self.webUrl componentsSeparatedByString:@":"];
//            NSString *tmpUrl1 = [NSString stringWithFormat:@"https%@", [tmp1 lastObject]];
//            self.webUrl = tmpUrl1;

            
            if (self.mp3Url.length < 1) {
                [KVNProgress showErrorWithStatus:@"服务器开小差了"];
            } else {
                [self.customProgressView setProgress:0 withAnimated:NO];
                [self.player playWithUrl:self.mp3Url];
            }
            [self getRow];
            [self.player pause];
            
            self.isLoading = NO;
            
            [self.player play];
            
//            [[ToastView sharedToastView] forceHide];
            //            [self requestMidiData];
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"提交midi错误--%@", error.description);
            [songLoading stopAnimate];
            self.isLoading = NO;
            if (error.code == -1001) {
//                [[ToastView sharedToastView] forceHide];
                [KVNProgress showErrorWithStatus:@"网络不给力"];
            } else {
//                [[ToastView sharedToastView] forceHide];
                [KVNProgress showErrorWithStatus:@"服务器开小差了"];
            }
        }];
        
    } else {
        [self refreshSongWithUrl:url];
    }
}

- (void)refreshSongWithUrl:(NSString *)url {
    [self pause];
    self.isLoading = YES;
//    [[ToastView sharedToastView] showLoadingViewWithMessage:nil inView:[[[UIApplication sharedApplication] delegate] window]];
    
    // 加载窗口
    SongLoadingView *songLoading = [[SongLoadingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:songLoading];
    [songLoading initAction];
    
    self.isPlaying = NO;
    self.needShowError = YES;
    
    WEAK_SELF;
    [XWAFNetworkTool getUrl:url body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        
        [songLoading stopAnimate];
        
        NSString *string = [resposeObject objectForKey:@"url"];
        NSString *shareUrl = [resposeObject objectForKey:@"fenxiang"];
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_TEST] isEqualToString:IS_TEST_YES]) {
            NSArray *stringArr = [string componentsSeparatedByString:@".com"];
            NSArray *shareArr = [shareUrl componentsSeparatedByString:@".com"];
            if (stringArr.count > 1) {
                string = [NSString stringWithFormat:@"%@%@", @"http://1.117.109.129", stringArr[1]];
                shareUrl = [NSString stringWithFormat:@"%@%@", @"http://1.117.109.129", shareArr[1]];
            }
        }
        if (string.length > 0) {
            NSArray *arr1 = [string componentsSeparatedByString:@"/"];
            NSString *str1 = [arr1 lastObject];
            NSArray *arr2 = [str1 componentsSeparatedByString:@"."];
            self.changeSingerAPIName = [arr2 firstObject];
            self.postMidiName = self.changeSingerAPIName;
            self.midiFileName = MD5Hash(self.titleStr);
        }
        self.mp3Url = string;
        self.webUrl = shareUrl;
        if (self.mp3Url.length < 1) {
            [KVNProgress showErrorWithStatus:@"服务器开小差了"];
        } else {
            
            self.isLoading = NO;
            
            [self requestMidiData];
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error);
        self.isLoading = NO;
        
        [songLoading stopAnimate];
        
        if (error.code == -1001) {
//            [[ToastView sharedToastView] forceHide];
            [KVNProgress showErrorWithStatus:@"网络不给力"];
        } else {
//            [[ToastView sharedToastView] forceHide];
            [KVNProgress showErrorWithStatus:@"服务器开小差了"];
        }
    }];
    
}


- (void)requestMidiData {
    if (![XWAFNetworkTool checkNetwork]) {
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    NSString *getMidiUrl = [NSString stringWithFormat:GET_MIDI_FILE, self.changeSingerAPIName];
    WEAK_SELF;
    [XWAFNetworkTool getUrl:getMidiUrl body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        [TYCommonClass sharedTYCommonClass].midiData = resposeObject;
        [self createTyView];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [KVNProgress showErrorWithStatus:@"MIDI生成失败"];
        [[ToastView sharedToastView] forceHide];
    }];
}

// 进度条拖动方法
- (void)sliderValueChanged:(CGFloat)value {
    
    //拖动改变视频播放进度
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        //    //计算出拖动的当前秒数
        CGFloat total = (CGFloat)self.player.currentItem.duration.value / self.player.currentItem.duration.timescale;
        
        self.isEnd = NO;
        // 已缓存区域
        NSTimeInterval timeInterval = [self availableDuration];
        CMTime duration = self.player.currentItem.duration;
        CGFloat totalDuration = CMTimeGetSeconds(duration);
        CGFloat maxAvailabelDuration = timeInterval / totalDuration;
        // 选取已缓存区域和手动调节的较小的位置
        CGFloat newValue = MIN(maxAvailabelDuration, value);
        NSInteger dragedSeconds = floorf(total * newValue);
        //转换成CMTime才能给player来控制播放进度
        CMTime dragedCMTime = CMTimeMake(dragedSeconds, 1);
        
        [self.player pause];
        WEAK_SELF;
        [self.player seekToTime:dragedCMTime completionHandler:^(BOOL finish){
            STRONG_SELF;
            [self.customProgressView setProgress:newValue withAnimated:YES];
            
            [self.customProgressView.playBtn setSelected:NO];
            [self.player play];
            self.isPlaying = YES;
        }];
    }
}
// 可用缓冲区
- (NSTimeInterval)availableDuration {
    
    NSArray *loadedTimeRanges = [self.player.currentItem loadedTimeRanges];
    // 获取缓冲区
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    // 计算缓冲总进度
    NSTimeInterval result = startSeconds + durationSeconds;
    return result;
}

#pragma mark - ButtonViewDelegate

// 播放按钮方法
- (void)playDelegate {
    
    if (![XWAFNetworkTool checkNetwork]) {
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    if (self.isEnd) {
        [self.player playWithUrl:self.mp3Url];
        [self.customProgressView.playBtn setSelected:NO];
        [self.customProgressView setProgress:0 withAnimated:NO];
        [self getRow];
        self.isPlaying = YES;
        self.isEnd = NO;
    } else {
        if (self.isPlaying) {
            [self pause];
        } else {
            [self play];
        }
//        self.isPlaying = !self.isPlaying;
    }
}

- (void)pause {
    [self.player pause];
    [self.customProgressView.playBtn setSelected:YES];
    self.isPlaying = NO;
}
- (void)play {
    [self.player play];
    [self.customProgressView.playBtn setSelected:NO];
    self.isPlaying = YES;
}

// 换一首按钮方法
- (void)nextSongDelegate {
    
    [self getData];
}

// 分享按钮方法
- (void)shareDelegate {
    [self.player pause];
    self.isPlaying = NO;
    
    [self pushToShareView];
    // 试听界面_发布按钮埋点
    [MobClick event:@"play_release"];
}

- (void)pushToShareView {
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"loading"];
    ReleaseViewController *rvc = [[ReleaseViewController alloc] init];
    rvc.webUrl = self.webUrl;
    rvc.mp3Url = self.mp3Url;
    rvc.songName = self.titleStr;
    
    [self.navigationController pushViewController:rvc animated:YES];
    
    
//    } else {
//        AXG_LOGIN(LOGIN_LOCATION_SHARE);
//    }
}

/**
 *  创建歌词界面
 */
- (void)createLyric {

    CGFloat navH = kDevice_Is_iPhoneX ? 88 : 64;
    
    self.navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, navH)];
    [self.view addSubview:self.navView];
    self.navView.backgroundColor = HexStringColor(@"#ffdc74");
    
    
    self.navLeftButton = [NavLeftButton buttonWithType:UIButtonTypeCustom];
    self.navLeftButton.frame = CGRectMake(0, (kDevice_Is_iPhoneX ? 24 : 0), 64, 64);
    [self.navView addSubview:self.navLeftButton];
    self.navLeftButton.backgroundColor = [UIColor clearColor];
    
    
    self.navRightButton = [UIButton new];
    [self.navRightButton setTitle:@"发布" forState:UIControlStateNormal];
    [self.navRightButton setTitleColor:UIColor.whiteColor];
    self.navRightButton.titleLabel.font = ZHONGDENG_FONT(15);
    self.navRightButton.frame = CGRectMake(self.view.width - 44 - 16, (kDevice_Is_iPhoneX ? 44 : 20), 44, 44);
    [self.navRightButton addTarget:self action:@selector(sendRightBtnClick:)];
    self.navRightButton.backgroundColor = [UIColor clearColor];
    [self.navView addSubview:self.navRightButton];
    
    
    self.navTitle = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, self.view.width - 110, 44)];
    [self.navView addSubview:self.navTitle];
    self.navTitle.center = CGPointMake(self.navTitle.centerX, self.navRightButton.centerY);
    self.navTitle.textColor = [UIColor colorWithHexString:@"#451d11"];
    self.navTitle.textAlignment = NSTextAlignmentCenter;
    [self.navTitle setFont:TECU_FONT(18)];
    
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    
    [self.navLeftButton addTarget:self
             action:@selector(backButtonAction:)
   forControlEvents:UIControlEventTouchUpInside];


    self.navTitleLabel = self.navTitle;
    
    UIView *lyricBg = [self createLyricBgViewUnderView:self.navView];
    
    // 创建tableview
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0,
                                                                   0,
//                                                                   self.titleLabel.bottom + titleBottomGap,
                                                                   lyricBg.width,
                                                                   lyricBg.height)
                                                  style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle = NO;
    self.tableView.showsHorizontalScrollIndicator = NO;
    self.tableView.showsVerticalScrollIndicator = NO;
    
    
    UIView *tableHeadView = [UIView new];
    tableHeadView.backgroundColor = [UIColor clearColor];
    CGFloat headHeight = 0.00001;
    if (self.lyricDataSource.count < 10) {
        headHeight = (10 - self.lyricDataSource.count) / 2 * self.cellHeight;
    }
    tableHeadView.frame = CGRectMake(0, 0, self.tableView.width, headHeight);
    self.tableView.tableHeaderView = tableHeadView;
    
    [self.tableView registerClass:[LyricTableViewCell class]
           forCellReuseIdentifier:@"PlayViewLyricTableViewCellIdentifier"];
    [lyricBg addSubview:self.tableView];
    
    UIImageView *maskImage = [UIImageView new];
    maskImage.frame = CGRectMake(0, self.tableView.bottom-2*self.cellHeight, self.tableView.width, 2*self.cellHeight);
    maskImage.image = [UIImage imageNamed:@"歌词遮罩"];
    [lyricBg addSubview:maskImage];
    [self createProgressViewUnderView:lyricBg];
}
- (void)createNaviTitleUnderView:(UIView *)customNaviView {
    
    self.navTitleLabel = [UILabel new];
    self.navTitleLabel.frame = CGRectMake(0, 25 * HEIGHT_NIT, self.view.width, 50 * HEIGHT_NIT);
    self.navTitleLabel.text = @"试听";
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.navTitleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.navTitleLabel.font = [UIFont systemFontOfSize:18 * WIDTH_NIT];
    [customNaviView addSubview:self.navTitleLabel];
}

- (void)sendRightBtnClick:(UIButton *)btn {
    [self sendToFriends:btn];
}

- (UIView *)createLyricBgViewUnderView:(UIView *)customNaviView {
    UIImageView *lyricBg = [UIImageView new];
    lyricBg.backgroundColor = [UIColor clearColor];
    lyricBg.frame = CGRectMake(0,
                               customNaviView.bottom + 20 * HEIGHT_NIT,
                               width(self.view),
                               10 * self.cellHeight);
    lyricBg.center = CGPointMake(self.view.centerX, lyricBg.centerY);
//    lyricBg.image = [UIImage imageNamed:@"stbg@2x"];
    [self.firstBgView addSubview:lyricBg];
    return lyricBg;
}

- (void)createProgressViewUnderView:(UIView *)lyricBg {
    _customProgressView = [[PlayViewCustomProgress alloc] initWithFrame:CGRectMake(0,
                                                                                   lyricBg.bottom + 10*HEIGHT_NIT,
                                                                                   self.view.width,
                                                                                   14*WIDTH_NIT)];
    WEAK_SELF;
    _customProgressView.playBtnBlock = ^(BOOL isPlaying){
        STRONG_SELF;
        [self playDelegate];
    };
    
    _customProgressView.sliderDidChangedBlock = ^(CGFloat value) {
        STRONG_SELF;
        [self.player pause];
        [self sliderValueChanged:value];
    };
    
    [self.firstBgView addSubview:_customProgressView];
    _customProgressView.backgroundColor = [UIColor clearColor];
}
/**
 *  返回按钮方法
 *
 *  @param sender 返回按钮
 */
- (void)backButtonAction:(UIButton *)sender {
    
    
    [AXGMessage showTextSelectMessageOnView:self.view title:@"是否放弃当前歌曲" leftButton:@"继续" rightButton:@"放弃"];
    WEAK_SELF;
    [AXGMessage shareMessageView].leftButtonBlock = ^ () {
        STRONG_SELF;
    };
    [AXGMessage shareMessageView].rightButtonBlock = ^ () {
        STRONG_SELF;
        self.currentRow = 0;
        
        [self.player pause];
        [self.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    };
}

- (void)popAlert {
    UIAlertController *aleret = [UIAlertController alertControllerWithTitle:nil message:@"是否放弃当前旋律" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"放弃" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.currentRow = 0;
        
        [self.player pause];
        [self.tableView reloadData];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    UIAlertAction *confirmAction = [UIAlertAction actionWithTitle:@"继续" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [aleret addAction:cancelAction];
    [aleret addAction:confirmAction];
    
    [self presentViewController:aleret animated:YES completion:nil];
}

- (void)removeOldTyView {
    self.midiIsReady = NO;
    if (self.tyView) {
        [self.tyView removeFromSuperview];
        self.tyView = nil;
    }
}

- (void)changeBtnType:(Btn_Type)btnType {
    self.btnType = btnType;
    if (btnType == TY_BTN_TYPE) {
        self.gaiquBtn.tag = TYBTN_TAG;
        [self.gaiquBtn setTitle:@"改曲" forState:UIControlStateNormal];
        [self.gaiquBtn setImage:[UIImage imageNamed:@"改曲"] forState:UIControlStateNormal];
    } else if (btnType == XL_BTN_TYPE) {
        self.gaiquBtn.tag = XUANLV_TAG;
        [self.gaiquBtn setTitle:@"换旋律" forState:UIControlStateNormal];
        [self.gaiquBtn setImage:[UIImage imageNamed:@"换旋律icon"] forState:UIControlStateNormal];
    }
}

#pragma mark - UITableViewDataSource

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    // 歌名
//    return [self getHeadView];
//}

- (UIView *)getHeadView {
    UIView *headView = [UIView new];
    headView.frame = CGRectMake(0, 0, width(self.tableView), (23)*HEIGHT_NIT);
    headView.backgroundColor = [UIColor clearColor];
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 23*HEIGHT_NIT, width(self.tableView), 18 * WIDTH_NIT)];
    self.titleLabel.backgroundColor = [UIColor clearColor];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    if ([[[UIDevice currentDevice] systemVersion] compare:@"10.0"options:NSNumericSearch] == NSOrderedSame) {
        self.titleLabel.font = [UIFont systemFontOfSize:18 * HEIGHT_NIT];
    } else {
        self.titleLabel.font = [UIFont fontWithName:@"经典宋体简" size:18 * WIDTH_NIT];
    }
    
    self.titleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.titleLabel.text = self.titleStr;
//    self.customProgressView.songName.text = self.titleStr;
    [headView addSubview:self.titleLabel];
    
    self.tableView.tableHeaderView = headView;
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 0.0001;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.lyricDataSource.count + 4;//增加4个 保证所有的cell都可以居中显示
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LyricTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"PlayViewLyricTableViewCellIdentifier"];
    cell.backgroundColor = [UIColor clearColor];
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor colorWithHexString:@"#f5f5f5"];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.index = indexPath.row;
    
    
    if (self.lyricDataSource.count > indexPath.row) {
        NSString *lyr = [self.lyricDataSource[indexPath.row] stringByReplacingOccurrencesOfString:@"-" withString:@"~"];
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

- (void)showTyViewWithIndex:(NSInteger)index {
    
    if (!self.midiIsReady) {
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:TY_GUID_IsShow];
    [[UIApplication sharedApplication] setStatusBarHidden:YES];
    [self.player pause];
    self.isPlaying = NO;
    [self.customProgressView.playBtn setSelected:YES];
    self.selectedSentenceIndex = index;
    [[NSUserDefaults standardUserDefaults] setObject:@"fastMode" forKey:@"musicMode"];
    
    [self changeShowTyViewWithIndex:index];
    
//    [self.tyView showTyViewWithIndex:index];
    [self flip:nil];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    [tableView deselectRowAtIndexPath:indexPath animated:YES];// 取消选中
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}
#pragma mark - 翻转视图方法
/**
 *  翻转视图
 */
-(void)flip:(id)sender{
    
    static BOOL mark = YES;
    CGContextRef context=UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
    [UIView setAnimationDuration:0.5];
    
    if (mark) {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:YES];
    } else {
        [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:YES];
    }
    NSInteger fist= [[self.view subviews] indexOfObject:[self.view viewWithTag:100]];
    NSInteger seconde= [[self.view subviews] indexOfObject:[self.view viewWithTag:101]];
    [self.view exchangeSubviewAtIndex:fist withSubviewAtIndex:seconde];
    [UIView setAnimationDelegate:self];
    [UIView commitAnimations];
    if (mark) {
        [self.view bringSubviewToFront:self.secondBgView];
    } else {
        [self.view sendSubviewToBack:self.secondBgView];
    }
    mark = !mark;
}

- (void)titleClick:(UIButton *)btn {
    [self.secondBgView bringSubviewToFront:self.maskHideView];
    [self.secondBgView bringSubviewToFront:self.tyPopView];
    if (self.tyPopView.hidden == YES) {
        self.maskHideView.hidden = NO;
        self.tyPopView.hidden = NO;
        [self.tyPopView changeSelectedIndex:self.currentTyIndex];
        WEAK_SELF;
        [UIView animateWithDuration:0.3 animations:^{
            STRONG_SELF;
            self.tyPopView.alpha = 1.0f;
        }];
    } else {
        
        WEAK_SELF;
        [UIView animateWithDuration:0.3 animations:^{
            STRONG_SELF;
            self.tyPopView.alpha = 0.0f;
        }completion:^(BOOL finished) {
            STRONG_SELF;
            self.tyPopView.hidden = YES;
            self.maskHideView.hidden = YES;
        }];
    }
}

- (void)changeShowTyViewWithIndex:(NSInteger)index {
    self.currentTyIndex = index;
    self.tySentenceLabel.text = self.tyPopView.dataArray[index];
    if (index > 9) {
        WEAK_SELF;
        [UIView animateWithDuration:0.3 animations:^{
            STRONG_SELF;
            self.tyTitleBtn.frame = self.titleBtnChangeFrame;
            self.tySentenceLabel.frame = self.titleChangeFrame;
        }];
    } else {
        WEAK_SELF;
        [UIView animateWithDuration:0.3 animations:^{
            STRONG_SELF;
            self.tyTitleBtn.frame = self.titleBtnNormalFrame;
            self.tySentenceLabel.frame = self.titleNormalFrame;
        }];
    }
    [self.tyView changeShowTyViewWithIndex:index];
    [self hideTyPopView];
}
#pragma mark - 初始化界面
- (void)initNavView {
    
}
#pragma mark - 生命周期

- (void)viewDidLoad {
    [super viewDidLoad];
    [self registNoti];
    
    CGSize lyricSize = [@"歌词" getWidth:@"歌词" andFont:ZHONGDENG_FONT(18*HEIGHT_NIT)];
    
    if (kDevice_Is_iPad || kDevice_Is_iPad3 || kDevice_Is_iPhone4) {
        self.cellHeight = lyricSize.height + 8;
    } else {
        self.cellHeight = lyricSize.height + 15*HEIGHT_NIT;
    }
    
    self.rvc = [[RecoderController alloc] init];
    
    self.currentTyIndex = 0;
    
    self.view.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.needShowError = YES;
    self.firstBgView = [[UIView alloc] initWithFrame:self.view.bounds];
    self.firstBgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.firstBgView.tag = 101;
    
    [self.view addSubview:self.firstBgView];
    [self createLyric];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.view.bounds;
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#2f436f"].CGColor,
                             (__bridge id)[UIColor colorWithHexString:@"#36597c"].CGColor
                             ];
    gradientLayer.locations = @[@(0.0f), @(0.0f)];
    self.secondBgView = [[UIView alloc] initWithFrame:self.view.bounds];
//    self.secondBgView.backgroundColor = [UIColor colorWithHexString:@"#415d8a"];
    self.secondBgView.backgroundColor = [UIColor blackColor];
    self.secondBgView.tag = 100;
//    [self.secondBgView.layer addSublayer:gradientLayer];
    [self.view addSubview:self.secondBgView];
    
    
    UIView *customNavie = [UIView new];
    
    CGFloat naviHeight = 0;
    if (kDevice_Is_iPhone4 || kDevice_Is_iPad || kDevice_Is_iPad) {
        naviHeight = TY_NAVI_HEIGHT_4s;
    } else {
        naviHeight = TY_NAVI_HEIGHT;
    }
    if (kDevice_Is_iPhoneX) {
        naviHeight = 88;
    }
    customNavie.frame = CGRectMake(0, 0, width(self.view), naviHeight);
    customNavie.backgroundColor = TY_NAVI_BGCOLOR;
    [self.secondBgView addSubview:customNavie];

    
    UILabel *title = [UILabel new];
    title.text = @"第一句";
    
    if (kDevice_Is_iPhone4 || kDevice_Is_iPad || kDevice_Is_iPad) {
        title.font = [UIFont systemFontOfSize:15];
    } else {
        title.font = [UIFont systemFontOfSize:18];
    }

    title.frame = CGRectMake(0, 0, 18*3.2, 18);
    title.backgroundColor = [UIColor clearColor];
    title.textAlignment = NSTextAlignmentCenter;
    title.center = CGPointMake(customNavie.centerX, customNavie.centerY);
    
    self.titleNormalFrame = title.frame;
    self.titleChangeFrame = CGRectMake(title.frame.origin.x, title.frame.origin.y, title.frame.size.width+18, title.frame.size.height);
    title.textColor = TY_TITLE_COLOR;
    [customNavie addSubview:title];
    
    self.tySentenceLabel = title;
    
    UIImageView *showBtnImg = [UIImageView new];
//    showBtnImg.backgroundColor = [UIColor redColor];
    showBtnImg.frame = CGRectMake(title.right+5, 0, 12, 6);
    showBtnImg.center = CGPointMake(showBtnImg.centerX, customNavie.centerY);
    
    self.titleBtnNormalFrame = showBtnImg.frame;
    self.titleBtnChangeFrame = CGRectMake(self.titleChangeFrame.origin.x + self.titleChangeFrame.size.width+5, showBtnImg.frame.origin.y, showBtnImg.width, showBtnImg.height);
    showBtnImg.image = [UIImage imageNamed:@"ty下拉按钮"];
    [customNavie addSubview:showBtnImg];
    self.tyTitleBtn = showBtnImg;
    
    UIButton *titleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0, 0, title.width + showBtnImg.width, title.height);
    titleBtn.center = CGPointMake(title.centerX + 12, title.centerY);
    titleBtn.backgroundColor = [UIColor clearColor];
    [titleBtn addTarget:self action:@selector(titleClick:) forControlEvents:UIControlEventTouchUpInside];
    [customNavie addSubview:titleBtn];
    
    self.tyPopView = [[TYPopView alloc] initWithFrame:CGRectMake(title.centerX, customNavie.bottom-7, 110*WIDTH_NIT, 29*4.5 + 7)];
    self.tyPopView.backgroundColor = [UIColor clearColor];
//    self.tyPopView.alpha = 0.85f;
    self.tyPopView.cellHeight = 29;
    self.tyPopView.center = CGPointMake(customNavie.centerX, self.tyPopView.centerY);
    self.tyPopView.hidden = YES;
    self.tyPopView.alpha = 0.0f;
    WEAK_SELF;
    self.tyPopView.popSelect = ^(NSInteger index) {
        STRONG_SELF;
        [self changeShowTyViewWithIndex:index];
    };
    [self.tyPopView showLineWithNumber:5];
    [self.secondBgView addSubview:self.tyPopView];
    

//    NSLog(@"%@---%@", NSStringFromCGRect(self.tyPopView.frame), NSStringFromCGRect(title.frame));
    
    [TYCommonClass sharedTYCommonClass].listCellLeftGap = title.left - self.tyPopView.left;
    
    self.maskHideView.frame = self.view.bounds;
    self.maskHideView.backgroundColor = [UIColor clearColor];
    self.maskHideView.hidden = YES;
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideTyPopView)];
    [self.maskHideView addGestureRecognizer:tgr];
    [self.secondBgView addSubview:self.maskHideView];
    
    TyDoneBtn *backBtn = [TyDoneBtn buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(16, 0, 100, 44);
    backBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    backBtn.center = CGPointMake(backBtn.centerX, title.centerY);
    backBtn.titleLabel.font = ZHONGDENG_FONT(15);
    [backBtn setTitle:@"完成" forState:UIControlStateNormal];
//    [backBtn setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [backBtn setTitleColor:[UIColor colorWithHexString:@"#6ae8ff"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(compleBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [customNavie addSubview:backBtn];

    
    CGFloat rightShowWidth = 25;
    self.tyRightBtn = [[TYRightBtn alloc] initWithFrame:CGRectMake(customNavie.width - 18 - rightShowWidth, 0, rightShowWidth, rightShowWidth)];
    self.tyRightBtn.center = CGPointMake(self.tyRightBtn.centerX, title.centerY);
    self.tyRightBtn.autoresizesSubviews = YES;
    self.tyRightBtn.userInteractionEnabled = NO;
    self.tyRightBtn.shouldTap = YES;
    [customNavie addSubview:self.tyRightBtn];
    
    UIButton *rightBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    rightBtn.frame = CGRectMake(customNavie.width - 22 * 4, 0, 22 * 4, customNavie.height);
    rightBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    rightBtn.center = CGPointMake(rightBtn.centerX, title.centerY);
    rightBtn.backgroundColor = [UIColor clearColor];
//    [rightBtn setTitle:@"16" forState:UIControlStateNormal];
//    [rightBtn setTitle:@"8" forState:UIControlStateSelected];
//    [rightBtn setBackgroundImage:[[UIImage imageNamed:@"16"] transformWidth:22 height:22] forState:UIControlStateNormal];
    [rightBtn setTitleColor:TY_COMPLE_COLOR forState:UIControlStateNormal];
    [rightBtn setTitleColor:TY_COMPLE_COLOR forState:UIControlStateSelected];
    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [customNavie addSubview:rightBtn];
    

    self.secondBgView.alpha = 1.0f;
    [self.view sendSubviewToBack:self.secondBgView];
    
    
    self.player = [[AXGMusicPlayer alloc] init];
    
    [self createBottomBtn];
}

- (void)playViewBeginRecoder {
    
}

- (void)createBottomBtn {
    
    UIButton *beginRecoder = [UIButton buttonWithType:UIButtonTypeCustom];
    beginRecoder.backgroundColor = [UIColor clearColor];
    beginRecoder.frame = CGRectMake(0, self.view.height - 50*HEIGHT_NIT - 85 * HEIGHT_NIT, 85*HEIGHT_NIT, 85*HEIGHT_NIT);
    beginRecoder.tag = RECODER_TAG;
    beginRecoder.centerX = self.view.width / 2;
    [beginRecoder addTarget:self action:@selector(bottomBtnClick:)];
    [beginRecoder setImage:@"play麦克风"];
    [self.firstBgView addSubview:beginRecoder];
    
    
    STBottomBtn *tyButton = [STBottomBtn buttonWithType:UIButtonTypeCustom];
    //    tyButton.backgroundColor = [UIColor clearColor];
    tyButton.frame = CGRectMake(beginRecoder.right + 55*WIDTH_NIT, 0, 30 * WIDTH_NIT, 30* WIDTH_NIT);
    tyButton.centerY = beginRecoder.centerY;
    tyButton.tag = TYBTN_TAG;
//    [tyButton setTitle:@"改曲" forState:UIControlStateNormal];
    tyButton.titleLabel.font = NORML_FONT(12*WIDTH_NIT);
//    [tyButton setImage:[UIImage imageNamed:@"改曲"] forState:UIControlStateNormal];
    [tyButton setTitleColor:[UIColor colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    [tyButton setTitleColor:[UIColor colorWithHexString:@"#576D6D"] forState:UIControlStateHighlighted];
    [tyButton addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    CGFloat gap = (self.firstBgView.width - tyButton.width * 3) / 4;
    
    STBottomBtn *changeBackTrack = [STBottomBtn buttonWithType:UIButtonTypeCustom];
    //    changeBackTrack.backgroundColor = [UIColor redColor];
    changeBackTrack.frame = CGRectMake(beginRecoder.left-55*WIDTH_NIT-tyButton.width, tyButton.top, tyButton.width, tyButton.width);
    changeBackTrack.tag = BANZOU_TAG;
    [changeBackTrack setTitle:@"换伴奏" forState:UIControlStateNormal];
    changeBackTrack.titleLabel.font = tyButton.titleLabel.font;
    [changeBackTrack setTitleColor:[UIColor colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    [changeBackTrack setTitleColor:[UIColor colorWithHexString:@"#576D6D"] forState:UIControlStateHighlighted];
    [changeBackTrack setImage:[UIImage imageNamed:@"换伴奏"] forState:UIControlStateNormal];
    [changeBackTrack addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
#if 0
    STBottomBtn *recorderBtn = [STBottomBtn buttonWithType:UIButtonTypeCustom];
    //    recorderBtn.backgroundColor = [UIColor redColor];
    recorderBtn.frame = CGRectMake(tyButton.right + gap, tyButton.top, tyButton.width, tyButton.height);
    recorderBtn.tag = RECODER_TAG;
    [recorderBtn setTitle:@"演唱" forState:UIControlStateNormal];
    recorderBtn.titleLabel.font = tyButton.titleLabel.font;
    [recorderBtn setImage:[UIImage imageNamed:@"演唱"] forState:UIControlStateNormal];
    [recorderBtn setTitleColor:[UIColor colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    [recorderBtn setTitleColor:[UIColor colorWithHexString:@"#576D6D"] forState:UIControlStateHighlighted];
    [recorderBtn addTarget:self action:@selector(bottomBtnClick:) forControlEvents:UIControlEventTouchUpInside];
#endif
    
//    UIButton *mixVoiceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
//    //    mixVoiceBtn.backgroundColor = [UIColor redColor];
//    mixVoiceBtn.frame = CGRectMake(0, 0, tyButton.width * 1.5, tyButton.width * 1.5);
//    mixVoiceBtn.center = tyButton.center;
//    mixVoiceBtn.layer.cornerRadius = mixVoiceBtn.width / 2;
//    mixVoiceBtn.hidden = YES;
//    mixVoiceBtn.alpha = 0.0f;
//    [mixVoiceBtn setTitle:@"开始" forState:UIControlStateNormal];
//    [mixVoiceBtn addTarget:self action:@selector(mixVoiceBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
//    UIButton *restartRecorder = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [self.firstBgView addSubview:changeBackTrack];
    [self.firstBgView addSubview:tyButton];
//    [self.firstBgView addSubview:recorderBtn];
//    [self.firstBgView addSubview:mixVoiceBtn];
    
    
    
    self.banzouBtn = changeBackTrack;
    self.gaiquBtn = tyButton;
//    self.yanchangBtn = recorderBtn;
//    self.mixVoiceBtn = mixVoiceBtn;
    
//    self.nextButton = [UIButton new];
//    self.nextButton.frame = CGRectMake(50 * WIDTH_NIT,
//                                       self.view.height - 50*WIDTH_NIT - 35*HEIGHT_NIT,
//                                       self.view.width - 100 * WIDTH_NIT,
//                                       50 * WIDTH_NIT);
//    [self.firstBgView addSubview:self.nextButton];
//    self.nextButton.layer.cornerRadius = self.nextButton.height / 2;
//    self.nextButton.layer.masksToBounds = YES;
//    [self.nextButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色"] forState:UIControlStateNormal];
//    [self.nextButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateNormal];
//    [self.nextButton setTitleColor:HexStringColor(@"#879999") forState:UIControlStateHighlighted];
//    [self.nextButton setTitle:@"发 布" forState:UIControlStateNormal];
//    self.nextButton.titleLabel.font = JIACU_FONT(18 * WIDTH_NIT);
//    [self.nextButton addTarget:self action:@selector(sendToFriends:) forControlEvents:UIControlEventTouchUpInside];
    
    [self changeBtnType:self.btnType];
}

/**
 *  换伴奏
 */
- (void)changeBgMusic {
    [MobClick event:@"release"];
    
    [MobClick event:@"play_change_banzou"];
    
    [self pause];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeBgMusic" object:nil];
    /*
     http:// service.woyaoxiege.com/core/home/index/call_acc?content=%@&name=%@&genre=%ld&emotion=%ld&rate=%f
     */
//    [[ToastView sharedToastView] showLoadingViewWithMessage:nil inView:[[[UIApplication sharedApplication] delegate] window]];
//    _manager  = [AFHTTPSessionManager manager];
    
    // 加载窗口
    SongLoadingView *songLoading = [[SongLoadingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:songLoading];
    [songLoading initAction];

    NSString *url = [NSString stringWithFormat:CHANG_BG_MUSIC, self.lyricContent, self.postMidiName, self.genere, self.emotion, self.songSpeed];
    
    NSLog(@"%@", url);
    
    [XWAFNetworkTool getUrl:url body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        
        [songLoading stopAnimate];
        
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
        self.mp3Url = dic[@"url"];
        self.webUrl = dic[@"fenxiang"];
        
//        NSArray *tmp = [self.mp3Url componentsSeparatedByString:@":"];
//        NSString *tmpUrl = [NSString stringWithFormat:@"https%@", [tmp lastObject]];
//        self.mp3Url = tmpUrl;
//        
//        NSArray *tmp1 = [self.webUrl componentsSeparatedByString:@":"];
//        NSString *tmpUrl1 = [NSString stringWithFormat:@"https%@", [tmp1 lastObject]];
//        self.webUrl = tmpUrl1;
        
        if (self.mp3Url.length < 1) {
            [KVNProgress showErrorWithStatus:@"服务器开小差了"];
        } else {
            [self.customProgressView setProgress:0 withAnimated:NO];
            [self.player playWithUrl:self.mp3Url];
        }
        [self getRow];
        [self.player pause];
        
        self.isLoading = NO;
        
        [self.player play];
        
//        [[ToastView sharedToastView] forceHide];

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error.description);
        [songLoading stopAnimate];
//        [[ToastView sharedToastView] forceHide];
    }];
}

- (NSMutableArray *)lyricDataSource {
    if (_lyricDataSource == nil) {
        _lyricDataSource = [NSMutableArray array];
    }
    return _lyricDataSource;
}

- (void)turnToRecoder {
    [MobClick event:@"play_sing"];
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
    self.rvc.shareMp3Url = self.mp3Url;
    self.rvc.shareWebUrl = self.webUrl;
    self.rvc.shareSongName = self.titleStr;
    self.rvc.isFromUserSong = NO;
    [self.navigationController pushViewController:self.rvc animated:YES];

}

- (void)bottomBtnClick:(UIButton *)btn {
    switch (btn.tag) {
        case BANZOU_TAG: {
            [self changeBgMusic];
        }
            break;
        case TYBTN_TAG: {
            [self showTyViewWithIndex:0];
        }
            break;
        case RECODER_TAG: {
            [self turnToRecoder];
        }
            break;
        case XUANLV_TAG: {
            NSString *parameter = @"";
            
            parameter = [NSString stringWithFormat:@"source=%ld&genre=%ld&emotion=%ld&rate=%.1f&hasweak=%d", (long)self.source, (long)self.genere, (long)self.emotion
                         , self.songSpeed, -1
                         ];
            NSString *url = [NSString stringWithFormat:@"%@%@", self.requestURL, parameter];
            
            [self refreshSongWithUrl:url];
        }
            break;
        default:
            break;
    }
    
}

//- (void)showMixVoiceBtn {
//    if (self.mixVoiceBtn.hidden) {
//        self.mixVoiceBtn.hidden = NO;
//        WEAK_SELF;
//        [UIView animateWithDuration:duration animations:^{
//            STRONG_SELF;
//            self.banzouBtn.alpha = 0.0f;
//            self.gaiquBtn.alpha = 0.0f;
//            self.yanchangBtn.alpha = 0.0f;
//            self.nextButton.alpha = 0.0f;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:duration animations:^{
//                self.mixVoiceBtn.alpha = 1.0f;
//            }];
//        }];
//    } else {
//        WEAK_SELF;
//        [UIView animateWithDuration:duration animations:^{
//            STRONG_SELF;
//            self.mixVoiceBtn.alpha = 0.0f;
//        } completion:^(BOOL finished) {
//            self.mixVoiceBtn.hidden = YES;
//            [UIView animateWithDuration:duration animations:^{
//                self.banzouBtn.alpha = 1.0f;
//                self.gaiquBtn.alpha = 1.0f;
//                self.yanchangBtn.alpha = 1.0f;
//                self.nextButton.alpha = 1.0f;
//            }];
//        }];
//    }
////    [self requestWavData];
//}


- (void)rightBtnClick:(UIButton *)btn {
    if (!self.tyRightBtn.shouldTap) {
        return;
    }
    static BOOL mark = YES;
    if (mark) {
        [self.tyRightBtn doubleWidth];
    } else {
        [self.tyRightBtn halfWidth];
    }
    mark = !mark;
    [[NSNotificationCenter defaultCenter] postNotificationName:TY_TYPE_CHANGE object:nil];
}

- (void)appearMethod {
    self.isChanged = NO;
    self.playerIsReady = NO;
    self.totalTime = 0.0f;
    
    //    NSString *lyricContent = nil;
    [RecoderClass sharedRecoderClass];
    [TYCommonClass sharedTYCommonClass].lyricArray = self.lyricDataSource;
    
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    app.noteIsChanged = NO;
    
    if (self.lyricDataSource) {
        [self.tyPopView showLineWithNumber:self.lyricDataSource.count];
        
        //        NSLog(@"player dataSource is nil");
        //        for (NSInteger i = 0; i < self.lyricDataSource.count; i++) {
        //            if (i == 0) {
        //                lyricContent = self.lyricDataSource[0];
        //            } else {
        //                lyricContent = [NSString stringWithFormat:@"%@,%@", lyricContent, self.lyricDataSource[i]];
        //            }
        //        }
        //        self.lyricContent = lyricContent;
    }
    if (self.customProgressView) {
        [self.customProgressView.playBtn setSelected:YES];
    }
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO];
    
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait] forKey:@"orientation"];
    
    [UIViewController attemptRotationToDeviceOrientation];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:@"loading"] isEqualToString:@"no"]) {
        [[NSUserDefaults standardUserDefaults] setObject:@"yes" forKey:@"loading"];
        
        [self playDelegate];
    } else {
        [self nextSongDelegate];
    }
    [self.player setVolume:1.0];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navTitle.text = self.titleStr;
    self.navTitleLabel.text = self.titleStr;
    if (self.tableView) {
        [self.tableView reloadData];
    }
    [self appearMethod];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)dealloc {
    [self removeNoti];
}

@end
