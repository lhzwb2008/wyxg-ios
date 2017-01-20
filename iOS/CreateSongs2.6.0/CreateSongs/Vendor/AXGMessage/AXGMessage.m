//
//  AXGMessage.m
//  lunbotest
//
//  Created by 爱写歌 on 16/7/23.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "AXGMessage.h"
#import "AXGHeader.h"

#define DURATION 0.8
#define END_DURATION 0.3
#define DAMPING 0.6
#define SPRING_VELOCITY 1

@implementation AXGMessage

static AXGMessage *messageView = nil;
+ (instancetype)shareMessageView {
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        messageView = [[AXGMessage alloc] initWithFrame:[UIScreen mainScreen].bounds];
    });
    return messageView;
}


// 创建文字选择弹窗
+ (void)showTextSelectMessageOnView:(UIView *)view title:(NSString *)title leftButton:(NSString *)left rightButton:(NSString *)right {
    
    AXGMessage *message = [AXGMessage shareMessageView];
    message.shouleTapHide = YES;
    [view addSubview:message];
    
    for (UIView *view in message.subviews) {
        [view removeFromSuperview];
    }
    
    [message createCenterViewOnView:message title:title leftButton:left rightButton:right];
}

+ (void)showPayResultMessageOnView:(UIView *)view title:(NSString *)title leftButton:(NSString *)left rightButton:(NSString *)right {
    
    AXGMessage *message = [AXGMessage shareMessageView];
    message.shouleTapHide = NO;
    [view addSubview:message];
    
    for (UIView *view in message.subviews) {
        [view removeFromSuperview];
    }
    
    [message createCenterViewOnView:message title:title leftButton:left rightButton:right];
    CGRect frame = message.titleLabel.frame;
    frame.origin.y += 6;
    message.titleLabel.frame = frame;
    
    CGRect frame1 = message.rightLabel.frame;
    frame1.origin.x = 0;
    frame1.size.width = 300 * WIDTH_NIT;
    message.rightLabel.frame = frame1;
    
    UILabel *line = [UILabel new];
    line.frame = CGRectMake(0, frame1.origin.y, 300*WIDTH_NIT, 1);
    line.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    [message.centerView addSubview:line];
    message.line = line;
}

// 创建图片选择弹窗
+ (void)showImageSelectMessageOnView:(UIView *)view leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage {
    AXGMessage *message = [AXGMessage shareMessageView];
    message.shouleTapHide = YES;
    [view addSubview:message];
    
    for (UIView *view in message.subviews) {
        [view removeFromSuperview];
    }
    
    [message createImageCenterViewOnView:view leftImage:leftImage rightImage:rightImage];
}

// 创建图片提示弹窗
+ (void)showImageToastOnView:(UIView *)view image:(UIImage *)image type:(NSInteger)type {
    AXGMessage *message = [AXGMessage shareMessageView];
    message.shouleTapHide = YES;
    [view addSubview:message];
    
    for (UIView *view in message.subviews) {
        [view removeFromSuperview];
    }
    
    [message createImageToastOnView:view image:image type:type];
    [message hideWithAnimation];
}

// 创建放大旋转提示框
+ (void)showRotateImageOnView:(UIView *)view image:(UIImage *)image {
    
    AXGMessage *message = [AXGMessage shareMessageView];
    [view addSubview:message];
    
    for (UIView *view in message.subviews) {
        [view removeFromSuperview];
    }
    
    [message createRotateImageOnView:view image:image];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [message hideMessage];
    });
    
}

// 隐藏弹出框
+ (void)hide {
    [[AXGMessage shareMessageView] hideMessage];
}


