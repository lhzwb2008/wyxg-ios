//
//  SuperpowerManager.m
//  AXGSuperpower
//
//  Created by axg on 16/8/29.
//  Copyright © 2016年 axg. All rights reserved.
//

#import "SuperpowerManager.h"
#import "SuperpoweredAdvancedAudioPlayer.h"
#import "SuperpoweredIOSAudioIO.h"
#import "SuperpoweredSimple.h"
#import "SuperpoweredRecorder.h"
#import "SuperpoweredFilter.h"
#import "SuperpoweredRoll.h"
#import "SuperpoweredFlanger.h"
#import "SuperpoweredEcho.h"
#import "SuperpoweredReverb.h"
#import "Superpowered3BandEQ.h"
#import "SuperpoweredDecoder.h"
#import "SuperpoweredCompressor.h"
#import "SuperpoweredGate.h"
#import "SuperpoweredLimiter.h"
#import "SuperpoweredWhoosh.h"
#import <mach/mach_time.h>
#import "lame.h"
#import "AXGHeader.h"
#import "SuperpoweredMixer.h"

#define HEADROOM_DECIBEL 3.0f
static const float headroom = powf(10.0f, -HEADROOM_DECIBEL * 0.025);

@interface SuperpowerManager () {
    
    unsigned int lastPositionSeconds, lastSamplerate, samplesProcessed;
    uint64_t timeUnitsProcessed, maxTime;
    /**
     *  播放器
     */
    SuperpoweredAdvancedAudioPlayer *player, *playerA, *playerB;
    
    SuperpoweredIOSAudioIO *singerOutput;
    unsigned int lastSamplerate1;
    
    SuperpoweredIOSAudioIO *output;
    unsigned int lastSamplerate2;
    
    SuperpoweredIOSAudioIO *recoderOutput;
    
    float *stereoBuffer, volA, volB;
    
    BOOL isSingerVoice;
    
    SuperpoweredFX *effects[NUMFXUNITS];
    
    BOOL isPlayToEnd;
    
    BOOL isDealloced;
}

@end
@implementation SuperpowerManager

#pragma mark - Play_Method



- (instancetype)init {
    self = [super init];
    if (self) {
        isDealloced = NO;
        lastPositionSeconds = lastSamplerate = samplesProcessed = timeUnitsProcessed = maxTime = avgUnitsPerSecond = maxUnitsPerSecond = 0;
        if (posix_memalign((void **)&stereoBuffer, 16, 4096 + 128) != 0) abort(); // Allocating memory
        player = new SuperpoweredAdvancedAudioPlayer(NULL, NULL, 44100, 0);
        player->setBpm(124.0f);
        
        
        playerA = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallbackA, 44100, 0);
        playerB = new SuperpoweredAdvancedAudioPlayer((__bridge void *)self, playerEventCallbackB, 44100, 0);
        
//        singerOutput = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:(id<SuperpoweredIOSAudioIODelegate>)self preferredBufferSize:12 preferredMinimumSamplerate:44100 audioSessionCategory:AVAudioSessionCategoryPlayback channels:2 audioProcessingCallback:singerAudioProcessing clientdata:(__bridge void *)self];
//        [singerOutput start];
        
        playerA->syncMode = playerB->syncMode = SuperpoweredAdvancedAudioPlayerSyncMode_TempoAndBeat;
        
        output = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:(id<SuperpoweredIOSAudioIODelegate>)self preferredBufferSize:12 preferredMinimumSamplerate:44100 audioSessionCategory:AVAudioSessionCategoryPlayback channels:2 audioProcessingCallback:audioProcessing clientdata:(__bridge void *)self];
        [output start];
    }
    return self;
}

- (void)playVoice:(NSString *)voiceUrl {
    isSingerVoice = YES;
    
    const char *url = [voiceUrl UTF8String];
   
    player->open(url);
}

- (void)playDoubleVoice:(NSString *)voiceUrl otherUrl:(NSString *)secondUrl {
    isSingerVoice = NO;
    volA = 0.5f;
    volB = 0.5f;

    const char *url1 = [voiceUrl UTF8String];
    const char *url2 = [secondUrl UTF8String];
    
   
    playerA->open(url1);

    playerB->open(url2);
}

- (void)play {
    isPlayToEnd = NO;
    if (isSingerVoice) {
        player->play(false);
    } else {
        playerA->play(false);
        playerB->play(false);
    }
}

