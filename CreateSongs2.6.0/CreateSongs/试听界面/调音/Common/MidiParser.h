//
//  MidiParser.h
//  Midi
//
//  Created by axg on 16/3/8.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteMessage.h"
#import <UIKit/UIKit.h>
@class MidiParser;
typedef enum tagMidiTimeFormat
{
    MidiTimeFormatTicksPerBeat,
    MidiTimeFormatFramesPerSecond
} MidiTimeFormat;


typedef enum : NSUInteger {
    tiaoYinPage,
    TianCiPage,
} MidiParserType;

@protocol ParserProtocol <NSObject>

@optional
/**
 *  改变midi回调方法
 *
 *  @param result   YES成功 NO失败
 *  @param midiData 改变后的midi数据
 */
- (void)midiChangedResult:(BOOL)result midiData:(NSData *)midiData;


/**
 *  解析midi完成 YES成功 NO失败
 */
- (void)midiParserDone:(BOOL)result;

@end

@protocol ChangeDelegate <NSObject>

@end


@interface MidiParser : NSObject {
@public
    NSData *data;
    NSUInteger offset;
    
    UInt16 format;
    UInt16 trackCount;
    MidiTimeFormat timeFormat;
    
    UInt16 ticksPerBeat;
    UInt16 framesPerSecond;
    UInt16 ticksPerFrame;
}
@property (nonatomic, strong)           NSMutableString *log;
@property (nonatomic, assign) UInt32 maxPitch;
@property (nonatomic, assign) UInt32 minPitch;


#pragma mark - 填词页面需要的数据

//@property (nonatomic, strong) NSMutableArray *tianciMidiDataArray;

//@property (nonatomic, assign) NSInteger tianciLastNoteIndex;

/**
 *  当前进行到第几句(sentenceNoteIndexs到第几个元素)
 */
@property (nonatomic, assign) NSInteger currtenArrayIndex;
/**
 *  每一句音符的个数
 */
@property (nonatomic, strong) NSArray *sentenceNoteIndexs;
/**
 *  当前已经读到第几个音符
 */
@property (nonatomic, assign) NSInteger currentNoteIndex;

@property (nonatomic, assign) MidiParserType parserType;

#pragma mark - 调音页面需要的数据
/**
 *  要写入文件的二进制数据
 */
@property (nonatomic, strong) NSMutableData *muData;

@property (nonatomic, strong) NSMutableData *xianquMidiData;
/**
 *  整体音色
 */
@property (nonatomic, assign) UInt8 tone;
/**
 *  开启音符信息数组
 */
@property (nonatomic, strong) NSMutableArray *noteArray;
/**
 *  关闭音符信息数组
 */
@property (nonatomic, strong) NSMutableArray *noteOffArr;

/**
 *  是否允许改变
 */
@property (nonatomic, assign) BOOL enableChange;
/**
 *  改变后的音高
 */
@property (nonatomic, assign) UInt8 changePitch;
/**
 *  改变的音符所在位置
 */
@property (nonatomic, assign) NSInteger changeIndex;
/**
 *  当前所在音符
 */
@property (nonatomic, assign) NSInteger currenIndex;

@property (nonatomic, weak) id<ParserProtocol> delegate;

/**
 *  指定基本时间，在计算每一句时间的时候需要
 */
@property (nonatomic, assign) UInt16 baseTicks;
/**
 *  曲速
 */
@property (nonatomic, assign) CGFloat currentBpm;

@end



// 分割句子使用的成员变量
@interface MidiParser ()

/**
 *  默认 0 头信息数据起始偏移量
 */
@property (nonatomic, assign) NSUInteger headBeginIndex;
/**
 *  头信息数据结束位置偏移量
 */
@property (nonatomic, assign) NSUInteger headEndIndex;
/**
 *  midi头文件信息二进制数据
 */
@property (nonatomic, strong) NSData *headData;
/**
 *  midi每一句对应的二进制数据存放数组
 */
@property (nonatomic, strong) NSMutableArray *sentenceDataArray;

/**
 *  每一句累计时长，当等于baseTicks*4是置为0  用这个变量来寻找每一句的结束位置
 */
@property (nonatomic, assign) float sentenceTotalTime;
/**
 *  上一句midi的结束位置
 */
@property (nonatomic, assign) NSInteger lastSentenceEndIndex;

/**
 *  midi开始前等待时间
 */
@property (nonatomic, assign) UInt32 midiBeginDeltaTime;


/**
 *  最大长度
 */
@property (nonatomic, assign) NSUInteger maxOffset;

/**
 *  结束部分的midi数据
 */
@property (nonatomic, strong) NSData *midiEndData;

/**
 *  是否已经到最后结束位置
 */
@property (nonatomic, assign) BOOL isToEnd;

/**
 *  零的二进制数据 用来放在每一句前边(每一句拼接后的midi文件 需要设置播放前时间为0)
 */
@property (nonatomic, strong) NSData *zeroData;

@property (nonatomic, strong) NSData *midiBeginDeltaData;

@property (nonatomic, assign) BOOL shouldCutHeadTime;
@property (nonatomic, strong) NSData *otherData;

@end



@interface MidiParser (ParserCategory)

- (BOOL)configHeadZeroTime:(NSData *)midiData;
/**
 *  解析midi文件
 */
- (BOOL) parseData: (NSData *) midiData;

- (BOOL) parseData:(NSData *)midiData fromePage:(MidiParserType)parserType;
/**
 *  改变音符信息
 */
- (BOOL)changeNotePatch:(NSData *)midiData;
// 后期使用此接口
- (BOOL)changeNotePatch:(NSData *)midiData withMessage:(NoteMessage *)noteMessage atIndex:(NSInteger)index;
@end
