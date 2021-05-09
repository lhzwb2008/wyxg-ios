//
//  MidiParser.m
//  Midi
//
//  Created by axg on 16/3/8.
//  Copyright © 2016年 axg. All rights reserved.
//

#import "MidiParser.h"
#import "TYCommonClass.h"
#import "TYCache.h"

#define kFileCorrupt @"File is corrupt"
#define kInvalidHeader @"Invalid MIDI header"
#define kInvalidTrackHeader @"Invalid Track header"

#define MAIN_HEADER_SIZE 6

#define META_SEQUENCE_NUMBER    0x0
#define META_TEXT_EVENT         0x1 // 文本事件
#define META_COPYRIGHT_NOTICE   0x2 // 版本通告
#define META_TRACK_NAME         0x3 // 音序或音轨名称
#define META_INSTRUMENT_NAME    0x4 // 乐器名称
#define META_LYRICS             0x5 // 歌词
#define META_MARKER             0x6 // 标记
#define META_CUE_POINT          0x7 // 提示点
#define META_CHANNEL_PREFIX     0x20 // MIDI channel前缀
#define META_END_OF_TRACK       0x2f // 音轨结束
#define META_SET_TEMPO          0x51 // 音符速度 如果没有设置缺省速度为120--> 0.5s --> 07A120
#define META_SMPTE_OFFSET       0x54 // SMTPE 偏移量
#define META_TIME_SIGNATURE     0x58 // 拍子记号
#define META_KEY_SIGNATURE      0x59 // 音调符号
#define META_SEQ_SPECIFIC       0x7f // 音序器描述

#define CHANNEL_NOTE_OFF        0x8
#define CHANNEL_NOTE_ON         0x9
#define CHANNEL_NOTE_AFTERTOUCH 0xA
#define CHANNEL_CONTROLLER      0xB
#define CHANNEL_PROGRAM_CHANGE  0xC
#define CHANNEL_AFTERTOUCH      0xD
#define CHANNEL_PITCH_BEND      0xE

#define MICRO_PER_MINUTE        60000000

#define META_YINGAO             0x3F

#define LOG_EXCEPTION   NSLog(@"发生异常%s\n%@\n%@\n%@", __func__, exception.name, exception.reason, exception.userInfo)

@implementation MidiParser

#pragma mark -懒加载

- (NSMutableString *)log {
    if (_log == nil) {
        _log = [[NSMutableString alloc] init];
    }
    return _log;
}

- (NSMutableArray *)noteArray {
    if (_noteArray == nil) {
        _noteArray = [[NSMutableArray alloc] init];
    }
    return _noteArray;
}

- (NSMutableArray *)noteOffArr {
    if (_noteOffArr == nil) {
        _noteOffArr = [[NSMutableArray alloc] init];
    }
    return _noteOffArr;
}
- (NSMutableArray *)sentenceDataArray {
    if (_sentenceDataArray == nil) {
        _sentenceDataArray = [NSMutableArray array];
    }
    return _sentenceDataArray;
}

- (BOOL)parseData:(NSData *)midiData fromePage:(MidiParserType)parserType {
    self.parserType = TianCiPage;
    self.shouldCutHeadTime = NO;
    return [self commonParseData:midiData];
}

- (BOOL)parseData:(NSData *)midiData {
    self.parserType = tiaoYinPage;
    self.shouldCutHeadTime = NO;
    return [self commonParseData:midiData];
}

- (BOOL)configHeadZeroTime:(NSData *)midiData {
    self.shouldCutHeadTime = YES;
    return [self commonParseData:midiData];
}

