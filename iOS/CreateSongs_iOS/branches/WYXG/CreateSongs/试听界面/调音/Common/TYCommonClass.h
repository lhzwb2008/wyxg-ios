//
//  TYCommonClass.h
//  SentenceMidiChange
//
//  Created by axg on 16/5/9.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
/**
 *  单例
 */
#define TYSingletonM(name) \
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
/**
 男声 / 女声
 */
/**
 男声 / 女声
 */
typedef enum : NSUInteger {
    womanSong,
    manSong,
} SongType;

/**
 调音界面类型  16分音符 / 8分音符
 */
typedef enum : NSUInteger {
    SixOneType,
    EightOneType,
} ShowTyType;

@interface TYCommonClass : NSObject

+ (instancetype)sharedTYCommonClass;

@property (nonatomic, assign) CGFloat noteMinWidth;

@property (nonatomic, assign) CGFloat noteHeight;

@property (nonatomic, strong) NSData *midiData;

/**
 *  歌曲类型
 */
@property (nonatomic, assign) SongType songType;

/**
 *  指定基本时间，在计算每一句时间的时候需要
 */
@property (nonatomic, assign) UInt16 baseTicks;
/**
 *  曲速
 */
@property (nonatomic, assign) CGFloat currentBpm;

@property (nonatomic, assign) CGFloat sentenceTime;
/**
 *  调音视图的宽度
 */
@property (nonatomic, assign) CGFloat tyViewWidth;
/**
 *  头部数据(需要根据具体长度改变头部数据块长度)
 */
@property (nonatomic, strong) NSData *headData;

@property (nonatomic, strong) NSData *footData;

@property (nonatomic, strong) NSData *zeroData;
/**
 *  当前播放的句数
 */
@property (nonatomic, assign) NSInteger currentPlaySentence;
/**
 *  每一句歌词存放的数组
 */
@property (nonatomic, strong) NSArray *lyricArray;

@property (nonatomic, strong) NSData *midiBeforeData;
@property (nonatomic, assign) UInt32 firstData;
@property (nonatomic, assign) UInt32 secondData;

@property (nonatomic, assign) NSInteger sentencCount;

/**
 *  横向最大格子数量
 */
@property (nonatomic, assign) NSInteger horiNoteCount;

@property (nonatomic, assign) ShowTyType showTyType;


@property (nonatomic, assign) CGFloat listCellLeftGap;

@end
