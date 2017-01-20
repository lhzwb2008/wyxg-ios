//
//  RecoderClass.h
//  CreateSongs
//
//  Created by axg on 16/7/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class AERecorder;
@interface RecoderClass : NSObject

@property (nonatomic, assign) BOOL isPlaying;
@property (nonatomic, assign) BOOL isMuted;

@property (nonatomic, strong) AERecorder *recorder;
@property (nonatomic, strong) NSMutableData *recorderData;

@property (nonatomic, assign) BOOL shouldChangeEar;

+ (instancetype)sharedRecoderClass;
/**
 *  播放指定路径的歌曲文件
 *
 *  @param songURL 歌曲路径
 */
+ (void)playVoiceWithURL:(NSURL *)songURL;

+ (void)setPlayerVolume:(float)volume;

+ (void)setPlayerCurrentTime:(float)currentTime;

+ (void)pausePlay;

+ (void)beginPlay;

+ (void)pauseRecorder;

+ (void)beginRecorder;

+ (void)turnOffRecorder;

+ (void)turnOnRecorder;



@end