// 创建文字中心视图
- (void)createCenterViewOnView:(UIView *)view title:(NSString *)title leftButton:(NSString *)left rightButton:(NSString *)right {
    
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.maskView];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    self.maskView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskViewAction:)];
    [self.maskView addGestureRecognizer:tap];
    
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 300 * WIDTH_NIT, 115 * WIDTH_NIT)];
    self.centerView.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 - 10);
    self.centerView.layer.cornerRadius = 5 * WIDTH_NIT;
    self.centerView.layer.masksToBounds = YES;
    [self addSubview:self.centerView];
    self.centerView.backgroundColor = [UIColor whiteColor];
    CGPoint center = self.centerView.center;
    self.centerView.alpha = 0;
    
    self.centerView.center = CGPointMake(self.centerView.centerX, - self.centerView.height / 2);
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 300 * WIDTH_NIT, 65 * WIDTH_NIT)];
    [self.centerView addSubview:titleLabel];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.font = JIACU_FONT(15);
    titleLabel.textColor = HexStringColor(@"#535353");
    self.titleLabel = titleLabel;
    
    UILabel *leftTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 65 * WIDTH_NIT, 150 * WIDTH_NIT, 50 * WIDTH_NIT)];
    [self.centerView addSubview:leftTitle];
    leftTitle.text = left;
    leftTitle.textAlignment = NSTextAlignmentCenter;
    leftTitle.font = JIACU_FONT(15);
    leftTitle.textColor = HexStringColor(@"#a0a0a0");
    self.leftLabel = leftTitle;
    
    UILabel *rightTitle = [[UILabel alloc] initWithFrame:CGRectMake(150 * WIDTH_NIT, 65 * WIDTH_NIT, 150 * WIDTH_NIT, 50 * WIDTH_NIT)];
    [self.centerView addSubview:rightTitle];
    rightTitle.textAlignment = NSTextAlignmentCenter;
    rightTitle.text = right;
    rightTitle.font = JIACU_FONT(15);
    rightTitle.textColor = HexStringColor(@"#a06262");
    self.rightLabel = rightTitle;
    
    self.leftButton = [UIButton new];
    [self.centerView addSubview:self.leftButton];
    self.leftButton.frame = leftTitle.frame;
    self.leftButton.backgroundColor = [UIColor clearColor];
    [self.leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightButton = [UIButton new];
    [self.centerView addSubview:self.rightButton];
    self.rightButton.frame = rightTitle.frame;
    self.rightButton.backgroundColor = [UIColor clearColor];
    [self.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(0, titleLabel.bottom, self.width, 0.5)];
    [self.centerView addSubview:line1];
    line1.backgroundColor = HexStringColor(@"#eeeeee");
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(leftTitle.right, line1.bottom, 0.5, self.height - line1.bottom)];
    [self.centerView addSubview:line2];
    line2.backgroundColor = HexStringColor(@"#eeeeee");
    
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.maskView.alpha = 1;
//        self.centerView.alpha = 1;
//        self.centerView.center = center;
//    } completion:^(BOOL finished) {
//        
//    }];
    
    [UIView animateWithDuration:DURATION delay:0 usingSpringWithDamping:DAMPING initialSpringVelocity:SPRING_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.maskView.alpha = 1;
        self.centerView.alpha = 1;
        self.centerView.center = center;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

// 创建图片中心视图
- (void)createImageCenterViewOnView:(UIView *)view leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage {
    
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.maskView];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    self.maskView.alpha = 0;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskViewAction:)];
    [self.maskView addGestureRecognizer:tap];
    
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 305 * WIDTH_NIT, 175 * WIDTH_NIT)];
    self.centerView.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 - 10);
    self.centerView.layer.cornerRadius = 5 * WIDTH_NIT;
    self.centerView.layer.masksToBounds = YES;
    [self addSubview:self.centerView];
    self.centerView.backgroundColor = [UIColor whiteColor];
    
    CGPoint center = self.centerView.center;
    
    self.centerView.center = CGPointMake(self.centerView.centerX, - self.centerView.height / 2);
    self.centerView.alpha = 0;
    
    UIImageView *leftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60 * WIDTH_NIT, 50 * WIDTH_NIT, 55 * WIDTH_NIT, 80 * WIDTH_NIT)];
    [self.centerView addSubview:leftImageView];
    leftImageView.image = leftImage;
    
    UIImageView *rightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(leftImageView.right + 75 * WIDTH_NIT, leftImageView.top, leftImageView.width, leftImageView.height)];
    [self.centerView addSubview:rightImageView];
    rightImageView.image = rightImage;
    
    self.leftButton = [UIButton new];
    [self.centerView addSubview:self.leftButton];
    self.leftButton.frame = leftImageView.frame;
    self.leftButton.backgroundColor = [UIColor clearColor];
    [self.leftButton addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightButton = [UIButton new];
    [self.centerView addSubview:self.rightButton];
    self.rightButton.frame = rightImageView.frame;
    self.rightButton.backgroundColor = [UIColor clearColor];
    [self.rightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        self.maskView.alpha = 1;
//        self.centerView.alpha = 1;
//        self.centerView.center = center;
//    } completion:^(BOOL finished) {
//        
//    }];
    
    [UIView animateWithDuration:DURATION delay:0 usingSpringWithDamping:DAMPING initialSpringVelocity:SPRING_VELOCITY options:UIViewAnimationOptionCurveEaseOut animations:^{
        
        self.maskView.alpha = 1;
        self.centerView.alpha = 1;
        self.centerView.center = center;
        
    } completion:^(BOOL finished) {
        
    }];
    
}

- (void)createRotateImageOnView:(UIView *)view image:(UIImage *)image {
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.maskView];
    self.maskView.backgroundColor = [UIColor clearColor];
    
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200 * WIDTH_NIT, 200 * WIDTH_NIT)];
    self.centerView.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 - 10);
    self.centerView.layer.cornerRadius = 5 * WIDTH_NIT;
    self.centerView.layer.masksToBounds = YES;
    [self addSubview:self.centerView];
    self.centerView.backgroundColor = [UIColor clearColor];
    
    self.toastImage = [UIImageView new];
    self.toastImage.frame = CGRectMake(0, 0, 150 * WIDTH_NIT, 150 * WIDTH_NIT);
    self.toastImage.center = CGPointMake(self.centerView.width / 2, self.centerView.height / 2);
    self.toastImage.image = image;
    [self.centerView addSubview:self.toastImage];
    self.toastImage.hidden = YES;
    
    CAKeyframeAnimation *opacityAnimation = [CAKeyframeAnimation animation];
    opacityAnimation.keyPath = @"opacity";
    opacityAnimation.values = @[@0, @(1), @(1), @(1), @(0)];
    opacityAnimation.repeatCount = 1;
    opacityAnimation.keyTimes = @[@(0), @(0.4), @(0.6), @(0.8), @(1)];
    
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animation];
    scaleAnimation.keyPath = @"transform.scale";
    scaleAnimation.values = @[@0, @(1.2), @(1.0), @(1.0), @(0)];
    scaleAnimation.repeatCount = 1;
    scaleAnimation.keyTimes = @[@(0), @(0.4), @(0.6), @(0.8), @(1)];
    
    CAKeyframeAnimation * keyAnimaion = [CAKeyframeAnimation animation];
    keyAnimaion.keyPath = @"transform.rotation";
    keyAnimaion.values = @[@(0 - M_PI_2), @(M_PI_2 + M_PI_4 - M_PI_2), @(M_PI_2 - M_PI_2), @(M_PI_2 - M_PI_2), @(0 - M_PI_2)];//度数转弧度
    keyAnimaion.repeatCount = 1;
    keyAnimaion.keyTimes = @[@(0), @(0.4), @(0.6), @(0.8), @(1)];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.animations = @[opacityAnimation, scaleAnimation, keyAnimaion];
    group.duration = 1;
    group.fillMode = kCAFillModeForwards;
    group.removedOnCompletion = NO;
    
    self.toastImage.hidden = NO;
    [self.toastImage.layer addAnimation:group forKey:nil];
    
}

