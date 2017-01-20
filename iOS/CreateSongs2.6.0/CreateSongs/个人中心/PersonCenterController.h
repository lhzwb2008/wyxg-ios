//
//  PersonCenterController.h
//  CreateSongs
//
//  Created by axg on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PersonBaseController.h"
@class AXGNavigationController;
@class DrawerViewController;

@interface PersonCenterController : PersonBaseController

@property (nonatomic, strong) UIView *panView;

@property (nonatomic, assign) CGFloat tmpOffsetY;

@property (nonatomic, assign) BOOL shouldHideNav;

@property (nonatomic, assign) BOOL isFocus;

@property (nonatomic, assign) NSInteger selectedIndex;

@property (nonatomic, strong) DrawerViewController *drawerVC;

@property (nonatomic, strong) AXGNavigationController *axgNavigation;

@property (nonatomic, copy) NSString *sixinName;

@property (nonatomic, copy) NSString *sixinImg;

- (NSString *)getUserId;
// 关注按钮方法
- (void)focusButtonAction:(UIButton *)sender;

- (void)clickHeadImage;
- (instancetype)initWIthUserId:(NSString *)userId;

- (void)createMsgView;

@end
