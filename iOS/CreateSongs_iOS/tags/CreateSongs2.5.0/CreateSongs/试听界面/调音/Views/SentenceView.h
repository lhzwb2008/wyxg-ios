//
//  SentenceView.h
//  SentenceMidiChange
//
//  Created by axg on 16/4/22.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteMessage.h"
#import "SentenceMessage.h"
#import "XMidiPlayer.h"

typedef void(^BeginScrollBlock)(NSInteger scrollOffsetCount);

@interface SentenceView : UIView

@property (nonatomic, strong) NSMutableArray *eventsArray;

@property (nonatomic, strong) XMidiPlayer *midiPlayer;

@property (nonatomic, assign) NSInteger index;

- (instancetype)initWithFrame:(CGRect)frame withSentenceMessage:(SentenceMessage *)sentenceMessage withSentenceIndex:(NSInteger)index;

- (void)mixPlayMidi:(NSInteger)index;

- (void)stopPlayMidi;

@property (nonatomic, strong) NSData *sentenceHeadData;
@property (nonatomic, strong) NSData *sentenceFootData;
@property (nonatomic, strong) NSData *beforeSentenceData;


@property (nonatomic, strong) NSData *playMidiData;//播放用
@property (nonatomic, strong) NSData *senteneData;// 合成用

@property (nonatomic, copy) NSString *sentenceLyric;
// 音符超出屏幕外触发
@property (nonatomic, copy) BeginScrollBlock beginScrollBlock;

@end

