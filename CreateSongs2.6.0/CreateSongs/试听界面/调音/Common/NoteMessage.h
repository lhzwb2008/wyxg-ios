//
//  NoteMessage.h
//  MidiPlayDemo
//
//  Created by axg on 16/3/10.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteMessage : NSObject

/**
 *  音符音高
 */
@property (nonatomic, assign) UInt32 notePitch1;
/**
 *  音符力度
 */
@property (nonatomic, assign) UInt32 velocity;
/**
 *  音符之间相差时长(和下一个音符的)
 */
@property (nonatomic, assign) UInt32 noteDeltaTime;
/**
 *  音符时长
 */
@property (nonatomic, assign) UInt32 deltaTime;
/**
 *  开始或者关闭标示
 */
@property (nonatomic, assign) UInt32 noteMark;


@property (nonatomic) UInt8 channel;
@property (nonatomic) UInt8 note;
@property (nonatomic) UInt8 releaseVelocity;	// was "reserved". 0 is the correct value when you don't know.
@property (nonatomic) Float32 duration;

@property (nonatomic) float panning;    // < 0 is left, 0 is center, > 0 is right


@end
