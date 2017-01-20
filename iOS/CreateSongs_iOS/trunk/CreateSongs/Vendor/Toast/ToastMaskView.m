//
//  ToastMaskView.m
//  BaseBusiness
//
//  Created by Somiya on 15/10/20.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ToastMaskView.h"

@implementation ToastMaskView

@synthesize delegate;
@synthesize isHideWhenTouchBackground;

#pragma mark - --------------------退出清空--------------------

- (void)dealloc
{
    delegate = nil;
}

#pragma mark - --------------------初始化--------------------


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
            // Initialization code
        [self initData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initData];
    }
    return self;
}

#pragma mark 初始化数据
- (void)initData
{
    self.isHideWhenTouchBackground = YES;
}
#pragma mark - --------------------System--------------------

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (YES == self.isHideWhenTouchBackground) {
        [self hide];
    }
}
#pragma mark - --------------------接口API--------------------

#pragma mark 隐藏遮罩view
- (void)hide
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(maskView:willRemoveFromSuperView:)]) {
        [self.delegate maskView:self willRemoveFromSuperView:self.superview];
    }
    [UIView animateWithDuration:.5f animations:^{
        [self setAlpha:0.0f];
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}


@end
