//
//  PlayUserSongUserCell.h
//  CreateSongs
//
//  Created by axg on 16/5/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FocusButton.h"
#import "LoveAndShareBtn.h"

typedef void(^TurnToUserPageBlock)(NSString *userId);

typedef void(^SetLikeBlock)();

typedef void(^SetFocusBlock)();

typedef void(^PauseThePlayerBlock)();

typedef void(^ShareBlock)();

typedef void(^AddOrSubLikeBlock)(BOOL flag);

typedef void(^FanChangeBlock)();

@interface PlayUserSongUserCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, copy) NSString *userId;
@property (nonatomic, strong) UIImageView *userHeadImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *createTimeLabel;

@property (nonatomic, strong) FocusButton *focusBtn;
@property (nonatomic, strong) LoveAndShareBtn *loveBtn;
@property (nonatomic, strong) LoveAndShareBtn *shareBtn;
@property (nonatomic, strong) LoveAndShareBtn *moreBtn;
@property (nonatomic, strong) LoveAndShareBtn *fanchangBtn;

@property (nonatomic, strong) UIImageView *genderImageView;

@property (nonatomic, copy) NSString *code;

@property (nonatomic, copy) NSString *songId;
@property (nonatomic, copy) NSString *songName;
@property (nonatomic, copy) NSString *gender;

@property (nonatomic, assign) BOOL isFocus;
@property (nonatomic, assign) BOOL isLove;
@property (nonatomic, assign) BOOL hasSetCheat;

@property (nonatomic, strong) NSMutableDictionary *userInfoDic;



@property (nonatomic, copy) TurnToUserPageBlock turnToUserPageBlock;

@property (nonatomic, copy) SetLikeBlock setLikeBlock;

@property (nonatomic, copy) SetFocusBlock setFocusBlock;

@property (nonatomic, copy) PauseThePlayerBlock pauseBlock;

@property (nonatomic, copy) ShareBlock shareBlock;

@property (nonatomic, copy) AddOrSubLikeBlock addOrSubLikeBlock;

@property (nonatomic, copy) FanChangeBlock fanChangeBlock;

//@property (nonatomic, strong) NSMutableDictionary *dataSource;

+ (instancetype)customCommentCell:(UITableView *)tableView;
@end
