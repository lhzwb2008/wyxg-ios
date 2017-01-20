//
//  HomeSongListViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/26.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "HomeSongListViewController.h"
#import "AXGCache.h"
#import "ActivityDetailViewController.h"


static NSString *const identifier = @"identifier";
static NSString *const talentIdentifier = @"talentIdentifier";
static NSString *const activityIdentifier = @"activityIdentifier";


@interface HomeSongListViewController ()

@end

@implementation HomeSongListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.urlArray = @[@"http://form.mikecrm.com/BNapy3", @"http://www.woyaoxiege.com/home/activity/tgActivity", @"http://mp.weixin.qq.com/s?__biz=MzI4MTE1MTE4Mg==&mid=2654459602&idx=1&sn=a48b0cdd11143c4ed20fa7f3586e50c9&scene=1&srcid=0729HdAmw1N8jgBnOXGQiKKr#wechat_redirect"];
    
    [self initNavView];
    
    [self createTableView];
    
    if (self.type == 2) {
        for (SongModel *model in self.array) {
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
    } else if (self.type == 4) {
        for (SongModel *model in self.array) {
            [self.dataSource addObject:model];
        }
        [self.tableView reloadData];
    }
//    else if (self.type == 5) {
//        
////        NSArray *array = @[@"活动3", @"活动2", @"活动1"];
//        for (ActivityModel *model in self.array) {
//            [self.dataSource addObject:model];
//        }
//        [self.tableView reloadData];
//        
//    }
    else if (self.type == 6) {
        [self getActivityData:NO];
//        [self refreshTable];
    }
    
    else {
        [self refreshTable];
    }
    
    [self.view bringSubviewToFront:self.navView];
    
}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
    
    if (self.type == 0) {
        self.navTitle.text = @"经典";
    } else if (self.type == 1) {
        self.navTitle.text = @"热门歌曲";
    } else if (self.type == 2) {
        self.navTitle.text = @"个性推荐";
    } else if (self.type == 3) {
        self.navTitle.text = @"最美人声";
    } else if (self.type == 4) {
        self.navTitle.text = @"优质歌词";
    } else if (self.type == 5) {
        self.navTitle.text = @"活动";
    } else if (self.type == 6) {
        self.navTitle.text = self.activityTitle;
    } else if (self.type == 7) {
        self.navTitle.text = self.activityTitle;
    }
    
//    self.navLeftImage.image = [UIImage imageNamed:@"返回"];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];

}

// 创建tableview
- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height + 44) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HexStringColor(@"#eeeeee");
    self.tableView.tableHeaderView = [self getHead];
    self.tableView.tableFooterView = [self getFooter];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    if (self.type == 4) {
        [self.tableView registerClass:[TalentTableViewCell class] forCellReuseIdentifier:talentIdentifier];
    } else if (self.type == 5) {
        [self.tableView registerClass:[ActivityTableViewCell class] forCellReuseIdentifier:activityIdentifier];
    }else {
        [self.tableView registerClass:[LatestTableViewCell class] forCellReuseIdentifier:identifier];
    }
    
}

- (UIView *)getHead {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)getFooter {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

#pragma mark - Action
// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 加载最新数据
- (void)refreshTable {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataSource removeAllObjects];
        [self getLatestData:NO];
    }];
    self.tableView.mj_header = header;
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getLatestData:YES];
    }];
    self.tableView.mj_footer = footer;
}

- (void)getActivityData:(BOOL)isMore {
    if ([AXGCache objectForKey:MD5Hash([NSString stringWithFormat:GET_ACTIVITY_SONGS, self.activitiId])]) {
        NSData *cacheData = [AXGCache objectForKey:MD5Hash([NSString stringWithFormat:GET_ACTIVITY_SONGS, self.activitiId])];
    
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:cacheData options:0 error:nil];
        if ([dic1[@"status"] isEqualToNumber:@0]) {
            NSArray *array = dic1[@"items"];
            NSMutableArray *mutArray = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary *dic in array) {
                SongModel *songModel = [[SongModel alloc] initWithDictionary:dic error:nil];
                [mutArray addObject:songModel];
            }
            self.array = [mutArray copy];
            
            for (SongModel *model in self.array) {
                [self.dataSource addObject:model];
            }
            [self.tableView reloadData];
            
            //            if (!isMore) {
            //                [self.tableView.mj_header endRefreshing];
            //            } else {
            //                [self.tableView.mj_footer endRefreshing];
            //            }
        } else {
            if (!isMore) {
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }
    } else {
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_ACTIVITY_SONGS, self.activitiId] body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
            if ([dic1[@"status"] isEqualToNumber:@0]) {
                NSArray *array = dic1[@"items"];
                NSMutableArray *mutArray = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dic in array) {
                    SongModel *songModel = [[SongModel alloc] initWithDictionary:dic error:nil];
                    [mutArray addObject:songModel];
                }
                self.array = [mutArray copy];
                
                for (SongModel *model in self.array) {
                    [self.dataSource addObject:model];
                }
                [self.tableView reloadData];
                
    //            if (!isMore) {
    //                [self.tableView.mj_header endRefreshing];
    //            } else {
    //                [self.tableView.mj_footer endRefreshing];
    //            }
            } else {
                if (!isMore) {
                    [self.tableView.mj_header endRefreshing];
                } else {
                    [self.tableView.mj_footer endRefreshing];
                }
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            if (!isMore) {
                [self.tableView.mj_header endRefreshing];
            } else {
                [self.tableView.mj_footer endRefreshing];
            }
        }];
    }
}

