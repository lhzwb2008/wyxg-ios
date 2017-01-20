//
//  Volum_SettingView.h
//  CreateSongs
//
//  Created by axg on 16/8/22.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASValueTrackingSlider.h"
#import "NMRangeSlider.h"

typedef void(^SliderBlock)(CGFloat value);

@interface Volum_SettingView : UIView<ASValueTrackingSliderDataSource, VolumeSliderProtocol>

//@property (nonatomic, strong)

@property (nonatomic, copy) SliderBlock sliderBlock;

@property (nonatomic, strong) NMRangeSlider *set_slider;

@property (nonatomic, strong) UILabel *set_title;

- (instancetype)initWithFrame:(CGRect)frame withValueBlock:(void(^)(CGFloat value))value;

@end
