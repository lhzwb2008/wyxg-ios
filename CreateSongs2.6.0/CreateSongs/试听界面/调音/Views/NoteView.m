//
//  NoteView.m
//  SentenceMidiChange
//
//  Created by axg on 16/5/9.
//  Copyright © 2016年 axg. All rights reserved.
//

#import "NoteView.h"
#import "TYCommonClass.h"
#import "TYHeader.h"
#import "UIColor+expanded.h"
#import "AXGHeader.h"
#import "Masonry.h"
#import "PlayViewController.h"

@interface NoteView ()

@property (nonatomic, strong) UIView *leftDragView;
@property (nonatomic, strong) UIView *rightDragView;
@property (nonatomic, strong) UILabel *lyricLabel;

@property (nonatomic, assign) CGPoint currentTickleStart;

@property (nonatomic, assign) BOOL directionLocked;



@property (nonatomic, assign) CGFloat noteHeight;

@property (nonatomic, strong) UIColor *backColor;

@property (nonatomic, assign) BOOL isDragging;

// 当前所在的位置(音高)
@property (nonatomic, assign) NSInteger currentHeight;

@property (nonatomic, strong) NSMutableArray *hotViewArr;

/**
 *  右边拖动指示视图
 */
@property (nonatomic, strong) UILabel *rightLineLabel;

@end

@implementation NoteView

- (void)registNoti {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeSelfDeltaTime) name:@"reloadTyView" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToSixType) name:SIX_TY_TYPE object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeToEightType) name:EIGHT_TY_TYPE object:nil];
}

- (void)changeToSixType {
    self.noteHoriXCount = self.noteHoriXCount * 2;
    self.noteWidthCount = self.noteWidthCount * 2;
}

- (void)changeToEightType {
    self.noteHoriXCount = self.noteHoriXCount / 2;
    self.noteWidthCount = self.noteWidthCount / 2;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"reloadTyView" object:nil];
}

- (NSMutableArray *)hotViewArr {
    if (_hotViewArr == nil) {
        _hotViewArr = [NSMutableArray array];
    }
    return _hotViewArr;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self registNoti];
        
        self.isDragging = NO;
        _currentDirection = DirectionNone;
        _rightDirection = DirectionNone;
        self.noteMinWidth = [[TYCommonClass sharedTYCommonClass] noteMinWidth];
        self.noteHeight = [[TYCommonClass sharedTYCommonClass] noteHeight];
        
        UIPanGestureRecognizer *rightPgr = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                   action:@selector(rightPanGesture:)];
        [self.rightDragView addGestureRecognizer:rightPgr];
        
        self.showNoteView.backgroundColor = NOTE_COLOR;
        self.showNoteView.clipsToBounds = YES;
        self.showNoteView.layer.cornerRadius = 2;
        
        self.lyricLabel.backgroundColor = [UIColor clearColor];
        self.lyricLabel.textAlignment = NSTextAlignmentCenter;
        self.lyricLabel.font = [UIFont systemFontOfSize:15*WIDTH_NIT];
        self.lyricLabel.textColor = TY_NOTE_TEXT;
        
        
        [self addSubview:self.showNoteView];
        [self addSubview:self.lyricLabel];
//        [self addSubview:self.leftDragView];
        
        for (NSInteger i = 0; i < 16; i ++) {
            UIView *hotView = [UIView new];
            hotView.backgroundColor = [UIColor clearColor];
            UIPanGestureRecognizer *leftPgr = [[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                                      action:@selector(leftPanGesture:)];
            [hotView addGestureRecognizer:leftPgr];
            [self addSubview:hotView];
            [self.hotViewArr addObject:hotView];
        }
        
        [self addSubview:self.rightDragView];
        
        self.rightLineLabel = [UILabel new];
        self.rightLineLabel.backgroundColor = [UIColor clearColor];
        self.rightLineLabel.text = @"|";
        self.rightLineLabel.textColor = [UIColor blackColor];
        self.rightLineLabel.font = [UIFont systemFontOfSize:5];
        self.rightLineLabel.textAlignment = NSTextAlignmentRight;
        
        [self addSubview:self.rightLineLabel];
        
        [self.lyricLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.mas_equalTo(self.showNoteView.center);
            make.size.mas_equalTo(CGSizeMake(50, 50));
        }];
        