- (void)getOtherData:(BOOL)isMore {
    if (isMore) {
        [self.tableView.mj_header endRefreshing];
        
        if (self.dataSource.count % 6 == 0) {
            self.startIndex = 6 * (self.dataSource.count / 6);
            //                self.endIndex = self.endIndex + 6;
        } else {
            [self.tableView.mj_footer endRefreshing];
            
            [MBProgressHUD showError:DATA_DONE];
            return;
        }
        
    } else {
        [self.tableView.mj_footer endRefreshing];
        
        if (self.type == 0) {
            self.startIndex = 36;
            self.length = 6;
        } else if (self.type == 1 || self.type == 3 || self.type == 7) {
            self.startIndex = 0;
            self.length = 6;
        }
        
    }
    NSString *url = @"";
    
    if (self.type == 0) {
        url = [NSString stringWithFormat:GET_RECOMMAND, self.startIndex, self.length];
    } else if (self.type == 1) {
        url = [NSString stringWithFormat:GET_RECOMMAND, self.startIndex, self.length];
    } else if (self.type == 3) {
        url = [NSString stringWithFormat:GET_SING_SONG, self.startIndex, self.length];
    } else if (self.type == 7) {
        url = [NSString stringWithFormat:GET_GEDAN_SONGS, self.activitiId, self.startIndex, self.length];
    }
    
    BOOL isConnect = [XWBaseMethod connectionInternet];
    
    WEAK_SELF;
    [XWAFNetworkTool getUrl:url body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
        if ([dic1[@"status"] isEqualToNumber:@0]) {
            
            NSArray *array = nil;
            if (self.type == 7) {
                array = dic1[@"items"];
            } else {
                array = dic1[@"songs"];
            }
            
            for (NSDictionary *dic in array) {
                SongModel *songModel = [[SongModel alloc] initWithDictionary:dic error:nil];
                
                [self.dataSource addObject:songModel];
            }
        }
        
        [self.tableView.mj_header endRefreshing];
        
        [TYCache setObject:resposeObject forKey:MD5Hash(url)];
        
        [self.tableView reloadData];
        
        if (!isMore) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"首页请求错误%@", error.description);
        
        if (!isMore) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
    }];

}

- (void)getActivityThemeData:(BOOL)isMore {
    
    if (isMore) {
        [self.tableView.mj_footer endRefreshing];
        return;
    } else {
        WEAK_SELF;
        
        if ([AXGCache objectForKey:MD5Hash(GET_ACTIVITY)]) {
            NSData *cacheData = [AXGCache objectForKey:MD5Hash(GET_ACTIVITY)];
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:cacheData options:0 error:nil];
            
            if ([dic1[@"status"] isEqualToNumber:@0]) {
                
                NSArray *item = dic1[@"items"];
                for (NSDictionary *dic in item) {
                    ActivityModel *model = [[ActivityModel alloc] initWithDictionary:dic error:nil];
                    
                    if ([model.status isEqualToString:@"1"]) {
                        [self.dataSource addObject:model];
                    }
                    
                }
                
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
                
            }
            
        } else {
            // 获取所有活动
            [XWAFNetworkTool getUrl:GET_ACTIVITY body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                STRONG_SELF;
                NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
                
                if ([dic1[@"status"] isEqualToNumber:@0]) {
                    
                    NSArray *item = dic1[@"items"];
                    for (NSDictionary *dic in item) {
                        ActivityModel *model = [[ActivityModel alloc] initWithDictionary:dic error:nil];
                        
                        if ([model.status isEqualToString:@"1"]) {
                            [self.dataSource addObject:model];
                        }
                        
                    }
                    
                    [self.tableView reloadData];
                    [self.tableView.mj_header endRefreshing];
                    
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self.tableView reloadData];
                [self.tableView.mj_header endRefreshing];
            }];
        }
    }
}

