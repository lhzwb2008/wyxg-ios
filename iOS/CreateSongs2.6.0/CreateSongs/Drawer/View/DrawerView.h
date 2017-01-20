//
//  DrawerView.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/15.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DrawerButton.h"
#import "DrawerSettingButton.h"
#import "MsgButton.h"

typedef void(^DrawerSelected)(NSInteger index);

//typedef void(^DrawerMsgClickBlock)();

@interface DrawerView : UIView

@property (nonatomic, strong) UIImageView *themeImage;

@property (nonatomic, strong) UILabel *nameLabel;

//@property (nonatomic, strong) UIImageView *homeImage;
//
//@property (nonatomic, strong) UIImageView *personImage;
//
//@property (nonatomic, strong) UIImageView *draftsImage;
//
//@property (nonatomic, strong) UIImageView *suggestionImage;
//
//@property (nonatomic, strong) UILabel *homeLabel;
//
//@property (nonatomic, strong) UILabel *personLabel;
//
//@property (nonatomic, strong) UILabel *draftsLabel;
//
//@property (nonatomic, strong) UILabel *suggesttionLabel;

@property (nonatomic, strong) DrawerButton *homeButton;

@property (nonatomic, strong) DrawerButton *personButton;

@property (nonatomic, strong) DrawerButton *draftsButton;

@property (nonatomic, strong) DrawerButton *suggestionButton;

@property (nonatomic, strong) DrawerButton *walletButton;

@property (nonatomic, copy) DrawerSelected drawerSelected;

@property (nonatomic, strong) MsgButton *msgButton;

//@property (nonatomic, strong) UIImageView *forumImage;
//
//@property (nonatomic, strong) UILabel *forumLabel;

@property (nonatomic, strong) DrawerButton *forumButton;

//@property (nonatomic, copy) DrawerMsgClickBlock drawerMsgClickBlock;

- (void)buttonAction:(UIButton *)sender;

- (void)changeShowState:(NSInteger)index;

@end
