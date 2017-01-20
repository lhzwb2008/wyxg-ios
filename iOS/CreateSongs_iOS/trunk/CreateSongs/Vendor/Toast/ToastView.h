//
//  ToastView.h
//  BaseBusiness
//
//  Created by Somiya on 15/10/20.
//  Copyright © 2015年 Somiya. All rights reserved.
//

#import <UIKit/UIKit.h>

    //渐入动画时间
#define kCTToastTipViewFadeinDuration 0.2
    //停留显示时间
#define kCTToastTipViewDisplayDuration 0.5
    //渐出动画时间
#define kCTToastTipViewFadeoutDuration 0.3
    //提示文本字体
#define kCTToastTipViewTextFont [UIFont systemFontOfSize:15]

typedef NS_ENUM(NSUInteger, ToastViewType) {
    ToastViewTypeDefault,
    ToastViewTypeLoading,
    ToastViewTypeProgressing,
    ToastViewTypeDone,
    ToastViewTypeFaild,
    ToastViewTypeCustom
};
@interface ToastView : UIView

#pragma mark ----------------ToastView设置----------------
@property (nonatomic, strong) UIColor *tintColor;
@property (nonatomic, assign) ToastViewType toastType;
@property (nonatomic, assign) BOOL rotating;

#pragma mark ----------------遮罩层设置----------------
    //遮罩层显隐
@property (nonatomic, assign) BOOL isHiddenMaskView;
    //遮罩层透明度
@property (nonatomic, assign) CGFloat maskViewOpaque;
    //遮罩层背景颜色
@property (nonatomic, strong) UIColor *maskViewBgColor;

// 加载图
@property (nonatomic, strong) UIImageView *imageB;
@property (nonatomic, strong) UIImageView *imageR;

+ (ToastView *)sharedToastView;

#pragma mark ----------------ToastView API----------------
- (void)forceHide;
- (void)showToastViewWithMessage:(NSString *)message inView:(UIView *)view;
- (void)showCustomView:(UIView *)customView inView:(UIView *)view;
- (void)showLoadingViewWithMessage:(NSString *)message inView:(UIView *)view;
@end
