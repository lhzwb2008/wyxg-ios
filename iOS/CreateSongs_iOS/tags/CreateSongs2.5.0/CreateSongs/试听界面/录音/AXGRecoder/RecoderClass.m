//
//  RecoderClass.m
//  CreateSongs
//
//  Created by axg on 16/7/6.
//  Copyright © 2016年 AXG. All rights reserved.
//


#import "RecoderClass.h"
#import "AXGHeader.h"
#import "AEAudioFilePlayer.h"
#import "AppDelegate.h"
#import "AERecorder.h"
#import "AEPlaythroughChannel.h"
#import <AVFoundation/AVFoundation.h>
#import "TYCache.h"

@interface RecoderClass () {
    AEChannelGroupRef _group;
}

@property (nonatomic, strong) AEAudioFilePlayer *player;
@property (nonatomic, strong) AEAudioFilePlayer *loop;
@property (nonatomic, strong) NSURL *songPathURL;
@property (nonatomic, strong) AEPlaythroughChannel *playThrough;

@end

@implementation RecoderClass

XLSingletonM(RecoderClass);

- (instancetype)init {
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(earPod) name:@"earPod" object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(noneEarPod) name:@"noneEarPod" object:nil];
        
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        self.audioController = app.audioController;
        
//        self.audioController1 = [app.audioController copy];
    }
    return self;
}


#pragma mark - classMethod

+ (void)playFinalVoiceWithURL:(NSURL *)songURL {
    RecoderClass *recoder = [RecoderClass sharedRecoderClass];
    [recoder playFinalSongURL:songURL];
}

+ (void)playVoiceWithURL:(NSURL *)songURL {
    RecoderClass *recoder = [RecoderClass sharedRecoderClass];
    [recoder playWithSongURL:songURL];
}

+ (void)setPlayerCurrentTime:(float)currentTime {
    RecoderClass *recoder = [RecoderClass sharedRecoderClass];
    [recoder setplayerCurrentTime:currentTime];
}

+ (void)setPlayerVolume:(float)volume {
    RecoderClass *recoder = [RecoderClass sharedRecoderClass];
    [recoder setPlayerVolume:volume];
}


+ (void)pausePlay {
    RecoderClass *recoder = [RecoderClass sharedRecoderClass];
    [recoder pausePlay];
}

+ (void)beginPlay {
    RecoderClass *recoder = [RecoderClass sharedRecoderClass];
    [recoder beginPlay];
}

+ (void)pauseRecorder {
    RecoderClass *recoder = [RecoderClass sharedRecoderClass];
    [recoder pauserRecorder];
}

+ (void)beginRecorder {
    RecoderClass *recoder = [RecoderClass sharedRecoderClass];
    [recoder beginRecoreder];
}

+ (void)turnOffRecorder {
    RecoderClass *recoder = [RecoderClass sharedRecoderClass];
    [recoder turnOffRecorder];
}

+ (void)turnOnRecorder {
    RecoderClass *recoder = [RecoderClass sharedRecoderClass];
    [recoder turnOnRecorder];
}


#pragma mark - Method

- (void)playFinalSongURL:(NSURL *)songPathURL {
    if (self.player) {
        [self.audioController removeChannels:@[self.player]];
        self.player = nil;
    }
    NSError *error = nil;
    self.player = [AEAudioFilePlayer audioFilePlayerWithURL:songPathURL error:&error];
    if ( !_player ) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Couldn't start playback: %@", [error localizedDescription]]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        return;
    }
    self.player.removeUponFinish = YES;
    WEAK_SELF;
    self.player.completionBlock = ^{
        STRONG_SELF;
        self.player = nil;
    };
    [self.audioController addChannels:@[self.player]];
}

- (void)playWithSongURL:(NSURL *)songPathURL {
    NSMutableArray *channelsToRemove = [NSMutableArray arrayWithObjects:self.loop, nil];
    
    if (_player) {
        [channelsToRemove addObject:_player];
        self.player = nil;
    }
    if (self.loop) {
        self.loop = nil;
        [_audioController removeChannels:channelsToRemove];
        [_audioController removeChannelGroup:_group];
        _group = NULL;
    }
    
    if (_audioController) {
        self.loop = [AEAudioFilePlayer audioFilePlayerWithURL:songPathURL error:NULL];
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        self.loop.volume = app.minVolume;
        self.loop.channelIsMuted = YES;
        self.loop.loop = NO;
        _group = [self.audioController createChannelGroup];
        [_audioController addChannels:@[self.loop] toChannelGroup:_group];
    }
    
    self.loop.channelIsMuted = NO;
    
}

- (void)setplayerCurrentTime:(float)currentTime {
    self.loop.currentTime = currentTime;
}

- (void)setPlayerVolume:(float)volume {
    self.loop.volume = volume;
}


