//
//  ToastView.m
//  BaseBusiness
//
//  Created by Somiya on 15/10/20.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import "ToastView.h"
#import "ToastMaskView.h"
#import "UIColor+expanded.h"
#import "GifView.h"
#import "AXGHeader.h"

@interface ToastView ()

@property (nonatomic, strong) ToastMaskView *maskView;
@property (nonatomic, strong) NSString *toastMessage;
@property (nonatomic, strong) UILabel *toastLabel;
@property (nonatomic, strong) UIView *customView;

- (void)forceHide;
@end
static ToastView *toastView;
@implementation ToastView
#pragma mark - --------------------退出清空--------------------

- (void)dealloc
{
    [_maskView removeFromSuperview], _maskView = nil;
}
#pragma mark - --------------------初始化--------------------

+ (ToastView *)sharedToastView {
    if (!toastView) {
        toastView = [[[self class] alloc] init];
    }
    return toastView;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        [self setFrame:CGRectMake(0, 0, 250, 44)];
        [self initData];
        [self initBaseView];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self initData];
    [self initBaseView];
}

- (void)initData {
    self.toastType = ToastViewTypeDefault;
    self.isHiddenMaskView = NO;
    [self addObserver:self forKeyPath:@"toastType" options:NSKeyValueObservingOptionOld | NSKeyValueObservingOptionNew context:nil];
}

- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    if (_toastLabel) {
        int edge = 10; 
        [_toastLabel setFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(edge, edge, edge, edge))];
    }
}

- (void)initBaseView
{
    [self setBackgroundColor:[[UIColor blackColor] colorWithAlphaComponent:0.7]];
    
    if (!_toastLabel) {
        _toastLabel = [[UILabel alloc] initWithFrame:UIEdgeInsetsInsetRect(self.bounds, UIEdgeInsetsMake(2, 10, 2, 10))];
        [_toastLabel setBackgroundColor:[UIColor clearColor]];
        [_toastLabel setTextAlignment:NSTextAlignmentCenter];
        [_toastLabel setTextColor:[UIColor whiteColor]];
        [_toastLabel setFont:kCTToastTipViewTextFont];
        _toastLabel.numberOfLines = INT_MAX;
    }
    
    [self addSubview:_toastLabel];
    
    [self setClipsToBounds:YES];
    [self.layer setCornerRadius:5];
}

- (void)willMoveToWindow:(UIWindow *)newWindow
{
    [super willMoveToWindow:newWindow];
    
    if (newWindow) {
        if (_toastLabel) {
            [_toastLabel setText:self.toastMessage];
        }
    }
}

- (void)setIsHiddenMaskView:(BOOL)isHiddenMaskView {
    _isHiddenMaskView = isHiddenMaskView;
    self.maskView.hidden = isHiddenMaskView;
}

#pragma mark ----------------observer----------------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    if ([keyPath isEqualToString:@"toastType"]) {
        
    }
}

#pragma mark ----------------功能函数----------------
- (void)showLoadingViewInView:(UIView *)view {
    if (!_isHiddenMaskView) {
        if (!_maskView) {
            _maskView = [[ToastMaskView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_W, SCREEN_H)];
        }
        _maskView.backgroundColor = [UIColor blackColor];
        _maskView.alpha = 0.3f;
        _maskView.isHideWhenTouchBackground = NO;
        [view addSubview:_maskView];
        [view addSubview:self];
        [self setCenter:CGPointMake(_maskView.bounds.size.width/2.0, _maskView.bounds.size.height/2.0)];
//        [view addSubview:_maskView];
    } else {
        [self setCenter:CGPointMake(view.bounds.size.width/2.0, view.bounds.size.height/2.0)];
        [view addSubview:self];
    }
//    self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    self.backgroundColor = [UIColor clearColor];
    self.layer.opacity = 1.0;
    [view bringSubviewToFront:self];
//    UIView *mask_v = [UIView new];
//    mask_v.frame = CGRectMake(0, 0, 80, 80);
//    mask_v.center = self.center;
//    mask_v.backgroundColor = [UIColor blackColor];
//    mask_v.alpha = 1;
//    [self.superview addSubview:mask_v];
    
    
    
    if (self.imageB == nil) {
        
//        UIBlurEffect * effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
//        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:effect];
//        blurView.frame = CGRectMake(0, 0, self.width, self.height);
////        blurView.clipsToBounds = YES;
////        blurView.layer.cornerRadius = 5;
//        blurView.alpha = 0.95f;
//        [self addSubview:blurView];
        
        
        
        UIView *bgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 10 * HEIGHT_NIT, self.width, self.height)];
        bgView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
        [self addSubview:bgView];
        bgView.layer.cornerRadius = 10;
        bgView.layer.masksToBounds = YES;
        
        self.imageB = [[UIImageView alloc] initWithFrame:self.bounds];
