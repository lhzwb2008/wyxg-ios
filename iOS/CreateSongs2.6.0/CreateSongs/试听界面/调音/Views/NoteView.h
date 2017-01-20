//
//  NoteView.h
//  SentenceMidiChange
//
//  Created by axg on 16/5/9.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <UIKit/UIKit.h>
@class NoteView;
typedef enum : NSUInteger {
    DirectionLeft = 0,
    DirectionRight,// 水平
    DirectionUp,
    DirectionDown,   // 垂直
    DirectionNone,
} PgrDirection;
/**
 *  if (message.userInfo[@"index"] || message.userInfo[@"translationX"]) {
 NSInteger index = [message.userInfo[@"index"] integerValue];
 CGFloat translationX = [message.userInfo[@"translationX"] floatValue];

 */
// 改变大小回调
typedef void(^NoteChangeBlock)(NSInteger index, CGFloat translationX);
// 改变高低回调播放声音
typedef void(^PlayPitchNote)(NSInteger pitch, NoteView *noteView);
// 拖动结束后改变midi回调
typedef void(^ChangeNoteBlock)(NSInteger pitch, NoteView *noteView);

@interface NoteView : UIView

@property (nonatomic, strong) UIView *showNoteView;

@property (nonatomic, assign) CGFloat noteMinWidth;

@property (nonatomic, assign) NSUInteger index;

@property (nonatomic, assign) NSUInteger sentenceIndex;

@property (nonatomic, assign) PgrDirection currentDirection;

@property (nonatomic, assign) PgrDirection rightDirection;

@property (nonatomic, strong) NSArray *noteViewArray;

@property (nonatomic, copy)  NoteChangeBlock noteChangeBlock;

@property (nonatomic, copy) PlayPitchNote playPitchNote;

@property (nonatomic, copy) ChangeNoteBlock changeNoteBlock;

@property (nonatomic, strong) NSData *noteData;//音符二进制为<90327881 70803200 00>

// 最终合成播放用
@property (nonatomic, strong) NSData *finalNoteData;

@property (nonatomic, strong) NSMutableData *mutData;

@property (nonatomic, copy) NSString *lyricStr;

@property (nonatomic, assign) CGPoint noteTranslation;

/**
 *  音符时长
 */
@property (nonatomic, assign) UInt32 noteDeltaTime;


/**
 *  音符横坐标所在格子位置(不包括音符第一个)
 */
@property (nonatomic, assign) CGFloat noteHoriXCount;
/**
 *  音符纵向占据格子数量
 */
@property (nonatomic, assign) CGFloat noteWidthCount;

/**
 *  计算数量时是否有余数
 */
@property (nonatomic, assign) CGFloat noteWidthYu;

/**
 *  音符最右边所在的格子数(包括最后一个)
 */
@property (nonatomic, assign) CGFloat noteRightCount;

/**
 *  音符纵向位置
 */
@property (nonatomic, assign) NSInteger notePitchCount;

@property (nonatomic, assign) BOOL isGuidNote;

@property (nonatomic, assign) CGFloat tmpPgrX;

- (void)changeNoteViewColor;

- (void)showMaskView;

- (void)hideMaskView;

- (void)changeSelfDeltaTime;

@end