// 请求最新数据
- (void)getLatestData:(BOOL)isMore {

    if (self.type == 6) {
        [self getActivityData:isMore];
    } else if (self.type == 5) {
        [self getActivityThemeData:isMore];
    } else {
        [self getOtherData:isMore];
    }
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == 4) {
        
        TalentTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:talentIdentifier];
        if (self.dataSource.count > indexPath.row) {
            cell.model = self.dataSource[indexPath.row];
        }
        return cell;
        
    } else if (self.type == 5) {
        
        ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:activityIdentifier];
//        if (indexPath.row == 2) {
//            cell.overImage.hidden = NO;
//        } else {
//            cell.overImage.hidden = YES;
//        }
        cell.overImage.hidden = YES;
        
        if (self.dataSource.count > indexPath.row) {
//            cell.activityImage.image = [UIImage imageNamed:self.dataSource[indexPath.row]];
            cell.model = self.dataSource[indexPath.row];
        }
        return cell;
        
    }else {
        LatestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
        
        if (self.dataSource.count > indexPath.row) {
            cell.model = self.dataSource[indexPath.row];
        }
        
        return cell;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.type == 4) {
        return 127.5 * WIDTH_NIT;
    } else if (self.type == 5) {
        return 195 * WIDTH_NIT;
    }else {
        return 131 * WIDTH_NIT;
    }
}

//- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 1 * WIDTH_NIT)];
//    view.backgroundColor = [UIColor clearColor];
//    return view;
//}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (self.type == 5) {
//        return 1 * WIDTH_NIT;
//    } else {
//        return CGFLOAT_MIN;
//    }
//}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    if (self.type == 4) {
        
        TalentTableViewCell *cell = (TalentTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
 
        PlayUserSongViewController *playVC = [[PlayUserSongViewController alloc] init];
        
//        playVC.lyricURL = [NSString stringWithFormat:HOME_LYRIC, cell.model.code];
//        playVC.soundURL = [NSString stringWithFormat:HOME_SOUND, cell.model.code];
//        playVC.soundName = [cell.nameLabel.text emojizedString];
//        playVC.listenCount = [cell.model.play_count integerValue];
//        playVC.user_id = cell.model.user_id;
//        playVC.createTimeStr = cell.model.create_time;
//        playVC.loveCount = cell.model.up_count;
//        playVC.song_id = cell.model.dataId;
//        playVC.needReload = YES;
        playVC.songCode = cell.model.code;
//        playVC.themeImageView.image = cell.headImage.image;
       
//        [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_PLAYCOUNT, playVC.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//            
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            
//        }];
       
        [self.navigationController pushViewController:playVC animated:YES];
        
        
        
    } else if (self.type == 5) {
        
        ActivityTableViewCell *cell = (ActivityTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        ActivityDetailViewController *acVC = [[ActivityDetailViewController alloc] init];
        acVC.activitiId = cell.model.dataId;
        acVC.activityName = cell.model.name;
        acVC.needRefresh = YES;
        acVC.image = cell.activityImage.image;

        [self.navigationController pushViewController:acVC animated:YES];
        
    } else {
        
        LatestTableViewCell *cell = (LatestTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        PlayUserSongViewController *playVC = [[PlayUserSongViewController alloc] init];
        
//        playVC.lyricURL = [NSString stringWithFormat:HOME_LYRIC, cell.model.code];
//        playVC.soundURL = [NSString stringWithFormat:HOME_SOUND, cell.model.code];
//        playVC.soundName = [cell.titleLabel.text emojizedString];
//        playVC.listenCount = [cell.model.play_count integerValue];
//        playVC.user_id = cell.model.user_id;
//        playVC.createTimeStr = cell.model.create_time;
//        playVC.loveCount = cell.model.up_count;
//        playVC.song_id = cell.model.dataId;
//        playVC.needReload = YES;
        playVC.songCode = cell.model.code;
//        playVC.themeImageView.image = cell.themeImage.image;
       
//        [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_PLAYCOUNT, playVC.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//            
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            
//        }];
       
        [self.navigationController pushViewController:playVC animated:YES];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
