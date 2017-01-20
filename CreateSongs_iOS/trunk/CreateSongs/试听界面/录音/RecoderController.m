//
//  RecoderController.m
//  CreateSongs
//
//  Created by axg on 16/7/8.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "RecoderController.h"
#import "AERecorder.h"
#import "lame.h"
#import "ReleaseViewController.h"
#import "TPOscilloscopeLayer.h"
#import "AEAudioController.h"
#import "SongLoadingView.h"
#import "LoginViewController.h"
#import "PlayViewController.h"
#import "VoiceSettingController.h"
#import "AXGMixer.h"
#import "PlayShareObjects.h"


@interface RecoderController ()

@property (nonatomic, strong) TPOscilloscopeLayer *inputOscilloscope;

@property (nonatomic, strong) UIButton *secondNumber;
@property (nonatomic, strong) UIButton *thirdNumber;
@property (nonatomic, strong) UIButton *recordingView;
@property (nonatomic, strong) UIButton *recordedDone;

@property (nonatomic, strong) UIView *inputView;

@property (nonatomic, copy) NSString *playMp3Url;

@property (nonatomic, strong) SongLoadingView *songLoading;

@property (nonatomic, strong) CAShapeLayer *recordRedLayer;

@property (nonatomic, strong) UIBezierPath *path1;

@property (nonatomic, strong) UIBezierPath *path2;

@property (nonatomic, assign) BOOL willShow321;

@property (nonatomic, strong) UIButton *recordButton;

@property (nonatomic, strong) STBottomBtn *DoneButton;

@end

@implementation RecoderController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushToShareView) name:@"recordPushToShare" object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self appearToReSing];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    app.midiPlayVolume = 1.0f;
    self.isFromPlayView = NO;
    self.isFromTianciPage = NO;
    [self pause];
    [RecoderClass pausePlay];
    [RecoderClass pauseRecorder];
    [RecoderClass turnOffRecorder];
    [RecoderClass sharedRecoderClass].shouldChangeEar = NO;
}

- (void)createLyric {
    [super createLyric];
    self.navRightButton.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    PlayShareObjects *object = [PlayShareObjects sharedPlayShareObjects];
//    self.isFromTianciPage = object.isFromTianciPage;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"no" forKey:@"loading"];
    [RecoderClass sharedRecoderClass].shouldChangeEar = YES;
    if (self.isFromPlayView) {
        [self.customProgressView setProgress:0.0f withAnimated:NO];
        self.currentRow = 0;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self.tableView reloadData];
        [self.customProgressView changeToProgressType:RecordingType];
        
        self.songLoading = [[SongLoadingView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.songLoading];
        [self.songLoading initAction];
        
        if (self.isFromUserSong) {
            [self requestNewCode];
        } else {
            [self requestWavData];
        }
    } else if (self.isFromTianciPage) {
    
        [self.customProgressView setProgress:0.0f withAnimated:NO];
        self.currentRow = 0;
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
        [self.tableView reloadData];
        
        self.songLoading = [[SongLoadingView alloc] initWithFrame:self.view.bounds];
        [self.view addSubview:self.songLoading];
        [self.songLoading initAction];
        
        [self requestLrc];
    }
}

- (void)requestLrc {
    
    NSString *str = self.requestHeadName;

    str = [str stringByReplacingOccurrencesOfString:@"," withString:@"，"];
    str = [str stringByReplacingOccurrencesOfString:@"：" withString:@":"];
    
    NSArray *tmpArr = [str componentsSeparatedByString:@"，"];
    for (NSString *time in tmpArr) {
        NSInteger timeNum = 0;
        NSArray *tmpA = [time componentsSeparatedByString:@":"];
        NSInteger minNum = [tmpA[0] integerValue];
        NSInteger secNum = [tmpA[1] integerValue];
        timeNum = minNum * 60 + secNum;
        [self.lrcTimeArray addObject:[NSString stringWithFormat:@"%ld", timeNum]];
    }

    [self requestTianciSound];
}

- (void)requestTianciSound {
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:ZOUYIN_URL parameters:self.zouyinUrl progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
//        NSLog(@"%@", dic);
        self.shareMp3Url = dic[@"url"];
        self.shareWebUrl = dic[@"fenxiang"];
        NSArray *tmpArr = [self.shareWebUrl componentsSeparatedByString:@"/"];
        self.changeSingerAPIName = [tmpArr lastObject];
        
        [self requestWavData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.description);
    }];
}

- (void)requestNewCode {
    
    NSString *requestUrl = [NSString stringWithFormat:COPY_RECODER, self.firstSongCode];
    WEAK_SELF;
    [XWAFNetworkTool getUrl:requestUrl body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
        NSString *newSongName = dic[@"name"];
        NSLog(@"%@", newSongName);
        [RecoderClass sharedRecoderClass].shouldChangeEar = YES;
        
        self.changeSingerAPIName = newSongName;
        self.shareMp3Url = [NSString stringWithFormat:HOME_SOUND, newSongName];
        self.shareWebUrl = [NSString stringWithFormat:HOME_SHARE, newSongName];
        
        [self requestWavData];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [self.songLoading stopAnimate];
        [KVNProgress showErrorWithStatus:@"歌曲错误"];
    }];
}

- (void)appearMethod {
    if (self.isFromPlayView) {
        [self resetRecoderBtn];
    }
}
- (void)resetRecoderBtn {
    self.firstNumber.alpha = 0.0f;
    self.secondNumber.alpha = 0.0f;
    self.thirdNumber.alpha = 0.0f;
    self.recordingView.alpha = 0.0f;
    self.recordedDone.alpha = 0.0f;
    self.beginRecord.alpha = 1.0f;
}

