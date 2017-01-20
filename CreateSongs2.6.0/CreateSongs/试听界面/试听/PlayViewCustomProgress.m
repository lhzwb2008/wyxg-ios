//
//  PlayViewCustomProgress.m
//  CreateSongs
//
//  Created by axg on 16/5/11.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PlayViewCustomProgress.h"
#import "UIView+Common.h"
#import "AXGHeader.h"
#import "UIColor+expanded.h"
#import "UIImage+Extensiton.h"


typedef enum : NSUInteger {
    DirectionLeft = 0,
    DirectionRight,// 水平
    DirectionUp,
    DirectionDown,   // 垂直
    DirectionNone,
} PgrDirection;
@interface PlayViewCustomProgress ()<ASValueTrackingSliderDataSource>



@property (nonatomic, assign) CGFloat firstX;

@property (nonatomic, assign) CGFloat firstY;

@property (nonatomic, assign) BOOL shouldChange;

@end

@implementation PlayViewCustomProgress

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.shouldChange = YES;
        self.progressType = PlayingType;
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame andType:(ProgressType)progressType {
    self = [super initWithFrame:frame];
    if (self) {
        self.shouldChange = YES;
        self.progressType = progressType;
        [self initSubViews];
    }
    return self;
}

- (void)playBtnClick:(UIButton *)btn {
    if (self.playBtnBlock) {
        self.playBtnBlock(btn.selected);
    }
    
//    self.playBtn.selected = !self.playBtn.selected;
}

- (void)hotBtnClick:(UIButton *)btn {
    [self playBtnClick:self.playBtn];
}

- (void)initSubViews {
    self.playBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.currentTime = [UILabel new];
    self.totalTime = [UILabel new];

    
    self.currentTime.text = @"00:00";
    self.currentTime.textColor = [UIColor colorWithHexString:@"#451d11"];
    self.currentTime.textAlignment = NSTextAlignmentLeft;
    self.currentTime.font = TECU_FONT(10*WIDTH_NIT);
    self.totalTime.text = @"00:00";
    self.totalTime.textColor = [UIColor colorWithHexString:@"#451d11"];
    self.totalTime.font = TECU_FONT(10*WIDTH_NIT);
    self.totalTime.textAlignment = NSTextAlignmentRight;
    
    self.playBtn.backgroundColor = [UIColor clearColor];
    self.playBtn.userInteractionEnabled = NO;
    self.playBtn.selected = YES;
    // 选中状态值暂停是的状态
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play暂停icon"]  forState:UIControlStateNormal];
    [self.playBtn setBackgroundImage:[UIImage imageNamed:@"play播放icon"] forState:UIControlStateSelected];
    
    self.playHotBtn = [UIButton new];
    self.playHotBtn.backgroundColor = [UIColor clearColor];
    [self.playHotBtn addTarget:self action:@selector(hotBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.sliderView = [ASValueTrackingSlider new];
    self.sliderView.popUpViewAlwaysOn = YES;
    self.sliderView.dataSource = self;
    self.sliderView.minimumTrackTintColor = [UIColor colorWithHexString:@"#ffdc74"];
    self.sliderView.maximumTrackTintColor = [UIColor colorWithHexString:@"#451d11"];
    [self.sliderView setThumbImage:[UIImage imageNamed:@"进度icon"] forState:UIControlStateNormal];
    
    WEAK_SELF;
    self.sliderView.dragThumbBlock = ^(CGFloat value) {
        STRONG_SELF;
        [self pauseWithProgress:value];
    };
    self.sliderView.dragEndBlock = ^(CGFloat value){
        STRONG_SELF;
        [self endDrageSetProgress:value];
    };
    
    [self addSubview:self.playBtn];
    [self addSubview:self.playHotBtn];
    [self addSubview:self.currentTime];
    [self addSubview:self.totalTime];
    [self addSubview:self.sliderView];
    
    [self setSubViewsFrame];
}

- (void)pauseWithProgress:(CGFloat)value {
    if (self.playBtnBlock) {
        self.playBtnBlock(NO);
    }
}

- (void)endDrageSetProgress:(CGFloat)value {
    if (self.sliderDidChangedBlock) {
        self.sliderDidChangedBlock(value);
    }
}

- (void)setSubViewsFrame {
    if (self.progressType == RecordingType) {
        self.playBtn.frame = CGRectMake(0, 0, 0, 13*WIDTH_NIT);
        self.sliderView.userInteractionEnabled = NO;
    } else {
        self.sliderView.userInteractionEnabled = YES;
        self.playBtn.frame = CGRectMake(16*WIDTH_NIT, 0, 12.5*WIDTH_NIT, 14*WIDTH_NIT);
    }
    
    CGSize sz = [@"00:00" getWidth:@"00:00" andFont:self.currentTime.font];
    
    self.playHotBtn.frame = CGRectMake(0, 0, self.playBtn.right + 16*WIDTH_NIT, self.height*3);
    
    self.currentTime.frame = CGRectMake(self.playBtn.right+16*WIDTH_NIT, 0, sz.width, sz.height);
    
    CGFloat sliderX = self.currentTime.right + 16*WIDTH_NIT;
    CGFloat sliderW = self.width - sliderX - 16*WIDTH_NIT - 16*WIDTH_NIT - sz.width;
    
    self.sliderView.frame = CGRectMake(sliderX, 0, sliderW, self.height);
    self.totalTime.frame = CGRectMake(self.sliderView.right + 16*WIDTH_NIT, 0, sz.width, sz.height);


    self.playBtn.centerY = self.height/2;
    self.playHotBtn.center = self.playBtn.center;
    self.currentTime.center = CGPointMake(self.currentTime.centerX, self.height/2);
    self.totalTime.center = CGPointMake(self.totalTime.centerX, self.height/2);
    self.sliderView.center = CGPointMake(self.sliderView.centerX, self.height/2);
}

- (void)setProgress:(CGFloat)progressValue withAnimated:(BOOL)animated {
    self.sliderView.value = progressValue;
}

// 滑动改变
- (void)setProgressInView {
   
}

- (void)changeToProgressType:(ProgressType)progressType {
    if (progressType == self.progressType) {
        return;
    }
    [self setProgress:0.0f withAnimated:NO];
    if (progressType == RecordingType) {
        
    } else if (progressType == PlayingType) {
        
    }
    self.progressType = progressType;
    [UIView animateWithDuration:0.8 animations:^{
        [self setSubViewsFrame];
    }];
    
}
- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value {
    
    return nil;
}
/**
 *  超出父视图部分响应手势
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];
    
    CGPoint leftPoint = [self.playHotBtn convertPoint:point fromView:self];
    
    if ([self.playHotBtn pointInside:leftPoint withEvent:event]) {
        return self.playHotBtn;
    }
    return result;
}
@end
