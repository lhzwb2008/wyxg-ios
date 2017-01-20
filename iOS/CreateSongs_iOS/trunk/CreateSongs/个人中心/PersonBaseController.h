//
//  PersonBaseController.h
//  CreateSongs
//
//  Created by axg on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AXGHeader.h"
#import "PersonCollectionDelegate.h"
//#import "PlayUserSongViewController.h"
#import "HomePageCollectionViewCell.h"
#import "HomePageModel.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "YTKKeyValueStore.h"
#import "PersonTableDelegate.h"
//#import "PersonCenterViewController.h"
//#import "MessageIdentifyViewController.h"
//#import "RegisterViewController.h"
#import "HomeViewController.h"
#import "UIImageView+WebCache.h"
#import "NSString+Emojize.h"
//#import "UIViewController+MMDrawerController.h"
#import "WorkCollectionViewCell.h"
#import "UIColor+expanded.h"

#define HEAD_HEIGHT (200 * HEIGHT_NIT)

static NSString *const collectionIdentifier1 = @"HomePageCollectionViewCellIndentifier1";
static NSString *const collectionIdentifier2 = @"HomePageCollectionViewCellIndentifier2";
static NSString *const collectionHeadIdentifier1 = @"collectionHeadIdentifier1";
static NSString *const collectionHeadIdentifier2 = @"collectionHeadIdentifier2";
static NSString *const collectionFootIdentifier1 = @"collectionFootIdentifier1";
static NSString *const collectionFootIdentifier2 = @"collectionFootIdentifier2";
static NSString *const tableViewIdentifier1 = @"tableViewIdentifier1";
static NSString *const tableViewIdentifier2 = @"tableViewIdentifier2";


@interface PersonBaseController : UIViewController<UIScrollViewDelegate>
/**
 *  头视图
 */
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) UIImageView *wallView;
@property (nonatomic, strong) UIImageView *treeView;
@property (nonatomic, strong) UIImageView *lightView;
@property (nonatomic, strong) UIImageView *maoqiuView;
@property (nonatomic, assign) CGPoint treePoint;
@property (nonatomic, assign) CGPoint lightPoint;
@property (nonatomic, assign) CGPoint maoqiuPoint;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *titleLabel2;
/**
 *  作品collection
 */
@property (nonatomic, strong) UICollectionView *worksCollectionView;
/**
 *  喜欢collection
 */
@property (nonatomic, strong) UICollectionView *likeCollectionView;
/**
 *  关注table
 */
@property (nonatomic, strong) UITableView *focusTableView;
/**
 *  粉丝table
 */
@property (nonatomic, strong) UITableView *followTableView;

// 头像
@property (nonatomic, strong) UIImageView *headImage;
// 昵称
@property (nonatomic, strong) UILabel *nickName;

@property (nonatomic, strong) UILabel *signature;

@property (nonatomic, strong) UIButton *focusBtn;

@property (nonatomic, strong) UIButton *sixinButton;

@property (nonatomic, strong) PersonCollectionDelegate *collectionDelegate1;

@property (nonatomic, strong) PersonCollectionDelegate *collectionDelegate2;

@property (nonatomic, strong) PersonTableDelegate *tableDelegate1;

@property (nonatomic, strong) PersonTableDelegate *tableDelegate2;

@property (nonatomic, strong) NSMutableArray *dataSourceWorks;

@property (nonatomic, strong) NSMutableArray *dataSourceLike;

@property (nonatomic, strong) NSMutableArray *dataSourceFocus;

@property (nonatomic, strong) NSMutableArray *dataSourceFollow;

@property (nonatomic, strong) UILabel *worksLabel;
@property (nonatomic, strong) UILabel *worksCount;

@property (nonatomic, strong) UILabel *likeLabel;
@property (nonatomic, strong) UILabel *likeCount;

@property (nonatomic, strong) UILabel *focusLabel;
@property (nonatomic, strong) UILabel *focusCount;

@property (nonatomic, strong) UILabel *followLabel;
@property (nonatomic, strong) UILabel *followCount;

@property (nonatomic, strong) UIView *infoHeadView;

@property (nonatomic, strong) UIImageView *genderImage;

@property (nonatomic, assign) CGPoint infoHeadViewPoint;

@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UIImageView *xieciImage;
@property (nonatomic, strong) UILabel *xieciLabel;
@property (nonatomic, strong) UIButton *xieciButton;

@property (nonatomic, strong) UIImageView *favorImage;
@property (nonatomic, strong) UILabel *favorLabel;
@property (nonatomic, strong) UIButton *favorButton;

@property (nonatomic, strong) UIImageView *focusNoImage;
@property (nonatomic, strong) UILabel *focusNoLabel;

@property (nonatomic, strong) UIImageView *followNoImage;
@property (nonatomic, strong) UILabel *followNoLabel;

@property (nonatomic, assign) BOOL enterRefresh;

@property (nonatomic, assign) CGFloat height;

@property (nonatomic, strong) UILabel *moveLabel;

@property (nonatomic, strong) UIView *navView;

@property (nonatomic, strong) UIView *navView2;

@property (nonatomic, assign) CGFloat head_Height;
/**
 [self createHeadView];
 [self createWorkCollection];
 [self createLikeCollection];
 [self createFocusTable];
 [self createFollowTable];
 [self createNavView];

 */
@property (nonatomic, copy) NSString *userId;

- (void)headTgr:(UITapGestureRecognizer *)tgr;

- (void)createHeadView;
- (void)createWorkCollection;
- (void)createLikeCollection;
- (void)createFocusTable;
- (void)createFollowTable;
- (void)createNavView;

- (void)isFocus:(BOOL)isFocus;

- (instancetype)initWIthUserId:(NSString *)userId;

@end