//        self.imageB = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.height, self.width)];
        self.imageB.image = [[UIImage imageNamed:@"newToastCenter"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        
        [self addSubview:self.imageB];
        
        CGPoint center = self.imageB.center;
        
        self.imageB.frame = CGRectMake(self.imageB.left, self.imageB.top, self.imageB.width * WIDTH_NIT, self.imageB.height * WIDTH_NIT);
        self.imageB.center = center;
//        self.imageB.center = CGPointMake(center.x, center.y - 40 * HEIGHT_NIT);
//
////        blurView.frame = self.imageB.frame;
//        blurView.frame = CGRectMake(self.imageB.left, self.imageB.top - 20, self.imageB.width * WIDTH_NIT * 1.1, self.imageB.width * WIDTH_NIT * 1.1);
//        blurView.center = CGPointMake(center.x, self.imageB.centerY + 15 * HEIGHT_NIT);
//        blurView.layer.cornerRadius = 10;
//        blurView.layer.masksToBounds = YES;
    }
    if (self.imageR == nil) {
        self.imageR = [[UIImageView alloc] initWithFrame:self.bounds];
        self.imageR.contentMode = UIViewContentModeScaleAspectFit;
        self.imageR.image = [UIImage imageNamed:@"newToastRotate"];
        [self addSubview:self.imageR];
        
        CGPoint center = self.imageB.center;
        
        self.imageR.frame = CGRectMake(self.imageR.left, self.imageR.top, self.imageR.width * WIDTH_NIT, self.imageR.height * WIDTH_NIT);
        self.imageR.center = center;
        
//        self.imageR.center = CGPointMake(center.x, center.y - 40 * HEIGHT_NIT);
        
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.imageR.left, self.imageR.bottom - 25 * HEIGHT_NIT, self.imageR.width, 30 * WIDTH_NIT)];
        [self addSubview:label];
        label.text = @"正在制作中";
        label.font = [UIFont systemFontOfSize:12];
        label.textAlignment = NSTextAlignmentCenter;
        label.textColor = [UIColor colorWithRed:140 / 255.0 green:140 / 255.0 blue:140 / 255.0 alpha:1];
        
    }
    
    self.clipsToBounds = NO;
    
//    UIImageView *imageB = [[UIImageView alloc] initWithFrame:self.bounds];
////    imageB.contentMode = UIViewContentModeScaleAspectFit;
//    imageB.image = [[UIImage imageNamed:@"tz1"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [self addSubview:imageB];
//    UIImageView *imageR = [[UIImageView alloc] initWithFrame:self.bounds];
//    imageR.contentMode = UIViewContentModeScaleAspectFit;
//    imageR.image = [[UIImage imageNamed:@"tz2"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
//    [self addSubview:imageR];
    
    
    self.rotating = YES;
    
//    [self rotate:imageR];
    
    
    [self rotate:self.imageR];

//    [self fadeInAnimation];
}
- (void)showCustomViewInView:(UIView *)view {
    if (!_isHiddenMaskView) {
        if (!_maskView) {
            _maskView = [[ToastMaskView alloc] initWithFrame:view.bounds];
        }
        
        [_maskView addSubview:self];
        [self setCenter:CGPointMake(_maskView.bounds.size.width/2.0, _maskView.bounds.size.height/2.0)];
        self.layer.opacity = 0.0;
        [self addSubview:self.customView];
        [view addSubview:_maskView];
    } else {
        [self setCenter:CGPointMake(view.bounds.size.width / 2.0, view.bounds.size.height/2.0)];
        self.layer.opacity = 0.0;
        [view addSubview:self];
        [self addSubview:self.customView];
    }
    [self fadeInAnimation];
    
}
- (void)showInView:(UIView *)view
{
    if (!_isHiddenMaskView) {
        if (!_maskView) {
            _maskView = [[ToastMaskView alloc] initWithFrame:view.bounds];
        }
        
        [_maskView addSubview:self];
        [self setCenter:CGPointMake(_maskView.bounds.size.width/2.0, _maskView.bounds.size.height/2.0)];
        self.layer.opacity = 0.0;
        [view addSubview:_maskView];
    } else {
        [self setCenter:CGPointMake(view.bounds.size.width/2.0, view.bounds.size.height/2.0)];
        self.layer.opacity = 0.0;
        [view addSubview:self];
    }

    
    [self fadeInAnimationAfterDelay:kCTToastTipViewDisplayDuration];
}

