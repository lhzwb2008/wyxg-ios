//
//  HomeSongListViewController.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/26.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "BaseViewController.h"
#import "MJRefresh.h"
#import "XWBaseMethod.h"
#import "KVNProgress.h"
#import "TYCache.h"
#import "SongModel.h"
#import "LatestTableViewCell.h"
#import "PlayUserSongViewController.h"
#import "NSString+Emojize.h"
#import "UserModel.h"
#import "TalentTableViewCell.h"
#import "OtherPersonCenterController.h"
#import "AppDelegate.h"
#import "ActivityModel.h"
#import "ActivityTableViewCell.h"
#import "WebViewController.h"



@interface HomeSongListViewController : BaseViewController<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, assign) NSInteger type;

@property (nonatomic, strong) NSArray *array;

@property (nonatomic, copy) NSString *activityTitle;
@property (nonatomic, copy) NSString *activitiId;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger startIndex;

@property (nonatomic, assign) NSInteger length;

@property (nonatomic, strong) NSArray *urlArray;

@end
