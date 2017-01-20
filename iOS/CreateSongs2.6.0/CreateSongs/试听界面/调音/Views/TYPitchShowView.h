//
//  TYPitchShowView.h
//  SentenceMidiView
//
//  Created by axg on 16/5/30.
//  Copyright © 2016年 axg. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    NormalPitch,
    HightPitch,
    HightHithtPitch,
    LowPitch,
    LowLowPitch,
} PitchType;

@interface TYPitchShowView : UIView

@property (nonatomic, strong) UILabel *numberLabel;// 数字
@property (nonatomic, strong) UILabel *thumbLabel;// 小圆点
@property (nonatomic, strong) UILabel *bottomThumbLabel;

@property (nonatomic, assign) PitchType pitchType;


- (void)setPitchNumber:(NSInteger)pitchNumber withPichType:(PitchType)pitchType;

@end
