//
//  XianQuShiTingViewController.m
//  CreateSongs
//
//  Created by axg on 16/9/2.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "XianQuShiTingViewController.h"
#import "XianQuPlayController.h"
#import "SongLoadingView.h"
#define TYBTN_TAG   100
#define BANZOU_TAG  101
#define RECODER_TAG 102
#define XUANLV_TAG  103
#define ZOUYIN_URL  @"https://service.woyaoxiege.com/core/home/index/template"
@interface XianQuShiTingViewController () {
    SongLoadingView *songLoading;
}
@property (nonatomic, assign) NSInteger tmpMark;
@end

@implementation XianQuShiTingViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
}

// 网络请求
- (void)getData {
    
    // 加载窗口
    songLoading = [[SongLoadingView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:songLoading];
    [songLoading initAction];
    
    [self requestLrc];
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
    [self requestVoice];
}


- (void)requestVoice {
#if XUANQU_FROME_NET
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    
    [manager POST:ZOUYIN_URL parameters:self.zouyinUrl progress:^(NSProgress * _Nonnull uploadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [songLoading stopAnimate];
        NSString *str = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        NSLog(@"%@", str);
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:nil];
        NSLog(@"%@", dic);
        self.mp3Url = dic[@"url"];
        self.webUrl = dic[@"fenxiang"];
        NSArray *tmpArr = [self.webUrl componentsSeparatedByString:@"/"];
        self.changeSingerAPIName = [tmpArr lastObject];
        //http://service.woyaoxiege.com/music/mp3/badc2dbc8cf1beb0349ca615d843b57b_1.mp3
        [self.customProgressView setProgress:0 withAnimated:NO];
        [self.player playWithUrl:self.mp3Url];
        [self getRow];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error.description);
        [songLoading stopAnimate];
    }];
#elif !XUANQU_FROME_NET
    [XWAFNetworkTool getUrl:self.zouyinUrl body:nil response:XWData requestHeadFile:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask *task, id resposeObjects) {
        [songLoading stopAnimate];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resposeObjects options:0 error:nil];
        NSLog(@"%@", dic);
        self.mp3Url = dic[@"url"];
        self.webUrl = dic[@"fenxiang"];
        NSArray *tmpArr = [self.webUrl componentsSeparatedByString:@"/"];
        self.changeSingerAPIName = [tmpArr lastObject];
        //http://service.woyaoxiege.com/music/mp3/badc2dbc8cf1beb0349ca615d843b57b_1.mp3
        [self.customProgressView setProgress:0 withAnimated:NO];
        [self.player playWithUrl:self.mp3Url];
        [self.player setVolume:1.0f];
        [self getRow];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error.description);
        [songLoading stopAnimate];
    }];
#endif
    
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
            NSInteger currentRow = 0;
            if (self.currentRow >= self.lrcTimeArray.count-1) {
                
            } else {
                NSInteger current = currentTime;
                
                for (NSInteger i = 0; i < self.lrcTimeArray.count-1; i++) {
                    NSString *currentStr = self.lrcTimeArray[i];
                    NSString *nextStr = self.lrcTimeArray[i+1];
                    
                    NSInteger currentNum = [currentStr integerValue];
                    NSInteger nextNum = [nextStr integerValue];
                    
                    if (current >= 0 && current < [self.lrcTimeArray[0] integerValue]) {
                        currentRow = 0;
                    } else if (current >= currentNum && current < nextNum) {
                        currentRow = i;
                    }
                }
                
//                if (self.tmpMark < self.lrcTimeArray.count) {
//                    NSLog(@"%ld+++%@--%ld", self.tmpMark, self.lrcTimeArray[self.tmpMark], current);
//                    if (current == [self.lrcTimeArray[self.tmpMark] integerValue]) {
//                        NSLog(@"___%@", self.lrcTimeArray[self.tmpMark]);
//                        currentRow = self.tmpMark;
//                        self.tmpMark ++;
                
                        if (currentRow < arrCount && totalTime != 0) {
                            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                self.currentRow = currentRow;
                                [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.currentRow inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
                                [self.tableView reloadData];
                            });
                        }
                        
                        
//                    }
//                }
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

- (void)turnToRecoder {
    [MobClick event:@"play_sing"];
    [self.player pause];
    [RecoderClass sharedRecoderClass].shouldChangeEar = YES;
    self.isPlaying = NO;
    
    
    XianQuPlayController *xqc = [XianQuPlayController new];
    
    xqc.zouyinUrl = self.zouyinUrl;
    xqc.lyricDataSource = self.lyricDataSource;
    xqc.isFirstPlay = self.isFirstPlay;
    xqc.isFromPlayView = self.isFromPlayView;
    xqc.isFromTianciPage = self.isFromTianciPage;
    xqc.isFirstGetZouyinMp3 = self.isFirstGetZouyinMp3;
    xqc.titleStr = self.titleStr;
    xqc.songName = self.titleStr;
    xqc.requestHeadName = self.requestHeadName;
    xqc.zouyin_banzouUrl = self.zouyin_banzouUrl;
    xqc.requestSongName = self.requestSongName;
    [self.navigationController pushViewController:xqc animated:YES];
}
/**
 *  返回按钮方法
 *
 *  @param sender 返回按钮
 */
- (void)backButtonAction:(UIButton *)sender {

    self.currentRow = 0;
    
    [self.player pause];
    [self.tableView reloadData];
    [self.navigationController popViewControllerAnimated:YES];
}
@end