//        self.lyricLabel.frame = CGRectMake(0, 0, self.noteMinWidth, self.noteHeight);
//        self.lyricLabel.center = self.showNoteView.center;
    }
    return self;
}

- (UILabel *)lyricLabel {
    if (_lyricLabel == nil) {
        _lyricLabel = [UILabel new];
    }
    return _lyricLabel;
}

- (void)setLyricStr:(NSString *)lyricStr {
    _lyricStr = lyricStr;
    self.lyricLabel.text = _lyricStr;
}

- (void)setNoteData:(NSData *)noteData {
    _noteData = noteData;
    [self.mutData setData:noteData];
}

- (NSMutableData *)mutData {
    if (_mutData == nil) {
        _mutData = [[NSMutableData alloc] init];
    }
    return _mutData;
}

- (void)leftPanGesture:(UIPanGestureRecognizer *)pgr {

    [self pangestureMoveWithView:pgr.view andPgr:pgr];
}

- (void)rightPanGesture:(UIPanGestureRecognizer *)pgr {

    [self pangestureMoveWithView:self.rightDragView andPgr:pgr];
}

- (void)rightPanGesture1:(UIPanGestureRecognizer *)recognizer {
    
    CGPoint translation = [recognizer translationInView:self.rightDragView];
    recognizer.view.center = CGPointMake(recognizer.view.center.x + translation.x,
                                         recognizer.view.center.y + translation.y);
    [recognizer setTranslation:CGPointZero inView:self.rightDragView];
    
    //    if (recognizer.state == UIGestureRecognizerStateEnded) {
    
    CGPoint velocity = [recognizer velocityInView:self.rightDragView];
    CGFloat magnitude = sqrtf((velocity.x * velocity.x) + (velocity.y * velocity.y));
    CGFloat slideMult = magnitude / 200;
    NSLog(@"magnitude: %f, slideMult: %f", magnitude, slideMult);
    
    float slideFactor = 0.1 * slideMult; // Increase for more of a slide
    CGPoint finalPoint = CGPointMake(recognizer.view.center.x + (velocity.x * slideFactor),
                                     recognizer.view.center.y + (velocity.y * slideFactor));
    NSLog(@"--%@", NSStringFromCGPoint(finalPoint));
            finalPoint.x = MIN(MAX(finalPoint.x, 0), self.bounds.size.width);
            finalPoint.y = MIN(MAX(finalPoint.y, 0), self.bounds.size.height);
    
    [UIView animateWithDuration:slideFactor*2 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        recognizer.view.center = finalPoint;
    } completion:nil];
    //    }
}

- (void)pangestureMoveWithView:(UIView *)pgrView andPgr:(UIPanGestureRecognizer *)pgr{


    CGPoint velocity = [pgr velocityInView:pgrView];
    
    // 这个变量在改变位置的时候使用
    _currentDirection = (velocity.y)>=0 ? DirectionDown : DirectionUp;
    
    static PgrDirection direction = DirectionNone;
    
    if (pgr.state == UIGestureRecognizerStateBegan) {
        
        [self showMaskView];
        
        if (pgrView == self.rightDragView) {//panRightViewBegan
            [[NSNotificationCenter defaultCenter] postNotificationName:@"panRightViewBegan" object:nil];
        } else {
            [[NSNotificationCenter defaultCenter] postNotificationName:@"panLeftViewBegan" object:nil];
        }
        
        CGPoint velocity = [pgr velocityInView:pgrView];
        
        if (fabs(velocity.x) > fabs(velocity.y)) {
            
            direction = (velocity.x)>=0 ? DirectionRight : DirectionLeft;
        } else {
            direction = (velocity.y)>=0 ? DirectionDown : DirectionUp;
        }
    } else if (pgr.state == UIGestureRecognizerStateEnded) {
        [self hideMaskView];
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pangestrueEnd" object:nil
                                                          userInfo:@{ @"sentenceIndex":[NSString stringWithFormat:@"%ld", (unsigned long)self.sentenceIndex]}];
        if (pgrView == self.rightDragView) {
            [self changeSelfDeltaTime];
//            [self changeSelfFrame:pgr.state];
        } else {
//            [self changeSelfFrame:pgr.state];
        }
        return;
    } else if (pgr.state == UIGestureRecognizerStateCancelled) {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"pangestrueEnd" object:nil
                                                          userInfo:@{ @"sentenceIndex":[NSString stringWithFormat:@"%ld", (unsigned long)self.sentenceIndex]}];
        [self hideMaskView];
        if (pgrView == self.rightDragView) {
            [self changeSelfDeltaTime];
//            [self changeSelfFrame:pgr.state];
        } else {
//            [self changeSelfFrame:pgr.state];
        }
        return;
    } else {
        
    }
    
    CGPoint translation = [pgr translationInView:pgrView];
    
    self.noteTranslation = translation;
    
    
    