- (void)pause {
    if (isSingerVoice) {
        player->pause();
    } else {
        playerA->pause();
        playerB->pause();
    }
}

- (void)seekTo:(float)percent {
    if (isSingerVoice) {
        player->seek(percent);
    } else {
        playerA->seek(percent);
        playerB->seek(percent);
    }
}

- (void)setFirstVolume:(float)volume {
    volA = volume;
}

- (void)setSecondVolume:(float)volume {
    volB = volume;
}

- (void)changeFilterEnable:(NSInteger)index enable:(bool)enable{
    self->effects[index]->enable(enable);
}

- (void)updateProgress:(PlayViewCustomProgress *)progressView{
    bool tracking = progressView.sliderView.tracking;
    unsigned int positionSeconds;
    int currentTime = 0, totalTime = 0;
    if (isSingerVoice) {
        positionSeconds = tracking ? int(float(player->durationSeconds) * progressView.sliderView.value) : player->positionSeconds;
        
        if (positionSeconds != lastPositionSeconds) {
            lastPositionSeconds = positionSeconds;
            progressView.totalTime.text = [NSString stringWithFormat:@"%02d:%02d", player->durationSeconds / 60, player->durationSeconds % 60];
            progressView.currentTime.text = [NSString stringWithFormat:@"%02d:%02d", positionSeconds / 60, positionSeconds % 60];
            UIButton *button = progressView.playBtn;
            if (!button.tracking && (button.selected != player->playing)) button.selected = !player->playing;
            if (!tracking && (progressView.sliderView.value != player->positionPercent)) progressView.sliderView.value = player->positionPercent;
            currentTime = positionSeconds;
            totalTime = player->durationSeconds;
            
            if (self.progress_change) {
                self.progress_change(currentTime, totalTime);
            }
        }
        if (player->durationSeconds == positionSeconds) {
            isPlayToEnd = YES;
        }
        if (positionSeconds == 0 && isPlayToEnd && self.pause_block) {
            self.pause_block();
        }
    } else {
        positionSeconds = tracking ? int(float(playerA->durationSeconds) * progressView.sliderView.value) : playerA->positionSeconds;
        
        if (positionSeconds != lastPositionSeconds) {
            
            lastPositionSeconds = positionSeconds;
            progressView.totalTime.text = [NSString stringWithFormat:@"%02d:%02d", playerA->durationSeconds / 60, playerA->durationSeconds % 60];
            progressView.currentTime.text = [NSString stringWithFormat:@"%02d:%02d", positionSeconds / 60, positionSeconds % 60];
            UIButton *button = progressView.playBtn;
            if (!button.tracking && (button.selected != playerA->playing)) button.selected = !playerA->playing;
            if (!tracking && (progressView.sliderView.value != playerA->positionPercent)) progressView.sliderView.value = playerA->positionPercent;
            currentTime = positionSeconds;
            totalTime = playerA->durationSeconds;
            
            if (self.progress_change) {
                self.progress_change(currentTime, totalTime);
            }
        }
        if (playerA->durationSeconds == positionSeconds) {
            isPlayToEnd = YES;
        }
        if (positionSeconds == 0 && isPlayToEnd && self.pause_block) {
            self.pause_block();
        }
    }
    
}

#pragma mark - Recoder_Method

- (void)recoderToFile:(NSString *)recoderFile {
    FILE *fd = createWAV([recoderFile fileSystemRepresentation], 44100, 2);
    NSString *destinationPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SuperpoweredOfflineTest.wav"];
    SuperpoweredRecorder *recoder = new SuperpoweredRecorder([destinationPath fileSystemRepresentation], 44100);
    recoder->start([recoderFile fileSystemRepresentation]);
    
    recoderOutput = [[SuperpoweredIOSAudioIO alloc] initWithDelegate:(id<SuperpoweredIOSAudioIODelegate>)self preferredBufferSize:12 preferredMinimumSamplerate:44100 audioSessionCategory:AVAudioSessionCategoryRecord channels:2 audioProcessingCallback:audioProcessing clientdata:(__bridge void *)self];
    [recoderOutput start];
}

#pragma mark - Filter声音滤镜

