//
//  ActivityDetailViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/1.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ActivityDetailViewController.h"
#import "LatestTableViewCell.h"
#import "MJRefreshNormalHeader.h"
#import "MJRefreshBackNormalFooter.h"
#import "AXGCache.h"
#import "PlayUserSongViewController.h"
#import "NSString+Emojize.h"
#import "SDCycleScrollView.h"
#import "AppDelegate.h"
#import "XieciViewController.h"
#import "XuanQuController.h"
#import "AXGTools.h"

#define DefaultRecommandDataSource @[ \
@"8e3674be804e30c6f1271e64a01edc72_112", \
@"1339b770539cb3df8671871f0d9a201d_1", \
@"49c05e81e6d9b0b1793517ab010c7c68_1", \
@"3e0a7f6d3590cee94e379e2542558c56_2", \
@"494d60b5d9324498ac48e29b25640cf9_1", \
@"0c19683b1ac28b79da104052f47e5018_1", \
]

static NSString *const identifier = @"identifier";

@interface ActivityDetailViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) SDCycleScrollView *cycleScroll;

@property (nonatomic, strong) UIImageView *addImage;

@property (nonatomic, strong) UIView *recommandView;

@property (nonatomic, strong) UIView *fastView;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, assign) CGAffineTransform transform;

@end

@implementation ActivityDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initNavView];
    
    [self createTableView];
    
    [self.view bringSubviewToFront:self.navView];
    
    if (self.needRefresh) {
        [self refreshTable];
        [self createMaskView];
        [self createBottomButton];
    } else {
        [self getData];
    }

}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
    
    self.navTitle.text = self.activityName;
    
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
    
    [self.tableView registerClass:[LatestTableViewCell class] forCellReuseIdentifier:identifier];
    
}

- (UIView *)getHead {
    CGFloat tmp = 190;
    if (kDevice_Is_iPhone5 || kDevice_Is_iPhone4 || [[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        tmp = screenWidth() / 375 * 190;
    } else {
        tmp = tmp * WIDTH_NIT;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, tmp + 44)];
    
    UIImageView *imageView = nil;
    
    if (imageView == nil) {
        
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, tmp)];
        imageView.image = self.image;
        [view addSubview:imageView];
    }
    
    return view;
}

