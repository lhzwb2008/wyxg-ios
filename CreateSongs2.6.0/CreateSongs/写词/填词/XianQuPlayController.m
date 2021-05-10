//
//  XianQuPlayController.m
//  CreateSongs
//
//  Created by axg on 16/8/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "XianQuPlayController.h"
#import "ReleaseViewController.h"

@implementation XianQuPlayController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isShared = NO;
}

- (void)turnToShareView {
    if (self.isRecorded) {
        [self stopRecorder];
    } else {
        self.isShared = YES;
        [self pushToShareView];
    }
}
- (void)sendRightBtnClick:(UIButton *)btn {
    [self turnToShareView];
}

- (void)pushToShareView {
    [self pause];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(playRecoderVoice) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(delayPlay) object:nil];
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(changeAllowState) object:nil];
    
    [RecoderClass sharedRecoderClass].shouldChangeEar = NO;
    
    //    PlayViewController *playVC = [PlayViewController sharePlayVC];
    
    ReleaseViewController *rvc = [[ReleaseViewController alloc] init];
    
    rvc.webUrl = self.shareWebUrl;
    rvc.mp3Url = self.shareMp3Url;
    rvc.songName = self.titleStr;
    
    NSLog(@"%@  %@", rvc.webUrl, rvc.mp3Url);
    [self.navigationController pushViewController:rvc animated:YES];
}

- (void)createBottomBtn {
    [super createBottomBtn];
    self.beginRecord.frame = CGRectMake(0, 0, 85*HEIGHT_NIT, 85*HEIGHT_NIT);
    self.beginRecord.center = self.firstNumber.center;
    [self.beginRecord setBackgroundImage:[UIImage imageNamed:@"play麦克风"] forState:UIControlStateNormal];
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
//        [RecoderClass pausePlay];
//        [RecoderClass pauseRecorder];
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
        if (self.isRecorded) {
            NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:RECODER_FILE];
            
            [RecoderClass playFinalVoiceWithURL:[NSURL fileURLWithPath:path]];
            [self.player playWithPathUrl:path];
            [self.player setVolume:0];
        } else {
            [self.customProgressView.playBtn setSelected:NO];
            [self.player playWithUrl:self.shareMp3Url];
        }
        [self getRow];
        return;
    }
    if (self.isFirstGetZouyinMp3) {
        
//        [self.player playWithUrl:self.shareMp3Url];
        
        self.isFirstGetZouyinMp3 = NO;
//        [self getRow];
    } else {
        if (self.isPlaying) {
            if (self.isRecorded) {
                [RecoderClass pausePlay];
            }
            [self pause];
        } else {
            if (self.isRecorded) {
                [RecoderClass beginPlay];
            }
            [self play];
        }
    }
}

// 播放结束方法
- (void)playToEnd:(NSNotification *)sender {
    self.isPlaying = NO;
    self.isEnd = YES;
    self.tmpMark = 0;
    [self.customProgressView.playBtn setSelected:YES];
    [self.customProgressView.currentTime setText:@"0:00"];
    [self.customProgressView setProgress:0.0f withAnimated:NO];
    self.currentRow = 0;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
    [self.tableView reloadData];
    
    if (self.isRecorded) {
        [RecoderClass turnOffRecorder];
//        [self recodeDoneState];
//        [self.customProgressView changeToProgressType:PlayingType];
        if (self.isAutoToEnd) {
            self.isAutoToEnd = NO;
            [self performSelector:@selector(playRecoderVoice) withObject:nil afterDelay:1];
        }
    } else {
        
    }
}
//http://1.117.109.129/core/music/zouyin_acc/frx.mp3

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
            for (NSInteger i = 0; i < self.lrcTimeArray.count; i++) {
                NSInteger currentTime = [self.lrcTimeArray[i] integerValue];
                if (i == 0 && totalDuration*1.0*newValue < currentTime) {
                    self.tmpMark = 0;
                    break;
                } else {
                    if (i == self.lrcTimeArray.count-1) {
                        self.tmpMark = i;
                        break;
                    } else {
                        NSInteger nextTime =  [self.lrcTimeArray[i+1] integerValue];
                        if (totalDuration*1.0*newValue >= currentTime && totalDuration*1.0*newValue < nextTime) {
                            self.tmpMark = i;
                            break;
                        }
                    }
                }
            }
            if (self.isRecorded) {
                NSString *path = self.finalPath;
                [RecoderClass playFinalVoiceWithURL:[NSURL fileURLWithPath:path]];
                [RecoderClass setPlayerCurrentTime:totalDuration*1.0*newValue];
                [RecoderClass beginPlay];
            }
            [self.customProgressView.playBtn setSelected:NO];
            
            [self.player play];
            
            self.isPlaying = YES;
        }];
    }
}
//dwarfdump --arch=arm64 --lookup 0x100213798 /Users/axg/GIT/CreateSongs.app.dSYM/Contents/Resources/DWARF/CreateSongs

- (void)createLyric {
    [super createLyric];
    self.navRightButton.hidden = YES;
}

- (void)beforeRecoder:(UIButton *)sender {
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.minVolume = 0.6f;
    self.isRecorded = YES;
    [self pause];
//    [UIView animateWithDuration:0.8 animations:^{
//        self.navRightButton.alpha = 0.0f;
//    } completion:^(BOOL finished) {
        self.navRightButton.hidden = YES;
//    }];
    [self.customProgressView changeToProgressType:RecordingType];
    [self performSelector:@selector(beginRecoder:) withObject:sender afterDelay:0];
}



@end