- (BOOL)commonParseData:(NSData *)midiData {
    if (!midiData) {
        return NO;
    }
    self.currenIndex = 0;
#pragma mark - 填词页面数据初始化
//    [self.tianciMidiDataArray removeAllObjects];
//    self.tianciLastNoteIndex = 0;
    self.currtenArrayIndex = 0;
    self.currentNoteIndex = 0;
    
#pragma mark - 改曲页面数据初始化
    
    BOOL success = YES;
    self.headBeginIndex = 0;
    self.headEndIndex = 0;
    self.sentenceTotalTime = 0;
    self.isToEnd = NO;
    self.lastSentenceEndIndex = 0;
    [self.sentenceDataArray removeAllObjects];
    
    self.muData = [[NSMutableData alloc] initWithData:midiData];
    
    self.xianquMidiData = [[NSMutableData alloc] initWithData:midiData];
//    NSLog(@"原始%@", _muData);
//    [TYCache setObject:_muData forKey:@"原始.mid"];
    
    self.minPitch = 100;
    [self noteArray];
    [self.noteArray removeAllObjects];
    @try {
        data = midiData;
        offset = 0;
        NSUInteger dataLength = [data length];
        if((offset + MAIN_HEADER_SIZE) > dataLength) {
            NSException *ex = [NSException exceptionWithName:kFileCorrupt
                                                      reason:kFileCorrupt userInfo:nil];
            @throw ex;
        }
        if(memcmp([data bytes], "MThd", 4) != 0) {
            NSException *ex = [NSException exceptionWithName:kFileCorrupt
                                                      reason:kInvalidHeader userInfo:nil];
            @throw ex;
        }
        offset += 4;
        
        UInt32 chunkSize = [self readDWord];
        /**
         *  头
         */
        format = [self readWord];
        /**
         *  轨道
         */
        trackCount = [self readWord];
        /**
         *  指定基本时间
         */
        UInt16 timeDivision = [self readWord];
        self.baseTicks = timeDivision;
        
        if((timeDivision & 0x8000) == 0) {
            timeFormat = MidiTimeFormatTicksPerBeat;
            ticksPerBeat = timeDivision & 0x7fff;
            [self.log appendFormat:@"Time Format: %d Ticks Per Beat\n", ticksPerBeat];
        }
        else {
            timeFormat = MidiTimeFormatFramesPerSecond;
            framesPerSecond = (timeDivision & 0x7f00) >> 8;
            ticksPerFrame = (timeDivision & 0xff);
            [self.log appendFormat:@"Time Division: %d Frames Per Second, %d Ticks Per Frame\n", framesPerSecond, ticksPerFrame];
        }
        // FA592ED41C8E9C64008048EA /* PresentAnimate */,
        // Try to parse tracks
        UInt32 expectedTrackOffset = offset;
        /**
         *  每个轨道的详细信息
         */
        for(UInt16 track = 0; track < trackCount; track++) {
            if(offset != expectedTrackOffset) {
                [self.log appendFormat:@"Track Offset Incorrect for Track %d - Offset: %d, Expected: %d", track, offset, (unsigned int)expectedTrackOffset];
                offset = expectedTrackOffset;
            }
            
            // Parse track header
            if(memcmp([data bytes] + offset, "MTrk", 4) != 0) {
                NSException *ex = [NSException exceptionWithName:kFileCorrupt
                                                          reason:kInvalidTrackHeader userInfo:nil];
                @throw ex;
            }
            offset += 4;
            
            UInt32 trackSize = [self readDWord];
            expectedTrackOffset = offset + trackSize;
            //[self.log appendFormat:@"Track %d : %d bytes\n", track, trackSize];
            
            NSLog(@"Track %d : %d bytes\n", track, trackSize);
            
            self.maxOffset = expectedTrackOffset;
            
            UInt32 trackEnd = offset + trackSize;
            UInt32 deltaTime;
            UInt8 nextByte = 0;
            UInt8 peekByte = 0;
            while(offset < trackEnd) {
                if (offset >= data.length) {
                    return NO;
                }
                deltaTime = [self readVariableValue];//
                //[self.log appendFormat:@"  (%05d): ", deltaTime];
                
                // Peak at next byte
                peekByte = [self readByteAtRelativeOffset:0];
                
                if((peekByte & 0x80) != 0) {
                    nextByte = [self readByte];
                }
                // Meta 事件
                if(nextByte == 0xFF){
                    /**
                     *  delta-time
                     */
                    UInt8 metaEventType = [self readByte];
                    UInt32 metaEventLength = [self readVariableValue];//
                    
                    switch (metaEventType) {
                        case META_SEQUENCE_NUMBER:
                            [self readMetaSequence];
                            break;
                            
                        case META_TEXT_EVENT:
                            [self readMetaTextEvent: metaEventLength];
                            break;
                            
                        case META_COPYRIGHT_NOTICE:
                            [self readMetaCopyrightNotice: metaEventLength];
                            break;
                            
                        case META_TRACK_NAME:
                            [self readMetaTrackName: metaEventLength];
                            break;
                            
                        case META_INSTRUMENT_NAME:
                            [self readMetaInstrumentName: metaEventLength];
                            break;
                            
                        case META_LYRICS:
                            [self readMetaLyrics: metaEventLength];
                            break;
                            
                        case META_MARKER:
                            [self readMetaMarker: metaEventLength];
                            break;
                            
                        case META_CUE_POINT:
                            [self readMetaCuePoint: metaEventLength];
                            break;
                            
                        case META_CHANNEL_PREFIX:
                            [self readMetaChannelPrefix];
                            break;
                            
                        case META_END_OF_TRACK:
                            [self readMetaEndOfTrack];
                            break;
                            
                        case META_SET_TEMPO:
                            [self readMetaSetTempo];
                            break;
                            
                        case META_SMPTE_OFFSET:
                            [self readMetaSMPTEOffset];
                            break;
                            
                        case META_TIME_SIGNATURE:
                            [self readMetaTimeSignature];
                            break;
                            
                        case META_KEY_SIGNATURE:
                            [self readMetaKeySignature];
                            break;
                            
                        case META_SEQ_SPECIFIC:
                            [self readMetaSeqSpecific: metaEventLength];
                            break;
                        default:
                            break;
                    }
                    
                    offset += metaEventLength;
                } else if(nextByte == 0xf0){
                    UInt32 sysExDataLength = [self readVariableValue];//
                    //[self.log appendFormat:@"SysEx Event - Length: %d\n", sysExDataLength];
                    offset += sysExDataLength;
                }else {
                    UInt8 eventType = (nextByte & 0xF0) >> 4;
                    UInt8 channel = (nextByte & 0xF);
                    UInt8 p1 = 0;
                    UInt8 p2 = 0;
                    
                    switch (eventType) {
                        case CHANNEL_NOTE_OFF:{
                            p1 = [self readByte];
                            p2 = [self readByte];
                            [self readNoteOff: channel parameter1: p1 parameter2: p2];
                            break;
                        }
                        case CHANNEL_NOTE_ON:{
                            p1 = [self readByte];
                            p2 = [self readByte];
                            [self readNoteOn:channel parameter1:p1 parameter2:p2];
                            break;
                        }
                        case CHANNEL_NOTE_AFTERTOUCH:{
                            p1 = [self readByte];
                            p2 = [self readByte];
                            [self readNoteAftertouch:channel parameter1:p1 parameter2:p2];
                            break;
                        }
                        case CHANNEL_CONTROLLER: {
                            p1 = [self readByte];
                            p2 = [self readByte];
                            [self readControllerEvent:channel parameter1:p1 parameter2:p2];
                            break;
                        }
                        case CHANNEL_PROGRAM_CHANGE: {
                            p1 = [self readByte];
                            [self readProgramChange:channel parameter1:p1];
                            break;
                        }
                        case CHANNEL_AFTERTOUCH: {
                            p1 = [self readByte];
                            [self readChannelAftertouch:channel parameter1:p1];
                            break;
                        }
                        case CHANNEL_PITCH_BEND: {
                            p1 = [self readByte];
                            p2 = [self readByte];
                            [self readPitchBend:channel parameter1:p1 parameter2:p2];
                            break;
                        }
                        default:
                            break;
                    }
                }
            }
        }
        
    }
    @catch (NSException *exception) {
        success = NO;
        LOG_EXCEPTION;
        [self.log appendString:[exception reason]];
    }
    if (self.delegate && [self.delegate respondsToSelector:@selector(midiParserDone:)]) {
        [self.delegate midiParserDone:success];
    }
    return success;
}

