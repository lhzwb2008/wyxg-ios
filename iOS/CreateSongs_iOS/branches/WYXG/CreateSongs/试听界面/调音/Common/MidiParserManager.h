//
//  MidiParserManager.h
//  SentenceMidiChange
//
//  Created by axg on 16/4/22.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "MidiParser.h"

@interface MidiParserManager : NSObject

/**
 *  每一句歌词视图信息存放数组
 */
@property (nonatomic, strong) NSMutableArray *sentenceArray;
/**
 *  解析指定二进制midi
 *
 *  @param midiData midi二进制数据
 *  @param content  歌词 现在用公共数据单例类存放歌词 这里传nil即可
 */
- (void)parserMidi:(NSData *)midiData lyricContent:(NSString *)content;

- (void)parserMidi:(NSData *)midiData withPageType:(MidiParserType)parserType;

@property (nonatomic, assign) MidiParserType parserType;

@property (nonatomic, assign) CGFloat sentenceTime;

@end
