//
//  AXGSlider.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/20.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SliderDidChangedBlock)(CGFloat value);

@interface AXGSlider : UIView<UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIImageView *sliderView;

@property (nonatomic, strong) UILabel *sliderLabel;

@property (nonatomic, assign) CGFloat firstX;

@property (nonatomic, assign) CGFloat firstY;

@property (nonatomic, assign) CGFloat speedScale;
/**
 *  滑动block
 */
@property (nonatomic, copy) SliderDidChangedBlock sliderDidChangedBlock;

@end