- (void)initFilter {
    
    //鬼畜重复
    effects[ROLLINDEX] = new SuperpoweredRoll(44100);
    //滤镜
    SuperpoweredFilter *filter = new SuperpoweredFilter(SuperpoweredFilter_Resonant_Lowpass, 44100);
    filter->setResonantParameters(1000.0f, 0.1f);//共振  共振频率
    effects[FILTERINDEX] = filter;
    //三波段均衡器
    Superpowered3BandEQ *eq = new Superpowered3BandEQ(44100);
    eq->bands[0] = 2.0f;
    eq->bands[1] = 0.5f;
    eq->bands[2] = 2.0f;
    effects[EQINDEX] = eq;
    //弗兰格效果
    effects[FLANGERINDEX] = new SuperpoweredFlanger(44100);
    //回声
    SuperpoweredEcho *delay = new SuperpoweredEcho(44100);
    delay->setMix(0.8f);
    effects[DELAYINDEX] = delay;
    //混响
    SuperpoweredReverb *reverb = new SuperpoweredReverb(44100);
    reverb->setRoomSize(0.5f);
    reverb->setMix(0.3f);
    effects[REVERBINDEX] = reverb;
    //压缩
    SuperpoweredCompressor *pressor = new SuperpoweredCompressor(44100);
    /*
     float inputGainDb;
     float outputGainDb;
     float wet;
     float attackSec;   起始缓冲
     float releaseSec;  结束缓冲
     float ratio;       比率
     float thresholdDb; 作用阈值
     float hpCutOffHz;
     */
    pressor->thresholdDb = -23;
    pressor->ratio = 2.0f;
    pressor->attackSec = 0.1f;
    pressor->releaseSec = 70;
    effects[COMPRESSOR] = pressor;
    //门限
    SuperpoweredGate *gate = new SuperpoweredGate(44100);
    effects[GATE] = gate;
    //限幅器
    SuperpoweredLimiter *limiter = new SuperpoweredLimiter(44100);
    effects[LIMITER] = limiter;
    //嘶嘶声效
    SuperpoweredWhoosh *whoosh = new SuperpoweredWhoosh(44100);
    whoosh->setFrequency(50);
    effects[WHOSSH] = whoosh;
    
    
//    effects[REVERBINDEX]->enable(true);
}

- (void)mixAndAddFilterToFile:(NSArray *)paths{
    NSString *path1 = paths[0];
    NSString *path2 = paths[1];
    
    const char *finalPath1 = [path1 UTF8String];
    const char *finalPath2 = [path2 UTF8String];
    
    SuperpoweredDecoder *decoder1 = new SuperpoweredDecoder();
    SuperpoweredDecoder *decoder2 = new SuperpoweredDecoder();
    
    const char *openError1 = decoder1->open(finalPath1, false, 0, 0);
    const char *openError2 = decoder2->open(finalPath2, false, 0, 0);
    
    if (openError1 || openError2) {
        NSLog(@"open error: %s %s", openError1, openError2);
        delete decoder1;
        delete decoder2;
        return;
    };
    
    NSArray *tmpArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *mp3FileName = @"SuperpoweredOfflineTest";
    mp3FileName = [mp3FileName stringByAppendingString:@".wav"];
    NSString *destinationPath = [[tmpArray objectAtIndex:0] stringByAppendingPathComponent:mp3FileName];
    FILE *fd = createWAV([destinationPath fileSystemRepresentation], decoder1->samplerate, 2);
    
    if (!fd) {
        NSLog(@"File creation error.");
        delete decoder1;
        delete decoder2;
        return;
    };
    
    short int *intBuffer1 = (short int *)malloc(decoder1->samplesPerFrame * 2 * sizeof(short int) + 16384);
    short int *intBuffer2 = (short int *)malloc(decoder1->samplesPerFrame * 2 * sizeof(short int) + 16384);
    
    short int *intBuffer = (short int *)malloc(decoder1->samplesPerFrame * 2 * sizeof(short int) + 16384);
    
    float *floatBuffer1 = (float *)malloc(decoder1->samplesPerFrame * 2 * sizeof(float) + 1024);
    float *floatBuffer2 = (float *)malloc(decoder1->samplesPerFrame * 2 * sizeof(float) + 1024);
    
    float *floatBuffer = (float *)malloc(decoder1->samplesPerFrame * 2 * sizeof(float) + 1024);
    
    SuperpoweredStereoMixer *mixer = new SuperpoweredStereoMixer();
    
    while (true) {
        unsigned int samplesDecoded = decoder1->samplesPerFrame;
        if (decoder1->decode(intBuffer1, &samplesDecoded) == SUPERPOWEREDDECODER_ERROR) break;
        if (decoder2->decode(intBuffer2, &samplesDecoded) == SUPERPOWEREDDECODER_ERROR) break;
        if (samplesDecoded < 1) break;
        
        SuperpoweredShortIntToFloat(intBuffer1, floatBuffer1, samplesDecoded);
        SuperpoweredShortIntToFloat(intBuffer2, floatBuffer2, samplesDecoded);
        
        float *inputBuffers[4] = {floatBuffer1, floatBuffer2};
        float *outputBuffers[2] = {floatBuffer};
        float inputLevels[8] = {volA, volA, volB, volB};
        float outputLevels[2] = {1.0, 1.0};
       
        mixer->process(inputBuffers, outputBuffers, inputLevels, outputLevels, NULL, NULL, samplesDecoded);
       
        // Apply the effect.
        self->effects[FILTERINDEX]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[ROLLINDEX]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[EQINDEX]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[FLANGERINDEX]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[DELAYINDEX]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[REVERBINDEX]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[COMPRESSOR]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[GATE]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[LIMITER]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[WHOSSH]->process(floatBuffer, floatBuffer, samplesDecoded);

        SuperpoweredFloatToShortInt(floatBuffer, intBuffer, samplesDecoded);
        
        fwrite(intBuffer, 1, samplesDecoded * 4, fd);
    };
    NSLog(@"The file is available in iTunes File Sharing, and locally at %@.", destinationPath);
    // Cleanup.
    closeWAV(fd);
    delete decoder1;
    delete decoder2;
    free(intBuffer);
    free(intBuffer1);
    free(intBuffer2);
    free(floatBuffer);
    free(floatBuffer1);
    free(floatBuffer2);
    
    
    [self changeToMp3:destinationPath toPath:nil];
}

