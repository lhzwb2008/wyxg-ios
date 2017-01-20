//
//  SuperpowerManager.h
//  AXGSuperpower
//
//  Created by axg on 16/8/29.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayViewCustomProgress.h"

#define NUMFXUNITS 12
#define TIMEPITCHINDEX 0
#define PITCHSHIFTINDEX 1
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

typedef void(^PLAY_Block)();
typedef void(^PAUSE_Block)();
typedef void(^FILTER_DONE)(NSString *finalPath);//加过滤镜的wav文件
typedef void(^PROGRESS_CHANGE)(int currentTime, int totalTime);

@interface SuperpowerManager : NSObject {
@public
    float progress;
    bool playing;
    uint64_t avgUnitsPerSecond, maxUnitsPerSecond;
}

@property (nonatomic, copy) PLAY_Block play_block;//
@property (nonatomic, copy) PAUSE_Block pause_block;// 播放结束暂停方法
@property (nonatomic, copy) FILTER_DONE filter_done;//文件增加滤镜完成
@property (nonatomic, copy) PROGRESS_CHANGE progress_change;



#pragma mark - playVoice

- (void)playVoice:(NSString *)voiceUrl;

- (void)playDoubleVoice:(NSString *)voiceUrl otherUrl:(NSString *)secondUrl;

- (void)play;
- (void)pause;
- (void)seekTo:(float)percent;

- (void)setFirstVolume:(float)volume;
- (void)setSecondVolume:(float)volume;

- (void)updateProgress:(PlayViewCustomProgress *)progressView;

#pragma mark - Recoder

- (void)recoderToFile:(NSString *)recoderFile;
/**
 *  初始化滤镜
 */
- (void)initFilter;

- (void)changeFilterEnable:(NSInteger)index enable:(bool)enable;
/**
 *  将滤镜效果应用到目标声音文件
 *
 *  @param path 声音文件路径
 */
- (void)addFilterToFile:(NSString *)path;

- (void)mixAndAddFilterToFile:(NSArray *)paths;

#pragma mark - close

- (void)closeSuperPower;
@end