- (BOOL)changeNotePatch:(NSData *)midiData withMessage:(NoteMessage *)noteMessage atIndex:(NSInteger)index {
    return NO;
}
- (BOOL)changeNotePatch:(NSData *)midiData {
    
    self.currenIndex = 0;
    BOOL success = YES;
//    self.log = [[NSMutableString alloc] init];
//    self.noteArray = [[NSMutableArray alloc] init];
//    self.noteOffArr = [[NSMutableArray alloc] init];
    _muData = [[NSMutableData alloc] initWithData:midiData];
    @try {
        data = midiData;
        offset = 0;
        NSUInteger dataLength = [data length];
        if((offset + MAIN_HEADER_SIZE) > dataLength) {
            NSException *ex = [NSException exceptionWithName:kFileCorrupt
                                                      reason:kFileCorrupt userInfo:nil];
            @throw ex;
        }
        if(memcmp([data bytes], "MThd", 4) != 0) {
            NSException *ex = [NSException exceptionWithName:kFileCorrupt
                                                      reason:kInvalidHeader userInfo:nil];
            @throw ex;
        }
        offset += 4;
        
        UInt32 chunkSize = [self readDWord];
        /**
         *  头
         */
        format = [self readWord];
        /**
         *  轨道
         */
        trackCount = [self readWord];
        /**
         *  指定基本时间
         */
        UInt16 timeDivision = [self readWord];
        if((timeDivision & 0x8000) == 0) {
            timeFormat = MidiTimeFormatTicksPerBeat;
            ticksPerBeat = timeDivision & 0x7fff;
            [self.log appendFormat:@"Time Format: %d Ticks Per Beat\n", ticksPerBeat];
        }
        else {
            timeFormat = MidiTimeFormatFramesPerSecond;
            framesPerSecond = (timeDivision & 0x7f00) >> 8;
            ticksPerFrame = (timeDivision & 0xff);
            [self.log appendFormat:@"Time Division: %d Frames Per Second, %d Ticks Per Frame\n", framesPerSecond, ticksPerFrame];
        }
        // Try to parse tracks
        UInt32 expectedTrackOffset = offset;
        /**
         *  每个轨道的详细信息
         */
        for(UInt16 track = 0; track < trackCount; track++) {
            if(offset != expectedTrackOffset) {
                [self.log appendFormat:@"Track Offset Incorrect for Track %d - Offset: %d, Expected: %d", track, offset, (unsigned int)expectedTrackOffset];
                offset = expectedTrackOffset;
            }
            // Parse track header
            if(memcmp([data bytes] + offset, "MTrk", 4) != 0) {
                NSException *ex = [NSException exceptionWithName:kFileCorrupt
                                                          reason:kInvalidTrackHeader userInfo:nil];
                @throw ex;
            }
            offset += 4;
            
            UInt32 trackSize = [self readDWord];
            expectedTrackOffset = offset + trackSize;
            
            UInt32 trackEnd = offset + trackSize;
            UInt32 deltaTime;
            UInt8 nextByte = 0;
            UInt8 peekByte = 0;
            while(offset < trackEnd) {
                deltaTime = [self readVariableValue];//
                
                // Peak at next byte
                peekByte = [self readByteAtRelativeOffset:0];
                
                // If high bit not set, then assume running status
                if((peekByte & 0x80) != 0) {
                    nextByte = [self readByte];
                }
                // Meta event
                if(nextByte == 0xFF){
                    
                    UInt8 metaEventType = [self readByte];
                    UInt32 metaEventLength = [self readVariableValue];
                    
                    
                    offset += metaEventLength;
                } else if(nextByte == 0xf0){
                    
                    UInt32 sysExDataLength = [self readVariableValue];
                    //[self.log appendFormat:@"SysEx Event - Length: %d\n", sysExDataLength];
                    offset += sysExDataLength;
                }else {
                    UInt8 eventType = (nextByte & 0xF0) >> 4;
                    UInt8 channel = (nextByte & 0xF);
                    UInt8 p1 = 0;
                    UInt8 p2 = 0;
                    
                    switch (eventType) {
                        case CHANNEL_NOTE_OFF:{
                            p1 = [self readByte];
                            p2 = [self readByte];
                            [self readNoteOff: channel parameter1: p1 parameter2: p2];
                            break;
                        }
                        case CHANNEL_NOTE_ON:{
                            p1 = [self readByte];
                            p2 = [self readByte];
                            [self readNoteOn:channel parameter1:p1 parameter2:p2];
                            break;
                        }
                        case CHANNEL_NOTE_AFTERTOUCH:{
                            p1 = [self readByte];
                            p2 = [self readByte];
                            [self readNoteAftertouch:channel parameter1:p1 parameter2:p2];
                            break;
                        }
                        case CHANNEL_CONTROLLER: {
                            p1 = [self readByte];
                            p2 = [self readByte];
                            [self readControllerEvent:channel parameter1:p1 parameter2:p2];
                            break;
                        }
                        case CHANNEL_PROGRAM_CHANGE: {
                            p1 = [self readByte];
                            //[self readProgramChange:channel parameter1:p1];
                            break;
                        }
                        case CHANNEL_AFTERTOUCH: {
                            p1 = [self readByte];
                            //[self readChannelAftertouch:channel parameter1:p1];
                            break;
                        }
                        case CHANNEL_PITCH_BEND: {
                            p1 = [self readByte];
                            p2 = [self readByte];
                            //[self readPitchBend:channel parameter1:p1 parameter2:p2];
                            break;
                        }
                        default:
                            break;
                    }
                    
                }
            }
        }
    }
    @catch (NSException *exception){
        success = NO;
        LOG_EXCEPTION;
        [self.log appendString:[exception reason]];
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(midiChangedResult:midiData:)]) {
        [self.delegate midiChangedResult:success midiData:self.muData];
    }
    return success;
}

- (UInt32) readDWord {
    UInt32 value = 0;
    [data getBytes:&value range:NSMakeRange(offset, sizeof(value))];
    value = CFSwapInt32BigToHost(value);
    offset += sizeof(value);
    return value;
}
//
- (UInt16) readWord {
    UInt16 value = 0;
    NSLog(@"baseTicks的偏移量是---%ld", offset);
    [data getBytes:&value range:NSMakeRange(offset, sizeof(value))];
    NSData *data = [_muData subdataWithRange:NSMakeRange(0, offset + 5)];
    NSLog(@"%@", data);
    
    value = CFSwapInt16BigToHost(value);
    offset += sizeof(value);
    return value;
}
//
- (UInt8) readByte {
    UInt8 value = 0;
    
    [data getBytes:&value range:NSMakeRange(offset, sizeof(value))];
    offset += sizeof(value);
    return value;
}

- (UInt8) readByteAtRelativeOffset: (UInt32) o {
    UInt8 value = 0;
    if (offset >= data.length) {
        return 0;
    }
    [data getBytes:&value range:NSMakeRange(offset + o, sizeof(value))];
    return value;
}
//
- (UInt32) readVariableValue {
    UInt32 value = 0;
    
    UInt8 byte;
    UInt8 shift = 0;
    do {
        value <<= shift;
        if (offset >= data.length) {
            return 0;
        }
        [data getBytes:&byte range:NSMakeRange(offset, 1)];
        offset++;
        value |= (byte & 0x7f);
        shift = 7;
    } while ((byte & 0x80) != 0);
    
    return value;
}

- (NSString *) readString: (int) length {
    char *buffer = malloc(length + 1);
    
    memcpy(buffer, ([data bytes] + offset), length);

    buffer[length] = 0x0;// 设置长度为 0
    NSString *string = [NSString stringWithCString:buffer encoding:NSASCIIStringEncoding];
    free(buffer);
    return string;
}

- (void) readMetaSequence {
    UInt32 sequenceNumber = 0;
    sequenceNumber |= [self readByteAtRelativeOffset:0];
    sequenceNumber <<= 8;
    sequenceNumber |= [self readByteAtRelativeOffset:1];
    //[self.log appendFormat:@"Meta Sequence Number: %d\n", sequenceNumber];
}

- (void) readMetaTextEvent: (UInt32) length {
    NSString *text = [self readString:length];
    [self.log appendFormat:@"Meta Text: %@\n", text];
}

- (void) readMetaCopyrightNotice: (UInt32) length {
    NSString *text = [self readString:length];
    [self.log appendFormat:@"Meta Copyright: %@\n", text];
}

- (void) readMetaTrackName: (UInt32) length {
    NSString *text = [self readString:length];
    [self.log appendFormat:@"Meta Track Name: %@\n", text];
}

- (void) readMetaInstrumentName: (UInt32) length {
    // length = 0x4
    NSString *text = [self readString:length];
    [self.log appendFormat:@"Meta Instrument Name: %@\n", text];
}

- (void) readMetaLyrics: (UInt32) length {
    NSString *text = [self readString:length];
    [self.log appendFormat:@"Meta Text: %@\n", text];
}

- (void) readMetaMarker: (UInt32) length {
    NSString *text = [self readString:length];
    [self.log appendFormat:@"Meta Marker: %@\n", text];
}

- (void) readMetaCuePoint: (UInt32) length {
    NSString *text = [self readString:length];
    [self.log appendFormat:@"Meta Cue Point: %@\n", text];
}

- (void) readMetaChannelPrefix {
    UInt8 channel = [self readByteAtRelativeOffset:0];
    [self.log appendFormat:@"Meta Channel Prefix: %d\n", channel];
}
/**
 *  音轨块结束
 */
