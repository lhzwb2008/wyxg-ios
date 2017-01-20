//
//  AXGRadarView.m
//  CreateSongs
//
//  Created by axg on 16/9/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AXGRadarView.h"
#import "AXGHeader.h"

@implementation AXGRadarView

-(void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    [[UIColor clearColor] setFill];
    UIRectFill(rect);
    NSInteger pulsingCount = 6;
    double animationDuration = 4;
    CALayer * animationLayer = [CALayer layer];
    for (int i = 0; i < pulsingCount; i++) {
        CALayer * pulsingLayer = [CALayer layer];
        pulsingLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
        pulsingLayer.borderColor = [UIColor colorWithHexString:@"#ffdc74"].CGColor;
        pulsingLayer.borderWidth = 0.5;
        pulsingLayer.cornerRadius = rect.size.height / 2;
        
        CAMediaTimingFunction * defaultCurve = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionDefault];
        
        CAAnimationGroup * animationGroup = [CAAnimationGroup animation];
        animationGroup.fillMode = kCAFillModeBackwards;
        animationGroup.beginTime = CACurrentMediaTime() + (double)i * animationDuration / (double)pulsingCount;
        animationGroup.duration = animationDuration;
        animationGroup.repeatCount = HUGE;
        animationGroup.timingFunction = defaultCurve;
        
        CABasicAnimation * scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.fromValue = @1.1;
        scaleAnimation.toValue = @2.5;
        
        CAKeyframeAnimation * opacityAnimation = [CAKeyframeAnimation animationWithKeyPath:@"opacity"];
        opacityAnimation.values = @[@1, @0.7, @0.65, @0.62, @0.6, @0.5, @0.4, @0.3, @0.2, @0.1, @0];
        opacityAnimation.keyTimes = @[@0, @0.1, @0.2, @0.3, @0.4, @0.5, @0.6, @0.7, @0.8, @0.9, @1];
        
//        opacityAnimation.values = @[@1, @0.5, @0];
//        opacityAnimation.keyTimes = @[@0, @0.5, @1];
        
        animationGroup.animations = @[scaleAnimation, opacityAnimation];
        [pulsingLayer addAnimation:animationGroup forKey:@"plulsing"];
        [animationLayer addSublayer:pulsingLayer];
    }
    [self.layer addSublayer:animationLayer];
}

@end