- (void)createBottomBtn {
    
    self.willShow321 = YES;
    
    CGFloat radius1 = 35.5 * WIDTH_NIT;
    CGFloat radius2 = 15 * WIDTH_NIT;
    
    CGPoint center = CGPointMake(radius1, radius1);
    
    CGPoint left1 = CGPointMake(center.x - radius1, center.y);
    CGPoint top1 = CGPointMake(center.x, center.y - radius1);
    CGPoint right1 = CGPointMake(center.x + radius1, center.y);
    CGPoint bottom1 = CGPointMake(center.x, center.y + radius1);
    
    CGPoint left2 = CGPointMake(center.x - radius2, center.y);
    CGPoint top2 = CGPointMake(center.x, center.y - radius2);
    CGPoint right2 = CGPointMake(center.x + radius2, center.y);
    CGPoint bottom2 = CGPointMake(center.x, center.y + radius2);
    
    CGFloat h1 = 0.552;
    CGFloat h2 = 0.8;
    
    self.path1 = [UIBezierPath bezierPath];
    [self.path1 moveToPoint:left1];
    [self.path1 addCurveToPoint:top1 controlPoint1:CGPointMake(left1.x, left1.y - radius1 * h1) controlPoint2:CGPointMake(top1.x - radius1 * h1, top1.y)];
    [self.path1 addCurveToPoint:right1 controlPoint1:CGPointMake(top1.x + radius1 * h1, top1.y) controlPoint2:CGPointMake(right1.x, right1.y - radius1 * h1)];
    [self.path1 addCurveToPoint:bottom1 controlPoint1:CGPointMake(right1.x, right1.y + radius1 * h1) controlPoint2:CGPointMake(bottom1.x + radius1 * h1, bottom1.y)];
    [self.path1 addCurveToPoint:left1 controlPoint1:CGPointMake(bottom1.x - radius1 * h1, bottom1.y) controlPoint2:CGPointMake(left1.x, left1.y + radius1 * h1)];
    [self.path1 closePath];
    
    self.path2 = [UIBezierPath bezierPath];
    [self.path2 moveToPoint:left2];
    [self.path2 addCurveToPoint:top2 controlPoint1:CGPointMake(left2.x, left2.y - radius2 * h2) controlPoint2:CGPointMake(top2.x - radius2 * h2, top2.y)];
    [self.path2 addCurveToPoint:right2 controlPoint1:CGPointMake(top2.x + radius2 * h2, top2.y) controlPoint2:CGPointMake(right2.x, right2.y - radius2 * h2)];
    [self.path2 addCurveToPoint:bottom2 controlPoint1:CGPointMake(right2.x, right2.y + radius2 * h2) controlPoint2:CGPointMake(bottom2.x + radius2 * h2, bottom2.y)];
    [self.path2 addCurveToPoint:left2 controlPoint1:CGPointMake(bottom2.x - radius2 * h2, bottom2.y) controlPoint2:CGPointMake(left2.x, left2.y + radius2 * h2)];
    [self.path2 closePath];
    
    CGPoint center1 = CGPointMake(self.view.width / 2, self.customProgressView.center.y + 108 * HEIGHT_NIT);
    
    UIView *recordView = [[UIView alloc] initWithFrame:CGRectMake(center1.x - radius1, center1.y - radius1, 85 * WIDTH_NIT, 85 * WIDTH_NIT)];
    [self.firstBgView addSubview:recordView];
    recordView.center = center1;
    recordView.backgroundColor = [UIColor clearColor];
    recordView.layer.cornerRadius = recordView.width / 2;
    recordView.layer.masksToBounds = YES;
    recordView.layer.borderWidth = 7 * WIDTH_NIT;
    recordView.layer.borderColor = HexStringColor(@"#eeeeee").CGColor;
    
    self.recordRedLayer = [CAShapeLayer layer];
    self.recordRedLayer.frame = CGRectMake(center1.x - radius1, center1.y - radius1, 71 * WIDTH_NIT, 71 * WIDTH_NIT);
    [self.firstBgView.layer addSublayer:self.recordRedLayer];
    self.recordRedLayer.path = self.path1.CGPath;
    self.recordRedLayer.fillColor = HexStringColor(@"#E6797F").CGColor;

    self.recordButton = [UIButton new];
    self.recordButton.frame = recordView.frame;
    [self.firstBgView addSubview:self.recordButton];
    self.recordButton.selected = NO;
    self.recordButton.backgroundColor = [UIColor clearColor];
    [self.recordButton addTarget:self action:@selector(recodButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.recordButton.enabled = NO;
    
//    self.firstNumber = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.secondNumber = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.thirdNumber = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.recordedDone = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.recordingView = [UIButton buttonWithType:UIButtonTypeCustom];
//    self.beginRecord = [UIButton buttonWithType:UIButtonTypeCustom];
//    
//    self.inputView = [UIView new];
//    
//    
//    [self.beginRecord setBackgroundImage:[UIImage imageNamed:@"beginRecoder"] forState:UIControlStateNormal];
//    
//    
//    [self.firstNumber setTitle:@"3" forState:UIControlStateNormal];
//    [self.secondNumber setTitle:@"2" forState:UIControlStateNormal];
//    [self.thirdNumber setTitle:@"1" forState:UIControlStateNormal];
//    
//    [self.firstNumber setTitleColor:[UIColor colorWithHexString:@"#451d11"]];
//    [self.secondNumber setTitleColor:[UIColor colorWithHexString:@"#451d11"]];
//    [self.thirdNumber setTitleColor:[UIColor colorWithHexString:@"#451d11"]];
//    
//    
//    self.firstNumber.titleLabel.font = TECU_FONT(18*WIDTH_NIT);
//    self.secondNumber.titleLabel.font = self.firstNumber.titleLabel.font;
//    self.thirdNumber.titleLabel.font = self.firstNumber.titleLabel.font;
//
//    self.firstNumber.backgroundColor = [UIColor clearColor];
//    self.secondNumber.backgroundColor = [UIColor clearColor];
//    self.thirdNumber.backgroundColor = [UIColor clearColor];
//    self.beginRecord.backgroundColor = [UIColor clearColor];
//    self.inputView.backgroundColor = [UIColor clearColor];
//    self.recordedDone.backgroundColor = [UIColor clearColor];
//    self.recordingView.backgroundColor = [UIColor clearColor];
////    [self.recordingView setBackgroundImage:[UIImage imageNamed:@"录音中"] forState:UIControlStateNormal];
//    
//    
//    [self.recordedDone setBackgroundImage:[UIImage imageNamed:@"录音完成"] forState:UIControlStateNormal];
//    
//    
//    self.firstNumber.frame = CGRectMake(0, self.customProgressView.bottom + 25*HEIGHT_NIT, 85*HEIGHT_NIT, 85*HEIGHT_NIT);
//    self.firstNumber.center = CGPointMake(self.view.centerX, self.firstNumber.centerY);
//    self.secondNumber.frame = self.firstNumber.frame;
//    self.thirdNumber.frame = self.firstNumber.frame;
//    self.recordingView.frame = self.firstNumber.frame;
//    self.recordedDone.frame = CGRectMake(0, 0, 128*HEIGHT_NIT, 128*HEIGHT_NIT);
//    self.recordedDone.center = self.firstNumber.center;
//    self.beginRecord.frame = CGRectMake(0, 0, 128*HEIGHT_NIT, 128*HEIGHT_NIT);
//    self.beginRecord.center = self.firstNumber.center;
//    self.inputView.frame = self.firstNumber.bounds;
//    
//    [self resetRecoderBtn];
//    
//    self.firstNumber.tag = FIRST_TAG;
//    self.secondNumber.tag = SECOND_TAG;
//    self.thirdNumber.tag = THIRD_TAG;
//    self.recordingView.tag = RECoding_TAG;
//    self.recordedDone.tag = RECoded_TAG;
//    self.beginRecord.tag = BEGINRecod_TAG;
//    
////    self.firstNumber.clipsToBounds = YES;
////    self.firstNumber.layer.cornerRadius = self.firstNumber.height/2;
////    self.firstNumber.layer.borderWidth = 0.5;
////    self.firstNumber.layer.borderColor = [UIColor colorWithHexString:@"#451d11"].CGColor;
//    
////    self.secondNumber.clipsToBounds = YES;
////    self.secondNumber.layer.cornerRadius = self.firstNumber.height/2;
////    self.secondNumber.layer.borderWidth = 0.5;
////    self.secondNumber.layer.borderColor = [UIColor colorWithHexString:@"#451d11"].CGColor;
//    
////    self.thirdNumber.clipsToBounds = YES;
////    self.thirdNumber.layer.cornerRadius = self.firstNumber.height/2;
////    self.thirdNumber.layer.borderWidth = 0.5;
////    self.thirdNumber.layer.borderColor = [UIColor colorWithHexString:@"#451d11"].CGColor;
//    
//    [self.firstNumber addTarget:self action:@selector(mixVoiceBtnClick:)];
//    [self.secondNumber addTarget:self action:@selector(mixVoiceBtnClick:)];
//    [self.thirdNumber addTarget:self action:@selector(mixVoiceBtnClick:)];
//    [self.recordingView addTarget:self action:@selector(mixVoiceBtnClick:)];
//    [self.recordedDone addTarget:self action:@selector(mixVoiceBtnClick:)];
//    [self.beginRecord addTarget:self action:@selector(mixVoiceBtnClick:)];
    
    
    AEAudioController *aeAudioController = [RecoderClass sharedRecoderClass].audioController;
    self.inputOscilloscope = [[TPOscilloscopeLayer alloc] initWithAudioDescription:aeAudioController.audioDescription];
    self.inputOscilloscope.frame = CGRectMake(0, 0, self.inputView.width, self.inputView.height);
    self.inputOscilloscope.lineColor = [UIColor colorWithWhite:0.0 alpha:0.3];
//    self.inputOscilloscope.borderWidth = 0.5;
//    self.inputOscilloscope.borderColor = [UIColor colorWithHexString:@"#451d11"].CGColor;
    self.inputOscilloscope.cornerRadius = self.firstNumber.height / 2;
    [self.recordingView.layer addSublayer:self.inputOscilloscope];
    [aeAudioController addInputReceiver:self.inputOscilloscope];
    
    
//    self.bottomBgImage = [UIImageView new];
//    self.bottomBgImage.frame = CGRectMake(0, 0, 128*HEIGHT_NIT, 128*HEIGHT_NIT);
//    self.bottomBgImage.center = self.firstNumber.center;
//    self.bottomBgImage.backgroundColor = [UIColor clearColor];
//    self.bottomBgImage.image = [UIImage imageNamed:@"recoder椭圆"];
//    self.bottomBgImage.userInteractionEnabled = YES;
//    self.bottomBgImage.alpha = 1.0f;
//    [self.firstBgView addSubview:self.bottomBgImage];
//    
//    
//    [self.firstBgView addSubview:self.firstNumber];
//    [self.firstBgView addSubview:self.secondNumber];
//    [self.firstBgView addSubview:self.thirdNumber];
//    [self.firstBgView addSubview:self.recordingView];
//    [self.firstBgView addSubview:self.recordedDone];
//    [self.firstBgView addSubview:self.beginRecord];
    

    self.DoneButton = [STBottomBtn buttonWithType:UIButtonTypeCustom];
    self.DoneButton.frame = CGRectMake(self.view.width - 55*WIDTH_NIT - 30 * WIDTH_NIT, 0, 30 * WIDTH_NIT, 30* WIDTH_NIT);
    self.DoneButton.centerY = recordView.centerY;
    self.DoneButton.titleLabel.font = NORML_FONT(12*WIDTH_NIT);
    [self.DoneButton setTitle:@"完成" forState:UIControlStateNormal];
    [self.DoneButton setImage:[UIImage imageNamed:@"录音_完成"] forState:UIControlStateNormal];
    [self.DoneButton setTitleColor:[UIColor colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    [self.DoneButton setTitleColor:[UIColor colorWithHexString:@"#576D6D"] forState:UIControlStateHighlighted];
    [self.DoneButton addTarget:self action:@selector(completeAction) forControlEvents:UIControlEventTouchUpInside];
    [self.firstBgView addSubview:self.DoneButton];
    // 刚进界面完成按钮不可用
    self.DoneButton.enabled = NO;
    
    STBottomBtn *reSingButton = [STBottomBtn buttonWithType:UIButtonTypeCustom];
    //    changeBackTrack.backgroundColor = [UIColor redColor];
    reSingButton.frame = CGRectMake(55*WIDTH_NIT, self.DoneButton.top, self.DoneButton.width, self.DoneButton.width);
    [reSingButton setTitle:@"重唱" forState:UIControlStateNormal];
    reSingButton.titleLabel.font = self.DoneButton.titleLabel.font;
    [reSingButton setTitleColor:[UIColor colorWithHexString:@"#535353"] forState:UIControlStateNormal];
    [reSingButton setTitleColor:[UIColor colorWithHexString:@"#576D6D"] forState:UIControlStateHighlighted];
    [reSingButton setImage:[UIImage imageNamed:@"录音_重唱"] forState:UIControlStateNormal];
    [reSingButton addTarget:self action:@selector(reSingAction) forControlEvents:UIControlEventTouchUpInside];
    [self.firstBgView addSubview:reSingButton];
    
    
    self.midiPlayer = [[XMidiPlayer alloc] init];
    [self.midiPlayer pause];
}

#pragma mark - Action

// 开始录音动画
- (void)startRecordAnimation {
    CAKeyframeAnimation *caKey = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    //        caKey.duration = 1;
    caKey.values = @[(__bridge id _Nullable)self.path1.CGPath, (__bridge id _Nullable)self.path2.CGPath];
    caKey.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    caKey.fillMode = kCAFillModeForwards;
    caKey.repeatCount = 0;
    
    //结束后是否移除动画
    caKey.removedOnCompletion = NO;
    
    //添加动画
    [self.recordRedLayer addAnimation:caKey forKey:@""];
}

// 暂停录音动画
- (void)pauseRecordAnimation {
    CAKeyframeAnimation *caKey = [CAKeyframeAnimation animationWithKeyPath:@"path"];
    //        caKey.duration = 1;
    caKey.values = @[(__bridge id _Nullable)self.path2.CGPath, (__bridge id _Nullable)self.path1.CGPath];
    caKey.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear];
    caKey.fillMode = kCAFillModeForwards;
    caKey.repeatCount = 0;
    
    //结束后是否移除动画
    caKey.removedOnCompletion = NO;
    
    //添加动画
    [self.recordRedLayer addAnimation:caKey forKey:@""];
}

// 录音按钮方法
- (void)recodButtonAction:(UIButton *)sender {
    
    [self beforeRecoder:sender];
}

- (void)appearToReSing {
    
    self.isFirstPlay = YES;
    self.isAutoToEnd = YES;
    self.willShow321 = YES;
    self.recordButton.enabled = YES;
    [self.inputOscilloscope stop];
    
    [self pauseRecord];
    [self.midiPlayer pause];
    
    if (self.recordButton.selected) {
        [self recodButtonAction:self.recordButton];
    }
    self.DoneButton.enabled = NO;
    WEAK_SELF;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        STRONG_SELF;
        
        if (!self.isShared) {
//            if (!self.isFromTianciPage) {
                [self.customProgressView changeToProgressType:RecordingType];
//            } else {
//                [self.customProgressView changeToProgressType:PlayingType];
//            }
            [self.customProgressView.playBtn setSelected:YES];
            self.customProgressView.currentTime.text = @"00:00";
            [self.customProgressView setProgress:0 withAnimated:NO];
        } else {
            
        }
        // 完成按钮变为不可用状态
        self.DoneButton.enabled = NO;
    });
}

// 重唱按钮方法
- (void)reSingAction {
    NSLog(@"重唱");
    
    self.isFirstPlay = YES;
    self.isAutoToEnd = YES;
    self.willShow321 = YES;
    self.recordButton.enabled = YES;
    [self.inputOscilloscope stop];
    
    [self pauseRecord];
    [self.midiPlayer pause];
    
    if (self.recordButton.selected) {
        [self recodButtonAction:self.recordButton];
    }
    
    WEAK_SELF;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        STRONG_SELF;
        [self.customProgressView changeToProgressType:RecordingType];
        [self.customProgressView.playBtn setSelected:YES];
        self.customProgressView.currentTime.text = @"00:00";
        [self.customProgressView setProgress:0 withAnimated:NO];
        
        // 完成按钮变为不可用状态
        self.DoneButton.enabled = NO;
    });
    
