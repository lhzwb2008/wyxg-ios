//
//  SentenceMessage.m
//  SentenceMidiChange
//
//  Created by axg on 16/5/7.
//  Copyright © 2016年 axg. All rights reserved.
//

#import "SentenceMessage.h"


@implementation SentenceMessage

- (void)setNoteMessArray:(NSArray *)noteMessArray {
    _noteMessArray = noteMessArray;
    
    CGFloat tyViewWidth = [[TYCommonClass sharedTYCommonClass] tyViewWidth];
//    NSLog(@"%f", tyViewWidth / 16);
    NSInteger currentTime = 0;
    CGFloat noteX = 0.0f;
    CGFloat noteH = [TYCommonClass sharedTYCommonClass].noteHeight;
    CGFloat noteY = 0.0f;
    CGFloat noteW = 0.0f;
    
    /**
    
     NSLog(@"间隔时长%f s", message.noteDeltaTime * 1.0 / _parser.baseTicks * (60.0 / _parser.currentBpm));
     NSLog(@"音符时长%f s", message.deltaTime * 1.0 / _parser.baseTicks * 1.0 * (60.0 / _parser.currentBpm));
     
     self.sentenceTime = self.midiParser.baseTicks * 4.0 * 2.0 / self.midiParser.baseTicks * (60.0 / self.midiParser.currentBpm)+0;
     */
    NSInteger tmpIndex = 0;
    for (SentenceNoteMessage *message in _noteMessArray) {
        if (tmpIndex == 0 && self.index == 0) {
#warning header这里修改让第一个音符从0开始计算坐标
//            currentTime += message.beforeSentenceTime;
        } 
        tmpIndex ++;
        
        noteW = tyViewWidth / (8 * self.baseTicks) * message.deltaTime;
        
        noteX = tyViewWidth / (8 * self.baseTicks) * currentTime ;
        
//        NSLog(@"%u--%u--pitch=%u", message.deltaTime, message.noteDeltime, message.notePitch);
        currentTime += (message.deltaTime + message.noteDeltime);
        
        // 女声 41 - 67  男声 35-60
        
        if ([TYCommonClass sharedTYCommonClass].songType == womanSong) {
//            if ([TYCommonClass sharedTYCommonClass].songType == manSong) {
//            NSLog(@"女声 %u", message.notePitch);
            NSInteger i = 0;
            switch (message.notePitch) {
                case 67: {
                    i = 0;
                }
                    break;
                case 65: {
                    i = 1;
                }
                    break;
                case 64: {
                    i = 2;
                }
                    break;
                case 62: {
                    i = 3;
                }
                    break;
                case 60: {
                    i = 4;
                }
                    break;
                case 59: {
                    i = 5;
                }
                    break;
                case 57: {
                    i = 6;
                }
                    break;
                case 55: {
                    i = 7;
                }
                    break;
                case 53: {
                    i = 8;
                }
                    break;
                case 52: {
                    i = 9;
                }
                    break;
                case 50: {
                    i = 10;
                }
                    break;
                case 48: {
                    i = 11;
                }
                    break;
                case 47: {
                    i = 12;
                }
                case 45: {
                    i = 13;
                }
                    break;
                case 43: {
                    i = 14;
                }
                    break;
                case 41: {
                    i = 15;
                }
                    break;
                default:
                    NSLog(@"音高超出范围");
                    break;
            }

            noteY = noteH * (i);
//            NSLog(@"女声 pitch=%u delta=%u notedel=%u  noteY = %f", message.notePitch, message.deltaTime, message.noteDeltime, noteY);
        } else {
//            NSLog(@"男声 %u", message.notePitch);
            NSInteger i = 0;
            switch (message.notePitch) {
                case 60: {
                    i = 0;
                }
                    break;
                case 59: {
                    i = 1;
                }
                    break;
                case 57: {
                    i = 2;
                }
                    break;
                case 55: {
                    i = 3;
                }
                    break;
                case 53: {
                    i = 4;
                }
                    break;
                case 52: {
                    i = 5;
                }
                    break;
                case 50: {
                    i = 6;
                }
                    break;
                case 48: {
                    i = 7;
                }
                    break;
                case 47: {
                    i = 8;
                }
                    break;
                case 45: {
                    i = 9;
                }
                    break;
                case 43: {
                    i = 10;
                }
                    break;
                case 41: {
                    i = 11;
                }
                    break;
                case 40: {
                    i = 12;
                }
                    break;
                case 38: {
                    i = 13;
                }
                case 36: {
                    i = 14;
                }
                    break;
                case 35: {
                    i = 15;
                }
                    
                    break;
                default:
                    NSLog(@"音高超出范围");
                    break;
            }
            noteY = noteH * (i);
//            NSLog(@"男声 pitch=%u delta=%u notedel=%u  noteY = %f", message.notePitch, message.deltaTime, message.noteDeltime, noteY);
        }
        
        CGRect noteFrame = CGRectMake(noteX, noteY, noteW, noteH);
//        NSLog(@"noteFrame == %@", NSStringFromCGRect(noteFrame));
        [self.noteFrameArray addObject:NSStringFromCGRect(noteFrame)];
    }
}

- (NSMutableArray *)noteFrameArray {
    if (_noteFrameArray == nil) {
        _noteFrameArray = [NSMutableArray array];
    }
    return _noteFrameArray;
}

@end
