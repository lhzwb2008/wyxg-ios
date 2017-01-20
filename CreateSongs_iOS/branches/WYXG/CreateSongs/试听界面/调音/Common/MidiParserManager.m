//
//  MidiParserManager.m
//  SentenceMidiChange
//
//  Created by axg on 16/4/22.
//  Copyright © 2016年 axg. All rights reserved.
//

#import "MidiParserManager.h"

#import "TYCache.h"
#import "SentenceNoteMessage.h"
#import "SentenceMessage.h"
#import "TYCommonClass.h"
#import "TYHeader.h"
#define TOTAL_WIDTH [[UIScreen mainScreen] bounds].size.width


@interface MidiParserManager ()<ParserProtocol>

@property (nonatomic, strong) NSArray *lyricArray;
/**
 *  解析midi对象
 */
@property (nonatomic, strong) MidiParser *midiParser;

// 每一句的二进制数组
@property (nonatomic, strong) NSMutableArray *sentenceDataArray;
// 每一句合成后的midi二进制数组（用于播放）
@property (nonatomic, strong) NSMutableArray *sentenceMidiArray;

@end

@implementation MidiParserManager



#pragma InitMethod

- (void)parserMidi:(NSData *)midiData withPageType:(MidiParserType)parserType {
    if (parserType == tiaoYinPage) {
        [self parserMidi:midiData lyricContent:nil];
    } else if (parserType == TianCiPage) {
        self.midiParser.delegate = self;
        self.parserType = parserType;
        [self.midiParser parseData:midiData fromePage:parserType];
    }
}

- (void)parserMidi:(NSData *)midiData lyricContent:(NSString *)content {
    if (content.length > 0) {
        self.lyricArray = [content componentsSeparatedByString:@","];
        
//        for (NSString *lyric in self.lyricArray) {
//            
//        }
    }
    self.midiParser.delegate = self;
    
    [self.midiParser parseData:midiData];
}

/**
 *  解析每一句对应的midi文件
 */
- (void)parserSentenceMidiData {
    NSInteger i = 0;

    for (NSData *sentenceData in self.sentenceDataArray) {
        [self parserDataBySentenceData:sentenceData sentenceIndex:i++];
        NSLog(@"每一句midi的长度%ld   二进制-%@", sentenceData.length, sentenceData);
//        break;
    }
}

