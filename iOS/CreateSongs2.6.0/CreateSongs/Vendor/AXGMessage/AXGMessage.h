//
//  AXGMessage.h
//  lunbotest
//
//  Created by 爱写歌 on 16/7/23.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^LeftButtonBlock)();

typedef void(^RightButtonBlock)();

typedef void(^HideBlock)();

@interface AXGMessage : UIView

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIImageView *toastImage;

@property (nonatomic, assign) BOOL shouleTapHide;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UILabel *rightLabel;
@property (nonatomic, strong) UILabel *line;

@property (nonatomic, strong) UIButton *leftButton;

@property (nonatomic, strong) UIButton *rightButton;

@property (nonatomic, copy) LeftButtonBlock leftButtonBlock;

@property (nonatomic, copy) RightButtonBlock rightButtonBlock;

@property (nonatomic, copy) HideBlock hideBlock;

+ (instancetype)shareMessageView;

+ (void)showTextSelectMessageOnView:(UIView *)view title:(NSString *)title leftButton:(NSString *)left rightButton:(NSString *)right;
+ (void)showPayResultMessageOnView:(UIView *)view title:(NSString *)title leftButton:(NSString *)left rightButton:(NSString *)right;

+ (void)showImageSelectMessageOnView:(UIView *)view leftImage:(UIImage *)leftImage rightImage:(UIImage *)rightImage;

+ (void)showImageToastOnView:(UIView *)view image:(UIImage *)image type:(NSInteger)type;

+ (void)showRotateImageOnView:(UIView *)view image:(UIImage *)image;

+ (void)hide;

@end