//    if (self.recordButton.selected) {
//        [self recodButtonAction:self.recordButton];
//        WEAK_SELF;
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.25 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//            STRONG_SELF;
//            [self.customProgressView setProgress:0 withAnimated:NO];
//            
//            self.isFirstPlay = YES;
//            self.isAutoToEnd = YES;
//            self.willShow321 = YES;
//            self.recordButton.enabled = YES;
//            [self.inputOscilloscope stop];
//        });
//    } else {
//        [self.customProgressView setProgress:0 withAnimated:NO];
//        
//        self.isFirstPlay = YES;
//        self.isAutoToEnd = YES;
//        self.willShow321 = YES;
//        self.recordButton.enabled = YES;
//        [self.inputOscilloscope stop];
//    }

}

// 完成按钮方法
- (void)completeAction {
    NSLog(@"完成");
    
    [self stopRecorder];
    
   //    self.rvc.lyricDataSource = self.lyricDataSource;
//    self.rvc.shareWebUrl = self.webUrl;
//    [self.navigationController pushViewController:self.rvc animated:YES];
    
}

// 开始录音方法
- (void)startRecord {
    NSLog(@"录音开始");
    
    self.isAutoToEnd = YES;
    [self.inputOscilloscope start];
    if (self.isEnd || self.isFirstPlay) {
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *songPath = [NSString stringWithFormat:@"%@/banzou.mp3", [TYCache cacheDirectory]];
        if ([fileManager fileExistsAtPath:songPath]) {
            
            [self startRecordAnimation];
            
            self.playMp3Url = songPath;
            [RecoderClass playVoiceWithURL:[NSURL fileURLWithPath:songPath]];
            
            [RecoderClass turnOnRecorder];
            [self.player playWithPathUrl:songPath];
            [self.player setVolume:0];
            [self getRow];
            self.isFirstPlay = NO;
        } else {
            [KVNProgress showErrorWithStatus:@"数据错误:2"];
        }
    } else {
        [self play];
        [RecoderClass beginPlay];
        [RecoderClass beginRecorder];
    }
    
}

