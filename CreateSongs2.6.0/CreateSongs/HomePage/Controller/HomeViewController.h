//
//  HomeViewController.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/13.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BaseViewController.h"
@class AXGNavigationController;
@class DrawerViewController;

@interface HomeViewController : BaseViewController {
    int _flag;
    NSTimer *_timer;
}

@property (nonatomic, assign)  BOOL expanding;

@property (nonatomic, strong) NSMutableArray *menusArray;

@property (nonatomic, strong) UIButton *bottomBtnMaskView;

@property (nonatomic, strong) DrawerViewController *drawerVC;

@property (nonatomic, strong) AXGNavigationController *axgNavigation;

@property (nonatomic, strong) UILabel *xianciLabel;
@property (nonatomic, strong) UILabel *xianquLabel;

- (void)newClick:(UIButton *)btn;

- (void)reloadHome;

@end
