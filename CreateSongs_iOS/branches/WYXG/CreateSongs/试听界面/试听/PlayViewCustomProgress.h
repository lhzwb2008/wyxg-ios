//
//  PlayViewCustomProgress.h
//  CreateSongs
//
//  Created by axg on 16/5/11.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayUserSongCustomProgressView.h"
#import "ASValueTrackingSlider.h"
//typedef enum : NSUInteger {
//    RecordingType,
//    PlayingType,
//} ProgressType;

typedef void(^PlayBtnBlock)(BOOL isPlaying);

typedef void(^SliderDidChangedBlock)(CGFloat value);

@interface PlayViewCustomProgress : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong) ASValueTrackingSlider *sliderView;

@property (nonatomic, strong) UILabel *currentTime;
@property (nonatomic, strong) UILabel *totalTime;

@property (nonatomic, strong) UIButton *playBtn;
@property (nonatomic, strong) UIButton *playHotBtn;

@property (nonatomic, copy) PlayBtnBlock playBtnBlock;

@property (nonatomic, assign) ProgressType progressType;

@property (nonatomic, copy)  SliderDidChangedBlock sliderDidChangedBlock;

- (instancetype)initWithFrame:(CGRect)frame andType:(ProgressType)progressType;

- (void)setProgress:(CGFloat)progressValue withAnimated:(BOOL)animated;

- (void)changeToProgressType:(ProgressType)progressType;

@end
