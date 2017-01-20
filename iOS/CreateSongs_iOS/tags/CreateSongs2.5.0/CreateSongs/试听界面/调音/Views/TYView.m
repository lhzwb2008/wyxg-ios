//
//  TYView.m
//  SentenceMidiChange
//
//  Created by axg on 16/5/9.
//  Copyright © 2016年 axg. All rights reserved.
// ;

#import "TYView.h"
#import "TYCommonClass.h"
#import "MidiParserManager.h"
#import "SentenceMessage.h"
#import "SentenceView.h"
#import "UIColor+expanded.h"
#import "TYHeader.h"
#import "PlayViewController.h"
#import "SCSiriWaveformView.h"
#import "PlayAnimatView.h"
#import "TYCache.h"
#import "AXGHeader.h"
#import "TYLeftPitchView.h"
#import "Masonry.h"
#import "TYSentenceChangeBtn.h"
#import "TY_SHITING_4s_BTN.h"

@interface TYView ()<UIScrollViewDelegate>
@property (nonatomic, strong) NSMutableArray *tyViewArray;
@property (nonatomic, assign) CGFloat noteWidth;
@property (nonatomic, assign) CGFloat noteHeight;
@property (nonatomic, strong) SentenceView *lastSentenceView;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, strong) NSData *finalMixData;

@property (nonatomic, strong) UIScrollView *thumbScrollView;

@property (nonatomic, strong) UIImageView *thumbImageView;

@property (nonatomic, strong) CAGradientLayer *gradientLayer;

@property (nonatomic, strong) TYLeftPitchView *leftPitchView;

@property (nonatomic, assign) CGFloat thumbWidth;

@property (nonatomic, assign) BOOL tyViewIsDrag;

// 八分音符线
@property (nonatomic, strong) NSMutableArray *eightLines;
// 十六分音符线
@property (nonatomic, strong) NSMutableArray *sixLines;
// 记录调音滚动视图的偏移量
@property (nonatomic, assign) CGFloat tyScrollOffsetX;
// 是否是点击右上角的改变音符类型按钮  如果是 则scrollViewDidScroll 方法里边不实现
@property (nonatomic, assign) BOOL isClickRightBtn;

@end

//#define THUMB_WIDTH [[UIScreen mainScreen] bounds].size.width * 3 / 4

@implementation TYView

- (NSMutableArray *)eightLines {
    if (_eightLines == nil) {
        _eightLines = [NSMutableArray array];
    }
    return _eightLines;
}

- (NSMutableArray *)sixLines {
    if (_sixLines == nil) {
        _sixLines = [NSMutableArray array];
    }
    return _sixLines;
}

- (void)registNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(beginPlay) name:@"beginPlayMidiSetOffset" object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connotShowNote) name:@"connotShowNoteNoti" object:nil];
    // 混音结束
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mixMidiDone) name:MIX_MIDI_DONE object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clickDoneBtn) name:COMPLET_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(tyTypeChange) name:TY_TYPE_CHANGE object:nil];
}

- (void)beginPlay {
    
    [self.thumbScrollView setContentOffset:CGPointMake(self.thumbScrollView.width-self.thumbWidth, 0) animated:YES];
    [self.tyScrollView setContentOffset:CGPointZero animated:YES];
}

- (void)connotShowNote {
    self.tyViewIsDrag = YES;
    
//    [self.thumbScrollView setContentOffset:CGPointMake(self.thumbScrollView.width-self.thumbWidth, 0) animated:YES];
    [self.tyScrollView setContentOffset:CGPointMake(self.tyScrollView.contentSize.width-self.tyScrollView.width, 0) animated:YES];
    
    [self scrollViewDidScroll:self.tyScrollView];
}

- (void)removeNoti {
//    [[NSNotificationCenter defaultCenter] removeObserver:self name:COMPLET_NOTI object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:MIX_MIDI_DONE object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"beginPlayMidiSetOffset" object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"connotShowNoteNoti" object:nil];
}

