//
//  SentenceMessage.h
//  SentenceMidiChange
//
//  Created by axg on 16/5/7.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SentenceNoteMessage.h"
#import <UIKit/UIKit.h>
#import "TYCommonClass.h"

/**
 *  每一句的信息
 */
@interface SentenceMessage : NSObject

/**
 *  存放SentenceNoteMessage对象的数组
 */
@property (nonatomic, strong) NSArray *noteMessArray;
/**
 *  当前歌词每个音符的frame数组
 */
@property (nonatomic, strong) NSMutableArray *noteFrameArray;

@property (nonatomic, assign) SongType songType;

@property (nonatomic, assign) UInt16 baseTicks;

@property (nonatomic, strong) NSData *sentenceMidiData;

@property (nonatomic, assign) NSInteger sentenceLength;

@property (nonatomic, strong) NSData *sentenceData;

@property (nonatomic, strong) NSData *sentenceHeadData;
@property (nonatomic, strong) NSData *sentenceFootData;
@property (nonatomic, strong) NSData *beforeSentenceData;
@property (nonatomic, strong) NSData *zeroData;

@property (nonatomic, assign) CGFloat sentenceTime;

@property (nonatomic, assign) NSInteger index;

@end