// 暂停录音按钮方法
- (void)pauseRecord {
    NSLog(@"录音暂停");
    
    [self pause];
    [RecoderClass pausePlay];
    [RecoderClass pauseRecorder];
}


- (void)recodeDoneState {
    [self.inputOscilloscope stop];
    self.firstNumber.alpha = 0.0f;
    self.secondNumber.alpha = 0.0f;
    self.thirdNumber.alpha = 0.0f;
    self.recordingView.alpha = 0.0f;
    self.recordedDone.alpha = 1.0f;
    self.beginRecord.alpha = 0.0f;
}

- (void)createNaviTitleUnderView:(UIView *)customNaviView {
    self.navTitleLabel = [UILabel new];
    self.navTitleLabel.frame = CGRectMake(0, 25 * HEIGHT_NIT, self.view.width, 50 * HEIGHT_NIT);
    self.navTitleLabel.text = self.songName;
    self.navTitleLabel.textAlignment = NSTextAlignmentCenter;
    self.navTitleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.navTitleLabel.font = [UIFont systemFontOfSize:18 * WIDTH_NIT];
    [customNaviView addSubview:self.navTitleLabel];
}

- (void)createProgressViewUnderView:(UIView *)lyricBg {
    self.customProgressView = [[PlayViewCustomProgress alloc] initWithFrame:CGRectMake(lyricBg.left,
                                                                                   lyricBg.bottom + 15*HEIGHT_NIT,
                                                                                   width(lyricBg),
                                                                                   50*HEIGHT_NIT) andType:RecordingType];
    WEAK_SELF;
    self.customProgressView.playBtnBlock = ^(BOOL isPlaying){
        STRONG_SELF;
        [self playRecoderDelegate];
    };
    
    self.customProgressView.sliderDidChangedBlock = ^(CGFloat value) {
        STRONG_SELF;
        [self pause];
        [RecoderClass pausePlay];
        [RecoderClass pauseRecorder];
        [self sliderValueChanged:value];
    };
    
    [self.firstBgView addSubview:self.customProgressView];
    self.customProgressView.backgroundColor = [UIColor clearColor];
}
// 播放录音按钮方法
- (void)playRecoderDelegate {
    
    if (![XWAFNetworkTool checkNetwork]) {
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    if (self.isEnd) {
        //        [btn setTitle:@"" forState:UIControlStateNormal];
        NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:RECODER_FILE];
        
        [RecoderClass playFinalVoiceWithURL:[NSURL fileURLWithPath:path]];
        [self.player playWithPathUrl:path];
        [self.player setVolume:0];
        [self getRow];
    } else {
        if (self.isPlaying) {
            [RecoderClass pausePlay];
            [self pause];
        } else {
            [RecoderClass beginPlay];
            [self play];
        }
    }
}
// 播放按钮方法
- (void)playDelegate {
    
    if (![XWAFNetworkTool checkNetwork]) {
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    if (self.isEnd) {
        [RecoderClass playFinalVoiceWithURL:[NSURL fileURLWithPath:self.playMp3Url]];
        [RecoderClass turnOnRecorder];
        [self.player playWithPathUrl:self.playMp3Url];
        [self.player setVolume:0];
        [self getRow];
        
    } else {
        if (self.isPlaying) {
            [RecoderClass pausePlay];
            [RecoderClass pauseRecorder];
            [self pause];
        } else {
            [RecoderClass beginPlay];
            [RecoderClass beginRecorder];
            [self play];
        }
        //        self.isPlaying = !self.isPlaying;
    }
}
- (void)requestWavData {
    if (![XWAFNetworkTool checkNetwork]) {
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    [self pause];
//    [[ToastView sharedToastView] showLoadingViewWithMessage:nil inView:[[[UIApplication sharedApplication] delegate] window]];
    
    NSString *getWavUrl = [NSString stringWithFormat:GET_WAV_MP3, self.changeSingerAPIName];
    
    if (self.isFromTianciPage) {
#if XUANQU_FROME_NET
        getWavUrl = self.zouyin_banzouUrl;
#elif !XUANQU_FROME_NET
        getWavUrl = [NSString stringWithFormat:ZOUYIN_BANXOU, self.requestSongName];
#endif
        
    }
    
    NSLog(@"请求wav的地址为%@", getWavUrl);
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager GET:getWavUrl parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//        [[ToastView sharedToastView] forceHide];
        [self.songLoading stopAnimate];
        
        [TYCache setObject:responseObject forKey:@"banzou.mp3"];
        
        if (self.isFromTianciPage) {
            [self playRecoderDelegate];
        }
        [self allowRecorder];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"数据错误:1%@", error.description);
        [self shouldNotRecorder];
        [KVNProgress showErrorWithStatus:@"数据错误:1"];
//        [[ToastView sharedToastView] forceHide];
        [self.songLoading stopAnimate];
    }];
}

