//
//  SongLoadingView.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/27.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SongLoadingView.h"
#import "GifView.h"
#import "AXGHeader.h"

@implementation SongLoadingView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        CGFloat navH = kDevice_Is_iPhoneX ? 88 : 64;
        navH = 44 - 20;
        self.frame = CGRectMake(0, navH, SCREEN_W, SCREEN_H - navH);
        [self createView];
    }
    return self;
}

- (void)createView {
    
    self.tipsArray = @[@"每句5个字以上更好听哦(ง •̀_•́)ง",
                       @"输入“~”可以连音啦 (*￣∇￣*)",
                       @"戴耳机演唱效果更棒呢(=ﾟωﾟ)ﾉ"];
    
    if (kDevice_Is_iPad || kDevice_Is_iPad3 || kDevice_Is_iPhone4) {
        self.gifView = [[GifView alloc] initWithFrame:self.bounds filePath:[[NSBundle mainBundle] pathForResource:@"试听_围巾飘4" ofType:@"gif"]];
    } else if (kDevice_Is_iPhone5) {
        self.gifView = [[GifView alloc] initWithFrame:self.bounds filePath:[[NSBundle mainBundle] pathForResource:@"试听_围巾飘5" ofType:@"gif"]];
    } else if (kDevice_Is_iPhone6Plus) {
        self.gifView = [[GifView alloc] initWithFrame:self.bounds filePath:[[NSBundle mainBundle] pathForResource:@"试听_围巾飘6p" ofType:@"gif"]];
    } else {
        self.gifView = [[GifView alloc] initWithFrame:self.bounds filePath:[[NSBundle mainBundle] pathForResource:@"试听_围巾飘6" ofType:@"gif"]];
    }

    self.gifView.contentMode = UIViewContentModeScaleAspectFit;
    [self addSubview:self.gifView];
    [self.gifView replay];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.height - 75 * HEIGHT_NIT, self.width, 0.5)];
    [self addSubview:lineView];
    lineView.backgroundColor = [UIColor blackColor];

    self.tipsLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, 100)];
    [self addSubview:self.tipsLabel];
    self.tipsLabel.textColor = HexStringColor(@"#ffffff");
    self.tipsLabel.font = JIACU_FONT(15);
    self.tipsLabel.textAlignment = NSTextAlignmentCenter;
    
    NSInteger index = arc4random() % self.tipsArray.count;
    NSString *tips = self.tipsArray[index];
    self.tipsLabel.text = tips;
    
    self.tipsLabel.center = CGPointMake(self.tipsLabel.centerX, self.height - 150 * HEIGHT_NIT - 7.5 * HEIGHT_NIT);
    
    if (kDevice_Is_iPhone5 || kDevice_Is_iPad || kDevice_Is_iPad3 || kDevice_Is_iPhone4) {
        lineView.frame = CGRectMake(0, self.height - 50 * HEIGHT_NIT, self.width, 0.5);
        
        self.tipsLabel.center = CGPointMake(self.tipsLabel.centerX, self.height - 100 * HEIGHT_NIT - 7.5 * HEIGHT_NIT);
    }
    
    self.progressView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 0.5)];
    [self addSubview:self.progressView];
    self.progressView.center = CGPointMake(self.progressView.centerX, lineView.centerY);
    self.progressView.backgroundColor = [UIColor whiteColor];
    
}

// 初始动画
- (void)initAction {
    
    NSInteger percent = arc4random() % 30 + 50;
    
    WEAK_SELF;
    [UIView animateWithDuration:3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        STRONG_SELF;
        
        self.progressView.frame = CGRectMake(self.progressView.left, self.progressView.top, SCREEN_W * (percent / 100.0), self.progressView.height);
        
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:1 delay:0.5 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            STRONG_SELF;
            
            NSInteger secPercent = arc4random() % 10 + 80;
            NSInteger thirdPercent = secPercent - percent;
            
            self.progressView.frame = CGRectMake(self.progressView.left, self.progressView.top, SCREEN_W * ((percent + thirdPercent / 2) / 100.0), self.progressView.height);
            
        } completion:^(BOOL finished) {
            
        }];
    }];
}

// 结束动画
- (void)stopAnimate {
    WEAK_SELF;
    [UIView animateWithDuration:0.4 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        STRONG_SELF;
        self.progressView.frame = CGRectMake(self.progressView.left, self.progressView.top, SCREEN_W, self.progressView.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