- (UIView *)getFooter {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44 + 50 * HEIGHT_NIT)];
    
    if (self.needRefresh) {
        view.frame = CGRectMake(0, 0, self.view.width, 44 + 50 * HEIGHT_NIT);
    } else {
        view.frame = CGRectMake(0, 0, self.view.width, 44);
    }
    
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (void)createMaskView {
    self.maskView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.maskView];
    self.maskView.backgroundColor = RGBColor(0, 0, 0, 0.5);
    
    self.recommandView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 50 * HEIGHT_NIT, self.view.width - 0, 150 * HEIGHT_NIT)];
    [self.maskView addSubview:self.recommandView];
    self.recommandView.backgroundColor = HexStringColor(@"#FFDC74");
    
    self.recommandView.layer.cornerRadius = 5;
    self.recommandView.layer.masksToBounds = YES;
    
    UIButton *recommandLabel = [UIButton new];
    recommandLabel.frame = CGRectMake(0, 0, self.recommandView.width, 50 * HEIGHT_NIT);
    [self.recommandView addSubview:recommandLabel];
    [recommandLabel setTitle:@"推  荐" forState:UIControlStateNormal];
    [recommandLabel setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
    recommandLabel.titleLabel.font = JIACU_FONT(18);
    recommandLabel.backgroundColor = HexStringColor(@"#FFDC74");
    recommandLabel.tag = 100;
    [recommandLabel addTarget:self action:@selector(createaButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    recommandLabel.layer.cornerRadius = 5;
//    recommandLabel.layer.masksToBounds = YES;
    
    self.fastView = [[UIView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, self.view.height - 50 * HEIGHT_NIT, self.view.width - 32 * WIDTH_NIT, 50 * HEIGHT_NIT)];
    [self.maskView addSubview:self.fastView];
    
    UIButton *fastLabel = [UIButton new];
    fastLabel.frame = CGRectMake(0, 50 * HEIGHT_NIT, self.recommandView.width, 50 * HEIGHT_NIT);
    [self.recommandView addSubview:fastLabel];
    [fastLabel setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
    [fastLabel setTitle:@"极  速" forState:UIControlStateNormal];
    fastLabel.titleLabel.font = JIACU_FONT(18);
    fastLabel.backgroundColor = HexStringColor(@"#FFDC74");
    fastLabel.tag = 101;
    [fastLabel addTarget:self action:@selector(createaButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    fastLabel.layer.cornerRadius = 5;
//    fastLabel.layer.masksToBounds = YES;
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 50 * HEIGHT_NIT, self.recommandView.width, 1)];
    [self.recommandView addSubview:lineView];
    lineView.backgroundColor = RGBColor(255, 255, 255, 0.95);
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(endAnimation)];
    [self.maskView addGestureRecognizer:tap];
    
    self.maskView.hidden = YES;
    
}

- (void)createBottomButton {
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.height - 50 * HEIGHT_NIT, self.view.width, 50 * HEIGHT_NIT)];
    [self.view addSubview:bottomView];
    bottomView.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.95];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 0.5)];
    [bottomView addSubview:lineView];
    lineView.backgroundColor = HexStringColor(@"#ffffff");
    
    CGFloat width = [AXGTools getTextWidth:@"为TA写歌" font:JIACU_FONT(18)];
    
    self.addImage = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - (width + 15 * WIDTH_NIT + 17 * WIDTH_NIT)) / 2, 0, 17 * WIDTH_NIT, 17 * WIDTH_NIT)];
    self.addImage.center = CGPointMake(self.addImage.centerX, bottomView.height / 2);
    [bottomView addSubview:self.addImage];
    self.addImage.image = [UIImage imageNamed:@"投稿icon"];
    
    self.transform = self.addImage.transform;
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(self.addImage.right + 15 * WIDTH_NIT, 0, 100, bottomView.height)];
    [bottomView addSubview:label];
    label.text = @"为TA写歌";
    label.textColor = HexStringColor(@"#A06262");
    label.font = JIACU_FONT(18);
    
    UIButton *button = [UIButton new];
    button.frame = bottomView.bounds;
    [bottomView addSubview:button];
    button.backgroundColor = [UIColor clearColor];
    [button addTarget:self action:@selector(createSongAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Action

// 开始动画
- (void)startAnimation {
    self.maskView.hidden = NO;
    
    WEAK_SELF;
//    [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        STRONG_SELF;
//        self.fastView.frame = CGRectMake(16 * WIDTH_NIT, self.view.height - 105 * HEIGHT_NIT, self.view.width - 32 * WIDTH_NIT, 50 * HEIGHT_NIT);
//    } completion:^(BOOL finished) {
//        
//    }];
    
//    [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        STRONG_SELF;
//        self.recommandView.frame = CGRectMake(16 * WIDTH_NIT, self.view.height - 160 * HEIGHT_NIT, self.view.width - 32 * WIDTH_NIT, 50 * HEIGHT_NIT);
//    } completion:^(BOOL finished) {
//        
//    }];
    
    [UIView animateWithDuration:0.5 delay:0 usingSpringWithDamping:0.7 initialSpringVelocity:1 options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.recommandView.frame = CGRectMake(0, self.view.height - 150 * HEIGHT_NIT, self.view.width, 150 * HEIGHT_NIT);
    } completion:^(BOOL finished) {
        
    }];
    
//    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
//        self.recommandView.frame = CGRectMake(0, self.view.height - 150 * HEIGHT_NIT, self.view.width - 0, 150 * HEIGHT_NIT);
//    } completion:^(BOOL finished) {
//        
//    }];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        STRONG_SELF;
        self.addImage.transform = CGAffineTransformRotate(self.transform, M_PI + M_PI_4);
        
    } completion:^(BOOL finished) {
        
    }];
}

// 结束动画
- (void)endAnimation {
    
    WEAK_SELF;
    
//    [UIView animateWithDuration:0.8 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        STRONG_SELF;
//        self.recommandView.frame = CGRectMake(16 * WIDTH_NIT, self.view.height - 50 * HEIGHT_NIT, self.view.width - 32 * WIDTH_NIT, 50 * HEIGHT_NIT);
//    } completion:^(BOOL finished) {
//        
//    }];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.recommandView.frame = CGRectMake(0, self.view.height - 50 * HEIGHT_NIT, self.view.width - 0, 50 * HEIGHT_NIT);
    } completion:^(BOOL finished) {
        
    }];
    