- (void)mixMidiDone {
    NSMutableData *finalPlayMidi = [[NSMutableData alloc] init];
    
    NSMutableData *newMidiData = [[NSMutableData alloc] init];
    
    for (NSInteger i = 0; i < self.tyViewArray.count; i++) {
        
        SentenceView *sentenceView = self.tyViewArray[i];
        if (i == 0) {
            
        }
        UInt8 tmpValue = 0;
        if (sentenceView.senteneData.length > 0) {
            [sentenceView.senteneData getBytes:&tmpValue range:NSMakeRange(0, sizeof(tmpValue))];
        } else {
            return;
        }
    
        // 如果第一个字节是0的话去除第一个(这里是为了防止意外)
        if (tmpValue == 0) {
            NSLog(@"首位出现0x00已去除");
            if (sentenceView.senteneData.length > 1) {
                NSRange range = NSMakeRange(1, sentenceView.senteneData.length-1);
                sentenceView.senteneData = [sentenceView.senteneData subdataWithRange:range];
            } else {
                NSLog(@"没有获取到二进制数据");
            }
        }
        [newMidiData appendData:sentenceView.senteneData];
    }

#warning TotalTimeWrong如果总时长超出两位十六进制，在这里进行处理
    // 改变音轨块长度 mutData 就是改变后的头快数据
    NSMutableData *mutData = [[NSMutableData alloc] initWithData:[TYCommonClass sharedTYCommonClass].headData];
    for (NSInteger offset = mutData.length - 7; offset < mutData.length-3; offset++) {
        void *a = (void *)([mutData bytes] + offset);
        if (offset == mutData.length-3-1) {
            if (newMidiData.length + 6 + 1 > 255) {
                void *b = (void *)([mutData bytes] + offset-1);
                memset(b, (int)(255-newMidiData.length-7), 1);
                memset(a, 0xff, 1);
            } else {
                memset(a, (int)(newMidiData.length + 6 + 1), 1);
            }
        } else {
            memset(a, 0x00, 1);
        }
    }
    [finalPlayMidi appendData:mutData];
    [finalPlayMidi appendData:[TYCommonClass sharedTYCommonClass].midiBeforeData];
    [finalPlayMidi appendData:newMidiData];
    [finalPlayMidi appendData:[TYCommonClass sharedTYCommonClass].footData];
    [PlayViewController sharePlayVC].midiData = finalPlayMidi;
//    [TYCache setObject:finalPlayMidi forKey:@"修改后.mid"];
}

- (void)pausePlayMidi {
    for (SentenceView *sentenceView in self.tyViewArray) {
        [sentenceView stopPlayMidi];
    }
}

- (void)clickDoneBtn {
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.song_tag = @"改曲";
    
    [[PlayAnimatView sharePlayAnimatView] stopAnimating];
    [[NSUserDefaults standardUserDefaults] setObject:@"moreMode" forKey:@"musicMode"];
    [TYCommonClass sharedTYCommonClass].sentencCount = self.tyViewArray.count;
//    for (NSInteger i = 0; i < self.tyViewArray.count; i++) {
//        
//        [[NSNotificationCenter defaultCenter] postNotificationName:MIX_DATA object:nil userInfo:@{@"currentIndex":[NSString stringWithFormat:@"%ld", (long)i]}];
//    }
    NSInteger i = 0;
    for (SentenceView *sentenceView in self.tyViewArray) {
        [sentenceView mixPlayMidi:i++];
    }
}

- (void)dealloc {
    [self removeNoti];
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registNoti];
        
        [TYCommonClass sharedTYCommonClass].showTyType = EightOneType;
//        self.gradientLayer = [CAGradientLayer layer];
//        self.gradientLayer.frame = self.bounds;
//        self.gradientLayer.startPoint = CGPointMake(0, 1);
//        self.gradientLayer.endPoint = CGPointMake(0, 0);
//  http://bbs.feng.com/plugin.php?id=attachment_download:tongji&aid=11375253&name=iOS_beta_Configuration_Profile.mobileconfig&server=http://att4.weiphone.net&url=201601/12/025901twsfmexjpxvwbwue.attach
//        self.gradientLayer.colors = @[(__bridge id)[UIColor colorWithHexString:@"#2e7bca"].CGColor,
//                                      (__bridge id)[UIColor colorWithHexString:@"#3982cd"].CGColor];
//        self.gradientLayer.locations = @[@(0.0f), @(1.0f)];
//    
//        [self.layer addSublayer:self.gradientLayer];
        
        self.backgroundColor = TY_BOTTOM_COLOR;
        
        [TYCommonClass sharedTYCommonClass].horiNoteCount = 16*2;
        [TYCommonClass sharedTYCommonClass].noteMinWidth = [[UIScreen mainScreen] bounds].size.width / 13;
        [TYCommonClass sharedTYCommonClass].noteHeight = [[UIScreen mainScreen] bounds].size.width / 13;
        [TYCommonClass sharedTYCommonClass].tyViewWidth = [TYCommonClass sharedTYCommonClass].noteMinWidth * 16;
    
        self.noteWidth = [TYCommonClass sharedTYCommonClass].noteHeight;
        self.noteHeight = self.noteWidth;
        
        NSData *data = [TYCommonClass sharedTYCommonClass].midiData;