//    CGRect frame = self.frame;
    CGPoint location = [pgr locationInView:pgrView];
    
//    NSLog(@"%@", NSStringFromCGPoint(location));
    
    if (direction == DirectionDown || direction == DirectionUp) {
//        frame.origin.y += translation.y;
        
        if (location.y < 0 && location.y > - self.noteHeight * 3) {
            [self changeSelfFrame:pgr.state];
        } else if (location.y > self.noteHeight && location.y < self.noteHeight * 3){
            [self changeSelfFrame:pgr.state];
        }
    } else {
        
        // 如果是拖动右边区域，左右拖动，则是改变宽度
        if (pgrView == self.rightDragView) {
        
            NSLog(@"%f", location.x);
            
            if (location.x < self.tmpPgrX) {
                NSLog(@"left");
            }
            
            self.tmpPgrX = location.x;
            
            if (location.x > pgrView.frame.size.width && location.x < pgrView.frame.size.width + self.noteHeight) {

                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeWidth"
                                                                    object:nil
                                                                  userInfo:@{@"index":[NSString stringWithFormat:@"%ld", (unsigned long)self.index],
                                                                             @"translationX":[NSNumber numberWithFloat:translation.x],
                                                                             @"sentenceIndex":[NSString stringWithFormat:@"%ld", (unsigned long)self.sentenceIndex]
                                                                             }];
            } else if (location.x < 0 && location.x > - pgrView.frame.size.width) {

                [[NSNotificationCenter defaultCenter] postNotificationName:@"changeWidth"
                                                                    object:nil
                                                                  userInfo:@{@"index":[NSString stringWithFormat:@"%ld", (unsigned long)self.index],
                                                                             @"translationX":[NSNumber numberWithFloat:translation.x],
                                                                             @"sentenceIndex":[NSString stringWithFormat:@"%ld", (unsigned long)self.sentenceIndex]
                                                                             }];
            }
            
            // 拖动左边区域，只改变x坐标
        } else {
            
            if (location.x > pgrView.frame.size.width && location.x < pgrView.frame.size.width + self.noteHeight) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"leftMoveNote"
                                                                    object:nil
                                                                  userInfo:@{@"index":[NSString stringWithFormat:@"%ld", (unsigned long)self.index],
                                                                             @"translationX":[NSNumber numberWithFloat:translation.x],
                                                                             @"sentenceIndex":[NSString stringWithFormat:@"%ld", (unsigned long)self.sentenceIndex]
                                                                             }];
            } else if (location.x < 0 && location.x > -pgrView.frame.size.width * 2) {
                [[NSNotificationCenter defaultCenter] postNotificationName:@"leftMoveNote"
                                                                    object:nil
                                                                  userInfo:@{@"index":[NSString stringWithFormat:@"%ld", (unsigned long)self.index],
                                                                             @"translationX":[NSNumber numberWithFloat:translation.x],
                                                                             @"sentenceIndex":[NSString stringWithFormat:@"%ld", (unsigned long)self.sentenceIndex]
                                                                             }];
            }
            
        }
    }
    [pgr setTranslation:CGPointZero inView:pgrView];
}

- (void)changeSelfFrame:(UIGestureRecognizerState)state {
    if (self.isGuidNote) {
        return;
    }
    if (self.currentDirection == DirectionDown) {
        
        self.notePitchCount ++;
        
    } else if (self.currentDirection == DirectionUp) {
        
        self.notePitchCount --;
    }
    [self finalMovewithNoteY:self.notePitchCount state:state];
}