- (void)createImageToastOnView:(UIView *)view image:(UIImage *)image type:(NSInteger)type {
    self.maskView = [[UIView alloc] initWithFrame:self.bounds];
    [self addSubview:self.maskView];
    self.maskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskViewAction:)];
    [self.maskView addGestureRecognizer:tap];
    
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200 * WIDTH_NIT, 175 * WIDTH_NIT)];
    self.centerView.center = CGPointMake(view.frame.size.width / 2, view.frame.size.height / 2 - 10);
    self.centerView.layer.cornerRadius = 5 * WIDTH_NIT;
    self.centerView.layer.masksToBounds = YES;
    [self addSubview:self.centerView];
    self.centerView.backgroundColor = [UIColor whiteColor];
    
    self.toastImage = [UIImageView new];
    [self.centerView addSubview:self.toastImage];
    
    // 0 提交成功
    switch (type) {
        case 0: {
            self.toastImage.frame = CGRectMake(65 * WIDTH_NIT, 34 * WIDTH_NIT, 77 * WIDTH_NIT, 117.5 * WIDTH_NIT);
            self.toastImage.image = image;
        }
            break;
        case 1: {
            self.toastImage.frame = CGRectMake(65 * WIDTH_NIT, 40 * WIDTH_NIT, 70 * WIDTH_NIT, 108 * WIDTH_NIT);
            self.toastImage.image = image;
        }
            
        default:
            break;
    }
    
}

// 隐藏弹出框
- (void)hideMessage {
    [[AXGMessage shareMessageView] removeFromSuperview];
}

// 渐隐
- (void)hideWithAnimation {
    [UIView animateWithDuration:END_DURATION delay:0.5 options:UIViewAnimationOptionCurveLinear animations:^{
        [AXGMessage shareMessageView].alpha = 0;
    } completion:^(BOOL finished) {
        [self hideMessage];
        [AXGMessage shareMessageView].alpha = 1;
        if (self.hideBlock) {
            self.hideBlock();
        }
    }];
}

// 选择框渐隐
- (void)selectHideAnimateion {
    [UIView animateWithDuration:END_DURATION delay:0 options:UIViewAnimationOptionCurveLinear animations:^{
       
        self.centerView.center = CGPointMake(self.centerView.centerX, self.height + self.centerView.height / 2);
        self.centerView.alpha = 0;
        self.maskView.alpha = 0;
        
    } completion:^(BOOL finished) {
        [self hideMessage];
        self.centerView.alpha = 1;
        self.maskView.alpha = 1;
        if (self.hideBlock) {
            self.hideBlock();
        }
    }];
}

// 点击背景方法
- (void)tapMaskViewAction:(UITapGestureRecognizer *)tap {
    if (!self.shouleTapHide) {
        return;
    }
    [self selectHideAnimateion];
}

// 左边按钮方法
- (void)leftButtonAction:(UIButton *)sender {
    [self selectHideAnimateion];
    if (self.leftButtonBlock) {
        self.leftButtonBlock();
    }
}

// 右边按钮方法
- (void)rightButtonAction:(UIButton *)sender {
    [self selectHideAnimateion];
    if (self.rightButtonBlock) {
        self.rightButtonBlock();
    }
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
