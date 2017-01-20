//
//  ModifyViewController.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/26.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BaseViewController.h"
@class PersonInfoView;
@class AXGNavigationController;
@class DrawerViewController;

@interface ModifyViewController : BaseViewController

@property (nonatomic, strong) PersonInfoView *personInfoView;

@property (nonatomic, strong) DrawerViewController *drawerVC;

@property (nonatomic, strong) AXGNavigationController *axgNavigation;

@property (nonatomic, assign) BOOL fromDrawer;

@end