- (void) readMetaEndOfTrack {
    /**
     *  只针对单音轨
     */
    if (self.headData && !self.isToEnd) {
        
        NSData *midiData = [data subdataWithRange:NSMakeRange(self.lastSentenceEndIndex, offset-self.lastSentenceEndIndex-3)];
#warning changed
        if (self.midiBeginDeltaTime == 0) {
            [self.sentenceDataArray addObject:midiData];
        }
        
        
//        NSMutableData *mutaData = [[NSMutableData alloc] initWithData:self.headData];
//        
//        [mutaData appendData:midiData];
//        
//        [self.sentenceMidiArray addObject:mutaData];
        
        
        self.lastSentenceEndIndex = offset-3;
        
        self.midiEndData = [data subdataWithRange:NSMakeRange(self.lastSentenceEndIndex, data.length-self.lastSentenceEndIndex)];
        
        self.isToEnd = YES;
//        NSLog(@"%@", self.midiEndData);
    }
}

- (void) readMetaSetTempo {
    UInt32 microPerQuarter = 0;
    microPerQuarter |= [self readByteAtRelativeOffset:0];
    microPerQuarter <<= 8;
    microPerQuarter |= [self readByteAtRelativeOffset:1];
    microPerQuarter <<= 8;
    microPerQuarter |= [self readByteAtRelativeOffset:2];
    
//    double bpm = MICRO_PER_MINUTE * 1.0 / microPerQuarter;
    
    CGFloat bpm = microPerQuarter *1.0 / 1000000;
    
    self.currentBpm = bpm;

    [TYCommonClass sharedTYCommonClass].currentBpm = self.currentBpm;
    
    NSData *dat = [data subdataWithRange:NSMakeRange(offset-3, 8)];
    
    NSLog(@"%@", dat);
    
    [TYCommonClass sharedTYCommonClass].sentenceTime = self.currentBpm * 8;
    
    NSLog(@"%f", [TYCommonClass sharedTYCommonClass].sentenceTime);
//    [self.log appendFormat:@"Meta Set Tempo: Micro Per Quarter: %d, Beats Per Minute: %d\n", (unsigned int)microPerQuarter, bpm];
}

- (void) readMetaSMPTEOffset {
    UInt8 byte = [self readByteAtRelativeOffset:0];
    UInt8 hour = byte & 0x1f;
    UInt8 rate = (byte & 0x60) >> 5;
    UInt8 fps = 0;
    switch(rate) {
        case 0: fps = 24; break;
        case 1: fps = 25; break;
        case 2: fps = 29; break;
        case 3: fps = 30; break;
        default: fps = 0; break;
    }
    UInt8 minutes = [self readByteAtRelativeOffset:1];
    UInt8 seconds = [self readByteAtRelativeOffset:2];
    UInt8 frame = [self readByteAtRelativeOffset:3];
    UInt8 subframe = [self readByteAtRelativeOffset:4];
    [self.log appendFormat:@"Meta SMPTE Offset (%d): %2d:%2d:%2d:%2d:%2d\n", fps, hour, minutes, seconds, frame, subframe];
}

- (void) readMetaTimeSignature {
    UInt8 numerator = [self readByteAtRelativeOffset:0];
    UInt8 denominator = [self readByteAtRelativeOffset:1];
    UInt8 metro = [self readByteAtRelativeOffset:2];
    UInt8 thirty_seconds = [self readByteAtRelativeOffset:3];
    
    [self.log appendFormat:@"Meta Time Signature: %d/%.0f, Metronome: %d, 32nds: %d\n", numerator, powf(2, denominator), metro, thirty_seconds];
}

- (void) readMetaKeySignature {
    UInt8 value = [self readByteAtRelativeOffset:0];
    UInt8 accidentals = value & 0x7f;
    BOOL sharps = YES;
    NSString *accidentalsType = nil;
    if((value & 0x80) != 0) {
        accidentalsType = @"Flats";
        sharps = NO;
    }
    else {
        accidentalsType = @"Sharps";
    }
    UInt8 scale = [self readByteAtRelativeOffset:1];
    NSString *scaleType = nil;
    if(scale == 0) {
        scaleType = @"Major";
    }
    else {
        scaleType = @"Minor";
    }
    [self.log appendFormat:@"Meta Key Signature: %d %@ Type: %@\n", accidentals, accidentalsType, scaleType];
}

- (void) readMetaSeqSpecific: (UInt32) length {
    [self.log appendFormat:@"Meta Event Sequencer Specific: - Length: %d\n", (unsigned int)length];
}
/**
 *  关闭音符
 */
- (void) readNoteOff: (UInt8) channel parameter1: (UInt8) p1 parameter2: (UInt8) p2 {

    NSData *tmpData = [self.xianquMidiData subdataWithRange:NSMakeRange(offset - 5, 6)];
    
//    NSLog(@"%@", tmpData);
    
    NoteMessage *noteMessage = [[NoteMessage alloc] init];
    noteMessage.noteMark = CHANNEL_NOTE_OFF;
    noteMessage.notePitch1 = p1;
    noteMessage.velocity = p2;
    [self.noteOffArr addObject:noteMessage];
    
    if (self.enableChange && self.changeIndex == self.currenIndex) {
        void *a = (void *)([_muData bytes] + offset - 2);
        memset(a, self.changePitch, sizeof(p1));
    }
    self.currenIndex++;
}
/**
 *  开启音符
 */