- (void)allowRecorder {
    
    self.recordButton.enabled = YES;
    
    self.beginRecord.enabled = YES;
    self.navRightButton.enabled = YES;
}

- (void)shouldNotRecorder {
    
    self.recordButton.enabled = NO;
    
    self.beginRecord.enabled = NO;
    self.navRightButton.enabled = NO;
}

- (void)stopRecorder {
    [self.midiPlayer pause];
    [self.inputOscilloscope stop];
    self.isAutoToEnd = NO;
    [self pause];
    self.isPlaying = NO;
    self.isEnd = YES;
    [self.customProgressView.playBtn setSelected:YES];
    [RecoderClass pausePlay];
    [RecoderClass turnOffRecorder];
    [self recodeDoneState];
//    [self performSelectorInBackground:@selector(playRecoderVoice) withObject:nil];
    [self performSelector:@selector(playRecoderVoice) withObject:nil afterDelay:0];
}

- (void)mixVoiceBtnClick:(UIButton *)btn {
    
    switch (btn.tag) {
        case FIRST_TAG: {}
            break;
        case SECOND_TAG: {}
            break;
        case THIRD_TAG: {}
            break;
        case RECoding_TAG: {
//            [self pause];
//            [RecoderClass pausePlay];
//            [RecoderClass pauseRecorder];
//            [self resetRecoderBtn];
            [self stopRecorder];
        }
            break;
        case RECoded_TAG: {
            [self uploadRecorder];
        }
            break;
        case BEGINRecod_TAG: {

        }
            break;
        default:
            break;
    }
}