- (void)pausePlay {
    self.player.channelIsMuted = YES;
    self.player.channelIsPlaying = NO;
    self.loop.channelIsMuted = YES;
    self.loop.channelIsPlaying = NO;
}

- (void)beginPlay {
    self.player.channelIsMuted = NO;
    self.player.channelIsPlaying = YES;
    self.loop.channelIsMuted = NO;
    self.loop.channelIsPlaying = YES;
}

- (BOOL)isHeadsetPluggedIn {
    AVAudioSessionRouteDescription* route = [[AVAudioSession sharedInstance] currentRoute];
    for (AVAudioSessionPortDescription* desc in [route outputs]) {
        if ([[desc portType] isEqualToString:AVAudioSessionPortHeadphones])
            return YES;
    }
    return NO;
}

- (NSMutableData *)recorderData {
    if (_recorderData == nil) {
        _recorderData = [NSMutableData data];
    }
    return _recorderData;
}

- (void)pauserRecorder {
    self.recorder.recording = NO;
//    self.recorder1.recording = NO;
}

- (void)beginRecoreder {
    self.recorder.recording = YES;
//    self.recorder1.recording = YES;
}

- (void)turnOffRecorder {
    self.recorder.recording = NO;
    [self turnOffVoice];
    [self.recorder finishRecording];
    [self.audioController removeInputReceiver:_recorder];
    [self.audioController removeOutputReceiver:_recorder];
    self.recorder = nil;
    
//    [self.recorder1 finishRecording];
//    [self.audioController removeInputReceiver:_recorder1];
//    [self.audioController removeOutputReceiver:_recorder1];
//    self.recorder1 = nil;
}

- (void)turnOnRecorder {
    NSArray *documentsFolders = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:@"Recodering.wav"];
//    NSString *path1 = [[documentsFolders objectAtIndex:0] stringByAppendingPathComponent:@"Recodering1.wav"];
    NSLog(@"录音路径%@", path);
    if ([self isHeadsetPluggedIn]) {
        self.loop.volume = 1.0f;
        [self turnOnVoice];
    } else {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        self.loop.volume = app.minVolume;
        [self turnOffVoice];
    }
    self.recorder = [[AERecorder alloc] initWithAudioController:self.audioController];
//    self.recorder1 = [[AERecorder alloc] initWithAudioController:self.audioController];
    
//    NSError *error1 = nil;
//    if (![_recorder beginRecordingToFileAtPath:path1 fileType:kAudioFileWAVEType error:&error1]) {
//        self.recorder1 = nil;
//        return;
//    }
//    [self.audioController addOutputReceiver:_recorder1];
//    self.recorder1.recording = YES;
    
    NSError *error = nil;//kAudioFileMP3Type   kAudioFileAIFFType
    if ( ![_recorder beginRecordingToFileAtPath:path fileType:kAudioFileWAVEType error:&error] ) {
        [[[UIAlertView alloc] initWithTitle:@"Error"
                                    message:[NSString stringWithFormat:@"Couldn't start recording: %@", [error localizedDescription]]
                                   delegate:nil
                          cancelButtonTitle:nil
                          otherButtonTitles:@"OK", nil] show];
        self.recorder = nil;
        return;
    }
//    [self.audioController addOutputReceiver:_recorder];
    [self.audioController addInputReceiver:_recorder];
    self.recorder.recording = YES;
}

#pragma mark - setter

- (void)setIsPlaying:(BOOL)isPlaying {
    _isPlaying = isPlaying;
    self.loop.channelIsPlaying = _isPlaying;
}

- (void)setIsMuted:(BOOL)isMuted {
    _isMuted = isMuted;
    self.loop.channelIsMuted = _isMuted;
}

#pragma mark - 根据耳机插入开关录音回声

- (void)noneEarPod {
    if (!self.shouldChangeEar) {
        [self turnOffVoice];
    } else {
        AppDelegate *app = [[UIApplication sharedApplication] delegate];
        self.loop.volume = app.minVolume;
        [self turnOffVoice];
    }
}

- (void)earPod {
    if (!self.shouldChangeEar) {
        [self turnOffVoice];
    } else {
        self.loop.volume = 1.0f;
        [self turnOnVoice];
    }
}

// 开关实时播放录音
- (void)turnOnVoice {
    self.playThrough = [[AEPlaythroughChannel alloc] initWithAudioController:_audioController];
    [_audioController addInputReceiver:_playThrough];
    [_audioController addChannels:[NSArray arrayWithObject:_playThrough]];
}

- (void)turnOffVoice {
    if (self.playThrough == nil) {
        return;
    }
    [_audioController removeChannels:[NSArray arrayWithObject:_playThrough]];
    [_audioController removeInputReceiver:_playThrough];
    self.playThrough = nil;
}

@end