- (void)readNoteOn: (UInt8) channel parameter1: (UInt8) p1 parameter2: (UInt8) p2 {
    NoteMessage *noteMessage = [[NoteMessage alloc] init];
    noteMessage.noteMark = CHANNEL_NOTE_ON;
    noteMessage.notePitch1 = p1;
    noteMessage.velocity = p2;
    
    
    NSData *zeroMark = [data subdataWithRange:NSMakeRange(0, 1)];
    
    void *a = (void *)([zeroMark bytes]);
    //        void *b = (void *)([_muData bytes] + offset - 1);
    //NSLog(@"%hhu", self.changePitch);
    memset(a, 0, sizeof(p1));
    
    self.zeroData = zeroMark;
    //90437f 34 8043004490
    
//    NSLog(@"%@", [data subdataWithRange:NSMakeRange(offset, 20)]);
    
    
    /**
     *  找到最大的音高 
     */
    if (p1 > self.maxPitch) {
        self.maxPitch = p1;
    }
    if (p1 < self.minPitch) {
        self.minPitch = p1;
    }
    UInt8 value1 = 0;
    UInt8 value2 = 0;
    UInt8 value21 = 0;
    [data getBytes:&value1 range:NSMakeRange(offset, sizeof(value1))];
    [data getBytes:&value2 range:NSMakeRange(offset + 1, sizeof(value2))];
    [data getBytes:&value21 range:NSMakeRange(offset + 2, sizeof(value21))];
    /**
     *  计算当前音符的时长
     */
    if (value2 == 0x80) {
        noteMessage.deltaTime = value1;
    }
    else {
        noteMessage.deltaTime = pow(128, 1) * (value1 - 128) + value2;
    }
    NSInteger midiOffset = offset;
    /**
     *  乐曲开始前的等待时间
     */
    //01a600c0 648360
    if (self.currenIndex == 0) {
        UInt8 value7 = 0;
        UInt8 value8 = 0;
        [data getBytes:&value7 range:NSMakeRange(offset - 8, sizeof(value7))];
        [data getBytes:&value8 range:NSMakeRange(offset - 7, sizeof(value8))];
        if (value7 == 0x00) {
            // value7等于0x00表示midi开始播放前等待时间是超过128的，占两位
            UInt8 value9 = 0;
            UInt8 value10 = 0;
            [data getBytes:&value9 range:NSMakeRange(offset - 5, sizeof(value9))];
            [data getBytes:&value10 range:NSMakeRange(offset - 4, sizeof(value10))];
            
//            if (self.shouldCutHeadTime) {
//                NSData *tmpData = [self.xianquMidiData subdataWithRange:NSMakeRange(offset - 5, 6)];
//                
//                NSLog(@"%@", tmpData);
//                
//                void *a1 = (void *)([self.xianquMidiData bytes] + offset - 4);
//                void *a2 = (void *)([self.xianquMidiData bytes] + offset - 5);
//                memset(a1, 0, sizeof(p1));
//                memset(a2, 0, sizeof(p1));
//                
//                NSData *tmpData1 = [self.xianquMidiData subdataWithRange:NSMakeRange(offset - 5, 6)];
//                
//                NSLog(@"%@", tmpData1);
//            }
            
            noteMessage.noteDeltaTime = 128 * (value9 - 128) + value10;
            
            self.midiBeginDeltaData = [data subdataWithRange:NSMakeRange(offset - 5, 2)];
            
            [self getMidiHeadDataWithOffset:offset-3-2];
            
        } else if (value8 == 0x00){
            // value8等于0x00表示midi开始播放前等待时间是小于128的，占一位
            UInt8 value11 = 0;
            [data getBytes:&value11 range:NSMakeRange(offset - 4, sizeof(value11))];
            noteMessage.noteDeltaTime = value11;
//            if (self.shouldCutHeadTime) {
//                void *a3 = (void *)([self.xianquMidiData bytes] + offset - 4);
//                memset(a3, 0, sizeof(p1));
//            }
            
            
            self.midiBeginDeltaData = [data subdataWithRange:NSMakeRange(offset - 4, 1)];
            
            
            [self getMidiHeadDataWithOffset:offset-3-1];
        }
       
        self.midiBeginDeltaTime = noteMessage.noteDeltaTime;
        
        [TYCommonClass sharedTYCommonClass].midiBeforeData = self.midiBeginDeltaData;
        NSLog(@"%@", self.midiBeginDeltaData);
        NSLog(@"开始播放midi前等待时间%u", self.midiBeginDeltaTime);
    } else {
        /**
         *  计算当前音符与前一个音符之间的时间差
         */
        UInt8 value3 = 0;
        UInt8 value4 = 0;
        UInt8 value5 = 0;
        UInt8 value6 = 0;
        
        BOOL shouldBreak = NO;
        
        for (NSInteger i = offset; i < self.maxOffset; i++) {
            [data getBytes:&value3 range:NSMakeRange(i, sizeof(value3))];
            
            if (value3 == 0x00) {
                for (NSInteger j = i; j < self.maxOffset; j++) {
                    if (j >= data.length) {
                        return;
                    }
                    [data getBytes:&value4 range:NSMakeRange(j, sizeof(value4))];
                    if (value4 == 0x90) {
//                        NSLog(@"i=%ld  j=%ld", i, j);
                        if (j - i - 1 == 1) {
                            //一位
                            [data getBytes:&value5 range:NSMakeRange(i+1, sizeof(value5))];
                            
                            midiOffset = i + 2;
                            noteMessage.noteDeltaTime = value5;
                            shouldBreak = YES;
                            break;
                        } else if (j - i - 1 == 2) {
                            //两位
                            [data getBytes:&value5 range:NSMakeRange(i+1, sizeof(value5))];
                            [data getBytes:&value6 range:NSMakeRange(i+2, sizeof(value6))];
                            
                            
                            midiOffset = i + 3;
                            noteMessage.noteDeltaTime = pow(128, 1) * (value5 - 128) + value6;
                            shouldBreak = YES;
                            break;
                        } else {
                            
                        }
                        shouldBreak = NO;
                    }
                }
            }
            if (shouldBreak) {
                break;
            }
        }
    }
    
    if (self.parserType == tiaoYinPage) {
       [self beforeCheckWithCurrentIndex:self.currenIndex noteMessage:noteMessage offset:midiOffset];
    } else if (self.parserType == TianCiPage) {
        [self tianciSentenceSeperate:midiOffset];
    }
    
    [self.noteArray addObject:noteMessage];
    
    if (self.enableChange && self.changeIndex == self.currenIndex) {
        void *a = (void *)([_muData bytes] + offset - 2);
//        void *b = (void *)([_muData bytes] + offset - 1);
        //NSLog(@"%hhu", self.changePitch);
        memset(a, self.changePitch, sizeof(p1));
//        memset(b, p2 + 12, sizeof(p2));
    }
}

- (void)beforeCheckWithCurrentIndex:(NSInteger)index noteMessage:(NoteMessage *)noteMessage offset:(NSInteger)midiOffset{
    
    UInt32 tmpTime = 0;
    
    if (index == 0) {
//        tmpTime = self.midiBeginDeltaTime;
    }
    
//    NSLog(@"--%u", (unsigned int)noteMessage.noteDeltaTime);
//    NSLog(@"--%u", (unsigned int)noteMessage.deltaTime);
    /**
     NSLog(@"间隔时长%f s", message.noteDeltaTime * 1.0 / _parser.baseTicks * (60.0 / _parser.currentBpm));
     NSLog(@"音符时长%f s", message.deltaTime * 1.0 / _parser.baseTicks * 1.0 * (60.0 / _parser.currentBpm));
     */
//    NSLog(@"ticks=%hu--%u---%u", self.baseTicks, noteMessage.deltaTime, (unsigned int)noteMessage.noteDeltaTime);

    //左移三位到开启音符标示的位置的前一位
    
    self.sentenceTotalTime += tmpTime;
    [self checkIsSentenceEndWithOffset:midiOffset];
    
    self.sentenceTotalTime += noteMessage.deltaTime;
    [self checkIsSentenceEndWithOffset:midiOffset];
#warning 这里修改不计算播放前的等待时间
    if (index == 0) {
        self.sentenceTotalTime += 0;
        [self checkIsSentenceEndWithOffset:midiOffset];
    } else {
        self.sentenceTotalTime += noteMessage.noteDeltaTime;
        [self checkIsSentenceEndWithOffset:midiOffset];
    }
}
/**
 *  填词页面进行的断句操作
 *
 *  @param midiOffset
 */
- (void)tianciSentenceSeperate:(NSInteger)midiOffset {
    
    NSNumber *indexNum = self.sentenceNoteIndexs[self.currtenArrayIndex];
    NSInteger index = [indexNum integerValue];
    if (index == self.currentNoteIndex) {
        self.currtenArrayIndex++;
        NSData *midiData = [data subdataWithRange:NSMakeRange(self.lastSentenceEndIndex, midiOffset - self.lastSentenceEndIndex)];
        [self.sentenceDataArray addObject:midiData];
        self.lastSentenceEndIndex = midiOffset;
    }
    self.currentNoteIndex += 1;
}