- (void)addFilterToFile:(NSString *)path {
    const char *finalPath = [path UTF8String];
    SuperpoweredDecoder *decoder = new SuperpoweredDecoder();
    const char *openError = decoder->open(finalPath, false, 0, 0);
    if (openError) {
        NSLog(@"open error: %s", openError);
        delete decoder;
        return;
    };
    
//    NSString *destinationPath = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"SuperpoweredOfflineTest.wav"];
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *mp3FileName = @"SuperpoweredOfflineTest";
    mp3FileName = [mp3FileName stringByAppendingString:@".wav"];
    NSString *destinationPath = [[paths objectAtIndex:0] stringByAppendingPathComponent:mp3FileName];
    
    FILE *fd = createWAV([destinationPath fileSystemRepresentation], decoder->samplerate, 2);
    if (!fd) {
        NSLog(@"File creation error.");
        delete decoder;
        return;
    };

    short int *intBuffer = (short int *)malloc(decoder->samplesPerFrame * 2 * sizeof(short int) + 16384);
    float *floatBuffer = (float *)malloc(decoder->samplesPerFrame * 2 * sizeof(float) + 1024);
    
    while (true) {
        unsigned int samplesDecoded = decoder->samplesPerFrame;
        if (decoder->decode(intBuffer, &samplesDecoded) == SUPERPOWEREDDECODER_ERROR) break;
        if (samplesDecoded < 1) break;
        
        SuperpoweredShortIntToFloat(intBuffer, floatBuffer, samplesDecoded);
        
        // Apply the effect.
        self->effects[FILTERINDEX]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[ROLLINDEX]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[EQINDEX]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[FLANGERINDEX]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[DELAYINDEX]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[REVERBINDEX]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[COMPRESSOR]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[GATE]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[LIMITER]->process(floatBuffer, floatBuffer, samplesDecoded);
        self->effects[WHOSSH]->process(floatBuffer, floatBuffer, samplesDecoded);
        
        SuperpoweredFloatToShortInt(floatBuffer, intBuffer, samplesDecoded);
        
        fwrite(intBuffer, 1, samplesDecoded * 4, fd);
        
        progress = (double)decoder->samplePosition / (double)decoder->durationSamples;
    };
    
    // iTunes File Sharing: https://support.apple.com/en-gb/HT201301
    NSLog(@"The file is available in iTunes File Sharing, and locally at %@.", destinationPath);
    // Cleanup.
    closeWAV(fd);
    delete decoder;
    free(intBuffer);
    free(floatBuffer);
    
    [self changeToMp3:destinationPath toPath:path];
}

