//
//  ForumViewController.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/22.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BaseViewController.h"
@class AXGNavigationController;
@class DrawerViewController;

@interface ForumViewController : BaseViewController

@property (nonatomic, strong) DrawerViewController *drawerVC;

@property (nonatomic, strong) AXGNavigationController *axgNavigation;

@end