- (void)showInView:(UIView *)view WithDisplayTime:(NSTimeInterval)iSecond
{
    if (!_maskView) {
        _maskView = [[ToastMaskView alloc] initWithFrame:view.bounds];
    }
    
    [_maskView addSubview:self];
    
    [self setCenter:CGPointMake(view.bounds.size.width/2.0, view.bounds.size.height/2.0)];
    self.layer.opacity = 0.0;
    [view addSubview:_maskView];
    
    [self fadeInAnimationAfterDelay:iSecond];
}


- (void)rotate:(UIView *)view {
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        view.transform = CGAffineTransformRotate(view.transform, M_PI);
    } completion:^(BOOL finished) {
        if (self.rotating) {
            [self rotate:view];
        }
    }];
}
- (void)stopAnimation {
    self.rotating = NO;
}


- (void)fadeInAnimationAfterDelay:(NSTimeInterval)delay
{
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        [self performSelector:@selector(fadeOutAnimation) withObject:nil afterDelay:kCTToastTipViewDisplayDuration];
    }];
    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeInAnimation setDuration:kCTToastTipViewFadeinDuration];
    [fadeInAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
    [fadeInAnimation setToValue:[NSNumber numberWithFloat:1.0]];
    [fadeInAnimation setRemovedOnCompletion:NO];
    [fadeInAnimation setFillMode:kCAFillModeForwards];
    [fadeInAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    [self.layer addAnimation:fadeInAnimation forKey:@"fadeIn"];
    
    [CATransaction commit];
}

- (void)fadeInAnimation
{
    [CATransaction begin];

    CABasicAnimation *fadeInAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeInAnimation setDuration:kCTToastTipViewFadeinDuration];
    [fadeInAnimation setFromValue:[NSNumber numberWithFloat:0.0]];
    [fadeInAnimation setToValue:[NSNumber numberWithFloat:1.0]];
    [fadeInAnimation setRemovedOnCompletion:NO];
    [fadeInAnimation setFillMode:kCAFillModeForwards];
    [fadeInAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    [self.layer addAnimation:fadeInAnimation forKey:@"fadeIn"];
    
    [CATransaction commit];
}

- (void)fadeOutAnimation
{
    [CATransaction begin];
    
    [CATransaction setCompletionBlock:^{
        [self forceHide];
    }];
    
    CABasicAnimation *fadeOutAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    [fadeOutAnimation setDuration:kCTToastTipViewFadeoutDuration];
    [fadeOutAnimation setFromValue:[NSNumber numberWithFloat:1.0]];
    [fadeOutAnimation setToValue:[NSNumber numberWithFloat:0.0]];
    [fadeOutAnimation setRemovedOnCompletion:NO];
    [fadeOutAnimation setFillMode:kCAFillModeForwards];
    [fadeOutAnimation setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionLinear]];
    
    [self.layer addAnimation:fadeOutAnimation forKey:@"fadeOut"];
    
    [CATransaction commit];
}

#pragma mark ----------------接口API----------------
#pragma mark 强制消失
- (void)forceHide
{
    self.rotating = NO;
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(fadeOutAnimation) object:nil];
    [self removeFromSuperview];
    [_maskView removeFromSuperview], _maskView = nil;
}

#pragma mark Toast样式提示自定义内容
- (void)showToastViewWithMessage:(NSString *)message inView:(UIView *)view {
    
    if (_maskView) {
        _maskView = nil;
    }
    CGSize textSize =  [message boundingRectWithSize:CGSizeMake(250-30, 320) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:kCTToastTipViewTextFont} context:nil].size;
    
    if (textSize.height > 20) {
        int viewHeight = 15 + textSize.height + 15;
        CGRect toastFrame = toastView.frame;
        toastFrame.size.height = viewHeight;
        toastView.frame = toastFrame;
    }
    
    toastView.toastMessage = message;
    [toastView showInView:view];
}

- (void)showCustomView:(UIView *)customView inView:(UIView *)view{
    if (_maskView) {
        _maskView = nil;
    }
    CGRect frame = toastView.frame;
    frame.size.width = 80;
    frame.size.height = 80;
    toastView.frame = frame;
    toastView.customView = customView;
    [toastView showCustomViewInView:view];
}
- (void)showLoadingViewWithMessage:(NSString *)message inView:(UIView *)view {
    if (_maskView) {
        _maskView = nil;
    }
    CGRect frame = toastView.frame;
    frame.size.width = 100;
    frame.size.height = 100;
    toastView.frame = frame;
    
    [toastView showLoadingViewInView:view];
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
