//
//  TYHeader.h
//  SentenceMidiChange
//
//  Created by axg on 16/5/9.
//  Copyright © 2016年 axg. All rights reserved.
//

#ifndef TYHeader_h
#define TYHeader_h

// 测试用 勿改
#define CHANGE_PITCH    0

#define TY_GUID_IsShow  @"tyGuidIsShow"

#define TY_YANYIN   @"～"

#define NOTE_COLOR [UIColor colorWithRed:72 / 255.0 green:226 / 255.0 blue:227 / 255.0 alpha:1]

#define TY_TITLE_COLOR  [UIColor colorWithHexString:@"#ffffff"]
#define TY_COMPLE_COLOR THEME_COLOR
#define TY_LINE_COLOR   [UIColor colorWithHexString:@"#262e36"]
#define TY_PITCH_NUMBER [UIColor colorWithHexString:@"#808080"]
#define TY_NOTE_TEXT    [UIColor colorWithHexString:@"#001122"]
#define TY_THUMB_COLOR  [UIColor colorWithHexString:@"#374553"]
#define TY_BOTTOM_COLOR [UIColor colorWithHexString:@"#0e1720"]
#define TY_TOP_BGCOLOR  [UIColor colorWithHexString:@"#0e1720"]
#define TY_NAVI_BGCOLOR [UIColor colorWithHexString:@"#161e27"]
#define TY_BG_TWOLight  [UIColor colorWithHexString:@"#131d27"]
/**
 *  weak strong self for retain cycle
 */
#define WEAK_SELF __weak typeof(self) weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf) self = weakSelf

#define PLAY_MIDI_NOTI  @"beginPlayMidiNoti"
#define COMPLET_NOTI    @"completeTyNoti"
#define MIX_MIDI_DONE   @"mixMidiDataDone"
#define MIX_DATA        @"mixMidiData"
#define STOP_PLAY_MID   @"stopPlayMidi"

#define SIX_TY_TYPE     @"sixTyType"
#define EIGHT_TY_TYPE   @"eightTyType"
#define TY_TYPE_CHANGE  @"tyTypeChange"
/**
 *  当前播放的音符下标
 */
#define CURRENT_PLAY_NOTE   @"currentPlayNote"

#define LOG_EXCEPTION   NSLog(@"发生异常%s\n%@\n%@\n%@", __func__, exception.name, exception.reason, exception.userInfo)
#define CHANNEL_NOTE_OFF        0x80
#define CHANNEL_NOTE_ON         0x90

#endif /* TYHeader_h */

/**
 *  单例
 */
#define XLSingletonM(name) \
static id _instance = nil; \
+ (id)allocWithZone:(struct _NSZone *)zone \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [super allocWithZone:zone]; \
}); \
return _instance; \
} \
+ (instancetype)shared##name \
{ \
static dispatch_once_t onceToken; \
dispatch_once(&onceToken, ^{ \
_instance = [[self alloc] init]; \
}); \
return _instance; \
} \
- (id)copyWithZone:(NSZone *)zone \
{ \
return _instance; \
}

