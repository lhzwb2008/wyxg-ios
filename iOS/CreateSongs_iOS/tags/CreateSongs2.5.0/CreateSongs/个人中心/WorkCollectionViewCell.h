//
//  WorkCollectionViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/6/30.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomePageModel.h"
@class UserModel;

typedef void(^MoreActionBlock)(NSString *code, NSString *title);

@interface WorkCollectionViewCell : UICollectionViewCell
/**
 *  cell背景图片
 */
@property (nonatomic, strong) UIImageView *themeImage;

/**
 *  高亮背景色
 */
@property (nonatomic, strong) UIView *maskView;

/**
 *  歌曲名字
 */
@property (nonatomic, strong) UILabel *title;

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


// 更多按钮
@property (nonatomic, strong) UIImageView *moreImage;
@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, assign) BOOL isMyPersonCenter;

@property (nonatomic, strong) UIImageView *lineImage;
@property (nonatomic, strong) UILabel *timeLineLabel1;
@property (nonatomic, strong) UILabel *timeLineLabel2;
@property (nonatomic, strong) UILabel *createTimeLabel;
@property (nonatomic, strong) UILabel *createSecondLabel;

@property (nonatomic, strong) UILabel *lyricLable;

@property (nonatomic, strong) UILabel *seperateLabel;

@property (nonatomic, strong) UILabel *upCountLabel;
@property (nonatomic, strong) UIImageView *upImageView;
/**
 *  播放次数耳机图片
 */
@property (nonatomic, strong) UIImageView *playCountsImage;
/**
 *  播放次数
 */
@property (nonatomic, strong) UILabel *playCounts;

@property (nonatomic, strong) UIImageView *maskImageView;

@property (nonatomic, copy) MoreActionBlock moreActionBlock;

@end
