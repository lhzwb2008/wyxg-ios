//
//  TYPitchShowView.m
//  SentenceMidiView
//
//  Created by axg on 16/5/30.
//  Copyright © 2016年 axg. All rights reserved.
//

#import "TYPitchShowView.h"
#import "UIView+Common.h"
#import "UIView+UIViewAdditions.h"
#import "AXGHeader.h"
#import "TYHeader.h"

@interface TYPitchShowView ()

@end

@implementation TYPitchShowView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.thumbLabel = [UILabel new];
        self.numberLabel = [UILabel new];
        self.bottomThumbLabel = [UILabel new];
        
        self.thumbLabel.font = [UIFont boldSystemFontOfSize:10*WIDTH_NIT];
        self.numberLabel.font = [UIFont systemFontOfSize:14*WIDTH_NIT];
        self.bottomThumbLabel.font = [UIFont boldSystemFontOfSize:10 * WIDTH_NIT];
        
        [self.thumbLabel sizeToFit];
        [self.bottomThumbLabel sizeToFit];
        [self.numberLabel sizeToFit];
//        self.thumbLabel.backgroundColor = [UIColor redColor];
        
//        self.bottomThumbLabel.backgroundColor = [UIColor redColor];
        
        self.thumbLabel.textAlignment = NSTextAlignmentCenter;
        self.numberLabel.textAlignment = NSTextAlignmentCenter;
        self.bottomThumbLabel.textAlignment = NSTextAlignmentCenter;
        
        self.numberLabel.textColor = TY_PITCH_NUMBER;
        self.thumbLabel.textColor = TY_PITCH_NUMBER;
        self.bottomThumbLabel.textColor = TY_PITCH_NUMBER;
        
//        self.thumbLabel.text = @"·";
//        self.numberLabel.text = @"2";
//        self.bottomThumbLabel.text = @"·";
        
        self.thumbLabel.frame = CGRectMake(0, 0, self.bounds.size.width-2, self.bounds.size.height*1.0/4);
        self.numberLabel.frame = CGRectMake(self.thumbLabel.left, self.thumbLabel.bottom-1, self.thumbLabel.width, self.bounds.size.height-self.thumbLabel.height*2 + 1);
        self.bottomThumbLabel.frame = CGRectMake(self.thumbLabel.left, self.numberLabel.bottom-2, self.thumbLabel.width, self.thumbLabel.height+1.5);
        
        
        

        [self addSubview:self.bottomThumbLabel];
        [self addSubview:self.numberLabel];
        [self addSubview:self.thumbLabel];
        
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setPitchNumber:(NSInteger)pitchNumber withPichType:(PitchType)pitchType {
    switch (pitchType) {
        case NormalPitch: {
            self.bottomThumbLabel.text = @"";
            self.thumbLabel.text = @"";
        }
            break;
        case HightPitch: {
            self.bottomThumbLabel.text = @"";
            self.thumbLabel.text = @"·";
        }
            break;
        case HightHithtPitch: {}
            break;
        case LowPitch: {
            self.bottomThumbLabel.text = @"·";
            self.thumbLabel.text = @"";
        }
            break;
        case LowLowPitch: {
            self.bottomThumbLabel.text = @":";
            self.thumbLabel.text = @"";
        }
            break;
            
        default:
            break;
    }
    self.numberLabel.text = [NSString stringWithFormat:@"%ld", (long)pitchNumber];
}


@end