- (void)checkIsSentenceEndWithOffset:(NSInteger)midiOffset {
    //按句数分开
//    NSLog(@"%d", self.baseTicks * 4 * 2);
//    NSLog(@"totalTime == %fr    sentenceTime = %d", self.sentenceTotalTime, self.baseTicks * 4 * 2);
    if (self.sentenceTotalTime == self.baseTicks*4*2) {
        self.sentenceTotalTime = 0;
        
        NSData *midiData = [data subdataWithRange:NSMakeRange(self.lastSentenceEndIndex, midiOffset - self.lastSentenceEndIndex)];
        
//        NSLog(@"当前句的midi数据为%@", midiData);
        
        [self.sentenceDataArray addObject:midiData];
        
        self.lastSentenceEndIndex = midiOffset;
    }
}
/*
<4d546864 00000006 00010003 01e04d54 726b0000 004200ff 01177072 6f647563 65645f62 795f574f 59414f58 49454745 2e00ff03 0a574f59 414f5849 45474500 ff510307 0ae200ff 58040402 180800ff 59020000 00ff2f00 4d54726b 000000bd 00c00000
 903478 963c 803400 00  
 903478 8170 803400 00
 903278 8170 803200 00
 903078 8170 803000 00
 903478 8170 803400 05
 903978 8360 803900 00
 903978 8360 803900 00
 903778 8740 803700 00 903c7887 40803c00 00903c78 8550803c 00817090 39788550 80390000 90397881 70803900 00903c78 8740803c 0000903c 78874080 3c000090 34788550 80340081 70903578 83608035 00009032 78836080 32000090 32788740 80320000 90327887 40803200 00903078 85508030 0000ff2f 004d5472 6b000000 0700c100 00ff2f00>
 
 
 
 <4d546864 00000006 00010003 00604d54 726b0000 000c00ff 58040402 180800ff 2f004d54 726b0000 001900
 ff 51030d76 b100
 ff51 030d76b1 00
 ff5103 0d76b100 
 
 ff2f00
 
 4d54726b
 
 000004e2
 00
 ff03084e 49414f4e 69616f
 
 00b0 0a40
 00b0076400 e00040
 00 b06500
 00 b06400
 00 b0060c
 00 b00a40
 00 b0076400 e0004000 c000
 00b0 650000b0 640000b0 060c00b0 0a40
 00b0 076400e0 004000c0 0000c000 
 00b06500 
 00b06400
 00b0060c
 00b00a40
 00b00764 00e00040 00c00000 c000>
 */

- (void)getMidiHeadDataWithOffset:(NSInteger)midiOffset {
    /**
     *  如果headEndIndex等于初始化的值，则说明还没有到第一个音符位置，将此时的offset赋值向左偏移3位 为头部信息二进制的长度 也是第一句的的起始位置
     */
    if (self.headEndIndex == 0) {
        self.headEndIndex = midiOffset;
        self.headData = [data subdataWithRange:NSMakeRange(0, self.headEndIndex)];
        self.lastSentenceEndIndex = midiOffset;
//        NSLog(@"头部二进制数据为%@", self.headData);
        
        if (self.shouldCutHeadTime) {
            self.otherData = [data subdataWithRange:NSMakeRange(self.headEndIndex+2, data.length-self.headEndIndex-2)];
        }
    }
}

- (void) readNoteAftertouch: (UInt8) channel parameter1: (UInt8) p1 parameter2: (UInt8) p2 {
    [self.log appendFormat:@"Note Aftertouch (Channel %d): %d, Amount: %d\n", channel, p1, p2];
}

- (void) readControllerEvent: (UInt8) channel parameter1: (UInt8) p1 parameter2: (UInt8) p2 {
    [self.log appendFormat:@"Controller (Channel %d): %d, Value: %d\n", channel, p1, p2];
}
/**
 *  改变乐器
 *
 *  @param channel
 *  @param p
 */
- (void)readProgramChange: (UInt8) channel parameter1: (UInt8) p1 {
//    void *b = (void *)([_muData bytes] + offset - 1);
//    memset(b, 73, sizeof(p1));
    [self.log appendFormat:@"Program Change (Channel %d): %d\n", channel, p1];
}

- (void)readChannelAftertouch: (UInt8) channel parameter1: (UInt8) p1 {
    [self.log appendFormat:@"Channel Aftertouch (Channel %d): %d\n", channel, p1];
}

