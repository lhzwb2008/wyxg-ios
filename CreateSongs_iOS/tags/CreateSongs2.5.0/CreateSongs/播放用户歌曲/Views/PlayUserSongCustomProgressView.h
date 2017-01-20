//
//  PlayUserSongCustomProgressView.h
//  CreateSongs
//
//  Created by axg on 16/5/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    RecordingType,
    PlayingType,
} ProgressType;

typedef void(^PlayBtnBlock)(BOOL isPlaying);

typedef void(^SliderDidChangedBlock)(CGFloat value);


@interface PlayUserSongCustomProgressView : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UILabel *currentTime;
@property (nonatomic, strong) UILabel *totalTime;

@property (nonatomic, strong) UIImageView *bgImageView;

@property (nonatomic, assign) ProgressType progressType;

@property (nonatomic, copy)  SliderDidChangedBlock sliderDidChangedBlock;

@property (nonatomic, copy) PlayBtnBlock playBtnBlock;

- (instancetype)initWithFrame:(CGRect)frame andType:(ProgressType)progressType;

- (void)setProgress:(CGFloat)progressValue withAnimated:(BOOL)animated;

- (void)changeToProgressType:(ProgressType)progressType;

@end