- (void)beginRecoder:(UIButton *)sender {
    
    if (sender.selected) {
        
        [self pauseRecordAnimation];
        
        [self pauseRecord];
        
        // 点击录音按钮之后完成按钮可用
        self.DoneButton.enabled = YES;
        
    } else {
        
        if (self.willShow321) {
            
            [self.customProgressView changeToProgressType:RecordingType];
            
            CGPoint center1 = CGPointMake(self.view.width / 2, self.customProgressView.center.y + 108 * HEIGHT_NIT);
            
            UIView *numberBgView = [[UIView alloc] initWithFrame:self.firstBgView.bounds];
            numberBgView.backgroundColor = [UIColor clearColor];
            [self.firstBgView addSubview:numberBgView];
            
            UILabel *numberLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 85 * WIDTH_NIT, 85 * WIDTH_NIT)];
            numberLabel.center = center1;
            [numberBgView addSubview:numberLabel];
            numberLabel.font = TECU_FONT(18);
            numberLabel.textColor = HexStringColor(@"#451d11");
            numberLabel.backgroundColor = self.firstBgView.backgroundColor;
            numberLabel.textAlignment = NSTextAlignmentCenter;
            numberLabel.layer.cornerRadius = numberLabel.width / 2;
            numberLabel.layer.masksToBounds = YES;
            numberLabel.layer.borderWidth = 7 * WIDTH_NIT;
            numberLabel.layer.borderColor = HexStringColor(@"#eeeeee").CGColor;
            numberLabel.text = @"3";
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                numberLabel.text = @"2";
            });
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                numberLabel.text = @"1";
            });
            WEAK_SELF;
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                STRONG_SELF;
                numberBgView.hidden = YES;
                self.willShow321 = NO;
                
                [self startRecord];
                
                // 点击录音按钮之后完成按钮可用
                self.DoneButton.enabled = YES;
            });
            
        } else {
            
            [self startRecordAnimation];
            
            [self startRecord];
            
            // 点击录音按钮之后完成按钮可用
            self.DoneButton.enabled = YES;
            
        }
        
    }
    
    sender.selected = !sender.selected;
    
//    self.isAutoToEnd = YES;
//    [UIView animateWithDuration:1 animations:^{
//        self.beginRecord.alpha = 0.0f;
//        self.firstNumber.alpha = 1.0f;
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:1 animations:^{
//            self.firstNumber.alpha = 0.0f;
//            self.secondNumber.alpha = 1.0f;
//        } completion:^(BOOL finished) {
//            [UIView animateWithDuration:1 animations:^{
//                self.secondNumber.alpha = 0.0f;
//                self.thirdNumber.alpha = 1.0f;
//            } completion:^(BOOL finished) {
//                [UIView animateWithDuration:1 animations:^{
//                    self.thirdNumber.alpha = 0.0f;
//                    self.recordingView.alpha = 1.0f;
//                } completion:^(BOOL finished) {
//                    [self.inputOscilloscope start];
//                    if (self.isEnd || self.isFirstPlay) {
//                        NSFileManager *fileManager = [NSFileManager defaultManager];
//                        NSString *songPath = [NSString stringWithFormat:@"%@/banzou.mp3", [TYCache cacheDirectory]];
//                        if ([fileManager fileExistsAtPath:songPath]) {
//                            self.playMp3Url = songPath;
//                            [RecoderClass playVoiceWithURL:[NSURL fileURLWithPath:songPath]];
    
//                            if (self.isFromTianciPage) {
//                                NSString *path = [[NSBundle mainBundle] pathForResource:@"发如雪 降" ofType:@"mid"];
//                                NSData *data = [[NSData alloc] initWithContentsOfFile:path];
//                                AppDelegate *app = [UIApplication sharedApplication].delegate;
//                                app.midiPlayVolume = 0.05f;
//                                [self.midiPlayer initMidiWithData:data];
//                                [self.midiPlayer play];
//                            }
                            
//                            [RecoderClass turnOnRecorder];
//                            [self.player playWithPathUrl:songPath];
//                            [self.player setVolume:0];
//                            [self getRow];
//                            self.isFirstPlay = NO;
//                        } else {
//                            [KVNProgress showErrorWithStatus:@"数据错误:2"];
//                        }
//                    } else {
//                        [self play];
//                        [RecoderClass beginPlay];
//                        [RecoderClass beginRecorder];
//                    }
//                }];
//            }];
//        }];
//    }];
 
}