- (void)readPitchBend: (UInt8) channel parameter1: (UInt8) p1 parameter2: (UInt8) p2 {
    
    NSData *tmp = [_muData subdataWithRange:NSMakeRange(0, offset - sizeof(p1) - sizeof(p2))];
    
    NSMutableData *tmp1 = [NSMutableData dataWithData:tmp];
    
    UInt8 gy = 70;
    
    [tmp1 appendBytes:&gy length:sizeof(p1)];
    [tmp1 appendBytes:&gy length:sizeof(p2)];
    
    NSData *tmp2 = [data subdataWithRange:NSMakeRange(offset, data.length - (offset + sizeof(p1) + sizeof(p2)) )];
    
    
    [tmp1 appendData:tmp2];
    /**
        p1 高音低位
        p2 高音高位
     */
//    NSLog(@"%d---%d", p1, p2);
    UInt32 value = p1;
    value <<= 8;
    value |= p2;

    [self.log appendFormat:@"Pitch Bend (Channel %d): %d\n", channel, (unsigned int)value];
}
/**
 
 
 <4d546864 00000006 00010003 00604d54 726b0000 000c
 
 00ff 58040402 180800ff 2f00
 
 4d54 726b
 0000 0019
 00ff 51030d76 b100ff51 030d76b1 
 00ff5103 0d76b1
 00 ff2f00
 
 4d54726b
 
 000004e2
 
 00ff03084e 49414f4e 69616f00 b00a4000 b0076400 e0004000 b0650000 b0640000 b0060c00 b00a4000 b0076400 e0004000 c00000b0 650000b0 640000b0 060c00b0 0a4000b0 076400e0 004000c0 0000c000 00b06500 00b06400 00b0060c 00b00a40 00b00764 00e00040 00c00000
 
 c0000000 902c5018 802c0000 902e5018 802e0000
 
 
 <4d546864 00000006 00000001 00784d54 726b0000 045e
 
 00ff 01147072 6f647563 65645f62 795f4e49 414f4e69 616f
 00ff 03084e49 414f4e69 616f
 00ff 51030d76 b0
 00ff58 04040218 08
 00ff59 02000000 c000837e 9038501e 80380000 903a501e 803a0000 9038501e 80380000 903a501e 803a0000 9038501e 80380000 903a501e 803a0000 903d503c 803d0000 9038501e 80380000 903a501e 803a0000 9038501e 80380000 903a501e 803a0000 9038501e 80380000 903a501e 803a0000 903d503c 803d0000 9038501e 80380000 903a501e 803a0000 9038501e 80380000 903a501e 803a0000 9041503c 80410000 903d501e 803d0000 903d504b 803d000f 903d503c 803d0000 903b503c 803b0000 903a501e 803a0000 9038503c 80380000 9036501e 80360000 9036503c 80360000 903d503c 803d0000 903d501e 803d0000 903d502d 803d0000 903a502d 803a0000 90365069 8036002d 903c502d 803c0000 903d502d 803d0000 903f505a 803f0000 903a503c 803a0000 90385081 34803800 5a903850 1e803800 00903a50 1e803a00 00903850 1e803800 00903a50 1e803a00 00903850 1e803800 00903a50 1e803a00 00903d50 3c803d00 00903850 1e803800 00903a50 1e803a00 00903850 1e803800 00903a50 1e803a00 00903850 1e803800 00903a50 1e803a00 00903d50 1e803d00 00904150 3c804100 00904250 3c804200 00903d50 1e803d00 00903a50 5a803a00 00903d50 69803d00 0f903d50 3c803d00 00903f50 1e803f00 00904250 1e804200 00904450 3c804400 00904250 1e804200 00903f50 3c803f00 00903f50 3c803f00 00903f50 1e803f00 00903f50 1e803f00 00903d50 3c803d00 00903d50 1e803d00 00903a50 1e803a00 00903850 1e803800 00903650 3c803600 00903850 5a803800 1e903a50 78803a00 00903b50 5a803b00 00903d50 1e803d00 00903d50 3c803d00 3c903f50 78803f00 00904450 1e804400 00904650 1e804600 00904450 1e804400 00904450 81168044 005a903d 501e803d 00009042 502d8042 00009041 502d8041 0000903d 501e803d 0000903a 501e803a 00009038 501e8038 00009038 501e8038 0000903a 501e803a 0000903a 505a803a 000f903a 502d803a 0000903d 502d803d 0000903f 502d803f 00009036 505a8036 000f903a 502d803a 0000903d 502d803d 0000903f 502d803f 0000903d 504b803d 000f903d 501e803d 0000903a 502d803a 00009038 502d8038 00009036 501e8036 0000903a 50813480 3a00822c 903f5078 803f0000 9044501e 80440000 9046501e 80460000 9044501e 80440000 90445069 8044004b 9041503c 80410000 903f501e 803f0000 903f502d 803f0000 903d502d 803d0000 903d501e 803d0000 903a503c 803a0000 903d501e 803d0000 903f501e 803f0000 903d501e 803d0000 903f503c 803f001e 903a502d 803a0000 903d502d 803d0000 903f503c 803f0000 9036503c 8036001e 903a502d 803a0000 903d502d 803d0000 903f503c 803f0000 9036502d 8036000f 9036501e 80360000 903f502d 803f0000 903d502d 803d0000 9039501e 80390000 903a502d 803a0000 90365081 43803600 00ff2f00>
 
 
    <4d546864(MThd) 00000006(长度) 0001(格式) 0003(Track) 0078(1/4音符)
 
    4d54726b(MTrk)
    00000044(音轨块长度)
    00ff011c70726f64756365645f62795f44736f756e64736f667420746563682e(文本事件，作者名称)
    00ff0307596f7562616e64(音序或音轨名称)
    00ff510308b824(音符速度)
    00ff580404021808(拍子记号)
    00ff59020000(音调符号)
    00ff2f00(音轨结束)
     
    4d54726b    (MTrk)
    000001a6    (音轨块长度)
    00          (delta-time)
    c064        (通道1 音色100)
 
    第一小节
    8360        (delta-time)           128^1 x 3 + 128^0 x 96   480
 
 
    每一个小格子代表 0.25s
 
                                9959   128 * (153-128) + 89
 
    第二小节  52 + 68 + 233 + 129 -->   480
    90437f 34   804300      44              52  68
    90407f 8168 804000      8100            232 128
    
    第三小节  22 + 38 + 52 + 242 -->    480
    903e7f 16   803e00      26              22  38
    903e7f 34   803e00      8270            52  368
    
 
    第四小节                            480
    90377f 34   803700      44              52  68
    90377f 70   803700      44              112 68
    903b7f 70   803b00      44              112 68
 
    第五小节                            480
    90347f 70   803400      8270            112 368
 
    第六小节                            480
    90397f 34   803900      44              52  68
    90397f 34   803900      08              52  8
    90397f 34   803900      44              52  68
    90417f 810e 804100      26              142 38
           810d
    第七小节                            480
    90407f 16   804000      26              22  38
    90407f 52   804000      26              82  38
    90437f 34   804300      08              52  8
    90407f 34   804000      08              52  8
    90407f 34   804000      08              52  8
    90407f 52   804000      26              82  38
 
 
    第八小节                            481
    903c7f 43   803c00      35              67  53
    903c7f 34   803c00      08              52  8
    903c7f 43   803c00      35              67  53
    90377f 810e 803700      26              143 38
           810d
    第九小节                            481
    90377f 16   803700      26              22  38
    90377f 3c   803700      00              60  0
    90377f 70   803700      8178            112 249
                            8177
 
 
    第十小节 第十一小节                   836 (480 + 350)?   差124
    90397f 34   803900      44              52  68
    903c7f 52   803c00      26              82  38
    903e7f 827e 803e00      26              256 38
    90407f 812c 804000      8100            173 129
 
 
 
    第十二小节 第十三小节                  836                差124
    903c7f 34   803c00      44              52  68
    903c7f 52   803c00      26              82  38
    90397f 8251 803900      17              211 23
    90437f 812c 804300      813c            173 189
    
    第十四小节 第十五小节                  960
    90397f 34   803900      44              52  68
    90417f 1e   804100      00              30  0
    90417f 34   804100      26              52  38
    903c7f 34   803c00      08              52  8
    90397f 52   803900      26              82  38
    903c7f 52   803c00      26              82  38
    903c7f 52   803c00      26              82  38
    903c7f 52   803c00      26              82  38
    90377f 34   803700      08              52  8
    90357f 70   803500      08              112 8
 
    第十六小节 第十七小节                  714                差246
    90397f 8260 803900      08              226（01d8） 8
    90377f 34   803700      08              52  8
    90357f 34   803500      08              52  8
    903b7f 61   803b00      17              97  23
    90407f 34   804000      08              52  8
    903e7f 34   803e00      08              52  8
    903c7f 78   803c00      00              120    最后一个音符系统读出的时间是1.0s 与这里对应，所以一个格子是30
 
    ff2f00(音轨结束) 4d54726b(MTrk) 00000007(音轨块长度) 00 c163(通道音色99)  00ff2f00(音轨结束)>

 音符时长为480
 音符时长为480
 音符时长为960
 音符时长为480
 音符时长为480
 音符时长为720
 
 
原始<4d546864 00000006 00010003 01e04d54 726b0000 004200ff 01177072 6f647563 65645f62 795f574f 59414f58 49454745 2e00ff03 0a574f59 414f5849 45474500 ff510307 b18900ff 58040402 180800ff 59020000 00ff2f00 4d54726b 000000c7 00c00000
 
 903078 8360 803000 00
 902f78 8360 802f00 00
 903078 8740 803000 00
 903078 8360 803000 00
 903278 8360 803200 00
 903478 8550 803400 8170
 903778 8740 803700 00
 903b78 8360 803b00 00
 903978 8360 803900 00
 903578 8740 803500 00
 903278 8550 803200 8170
 
 903478 8360 803400 00
 903278 8360 803200 00
 903078 8740 803000 00
 903478 8360 803400 00
 903c78 8740 803c00 8360
 
 903c78 8550 803c00 00
 903c78 8170 803c00 00
 903e78 8740 803e00 00
 903978 8740 803900 00
 903978 8550 803900 00
 
 ff2f004d 54726b00 00000700 c10000ff 2f00>
 
修改<4d546864 00000006 00010003 01e04d54 726b0000 004200ff 01177072 6f647563 65645f62 795f574f 59414f58 49454745 2e00ff03 0a574f59 414f5849 45474500 ff510307 b18900ff 58040402 180800ff 59020000 00ff2f00 4d54726b 000000c8 00c00000 
 
 903078 8360 803000 00
 902f78 8360 802f00 00
 903078 8740 803000 00
 903078 8360 803000 00
 903278 8360 803200 00
 903478 8550 803400 8170
 
 903778 8740 803700 00
 903b78 8360 803b00 00
 903978 8360 803900 00
 903578 8740 803500 00
 903278 8550 803200 8170
 
 903478 8360 803400 00
 903278 8360 803200 00
 903078 8740 803000 00
 903478 8360 803400 00
 903c78 8740 803c00 8360
 
 903c78 8550 803c00 00     720
 903c78 8170 803c00 00     240
 903e78 8740 803e00 00      960
 903978 8740 803900 00      960
 903978 8550 803900 8170    720  240
 
 ff2f004d 54726b00 00000700 c10000ff 2f00>
 
 
 // 这是获取到的最后一个音符数据
 903c78 8930 803c00 00
 ff2f004d 54726b00 00000700 c10000ff 2f00
 
 // 应该是这样的
 903c78 8930 803c00 8550
 ff2f00 4d54726b 00000007 00c10000 ff2f00
 
原始<4d546864 00000006 00010003 01e04d54 726b0000 004200ff 01177072 6f647563 65645f62 795f574f 59414f58 49454745 2e00ff03 0a574f59 414f5849 45474500 ff510307 530000ff 58040402 180800ff 59020000 00ff2f00 4d54726b 000000eb 00c00000
 903478 8170 803400 00
 903278 8170 803200 00
 903278 8170 803200 00
 903278 8170 803200 00
 903478 8360 803400 00
 903578 8360 803500 00
 903778 8170 803700 00
 903478 8268 803400 00
 903578 8268 803500 00
 903478 8550 803400 8170
 
 
 90 37788360 80370000 
 90377883 60803700 00903778 85508037 00009037 78817080 37000090 37788930 80370085 50903c78 8360803c 00009039 78836080 39000090 37788740 80370000 90397883 60803900 00904078 87408040 00836090 40788360 80400000 903e7883 60803e00 00903b78 8170803b 0000903c 78855080 3c000090 3c788930 803c0000 ff2f004d 54726b00 00000700 c10000ff 2f00>
 
修改<4d546864 00000006 00010003 01e04d54 726b0000 004200ff 01177072 6f647563 65645f62 795f574f 59414f58 49454745 2e00ff03 0a574f59 414f5849 45474500 ff510307 530000ff 58040402 180800ff 59020000 00ff2f00 4d54726b 000000ec 00c00000
 
 903478 8170 803400 00
 903278 8170 803200 00
 903278 8170 803200 00
 903278 8170 803200 00
 903478 8360 803400 00
 903578 8360 803500 00
 903778 8170 803700 00
 903478 8170 803400 00
 903578 8170 803500 8170
 903478 8550 803400 8170
 
 
 90377883 60803700 00
 903778 83608037 0000
 9037 78855080 370000
 90 37788170 80370000
 90377889 30803700 8550
 903c 78836080 3c0000
 90 39788360 80390000 
 90377887 40803700 00
 903978 83608039 00009040 78874080 40008360 90407883 60804000 00903e78 8360803e 0000903b 78817080 3b000090 3c788550 803c0000 903c788f 00803c00 00ff2f00 4d54726b 00000007 00c10000 ff2f00>
 
 
  原始<4d546864 00000006 00010003 01e04d54 726b0000 004200ff 01177072 6f647563 65645f62 795f574f 59414f58 49454745 2e00ff03 0a574f59 414f5849 45474500 ff510306 e23700ff 58040402 180800ff 59020000 00ff2f00 4d54726b 000000be 00c00000 9030788f 00803000 00903478 81708034 00009032 78817080 32000090 35788360 80350000 90347885 50803400 81709030 78817080 30000090 32788550 80320000 90327883 60803200 00903078 83608030 00009030 78893080 30008550 90357887 40803500 00903278 87408032 00009034 78855080 34000090 37788170 80370000 903c7885 50803c00 81709039 78836080 39000090 39788360 80390000 90377887 40803700 00904078 87408040 0000903c 78855080 3c0000ff 2f004d54 726b0000 000700c1 0000ff2f 00>
 修改<4d546864 00000006 00010003 01e04d54 726b0000 004200ff 01177072 6f647563 65645f62 795f574f 59414f58 49454745 2e00ff03 0a574f59 414f5849 45474500 ff510306 e23700ff 58040402 180800ff 59020000 00ff2f00 4d54726b 000000be 00c00000 9030788f 00803000 00903478 81708034 00009032 78817080 32000090 35788360 80350000 90347885 50803400 81709030 78817080 30000090 32788550 80320000 90327883 60803200 00903078 83608030 00009030 78893080 30008550 90357887 40803500 00903278 87408032 00009034 78855080 34000090 37788170 80370000 903c7885 50803c00 81709039 78836080 39000090 39788360 80390000 90377887 40803700 00904078 87408040 0000903c 78874080 3c0000ff 2f004d54 726b0000 000700c1 0000ff2f 00>
 
  原始<4d546864 00000006 00010003 01e04d54 726b0000 004200ff 01177072 6f647563 65645f62 795f574f 59414f58 49454745 2e00ff03 0a574f59 414f5849 45474500 ff510307 621e00ff 58040402 180800ff 59020000 00ff2f00 4d54726b 000000d9 00c00000 90307881 70803000 00903478 81708034 00009032 78836080 32000090 32788170 80320000 90307881 70803000 00903278 83608032 00009030 78874080 30000090 34788550 80340081 70903078 81708030 00009032 78817080 32000090 34788360 80340000 90347887 40803400 00903978 89308039 00855090 40788f00 80400000 90407881 70804000 00903e78 8170803e 00009040 78836080 40000090 3c788550 803c0081 70903c78 8550803c 0000903c 78817080 3c000090 3b788740 803b0000 90397887 40803900 00903978 85508039 0000ff2f 004d5472 6b000000 0700c100 00ff2f00>
 
 修改<4d546864 00000006 00010003 01e04d54 726b0000 004200ff 01177072 6f647563 65645f62 795f574f 59414f58 49454745 2e00ff03 0a574f59 414f5849 45474500 ff510307 621e00ff 58040402 180800ff 59020000 00ff2f00 4d54726b 000000d9 00c00000 90307881 70803000 00903478 81708034 00009032 78836080 32000090 32788170 80320000 90307881 70803000 00903278 83608032 00009030 78874080 30000090 34788550 80340081 70903078 81708030 00009032 78817080 32000090 34788360 80340000 90347887 40803400 00903978 89308039 00855090 40788f00 80400000 90407881 70804000 00903e78 8170803e 00009040 78836080 40000090 3c788550 803c0081 70903c78 8550803c 0000903c 78817080 3c000090 3b788740 803b0000 90397887 40803900 00903978 87408039 0000ff2f 004d5472 6b000000 0700c100 00ff2f00>
 
 
 
 
 
 */



@end
