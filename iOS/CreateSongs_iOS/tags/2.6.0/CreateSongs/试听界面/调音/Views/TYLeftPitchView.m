//
//  TYLeftPitchView.m
//  SentenceMidiView
//
//  Created by axg on 16/5/30.
//  Copyright © 2016年 axg. All rights reserved.
//

#import "TYLeftPitchView.h"
#import "TYPitchShowView.h"
#import "TYCommonClass.h"
#import "UIColor+expanded.h"
#import "TYHeader.h"

@interface TYLeftPitchView ()

@property (nonatomic, strong) UILabel *rightLine;

@property (nonatomic, strong) NSMutableArray *pitchViewArray;

@end

@implementation TYLeftPitchView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // 女 65 64 62 60 59 57 55 53 52 50 48 47
        // 男 57 55 53 52 50 48 47 45 43 41 40 38
        // 起始音高
        NSInteger beginPitch = 5;
        if ([TYCommonClass sharedTYCommonClass].songType == manSong) {
            beginPitch = 1;
        }
        
        // 当前音域数
        NSInteger pageNumber = 1;
        PitchType pitchType = HightPitch;

        
        if ([TYCommonClass sharedTYCommonClass].songType == manSong) {
            pitchType = HightPitch;
        }
//        self.rightLine = [UILabel new];
//        self.rightLine.backgroundColor = [UIColor colorWithHexString:@"#1464b6"];
        for (NSInteger i = 0; i < 16; i++) {
            
            if (beginPitch < 1) {
                if (pageNumber == 1) {
                    if ([TYCommonClass sharedTYCommonClass].songType == manSong) {
                        pitchType = NormalPitch;
                    } else {
                        pitchType = NormalPitch;
                    }
                } else if (pageNumber == 2) {
                    if ([TYCommonClass sharedTYCommonClass].songType == manSong) {
                        pitchType = LowPitch;
                    } else {
                        pitchType = LowPitch;
                    }
                } else if (pageNumber == 3) {
                    if ([TYCommonClass sharedTYCommonClass].songType == manSong) {
                        pitchType = LowLowPitch;
                    } else {
                        pitchType = LowLowPitch;
                    }
                } else {
                    NSLog(@"error: lowlowlow");
                }
                
                beginPitch = 7;
                pageNumber++;
            }
            CGFloat pitchViewH = frame.size.width;
            CGRect pitchFrame = CGRectZero;
            if (i == 0) {
                pitchFrame = CGRectMake(0, (pitchViewH-2) * i+2, pitchViewH, pitchViewH-4);
            } else {
                pitchFrame = CGRectMake(0, (pitchViewH-2) * i+0.5, pitchViewH, pitchViewH-2);
            }
            TYPitchShowView *pitchView = [[TYPitchShowView alloc] initWithFrame:pitchFrame];
            pitchView.backgroundColor = TY_LINE_COLOR;
            pitchView.numberLabel.backgroundColor = TY_TOP_BGCOLOR;
            pitchView.thumbLabel.backgroundColor = pitchView.numberLabel.backgroundColor;
            pitchView.bottomThumbLabel.backgroundColor = pitchView.numberLabel.backgroundColor;
            [pitchView setPitchNumber:beginPitch-- withPichType:pitchType];
            [self addSubview:pitchView];
            [self.pitchViewArray addObject:pitchView];
        }
//        [self addSubview:self.rightLine];
    }
    return self;
}


- (NSMutableArray *)pitchViewArray {
    if (_pitchViewArray == nil) {
        _pitchViewArray = [NSMutableArray array];
    }
    return _pitchViewArray;
}

@end