- (void)beforeRecoder:(UIButton *)sender {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.minVolume = 0.3f;
    //number  yuanqu = frx
    [self beginRecoder:sender];
}
// 播放结束方法
- (void)playToEnd:(NSNotification *)sender {
    
    if (self.recordButton.selected) {
        [self recodButtonAction:self.recordButton];
    }
    self.recordButton.enabled = NO;
    
    [self.midiPlayer pause];
    self.tmpMark = 0;
    self.isPlaying = NO;
    self.isEnd = YES;
    [self.customProgressView.playBtn setSelected:YES];
    [self.customProgressView.currentTime setText:@"0:00"];
    [self.customProgressView setProgress:0.0f withAnimated:NO];
    self.currentRow = 0;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self.tableView reloadData];
    [RecoderClass turnOffRecorder];
//    [self recodeDoneState];
//    [self.customProgressView changeToProgressType:PlayingType];
    
    if (self.isAutoToEnd) {
        self.isAutoToEnd = NO;
        [self performSelector:@selector(playRecoderVoice) withObject:nil afterDelay:1];
    }
}
- (void)delayPlay {
    VoiceSettingController *vsc = [VoiceSettingController new];
    vsc.lrcDataSource = self.lyricDataSource;
    vsc.shareUrl = self.shareWebUrl;
    vsc.mp3Url = self.shareMp3Url;
    vsc.songName =self.songName;
    
    vsc.code = self.changeSingerAPIName;
    vsc.banzouPath = self.finalBanzouPath;
    vsc.recoderPath = self.finalPath;
    
    [self.navigationController pushViewController:vsc animated:YES];
}

- (void)changeAllowState {
    self.shouldDone = YES;
}

- (void)banzouToMp3 {
    
    NSString *path1 = [NSString stringWithFormat:@"%@/banzou.mp3", [TYCache cacheDirectory]];
    
    AXGMixer *mixer = [AXGMixer new];

    [mixer getCutMP3File:@[path1, self.finalPath] withVolumes:@[@1, @1] success:^(NSString *path) {
        [self cutDone:path];
    } error:^(NSError *error) {
        
    }];
}

- (void)cutDone:(NSString *)path {
//    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:RECODER_FILE];
    
    NSString *cafFilePath = path;
    
    NSString *mp3FileName = @"BanZou";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
    
    self.finalBanzouPath = mp3FilePath;
    
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
        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        lame_set_brate(lame, 32);
        lame_set_mode(lame, MONO);
        lame_set_quality(lame, 2);
        
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0)
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            else
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            
            fwrite(mp3_buffer, write, 1, mp3);
            
        } while (read != 0);
        
        lame_close(lame);
        fclose(mp3);
        fclose(pcm);
    }
    @catch (NSException *exception) {
        NSLog(@"%@",[exception description]);
    }
    @finally {
//        [self performSelectorOnMainThread:@selector(delayPlay) withObject:nil waitUntilDone:NO];
        [self performSelector:@selector(delayPlay) withObject:nil afterDelay:0];
    }

}

- (void) toMp3 {
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:RECODER_FILE];
    
    NSString *cafFilePath = path;
    
    NSString *mp3FileName = @"Mp3File";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[NSHomeDirectory() stringByAppendingFormat:@"/Documents/"] stringByAppendingPathComponent:mp3FileName];
    
    self.finalPath = mp3FilePath;
    
    NSLog(@"mp3FilePath  -----  %@", mp3FilePath);
    @try {
        int read, write;
        
        FILE *pcm = fopen([cafFilePath cStringUsingEncoding:1], "rb");  //source
        fseek(pcm, 4*1024, SEEK_CUR);                                   //skip file header
        FILE *mp3 = fopen([mp3FilePath cStringUsingEncoding:1], "wb");  //output
        
        const int PCM_SIZE = 8192;
        const int MP3_SIZE = 8192;
        short int pcm_buffer[PCM_SIZE*2];
        unsigned char mp3_buffer[MP3_SIZE];
        
        /*
         Float64             mSampleRate;
         AudioFormatID       mFormatID;
         AudioFormatFlags    mFormatFlags;
         UInt32              mBytesPerPacket;
         UInt32              mFramesPerPacket;
         UInt32              mBytesPerFrame;
         UInt32              mChannelsPerFrame;
         UInt32              mBitsPerChannel;
         UInt32              mReserved;
         */
        AEAudioController *audioController = [RecoderClass sharedRecoderClass].audioController;
        AudioStreamBasicDescription format = audioController.audioDescription;
        lame_t lame = lame_init();
        
        lame_set_num_channels(lame, 1);
        lame_set_in_samplerate(lame, format.mSampleRate);//44100.0
//        lame_set_VBR(lame, vbr_default);
        lame_init_params(lame);
        lame_set_brate(lame, 32);
        lame_set_mode(lame, MONO);
        lame_set_quality(lame, 2);
        lame_set_bWriteVbrTag(lame, 0);
        do {
            read = fread(pcm_buffer, 2*sizeof(short int), PCM_SIZE, pcm);
            if (read == 0){
                write = lame_encode_flush(lame, mp3_buffer, MP3_SIZE);
            } else {
                write = lame_encode_buffer_interleaved(lame, pcm_buffer, read, mp3_buffer, MP3_SIZE);
            }
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
        [self banzouToMp3];
    }
}