- (void)parserDataBySentenceData:(NSData *)sentenceData sentenceIndex:(NSInteger)sentenceIndex{
    NSInteger offset = 0;
    CGFloat sentenceTime = 0.0f;
    NSMutableArray *tmpNoteArray = [NSMutableArray array];
    @try {
        NSInteger openIndex = 0;
        NSInteger closeIndex = 0;
        while (offset < sentenceData.length) {
            UInt8 value = 0;
            [sentenceData getBytes:&value range:NSMakeRange(offset, sizeof(value))];
            
            if (value == CHANNEL_NOTE_ON) {
                openIndex = offset;
                /* 
                 *  这里的5表示暂时限定最多有五位十六进制  这里计算的是第一句midi开始前的时间
                 */
                UInt32 beforeMidiTime = 0;
                if (offset > 0 && offset < 5 && sentenceIndex==0) {
                    for (NSInteger i = 0; i < offset; i++) {
                        UInt8 tmpValue = 0;
                        [sentenceData getBytes:&tmpValue range:NSMakeRange(i, sizeof(tmpValue))];
//                        NSLog(@"%u", tmpValue);
                        
                        if (tmpValue > 128) {
                            // 这里只针对两位长度
                            [TYCommonClass sharedTYCommonClass].firstData = tmpValue;
                            beforeMidiTime += pow(128, offset - i - 1)*(tmpValue - 128);
                        } else {
                            [TYCommonClass sharedTYCommonClass].secondData = tmpValue;
                            beforeMidiTime +=  tmpValue;
                        }
                    }
                }
                /**
                 *  音高
                 */
                UInt8 notePitch = 0;
                [sentenceData getBytes:&notePitch range:NSMakeRange(offset+1, sizeof(notePitch))];
//                NSLog(@"%u", notePitch);
                /**
                 902b78 8170 802b00 00
                 902b78 8170 802b00 00
                 902978 8170 802900 00
                 
                <902878 8170 802800 00
                 902b78 8170 802b00 00
                 902978 8170 802900 00
                 902878 8550 802800 8360
                 902d78 8170 802d00 00
                 902b78 8170 802b00 00
                 902d78 8170 802d00 00
                 90297881 70802900 00902878 82688028 00009029 78826880 29000090 2b788170 802b0000>
                 */
                
                /**
                 *  音符时长
                 */
                UInt32 deltaTime = 0;
                UInt32 noteDeltime = 0;
                for (NSInteger i = offset; i < sentenceData.length; i++) {
                    UInt8 endValue = 0;
                    [sentenceData getBytes:&endValue range:NSMakeRange(i, sizeof(endValue))];
                    if (endValue == CHANNEL_NOTE_OFF) {
                        
                        for (NSInteger j = 1; j < i - (offset+2); j++) {
                            UInt8 tmpValue = 0;
                            [sentenceData getBytes:&tmpValue range:NSMakeRange(offset + 2 + j, sizeof(tmpValue))];
                            if (tmpValue > 128) {
                                deltaTime += pow(128, i-(offset+2+1)-j)*(tmpValue - 128);
                            } else {
                                deltaTime += tmpValue;
                            }
                        }
                        
                        /**
                         *  音符与下一个音符的间隔时长
                         */
                        for (NSInteger m = i; m < sentenceData.length; m++) {
                            UInt8 beginValue = 0;
                            [sentenceData getBytes:&beginValue range:NSMakeRange(m, sizeof(beginValue))];
                            if (beginValue == CHANNEL_NOTE_ON || m == sentenceData.length-1) {
                                NSInteger maxCount = (m-(i+2));
                                if (m == sentenceData.length - 1) {
                                    maxCount = (m-(i+2))+1;
                                }
                                for (NSInteger n = 1; n < maxCount; n++) {
                                    UInt8 tmpValue = 0;
//                                    NSLog(@"%@", [sentenceData subdataWithRange:NSMakeRange(i + 2 + n , sizeof(tmpValue))]);
                                    [sentenceData getBytes:&tmpValue range:NSMakeRange(i + 2 + n, sizeof(tmpValue))];
                                    if (tmpValue > 128) {
                                        noteDeltime += pow(128, 1)*(tmpValue - 128);
                                    } else {
                                        noteDeltime += tmpValue;
                                    }
                                }
                                closeIndex = m;
                                
//                                NSLog(@"%u", noteDeltime);
                                break;
                            }
                        }
                        break;
                    }
                }
                SentenceNoteMessage *noteMessage = [SentenceNoteMessage new];
                if (closeIndex == sentenceData.length-1) {
                    closeIndex += 1;
                } else {
                    
                }
                
                noteMessage.noteData = [sentenceData subdataWithRange:NSMakeRange(openIndex, closeIndex-openIndex)];
//                NSLog(@"音符数据为%@", noteMessage.noteData);
//                NSLog(@"音符二进制为%@", noteMessage.noteData);
                noteMessage.beforeSentenceTime = beforeMidiTime;
                noteMessage.notePitch = notePitch;
                noteMessage.deltaTime = deltaTime;
//                NSLog(@"音符时长为-%u", (unsigned int)deltaTime);
                noteMessage.noteDeltime = noteDeltime;
                
                [tmpNoteArray addObject:noteMessage];
                
//                CGFloat delTime = noteMessage.noteDeltime * 1.0 / self.midiParser.baseTicks * (60.0 / self.midiParser.currentBpm);
//                CGFloat notTime = noteMessage.deltaTime * 1.0 / self.midiParser.baseTicks * 1.0 * (60.0 / self.midiParser.currentBpm);
//                 NSLog(@"间隔时长%f s", noteMessage.noteDeltime * 1.0 / self.midiParser.baseTicks * (60.0 / self.midiParser.currentBpm));
//                 NSLog(@"音符时长%f s", noteMessage.deltaTime * 1.0 / self.midiParser.baseTicks * 1.0 * (60.0 / self.midiParser.currentBpm));
//                sentenceTime += delTime;
//                sentenceTime += notTime;
            }
            offset += sizeof(value);
        }
    }
    @catch (NSException *exception) {
        LOG_EXCEPTION;
    }
    @finally {
        
    }
//    NSLog(@"--+%f", self.midiParser.baseTicks*4*2 * 1.0 / self.midiParser.baseTicks * (60.0 / self.midiParser.currentBpm));
    
//    NSLog(@"总时间为%f", sentenceTime);
    SentenceMessage *sentenceMessage = [SentenceMessage new];
    sentenceMessage.index = sentenceIndex;
    sentenceMessage.baseTicks = self.midiParser.baseTicks;
    sentenceMessage.sentenceTime = sentenceTime;
    sentenceMessage.noteMessArray = tmpNoteArray;
    sentenceMessage.sentenceMidiData = self.sentenceMidiArray[sentenceIndex];
    sentenceMessage.sentenceData = sentenceData;
    sentenceMessage.sentenceHeadData = self.midiParser.headData;
    sentenceMessage.sentenceFootData = self.midiParser.midiEndData;
    sentenceMessage.zeroData = self.midiParser.zeroData;
//    NSLog(@"++%@", sentenceMessage.sentenceData);
    [self.sentenceArray addObject:sentenceMessage];
}