//        NSString *path = [[NSBundle mainBundle] pathForResource:@"修改后" ofType:@"mid"];
//        NSData *data = [[NSData alloc] initWithContentsOfFile:path];
        
//        CGRect tyBgRect = CGRectMake(0, 0, frame.size.width, self.noteHeight * 12);
        
        /*
         * 左边音高视图
         */
        self.leftPitchView = [[TYLeftPitchView alloc] initWithFrame:CGRectMake(0, 0, self.noteWidth+2, self.noteHeight * 16+2)];
        self.leftPitchView.backgroundColor = TY_LINE_COLOR;
        [self addSubview:self.leftPitchView];
        
        
        CGRect tyViewRect = CGRectMake(self.leftPitchView.right, self.leftPitchView.top, [TYCommonClass sharedTYCommonClass].tyViewWidth, self.leftPitchView.height);
        self.tyScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(self.leftPitchView.right, self.leftPitchView.top, [[UIScreen mainScreen] bounds].size.width - self.leftPitchView.right, self.leftPitchView.height)];
        self.tyScrollView.contentSize = CGSizeMake(tyViewRect.size.width, 0);
        self.tyScrollView.contentOffset = CGPointMake(0, 0);
        self.tyScrollView.showsHorizontalScrollIndicator = NO;
        self.tyScrollView.showsVerticalScrollIndicator = NO;
        self.tyScrollView.panGestureRecognizer.minimumNumberOfTouches = 2;
//        self.tyScrollView.backgroundColor = [UIColor redColor];
        self.tyScrollView.backgroundColor = TY_TOP_BGCOLOR;
        self.tyScrollView.delegate = self;
        [self addSubview:self.tyScrollView];
        
        
        self.thumbWidth = self.frame.size.width - (self.tyScrollView.contentSize.width - self.tyScrollView.width);
        
        self.thumbScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, self.tyScrollView.bottom, self.frame.size.width, 25)];
        self.thumbScrollView.delegate = self;
        self.thumbScrollView.backgroundColor = [UIColor colorWithHexString:@"#1a242e"];
        self.thumbScrollView.contentSize = CGSizeMake(self.thumbScrollView.width * 2- self.thumbWidth, 0);
        self.thumbScrollView.contentOffset = CGPointMake(self.thumbScrollView.width-self.thumbWidth, 0);
        self.thumbScrollView.showsHorizontalScrollIndicator = NO;
        self.thumbScrollView.showsVerticalScrollIndicator = NO;
        self.thumbScrollView.bounces = NO;
        [self addSubview:self.thumbScrollView];
        
        self.thumbImageView = [UIImageView new];
        self.thumbImageView.backgroundColor = TY_THUMB_COLOR;
        self.thumbImageView.autoresizesSubviews = YES;
        self.thumbImageView.frame = CGRectMake(self.thumbScrollView.width -  self.thumbWidth, 0,  self.thumbWidth, self.thumbScrollView.height);
//        self.thumbImageView.frame = CGRectMake(0, 0, self.thumbScrollView.width, self.thumbScrollView.height);
        [self.thumbScrollView addSubview:self.thumbImageView];
        
        UILabel *showThumb = [UILabel new];
        showThumb.backgroundColor = [UIColor clearColor];
        showThumb.frame = CGRectMake(0, 1, self.thumbImageView.width-1, self.thumbImageView.height-2);