//    [UIView animateWithDuration:0.25 delay:0.1 options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        STRONG_SELF;
//        self.fastView.frame = CGRectMake(16 * WIDTH_NIT, self.view.height - 50 * HEIGHT_NIT, self.view.width - 32 * WIDTH_NIT, 50 * HEIGHT_NIT);
//    } completion:^(BOOL finished) {
//        
//    }];
    
    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        STRONG_SELF;
        self.addImage.transform = CGAffineTransformRotate(self.transform, 0);
        
    } completion:^(BOOL finished) {
        self.maskView.hidden = YES;
    }];
    
}

// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 写词按钮方法
- (void)createSongAction:(UIButton *)sender {
    
    if (self.maskView.hidden) {
        [self startAnimation];
    } else {
        [self endAnimation];
    }
    
//    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
//    app.activityId = self.activitiId;
//    
//    XieciViewController *xieciVC = [[XieciViewController alloc] init];
//    [self.navigationController pushViewController:xieciVC animated:YES];
}

// 创作按钮方法
- (void)createaButtonAction:(UIButton *)sender{
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.activityId = self.activitiId;
    
    if (sender.tag == 100) {
        XuanQuController *xuanquVC = [[XuanQuController alloc] init];
        [self.navigationController pushViewController:xuanquVC animated:YES];
    } else {
        app.originSongName = @"";
        XieciViewController *xieciVC = [[XieciViewController alloc] init];
        [self.navigationController pushViewController:xieciVC animated:YES];
    }
    
    [self endAnimation];
    
}

// 获取指定数据
- (void)getData {
    
    [self.dataSource removeAllObjects];
    
    NSArray *array = DefaultRecommandDataSource;
    
    for (NSString *code in array) {
        
        if ([AXGCache objectForKey:MD5Hash([NSString stringWithFormat:GET_SONG_MESS, code])]) {
            NSData *cacheData = [AXGCache objectForKey:MD5Hash([NSString stringWithFormat:GET_SONG_MESS, code])];
            SongModel *model = [[SongModel alloc] initWithData:cacheData error:nil];
            if (model) {
                [self.dataSource addObject:model];
                if (self.dataSource.count >= 6) {
                    [self.tableView reloadData];
                }
            }
            
        } else {
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_SONG_MESS, code] body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                
                WEAK_SELF;
                SongModel *model = [[SongModel alloc] initWithData:resposeObject error:nil];
                if (model) {
                    [self.dataSource addObject:model];
                    if (self.dataSource.count >= 6) {
                       [self.tableView reloadData];
                    }
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
    }
    
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
        
        self.startIndex = 0;
        self.length = 6;

    }
    
    NSString *url = [NSString stringWithFormat:GET_ACTIVITY_SONGS_PAR, self.activitiId, self.startIndex, self.length];
    
    [XWAFNetworkTool getUrl:url body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
        if ([dic1[@"status"] isEqualToNumber:@0]) {
            NSArray *array = dic1[@"items"];
            
            for (NSDictionary *dic in array) {
                SongModel *songModel = [[SongModel alloc] initWithDictionary:dic error:nil];
                
                [self.dataSource addObject:songModel];
            }
        }
        
        [self.tableView.mj_header endRefreshing];
        
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

// 请求最新数据
- (void)getLatestData:(BOOL)isMore {
    
    [self getOtherData:isMore];
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    LatestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 131 * WIDTH_NIT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    LatestTableViewCell *cell = (LatestTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    PlayUserSongViewController *playVC = [[PlayUserSongViewController alloc] init];
    
//    playVC.lyricURL = [NSString stringWithFormat:HOME_LYRIC, cell.model.code];
//    playVC.soundURL = [NSString stringWithFormat:HOME_SOUND, cell.model.code];
//    playVC.soundName = [cell.titleLabel.text emojizedString];
//    playVC.listenCount = [cell.model.play_count integerValue];
//    playVC.user_id = cell.model.user_id;
//    playVC.createTimeStr = cell.model.create_time;
//    playVC.loveCount = cell.model.up_count;
//    playVC.song_id = cell.model.dataId;
//    playVC.needReload = YES;
    playVC.songCode = cell.model.code;
//    playVC.themeImageView.image = cell.themeImage.image;
    
//    [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_PLAYCOUNT, playVC.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
    
    [self.navigationController pushViewController:playVC animated:YES];
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