#pragma mark - ParserProtocol

- (void)midiParserDone:(BOOL)result {
    if (result) {
        NSInteger i = 0;
        [self.sentenceDataArray addObjectsFromArray:self.midiParser.sentenceDataArray];
        
        [TYCommonClass sharedTYCommonClass].baseTicks = self.midiParser.baseTicks;
        
        [TYCommonClass sharedTYCommonClass].headData = self.midiParser.headData;
        
        [TYCommonClass sharedTYCommonClass].footData = self.midiParser.midiEndData;
        
        [TYCommonClass sharedTYCommonClass].zeroData = self.midiParser.zeroData;
        
//         NSLog(@"--+%f", self.midiParser.baseTicks*4*2 * 1.0 / self.midiParser.baseTicks * (60.0 / self.midiParser.currentBpm));
        
//        [TYCommonClass sharedTYCommonClass].sentenceTime = self.midiParser.baseTicks*4*2 * 1.0 / self.midiParser.baseTicks * (60.0 / self.midiParser.currentBpm);
//        NSLog(@"%f", [TYCommonClass sharedTYCommonClass].sentenceTime);
        // 每一句的时间
        self.sentenceTime = self.midiParser.baseTicks * 4.0 * 2.0 / self.midiParser.baseTicks * (60.0 / self.midiParser.currentBpm);
//        NSLog(@"每一句的时间为%f", self.sentenceTime);
        
        for (NSData *midiData in self.midiParser.sentenceDataArray) {
            
            NSMutableData *mutData = [[NSMutableData alloc] initWithData:self.midiParser.headData];
    
//            NSLog(@"%@", [mutData subdataWithRange:NSMakeRange(mutData.length - 7, 7)]);

            // 改变音轨块长度 mutData 就是改变后的头快数据
            for (NSInteger offset = mutData.length - 7; offset < mutData.length-3; offset++) {
                
                void *a = (void *)([mutData bytes] + offset);

                if (offset == mutData.length-3-1) {
                    memset(a, (int)(midiData.length + 6), 1);
                } else {
                    memset(a, 0x00, 1);
                }
            }
            
            if (i != 0) {
                [mutData appendData:self.midiParser.zeroData];
            }
            
            /**
             4d546864 00000006 00010003 01e04d54 726b0000 004200ff 01177072 6f647563 65645f62 795f574f 59414f58 49454745 2e00ff03 0a574f59 414f5849 45474500 ff510309 3f6c00ff 58040402 180800ff 59020000 00ff2f00 4d54726b 0000012a 00c000
             */
            [mutData appendData:midiData];
            
            [mutData appendData:self.midiParser.midiEndData];
            
            // 保存原始未改变的midi数据
            [self.sentenceMidiArray addObject:mutData];
            
//            [TYCache setObject:mutData forKey:[NSString stringWithFormat:@"%ld.mid", i]];
            
            i++;
        }
        [self parserSentenceMidiData];
    } else {
        NSLog(@"解析错误");
    }
}

- (void)midiChangedResult:(BOOL)result midiData:(NSData *)midiData {}


#pragma mark - LazyLoad

- (MidiParser *)midiParser {
    if (_midiParser == nil) {
        _midiParser = [[MidiParser alloc] init];
    }
    return _midiParser;
}

- (NSMutableArray *)sentenceDataArray {
    if (_sentenceDataArray == nil) {
        _sentenceDataArray = [NSMutableArray array];
    }
    return _sentenceDataArray;
}

- (NSMutableArray *)sentenceMidiArray {
    if (_sentenceMidiArray==nil) {
        _sentenceMidiArray = [NSMutableArray array];
    }
    return _sentenceMidiArray;
}

- (NSMutableArray *)sentenceArray {
    if (_sentenceArray == nil) {
        _sentenceArray = [NSMutableArray array];
    }
    return _sentenceArray;
}

@end
