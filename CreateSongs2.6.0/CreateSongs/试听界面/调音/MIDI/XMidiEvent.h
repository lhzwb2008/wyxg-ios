//
//  Created by Lugia on 15/3/13.
//  Copyright (c) 2015年 Freedom. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>
#import "XFunction.h"
#import "XMidiNoteMessage.h"
#import "XOpenAL.h"
#import "XMidiSequence.h"

@class XMidiSequence;
@class XMidiNoteMessage;
@class XOpenAL;

@interface XMidiEvent : NSObject
@property (nonatomic) MusicTimeStamp timeStamp;//出现时间
@property (nonatomic) MusicEventType type;
@property (nonatomic) NSData* data;
@property (nonatomic) BOOL isPlayed;
@property (nonatomic) int bpm;
@property (nonatomic) XMidiNoteMessage* noteMessage;
@property (nonatomic, assign) float height;

-(id)init:(MusicTimeStamp)timeStamp type:(MusicEventType)type data:(NSData*)data;
-(void)playEvent;

+(float)getTempoBpmInTimeStamp:(float)timeStamp;

/**
 *  播放指定类型 指定信息的音调
 *
 *  @param message 音符信息
 *  @param type    乐器种类
 */
- (void)playSoundByNote:(XMidiNoteMessage *)message byInstrumentType:(int)type;

@end