- (void)playRecoderVoice {
//    [self.customProgressView changeToProgressType:PlayingType];

    [self toMp3];

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
            NSLog(@"---%f", totalDuration*1.0*newValue);
            
            
            NSString *path = self.finalPath;
            [RecoderClass playFinalVoiceWithURL:[NSURL fileURLWithPath:path]];
            [RecoderClass setPlayerCurrentTime:totalDuration*1.0*newValue];
            [RecoderClass beginPlay];

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
/**
 *  演唱完成上传录音
 */
- (void)uploadRecorder {
    
    if (!self.shouldDone) {
        return;
    }
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.song_tag = @"演唱";
    
    [MobClick event:@"play_sing_complete"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }//@{@"key":@"value"}
    [self pause];
    [self.customProgressView.playBtn setSelected:YES];
    [RecoderClass pausePlay];
    
//    [[ToastView sharedToastView] showLoadingViewWithMessage:nil inView:[[[UIApplication sharedApplication] delegate] window]];
    
    SongLoadingView *songLoading = [[SongLoadingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:songLoading];
    [songLoading initAction];
    
//    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:RECODER_FILE];
    
//    NSData *data = [NSData dataWithContentsOfFile:path];
//
//    [TYCache setObject:data forKey:@"recorder.mp3"];
    
    self.recoderData =  [NSData dataWithContentsOfFile:self.finalPath];
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    
    [manager POST:UPLOAD_RECODER parameters:@{@"key":@"value"} constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {//70F2EC5A06BD8A9B4D57152CADD3C2A0
        NSLog(@"---%@", [PlayViewController sharePlayVC].postMidiName);
         [formData appendPartWithFileData:self.recoderData name:@"file" fileName:[NSString stringWithFormat:@"%@.mp3", self.changeSingerAPIName] mimeType:@"audio/mp3"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {

        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        NSLog(@"--%@", str);
        
//        [[ToastView sharedToastView] forceHide];
        [songLoading stopAnimate];
        
        [self pushToShareView];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
//         [[ToastView sharedToastView] forceHide];
        [songLoading stopAnimate];
        [KVNProgress showErrorWithStatus:@"数据错误:3"];
        NSLog(@"wrong---%@", error.description);
    }];
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
        CMTime time1 = self.player.currentItem.duration;
        
        CGFloat totalTime = time1.value / time1.timescale;
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
        if (self.isFromTianciPage) {
            // 刷新歌词
            NSInteger currentRow;
            if (self.currentRow >= self.lrcTimeArray.count-1) {
                
            } else {
                NSInteger current = currentTime;
                if (self.tmpMark < self.lrcTimeArray.count) {
                    NSLog(@"%ld+++%@--%ld", self.tmpMark, self.lrcTimeArray[self.tmpMark], current);
                    if (current == [self.lrcTimeArray[self.tmpMark] integerValue]) {
                        NSLog(@"___%@", self.lrcTimeArray[self.tmpMark]);
                        currentRow = self.tmpMark;
                        self.tmpMark ++;
                        if (currentRow < arrCount && totalTime != 0) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                self.currentRow = currentRow;
                                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                [self.tableView reloadData];
                            });
                        }
                    }
                }
            }
           
        } else {
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
        }
    }];
}
/*
 ShareViewController *shareVC = [[ShareViewController alloc] init];
 shareVC.isShow = YES;
 shareVC.webUrl = self.webUrl;
 shareVC.mp3Url = self.mp3Url;
 shareVC.songTitle = self.titleLabel.text;
 [self.navigationController pushViewController:shareVC animated:YES];
 */

- (void)pushToShareView {
    
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        //changeAllowState
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playRecoderVoice) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayPlay) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeAllowState) object:nil];
    
    [RecoderClass sharedRecoderClass].shouldChangeEar = NO;
    
//    PlayViewController *playVC = [PlayViewController sharePlayVC];
    
    ReleaseViewController *rvc = [[ReleaseViewController alloc] init];
    
//    rvc.webUrl = playVC.webUrl;
//    rvc.mp3Url = playVC.mp3Url;
//    rvc.songName = playVC.titleStr;
    
    rvc.webUrl = self.shareWebUrl;
    rvc.mp3Url = self.shareMp3Url;
    rvc.songName = self.shareSongName;
    
    NSLog(@"%@  %@", rvc.webUrl, rvc.mp3Url);
    [self.navigationController pushViewController:rvc animated:YES];

//    } else {
//        AXG_LOGIN(LOGIN_LOCATION_RECORD);
//    }
}

- (void)backButtonAction:(UIButton *)sender {
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playRecoderVoice) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayPlay) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeAllowState) object:nil];
    
    [RecoderClass sharedRecoderClass].shouldChangeEar = NO;
    [self.customProgressView changeToProgressType:RecordingType];
    self.currentRow = 0;
    [RecoderClass pausePlay];
    [RecoderClass turnOffRecorder];
    [self.player pause];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)dealloc {
    [self.player removeTimeObserver:self.observer];//delayPlay
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playRecoderVoice) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayPlay) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeAllowState) object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVPlayerItemDidPlayToEndTimeNotification object:self.player.currentItem];
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