// 纵向位置处理
- (void)finalMovewithNoteY:(NSInteger)noteCountY state:(UIGestureRecognizerState)state{

    
    NSInteger finalOffset = 0;
    
    finalOffset = noteCountY;
    
    if (finalOffset <= 0) {
        finalOffset = 0;
    } else if (finalOffset >= 15) {
        finalOffset = 15;
    }
//    NSLog(@"%ld", finalOffset);
    [self changeColorWithOffset:finalOffset];
    
    CGFloat moveY = self.noteHeight * finalOffset;

    if (moveY <= 0) {
        moveY = 0;
        finalOffset = 0;
    } else if (moveY >= self.noteHeight * 15) {
        moveY = self.noteHeight * 15;
        finalOffset = 15;
    }
    
    self.frame = CGRectMake(self.frame.origin.x, moveY, self.bounds.size.width, self.bounds.size.height);

    NSInteger finalPitch = [self calmFinalNotePitchWithHeight:finalOffset];
    
    [self changeSelfPitchWithPitch:finalPitch];

    if (self.playPitchNote) {
        self.playPitchNote(finalPitch, self);
    }
}

- (void)changeNoteViewColor {
    
    [self changeColorWithOffset:self.notePitchCount];
}
- (void)changeSelfDeltaTime {
    if (!self.noteData || self.isGuidNote) {
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
    for (NSInteger i = 0; i < self.noteData.length; i++) {
        UInt8 value = 0;
        [self.noteData getBytes:&value range:NSMakeRange(i, sizeof(value))];
        if (value == CHANNEL_NOTE_ON && leftData == nil) {
            leftData = [self.noteData subdataWithRange:NSMakeRange(i, 3)];
        } else if (value == CHANNEL_NOTE_OFF) {
            rightData = [self.noteData subdataWithRange:NSMakeRange(i, 3)];
            endData = [self.noteData subdataWithRange:NSMakeRange(i+3, self.noteData.length-(i+3))];
        }
    }
    float inter = 0;
    
    inter = (int)roundf(self.frame.size.width * 1.0 / ([TYCommonClass sharedTYCommonClass].noteMinWidth * 0.5));
    
    
    if ([TYCommonClass sharedTYCommonClass].showTyType == EightOneType) {
        inter = inter * 2;
    }
    
//    NSLog(@"音符宽度为%d --- %f", (int)roundf(self.frame.size.width * 1.0 / [TYCommonClass sharedTYCommonClass].noteMinWidth), inter);
    // 计算得到的是10格  则实际应该是2.5格  所以除以4
    UInt32 deltaTime = inter * 1.0 * [TYCommonClass sharedTYCommonClass].baseTicks / 2 / 4;
    
    self.noteDeltaTime = deltaTime;
    if (self.noteData.length == 0) {
        return;
    }
    NSData *oneData = [self.noteData subdataWithRange:NSMakeRange(0, 1)];
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
    self.finalNoteData = tmpNoteData;
    self.noteData = tmpNoteData;
    //     NSLog(@"改动后%@", self.noteData);
}

- (void)tmpChangeFrame:(NSInteger)offset {
    CGFloat moveY = self.noteHeight * offset;
    if (moveY <= 0) {
        moveY = 0;
    } else if (moveY >= self.noteHeight * 15) {
        moveY = self.noteHeight * 15;
    }
    WEAK_SELF;
    [UIView animateWithDuration:0.1 animations:^{
        STRONG_SELF;
        self.frame = CGRectMake(self.frame.origin.x, moveY, self.bounds.size.width, self.bounds.size.height);
    } completion:^(BOOL finished) {
        [self changeSelfPitchWithPitch:offset];
    }];
}

//- (NSData *)finalNoteData {
//    if (_finalNoteData.length == 0) {
//        _finalNoteData = self.noteData;
//    }
//    return _finalNoteData;
//}

- (void)changeColorWithOffset:(NSInteger)offset {
    self.currentHeight = offset;
//    NSLog(@"%ld", offset);
    NSString *colorStr = nil;
    switch (offset) {
        case 0: {
            
            colorStr = @"#d51338";
        }
            break;
        case 1: {
            colorStr = @"#d92e5e";
        }
            break;
        case 2: {
            colorStr = @"#eb517d";
        }
            break;
        case 3: {
            colorStr = @"#ff6867";
        }
            break;
        case 4: {
            colorStr = @"#ff9d4d";
        }
            break;
        case 5: {
            colorStr = @"#ffc64d";
        }
            break;
        case 6: {
            colorStr = @"#ffe960";
        }
            break;
        case 7: {
            colorStr = @"#f6ff92";
        }
            break;
        case 8: {
            colorStr = @"#91ffb1";
        }
            break;
        case 9: {
            colorStr = @"#5efce3";
        }
            break;
        case 10: {
            colorStr = @"#6ae8ff";
        }
            break;
        case 11: {
            colorStr = @"#31c5ee";
        }
            break;
        case 12: {
            colorStr = @"#1f88c5";
        }
            break;
        case 13: {
            colorStr = @"#4e599e";
        }
            break;
        case 14: {
            colorStr = @"934e8d";
        }
            break;
        case 15: {
            colorStr = @"7d3b76";
        }
            break;
        default:
            colorStr = @"7d3b76";
            break;
    }
//    self.showNoteView.backgroundColor = [UIColor colorWithHexString:@"#41feff"];
    self.showNoteView.backgroundColor = [UIColor colorWithHexString:colorStr];
}

- (NSInteger)calmFinalNotePitchWithHeight:(NSInteger)pitch {
    
    if ([[TYCommonClass sharedTYCommonClass] songType] == womanSong) {
        NSInteger i = 0;
        switch (pitch) {
            case 0: {
                i = 67;
            }
                break;
            case 1: {
                i = 65;
            }
                break;
            case 2: {
                i = 64;
            }
                break;
            case 3: {
                i = 62;
            }
                break;
            case 4: {
                i = 60;
            }
                break;
            case 5: {
                i = 59;
            }
                break;
            case 6: {
                i = 57;
            }
                break;
            case 7: {
                i = 55;
            }
                break;
            case 8: {
                i = 53;
            }
                break;
            case 9: {
                i = 52;
            }
                break;
            case 10: {
                i = 50;
            }
                break;
            case 11: {
                i = 48;
            }
                break;
            case 12: {
                i = 47;
            }
                break;
            case 13: {
                i = 45;
            }
                break;
            case 14: {
                i = 43;
            }
                break;
            case 15: {
                i = 41;
            }
                break;
            default:
                break;
        }
        return i;
    } else if ([[TYCommonClass sharedTYCommonClass] songType] == manSong) {
        NSInteger i = 0;
        switch (pitch) {
            case 0: {
                i = 60;
            }
                break;
            case 1: {
                i = 59;
            }
                break;
            case 2: {
                i = 57;
            }
                break;
            case 3: {
                i = 55;
            }
                break;
            case 4: {
                i = 53;
            }
                break;
            case 5: {
                i = 52;
            }
                break;
            case 6: {
                i = 50;
            }
                break;
            case 7: {
                i = 48;
            }
                break;
            case 8: {
                i = 47;
            }
                break;
            case 9: {
                i = 45;
            }
                break;
            case 10: {
                i = 43;
            }
                break;
            case 11: {
                i = 41;
            }
                break;
            case 12: {
                i = 40;
            }
                break;
            case 13: {
                i = 38;
            }
                break;
            case 14: {
                i = 36;
            }
                break;
            case 15: {
                i = 35;
            }
                break;
            default:
                break;
        }
        return i;
    }
    NSLog(@"改变音高时超出范围");
    return 0;
}

- (void)changeSelfPitchWithPitch:(NSInteger)pitch {
    
    NSInteger finalPitch = pitch;
    
//    NSLog(@"---%ld", finalPitch);
    
//    NSLog(@"音符数据为%@ 改变后音高%ld", self.mutData, finalPitch);
    
    for (NSInteger i = 0; i < self.mutData.length; i++) {
        UInt8 value = 0;
        [self.noteData getBytes:&value range:NSMakeRange(i, sizeof(value))];
        // 因为开启音符标识后边的长度不可控，而关闭音符后边力度都是0x00所以在关闭音符后边查找对应音高
        if (value == CHANNEL_NOTE_OFF) {//<90377882 68803700 00>
            
            void *a = (void *)([_mutData bytes]+i+1);
            memset(a, (int)finalPitch, sizeof(value));
#if 0// 当最高音高超过128时使用下边策略
            for (NSInteger j = i; j < self.noteData.length; j++) {
                UInt8 value1 = 0;
                [self.noteData getBytes:&value1 range:NSMakeRange(j, sizeof(value1))];
                if (value1 == 0x00) {
                    // 因为服务端的midi数据最高音高是66 并未超过Uint8的最大范围128，所以都是一位二进制数 
                }
            }
#endif
        } else if (value == CHANNEL_NOTE_ON) {
            void *a = (void *)([_mutData bytes]+i+1);
            memset(a, (int)finalPitch, sizeof(value));
        }
    }
    self.noteData = _mutData;
    self.finalNoteData = _mutData;
//    NSLog(@"改变后的音符数据为%@ 音高%ld  pitch=%ld", self.finalNoteData, finalPitch, pitch);
}
/**
 *  超出父视图部分响应手势
 */
//- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
//    UIView *result = [super hitTest:point withEvent:event];
//    
//    CGPoint leftPoint = [self.leftDragView convertPoint:point fromView:self];
//    CGPoint rightPoint = [self.rightDragView convertPoint:point fromView:self];
//    
//    if ([self.leftDragView pointInside:leftPoint withEvent:event]) {
//        return self.leftDragView;
//    } else if ([self.rightDragView pointInside:rightPoint withEvent:event]) {
//        return self.rightDragView;
//    }
//    return result;
//}
#define LEFT_SCALE  0.12
#define TOP_SCALE   0.21

- (void)layoutSubviews {
    [super layoutSubviews];
    
    NSInteger i = 0;
//    for (UIView *hotView in self.hotViewArr) {
//        CGFloat hotX = self.noteHeight * i++;
//        if (hotX >= self.bounds.size.width-self.noteHeight) {
//            hotView.frame = CGRectZero;
//        } else {
//            hotView.frame = CGRectMake(hotX, 0, self.noteHeight, self.noteHeight);
//        }
//    }
    for (UIView *hotView in self.hotViewArr) {
//        hotView.backgroundColor = [UIColor redColor];
        CGFloat hotX = self.noteHeight * i++;
        if (hotX >= self.bounds.size.width/2) {
            hotView.frame = CGRectZero;
        } else {
            hotView.frame = CGRectMake(hotX, 0, self.noteHeight, self.noteHeight);
        }
    }

//    self.rightDragView.backgroundColor = [UIColor greenColor];
    if (self.bounds.size.width <= self.noteHeight) {
        self.rightDragView.frame = CGRectMake(0,
                                              0,
                                              self.bounds.size.width,
                                              self.bounds.size.height);
    } else {
        self.rightDragView.frame = CGRectMake(self.bounds.size.width/2,
                                              0,
                                              self.bounds.size.width/2,
                                              self.bounds.size.height);
    }
    self.rightLineLabel.frame = self.rightDragView.frame;
    
    self.rightLineLabel.center = CGPointMake(self.rightDragView.centerX - 1.5, self.rightDragView.centerY);
    self.showNoteView.frame = CGRectMake(0.5,
                                         0.5,
                                         self.bounds.size.width-0.5,
                                         self.bounds.size.height-0.5);
}
/**
 *  当frame改变的时候调用此方法 在这个方法内部修改每个note的音高音长信息
 */
- (id<CAAction>)actionForLayer:(CALayer *)layer forKey:(NSString *)event {
    id<CAAction> action = [super actionForLayer:layer forKey:event];
    
    if (!self.isGuidNote) {
        [self changeSelfDeltaTime];
    }
    return action;
}

- (UIView *)showNoteView {
    if (_showNoteView == nil) {
        _showNoteView = [UIView new];
    }
    return _showNoteView;
}

- (UIView *)leftDragView {
    if (_leftDragView == nil) {
        _leftDragView = [UIView new];
    }
    return _leftDragView;
}

- (UIView *)rightDragView {
    if (_rightDragView == nil) {
        _rightDragView = [UIView new];
//        _rightDragView.backgroundColor = [UIColor grayColor];
    }
    return _rightDragView;
}


- (void)showMaskView {
    if (self.isGuidNote) {
        __block UIView *guidView = [PlayViewController sharePlayVC].tyGuidView;
        if (guidView) {
            [UIView animateWithDuration:0.3 animations:^{
                guidView.alpha = 0.0f;
            } completion:^(BOOL finished) {
                [guidView removeFromSuperview];
                guidView = nil;
            }];
        }
    }
    
    self.showNoteView.layer.borderColor = [UIColor whiteColor].CGColor;
    self.showNoteView.layer.borderWidth = 1;
}
- (void)hideMaskView {
    self.showNoteView.layer.borderColor = [UIColor clearColor].CGColor;
    self.showNoteView.layer.borderWidth = 0;
//    WEAK_SELF;
//    [UIView animateWithDuration:0.5 animations:^{
//        STRONG_SELF;
//
//        self.transform = CGAffineTransformIdentity;
//    }];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];

}

@end
