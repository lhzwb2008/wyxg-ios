//
//  SentenceView.m
//  SentenceMidiChange
//
//  Created by axg on 16/4/22.
//  Copyright © 2016年 axg. All rights reserved.
//

#import "SentenceView.h"
#import "NoteView.h"
#import "TYCommonClass.h"
#import "AppDelegate.h"
#import "TYHeader.h"
#import "PlayAnimatView.h"
#import "UIView+Common.h"
#import "TYCache.h"

@interface SentenceView ()<XOpenALPlayerDelegate, XMidiPlayerDelegate> {
    NSInteger _moveDeltaCount;
}
@property (nonatomic, strong) NSArray *sentenceFrameArr;
@property (nonatomic, strong) NSMutableArray *noteViewArray;
/**
 *  滑动手势结束响应
 */
@property (nonatomic, assign) BOOL shouldBreak;
@property (nonatomic, assign) NSInteger sentenceCount;
@property (nonatomic, assign) NSInteger currentPitch;
@property (nonatomic, strong) NSMutableData *mixSentenceData;
@property (nonatomic, strong) NSMutableData *mixSentenceMidiData;
@property (nonatomic, strong) NSData *zeroData;

// 正在拖动的音符下标
@property (nonatomic, assign) NSInteger moveingIndex;
// 上一次显示的noteView
@property (nonatomic, strong) NoteView *lastShowNoteView;

@property (nonatomic, assign) CGFloat translationX;

@property (nonatomic, assign) CGFloat minNoteWidth;
@property (nonatomic, assign) CGFloat tyViewWidth;

/**
 *  是否是拖动的左边，如果是则当前音符大小不改变，只移动
 */
@property (nonatomic, assign) BOOL isLeft;

/**
 *  用来判断最终形成一句的时长是否是一整句(暂时性解决办法)
 */
@property (nonatomic, assign) CGFloat tmpSentenceTime;

/**
 * +<902b7881 70802b00 00>
 ~<90287881 70802800 8170>
 */
@end

@implementation SentenceView

- (NSMutableData *)mixSentenceData {
    if (_mixSentenceData == nil) {
        _mixSentenceData = [[NSMutableData alloc] init];
    }
    return _mixSentenceData;
}

- (NSMutableData *)mixSentenceMidiData {
    if (_mixSentenceMidiData == nil) {
        _mixSentenceMidiData = [[NSMutableData alloc] init];
    }
    return _mixSentenceMidiData;
}

- (NSMutableArray *)eventsArray {
    if (_eventsArray == nil) {
        _eventsArray = [[NSMutableArray alloc] initWithCapacity:0];
    }
    return _eventsArray;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"changeWidth" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:PLAY_MIDI_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:CURRENT_PLAY_NOTE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:STOP_PLAY_MID object:nil];
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:MIX_DATA object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"pangestrueEnd" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
}

- (void)registNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeOtherNoteFrame:) name:@"changeWidth" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(topLeftToMoveNote:) name:@"leftMoveNote" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginPlayMidi:) name:PLAY_MIDI_NOTI object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mixPlayMidi:) name:MIX_DATA object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(showCurrentNote:) name:CURRENT_PLAY_NOTE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(stopPlayMidi) name:STOP_PLAY_MID object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pangestureEnd:) name:@"pangestrueEnd" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(panLeftViewBegan) name:@"panLeftViewBegan" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(panRightViewBegan) name:@"panRightViewBegan" object:nil];
}

- (void)panLeftViewBegan {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    if (!app.noteIsChanged) {
        app.noteIsChanged = YES;
    }

    self.isLeft = YES;
    _moveDeltaCount = 2;
}

- (void)panRightViewBegan {
    AppDelegate *app = [UIApplication sharedApplication].delegate;
    
    if (!app.noteIsChanged) {
        app.noteIsChanged = YES;
    }

    self.isLeft = NO;
    _moveDeltaCount = 2;
}
- (void)showCurrentNoteOnMain:(NSNumber *)numberIndex {
    NSInteger index = [numberIndex integerValue];
    
    if ([TYCommonClass sharedTYCommonClass].currentPlaySentence == self.index) {
        if (index >= self.noteViewArray.count) {
            if (self.lastShowNoteView != nil) {
                [self.lastShowNoteView hideMaskView];
            }
            return;
        }
        NoteView *currentNote = self.noteViewArray[index];
#if 1
        //        NSLog(@"%@-%f", NSStringFromCGRect(currentNote.frame), [TYCommonClass sharedTYCommonClass].noteMinWidth*12);
        CGFloat scrollOffsetX = currentNote.frame.origin.x + [TYCommonClass sharedTYCommonClass].noteMinWidth;
        
        NSLog(@"%f---%f", scrollOffsetX, [UIScreen mainScreen].bounds.size.width);
        
        if (scrollOffsetX >= 0 && scrollOffsetX < [UIScreen mainScreen].bounds.size.width) {
            if (self.beginScrollBlock) {
                self.beginScrollBlock(0);
            }
        } else if (scrollOffsetX >= [UIScreen mainScreen].bounds.size.width && scrollOffsetX < [UIScreen mainScreen].bounds.size.width * 2) {
            if (self.beginScrollBlock) {
                self.beginScrollBlock(1);
            }
        } else if (scrollOffsetX >= [UIScreen mainScreen].bounds.size.width * 2 && scrollOffsetX < [UIScreen mainScreen].bounds.size.width * 3) {
            if (self.beginScrollBlock) {
                self.beginScrollBlock(2);
            }
        } else if (scrollOffsetX >= [UIScreen mainScreen].bounds.size.width * 3 && scrollOffsetX < [UIScreen mainScreen].bounds.size.width * 4) {
            
        } else if (scrollOffsetX >= [UIScreen mainScreen].bounds.size.width * 4 && scrollOffsetX < [UIScreen mainScreen].bounds.size.width * 5) {
            
        }
#elif 0
        if (currentNote.frame.origin.x >= [TYCommonClass sharedTYCommonClass].noteMinWidth * 11 || index == self.noteViewArray.count-1) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"connotShowNoteNoti" object:nil];
            
        }
#endif
        
        [currentNote showMaskView];
        
        if (self.lastShowNoteView != nil) {
            [self.lastShowNoteView hideMaskView];
        }
        self.lastShowNoteView = currentNote;
    }
}
/**
 *  高亮显示当前播放音符
 *
 *  @param message 通知传递正在播放音符的下标
 */
- (void)showCurrentNote:(NSNotification *)message {
    
    NSInteger index = [message.userInfo[@"currentIndex"] integerValue];
    
    [self performSelectorOnMainThread:@selector(showCurrentNoteOnMain:) withObject:[NSNumber numberWithInteger:index] waitUntilDone:YES];

}
- (void)pangestureEnd:(NSNotification *)message{
}
/**
 *  拖动左边区域移动音符块
 */