- (void)changeToMp3:(NSString *)path toPath:(NSString *)toPath{
    NSString *cafFilePath = path;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *mp3FileName = @"Filter_mp3";
    mp3FileName = [mp3FileName stringByAppendingString:@".mp3"];
    NSString *mp3FilePath = [[paths objectAtIndex:0] stringByAppendingPathComponent:mp3FileName];
    NSLog(@"mp3FilePath  -----  %@", mp3FilePath);
//    NSString *mp3FilePath = toPath;
    
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
        if (self.filter_done) {
            self.filter_done(mp3FilePath);
        }
    }
}

#pragma mark - CallBack_Method

static bool singerAudioProcessing(void *clientdata, float **buffers, unsigned int inputChannels, unsigned int outputChannels, unsigned int numberOfSamples, unsigned int samplerate, uint64_t hostTime) {
    __unsafe_unretained SuperpowerManager *self = (__bridge SuperpowerManager *)clientdata;
    
    uint64_t startTime = mach_absolute_time();
    
    if (samplerate != self->lastSamplerate1) {
        self->lastSamplerate1 = samplerate;
        self->player->setSamplerate(samplerate);
    }
    
    // CPU measurement code to show some nice numbers for the business guys.
    uint64_t elapsedUnits = mach_absolute_time() - startTime;
    if (elapsedUnits > self->maxTime) self->maxTime = elapsedUnits;
    self->timeUnitsProcessed += elapsedUnits;
    self->samplesProcessed += numberOfSamples;
    if (self->samplesProcessed >= samplerate) {
        self->avgUnitsPerSecond = self->timeUnitsProcessed;
        self->maxUnitsPerSecond = (double(samplerate) / double(numberOfSamples)) * self->maxTime;
        self->samplesProcessed = self->timeUnitsProcessed = self->maxTime = 0;
    };
    
    
    bool silence = !self->player->process(self->stereoBuffer, false, numberOfSamples, 1.0f, 0.0f, -1.0);
    
    
    if(self->effects[ROLLINDEX]->process(silence ? NULL : self->stereoBuffer, self->stereoBuffer, numberOfSamples)) silence = false;
    self->effects[FILTERINDEX]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    self->effects[EQINDEX]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    self->effects[FLANGERINDEX]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    if(self->effects[DELAYINDEX]->process(silence ? NULL : self->stereoBuffer, self->stereoBuffer, numberOfSamples))silence = false;
    if(self->effects[REVERBINDEX]->process(silence ? NULL : self->stereoBuffer, self->stereoBuffer, numberOfSamples))silence = false;
    self->effects[COMPRESSOR]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    self->effects[GATE]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    self->effects[LIMITER]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    self->effects[WHOSSH]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    

    
    
    if (!silence) SuperpoweredDeInterleave(self->stereoBuffer, buffers[0], buffers[1], numberOfSamples);
    return !silence;
}