//        showThumb.layer.borderWidth = 0.5;
//        showThumb.layer.borderColor = [UIColor colorWithHexString:@"#858789"].CGColor;
        [showThumb setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin];
        [self.thumbImageView addSubview:showThumb];
        
        
        MidiParserManager *parserManager = [MidiParserManager new];
        
        [parserManager parserMidi:data lyricContent:nil];
        
        NSInteger index = 0;
        for (SentenceMessage *sentenceMessage in parserManager.sentenceArray) {
            
            @try {
                SentenceView *sentenceView = [[SentenceView alloc] initWithFrame:CGRectMake(0, 0, tyViewRect.size.width, tyViewRect.size.height) withSentenceMessage:sentenceMessage withSentenceIndex:index];

                [sentenceView setAutoresizesSubviews:YES];
                [sentenceView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
                if (index >= [TYCommonClass sharedTYCommonClass].lyricArray.count) {
//                    NSLog(@"%@", [TYCommonClass sharedTYCommonClass].lyricArray);
                } else {
                    if (index < [TYCommonClass sharedTYCommonClass].lyricArray.count) {
                        sentenceView.sentenceLyric = [TYCommonClass sharedTYCommonClass].lyricArray[index];
                    }
                }
                sentenceView.alpha = 0.0f;
                sentenceView.hidden = YES;
                sentenceView.tag = index;
                WEAK_SELF;
                sentenceView.beginScrollBlock = ^(NSInteger scrollOffsetCount) {
                    STRONG_SELF;
                    [self moveToShowNoteWithPage:scrollOffsetCount];
                };
//                sentenceView.backgroundColor = [UIColor colorWithHexString:@"#2e79c6"];
                index++;
                [self.tyScrollView addSubview:sentenceView];
                [self createLinesForView:sentenceView];
                [self.tyViewArray addObject:sentenceView];
            }
            @catch (NSException *exception) {
                LOG_EXCEPTION;
            }
            @finally {
                
            }
        }
        
        [self bringSubviewToFront:self.leftPitchView];
//        CGFloat tmpHeight = frame.size.height;
        
        NSLog(@"%f", self.height - self.thumbScrollView.bottom);
        
        CGFloat playBtnY = (self.height - self.thumbScrollView.bottom - 85*HEIGHT_NIT) / 2 + self.thumbScrollView.bottom;
        
        CGFloat bottomH = self.height - self.thumbScrollView.bottom;
        
        if (kDevice_Is_iPad || kDevice_Is_iPad3 || kDevice_Is_iPhone4) {
            UILabel *topLine = [UILabel new];
            topLine.backgroundColor = TY_THUMB_COLOR;
            topLine.frame = CGRectMake(0, self.thumbScrollView.bottom, self.width, 0.5);
            [self addSubview:topLine];
            
            UIButton *lastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            lastBtn.frame = CGRectMake(0, topLine.bottom, 75, bottomH-0.5);
            [lastBtn setTitle:@"上一句"];
            [lastBtn addTarget:self action:@selector(lastBtnClick)];
            [lastBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"]];
            lastBtn.titleLabel.font = NORML_FONT(12*WIDTH_NIT);
            lastBtn.backgroundColor = [UIColor clearColor];
            [self addSubview:lastBtn];
            
            UILabel *leftLine = [UILabel new];
            leftLine.backgroundColor = TY_THUMB_COLOR;
            leftLine.frame = CGRectMake(lastBtn.right, topLine.bottom, 0.5, lastBtn.height);
            [self addSubview:leftLine];
            
            UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            nextBtn.frame = CGRectMake(self.width - 75, lastBtn.top, lastBtn.width, lastBtn.height);
            [nextBtn setTitle:@"下一句"];
            [nextBtn addTarget:self action:@selector(nextBtnClick)];
            [nextBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"]];
            nextBtn.backgroundColor = [UIColor clearColor];
            nextBtn.titleLabel.font = lastBtn.titleLabel.font;
            [self addSubview:nextBtn];
            
            UILabel *rightLine = [UILabel new];
            rightLine.backgroundColor = TY_THUMB_COLOR;
            rightLine.frame = CGRectMake(nextBtn.left - 0.5, leftLine.top, leftLine.width, leftLine.height);
            [self addSubview:rightLine];
            
            TY_SHITING_4s_BTN *playBtn = [TY_SHITING_4s_BTN buttonWithType:UIButtonTypeCustom];
            playBtn.frame = CGRectMake(leftLine.right, topLine.bottom, rightLine.left-leftLine.right, lastBtn.height);
            playBtn.backgroundColor = [UIColor clearColor];
            playBtn.titleLabel.font = JIACU_FONT(18*WIDTH_NIT);
            [playBtn setTitle:@"试听"];
            [playBtn setTitleColor:[UIColor colorWithHexString:@"#ffffff"]];
            [playBtn setImage:@"试听icon_4s"];
            [playBtn addTarget:self action:@selector(playBtnClick:)];
            [self addSubview:playBtn];
            
        } else {
            UIButton *playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
            playBtn.frame = CGRectMake(0, playBtnY, 85.5*HEIGHT_NIT, 85.5*HEIGHT_NIT);
            playBtn.centerX = self.width / 2;
            [playBtn setImage:[UIImage imageNamed:@"ty试听icon"] forState:UIControlStateNormal];
            [playBtn addTarget:self action:@selector(playBtnClick:)];
            [self addSubview:playBtn];
            
            CGFloat lastBtnW = 50*HEIGHT_NIT;
            CGFloat lastBtnH = 67.5 * HEIGHT_NIT;
            CGFloat btnGap = (self.width - playBtn.width - 2*lastBtnW) / 4;
            
            TYSentenceChangeBtn *lastBtn = [TYSentenceChangeBtn buttonWithType:UIButtonTypeCustom];
            lastBtn.frame = CGRectMake(btnGap, 0, lastBtnW, lastBtnH);
            lastBtn.centerY = playBtn.centerY;
            [lastBtn setImage:[UIImage imageNamed:@"ty上一句icon"] forState:UIControlStateNormal];
            lastBtn.titleLabel.font = JIACU_FONT(10*HEIGHT_NIT);
            [self addSubview:lastBtn];
            [lastBtn addTarget:self action:@selector(lastBtnClick)];
            
            
            TYSentenceChangeBtn *nextBtn = [TYSentenceChangeBtn buttonWithType:UIButtonTypeCustom];
            nextBtn.frame = CGRectMake(btnGap + playBtn.right, 0, lastBtnW, lastBtnH);
            nextBtn.centerY = playBtn.centerY;
            [nextBtn setImage:[UIImage imageNamed:@"ty下一句icon"] forState:UIControlStateNormal];
            nextBtn.titleLabel.font = JIACU_FONT(10*HEIGHT_NIT);
            [self addSubview:nextBtn];
            [nextBtn addTarget:self action:@selector(nextBtnClick)];
        }
    }
    return self;
}

- (void)lastBtnClick {
    [self pausePlayMidi];
    if (self.tyLastBlock) {
        self.tyLastBlock();
    }
}

- (void)nextBtnClick {
    [self pausePlayMidi];
    if (self.tyNextBlock) {
        self.tyNextBlock();
    }
}

- (void)moveToShowNoteWithPage:(NSInteger)pageCount {
    self.isClickRightBtn = NO;
    self.tyViewIsDrag = YES;
    
    if ([TYCommonClass sharedTYCommonClass].showTyType == EightOneType && pageCount > 1) {
        [self.tyScrollView setContentOffset:CGPointMake(self.tyScrollView.contentSize.width - self.tyScrollView.frame.size.width, 0) animated:YES];
        return;
    }
    switch (pageCount) {
        case 0: {
            [self.tyScrollView setContentOffset:CGPointZero animated:YES];
        }
            break;
        case 1: {
            [self.tyScrollView setContentOffset:CGPointMake(self.tyScrollView.contentSize.width - self.tyScrollView.frame.size.width, 0) animated:YES];
        }
            break;
        case 2: {
            [self.tyScrollView setContentOffset:CGPointMake(self.tyScrollView.contentSize.width - self.tyScrollView.frame.size.width, 0) animated:YES];
        }
            break;
        case 3: {}
            break;
        case 4: {}
            break;
            
        default:
            break;
    }
    [self scrollViewDidScroll:self.tyScrollView];
}
//http://service.woyaoxiege.com/music/mid/44ddf2cc8ffd0406eca4d69592590b84_1.mid
// http://www.woyaoxiege.com/home/index/play/44ddf2cc8ffd0406eca4d69592590b84_1
- (void)sixTyType {
    WEAK_SELF;
    // 16分音符
    CGFloat thumbWidth = self.thumbImageView.frame.size.width / 2;
    CGFloat tyScrollContentWidth = [TYCommonClass sharedTYCommonClass].noteMinWidth * (32 + 12);
    self.thumbWidth = thumbWidth;
    self.thumbScrollView.contentSize = CGSizeMake(self.thumbScrollView.width * 2 - self.thumbWidth, 0);
    self.tyScrollView.contentSize = CGSizeMake(tyScrollContentWidth, 0);
    CGFloat offsetX = self.tyScrollOffsetX * 2;
    CGFloat offset2 = (self.thumbScrollView.width - self.thumbWidth) * offsetX * 1.0 / (tyScrollContentWidth - self.tyScrollView.width + 4);
    
    offset2 = self.thumbScrollView.width - self.thumbWidth - offset2;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        STRONG_SELF;
        self.tyScrollView.frame = CGRectMake(self.tyScrollView.frame.origin.x, self.tyScrollView.frame.origin.y, self.tyScrollView.frame.size.width*2, self.tyScrollView.frame.size.height);
        self.thumbImageView.frame = CGRectMake(self.thumbImageView.frame.origin.x + thumbWidth, self.thumbImageView.frame.origin.y, thumbWidth, self.thumbImageView.frame.size.height);
        self.thumbScrollView.contentOffset = CGPointMake(offset2, self.thumbScrollView.contentOffset.y);
        for (UILabel *line in self.sixLines) {
            line.alpha = 1.0f;
        }
    } completion:^(BOOL finished) {
//        NSLog(@"%f", self.lastSentenceView.width);
    }];
    [TYCommonClass sharedTYCommonClass].showTyType = SixOneType;
    [[NSNotificationCenter defaultCenter] postNotificationName:SIX_TY_TYPE object:nil];
    [TYCommonClass sharedTYCommonClass].horiNoteCount = 16*4;
}

