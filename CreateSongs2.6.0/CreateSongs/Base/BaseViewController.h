//
//  BaseViewController.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/13.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXGHeader.h"
#import "NavLeftButton.h"
#import "NavRightButton.h"

@interface BaseViewController : UIViewController

// 导航栏
@property (nonatomic, strong) UIView *navFakeView;
@property (nonatomic, strong) UIView *navView;

@property (nonatomic, strong) UIImageView *navLeftImage;

@property (nonatomic, strong) NavLeftButton *navLeftButton;

@property (nonatomic, strong) UIImageView *navRightImage;

@property (nonatomic, strong) NavRightButton *navRightButton;

@property (nonatomic, strong) UILabel *navTitle;

@property (nonatomic, strong) UIView *msgView;

- (void)initNavView;


- (NSString *)setTitleTxt;
- (UIImage *)setLeftBtnImage;
- (UIImage *)setRightBtnImage;


@end
