//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import "XMidiPlayer.h"
#import "AXGHeader.h"
#import "TYHeader.h"
#import "TYCommonClass.h"


@implementation XMidiPlayer
double currentMusitTime;

BOOL isPaused;
BOOL isPlayTimerEnabled;
double playTimeStamp;
double lastUpdateTime;

XLSingletonM(XMidiPlayer);

+(void)xInit{
    
    [XOpenALPlayer xInit];
    [XOpenAL xInit];
    [XMusicalInstrumentsManager xInit];
}

- (void)becomeActive {
    [XOpenAL backGround];
    [XOpenAL active];
}

- (void)becomeBackGround {
    [XOpenAL backGround];
}
//处理中断事件
-(void)handleInterreption:(NSNotification *)sender
{
    //    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    //    [XMidiPlayer xInit];
    //    app.deviceIsReady = YES;
    [XOpenAL backGround];
    NSLog(@"%@", sender);
    NSLog(@"接到电话");
}


+(void)xDispose{
    [XOpenALPlayer xDispose];
    [XOpenAL xDispose];
    [XMusicalInstrumentsManager xDispose];
}

-(id)init{
    if(self = [super init]){
        isPlayTimerEnabled = true;
        [self playTimer];
    }
    return self;
}

- (void)initMidi:(NSURL*)midiUrl{
    isPaused = true;
    currentMusitTime = 0;
    playTimeStamp = 0;
    self.currentBpm = 100;
    _midiSequence = [[XMidiSequence alloc] init:midiUrl];
}

-(void)initMidiWithData:(NSData*)data{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeActive) name:@"applicationActive" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(becomeBackGround) name:@"applicationBackGround" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleInterreption:) name:AVAudioSessionInterruptionNotification object:[AVAudioSession sharedInstance]];
    isPaused = true;
    currentMusitTime = 0;
    playTimeStamp = 0;
    self.currentBpm = 100;
    
    _midiSequence = [[XMidiSequence alloc] initWithData:data];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationActive" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"applicationBackGround" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:AVAudioSessionInterruptionNotification object:nil];
}

-(void)closePlayer{
    isPlayTimerEnabled = false;
    isPaused = true;
    _midiSequence = NULL;
}

-(void)pause{
    isPaused = true;
}

-(void)play{
    static float a = 0.5f;
    self.height = a;
    isPaused = false;
    lastUpdateTime = [[NSDate date] timeIntervalSince1970];
}

-(void)replay{
    [self setProgress:0];
}

-(double)getProgress{
    return currentMusitTime / (_midiSequence.musicTotalTime);
}

- (double)getCurrentMusicTime {
    return currentMusitTime;
}

-(void)setProgress:(double)progress{
    if (_midiSequence == NULL){
        return;
    }
    
    if (_midiSequence.tracks.count <= 0){
        return;
    }
    
    isPaused = true;
    double p = progress;
    if (p < 0){
        p = 0;
    }
    
    if (p > 1){
        p = 1;
    }
    
    double maxTimeStamp = _midiSequence.musicTotalTime * p;
    currentMusitTime = 0;
    playTimeStamp = 0;
    while (currentMusitTime < maxTimeStamp) {
        double bpm = [XMidiEvent getTempoBpmInTimeStamp:playTimeStamp];
        playTimeStamp += 1 / 60.0 / 60.0 * bpm;
        currentMusitTime += 1 / 60.0;
    }

    //重置播放标示
    for (int i = 0; i< _midiSequence.tracks.count; i++) {
        XMidiTrack* track = _midiSequence.tracks[i];
        track.playEventIndex = 0;
        if (track.eventIterator.childEvents.count <= 0){
            continue;
        }
        for (int index = 0; index < track.eventIterator.childEvents.count; index ++) {
            XMidiEvent* event = track.eventIterator.childEvents[index];
            
            event.isPlayed = playTimeStamp >= event.timeStamp;
            if (event.isPlayed){
                track.playEventIndex = index;
            }
        }
    }
    isPaused = false;
}

-(void)playTimer
{
    double timeSinceLast = [[NSDate date] timeIntervalSince1970] - lastUpdateTime;
    lastUpdateTime = [[NSDate date] timeIntervalSince1970];
    
    double delayInSeconds = 1 / 60.0;
    if (!isPaused && currentMusitTime < _midiSequence.musicTotalTime){
        //按bpm速率播放
        self.currentBpm = [XMidiEvent getTempoBpmInTimeStamp:playTimeStamp];
        playTimeStamp += timeSinceLast / 60.0 * self.currentBpm;
        currentMusitTime += timeSinceLast;
        if (currentMusitTime > _midiSequence.musicTotalTime){
            currentMusitTime = _midiSequence.musicTotalTime;
        }
//        NSLog(@"%f", [self getProgress]);
        [self playSound];
        if (self.delegate != nil
            && [self.delegate respondsToSelector:@selector(progressChanged:noteMessage:)]) {
            [self.delegate progressChanged:[self getProgress] noteMessage:self.noteMessage];
        }
    }
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, (int64_t)(delayInSeconds * NSEC_PER_SEC));
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        if (isPlayTimerEnabled){
            [self playTimer];
        }
    });
}

-(void)playSound{
    if (_midiSequence == NULL){
        return;
    }
    
    if (_midiSequence.tracks.count <= 0){
        return;
    }
    
    for (int i = 0; i<_midiSequence.tracks.count; i++) {
        XMidiTrack* track = _midiSequence.tracks[i];
        for (int index = track.playEventIndex; index<track.playEventIndex + 10; index++) {
            if (index < track.playEventIndex || index >= track.eventIterator.childEvents.count){
                continue;
            }
            
            XMidiEvent* event = track.eventIterator.childEvents[index];
            if (playTimeStamp >= event.timeStamp && !event.isPlayed){
                track.playEventIndex = index;
//                NSLog(@"当前播放下标为--%d", index);
                [[NSNotificationCenter defaultCenter] postNotificationName:CURRENT_PLAY_NOTE object:nil userInfo:@{@"currentIndex":[NSString stringWithFormat:@"%d", index]}];
                event.height = self.height;
                self.noteMessage = event.noteMessage;
                
                [event playEvent];
            }
        }
    }
}

- (void)playSoundByNote:(XMidiNoteMessage *)message byInstrumentType:(int)type event:(XMidiEvent *)event{
    [event playSoundByNote:message byInstrumentType:type];
}
@end