- (void)eightTyType {
    WEAK_SELF;
    // 8分音符
    CGFloat thumbWidth = self.thumbImageView.frame.size.width * 2;
    CGFloat tyScrollWidth = self.tyScrollView.width / 2;
    
    self.thumbWidth = thumbWidth;
//    self.thumbScrollView.contentSize = CGSizeMake(self.thumbScrollView.width * 2 - self.thumbWidth, 0);
    self.tyScrollView.contentSize = CGSizeMake([TYCommonClass sharedTYCommonClass].tyViewWidth, self.tyScrollView.contentSize.height);
    
//    NSLog(@"%@", NSStringFromCGSize(self.tyScrollView.contentSize));
    CGFloat offsetX = self.tyScrollOffsetX / 2;
    
    CGFloat offset2 = (self.thumbScrollView.width-self.thumbWidth) * offsetX * 1.0 / (self.tyScrollView.contentSize.width - self.tyScrollView.width + 4);
    
    offset2 = self.thumbScrollView.width-self.thumbWidth - offset2;
    
    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^{
        STRONG_SELF;
        self.tyScrollView.frame = CGRectMake(self.tyScrollView.frame.origin.x, self.tyScrollView.frame.origin.y, tyScrollWidth, self.tyScrollView.frame.size.height);
        self.thumbImageView.frame = CGRectMake(self.thumbImageView.frame.origin.x - thumbWidth / 2, self.thumbImageView.frame.origin.y, thumbWidth, self.thumbImageView.frame.size.height);
//        self.thumbScrollView.contentOffset = CGPointMake(offset2, self.thumbScrollView.contentOffset.y);
        self.thumbScrollView.contentSize = CGSizeMake(self.thumbScrollView.width * 2 - self.thumbWidth, 0);
        for (UILabel *line in self.sixLines) {
            line.alpha = 0.0f;
        }
    } completion:^(BOOL finished) {
        
        [self.thumbScrollView setContentOffset:CGPointMake(offset2, self.thumbScrollView.contentOffset.y) animated:YES];
    }];
    
    [TYCommonClass sharedTYCommonClass].showTyType = EightOneType;
    
    [[NSNotificationCenter defaultCenter] postNotificationName:EIGHT_TY_TYPE object:nil];
    
    [TYCommonClass sharedTYCommonClass].horiNoteCount = 16*2;
}

