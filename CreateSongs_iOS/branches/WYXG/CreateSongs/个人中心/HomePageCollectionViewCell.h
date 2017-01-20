//
//  HomePageCollectionViewCell.h
//  CreateSongs
//
//  Created by axg on 16/3/19.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageModel.h"
@class UserModel;

typedef void(^MoreActionBlock)(NSString *code, NSString *title);

@interface HomePageCollectionViewCell : UICollectionViewCell
/**
 *  cell背景图片
 */
@property (nonatomic, strong) UIImageView *themeImage;
/**
 *  歌曲名字
 */
@property (nonatomic, strong) UILabel *title;
/**
 *  播放次数耳机图片
 */
@property (nonatomic, strong) UIImageView *playCountsImage;
/**
 *  播放次数
 */
@property (nonatomic, strong) UILabel *playCounts;
@property (nonatomic, strong) UIView *maskView;
@property (nonatomic, strong) UIView *bgView;
/**
 *  当前cell数据模型
 */
@property (nonatomic, strong) HomePageUserMess *dataModel;
/**
 *  歌词接口
 */
@property (nonatomic, copy) NSString *lyricUrl;

/**
 *  当前cell所在单元格
 */
@property (nonatomic, assign) NSIndexPath *indexPath;

/**
 *  播放次数蒙版视图
 */
@property (nonatomic, strong) UIView *playCountMask;
/**
 *  播放次数背景视图
 */
@property (nonatomic, strong) UIView *playCountView;

/**
 *  用户信息数据模型
 */
@property (nonatomic, strong) UserModel *userModel;
/**
 *  用户头像
 */
@property (nonatomic, copy)   NSString *userHeadImgUrl;

@property (nonatomic, strong) UIView *bgMaskView;

@property (nonatomic, strong) UILabel *userName;

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UIImageView *userNameMaskView;

// 更多按钮
@property (nonatomic, strong) UIImageView *moreImage;
@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, assign) BOOL isMyPersonCenter;

@property (nonatomic, copy) MoreActionBlock moreActionBlock;

@end