static bool audioProcessing(void *clientdata, float **buffers, unsigned int inputChannels, unsigned int outputChannels, unsigned int numberOfSamples, unsigned int samplerate, uint64_t hostTime) {
    
    
    
    __unsafe_unretained SuperpowerManager *self = (__bridge SuperpowerManager *)clientdata;
    uint64_t startTime = mach_absolute_time();
    if (samplerate != self->lastSamplerate2) { // Has samplerate changed?
        self->lastSamplerate2 = samplerate;
        self->playerA->setSamplerate(samplerate);
        self->playerB->setSamplerate(samplerate);
    };
    float masterBpm = self->playerA->currentBpm;
    double msElapsedSinceLastBeatA = self->playerA->msElapsedSinceLastBeat;
    
    // CPU measurement code to show some nice numbers for the business guys.
    uint64_t elapsedUnits = mach_absolute_time() - startTime;
    if (elapsedUnits > self->maxTime) self->maxTime = elapsedUnits;
    self->timeUnitsProcessed += elapsedUnits;
    self->samplesProcessed += numberOfSamples;
    if (self->samplesProcessed >= samplerate) {
        self->avgUnitsPerSecond = self->timeUnitsProcessed;
        self->maxUnitsPerSecond = (double(samplerate) / double(numberOfSamples)) * self->maxTime;
        self->samplesProcessed = self->timeUnitsProcessed = self->maxTime = 0;
    };
    
    
    bool silence = !self->playerA->process(self->stereoBuffer, false, numberOfSamples, self->volA, masterBpm, self->playerB->msElapsedSinceLastBeat);
    
    
    
    if(self->effects[ROLLINDEX]->process(silence ? NULL : self->stereoBuffer, self->stereoBuffer, numberOfSamples)) silence = false;
    self->effects[FILTERINDEX]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    self->effects[EQINDEX]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    self->effects[FLANGERINDEX]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    if(self->effects[DELAYINDEX]->process(silence ? NULL : self->stereoBuffer, self->stereoBuffer, numberOfSamples))silence = false;
    if(self->effects[REVERBINDEX]->process(silence ? NULL : self->stereoBuffer, self->stereoBuffer, numberOfSamples))silence = false;
    self->effects[COMPRESSOR]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    self->effects[GATE]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    self->effects[LIMITER]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);
    self->effects[WHOSSH]->process(self->stereoBuffer, self->stereoBuffer, numberOfSamples);

    
    /**
     *  这里讲播放器写入缓冲区的位置放到效果前边，这个播放器不会加效果
     */
    if (self->playerB->process(self->stereoBuffer, !silence, numberOfSamples, self->volB, masterBpm, msElapsedSinceLastBeatA)) silence = false;
    
    if (!silence) SuperpoweredDeInterleave(self->stereoBuffer, buffers[0], buffers[1], numberOfSamples);
   
    return !silence;
}

void playerEventCallback(void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
    if (event == SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess) {
        SuperpowerManager *self = (__bridge SuperpowerManager *)clientData;
        self->player->setBpm(126.0f);
        self->player->setFirstBeatMs(353);
        self->player->setPosition(self->player->firstBeatMs, false, false);
    };
}
void playerEventCallbackA(void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
    switch (event) {
        case SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess: {
            SuperpowerManager *self = (__bridge SuperpowerManager *)clientData;
            self->playerA->setBpm(126.0f);
            self->playerA->setFirstBeatMs(10);
            self->playerA->setPosition(self->playerA->firstBeatMs, false, false);
        }
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_LoopEnd: {
            NSLog(@"endB");
        }
            break;
        default:
            break;
    };
}
void playerEventCallbackB(void *clientData, SuperpoweredAdvancedAudioPlayerEvent event, void *value) {
    switch (event) {
        case SuperpoweredAdvancedAudioPlayerEvent_LoadSuccess: {
            SuperpowerManager *self = (__bridge SuperpowerManager *)clientData;
            self->playerB->setBpm(126.0f);
            self->playerB->setFirstBeatMs(10);
            self->playerB->setPosition(self->playerA->firstBeatMs, false, false);
        }
            break;
        case SuperpoweredAdvancedAudioPlayerEvent_LoopEnd: {
            NSLog(@"endB");
        }
            break;
        default:
            break;
    };
}

#pragma mark - SuperpoweredIOSAudioIODelegate

- (void)interruptionStarted {}
- (void)recordPermissionRefused {}
- (void)mapChannels:(multiOutputChannelMap *)outputMap inputMap:(multiInputChannelMap *)inputMap externalAudioDeviceName:(NSString *)externalAudioDeviceName outputsAndInputs:(NSString *)outputsAndInputs {}
- (void)interruptionEnded {
    if (isSingerVoice) {
        player->onMediaserverInterrupt();
    } else {
        playerA->onMediaserverInterrupt();
        playerB->onMediaserverInterrupt();
    }
}

- (void)closeSuperPower {
    if (isDealloced) {
        return;
    }
    [singerOutput stop];
    [recoderOutput stop];
    [output stop];
    delete player;
    delete playerA;
    delete playerB;
    free(stereoBuffer);
    for (int n = 2; n < NUMFXUNITS; n++) delete effects[n];
}

- (void)dealloc {
    isDealloced = YES;
    [singerOutput stop];
    [recoderOutput stop];
    [output stop];
    delete player;
    delete playerA;
    delete playerB;
    free(stereoBuffer);
    for (int n = 2; n < NUMFXUNITS; n++) delete effects[n];
}

@end
