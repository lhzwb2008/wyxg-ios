//
//  DrawerViewController.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerView.h"
#import "CreateSongs-Swift.h"

@interface DrawerViewController : UIViewController

@property (nonatomic, strong) DrawerView *drawerView;

@property (nonatomic, strong) KYDrawerController *kyDrawer;

- (void)changeDrawerState:(NSInteger)index;

@end