- (void)topLeftToMoveNote:(NSNotification *)message {
    self.shouldBreak = NO;
    NSInteger sentenceIndex = [message.userInfo[@"sentenceIndex"] integerValue];
    if (sentenceIndex == self.index) {
        if (message.userInfo[@"index"] || message.userInfo[@"translationX"]) {
            NSInteger noteIndex = [message.userInfo[@"index"] integerValue];
            
//            self.moveingIndex = noteIndex;
            self.translationX = [message.userInfo[@"translationX"] floatValue];
            [self changeFrameWithCurrentIndex:noteIndex translation:self.translationX];
        }
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
//    NSInteger i = 0;
//    for (NSString *rectStr in self.sentenceFrameArr) {
//        
//        CGRect rect = CGRectFromString(rectStr);
//        
//        NoteView *noteView = self.noteViewArray[i++];
//        
//        noteView.frame = rect;
//    }
}

- (instancetype)initWithFrame:(CGRect)frame withSentenceMessage:(SentenceMessage *)sentenceMessage withSentenceIndex:(NSInteger)index{
    self = [super initWithFrame:frame];
    if (self) {
        [self registNoti];
//        NSLog(@"%@", sentenceMessage.sentenceMidiData);
//        NSLog(@"%ld", sentenceMessage.sentenceData.length);
        self.index = index;
        self.minNoteWidth = [TYCommonClass sharedTYCommonClass].noteMinWidth;
        self.tyViewWidth = [TYCommonClass sharedTYCommonClass].tyViewWidth;
        self.playMidiData = sentenceMessage.sentenceMidiData;
        self.senteneData = sentenceMessage.sentenceData;
        self.shouldBreak = NO;
        self.sentenceFrameArr = sentenceMessage.noteFrameArray;
        self.sentenceHeadData = sentenceMessage.sentenceHeadData;
        self.sentenceFootData = sentenceMessage.sentenceFootData;
        self.beforeSentenceData = sentenceMessage.beforeSentenceData;
        self.zeroData = sentenceMessage.zeroData;
        self.midiPlayer = [[XMidiPlayer alloc] init];
        @try {
            AppDelegate *app = [[UIApplication sharedApplication] delegate];
            if (!app.deviceIsReady) {
                [XMidiPlayer xInit];
                app.deviceIsReady = YES;
            }
            [XOpenALPlayer setDelegate:self];
            [self.midiPlayer pause];
            [self.midiPlayer initMidiWithData:self.playMidiData];
            [self.eventsArray removeAllObjects];
            NSArray *arr1 = self.midiPlayer.midiSequence.tracks;
            for (NSInteger i = 0; i < arr1.count; i++) {
                XMidiTrack *track = arr1[i];
                for (XMidiEvent *event in track.eventIterator.childEvents) {
//                    NSLog(@"time=%f", event.noteMessage.duration);
                    [self.eventsArray addObject:event];
                }
            }
            NSInteger index = 0;
            _noteViewArray = [[NSMutableArray alloc] initWithCapacity:0];
            
            
            for (NSString *frameStr in self.sentenceFrameArr) {
                CGRect rect = CGRectFromString(frameStr);
                
                NoteView *noteView = [NoteView new];
                noteView.isGuidNote = NO;
                [noteView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
                
                noteView.noteData = [(SentenceNoteMessage *)sentenceMessage.noteMessArray[index] noteData];
                noteView.backgroundColor = [UIColor clearColor];
               
                noteView.sentenceIndex = self.index;
                noteView.index = index;
                noteView.frame = rect;
                
                CGFloat noteW = rect.size.width;
                CGFloat noteX = rect.origin.x;
                CGFloat noteY = rect.origin.y;
                float inter = 0;
                // 商
                modff(noteW * 1.0 / ([TYCommonClass sharedTYCommonClass].noteMinWidth * 0.5), &inter);
                // 余数
                CGFloat noteYu = fmodf(noteW, [TYCommonClass sharedTYCommonClass].noteMinWidth * 0.5);
                
                if (index == self.sentenceFrameArr.count-1) {
                    noteYu = noteYu - [TYCommonClass sharedTYCommonClass].noteMinWidth * 0.5;
                }
                
                float inter1 = 0;
                modff(noteX * 1.0 / ([TYCommonClass sharedTYCommonClass].noteMinWidth * 0.5), &inter1);
                
//                CGFloat inter1 = noteX * 1.0 / [TYCommonClass sharedTYCommonClass].noteMinWidth;
//                CGFloat inter = noteW * 1.0 / [TYCommonClass sharedTYCommonClass].noteMinWidth;
                
                float inter2 = 0;
                modff(noteY * 1.0 / [TYCommonClass sharedTYCommonClass].noteHeight, &inter2);

                noteView.notePitchCount = inter2;
                noteView.noteHoriXCount = inter1;
                noteView.noteWidthCount = inter;
//                noteView.noteWidthYu = noteYu;
                
//                NSLog(@"宽度%f-商%f-余数为--%f  最小宽度-%f", noteW, inter, noteYu, [TYCommonClass sharedTYCommonClass].noteMinWidth);
                
                [noteView changeNoteViewColor];
                
                WEAK_SELF;
                noteView.playPitchNote = ^(NSInteger pitch, NoteView *noteView){
                    STRONG_SELF;
                    [self changePitch:noteView withPitch:pitch];
                };
                noteView.changeNoteBlock = ^(NSInteger pitch, NoteView *noteView) {
                    STRONG_SELF;
                    [self changePitchWithNoteIndex:noteView.index andPitch:pitch];
                };
                
                [self.noteViewArray addObject:noteView];
                [self addSubview:noteView];
                
                
                
                index++;
            }
            for (NoteView *noteView in self.noteViewArray) {
                noteView.noteViewArray = self.noteViewArray;
            }
            self.sentenceCount = self.sentenceFrameArr.count;
        }
        @catch (NSException *exception) {
            LOG_EXCEPTION;
        }
        @finally {
            
        }
    }
    return self;
}

- (void)adjustNoteFrameWithNote:(id)object {
    NoteView *noteView = object;
    NSInteger index = noteView.index;
    CGRect frame = noteView.frame;
    
    // 除了最后一个 其他的位置都有下一个音符 --->nextNote
    if (index < self.noteViewArray.count-1 && self.noteViewArray.count > 0) {
        if (index == 1) {
            NSLog(@"123");
        }
        NoteView *nextNote = self.noteViewArray[index+1];
        CGRect nextFrame = nextNote.frame;
        if (frame.origin.x + frame.size.width >= nextNote.frame.origin.x) {
            nextFrame.origin.x += noteView.noteTranslation.x;
            if (nextFrame.size.width > self.minNoteWidth) {
                nextFrame.size.width -= noteView.noteTranslation.x;
            } else {
                [self adjustNoteFrameWithNote:nextNote];
            }
            nextNote.frame = nextFrame;
        }
    }
}

- (void)beginPlayMidi:(NSNotification *)message {
    NSInteger index = [message.userInfo[@"currentIndex"] integerValue];
    if (index >= 0 & index == self.index) {
        [TYCommonClass sharedTYCommonClass].currentPlaySentence = self.index;
        [self mixNoteDataWithIndex:index];
        if (self.midiPlayer) {
            [self.midiPlayer pause];
        }
//        [self.midiPlayer replay];
        if (self.lastShowNoteView != nil) {
            [self.lastShowNoteView hideMaskView];
        }
        self.lastShowNoteView = nil;
        self.midiPlayer.delegate = nil;
        self.midiPlayer.delegate = self;
//        NSLog(@"最终播放midi为%@", self.playMidiData);
        [[NSNotificationCenter defaultCenter] postNotificationName:@"beginPlayMidiSetOffset" object:nil];
//        [TYCache setObject:self.playMidiData forKey:@"playMidi.mid"];
        [self.midiPlayer initMidiWithData:self.playMidiData];
        [self.midiPlayer play];
    }
}
/**
<4d546864 00000006 00010003 01e04d54 726b0000 004200ff 01177072 6f647563 65645f62 795f574f 59414f58 49454745 2e00ff03 0a574f59 414f5849 45474500 ff510306 bb5800ff 58040402 180800ff 59020000 00ff2f00 4d54726b 00000032 00c00000 
 
 902b78 8d10 802b00 00  1670
 902d78 8170 802d00 00  240
 903078 8170 803000 00  240
 903278 8d10 803200 00  1670
 902b78 00   802b00 00
 
 ff2f004d 54726b00 00000700 c10000ff 2f00>
 */

- (void)stopPlayMidi {
    if (self.midiPlayer) {
        [self.midiPlayer pause];
    }
}

- (void)mixPlayMidi:(NSInteger)index {
//    NSInteger index = [message.userInfo[@"currentIndex"] integerValue];
    if (index >= 0 & index == self.index) {
    
        [self mixNoteDataWithIndex:index];
        
        [self.midiPlayer pause];
        
        if (index == [TYCommonClass sharedTYCommonClass].sentencCount - 1) {
            [[NSNotificationCenter defaultCenter] postNotificationName:MIX_MIDI_DONE object:nil];
        }
    }
}

- (void)clumNoteDeltatimeWithNoteIndex:(NSInteger)index andNoteView:(NoteView *)currentNote{
    
    if (index < self.noteViewArray.count - 1) {
#if 0
        // 除了最后一个以外的音符视图
        NoteView *nextNote = self.noteViewArray[index+1];
        CGFloat noteGap = minX(nextNote)-maxX(currentNote);
        if (noteGap <= 0) {
            noteGap = 0;
        }
        UInt32 deltaTime = noteGap * 8 * [TYCommonClass sharedTYCommonClass].baseTicks / self.tyViewWidth;
        
        self.tmpSentenceTime = self.tmpSentenceTime + currentNote.noteDeltaTime + deltaTime;
        
        currentNote.finalNoteData = [self clumDeltaDataWithDeltaTime:deltaTime andCurrentNote:currentNote];
#elif 1
        // 除了最后一个以外的音符视图
        NoteView *nextNote = self.noteViewArray[index+1];
    
        //inter = (int)roundf();
        
        nextNote.noteHoriXCount = (int)roundf(nextNote.frame.origin.x * 1.0 / ([TYCommonClass sharedTYCommonClass].noteMinWidth * 0.5));
        currentNote.noteHoriXCount = (int)roundf(currentNote.frame.origin.x * 1.0 / ([TYCommonClass sharedTYCommonClass].noteMinWidth * 0.5));
        currentNote.noteWidthCount = (int)roundf(currentNote.frame.size.width * 1.0 / ([TYCommonClass sharedTYCommonClass].noteMinWidth * 0.5));
        
        CGFloat gapCount = nextNote.noteHoriXCount - currentNote.noteHoriXCount - currentNote.noteWidthCount;
        
        if ([TYCommonClass sharedTYCommonClass].showTyType == SixOneType) {
            gapCount = gapCount / 2;
        }
//        NSLog(@"---%ld", gapCount);
        // 计算出来的count 对应实际count的一半
        UInt32 deltaTime = gapCount * 1.0 * [TYCommonClass sharedTYCommonClass].baseTicks / 2.0 / 2.0;
        
//        NSLog(@"宽度%f   间距%f---%u", currentNote.noteWidthCount, gapCount, (unsigned int)deltaTime);
        
        self.tmpSentenceTime = self.tmpSentenceTime + currentNote.noteDeltaTime + deltaTime;
        
        currentNote.finalNoteData = [self clumDeltaDataWithDeltaTime:deltaTime andCurrentNote:currentNote];
#endif
    } else if (index == self.noteViewArray.count - 1) {
#if 0
        // 最后一个音符视图单独处理
        CGFloat lastGap = [TYCommonClass sharedTYCommonClass].tyViewWidth - maxX(currentNote);
        if (lastGap <= 0) {
            lastGap = 0;
        }
        UInt32 deltaTime = lastGap * 8 * [TYCommonClass sharedTYCommonClass].baseTicks / self.tyViewWidth;
        self.tmpSentenceTime = self.tmpSentenceTime + currentNote.noteDeltaTime + deltaTime;
        
        UInt32 sentenceTime = [TYCommonClass sharedTYCommonClass].baseTicks * 2 * 4;
        if (self.tmpSentenceTime > sentenceTime) {
            deltaTime = 0;
            
            currentNote.finalNoteData = [self clumDeltaDataWithDeltaTime:deltaTime andCurrentNote:currentNote];
//            NSLog(@"改变前%@", currentNote.finalNoteData);
            [self changeSelfDeltaTimeForNote:currentNote withDeltaTime:currentNote.noteDeltaTime - (self.tmpSentenceTime - sentenceTime)];
//            NSLog(@"改变后%@", currentNote.finalNoteData);
        } else if (self.tmpSentenceTime < sentenceTime) {
            currentNote.finalNoteData = [self clumDeltaDataWithDeltaTime:deltaTime andCurrentNote:currentNote];
            [self changeSelfDeltaTimeForNote:currentNote withDeltaTime:currentNote.noteDeltaTime - (self.tmpSentenceTime - sentenceTime)];
        } else if (self.tmpSentenceTime == sentenceTime) {
            currentNote.finalNoteData = [self clumDeltaDataWithDeltaTime:deltaTime andCurrentNote:currentNote];
        }
#elif 1
        
        currentNote.noteHoriXCount = (int)roundf(currentNote.frame.origin.x * 1.0 / ([TYCommonClass sharedTYCommonClass].noteMinWidth * 0.5));
        currentNote.noteWidthCount = (int)roundf(currentNote.frame.size.width * 1.0 / ([TYCommonClass sharedTYCommonClass].noteMinWidth * 0.5));
        
        // 最后一个音符视图单独处理
        CGFloat gapCount = [TYCommonClass sharedTYCommonClass].horiNoteCount - currentNote.noteHoriXCount - currentNote.noteWidthCount;
        
        if ([TYCommonClass sharedTYCommonClass].showTyType == SixOneType) {
            gapCount = gapCount / 2;
        }
//        NSLog(@"tmpSentenceTime = %f", self.tmpSentenceTime);
//        NSLog(@"noteDeltaTime = %u", (unsigned int)currentNote.noteDeltaTime);
//        NSLog(@"最后一个宽度%f  最后一个间距%f", currentNote.noteWidthCount, gapCount);
//        if (self.index == [TYCommonClass sharedTYCommonClass].sentencCount-1) {
//            gapCount = 0;
//        }
      
        UInt32 deltaTime = gapCount * 1.0 * [TYCommonClass sharedTYCommonClass].baseTicks / 2 / 2.0;
        self.tmpSentenceTime = self.tmpSentenceTime + currentNote.noteDeltaTime + deltaTime;
        
        UInt32 sentenceTime = [TYCommonClass sharedTYCommonClass].baseTicks * 2 * 4;
        if (self.tmpSentenceTime > sentenceTime) {
            
            NSLog(@"*****************************越界****************************");
            
            deltaTime = 0;
            currentNote.noteDeltaTime = 1.0 * [TYCommonClass sharedTYCommonClass].baseTicks / 2;
            
            currentNote.finalNoteData = [self clumDeltaDataWithDeltaTime:deltaTime andCurrentNote:currentNote];
            
            [self changeSelfDeltaTimeForNote:currentNote withDeltaTime:currentNote.noteDeltaTime];
            
//            NSLog(@"1改变前%@---%f", currentNote.finalNoteData, currentNote.noteDeltaTime - (self.tmpSentenceTime - sentenceTime));
            
            if (currentNote.noteDeltaTime - (self.tmpSentenceTime-sentenceTime) <= 0) {

                if (index < self.noteViewArray.count) {
                    NoteView *lastNote = self.noteViewArray[index-1];
                    for (NoteView *noteView in self.noteViewArray) {
                        if (noteView.noteDeltaTime > (self.tmpSentenceTime-sentenceTime)*2) {
                            noteView.noteDeltaTime = noteView.noteDeltaTime - (self.tmpSentenceTime-sentenceTime);
                            [self changeSelfDeltaTimeForNote:noteView withDeltaTime:lastNote.noteDeltaTime];
                            break;
                        }
                    }
//                    lastNote.noteDeltaTime = lastNote.noteDeltaTime - (self.tmpSentenceTime-sentenceTime);
                }
            } else {
                currentNote.noteDeltaTime = currentNote.noteDeltaTime - (self.tmpSentenceTime-sentenceTime);
                [self changeSelfDeltaTimeForNote:currentNote withDeltaTime:currentNote.noteDeltaTime];
            }
//            NSLog(@"1改变后%@", currentNote.finalNoteData);
        } else if (self.tmpSentenceTime < sentenceTime) {
            
             NSLog(@"*****************************越界****************************");
            
            currentNote.finalNoteData = [self clumDeltaDataWithDeltaTime:deltaTime andCurrentNote:currentNote];
//            NSLog(@"2改变前%@", currentNote.finalNoteData);
            currentNote.noteDeltaTime = currentNote.noteDeltaTime + (sentenceTime - self.tmpSentenceTime);
            [self changeSelfDeltaTimeForNote:currentNote withDeltaTime:currentNote.noteDeltaTime];
//            NSLog(@"2改变后%@", currentNote.finalNoteData);
        } else if (self.tmpSentenceTime == sentenceTime) {
            currentNote.finalNoteData = [self clumDeltaDataWithDeltaTime:deltaTime andCurrentNote:currentNote];
//            NSLog(@"3改变后%@", currentNote.finalNoteData);
        }
#endif
    }
}
/*
 <4d546864 00000006 00010003 01e04d54 726b0000 004200ff 01177072 6f647563 65645f62 795f574f 59414f58 49454745 2e00ff03 0a574f59 414f5849 45474500 ff510306 8a1b00ff 58040402 180800ff 59020000 00ff2f00 4d54726b 000000bd 00c00000 90347898 41803400 00903578 81708035 00009034 78817080 34000090 32788170 80320000 9034787f 6f803400 00903278 85508032 00009030 78817080 30000090 32788740 80320000 90377887 40803700 00903c78 8550803c 00817090 3c788360 803c0000 903b7883 60803b00 00903978 87408039 00009040 78874080 40000090 3c788550 803c0081 70903978 83608039 00009035 788b2080 35000090 32788550 80320000 90327881 70803200 00903078 85508030 0000ff2f 004d5472 6b000000 0700c100 00ff2f00>
 */
- (void)changeSelfDeltaTimeForNote:(NoteView *)noteView withDeltaTime:(UInt32)deltaTime{
    if (!noteView.noteData) {
        return;
    }
    //<903778 8268 803700 00>
    /**
     *  这两个是将音符数据除去中间的deltatime后的数据
     */
    NSData *leftData = nil;
    NSData *rightData = nil;
    NSData *endData = nil;
    NSMutableData *tmpNoteData = [[NSMutableData alloc] init];
    //<906a8094 6a803400 00>
    for (NSInteger i = 0; i < noteView.finalNoteData.length; i++) {
        UInt8 value = 0;
        [noteView.finalNoteData getBytes:&value range:NSMakeRange(i, sizeof(value))];
        if (value == CHANNEL_NOTE_ON && leftData == nil) {
            leftData = [noteView.finalNoteData subdataWithRange:NSMakeRange(i, 3)];
        } else if (value == CHANNEL_NOTE_OFF) {
            rightData = [noteView.finalNoteData subdataWithRange:NSMakeRange(i, 3)];
            endData = [noteView.finalNoteData subdataWithRange:NSMakeRange(i+3, noteView.finalNoteData.length-(i+3))];
        }
    }
    noteView.noteDeltaTime = deltaTime;
    
    NSData *oneData = [noteView.finalNoteData subdataWithRange:NSMakeRange(0, 1)];
    void *a = (void *)([oneData bytes]);
    memset(a, 0, 1);
    
    NSMutableData *finalDeltaData = [[NSMutableData alloc] init];
    NSMutableData *deltaMutdata1 = [[NSMutableData alloc] initWithData:oneData];
    NSMutableData *deltaMutdata2 = [[NSMutableData alloc] initWithData:oneData];
    if (deltaTime > 127) {
        // 时长超过128 末位赋值为128
        
        // 整数部分   128^2 * x + 128^0 * y  x是第一位与128的差值 y是余数
        double inter = 0;
        modf(deltaTime/128, &inter);
        
        UInt32 first = 128 + inter;
        UInt32 second = fmod(deltaTime, 128);
        
        // 高位
        void *b = (void *)[deltaMutdata1 bytes];
        memset(b, first, 1);
        // 低位
        void *c = (void *)[deltaMutdata2 bytes];
        memset(c, second, 1);
        
        [finalDeltaData appendData:deltaMutdata1];
        [finalDeltaData appendData:deltaMutdata2];
        
    } else {
        // 时长没有超过128 直接赋值
        void *b = (void *)[deltaMutdata1 bytes];
        memset(b, deltaTime, 1);
        [finalDeltaData appendData:deltaMutdata1];
    }
    //    NSLog(@"deltaTime=%@", finalDeltaData);
    [tmpNoteData appendData:leftData];
    [tmpNoteData appendData:finalDeltaData];
    [tmpNoteData appendData:rightData];
    
    [tmpNoteData appendData:endData];
    //     NSLog(@"改动前%@", self.noteData);
    noteView.finalNoteData = tmpNoteData;
    noteView.noteData = tmpNoteData;
    //     NSLog(@"改动后%@", self.noteData);
}

- (NSData *)clumDeltaDataWithDeltaTime:(UInt32)deltaTime andCurrentNote:(NoteView *)currentNote{
    
    NSMutableData *finalNoteData = [[NSMutableData alloc] init];
    // 占一位字节的二进制 备用
    NSData *oneData = [currentNote.noteData subdataWithRange:NSMakeRange(0, 1)];
    
    void *a = (void *)([oneData bytes]);
    memset(a, 0, 1);
    
    NSMutableData *finalDeltaData = [[NSMutableData alloc] init];
    NSMutableData *deltaMutdata1 = [[NSMutableData alloc] initWithData:oneData];
    NSMutableData *deltaMutdata2 = [[NSMutableData alloc] initWithData:oneData];
    
    if (deltaTime > 127) {
        // 时长超过128 末位赋值为128
        
        // 整数部分   128^2 * x + 128^0 * y  x是第一位与128的差值 y是余数
        double inter = 0;
        modf(deltaTime/128, &inter);
        
        UInt32 first = 128 + inter;
        UInt32 second = fmod(deltaTime, 128);
        
        // 高位
        void *b = (void *)[deltaMutdata1 bytes];
        memset(b, first, 1);
        // 低位
        void *c = (void *)[deltaMutdata2 bytes];
        memset(c, second, 1);
        
        [finalDeltaData appendData:deltaMutdata1];
        [finalDeltaData appendData:deltaMutdata2];
        
    } else {
        // 时长没有超过128 直接赋值
        void *b = (void *)[deltaMutdata1 bytes];
        memset(b, deltaTime, 1);
        [finalDeltaData appendData:deltaMutdata1];
    }
    
    NSData *leftData = nil;
    for (NSInteger i = 0; i < currentNote.finalNoteData.length; i++) {
        UInt8 value = 0;
        [currentNote.finalNoteData getBytes:&value range:NSMakeRange(i, sizeof(value))];
        if (value == CHANNEL_NOTE_OFF) {
            UInt8 value2 = 0;
            [currentNote.finalNoteData getBytes:&value2 range:NSMakeRange(i+2, sizeof(value2))];
            if (value2 == 0x00) {
                leftData = [currentNote.finalNoteData subdataWithRange:NSMakeRange(0, i+3)];
            }
        }
    }
//    NSLog(@"%@", leftData);
    [finalNoteData appendData:leftData];
    [finalNoteData appendData:finalDeltaData];
    return finalNoteData;
}

- (void)mixNoteDataWithIndex:(NSInteger)index {
    
//    if (self.index == index) {
        self.mixSentenceData = nil;
        self.mixSentenceMidiData = nil;
    /**
     ~<90307881 70803000 8170>
     
     +<90307881 70803000 00>
     */
        NSInteger tmpIndex = 0;
        self.tmpSentenceTime = 0;
        for (NoteView *noteView in self.noteViewArray) {
//            NSLog(@"~%@", noteView.finalNoteData);
            [noteView changeSelfDeltaTime];
            
            [self clumNoteDeltatimeWithNoteIndex:tmpIndex++ andNoteView:noteView];
//            NSLog(@"+%@", noteView.finalNoteData);
            [self.mixSentenceData appendData:noteView.finalNoteData];
        }
        NSMutableData *mutData = [[NSMutableData alloc] initWithData:self.sentenceHeadData];
        // 改变音轨块长度 mutData 就是改变后的头块数据
        
        for (NSInteger offset = mutData.length - 7; offset < mutData.length-3; offset++) {
            
            void *a = (void *)([mutData bytes] + offset);
            
            if (offset == mutData.length-3-1) {
                if (self.index == index && index == 0) {
                    memset(a, (int)(self.mixSentenceData.length + 6 + [TYCommonClass sharedTYCommonClass].midiBeforeData.length - 1), 1);
                } else {
                    memset(a, (int)(self.mixSentenceData.length + 6), 1);
                }
            } else {
                memset(a, 0x00, 1);
            }
        }
//        if (self.index == index) {
            [self.mixSentenceMidiData appendData:mutData];
    //        if (self.index == 0) {
    //            [self.mixSentenceMidiData appendData:[TYCommonClass sharedTYCommonClass].midiBeforeData];
    //        } else {
            [self.mixSentenceMidiData appendData:self.zeroData];
    //        }
            [self.mixSentenceMidiData appendData:self.mixSentenceData];
            [self.mixSentenceMidiData appendData:self.sentenceFootData];
//        }
    //    NSLog(@"修改前的二进制%@", self.playMidiData);
    //    NSLog(@"修改后的二进制%@", self.mixSentenceMidiData);
        self.playMidiData = self.mixSentenceMidiData;
        self.senteneData = self.mixSentenceData;
    
//    NSLog(@"-%@", self.senteneData);
//    }
}

- (void)changePitch:(NoteView *)noteView withPitch:(NSInteger)pitch {
    
    if (pitch == self.currentPitch) {
        return;
    }
    // 1-22 分别对应 65-47音高
    /**
     *  去除半音
     */
    if (self.eventsArray.count > noteView.index) {
        XMidiEvent *event = self.eventsArray[noteView.index];
        
        event.noteMessage.note = pitch+12;
        
        [_midiPlayer pause];
        
        event.noteMessage.duration = 0.2;
//        NSLog(@"pitch=%d  before=%ld", event.noteMessage.note, pitch);
        [_midiPlayer playSoundByNote:event.noteMessage
                    byInstrumentType:1
                               event:event];
        if ([PlayAnimatView sharePlayAnimatView].isAnimating) {
            [[PlayAnimatView sharePlayAnimatView] stopAnimating];
        }
        self.currentPitch = pitch;
        
    } else {
        NSLog(@"还未初始化完成");
    }
}
/**
 *  滑动结束后回调改变音高
 *
 *  @param index  当前滑动改变的音符下标
 *  @param pitch  音高
 */
- (void)changePitchWithNoteIndex:(NSInteger)index andPitch:(NSInteger)pitch{
    @try {
        NSInteger openNoteIndex = 0;
        for (NSInteger i = 0; i < self.senteneData.length; i++) {
            
            UInt8 value = 0;
            
            [self.senteneData getBytes:&value range:NSMakeRange(i, sizeof(value))];
            
            if (value == CHANNEL_NOTE_ON) {
                openNoteIndex = i;
            }
        }
    }
    @catch (NSException *exception) {
        LOG_EXCEPTION;
    }
    @finally {
        
    }
}
/**
 *  拖动右边区域
 */
- (void)changeOtherNoteFrame:(NSNotification *)message {
    self.shouldBreak = NO;
    [self performSelectorOnMainThread:@selector(changeByNotifaction:) withObject:message waitUntilDone:YES];
}

- (void)changeByNotifaction:(NSNotification *)message {
    NSInteger sentenceIndex = [message.userInfo[@"sentenceIndex"] integerValue];
//    NSLog(@"sentenceIndex=%ld", (long)sentenceIndex);
    if (sentenceIndex == self.index) {
        if (message.userInfo[@"index"] || message.userInfo[@"translationX"]) {
            NSInteger index = [message.userInfo[@"index"] integerValue];
            NSNumber *translationX = message.userInfo[@"translationX"];
            CGFloat translatFloatValue = [translationX floatValue];
            
            [self changeFrameWithCurrentIndex:index translation:translatFloatValue];
        }
    }
}

- (void)changeFrameWithCurrentIndex:(NSInteger)index translation:(CGFloat)translation {
    @try {
        if (index >= self.sentenceCount || index < 0) {
            return;
        }
        self.moveingIndex = index;
        NoteView *currentNote = nil;
        NoteView *nextNote = nil;
        NoteView *lastNote = nil;
        if (index < self.noteViewArray.count-1) {
            // 拖动的是除了最后一个以外的其他音符，这些音符都有下一个音符
            currentNote = self.noteViewArray[index];
            nextNote = self.noteViewArray[index+1];
        } else if (index == self.noteViewArray.count-1){
            // 拖动的是最后一个音符
            currentNote = self.noteViewArray[index];
        } else {
            return;
        }
        
        if (index > 0) {
            lastNote = self.noteViewArray[index-1];
        }
        self.translationX = translation;
        [self adjustNoteFrameForNoteView:currentNote andNextNote:nextNote andLastNote:lastNote];
    }
    @catch (NSException *exception) {
        LOG_EXCEPTION;
    }
    @finally {
        
    }
}

- (void)adjustNoteFrameForNoteView:(NoteView *)currentNote andNextNote:(NoteView *)nextNote andLastNote:(NoteView *)lastNote{
    
//    NSLog(@"%ld--%f--%ld", (long)currentNote.noteHoriXCount, currentNote.noteWidthYu, (long)currentNote.noteWidthCount);
    // 向右滑动
    if (self.translationX >= 0) {
        [self moveToRightForNoteView:currentNote andNextNote:nextNote andLastNote:lastNote];
    // 向左滑动
    } else {
        [self moveToLeftForNoteView:currentNote andLastNote:lastNote andNextNote:nextNote];
    }
}

- (void)moveToRightForNoteView:(NoteView *)currentNote andNextNote:(NoteView *)nextNote andLastNote:(NoteView *)lastNote{
    CGRect currentFrame = currentNote.frame;
    CGRect nextFrame = nextNote.frame;
    CGRect lastFrame = lastNote.frame;
    
    float inter1 = 0;
    float inter2 = 0;
    float inter3 = 0;
    float inter4 = 0;
    float inter5 = 0;
    float inter6 = 0;
    modff(currentNote.noteHoriXCount, &inter1);
    modff(currentNote.noteWidthCount, &inter2);
    modff(nextNote.noteHoriXCount, &inter3);
    modff(nextNote.noteWidthCount, &inter4);
    modff(lastNote.noteHoriXCount, &inter5);
    modff(lastNote.noteWidthCount, &inter6);
    
    NSInteger currentHoriCount = 0;
    NSInteger currentWidthCount = 0;
    
    NSInteger nextHoriCount = 0;
    NSInteger nextWidthCount = 0;
    
    NSInteger lastHoriCount = 0;
    NSInteger lastWidthCount = 0;
    
    currentHoriCount = inter1;
    currentWidthCount = inter2;
    
    nextHoriCount = inter3;
    nextWidthCount = inter4;
    
    lastHoriCount = inter5;
    lastWidthCount = inter6;
    
    currentNote.noteRightCount = currentHoriCount + currentWidthCount;
    
    
    NSInteger deltaCount = _moveDeltaCount;
    
    if (self.isLeft) {
        if (self.moveingIndex != 0) {
//            currentFrame.origin.x += self.minNoteWidth;
            currentHoriCount += deltaCount;
            if ([currentNote.lyricStr isEqualToString:TY_YANYIN]) {
                lastWidthCount += deltaCount;
            }
            
        } else {
            return;
        }
    } else {
        currentWidthCount += deltaCount;
//        currentFrame.size.width += self.minNoteWidth;
    }
    
    if (nextNote) {
        if (currentNote.noteRightCount >= nextNote.noteHoriXCount) {
//            nextFrame.origin.x += self.minNoteWidth;
            nextHoriCount += deltaCount;
            if ([self moveToRightShouldChangeCount:nextNote.noteWidthCount]) {
//                nextFrame.size.width -= self.minNoteWidth;
                nextWidthCount -= deltaCount;
            }
        }
    } else {
        if (self.isLeft && currentNote.noteWidthCount <= 1) {
            return;
        }
        if (currentNote.noteRightCount >= [TYCommonClass sharedTYCommonClass].horiNoteCount) {
            return;
        }
    }
    if (self.shouldBreak) {
        return;
    }
    
    if (currentWidthCount < 1) {
        currentWidthCount = 1;
        nextHoriCount += deltaCount;
    }
//    if (nextWidthCount < 1) {
//        nextWidthCount = 1;
//    }
    
    if (currentHoriCount + currentWidthCount > nextHoriCount && currentWidthCount > 1 && nextNote) {
        if ([TYCommonClass sharedTYCommonClass].showTyType == EightOneType && currentHoriCount + currentWidthCount - nextHoriCount == 1) {
            // 如果相距一个单位长度(半个格子) 因为增加一次是增加两个单位长度 所以这里判断超出，这里做处理
            currentWidthCount -= 1;
        } else {
            currentWidthCount -= deltaCount;
        }
    }
    /**
     *  变化值
     */
    NSInteger currentHoriCount1 = 0;
    NSInteger currentWidthCount1 = 0;
    
    NSInteger nextHoriCount1 = 0;
    NSInteger nextWidthCount1 = 0;
    
    NSInteger lastHoriCount1 = 0;
    NSInteger lastWidthCount1 = 0;
    
    lastHoriCount1 =  lastHoriCount - lastNote.noteHoriXCount;
    lastWidthCount1 = lastWidthCount - lastNote.noteWidthCount;
    currentHoriCount1 = currentHoriCount - currentNote.noteHoriXCount;
    currentWidthCount1 = currentWidthCount - currentNote.noteWidthCount;
    nextHoriCount1 = nextHoriCount - nextNote.noteHoriXCount;
    nextWidthCount1 = nextWidthCount - nextNote.noteWidthCount;
    
    /**
     *  最终用来计算frame的值
     */
    NSInteger currentHoriCount2 = 0;
    NSInteger currentWidthCount2 = 0;
    
    NSInteger nextHoriCount2 = 0;
    NSInteger nextWidthCount2 = 0;
    
    NSInteger lastHoriCount2 = 0;
    NSInteger lastWidthCount2 = 0;
    
    
    lastHoriCount2 = lastNote.noteHoriXCount  + lastHoriCount1;
    lastWidthCount2 = lastNote.noteWidthCount + lastWidthCount1;
    currentHoriCount2 = currentNote.noteHoriXCount + currentHoriCount1;
    currentWidthCount2 = currentNote.noteWidthCount  + currentWidthCount1;
    nextHoriCount2 = nextNote.noteHoriXCount  + nextHoriCount1;
    nextWidthCount2 = nextNote.noteWidthCount + nextWidthCount1;
    
//    NSLog(@"%d-%d", currentHoriCount2, currentWidthCount2);
    
    if (lastWidthCount2 < 1) {
        lastWidthCount2 = 1;
    }
    if (currentWidthCount2 < 1) {
        currentWidthCount2 = 1;
    }
    if (nextWidthCount2 < 1) {
        nextWidthCount2 = 1;
    }
    /**
     *  计算frame
     */
    currentFrame.origin.x = currentHoriCount2 * self.minNoteWidth * 0.5;
    currentFrame.size.width = currentWidthCount2 * self.minNoteWidth * 0.5;
    
    nextFrame.origin.x = nextHoriCount2 * self.minNoteWidth * 0.5;
    nextFrame.size.width = nextWidthCount2 * self.minNoteWidth * 0.5;
    
    lastFrame.size.width = lastWidthCount2 * self.minNoteWidth * 0.5;
    lastFrame.origin.x = lastHoriCount2 * self.minNoteWidth * 0.5;
    
    lastNote.frame = lastFrame;
    currentNote.frame = currentFrame;
    nextNote.frame = nextFrame;
    
    /**
     *  实际值
     */
    lastNote.noteHoriXCount = lastHoriCount;
    lastNote.noteWidthCount = lastWidthCount;
    currentNote.noteHoriXCount = currentHoriCount;
    currentNote.noteWidthCount = currentWidthCount;
    nextNote.noteHoriXCount = nextHoriCount;
    nextNote.noteWidthCount = nextWidthCount;
}
- (BOOL)moveToRightShouldChangeCount:(NSInteger)noteCount {
    if (noteCount <= _moveDeltaCount) {
        [self adjustMoveToRightWithIndex:self.moveingIndex + 1];
        return NO;
    } else {
        return YES;
    }
}
/**
 *  当前拖动音符后边的所有音符 根据前一个音符位置 适应自身位置
 *  (该方法在拖动音符下一个音符的宽度等于最小宽度的时候调用)
 */
- (void)adjustMoveToRightWithIndex:(NSInteger)index {
    
    // 处理除了最后一个音符外的音符
    if (index < self.noteViewArray.count - 1) {
        NoteView *currentNote = self.noteViewArray[index];
        if ([self jugeNullWithObject:currentNote]) {
            NSLog(@"currentNote为空");
            return;
        }
//        CGRect currentFrame = currentNote.frame;
        NoteView *nextNote = self.noteViewArray[index+1];
        if ([self jugeNullWithObject:nextNote]) {
            NSLog(@"nextNote为空");
            return;
        }
        
//        NSInteger currentHoriCount = currentNote.noteHoriXCount;
//        NSInteger currentWidthCount = currentNote.noteWidthCount;
        
        float inter1 = 0;
        float inter2 = 0;

        modff(nextNote.noteHoriXCount, &inter1);
        modff(nextNote.noteWidthCount, &inter2);
        
        NSInteger nextHoriCount = inter1;
        NSInteger nextWidthCount = inter2;
        
        currentNote.noteRightCount = currentNote.noteWidthCount + currentNote.noteHoriXCount;
        
        CGRect nextFrame = nextNote.frame;
        
        
        if (currentNote.noteRightCount >= nextNote.noteHoriXCount) {
            
            if (nextNote.noteWidthCount <= _moveDeltaCount) {
                [self adjustMoveToRightWithIndex:++index];
            } else {
                nextWidthCount -= _moveDeltaCount;
            }
            nextHoriCount += _moveDeltaCount;
        }
        
        // 八分音符模式下遇到一半音符
        if ([TYCommonClass sharedTYCommonClass].showTyType == EightOneType && nextNote.noteHoriXCount - currentNote.noteRightCount == 1) {
            if (nextNote.noteWidthCount <= _moveDeltaCount) {
                [self adjustMoveToRightWithIndex:++index];
            } else {
                nextWidthCount -= 1;
            }
            nextHoriCount += 1;
        }
        
        
        if (self.shouldBreak) {
            return;
        }
        if (nextWidthCount < 1) {
            nextWidthCount = 1;
        }
//        currentFrame.origin.x = currentHoriCount * self.minNoteWidth;
//        currentFrame.size.width = currentWidthCount * self.minNoteWidth;
        nextFrame.origin.x = nextHoriCount * self.minNoteWidth * 0.5;
        nextFrame.size.width = nextWidthCount * self.minNoteWidth * 0.5;
        
        nextNote.frame = nextFrame;
//        currentNote.frame = currentFrame;
        
        nextNote.noteHoriXCount = nextHoriCount;
        nextNote.noteWidthCount = nextWidthCount;
        
        // 已经处理到最后一个音符
    } else if (index == self.noteViewArray.count - 1) {
        
        NoteView *currentNote = self.noteViewArray[index];
        CGRect currentFrame = currentNote.frame;
        
        float inter1 = 0;
    
        modff(currentNote.noteWidthCount, &inter1);
        
        currentNote.noteRightCount = currentNote.noteHoriXCount + currentNote.noteWidthCount;
        NSInteger currentWidthCount = inter1;
        
        if (currentNote.noteRightCount >= [TYCommonClass sharedTYCommonClass].horiNoteCount) {
            self.shouldBreak = YES;
            return;
        } else {
            if (currentNote.noteWidthCount > _moveDeltaCount) {
                currentWidthCount -= _moveDeltaCount;
//                currentFrame.size.width -= self.minNoteWidth;
            }
        }
        if (self.shouldBreak) {
            return;
        }
        if (currentWidthCount < 1) {
            currentWidthCount = 1;
        }
       

        currentFrame.size.width = currentWidthCount * self.minNoteWidth * 0.5;

        currentNote.noteWidthCount = currentWidthCount;
        currentNote.frame = currentFrame;
    }
}

- (BOOL)jugeNullWithObject:(id)object {
    
    if ([object isEqual:[NSNull null]] || object == nil) {
        return YES;
    } else if ([object isKindOfClass:[NSString class]]) {
        if ([object isEqualToString:@""]) {
            return YES;
        } else {
            return NO;
        }
    } else {
        return NO;
    }
}

- (void)leftNoteView:(NoteView *)currentNote andLastNote:(NoteView *)lastNote {
    NSInteger currentHoriCount = currentNote.noteHoriXCount;
    NSInteger currentWidthCount = currentNote.noteWidthCount;
    
    NSInteger lastHoriCount = lastNote.noteHoriXCount;
    NSInteger lastWidthCount = lastNote.noteWidthCount;
    
    lastNote.noteRightCount = lastHoriCount + lastWidthCount;
    
}

- (void)moveToLeftForNoteView:(NoteView *)currentNote andLastNote:(NoteView *)lastNote andNextNote:(NoteView *)nextNote{
    CGRect currentFrame = currentNote.frame;
    CGRect lastFrame = lastNote.frame;
    CGRect nextFrame = nextNote.frame;
    
    
    float inter1 = 0;
    float inter2 = 0;
    float inter3 = 0;
    float inter4 = 0;
    float inter5 = 0;
    float inter6 = 0;
    modff(currentNote.noteHoriXCount, &inter1);
    modff(currentNote.noteWidthCount, &inter2);
    modff(nextNote.noteHoriXCount, &inter3);
    modff(nextNote.noteWidthCount, &inter4);
    modff(lastNote.noteHoriXCount, &inter5);
    modff(lastNote.noteWidthCount, &inter6);
    
    
    NSInteger currentHoriCount = inter1;
    NSInteger currentWidthCount = inter2;
    
    NSInteger nextHoriCount = inter3;
    NSInteger nextWidthCount = inter4;
    
    NSInteger lastHoriCount = inter5;
    NSInteger lastWidthCount = inter6;
    
    
    
    if (lastNote) {
        
        lastNote.noteRightCount = lastHoriCount + lastWidthCount;
        
        if (self.isLeft) {
            
            if (lastNote.noteRightCount >= currentHoriCount) {
                
                if ([self moveToLeftShouldChangeCount:lastWidthCount]) {
                    lastWidthCount -= _moveDeltaCount;
//                    lastFrame.size.width -= self.minNoteWidth;
                } else {
                    lastHoriCount -= _moveDeltaCount;
//                    lastFrame.origin.x -= self.minNoteWidth;
                }
            }
            
            
//            currentFrame.origin.x -= self.minNoteWidth;
            if ([TYCommonClass sharedTYCommonClass].showTyType == EightOneType && currentHoriCount - lastNote.noteRightCount == 1) {
                currentHoriCount -= 1;
            } else {
                currentHoriCount -= _moveDeltaCount;
            }
            if ([nextNote.lyricStr isEqualToString:TY_YANYIN]) {
                nextHoriCount -= _moveDeltaCount;
                nextWidthCount += _moveDeltaCount;
            }
            if (self.shouldBreak) {
                return;
            }
        } else {
            
            if (currentWidthCount > _moveDeltaCount) {
//                currentFrame.size.width -= self.minNoteWidth;
                currentWidthCount -= _moveDeltaCount;
                if ([nextNote.lyricStr isEqualToString:TY_YANYIN]) {
                    nextHoriCount -= _moveDeltaCount;
                    nextWidthCount += _moveDeltaCount;
                }
            }
            // 当前音符缩短到最小宽度
            else {
                // 上一个音符宽度可以缩短
                if (lastNote.noteRightCount >= currentHoriCount) {
                    if ([self moveToLeftShouldChangeCount:lastWidthCount]) {
                        lastWidthCount -= _moveDeltaCount;
//                        lastFrame.size.width -= self.minNoteWidth;
                    } else {
                        lastHoriCount -= _moveDeltaCount;
//                        lastFrame.origin.x -= self.minNoteWidth;
                    }
                }
                if ([TYCommonClass sharedTYCommonClass].showTyType == EightOneType && currentHoriCount - lastNote.noteRightCount == 1) {
                    currentHoriCount -= 1;
                } else {
                    currentHoriCount -= _moveDeltaCount;
                }
                if ([nextNote.lyricStr isEqualToString:TY_YANYIN]) {
                    nextHoriCount -= _moveDeltaCount;
                    nextWidthCount += _moveDeltaCount;
                }
//                currentFrame.origin.x -= self.minNoteWidth;
                if (self.shouldBreak) {
                    return;
                }
            }
        }
    } else {
        if (self.isLeft) {
            currentHoriCount -= _moveDeltaCount;
            if ([nextNote.lyricStr isEqualToString:TY_YANYIN]) {
                nextHoriCount -= _moveDeltaCount;
                nextWidthCount += _moveDeltaCount;
            }
//            currentFrame.origin.x -= self.minNoteWidth;
            if (currentHoriCount <= 0) {
                return;
            }
        } else {
            if (currentWidthCount > _moveDeltaCount) {
                currentWidthCount -= _moveDeltaCount;
                if ([nextNote.lyricStr isEqualToString:TY_YANYIN]) {
                    nextHoriCount -= _moveDeltaCount;
                    nextWidthCount += _moveDeltaCount;
                }
//                currentFrame.size.width -= self.minNoteWidth;
            } else {
                currentHoriCount -= _moveDeltaCount;
                if ([nextNote.lyricStr isEqualToString:TY_YANYIN]) {
                    nextHoriCount -= _moveDeltaCount;
                    nextWidthCount += _moveDeltaCount;
                }
//                currentFrame.origin.x -= self.minNoteWidth;
                if (currentHoriCount <= 0) {
                    return;
                }
            }
        }
    }
//    NSLog(@"%ld-%ld   %ld-%ld", currentNote.noteHoriXCount, currentNote.noteWidthCount, currentHoriCount, currentWidthCount);
    
//    if (currentWidthCount < 1) {
//        currentWidthCount = 1;
//    }
//    if (lastWidthCount < 1) {
//        lastWidthCount = 1;
//    }
    nextFrame.origin.x = nextHoriCount * self.minNoteWidth * 0.5;
    nextFrame.size.width = nextWidthCount * self.minNoteWidth * 0.5;
    
    currentFrame.origin.x = currentHoriCount * self.minNoteWidth * 0.5;
    currentFrame.size.width = currentWidthCount * self.minNoteWidth * 0.5;
    
    lastFrame.origin.x = lastHoriCount * self.minNoteWidth * 0.5;
    lastFrame.size.width = lastWidthCount * self.minNoteWidth * 0.5;
    
    nextNote.frame = nextFrame;
    currentNote.frame = currentFrame;
    lastNote.frame = lastFrame;
    currentNote.noteHoriXCount = currentHoriCount;
    currentNote.noteWidthCount = currentWidthCount;
    
    lastNote.noteHoriXCount = lastHoriCount;
    lastNote.noteWidthCount = lastWidthCount;
    
    nextNote.noteHoriXCount = nextHoriCount;
    nextNote.noteWidthCount = nextWidthCount;
    
}
- (BOOL)moveToLeftShouldChangeCount:(NSInteger)noteCount {
    if (noteCount <= _moveDeltaCount) {
        [self adjustMoveToLeftWithIndex:self.moveingIndex-1];
        return NO;
    } else {
        return YES;
    }
}
/**
 *  这个方法之后的问题
 */
- (void)adjustMoveToLeftWithIndex:(NSInteger)index {
    self.moveingIndex = index;
    if (index > 0) {
        NoteView *currentNote = self.noteViewArray[index];
        NoteView *lastNote = self.noteViewArray[index-1];
        
        float inter1 = 0;
        float inter2 = 0;
        float inter5 = 0;
        float inter6 = 0;
        modff(currentNote.noteHoriXCount, &inter1);
        modff(currentNote.noteWidthCount, &inter2);

        modff(lastNote.noteHoriXCount, &inter5);
        modff(lastNote.noteWidthCount, &inter6);

        
        NSInteger currentHoriCount = inter1;
        NSInteger currentWidthCount = inter1;
        
        NSInteger lastHoriCount = inter5;
        NSInteger lastWidthCount = inter6;
        
        lastNote.noteRightCount = lastHoriCount + lastWidthCount;
        //        CGRect currentFrame = currentNote.frame;
        CGRect lastFrame = lastNote.frame;
        
        
        
        if (lastNote.noteRightCount >= currentHoriCount) {
            
            if (lastWidthCount <= _moveDeltaCount) {
//                lastFrame.origin.x -= self.minNoteWidth;
                lastHoriCount -= _moveDeltaCount;
                
                [self adjustMoveToLeftWithIndex:index-1];
                
            } else {
//                lastFrame.size.width -= self.minNoteWidth;
                lastWidthCount -= _moveDeltaCount;
            }
        }
        
        
        if ([TYCommonClass sharedTYCommonClass].showTyType == EightOneType && currentHoriCount - lastNote.noteRightCount == 1) {
            if (lastWidthCount <= _moveDeltaCount) {
                //                lastFrame.origin.x -= self.minNoteWidth;
                lastHoriCount -= 1;
                
                [self adjustMoveToLeftWithIndex:index-1];
                
            } else {
                //                lastFrame.size.width -= self.minNoteWidth;
                lastWidthCount -= 1;
            }
        }
        
        if (self.shouldBreak) {
//            NSLog(@"end2");
            return;
        }
//        if (lastWidthCount < 1) {
//            lastWidthCount = 1;
//        }
        
        lastFrame.origin.x = lastHoriCount * self.minNoteWidth * 0.5;
        lastFrame.size.width = lastWidthCount * self.minNoteWidth * 0.5;
        lastNote.noteHoriXCount = lastHoriCount;
        lastNote.noteWidthCount = lastWidthCount;
        lastNote.frame = lastFrame;
    } else if (index == 0) {
        NoteView *currentNote = self.noteViewArray[index];
        
        float inter1 = 0;
        float inter2 = 0;
        float inter5 = 0;
        float inter6 = 0;
        modff(currentNote.noteHoriXCount, &inter1);
        modff(currentNote.noteWidthCount, &inter2);
        
        NSInteger currentHoriCount = inter1;
        NSInteger currentWidthCount = inter2;
        CGRect currentFrame = currentNote.frame;
        
        currentWidthCount -= _moveDeltaCount;
//        currentFrame.size.width -= self.translationX;
        if (currentWidthCount < _moveDeltaCount) {
            self.shouldBreak = YES;
            return;
        }
//        if (currentWidthCount < 1) {
//            currentWidthCount = 1;
//        }
        currentFrame.origin.x = currentHoriCount * self.minNoteWidth * 0.5;
        currentFrame.size.width = currentWidthCount * self.minNoteWidth * 0.5;
        currentNote.noteWidthCount = currentWidthCount;
        currentNote.frame = currentFrame;
    }
}
- (void)setSentenceLyric:(NSString *)sentenceLyric {
    _sentenceLyric = sentenceLyric;
    if (!_sentenceLyric || _sentenceLyric.length <= 0) {
        return;
    }
    for (NSInteger i = 0; i < self.noteViewArray.count; i++) {
        if (i >= self.noteViewArray.count) {
            return;
        }
        NoteView *noteView = self.noteViewArray[i];
        NSString *str = nil;
        if (i < _sentenceLyric.length) {
            str = [_sentenceLyric substringWithRange:NSMakeRange(i, 1)];
        }
        noteView.lyricStr = str;
    }
}

#pragma mark - XMidiPlayerDelegate
//播放进度变化 progress是一个0～1的一个小数，代表进度百分比
- (void)progressChanged:(double)progress noteMessage:(XMidiNoteMessage *)message {
//    NSLog(@"%ld--%ld", [TYCommonClass sharedTYCommonClass].currentPlaySentence, self.index);
    if ([TYCommonClass sharedTYCommonClass].currentPlaySentence == self.index) {
//        CGFloat currentX = self.bounds.size.width * progress + [TYCommonClass sharedTYCommonClass].noteMinWidth;
        
//        if (self.beginScrollBlock) {
//            self.beginScrollBlock(currentX);
//        }
        
        if (progress == 1.0f) {
            [self performSelector:@selector(hideMask) withObject:nil afterDelay:1];
        }
    }
}
- (void)hideMask {
    [[PlayAnimatView sharePlayAnimatView] stopAnimating];
    [self.lastShowNoteView hideMaskView];
}

@end
