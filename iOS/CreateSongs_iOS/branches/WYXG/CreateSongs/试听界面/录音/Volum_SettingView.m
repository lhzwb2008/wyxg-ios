//
//  Volum_SettingView.m
//  CreateSongs
//
//  Created by axg on 16/8/22.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "Volum_SettingView.h"
#import "AXGHeader.h"


@implementation Volum_SettingView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame withValueBlock:(void (^)(CGFloat))value {
    self = [super initWithFrame:frame];
    if (self) {
        self.sliderBlock = value;
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    CGSize titleSize = [@"" getWidth:@"人声" andFont:[UIFont boldSystemFontOfSize:15]];
    
    self.set_title = [UILabel new];
    self.set_title.frame = CGRectMake(16*WIDTH_NIT, 0, titleSize.width, titleSize.height);
    self.set_title.font = [UIFont boldSystemFontOfSize:15];
    self.set_title.textColor = [UIColor colorWithHexString:@"#451d11"];
    
    CGFloat sliderW = screenWidth() - self.set_title.right - 16 * WIDTH_NIT - 16 * WIDTH_NIT + 15;
    
    self.set_slider = [NMRangeSlider new];
    self.set_slider.delegate = self;
    self.set_slider.frame = CGRectMake(self.set_title.right + 6*WIDTH_NIT, 0, sliderW, self.height);
    self.set_title.centerY = self.height / 2;
    self.set_slider.centerY = self.height / 2;
    
    self.set_slider.upperValue = 0.5;
    
    [self addSubview:self.set_title];
    [self addSubview:self.set_slider];
    
//    [self volumeIsChanged:0.5];
}

/**
 *  超出父视图部分响应手势
 */
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    UIView *result = [super hitTest:point withEvent:event];

    CGPoint leftPoint = [self.set_slider convertPoint:point fromView:self];

    if ([self.set_slider pointInside:leftPoint withEvent:event]) {
        return self.set_slider;
    }
    return result;
}

- (void)volumeIsChanged:(CGFloat)volume {
    if (self.sliderBlock) {
        self.sliderBlock(volume);
    }
}

//- (NSString *)slider:(ASValueTrackingSlider *)slider stringForValue:(float)value {
//    
//    return nil;
//}

@end