- (void)changeTYTypeBtnClick {
    [self.tyScrollView setAutoresizesSubviews:YES];
    self.isClickRightBtn = YES;
    if ([TYCommonClass sharedTYCommonClass].showTyType == EightOneType) {
        [self sixTyType];
    } else if ([TYCommonClass sharedTYCommonClass].showTyType == SixOneType){
        [self eightTyType];
    }
}

- (void)playBtnClick:(UIButton *)btn {
    
//    if (![PlayAnimatView sharePlayAnimatView] .isAnimating) {
//        [[PlayAnimatView sharePlayAnimatView]  startAnimating];
//    } else {
//        [[PlayAnimatView sharePlayAnimatView]  stopAnimating];
//    }
    [[NSNotificationCenter defaultCenter] postNotificationName:PLAY_MIDI_NOTI object:nil userInfo:@{@"currentIndex":[NSString stringWithFormat:@"%ld", (long)_currentIndex]}];
//    [self changeTYTypeBtnClick];
}

- (void)tyTypeChange {
    [self pausePlayMidi];
    [self changeTYTypeBtnClick];
}

- (void)createLinesForView:(SentenceView *)sentenceView {
    CGFloat lineW = 0.5f;
    UIView *whiteView1 = [UIView new];
    UIView *whiteView2 = [UIView new];
    UIView *whiteView3 = [UIView new];
    whiteView1.backgroundColor = TY_BG_TWOLight;
    whiteView2.backgroundColor = TY_BG_TWOLight;
    whiteView3.backgroundColor = TY_BG_TWOLight;
    
    [whiteView1 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [whiteView2 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    [whiteView3 setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
    
//    UILabel *lastLabel = nil;
    for (NSInteger i = 0; i < 17; i++) {
        UILabel *line = [UILabel new];
        UILabel *line2 = [UILabel new];
        
        line.backgroundColor = TY_LINE_COLOR;
        line2.backgroundColor = TY_LINE_COLOR;
//        line.alpha = 0.25;
        
        CGFloat lineX = self.noteWidth * i;
        
        line2.frame = CGRectMake(self.noteWidth / 2 + self.noteWidth * i, 0, 0.5f, self.noteHeight * 16);
        line2.alpha = 0.0f;
        
        if (i == 0 || i == 4 || i == 8 || i == 12 || i == 16) {
            lineW = 2.0f;
            if (i == 16) {
                lineX = lineX - 2;
                line2.hidden = YES;
            }
        }
        
        else {
            lineW = 0.5f;
        }
        
        line.frame = CGRectMake(lineX, 0, lineW, self.noteHeight * 16);
       
    
        [sentenceView addSubview:line];
        [sentenceView sendSubviewToBack:line];
        [sentenceView addSubview:line2];
        [sentenceView sendSubviewToBack:line2];
        
        [line setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        [line2 setAutoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        
        [self.eightLines addObject:line];
        [self.sixLines addObject:line2];
    }
    lineW = 0.5f;
    for (NSInteger i = 0; i < 17; i++) {
        UILabel *line = [UILabel new];
        line.backgroundColor = TY_LINE_COLOR;

        lineW = 0.5f;

        if (i == 0 || i == 16) {
            lineW = 2.0f;
        }
        
        line.frame = CGRectMake(0, self.noteHeight * i, [TYCommonClass sharedTYCommonClass].tyViewWidth, lineW);
        
        [line setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
        
        if ([TYCommonClass sharedTYCommonClass].songType == manSong) {
            if (i == 7) {
                whiteView1.frame = CGRectMake(0, line.bottom, line.width, self.noteHeight);
            } else if (i == 14) {
                whiteView2.frame = CGRectMake(0, line.bottom, line.width, self.noteHeight);
            } else if (i == 0) {
                whiteView3.frame = CGRectMake(0, line.bottom, line.width, self.noteHeight-2);
            }
        } else if ([TYCommonClass sharedTYCommonClass].songType == womanSong) {
            if (i == 4) {
                whiteView1.frame = CGRectMake(0, line.bottom, line.width, self.noteHeight);
            } else if (i == 11) {
                whiteView2.frame = CGRectMake(0, line.bottom, line.width, self.noteHeight);
            }
            whiteView3.frame = CGRectZero;
        }
        [sentenceView addSubview:line];
        [sentenceView sendSubviewToBack:line];
    }
    [sentenceView addSubview:whiteView1];
    [sentenceView addSubview:whiteView2];
    [sentenceView addSubview:whiteView3];
    [sentenceView sendSubviewToBack:whiteView1];
    [sentenceView sendSubviewToBack:whiteView2];
    [sentenceView sendSubviewToBack:whiteView3];
}

- (void)changeShowTyViewWithIndex:(NSInteger)index {
    self.thumbScrollView.contentOffset = CGPointMake(self.thumbScrollView.width-self.thumbWidth, 0);
    [self.tyScrollView setContentOffset:CGPointZero];
    //    [self.thumbScrollView setContentOffset:CGPointZero];
    _currentIndex = index;
    if (index < self.tyViewArray.count) {
        
        SentenceView *sentenceView = self.tyViewArray[index];
        
        if (self.lastSentenceView == sentenceView) {
            return;
        }
        self.lastSentenceView.hidden = YES;
        sentenceView.hidden = NO;
        WEAK_SELF;
        [UIView animateWithDuration:0.3 animations:^{
            STRONG_SELF;
            self.lastSentenceView.alpha = 0.0f;
            sentenceView.alpha = 1.0f;
        }];
       
        [sentenceView removeFromSuperview];
        [self.tyScrollView addSubview:sentenceView];
        [self.tyScrollView setContentOffset:CGPointMake(0, 0)];
        self.lastSentenceView = sentenceView;
    }
}

- (void)showTyViewWithIndex:(NSInteger)index {
    self.thumbScrollView.contentOffset = CGPointMake(self.thumbScrollView.width-self.thumbWidth, 0);
    [self.tyScrollView setContentOffset:CGPointZero];
//    [self.thumbScrollView setContentOffset:CGPointZero];
    _currentIndex = index;
    if (index < self.tyViewArray.count) {
        
        SentenceView *sentenceView = self.tyViewArray[index];
        
        if (self.lastSentenceView == sentenceView) {
            return;
        }
        self.lastSentenceView.hidden = YES;
        self.lastSentenceView.alpha = 0.0f;
        sentenceView.hidden = NO;
        sentenceView.alpha = 1.0f;
        [sentenceView removeFromSuperview];
        [self.tyScrollView addSubview:sentenceView];
        [self.tyScrollView setContentOffset:CGPointMake(0, 0)];
        self.lastSentenceView = sentenceView;
        [self bringSubviewToFront:self.leftPitchView];
    }
}

- (NSMutableArray *)tyViewArray {
    if (_tyViewArray == nil) {
        _tyViewArray = [NSMutableArray array];
    }
    return _tyViewArray;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    if (scrollView == self.tyScrollView) {
        self.tyScrollOffsetX = offsetX;
    }
    if (self.isClickRightBtn) {
        return;
    }
    
    if (!self.tyViewIsDrag && scrollView == self.thumbScrollView) {

//        NSLog(@"++++%f", offsetX);
        
        offsetX = (self.bounds.size.width - self.thumbWidth - offsetX);
        
        
        CGFloat tyScrollContentW = self.tyScrollView.contentSize.width - self.bounds.size.width + self.noteWidth + 4;
        
        if ([TYCommonClass sharedTYCommonClass].showTyType == SixOneType) {
            tyScrollContentW = tyScrollContentW - self.bounds.size.width;
        } else {
            
        }
        
        offsetX = offsetX * tyScrollContentW * 1.0 / (self.bounds.size.width -  self.thumbWidth);
        
        [self.tyScrollView setContentOffset:CGPointMake(offsetX, self.tyScrollView.contentOffset.y)];
       
        self.tyScrollOffsetX = offsetX;
        
    } else  if (self.tyViewIsDrag && scrollView == self.tyScrollView) {
        
        CGFloat offset2 = (self.thumbScrollView.width-self.thumbWidth) * offsetX * 1.0 / (self.tyScrollView.contentSize.width - self.tyScrollView.width + 4);

        offset2 = self.thumbScrollView.width - self.thumbWidth - offset2;
        
//        NSLog(@"%f--%f--%f", offsetX, offset2, self.thumbScrollView.width-self.thumbWidth);
        
        [self.thumbScrollView setContentOffset:CGPointMake(offset2, self.thumbScrollView.contentOffset.y)];
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    self.isClickRightBtn = NO;
    if (scrollView == self.thumbScrollView) {
        self.tyViewIsDrag = NO;
    } else if (scrollView == self.tyScrollView) {
        self.tyViewIsDrag = YES;
    }
}

@end
