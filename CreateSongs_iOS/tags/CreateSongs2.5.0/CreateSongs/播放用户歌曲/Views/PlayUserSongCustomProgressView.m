//
//  PlayUserSongCustomProgressView.m
//  CreateSongs
//
//  Created by axg on 16/5/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PlayUserSongCustomProgressView.h"
#import "UIView+Common.h"
#import "AXGHeader.h"
#import "UIColor+expanded.h"
#import "UIImage+Extensiton.h"
#import "ASValueTrackingSlider.h"

@interface PlayUserSongCustomProgressView ()<ASValueTrackingSliderDataSource>
/**
 *  左端已经显示过的视图
 */
@property (nonatomic, strong) UIView *minShowView;

@property (nonatomic, strong) ASValueTrackingSlider *sliderView;

@property (nonatomic, assign) CGFloat firstX;

@property (nonatomic, assign) CGFloat firstY;

@property (nonatomic, assign) BOOL shouldChange;

@end

@implementation PlayUserSongCustomProgressView

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


- (void)initSubViews {
    
    
    self.bgImageView = [UIImageView new];
    self.bgImageView.backgroundColor = [UIColor clearColor];
    self.bgImageView.image = [UIImage imageNamed:@"playUser进度条蒙版"];
    
    self.currentTime = [UILabel new];
    self.totalTime = [UILabel new];
    
    self.currentTime.text = @"00:00";
    self.currentTime.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.currentTime.textAlignment = NSTextAlignmentLeft;
    self.currentTime.font = TECU_FONT(10*WIDTH_NIT);
    self.totalTime.text = @"00:00";
    self.totalTime.textColor = [UIColor colorWithHexString:@"#ffffff"];
    self.totalTime.font = TECU_FONT(10*WIDTH_NIT);
    self.totalTime.textAlignment = NSTextAlignmentRight;
    
    self.sliderView = [ASValueTrackingSlider new];
    self.sliderView.popUpViewAlwaysOn = YES;
    self.sliderView.dataSource = self;
    self.sliderView.minimumTrackTintColor = [UIColor colorWithHexString:@"#ffdc74"];
    self.sliderView.maximumTrackTintColor = [UIColor colorWithHexString:@"#451d11"];
    [self.sliderView setThumbImage:[UIImage imageNamed:@"playUser进度"] forState:UIControlStateNormal];
    self.sliderView.maximumValue = 1.0f;
    WEAK_SELF;
    self.sliderView.dragThumbBlock = ^(CGFloat value) {
        STRONG_SELF;
        [self pauseWithProgress:value];
    };
    self.sliderView.dragEndBlock = ^(CGFloat value){
        STRONG_SELF;
        [self endDrageSetProgress:value];
    };
    
    [self addSubview:self.bgImageView];
    [self addSubview:self.currentTime];
    [self addSubview:self.totalTime];
    [self addSubview:self.sliderView];
    
    [self setSubViewsFrame];
}

- (void)pauseWithProgress:(CGFloat)value {
    if (self.playBtnBlock) {
        self.playBtnBlock(YES);
    }
}

- (void)endDrageSetProgress:(CGFloat)value {
    if (self.sliderDidChangedBlock) {
        self.sliderDidChangedBlock(value);
    }
}

- (void)setSubViewsFrame {

    self.bgImageView.frame = self.bounds;
    
    CGSize sz = [self.currentTime.text sizeWithFont:self.currentTime.font constrainedToSize:CGSizeMake(MAXFLOAT, 40)];

    self.currentTime.frame = CGRectMake(16*WIDTH_NIT, 0, sz.width, sz.height);
    
    CGFloat sliderX = self.currentTime.right + 16*WIDTH_NIT;
    CGFloat sliderW = self.width - sliderX - 16*WIDTH_NIT - 16*WIDTH_NIT - sz.width;
    
    self.sliderView.frame = CGRectMake(sliderX, 0, sliderW, self.height);
    self.totalTime.frame = CGRectMake(self.sliderView.right + 16*WIDTH_NIT, 0, sz.width, sz.height);
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

- (void)panGestureEndChangePlayerProgress:(CGFloat)value {
    
    if (self.sliderDidChangedBlock) {
        self.sliderDidChangedBlock(value);
    }
}

- (void)changeToProgressType:(ProgressType)progressType {
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


@end
