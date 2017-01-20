//
//  HomeViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/13.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "HomeViewController.h"
#import "SDCycleScrollView.h"
#import "AXGTools.h"
#import "HomeRecommandDelegate.h"
#import "HotTableViewCell.h"
#import "MJRefreshNormalHeader.h"
#import "KVNProgress.h"
#import "XWBaseMethod.h"
#import "TYCache.h"
#import "RecommandTableViewCell.h"
#import "ActivityTableViewCell.h"
#import "UserModel.h"
#import "TalentTableViewCell.h"
#import "HomeLatestDelegate.h"
#import "LatestTableViewCell.h"
#import "MJRefreshBackNormalFooter.h"
#import "DrawerView.h"
//#import "UIViewController+MMDrawerController.h"
#import "BannerModel.h"
#import "WebViewController.h"
#import "XieciViewController.h"
#import "PersonSoundTableViewCell.h"
#import "MsgViewController.h"
#import "UIImage+Extensiton.h"
#import "AXGMessage.h"
#import "LoginViewController.h"
#import "HomeRankController.h"
#import "ModifyViewController.h"
#import "ActivityModel.h"
#import "PlayUserSongViewController.h"
#import "NSString+Emojize.h"
#import "PersonSoundCollectionViewCell.h"
#import "HomeSongListViewController.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "OtherPersonCenterController.h"
#import "AppDelegate.h"
#import "MobClick.h"
#import "AXGCache.h"
#import "TianciViewController.h"
#import "XuanQuController.h"
#import "BottomScaleBtn.h"
#import "DrawerViewController.h"
//#import "KYDrawerController.h"
#import "CreateSongs-Swift.h"
#import "ActivityDetailViewController.h"
#import "SongListTableViewCell.h"
#import "HomeActivityDelegate.h"
#import "SearchViewController.h"
#import "MBProgressHUD.h"
#import "EMSDK.h"
#import "ForumViewController.h"
#import "AXGMediator+MediatorModuleAActions.h"
#import "NSString+Common.h"

#define DefaultRecommandDataSource @[ \
@"e50f79bdc16fce3f4e8d6dd4954bbf6b_1", \
@"8b086cd5f90e4c5131528006bd789928_2", \
@"155622e4ef73e67c199cebc667572d4f_1", \
@"02173e66251917ed8c83f539cc887e8c_1", \
@"9687edd840e62351ef0710765d001dde_1", \
@"9688e946a5011bc83b26f58c67a07187_2", \
@"15648199f06a0fd5642a8caa576aecc2_6"  \
]
#define TIMEOFFSET 0.1f
#define BTN_ANI_TIME    0.5f

static NSString *const hotIdentifier = @"hotIdentifier";
static NSString *const recommandIdentifier = @"recommandIdentifier";
static NSString *const talentIdentifier = @"talentIdentifier";
static NSString *const activityIdentifier = @"activityIdentifier";
static NSString *const latestIdentifier = @"latestIdentifier";
static NSString *const changIdentifier = @"changIdentifier";
static NSString *const gaiIdentifier = @"gaiIdentifier";
static NSString *const personSoundIdentifier = @"personSoundIdentifier";
static NSString *const homeActivtyIdentifier = @"homeActivtyIdentifier";

@interface HomeViewController ()<UIScrollViewDelegate, SDCycleScrollViewDelegate, BottomScaleDelegate>

@property (nonatomic, strong) UILabel *recommandLabel;

@property (nonatomic, strong) UIButton *recommandButton;

@property (nonatomic, strong) UILabel *latestLabel;

@property (nonatomic, strong) UIButton *latestButton;

@property (nonatomic, assign) NSInteger beginIndex;

@property (nonatomic, assign) NSInteger songLength;

@property (nonatomic, strong) NSMutableArray *bannerDataSource;

@property (nonatomic, strong) NSMutableArray *hotDataSource;

@property (nonatomic, strong) NSMutableArray *recommandDataSource;

@property (nonatomic, strong) NSMutableArray *talentDataSource;

@property (nonatomic, strong) NSMutableArray *activityDataSource;

@property (nonatomic, strong) NSMutableArray *personSoundDataSource;

@property (nonatomic, strong) NSMutableArray *goodLyricDataSource;

@property (nonatomic, strong) NSMutableArray *latestDataSource;

@property (nonatomic, strong) UIScrollView *scroll;

@property (nonatomic, strong) UITableView *tableViewRecommand;

@property (nonatomic, strong) UITableView *tableViewLatest;

@property (nonatomic, strong) UITableView *activityTable;

@property (nonatomic, strong) HomeActivityDelegate *activityDelegate;

@property (nonatomic, strong) SDCycleScrollView *cycleScroll;

@property (nonatomic, strong) HomeRecommandDelegate *recommandDelegate;

@property (nonatomic, strong) HomeLatestDelegate *latestDelegate;

@property (nonatomic, assign) BOOL suggestIsRefreshed;

@property (nonatomic, assign) BOOL latestIsRefreshed;

@property (nonatomic, assign) BOOL activityIsRefreshed;

@property (nonatomic, strong) UILabel *activityLabel;

@property (nonatomic, strong) UIButton *activityButton;

@property (nonatomic, strong) NSMutableArray *navActivityDataSource;

@property (nonatomic, strong) BottomScaleBtn *bottomButton;

@property (nonatomic, strong) NSMutableArray *msgReadArray;

@property (nonatomic, strong) NSMutableArray *msgNotReadArray;

@property (nonatomic, strong) UILabel *msgCountLabel;

@property (nonatomic, strong) UIView *titleSlider;

@property (nonatomic, assign) CGFloat centerX1;

@property (nonatomic, assign) CGFloat centerX2;

@property (nonatomic, strong) UITableView *tableViewLatestChang;

@property (nonatomic, strong) UITableView *tableViewLatestGai;

@property (nonatomic, strong) HomeLatestDelegate *changDelegate;

@property (nonatomic, strong) HomeLatestDelegate *gaiDelegate;

@property (nonatomic, strong) NSMutableArray *changDataSource;

@property (nonatomic, strong) NSMutableArray *gaiDataSource;

@property (nonatomic, assign) BOOL changIsRefreshed;

@property (nonatomic, assign) BOOL gaiIsRefreshed;

@property (nonatomic, strong) UIButton *allButton;

@property (nonatomic, strong) UIButton *changButton;

@property (nonatomic, strong) UIButton *gaiButton;

@property (nonatomic, strong) UIScrollView *latestScroll;

@property (nonatomic, assign) NSInteger songlistNum;

@property (nonatomic, strong) UIView *tagView;

@property (nonatomic, assign) CGFloat allX;

@property (nonatomic, assign) CGFloat singX;

@property (nonatomic, assign) CGFloat gaiX;


@end

@implementation HomeViewController

//- (void)dealloc {
//    [[NSNotificationCenter defaultCenter] removeObserver:self];
//}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.suggestIsRefreshed = NO;
    self.latestIsRefreshed = NO;
    self.changIsRefreshed = NO;
    self.gaiIsRefreshed = NO;
    self.activityIsRefreshed = NO;
    
    self.songlistNum = 0;
    
    self.bannerDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.hotDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.recommandDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.talentDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.activityDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.latestDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.personSoundDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.changDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.gaiDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.goodLyricDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.navActivityDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initDelegate];
    [self createTableRecommand];
    [self createLatestTable];
    [self createActivityTable];
    [self initGetData];
    [self refreshRecommand];
    [self refreshLatest];
    [self refreshLatestChang];
    [self refreshLatestGai];
    [self refreshActivity];
    
//    [self gettouxiang];
    
    [self.view bringSubviewToFront:self.navView];
    
    [self createBottomButton];
    [self createEdgePanView];
    
    // 处理推送信息
    [self pushInfo];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(pushNotificationAction:) name:@"enterAppFromPushNotification" object:nil];
    
    // 处理浏览器过来的URL
    [self safriUrl];
    
//    NSString *str = URLEncodedString(@"wyxg://www.woyaoxiege.com?action=share&img=http://www.woyaoxiege.com/Public/images/spq/logo.png&title=TA和杨幂不得不说的故事&description=KILL,MARRY,F*CK 国外最火爆有毒的游戏！&url=http://www.woyaoxiege.com/home/index/spqResult.html?pa=宋慧乔&sha=刘诗诗&qu=关晓彤&fenxiang=杨幂");
//    NSLog(@"%@", str);
}

//// 获取指定头像
//- (void)gettouxiang {
//    NSString *userHead = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:@"robot41"]];
//    NSLog(@"%@", userHead);
//    
//}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    KYDrawerController *drawerVC = (KYDrawerController *)self.navigationController.parentViewController;
    DrawerViewController *drawer = (DrawerViewController *)drawerVC.drawerViewController;
    [drawer changeDrawerState:0];
    [self reloadMsg];
    
//    self.navLeftButton.growingAttributesUniqueTag = @"home_leftButton";
    
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
 
}

#pragma mark - 初始化界面
- (void)initNavView {
    
    [super initNavView];
    
    self.latestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, 44 * WIDTH_NIT, 44)];
    [self.navView addSubview:self.latestLabel];
    self.latestLabel.center = CGPointMake(self.view.width / 2, self.latestLabel.centerY);
    self.latestLabel.text = @"最新";
    self.latestLabel.textColor = [UIColor whiteColor];
    [self.latestLabel setFont:TECU_FONT(18)];
    self.latestLabel.textAlignment = NSTextAlignmentCenter;
    
    CGFloat textWidth = [AXGTools getTextWidth:@"最新" font:self.latestLabel.font];
    
    self.latestButton = [UIButton new];
    self.latestButton.frame = self.latestLabel.frame;
    [self.navView addSubview:self.latestButton];
    self.latestButton.backgroundColor = [UIColor clearColor];
    [self.latestButton addTarget:self action:@selector(newClick:) forControlEvents:UIControlEventTouchUpInside];
    
    self.recommandLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.latestLabel.width, self.latestLabel.height)];
    [self.navView addSubview:self.recommandLabel];
    self.recommandLabel.center = CGPointMake(self.latestLabel.centerX - 45 * WIDTH_NIT - textWidth, self.latestLabel.centerY);
    self.recommandLabel.textAlignment = NSTextAlignmentCenter;
    self.recommandLabel.text = @"推荐";
    self.recommandLabel.textColor = HexStringColor(@"#441D11");
    [self.recommandLabel setFont:TECU_FONT(18)];
    
    self.recommandButton = [UIButton new];
    [self.navView addSubview:self.recommandButton];
    self.recommandButton.backgroundColor = [UIColor clearColor];
    [self.recommandButton addTarget:self action:@selector(suggestClick:) forControlEvents:UIControlEventTouchUpInside];
    self.recommandButton.frame = self.recommandLabel.frame;
    
    self.activityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.latestLabel.width, self.latestLabel.height)];
    [self.navView addSubview:self.activityLabel];
    self.activityLabel.center = CGPointMake(self.latestLabel.centerX + 45 * WIDTH_NIT + textWidth, self.latestLabel.centerY);
    self.activityLabel.textAlignment = NSTextAlignmentCenter;
    self.activityLabel.text = @"活动";
    self.activityLabel.textColor = HexStringColor(@"#441D11");
    self.activityLabel.font = TECU_FONT(18);
    
    self.activityButton = [UIButton new];
    [self.navView addSubview:self.activityButton];
    self.activityButton.backgroundColor = [UIColor clearColor];
    [self.activityButton addTarget:self action:@selector(activityButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    self.activityButton.frame = self.activityLabel.frame;
    
    CGFloat width = [AXGTools getTextWidth:self.recommandLabel.text font:self.recommandLabel.font];
    
    self.centerX1 = self.recommandLabel.centerX;
    self.centerX2 = self.latestLabel.centerX;
    
    self.titleSlider = [[UIView alloc] initWithFrame:CGRectMake(0, 64 - 2, width, 2)];
    [self.navView addSubview:self.titleSlider];
    self.titleSlider.center = CGPointMake(self.recommandLabel.centerX, self.titleSlider.centerY);
    self.titleSlider.backgroundColor = HexStringColor(@"#441D11");
    
    [self.navLeftButton setImage:[UIImage imageNamed:@"菜单icon"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"菜单_高亮"] forState:UIControlStateHighlighted];
//    [self.navLeftButton setImage:[UIImage imageNamed:@"菜单_消息"] forState:UIControlStateSelected];
//    self.navLeftButton.selected = NO;
    
    [self.navRightButton setImage:[UIImage imageNamed:@"搜索"] forState:UIControlStateNormal];
    [self.navRightButton setImage:[UIImage imageNamed:@"搜索_高亮"] forState:UIControlStateHighlighted];
    
    [self.navLeftButton addTarget:self action:@selector(drawerButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.msgReadArray = [[NSMutableArray alloc] initWithCapacity:0];
    self.msgNotReadArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.msgCountLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 13, 13)];
    self.msgCountLabel.font = [UIFont systemFontOfSize:10];
    [self.navRightImage addSubview:self.msgCountLabel];
    self.msgCountLabel.layer.cornerRadius = self.msgCountLabel.width / 2;
    self.msgCountLabel.layer.masksToBounds = YES;
    self.msgCountLabel.backgroundColor = HexStringColor(@"#cc2424");
    self.msgCountLabel.textColor = [UIColor whiteColor];
    //    self.msgCountLabel.text = @"3";
    self.msgCountLabel.textAlignment = NSTextAlignmentCenter;
    self.msgCountLabel.center = CGPointMake(self.navRightImage.width - 1.5, 4);
    
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:10],};
    CGSize textSize = [self.msgCountLabel.text boundingRectWithSize:CGSizeMake(100, 100) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    CGPoint center = self.msgCountLabel.center;
    self.msgCountLabel.frame = CGRectMake(0, 0, textSize.width, self.msgCountLabel.height);
    self.msgCountLabel.center = center;
    
    [self.navRightButton addTarget:self action:@selector(turnToSearchVC) forControlEvents:UIControlEventTouchUpInside];
    
}

// 初始化代理
- (void)initDelegate {
    self.recommandDelegate = [HomeRecommandDelegate new];
    
    WEAK_SELF;
    self.recommandDelegate.rankBtnBlock = ^{
        STRONG_SELF;
        [self pushToRankController];
    };
    
    self.recommandDelegate.hotSongSelectBlock = ^ (HotTableViewCell *cell) {
        STRONG_SELF;
        [self pushToUserSongVC:cell];
    };
    
    self.recommandDelegate.recommandSelectBlock = ^ (RecommandCollectionViewCell *cell)
    {
        STRONG_SELF;
        [self pushToUserSongVC:cell];
    };
    
    self.recommandDelegate.personSoundBlock = ^ (PersonSoundCollectionViewCell *cell) {
        STRONG_SELF;
        [self pushToTalentVC:cell];
    };
    
    self.recommandDelegate.detailBlock = ^ (NSInteger index) {
        STRONG_SELF;
        
        [self pushToDetailVC:index];
    };
    
//    self.recommandDelegate.activityBlock = ^ (ActivityModel *model) {
//        STRONG_SELF;
//        
//        ActivityDetailViewController *acVC = [[ActivityDetailViewController alloc] init];
//        acVC.needRefresh = NO;
//        acVC.activityName = @"另类吐槽";
//        acVC.image = [UIImage imageNamed:@"另类吐槽"];
//        [self.navigationController pushViewController:acVC animated:YES];
//    };
    
    self.recommandDelegate.songListDelegateBlock = ^ (NSInteger index) {
        STRONG_SELF;
        switch (index) {
            case 0: {
                [MobClick event:@"home_list1"];
            }
                break;
            case 1: {
                [MobClick event:@"home_list2"];
            }
                break;
            case 2: {
                [MobClick event:@"home_list3"];
            }
                break;
            default:
                break;
        }
        self.songlistNum = index;
        [self pushToDetailVC:7];
    };
    
    self.recommandDelegate.talentBlock = ^ (TalentTableViewCell *cell) {
        STRONG_SELF;
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
//        
//        [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_PLAYCOUNT, playVC.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//            
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            
//        }];
        
        [self.navigationController pushViewController:playVC animated:YES];
    };
    
    self.latestDelegate = [HomeLatestDelegate new];
    
    self.latestDelegate.latestSelectBlock = ^ (LatestTableViewCell *cell) {
        STRONG_SELF;

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
//        
//        [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_PLAYCOUNT, playVC.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//            
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            
//        }];
        
        [self.navigationController pushViewController:playVC animated:YES];
        
    };
    
    self.changDelegate = [HomeLatestDelegate new];
    
    self.changDelegate.latestSelectBlock = ^ (LatestTableViewCell *cell) {
        STRONG_SELF;
        
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
//        
//        [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_PLAYCOUNT, playVC.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//            
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            
//        }];
        
        [self.navigationController pushViewController:playVC animated:YES];
        
    };
    
    self.gaiDelegate = [HomeLatestDelegate new];
    
    self.gaiDelegate.latestSelectBlock = ^ (LatestTableViewCell *cell) {
        STRONG_SELF;
        
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
//        
//        [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_PLAYCOUNT, playVC.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//            
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            
//        }];
        
        [self.navigationController pushViewController:playVC animated:YES];
        
    };
    
    
    self.activityDelegate = [HomeActivityDelegate new];
    
    self.activityDelegate.activitySelectBlock = ^ (ActivityTableViewCell *cell) {
        STRONG_SELF;
        
        ActivityDetailViewController *acVC = [[ActivityDetailViewController alloc] init];
        acVC.activitiId = cell.model.dataId;
        acVC.activityName = cell.model.name;
        acVC.needRefresh = YES;
        acVC.image = cell.activityImage.image;
        
        [self.navigationController pushViewController:acVC animated:YES];
        
    };
}

// 初始化推荐
- (void)createTableRecommand {
    
    self.scroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:self.scroll];
    self.scroll.contentSize = CGSizeMake(self.view.width * 3, 0);
    self.scroll.pagingEnabled = YES;
    self.scroll.delegate = self;
    self.scroll.showsHorizontalScrollIndicator = NO;
    self.scroll.showsVerticalScrollIndicator = NO;
    
    self.tableViewRecommand = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height + 40 * WIDTH_NIT) style:UITableViewStyleGrouped];
    
    [self.scroll addSubview:self.tableViewRecommand];
    self.tableViewRecommand.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewRecommand.backgroundColor = HexStringColor(@"#eeeeee");
    self.tableViewRecommand.tableHeaderView = [self getTableHeadView];
    self.tableViewRecommand.tableFooterView = [self getTableFooterView];
    
    self.tableViewRecommand.delegate = self.recommandDelegate;
    self.tableViewRecommand.dataSource = self.recommandDelegate;
    
    self.recommandDelegate.hotIdentifier = hotIdentifier;
    self.recommandDelegate.recommandIdentifier = recommandIdentifier;
    self.recommandDelegate.talentIdentifier = talentIdentifier;
    self.recommandDelegate.activityIdentifier = activityIdentifier;
    self.recommandDelegate.personSoundIdentifier = personSoundIdentifier;
    
    [self.tableViewRecommand registerClass:[HotTableViewCell class] forCellReuseIdentifier:hotIdentifier];
    [self.tableViewRecommand registerClass:[RecommandTableViewCell class] forCellReuseIdentifier:recommandIdentifier];
    [self.tableViewRecommand registerClass:[SongListTableViewCell class] forCellReuseIdentifier:activityIdentifier];
    [self.tableViewRecommand registerClass:[TalentTableViewCell class] forCellReuseIdentifier:talentIdentifier];
    [self.tableViewRecommand registerClass:[PersonSoundTableViewCell class] forCellReuseIdentifier:personSoundIdentifier];
    
}

- (void)createLatestTable {
    
    UIView *latestView = [[UIView alloc] initWithFrame:CGRectMake(self.view.width, 0, self.view.width, self.scroll.height)];
    [self.scroll addSubview:latestView];
    latestView.backgroundColor = [UIColor clearColor];
    
    self.latestScroll = [[UIScrollView alloc] initWithFrame:latestView.bounds];
    [latestView addSubview:self.latestScroll];
    self.latestScroll.delegate = self;
    self.latestScroll.scrollEnabled = NO;
    self.latestScroll.pagingEnabled = YES;
    self.latestScroll.showsHorizontalScrollIndicator = NO;
    self.latestScroll.showsVerticalScrollIndicator = NO;
    self.latestScroll.contentSize = CGSizeMake(self.view.width * 3, 0);
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, 50 * WIDTH_NIT)];
    [latestView addSubview:topView];
    topView.backgroundColor = [UIColor clearColor];
    topView.clipsToBounds = YES;
    
    self.tagView = [[UIView alloc] initWithFrame:topView.bounds];
    [topView addSubview:self.tagView];
    
    self.changButton = [UIButton new];
    self.changButton.frame = CGRectMake(0, 0, 100, topView.height);
    self.changButton.center = CGPointMake(topView.width / 2, topView.height / 2);
    [self.changButton setTitle:@"演唱" forState:UIControlStateNormal];
    [self.changButton setTitleColor:HexStringColor(@"#A0A0A0") forState:UIControlStateNormal];
    self.changButton.titleLabel.font = NORML_FONT(15);
    [topView addSubview:self.changButton];
    self.changButton.tag = 101;
    [self.changButton addTarget:self action:@selector(latestChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.singX = self.changButton.centerX;
    
    CGFloat buttonWidth = [AXGTools getTextWidth:@"演唱" font:NORML_FONT(15)];
    
    self.allButton = [UIButton new];
    [topView addSubview:self.allButton];
    self.allButton.frame = CGRectMake(0, 0, self.changButton.width, self.changButton.height);
    self.allButton.center = CGPointMake(self.changButton.centerX - 86.5 * WIDTH_NIT - buttonWidth, self.changButton.centerY);
    [self.allButton setTitleColor:HexStringColor(@"#FFDC74") forState:UIControlStateNormal];
    [self.allButton setTitle:@"全部" forState:UIControlStateNormal];
    self.allButton.titleLabel.font = JIACU_FONT(15);
    self.allButton.tag = 100;
    [self.allButton addTarget:self action:@selector(latestChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.allX = self.allButton.centerX;
    
    self.gaiButton = [UIButton new];
    [topView addSubview:self.gaiButton];
    self.gaiButton.frame = CGRectMake(0, 0, self.changButton.width, self.changButton.height);
    self.gaiButton.center = CGPointMake(self.changButton.centerX + 86.5 * WIDTH_NIT + buttonWidth, self.changButton.centerY);
    [self.gaiButton setTitle:@"改曲" forState:UIControlStateNormal];
    [self.gaiButton setTitleColor:HexStringColor(@"#A0A0A0") forState:UIControlStateNormal];
    self.gaiButton.titleLabel.font = NORML_FONT(15);
    self.gaiButton.tag = 102;
    [self.gaiButton addTarget:self action:@selector(latestChangeAction:) forControlEvents:UIControlEventTouchUpInside];
    self.gaiX = self.gaiButton.centerX;
    
    CGFloat halfWidth = self.view.width - self.allX;
    self.tagView.frame = CGRectMake(0, 0, halfWidth * 2, topView.height);
    self.tagView.center = CGPointMake(self.allX, self.tagView.centerY);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPath];
    [bezierPath moveToPoint:CGPointMake(0, 0)];
    [bezierPath addLineToPoint:CGPointMake(halfWidth * 2, 0)];
    [bezierPath addLineToPoint:CGPointMake(halfWidth * 2, self.tagView.height)];
    [bezierPath addLineToPoint:CGPointMake(halfWidth + 7 * WIDTH_NIT, self.tagView.height)];
    [bezierPath addLineToPoint:CGPointMake(halfWidth, self.tagView.height - 7 * WIDTH_NIT)];
    [bezierPath addLineToPoint:CGPointMake(halfWidth - 7 * WIDTH_NIT, self.tagView.height)];
    [bezierPath addLineToPoint:CGPointMake(0, self.tagView.height)];
    [bezierPath closePath];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [self.tagView.layer addSublayer:shapeLayer];
    shapeLayer.path = bezierPath.CGPath;
    shapeLayer.fillColor = HexStringColor(@"#ffffff").CGColor;
    
    
    self.tableViewLatest = [[UITableView alloc] initWithFrame:CGRectMake(0, 50 * WIDTH_NIT, self.view.width, self.view.height - 50 * WIDTH_NIT + 44) style:UITableViewStyleGrouped];
    [self.latestScroll addSubview:self.tableViewLatest];
    self.tableViewLatest.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewLatest.backgroundColor = HexStringColor(@"#eeeeee");
    self.tableViewLatest.tableHeaderView = [self getLatestHead];
    self.tableViewLatest.tableFooterView = [self getLatestFooter];
    self.tableViewLatest.delegate = self.latestDelegate;
    self.tableViewLatest.dataSource = self.latestDelegate;
    self.latestDelegate.identifier = latestIdentifier;
    self.latestDelegate.latestType = allType;
    [self.tableViewLatest registerClass:[LatestTableViewCell class] forCellReuseIdentifier:latestIdentifier];
    
    
    self.tableViewLatestChang = [[UITableView alloc] initWithFrame:CGRectMake(self.view.width, 50 * WIDTH_NIT, self.view.width, self.view.height - 50 * WIDTH_NIT + 44) style:UITableViewStyleGrouped];
    [self.latestScroll addSubview:self.tableViewLatestChang];
    self.tableViewLatestChang.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewLatestChang.backgroundColor = HexStringColor(@"#eeeeee");
    self.tableViewLatestChang.tableHeaderView = [self getLatestHead];
    self.tableViewLatestChang.tableFooterView = [self getLatestFooter];
    self.tableViewLatestChang.delegate = self.changDelegate;
    self.tableViewLatestChang.dataSource = self.changDelegate;
    self.changDelegate.identifier = changIdentifier;
    self.changDelegate.latestType = changType;
    [self.tableViewLatestChang registerClass:[LatestTableViewCell class] forCellReuseIdentifier:changIdentifier];
    
//    self.tableViewLatestChang.backgroundColor = [UIColor redColor];
    
    
    self.tableViewLatestGai = [[UITableView alloc] initWithFrame:CGRectMake(self.view.width * 2, 50 * WIDTH_NIT, self.view.width, self.view.height - 50 * WIDTH_NIT + 44) style:UITableViewStyleGrouped];
    [self.latestScroll addSubview:self.tableViewLatestGai];
    self.tableViewLatestGai.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableViewLatestGai.backgroundColor = HexStringColor(@"#eeeeee");
    self.tableViewLatestGai.tableHeaderView = [self getLatestHead];
    self.tableViewLatestGai.tableFooterView = [self getLatestFooter];
    self.tableViewLatestGai.delegate = self.gaiDelegate;
    self.tableViewLatestGai.dataSource = self.gaiDelegate;
    self.gaiDelegate.identifier = gaiIdentifier;
    self.gaiDelegate.latestType = gaiType;
    [self.tableViewLatestGai registerClass:[LatestTableViewCell class] forCellReuseIdentifier:gaiIdentifier];
    
//    self.tableViewLatestGai.backgroundColor = [UIColor greenColor];
    
}

// 创建活动
- (void)createActivityTable {
    self.activityTable = [[UITableView alloc] initWithFrame:CGRectMake(self.view.width * 2, 0, self.view.width, self.view.height + 40 * WIDTH_NIT) style:UITableViewStyleGrouped];

    [self.scroll addSubview:self.activityTable];
    self.activityTable.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.activityTable.backgroundColor = HexStringColor(@"#ffffff");
//    self.activityTable.backgroundColor = [UIColor redColor];
    self.activityTable.tableHeaderView = [self getLatestHead];
    self.activityTable.tableFooterView = [self getLatestFooter];
    
    self.activityTable.delegate = self.activityDelegate;
    self.activityTable.dataSource = self.activityDelegate;
    
    self.activityDelegate.identifier = homeActivtyIdentifier;

    [self.activityTable registerClass:[ActivityTableViewCell class] forCellReuseIdentifier:homeActivtyIdentifier];

}

// tableview头视图
- (UIView *)getTableHeadView {
    
    CGFloat tmp = 190;
    if (kDevice_Is_iPhone5 || kDevice_Is_iPhone4 || [[UIDevice currentDevice].model isEqualToString:@"iPad"]) {
        tmp = screenWidth() / 375 * 190;
    } else {
        tmp = tmp * WIDTH_NIT;
    }
    
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, tmp + 44)];
    
    self.cycleScroll = nil;
    
    if (self.cycleScroll == nil) {
        
        self.cycleScroll = [SDCycleScrollView cycleScrollViewWithFrame:CGRectMake(0, 44, self.view.width, tmp) delegate:self placeholderImage:[UIImage imageNamed:@"bannerPlaceholder"]];
        
        CGFloat dotImageW = 5;
//        UIImage *image1 = [AXGTools imageWithImage:[UIImage resizeImage:@"Banner轮播"] scaledToSize:CGSizeMake(dotImageW, dotImageW)];
//        UIImage *image2 = [AXGTools imageWithImage:[UIImage resizeImage:@"Banner轮播2"] scaledToSize:CGSizeMake(dotImageW, dotImageW)];
//        self.cycleScroll.currentPageDotImage = image1;
//        self.cycleScroll.pageDotImage = image2;
        self.cycleScroll.currentPageDotImage = [UIImage imageNamed:@"Banner轮播"];
        self.cycleScroll.pageDotImage = [UIImage imageNamed:@"Banner轮播2"];
        self.cycleScroll.autoScrollTimeInterval = 4;
        //        imageView.delegate = self;
        [view addSubview:self.cycleScroll];
    }
    
    return view;
}

- (UIView *)getTableFooterView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40 * WIDTH_NIT)];
    UIImageView *bottomImage = [[UIImageView alloc] initWithFrame:view.bounds];
    [view addSubview:bottomImage];
    bottomImage.image = [UIImage imageNamed:@"©--我要写歌--2016"];
    return view;
}

- (UIView *)getLatestHead {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)getLatestFooter {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

// 创建打开手势界面
- (void)createEdgePanView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 20, self.view.height - 64)];
    //    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanAction)];
    edgePan.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:edgePan];
}

- (void)quadCurveMenuItemTouchesBegan:(BottomScaleBtn *)item {
//    if (item != self.bottomButton) {
//        return;
//    }
    self.expanding = !self.expanding;
    
    if (item == self.bottomButton) {
        return;
    }
    [self resetItemBtn:item];
}

- (void)quadCurveMenuItemTouchesEnd:(BottomScaleBtn *)item {
    // exclude the "add" button
    if (item == self.bottomButton) {
        return;
    }
    [self resetItemBtn:item];
//    [UIView animateWithDuration:0.3 animations:^{
//        item.alpha = 0.3f;
//        item.transform = CGAffineTransformMakeScale(3f, 1.5f);
//    } completion:^(BOOL finished) {
//        [UIView animateWithDuration:0.3 animations:^{
//            item.transform = CGAffineTransformScale(item.transform, 1.3, 1.3);
//        } completion:^(BOOL finished) {
//            item.transform  = CGAffineTransformIdentity;
//            item.alpha = 1.0f;
//        }];
//        [self resetItemBtn:item];
//    }];
}

- (void)resetItemBtn:(BottomScaleBtn *)item {
    // blowup the selected menu button
    
    self.expanding = NO;
    CAAnimationGroup *blowup = [self _blowupAnimationAtPoint:item.center];
    [item.layer addAnimation:blowup forKey:@"blowup"];
    item.center = item.startPoint;
    
    // shrink other menu buttons
    for (int i = 0; i < [self.menusArray count]; i++) {
        
        BottomScaleBtn *otherItem = [self.menusArray objectAtIndex:i];
        CAAnimationGroup *shrink = [self _shrinkAnimationAtPoint:otherItem.center];
        if (otherItem.tag == item.tag) {
            continue;
        }
        [otherItem.layer addAnimation:shrink forKey:@"shrink"];
        
        otherItem.center = otherItem.startPoint;
    }
    _expanding = NO;
    
    float angle = self.expanding ? -M_PI_4 : 0.0f;
    [UIView animateWithDuration:BTN_ANI_TIME animations:^{
        self.bottomButton.transform = CGAffineTransformMakeRotation(angle);
    }];
    
    [self quadCurvedidSelectIndex:item.tag - 1000];
}

- (void)quadCurvedidSelectIndex:(NSInteger)idx {
    
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    app.activityId = @"0";
    
    [MobClick event:@"home_createSong"];
    switch (idx) {
        case 0: {
            app.originSongName = @"";
            [MobClick event:@"lyric_song"];
        
//            [AXGMediator AXGMeidator_showShareWithUrl:@"wyxg://www.woyaoxiege.com?action=share&title=123&url=123&description=123&img=123" loadResult:^(id view) {
//                
//            } hideAction:^(NSDictionary *info) {
//                
//            }];
            
            [AXGMediator  AXGLoadPageByUrl_Controller:@"wyxg://A?action=webController&controller=XieciViewController"
                                                           loadResult:^(id controller) {
                                                               [self.navigationController pushViewController:controller animated:YES];
                                                           }];
        }
            break;
        case 1: {
            [MobClick event:@"song_lyric"];
            [AXGMediator AXGLoadPageByUrl_Controller:@"wyxg://A?action=webController&controller=XuanQuController"
                                                           loadResult:^(id controller) {
                                                               [self.navigationController pushViewController:controller animated:YES];
                                                           }];
        }
            break;
        default:
            break;
    }
}

- (CAAnimationGroup *)_blowupAnimationAtPoint:(CGPoint)p {
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CGFloat scale = self.bottomButton.width / 75*WIDTH_NIT;
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, scale)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)];
    scaleAnimation.removedOnCompletion = YES;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    opacityAnimation.removedOnCompletion = YES;
    
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = BTN_ANI_TIME;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}
- (CAAnimationGroup *)_shrinkAnimationAtPoint:(CGPoint)p {
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.values = [NSArray arrayWithObjects:[NSValue valueWithCGPoint:p], nil];
    positionAnimation.keyTimes = [NSArray arrayWithObjects: [NSNumber numberWithFloat:.3], nil];
    
    CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform"];
    CGFloat scale = self.bottomButton.width / 75*WIDTH_NIT;
    scaleAnimation.fromValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(1.0, 1.0, 1.0)];
    scaleAnimation.toValue = [NSValue valueWithCATransform3D:CATransform3DMakeScale(scale, scale, scale)];
    scaleAnimation.removedOnCompletion = YES;
    
    CABasicAnimation *opacityAnimation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    opacityAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    opacityAnimation.toValue  = [NSNumber numberWithFloat:0.0f];
    opacityAnimation.removedOnCompletion = YES;
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, scaleAnimation, opacityAnimation, nil];
    animationgroup.duration = BTN_ANI_TIME;
    animationgroup.fillMode = kCAFillModeForwards;
    
    return animationgroup;
}
- (void)setExpanding:(BOOL)expanding {
    _expanding = expanding;
    float angle = self.expanding ? -M_PI_4*3 : 0.0f;
    float alpha = self.expanding ? 1.0f : 0.0f;
    
    if (self.expanding) {
        [UIView animateWithDuration:0.2 animations:^{
            for (BottomScaleBtn *item in self.menusArray) {
                item.alpha = 1;
            }
        }];
        if (self.expanding) {
            self.bottomBtnMaskView.hidden = NO;
        }
        [self.bottomButton setImage:[UIImage imageNamed:@"创作icon2"] forState:UIControlStateNormal];
        [UIView animateWithDuration:BTN_ANI_TIME animations:^{
            self.bottomBtnMaskView.alpha = alpha;
            self.bottomButton.transform = CGAffineTransformMakeRotation(angle);
            self.xianquLabel.alpha = alpha;
            self.xianciLabel.alpha = alpha;
        } completion:^(BOOL finished) {
            self.bottomBtnMaskView.hidden = !self.expanding;
        }];

    } else {
        [UIView animateKeyframesWithDuration:0.15 delay:0.3 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            for (BottomScaleBtn *item in self.menusArray) {
                item.alpha = 0;
            }
        } completion:^(BOOL finished) {
            
        }];
        if (self.expanding) {
            self.bottomBtnMaskView.hidden = NO;
        }
        [UIView animateKeyframesWithDuration:0.3 delay:0.3 options:UIViewKeyframeAnimationOptionLayoutSubviews animations:^{
            self.bottomBtnMaskView.alpha = alpha;
            self.xianquLabel.alpha = alpha;
            self.xianciLabel.alpha = alpha;

//            self.bottomButton.transform = CGAffineTransformMakeRotation(angle);
            
        } completion:^(BOOL finished) {
            
//            self.bottomBtnMaskView.hidden = !self.expanding;
        }];
        [self.bottomButton setImage:[UIImage imageNamed:@"创作icon"] forState:UIControlStateNormal];
        [UIView animateWithDuration:0.2 animations:^{
            self.bottomButton.transform = CGAffineTransformMakeRotation(angle);
            
        } completion:^(BOOL finished) {
            
            self.bottomBtnMaskView.hidden = !self.expanding;
        }];
    }
    
    // expand or close animation
    if (!_timer)
    {
        _flag = self.expanding ? 0 : 1;
        SEL selector = self.expanding ? @selector(_expand) : @selector(_close);
        _timer = [NSTimer scheduledTimerWithTimeInterval:TIMEOFFSET target:self selector:selector userInfo:nil repeats:YES];
    }
}

- (void)_expand {
//    self.bottomBtnMaskView.hidden = NO;
    if (_flag == 2)
    {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    CGFloat time = 0.3f;
    int tag = 1000 + _flag;
    BottomScaleBtn *item = (BottomScaleBtn *)[self.view viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:M_PI/2],[NSNumber numberWithFloat:0.0f], nil];
//    rotateAnimation.duration = 0.5f;
//    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
//                                [NSNumber numberWithFloat:.3],
//                                [NSNumber numberWithFloat:.4], nil];
    
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:-M_PI*2], [NSNumber numberWithFloat:0], nil];
    rotateAnimation.duration = time;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.0],
                                [NSNumber numberWithFloat:time],
                                nil];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = time;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.nearPoint.x, item.nearPoint.y);
    CGPathAddLineToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, nil];
    animationgroup.duration = time;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [item.layer addAnimation:animationgroup forKey:@"Expand"];
    item.center = item.endPoint;
    
    _flag ++;
}

- (void)_close {
    if (_flag == -1)
    {
        [_timer invalidate];
        _timer = nil;
        return;
    }
    CGFloat time = 0.15f;
    int tag = 1000 + _flag;
    BottomScaleBtn *item = (BottomScaleBtn *)[self.view viewWithTag:tag];
    
    CAKeyframeAnimation *rotateAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform.rotation.z"];
//    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:M_PI/2],[NSNumber numberWithFloat:0.0f], nil];
//    rotateAnimation.duration = 0.5f;
//    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
//                                [NSNumber numberWithFloat:.0],
//                                [NSNumber numberWithFloat:.4],
//                                [NSNumber numberWithFloat:.5], nil];
    rotateAnimation.values = [NSArray arrayWithObjects:[NSNumber numberWithFloat:0.0f],[NSNumber numberWithFloat:-M_PI*2], nil];
    rotateAnimation.duration = time;
    rotateAnimation.keyTimes = [NSArray arrayWithObjects:
                                [NSNumber numberWithFloat:.0],
                                [NSNumber numberWithFloat:time],
                                nil];
    
    CAKeyframeAnimation *positionAnimation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    positionAnimation.duration = time;
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, item.endPoint.x, item.endPoint.y);
    CGPathAddLineToPoint(path, NULL, item.farPoint.x, item.farPoint.y);
    CGPathAddLineToPoint(path, NULL, item.startPoint.x, item.startPoint.y);
    positionAnimation.path = path;
    CGPathRelease(path);
    
    CAAnimationGroup *animationgroup = [CAAnimationGroup animation];
    animationgroup.animations = [NSArray arrayWithObjects:positionAnimation, nil];
    animationgroup.duration = time;
    animationgroup.fillMode = kCAFillModeForwards;
    animationgroup.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [item.layer addAnimation:animationgroup forKey:@"Close"];
    item.center = item.startPoint;
    _flag --;
}

- (NSMutableArray *)menusArray {
    if (_menusArray == nil) {
        _menusArray = [NSMutableArray array];
    }
    return _menusArray;
}

- (void)maskViewAction {
    self.expanding = NO;
}

- (void)bottomAction:(BottomScaleBtn *)btn {
    
    [self quadCurveMenuItemTouchesBegan:btn];
}

- (void)createBottomButton {
    
    self.bottomBtnMaskView = [UIButton new];
    [self.bottomBtnMaskView addTarget:self action:@selector(maskViewAction) forControlEvents:UIControlEventTouchUpInside];
    self.bottomBtnMaskView.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.7f];
    self.bottomBtnMaskView.frame = self.view.bounds;
    self.bottomBtnMaskView.userInteractionEnabled = YES;
    self.bottomBtnMaskView.alpha = 0.0f;
    self.bottomBtnMaskView.hidden = YES;
    [self.view addSubview:self.bottomBtnMaskView];
    
    self.bottomButton = [BottomScaleBtn new];
    [self.bottomButton addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.bottomButton setImage:[UIImage imageNamed:@"创作icon"] forState:UIControlStateNormal];
//    self.bottomButton.accessibilityLabel = @"bottomButton";
    self.bottomButton.delegate = self;
   
//    [self.bottomButton setBackgroundImage:[UIImage imageNamed:@"创作icon"] forState:UIControlStateNormal];
    self.bottomButton.frame = CGRectMake(self.view.width - 73 * WIDTH_NIT - 20 * WIDTH_NIT, self.view.height - 73 * WIDTH_NIT - 25 * HEIGHT_NIT, 73 * WIDTH_NIT, 73 * WIDTH_NIT);
//    [self.bottomButton addTarget:self action:@selector(bottomButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    
    CGFloat gap = 65*WIDTH_NIT/2 + 75*WIDTH_NIT/2;
    CGFloat offset = 10;
    BottomScaleBtn *xianciItem = [BottomScaleBtn new];
    xianciItem.frame = CGRectMake(0, 0, 75*WIDTH_NIT, 75*WIDTH_NIT);
    [xianciItem setImage:[UIImage imageNamed:@"先曲"] forState:UIControlStateNormal];
    [xianciItem addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
    xianciItem.tag = 1001;
    xianciItem.startPoint = self.bottomButton.center;
    xianciItem.endPoint = CGPointMake(self.view.centerX-gap, self.view.height - 187*HEIGHT_NIT);
    
    xianciItem.center = xianciItem.startPoint;
    xianciItem.nearPoint = CGPointMake(self.view.centerX - gap - offset, self.view.height -  187*HEIGHT_NIT - offset);
    xianciItem.farPoint = CGPointMake(self.view.centerX - gap + offset, self.view.height -  187*HEIGHT_NIT + offset);
    xianciItem.delegate = self;
    xianciItem.alpha = 0.0f;
    [self.view addSubview:xianciItem];
    
    BottomScaleBtn *xianquItem = [BottomScaleBtn new];
    xianquItem.frame = CGRectMake(0, 0, 75*WIDTH_NIT, 75*WIDTH_NIT);
    [xianquItem setImage:[UIImage imageNamed:@"先词"] forState:UIControlStateNormal];
    [xianquItem addTarget:self action:@selector(bottomAction:) forControlEvents:UIControlEventTouchUpInside];
    xianquItem.tag = 1000;
    xianquItem.startPoint = self.bottomButton.center;
    xianquItem.endPoint = CGPointMake(self.view.centerX+gap, self.view.height -  187*HEIGHT_NIT);
    xianquItem.nearPoint = CGPointMake(self.view.centerX + gap - offset, self.view.height -  187*HEIGHT_NIT - offset);
    xianquItem.farPoint = CGPointMake(self.view.centerX + gap + offset, self.view.height -  187*HEIGHT_NIT + offset);
    xianquItem.center = xianquItem.startPoint;
    xianquItem.delegate = self;
    xianquItem.alpha = 0.0f;
    [self.view addSubview:xianquItem];
    [self.menusArray addObjectsFromArray:@[xianciItem, xianquItem]];
    
    self.xianciLabel = [UILabel new];
    self.xianciLabel.text = @"推荐";
    self.xianciLabel.frame = CGRectMake(0, xianciItem.endPoint.y + 75/2*WIDTH_NIT + 15*HEIGHT_NIT, xianciItem.width, 20);
    self.xianciLabel.centerX = xianciItem.endPoint.x;
    self.xianciLabel.textAlignment = NSTextAlignmentCenter;
    self.xianciLabel.textColor = [UIColor whiteColor];
    self.xianciLabel.font = NORML_FONT(15*WIDTH_NIT);
    self.xianciLabel.alpha = 0.0f;
    [self.view addSubview:self.xianciLabel];

    self.xianquLabel = [UILabel new];
    self.xianquLabel.text = @"极速";
    self.xianquLabel.frame = CGRectMake(0, xianquItem.endPoint.y + 75/2*WIDTH_NIT + 15*HEIGHT_NIT, xianquItem.width, 20);
    self.xianquLabel.centerX = xianquItem.endPoint.x;
    self.xianquLabel.textAlignment = NSTextAlignmentCenter;
    self.xianquLabel.textColor = [UIColor whiteColor];
    self.xianquLabel.font = NORML_FONT(15*WIDTH_NIT);
    self.xianquLabel.alpha = 0.0f;
    [self.view addSubview:self.xianquLabel];
    
    [self.view addSubview:self.bottomButton];
}

#pragma mark - 获取及刷新数据

- (void)initGetData {
    [self.hotDataSource removeAllObjects];
    [self.recommandDataSource removeAllObjects];
    [self.talentDataSource removeAllObjects];
    [self.activityDataSource removeAllObjects];
    [self.bannerDataSource removeAllObjects];
    [self.personSoundDataSource removeAllObjects];
    [self.goodLyricDataSource removeAllObjects];
    
    self.recommandDelegate.hotDataSource = nil;
    self.recommandDelegate.recommandDataSource = nil;
    self.recommandDelegate.talentDataSource = nil;
    self.recommandDelegate.model = nil;
    self.recommandDelegate.personSoundDataSource = nil;
    self.recommandDelegate.songListDataSource = nil;
    
    [self getRecommandData];
}

// 加载推荐数据
- (void)refreshRecommand {
    
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        
        self.suggestIsRefreshed = YES;
        
        [self.hotDataSource removeAllObjects];
        [self.recommandDataSource removeAllObjects];
        [self.talentDataSource removeAllObjects];
        [self.activityDataSource removeAllObjects];
        [self.bannerDataSource removeAllObjects];
        [self.personSoundDataSource removeAllObjects];
        [self.goodLyricDataSource removeAllObjects];
        
        self.recommandDelegate.hotDataSource = nil;
        self.recommandDelegate.recommandDataSource = nil;
        self.recommandDelegate.talentDataSource = nil;
        self.recommandDelegate.model = nil;
        self.recommandDelegate.personSoundDataSource = nil;
        self.recommandDelegate.songListDataSource = nil;
        
        [self getRecommandData];
    }];
    self.tableViewRecommand.mj_header = header;
    
//    [self.tableViewRecommand.mj_header beginRefreshing];
}

- (void)getRecommandData {
    
    self.beginIndex = 0;
    self.songLength = 6;
    
    WEAK_SELF;
    
    NSString *hotUrl = [NSString stringWithFormat:GET_RECOMMAND, self.beginIndex, self.songLength];
    
    if ([AXGCache objectForKey:MD5Hash([NSString stringWithFormat:GET_BANNER])]) {
        NSData *cacheData = [AXGCache objectForKey:MD5Hash([NSString stringWithFormat:GET_BANNER])];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:cacheData options:0 error:nil];
        if ([dic[@"status"] isEqualToNumber:@0]) {
            NSArray *array = dic[@"items"];
            NSMutableArray *mutArr = [[NSMutableArray alloc] initWithCapacity:0];
            for (NSDictionary *dic in array) {
                BannerModel *model = [[BannerModel alloc] initWithDictionary:dic error:nil];
                [self.bannerDataSource addObject:model];
                [mutArr addObject:model.img];
            }
            self.cycleScroll.imageURLStringsGroup = mutArr;
        }
    } else {
        WEAK_SELF;
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_BANNER] body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
            if ([dic[@"status"] isEqualToNumber:@0]) {
                STRONG_SELF;
                NSArray *array = dic[@"items"];
                NSMutableArray *mutArr = [[NSMutableArray alloc] initWithCapacity:0];
                for (NSDictionary *dic in array) {
                    BannerModel *model = [[BannerModel alloc] initWithDictionary:dic error:nil];
                    [self.bannerDataSource addObject:model];
                    [mutArr addObject:model.img];
                }
                self.cycleScroll.imageURLStringsGroup = mutArr;
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
    
    if ([AXGCache objectForKey:MD5Hash(hotUrl)]) {
        NSData *cacheData = [AXGCache objectForKey:MD5Hash(hotUrl)];
        NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:cacheData options:0 error:nil];
        if ([dic[@"status"] isEqualToNumber:@0]) {
            NSArray *array = dic[@"songs"];
            
            for (NSDictionary *dic in array) {
                SongModel *songModel = [[SongModel alloc] initWithDictionary:dic error:nil];
                
                [self.hotDataSource addObject:songModel];
            }
            self.recommandDelegate.hotDataSource = self.hotDataSource;

        }
        
        [self.tableViewRecommand.mj_header endRefreshing];
        
        [self.tableViewRecommand reloadData];

    } else {
    
        [XWAFNetworkTool getUrl:hotUrl body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
            if ([dic[@"status"] isEqualToNumber:@0]) {
                NSArray *array = dic[@"songs"];
                
                for (NSDictionary *dic in array) {
                    SongModel *songModel = [[SongModel alloc] initWithDictionary:dic error:nil];
                    
                    [self.hotDataSource addObject:songModel];
                }
                self.recommandDelegate.hotDataSource = self.hotDataSource;
            }
            
            [self.tableViewRecommand.mj_header endRefreshing];
            
            
            [self.tableViewRecommand reloadData];

            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"首页请求错误%@", error.description);
            
            [self.tableViewRecommand.mj_header endRefreshing];
            
        }];
    }
    
    if ([AXGCache objectForKey:[NSString stringWithFormat:GET_SING_SONG, self.beginIndex, self.songLength]]) {
        NSData *cacheData = [AXGCache objectForKey:[NSString stringWithFormat:GET_SING_SONG, self.beginIndex, self.songLength]];
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:cacheData options:0 error:nil];
        if ([dic1[@"status"] isEqualToNumber:@0]) {
            NSArray *array = dic1[@"songs"];
            
            for (NSDictionary *dic in array) {
                SongModel *songModel = [[SongModel alloc] initWithDictionary:dic error:nil];
                
                [self.personSoundDataSource addObject:songModel];
            }
            
            self.recommandDelegate.recommandDataSource = self.personSoundDataSource;

        }
        
        NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
        [self.tableViewRecommand reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
        
    } else {
        // 人声接口
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_SING_SONG, self.beginIndex, self.songLength] body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
            if ([dic1[@"status"] isEqualToNumber:@0]) {
                NSArray *array = dic1[@"songs"];
                
                for (NSDictionary *dic in array) {
                    SongModel *songModel = [[SongModel alloc] initWithDictionary:dic error:nil];
                    
                    [self.personSoundDataSource addObject:songModel];
                }
                
                self.recommandDelegate.recommandDataSource = self.personSoundDataSource;
                
            }
            
            NSIndexSet *indexSet = [[NSIndexSet alloc] initWithIndex:1];
            @try {
                [self.tableViewRecommand reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception.description);
            }
            @finally {
                
            }
//            [self.tableViewRecommand reloadSections:indexSet withRowAnimation:UITableViewRowAnimationAutomatic];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
    if ([AXGCache objectForKey:MD5Hash(GET_RECOMMAND_USER)]) {
        NSData *cacheData = [AXGCache objectForKey:MD5Hash(GET_RECOMMAND_USER)];
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:cacheData options:0 error:nil];
        if ([dic1[@"status"] isEqualToNumber:@0]) {
            NSArray *array = dic1[@"items"];
            for (NSDictionary *dic in array) {
                UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                [self.talentDataSource addObject:model];
            }

            self.recommandDelegate.personSoundDataSource = self.talentDataSource;
            
            NSIndexSet *indexSet2 = [[NSIndexSet alloc] initWithIndex:2];
            [self.tableViewRecommand reloadSections:indexSet2 withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
    } else {
        [XWAFNetworkTool getUrl:GET_RECOMMAND_USER body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
            if ([dic1[@"status"] isEqualToNumber:@0]) {
                NSArray *array = dic1[@"items"];
                for (NSDictionary *dic in array) {
                    UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                    [self.talentDataSource addObject:model];
                }

                self.recommandDelegate.personSoundDataSource = self.talentDataSource;
                
                NSIndexSet *indexSet2 = [[NSIndexSet alloc] initWithIndex:2];
                [self.tableViewRecommand reloadSections:indexSet2 withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
    if ([AXGCache objectForKey:MD5Hash(GET_GEDANS)]) {
        NSData *cacheData = [AXGCache objectForKey:MD5Hash(GET_GEDANS)];
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:cacheData options:0 error:nil];
        
        if ([dic1[@"status"] isEqualToNumber:@0]) {
            
            NSArray *item = dic1[@"items"];
            for (NSDictionary *dic in item) {
                ActivityModel *model = [[ActivityModel alloc] initWithDictionary:dic error:nil];
                
                [self.activityDataSource addObject:model];
                
            }
            
            self.recommandDelegate.songListDataSource = self.activityDataSource;
            
            NSIndexSet *indexSet3 = [[NSIndexSet alloc] initWithIndex:3];
            [self.tableViewRecommand reloadSections:indexSet3 withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
        
    } else {
        // 获取所有活动
        [XWAFNetworkTool getUrl:GET_GEDANS body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
            
            if ([dic1[@"status"] isEqualToNumber:@0]) {
                
                NSArray *item = dic1[@"items"];
                for (NSDictionary *dic in item) {
                    ActivityModel *model = [[ActivityModel alloc] initWithDictionary:dic error:nil];
                    
                    [self.activityDataSource addObject:model];
                    
                }
                
                self.recommandDelegate.songListDataSource = self.activityDataSource;
                
                NSIndexSet *indexSet31 = [[NSIndexSet alloc] initWithIndex:3];
                @try {
                    [self.tableViewRecommand reloadSections:indexSet31 withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception.description);
                }
                @finally {
                    
                }
               
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
    if ([AXGCache objectForKey:MD5Hash(GET_GOOD_LYRIC)]) {
        NSData *cacheData = [AXGCache objectForKey:MD5Hash(GET_GOOD_LYRIC)];
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:cacheData options:0 error:nil];
        if ([dic1[@"status"] isEqualToNumber:@0]) {
            NSArray *array = dic1[@"items"];
            
//            NSMutableArray *mutDataSource = [[NSMutableArray alloc] initWithCapacity:0];
            
            for (int i = 0; i < array.count; i++) {
                NSDictionary *dic = array[i];
                SongModel *model = [[SongModel alloc] initWithDictionary:dic error:nil];
                [self.goodLyricDataSource addObject:model];
//                if (i < 3) {
//                    [mutDataSource addObject:dic];
//                }
            }
            
            self.recommandDelegate.talentDataSource = self.goodLyricDataSource;
            
            NSIndexSet *indexSet4 = [[NSIndexSet alloc] initWithIndex:4];
            @try {
                [self.tableViewRecommand reloadSections:indexSet4 withRowAnimation:UITableViewRowAnimationAutomatic];
            }
            @catch (NSException *exception) {
                NSLog(@"%@", exception.description);
            }
            @finally {
                
            }
//            [self.tableViewRecommand reloadSections:indexSet4 withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
    } else {
        [XWAFNetworkTool getUrl:GET_GOOD_LYRIC body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
            if ([dic1[@"status"] isEqualToNumber:@0]) {
                NSArray *array = dic1[@"items"];
                
//                NSMutableArray *mutDataSource = [[NSMutableArray alloc] initWithCapacity:0];
                
                for (int i = 0; i < array.count; i++) {
                    NSDictionary *dic = array[i];
                    SongModel *model = [[SongModel alloc] initWithDictionary:dic error:nil];
                    [self.goodLyricDataSource addObject:model];
//                    if (i < 3) {
//                        [mutDataSource addObject:dic];
//                    }
                }
                
                self.recommandDelegate.talentDataSource = self.goodLyricDataSource;
                
                NSIndexSet *indexSet4 = [[NSIndexSet alloc] initWithIndex:4];
                
                @try {
                    [self.tableViewRecommand reloadSections:indexSet4 withRowAnimation:UITableViewRowAnimationAutomatic];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@", exception.description);
                }
                @finally {
                    
                }
//                [self.tableViewRecommand reloadSections:indexSet4 withRowAnimation:UITableViewRowAnimationAutomatic];
                
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
}

// 加载活动数据
- (void)refreshActivity {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.activityIsRefreshed = YES;
        [self.navActivityDataSource removeAllObjects];
        self.activityDelegate.dataSource = nil;
        [self getActivityThemeData:NO];
    }];
    self.activityTable.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getActivityThemeData:YES];
    }];
    self.activityTable.mj_footer = footer;
}

// 获取活动数据
- (void)getActivityThemeData:(BOOL)isMore {
    
    if (isMore) {
        [self.activityTable.mj_footer endRefreshing];
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
                    
                    [self.navActivityDataSource addObject:model];
                    
                }
                
                self.activityDelegate.dataSource = self.navActivityDataSource;
                
                [self.activityTable reloadData];
                [self.activityTable.mj_header endRefreshing];
                
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
                        
                        [self.navActivityDataSource addObject:model];
                        
                    }
                    
                    self.activityDelegate.dataSource = self.navActivityDataSource;
                    
                    [self.activityTable reloadData];
                    [self.activityTable.mj_header endRefreshing];
                    
                }
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                [self.activityTable reloadData];
                [self.activityTable.mj_header endRefreshing];
            }];
        }
    }
}

// 加载最新数据
- (void)refreshLatest {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.latestIsRefreshed = YES;
        [self.latestDataSource removeAllObjects];
        self.latestDelegate.dataSource = nil;
        [self getLatestData:NO];
    }];
    self.tableViewLatest.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getLatestData:YES];
    }];
    self.tableViewLatest.mj_footer = footer;
}

// 请求最新数据
- (void)getLatestData:(BOOL)isMore {
    if (isMore) {
        [self.tableViewLatest.mj_header endRefreshing];
        
        if (self.latestDataSource.count % 6 == 0) {
            self.beginIndex = 6 * (self.latestDataSource.count / 6);
            //                self.endIndex = self.endIndex + 6;
        } else {
            [self.tableViewLatest.mj_footer endRefreshing];
            
            [MBProgressHUD showError:DATA_DONE];
            return;
        }
        
    } else {
        [self.tableViewLatest.mj_footer endRefreshing];
        self.beginIndex = 0;
        self.songLength = 6;
    }
    NSString *url = [NSString stringWithFormat:GET_LASTEST, self.beginIndex, self.songLength];

    [XWAFNetworkTool getUrl:url body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
        
        if ([dic1[@"status"] isEqualToNumber:@0]) {
            NSArray *array = dic1[@"songs"];
            
            for (NSDictionary *dic in array) {
                SongModel *songModel = [[SongModel alloc] initWithDictionary:dic error:nil];
                
                [self.latestDataSource addObject:songModel];
            }
            
            self.latestDelegate.dataSource = self.latestDataSource;
        }
        
        [self.tableViewLatest.mj_header endRefreshing];
    
        [self.tableViewLatest reloadData];
        
        if (!isMore) {
            [self.tableViewLatest.mj_header endRefreshing];
        } else {
            [self.tableViewLatest.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"首页请求错误%@", error.description);
        
        if (!isMore) {
            [self.tableViewLatest.mj_header endRefreshing];
        } else {
            [self.tableViewLatest.mj_footer endRefreshing];
        }
    }];
}

// 自唱的接口
- (void)refreshLatestChang {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.changIsRefreshed = YES;
        [self.changDataSource removeAllObjects];
        self.changDelegate.dataSource = nil;
        [self getLatestChangData:NO];
    }];
    self.tableViewLatestChang.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getLatestChangData:YES];
    }];
    self.tableViewLatestChang.mj_footer = footer;
}

- (void)getLatestChangData:(BOOL)isMore {
    if (isMore) {
        [self.tableViewLatestChang.mj_header endRefreshing];
        
        if (self.changDataSource.count % 6 == 0) {
            self.beginIndex = 6 * (self.changDataSource.count / 6);
            //                self.endIndex = self.endIndex + 6;
        } else {
            [self.tableViewLatestChang.mj_footer endRefreshing];
            
            [MBProgressHUD showError:DATA_DONE];
            return;
        }
        
    } else {
        [self.tableViewLatestChang.mj_footer endRefreshing];
        self.beginIndex = 0;
        self.songLength = 6;
    }
    NSString *url = [NSString stringWithFormat:GET_LASTEST_SING, self.beginIndex, self.songLength];
    
    [XWAFNetworkTool getUrl:url body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
        
        if ([dic1[@"status"] isEqualToNumber:@0]) {
            NSArray *array = dic1[@"songs"];
            
            for (NSDictionary *dic in array) {
                SongModel *songModel = [[SongModel alloc] initWithDictionary:dic error:nil];
                
                [self.changDataSource addObject:songModel];
            }
            
            self.changDelegate.dataSource = self.changDataSource;
        }
        
        [self.tableViewLatestChang.mj_header endRefreshing];
        
        
        [self.tableViewLatestChang reloadData];
        
        if (!isMore) {
            [self.tableViewLatestChang.mj_header endRefreshing];
        } else {
            [self.tableViewLatestChang.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"首页请求错误%@", error.description);
        
        if (!isMore) {
            [self.tableViewLatestChang.mj_header endRefreshing];
        } else {
            [self.tableViewLatestChang.mj_footer endRefreshing];
        }
    }];
}

// 改曲接口
- (void)refreshLatestGai {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        self.gaiIsRefreshed = YES;
        [self.gaiDataSource removeAllObjects];
        self.gaiDelegate.dataSource = nil;
        [self getLatestGaiData:NO];
    }];
    self.tableViewLatestGai.mj_header = header;
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getLatestGaiData:YES];
    }];
    self.tableViewLatestGai.mj_footer = footer;
}

- (void)getLatestGaiData:(BOOL)isMore {
    if (isMore) {
        [self.tableViewLatestGai.mj_header endRefreshing];
        
        if (self.gaiDataSource.count % 6 == 0) {
            self.beginIndex = 6 * (self.gaiDataSource.count / 6);
            //                self.endIndex = self.endIndex + 6;
        } else {
            [self.tableViewLatestGai.mj_footer endRefreshing];
            
            [MBProgressHUD showError:DATA_DONE];
            return;
        }
        
    } else {
        [self.tableViewLatestGai.mj_footer endRefreshing];
        self.beginIndex = 0;
        self.songLength = 6;
    }
    NSString *url = [NSString stringWithFormat:GET_LASTEST_GAI, self.beginIndex, self.songLength];
    
    [XWAFNetworkTool getUrl:url body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
        
        if ([dic1[@"status"] isEqualToNumber:@0]) {
            NSArray *array = dic1[@"songs"];
            
            for (NSDictionary *dic in array) {
                SongModel *songModel = [[SongModel alloc] initWithDictionary:dic error:nil];
                
                [self.gaiDataSource addObject:songModel];
            }
            
            self.gaiDelegate.dataSource = self.gaiDataSource;
        }
        
        [self.tableViewLatestGai.mj_header endRefreshing];
        
        
        [self.tableViewLatestGai reloadData];
        
        if (!isMore) {
            [self.tableViewLatestGai.mj_header endRefreshing];
        } else {
            [self.tableViewLatestGai.mj_footer endRefreshing];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"首页请求错误%@", error.description);
        
        if (!isMore) {
            [self.tableViewLatestGai.mj_header endRefreshing];
        } else {
            [self.tableViewLatestGai.mj_footer endRefreshing];
        }
    }];
}

#pragma mark - Action

// 跳转到搜索界面
- (void)turnToSearchVC {
    
//    WebViewController *webVC = [[WebViewController alloc] init];
//    webVC.url = [NSURL URLWithString:@"http://www.woyaoxiege.com/home/index/spqResult.html?pa=%E5%AE%8B%E6%85%A7%E4%B9%94&sha=%E5%88%98%E8%AF%97%E8%AF%97&qu=%E5%85%B3%E6%99%93%E5%BD%A4"];
//    [self.navigationController pushViewController:webVC animated:YES];
    
    
    SearchViewController *searchVC = [[SearchViewController alloc] init];
    [self.navigationController pushViewController:searchVC animated:YES];
    
}

// 最新上方按钮方法
- (void)latestChangeAction:(UIButton *)button {
    
    [self changeLatestWithTag:button.tag - 100];
    
}

- (void)changeLatestWithTag:(NSInteger)tag {
    switch (tag) {
        case 0: {
            
            [self.latestScroll setContentOffset:CGPointMake(0, 0) animated:YES];
        }
            break;
        case 1: {
            
            [self.latestScroll setContentOffset:CGPointMake(self.view.width, 0) animated:YES];
        }
            break;
        case 2: {
            
            [self.latestScroll setContentOffset:CGPointMake(self.view.width * 2, 0) animated:YES];
        }
            break;
            
        default:
            break;
    }
}

// 刷新首页
- (void)reloadHome {
    self.latestIsRefreshed = NO;
    [self newClick:nil];
    if (self.latestScroll.contentOffset.x != 0) {
        [self changeLatestWithTag:0];
    }
}

// 手势打开抽屉
- (void)edgePanAction {
    [self drawerButtonAction:nil];
}

// 打开抽屉方法
- (void)drawerButtonAction:(UIButton *)sender {

    KYDrawerController *drawerVC = (KYDrawerController *)self.navigationController.parentViewController;

    [drawerVC setDrawerState:DrawerStateOpened animated:YES];
    
//    [self.mm_drawerController
//     openDrawerSide:MMDrawerSideLeft
//     animated:YES
//     completion:^(BOOL finished) {
//         
//     }];
    
}

// 推到榜单
- (void)pushToRankController {
    HomeRankController *hrc = [HomeRankController new];
    [self.navigationController pushViewController:hrc animated:YES];
}

// 推到详情页
- (void)pushToDetailVC:(NSInteger)index {
    
    // 乐谈
    if (index == 0) {
        
        ForumViewController *forumVC = [[ForumViewController alloc] init];
        [self.navigationController pushViewController:forumVC animated:YES];
        
    } else {
        
        // 其他
        
        HomeSongListViewController *VC = [[HomeSongListViewController alloc] init];
        VC.type = index;
        if (index == 2) {
            VC.array = self.recommandDataSource;
        } else if (index == 4) {
            VC.array = self.goodLyricDataSource;
        } else if (index == 5) {
            
            [MobClick event:@"home_activity"];
            
            VC.array = self.activityDataSource;
            
        } else if (index == 7) {
            ActivityModel *model = self.activityDataSource[self.songlistNum];
            VC.activitiId = model.dataId;
            VC.activityTitle = model.name;
        }
        [self.navigationController pushViewController:VC animated:YES];
    }
}

// 推到用户歌曲界面
- (void)pushToUserSongVC:(id)cell {
    
//    self.lyricURL = @"http://service.woyaoxiege.com/music/lrc/f5a13eca90cbe22dd8a3c412e941e61e_6.lrc";
//    self.soundURL = @"http://service.woyaoxiege.com/music/mp3/f5a13eca90cbe22dd8a3c412e941e61e_6.mp3";
//    self.soundName = @"七夕";
//    self.listenCount = 1234;
//    self.user_id = @"20590";
//    self.createTimeStr = @"2016-07-16 19:14:27";
//    self.loveCount = @"4321";
//    self.song_id = @"22958";
//    self.needReload = YES;
//    self.songCode = @"f5a13eca90cbe22dd8a3c412e941e61e_6";
    
    PlayUserSongViewController *playVC = [[PlayUserSongViewController alloc] init];
    
    if ([cell isKindOfClass:[HotTableViewCell class]]) {
        
        HotTableViewCell *acell = (HotTableViewCell *)cell;
//        playVC.lyricURL = [NSString stringWithFormat:HOME_LYRIC, acell.songModel.code];
//        playVC.soundURL = [NSString stringWithFormat:HOME_SOUND, acell.songModel.code];
//        playVC.soundName = [acell.titleLabel.text emojizedString];
//        playVC.listenCount = [acell.songModel.play_count integerValue];
//        playVC.user_id = acell.songModel.user_id;
//        playVC.createTimeStr = acell.songModel.create_time;
//        playVC.loveCount = acell.songModel.up_count;
//        playVC.song_id = acell.songModel.dataId;
//        playVC.needReload = YES;
        playVC.songCode = acell.songModel.code;
//        playVC.themeImageView.image = acell.themeImage.image;
        
    } else if ([cell isKindOfClass:[RecommandCollectionViewCell class]]) {
        
        RecommandCollectionViewCell *acell = (RecommandCollectionViewCell *)cell;
//        playVC.lyricURL = [NSString stringWithFormat:HOME_LYRIC, acell.model.code];
//        playVC.soundURL = [NSString stringWithFormat:HOME_SOUND, acell.model.code];
//        playVC.soundName = [acell.titleLabel.text emojizedString];
//        playVC.listenCount = [acell.model.play_count integerValue];
//        playVC.user_id = acell.model.user_id;
//        playVC.createTimeStr = acell.model.create_time;
//        playVC.loveCount = acell.model.up_count;
//        playVC.song_id = acell.model.dataId;
//        playVC.needReload = YES;
        playVC.songCode = acell.model.code;
//        playVC.themeImageView.image = acell.themeImage.image;
        
    }
//    else if ([cell isKindOfClass:[PersonSoundCollectionViewCell class]]) {
//        
//        PersonSoundCollectionViewCell *acell = (PersonSoundCollectionViewCell *)cell;
//        playVC.lyricURL = [NSString stringWithFormat:HOME_LYRIC, acell.model.code];
//        playVC.soundURL = [NSString stringWithFormat:HOME_SOUND, acell.model.code];
//        playVC.soundName = [acell.model.title emojizedString];
//        playVC.listenCount = [acell.model.play_count integerValue];
//        playVC.user_id = acell.model.user_id;
//        playVC.createTimeStr = acell.model.create_time;
//        playVC.loveCount = acell.model.up_count;
//        playVC.song_id = acell.model.dataId;
//        playVC.needReload = YES;
//        playVC.songCode = acell.model.code;
//        playVC.themeImageView.image = acell.themeImage.image;
//        
//    }
    
//    [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_PLAYCOUNT, playVC.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
    
    [self.navigationController pushViewController:playVC animated:YES];
}

// 推到达人详情页
- (void)pushToTalentVC:(PersonSoundCollectionViewCell *)cell {
    
    OtherPersonCenterController *otherVC = [[OtherPersonCenterController alloc] initWIthUserId:cell.model.userModelId];
    [self.navigationController pushViewController:otherVC animated:YES];
    
}

// 推到活动详情页
- (void)pushToActivityVC:(ActivityModel *)model {
    
}

// 从Safari打开
- (void)safriUrl {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (app.isLaunchedBySafari) {
        [self dealNotificationWithUrlString:app.safariString];
    }
}

// 推送消息
- (void)pushInfo {
    AppDelegate *app = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    if (app.isLaunchedByNotification) {
        if ([app.remoteNotification.allKeys containsObject:@"link"]) {
            NSString *urlString = app.remoteNotification[@"link"];
            [self dealNotificationWithUrlString:urlString];
        }
    }
    
}

// 收到推送消息后的操作
- (void)pushNotificationAction:(NSNotification *)message {
    
    NSDictionary *dic = message.object;
    
    if ([dic.allKeys containsObject:@"link"]) {
        NSString *urlString = dic[@"link"];
        [self dealNotificationWithUrlString:urlString];
    }
    
}

// 收到字符串后处理推送消息
- (void)dealNotificationWithUrlString:(NSString *)urlString {
    
    NSURL *url = [NSURL URLWithString:urlString];
    NSLog(@"scheme %@   query %@   paramter %@", [url scheme], [url query], [url parameterString]);
    NSString *query = [url query];
    //        query = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSArray *array = [query componentsSeparatedByString:@"&"];
    NSMutableDictionary *notificationDic = [[NSMutableDictionary alloc] initWithCapacity:0];
    for (NSString *string in array) {
        NSArray *subArray = [string componentsSeparatedByString:@"="];
        [notificationDic setObject:[subArray lastObject] forKey:[subArray firstObject]];
    }
    NSLog(@"推送消息 -- %@", notificationDic);
    
    if ([notificationDic[@"action"] isEqualToString:@"playSong"]) {
        // 播放歌曲
        NSString *code = notificationDic[@"code"];
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_SONG_MESS, code] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            
            NSDictionary *dictionary = resposeObject;
            SongModel *model = [[SongModel alloc] initWithDictionary:dictionary error:nil];
            
            PlayUserSongViewController *playVC = [[PlayUserSongViewController alloc] init];
            
//            playVC.lyricURL = [NSString stringWithFormat:HOME_LYRIC, model.code];
//            playVC.soundURL = [NSString stringWithFormat:HOME_SOUND, model.code];
//            playVC.soundName = [model.title emojizedString];
//            playVC.listenCount = [model.play_count integerValue];
//            playVC.user_id = model.user_id;
//            playVC.createTimeStr = model.create_time;
//            playVC.loveCount = model.up_count;
//            playVC.song_id = model.dataId;
//            playVC.needReload = YES;
            playVC.songCode = model.code;
            
//            NSString *imageUrl = [NSString stringWithFormat:GET_SONG_IMG, model.code];
//            NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:imageUrl]];
//            UIImage *image = [UIImage imageWithData:data];
//            playVC.themeImageView.image = image;
//            
//            [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_PLAYCOUNT, playVC.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//                
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                
//            }];
            
            [self.navigationController pushViewController:playVC animated:YES];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    } else if ([notificationDic[@"action"] isEqualToString:@"innerH5"]) {
        // 内嵌h5
        NSString *webUrl = notificationDic[@"url"];
        WebViewController *webViewVC = [[WebViewController alloc] init];
        webViewVC.url = [NSURL URLWithString:webUrl];
        [self.navigationController pushViewController:webViewVC animated:YES];
        
    } else if ([notificationDic[@"action"] isEqualToString:@"activityDetail"]) {
        // 活动详情
        NSString *acId = notificationDic[@"id"];
        NSString *acName = notificationDic[@"title"];
        NSString *img = notificationDic[@"img"];
        ActivityDetailViewController *acVC = [[ActivityDetailViewController alloc] init];
        acVC.activitiId = acId;
        acVC.activityName = acName;
        acVC.needRefresh = YES;
        NSData * data = [NSData dataWithContentsOfURL:[NSURL URLWithString:img]];
        UIImage *image = [UIImage imageWithData:data];
        acVC.image = image;
        
        [self.navigationController pushViewController:acVC animated:YES];
        
    } else if ([notificationDic[@"action"] isEqualToString:@"rankList"]) {
        // 榜单
        [self pushToRankController];
        
    } else if ([notificationDic[@"action"] isEqualToString:@"otherPersonalCenter"]) {
        // 他人个人中心
        NSString *userId = notificationDic[@"userId"];
        OtherPersonCenterController *personCenter = [[OtherPersonCenterController alloc] initWIthUserId:userId];
        [self.navigationController pushViewController:personCenter animated:YES];
        
    } else if ([notificationDic[@"action"] isEqualToString:@"homePage"]) {
        // 主页
        
    } else if ([notificationDic[@"action"] isEqualToString:@"hotSongs"]) {
        // 热门歌曲
        [self pushToDetailVC:1];
        
    } else if ([notificationDic[@"action"] isEqualToString:@"character"]) {
        // 个性推荐
        
    } else if ([notificationDic[@"action"] isEqualToString:@"manMadeSong"]) {
        // 最美人声
        [self pushToDetailVC:3];
        
    } else if ([notificationDic[@"action"] isEqualToString:@"hotWriters"]) {
        // 达人
        
    } else if ([notificationDic[@"action"] isEqualToString:@"allActivities"]) {
        // 活动列表
        [self pushToDetailVC:5];
        
    }
    
}

#pragma mark - scrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    CGFloat offsetX = scrollView.contentOffset.x;
    
    if (scrollView == self.scroll) {
        
        CGFloat xWidth = self.centerX2 - self.centerX1;
        
        self.titleSlider.center = CGPointMake(self.centerX1 + xWidth * offsetX / self.view.width, self.titleSlider.centerY);
        
        if (offsetX == width(self.view)) {
            
            self.recommandLabel.textColor = HexStringColor(@"#ffffff");
            self.latestLabel.textColor = HexStringColor(@"#441D11");
            self.activityLabel.textColor = HexStringColor(@"#ffffff");
            
            if (self.latestIsRefreshed) {
                return;
            }
            
            [self.tableViewRecommand.mj_header endRefreshing];
            [self.tableViewRecommand.mj_footer endRefreshing];
            
            [self.activityTable.mj_header endRefreshing];
            [self.activityTable.mj_footer endRefreshing];
            
            [self.tableViewLatest.mj_header beginRefreshing];
            
        } else if (offsetX == 0) {
            
            self.recommandLabel.textColor = HexStringColor(@"#441D11");
            self.latestLabel.textColor = HexStringColor(@"#ffffff");
            self.activityLabel.textColor = HexStringColor(@"#ffffff");
            
            
            if (self.suggestIsRefreshed) {
                return;
            }
            [self.tableViewLatest.mj_header endRefreshing];
            [self.tableViewLatest.mj_footer endRefreshing];
            
            [self.activityTable.mj_header endRefreshing];
            [self.activityTable.mj_footer endRefreshing];
            
//            [self.tableViewRecommand.mj_header beginRefreshing];
            

        } else if (offsetX == self.view.width * 2) {
            
            [MobClick event:@"home_nav_activity"];
            
            self.recommandLabel.textColor = HexStringColor(@"#ffffff");
            self.latestLabel.textColor = HexStringColor(@"#ffffff");
            self.activityLabel.textColor = HexStringColor(@"#441D11");
            
            if (self.activityIsRefreshed) {
                return;
            }
            
            [self.tableViewRecommand.mj_header endRefreshing];
            [self.tableViewRecommand.mj_footer endRefreshing];
            
            [self.tableViewLatest.mj_header endRefreshing];
            [self.tableViewLatest.mj_footer endRefreshing];
            
            [self.activityTable.mj_header beginRefreshing];
            
        }
    } else if (scrollView == self.latestScroll) {
        
        CGFloat xWidth = self.singX - self.allX;
        
        self.tagView.center = CGPointMake(self.allX + xWidth * offsetX / self.view.width, self.tagView.centerY);

        if (offsetX == 0) {
            
            [self.allButton setTitleColor:HexStringColor(@"#FFDC74") forState:UIControlStateNormal];
            self.allButton.titleLabel.font = JIACU_FONT(15);
            
            [self.changButton setTitleColor:HexStringColor(@"#A0A0A0") forState:UIControlStateNormal];
            self.changButton.titleLabel.font = NORML_FONT(15);
            
            [self.gaiButton setTitleColor:HexStringColor(@"#A0A0A0") forState:UIControlStateNormal];
            self.gaiButton.titleLabel.font = NORML_FONT(15);
            
            if (self.latestIsRefreshed) {
                return;
            }
            [self.tableViewLatest.mj_header beginRefreshing];
            
        } else if (offsetX == self.view.width) {
            
            [self.allButton setTitleColor:HexStringColor(@"#A0A0A0") forState:UIControlStateNormal];
            self.allButton.titleLabel.font = NORML_FONT(15);
            
            [self.changButton setTitleColor:HexStringColor(@"#FFDC74") forState:UIControlStateNormal];
            self.changButton.titleLabel.font = JIACU_FONT(15);
            
            [self.gaiButton setTitleColor:HexStringColor(@"#A0A0A0") forState:UIControlStateNormal];
            self.gaiButton.titleLabel.font = NORML_FONT(15);
            
            if (self.changIsRefreshed) {
                return;
            }
            [self.tableViewLatestChang.mj_header beginRefreshing];
            
        } else if (offsetX == self.view.width * 2) {
            
            [self.allButton setTitleColor:HexStringColor(@"#A0A0A0") forState:UIControlStateNormal];
            self.allButton.titleLabel.font = NORML_FONT(15);
            
            [self.changButton setTitleColor:HexStringColor(@"#A0A0A0") forState:UIControlStateNormal];
            self.changButton.titleLabel.font = NORML_FONT(15);
            
            [self.gaiButton setTitleColor:HexStringColor(@"#FFDC74") forState:UIControlStateNormal];
            self.gaiButton.titleLabel.font = JIACU_FONT(15);
            
            if (self.gaiIsRefreshed) {
                return;
            }
            [self.tableViewLatestGai.mj_header beginRefreshing];
            
        }
        
    }
}

#pragma mark - 站内信方法

// 收到新消息
- (void)receiveNewMessage {
    self.msgView.hidden = NO;
}

// 刷新站内信数据
- (void)reloadMsg {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(receiveNewMessage) name:@"didReceiveMessage" object:nil];
    
    NSMutableArray *mutaArr = [[NSMutableArray alloc] initWithCapacity:0];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        
        NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
        NSInteger unreadCount = 0;
        for (EMConversation *conversation in conversations) {
            unreadCount += conversation.unreadMessagesCount;
        }
        
        if (unreadCount != 0) {
            self.msgView.hidden = NO;
        } else {
            //     获取用户id
            KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
            NSString *userId = [wrapper objectForKey:(id)kSecValueData];
            
            WEAK_SELF;
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_MESSAGE, userId] body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
                STRONG_SELF;
                if ([dic1[@"status"] isEqualToNumber:@0]) {
                    NSArray *array = dic1[@"items"];
                    
                    for (NSDictionary *dic in array) {
                        if ([dic[@"is_read"] isEqualToString:@"1"]) {
                            
                        } else {
                            [mutaArr addObject:dic];
                        }
                    }
                    
                    if (mutaArr.count != 0) {
                        self.msgView.hidden = NO;
                    } else {
                        self.msgView.hidden = YES;
                    }
                    
                } else {
                    self.msgView.hidden = YES;
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                self.msgView.hidden = YES;
            }];
        }
        
    } else {
        self.msgView.hidden = YES;
    }
    
}

//// 推到消息页
//- (void)turnToMsgView {
//    
//    MsgViewController *msgVC = [[MsgViewController alloc] init];
//    [self.navigationController pushViewController:msgVC animated:YES];
//    
//}

#pragma mark - 导航栏滚动条方法

// 导航栏滚动条方法

- (void)suggestClick:(UIButton *)btn {

    [self.scroll setContentOffset:CGPointMake(0, self.scroll.contentOffset.y) animated:YES];
    
//    if (self.suggestIsRefreshed) {
//        return;
//    }
//    [self.tableViewLatest.mj_header endRefreshing];
//    [self.tableViewLatest.mj_footer endRefreshing];
//    
//    [self.activityTable.mj_header endRefreshing];
//    [self.activityTable.mj_footer endRefreshing];
//
//    [self.tableViewRecommand.mj_header beginRefreshing];

}

- (void)newClick:(UIButton *)btn {
    
    [self.scroll setContentOffset:CGPointMake(width(self.scroll), self.scroll.contentOffset.y) animated:YES];
    
//    if (self.latestIsRefreshed) {
//        return;
//    }
//    
//    [self.tableViewRecommand.mj_header endRefreshing];
//    [self.tableViewRecommand.mj_footer endRefreshing];
//    
//    [self.activityTable.mj_header endRefreshing];
//    [self.activityTable.mj_footer endRefreshing];
//    
//    [self.tableViewLatest.mj_header beginRefreshing];

}

- (void)activityButtonClick:(UIButton *)sender {
    
    [self.scroll setContentOffset:CGPointMake(width(self.scroll) * 2, self.scroll.contentOffset.y) animated:YES];
    
//    if (self.activityIsRefreshed) {
//        return;
//    }
//    
//    [self.tableViewRecommand.mj_header endRefreshing];
//    [self.tableViewRecommand.mj_footer endRefreshing];
//    
//    [self.tableViewLatest.mj_header endRefreshing];
//    [self.tableViewLatest.mj_footer endRefreshing];
//    
//    [self.activityTable.mj_header beginRefreshing];
    
}

- (void)forumButtonClick:(UIButton *)sender {
    
    //    self.bottomBgView.image = [UIImage imageNamed:@"send_post"];
    //    self.homeType = forumType;
    //
    //    if (!self.forumButton.selected) {
    //        //        _rightNewLabel.alpha = 1.0f;
    //        //        _suggestLabel.alpha = 0.0f;
    //        //        _rightNewLabel2.alpha = 0.0f;
    [self.scroll setContentOffset:CGPointMake(width(self.scroll) * 2, self.scroll.contentOffset.y) animated:YES];
    //        [_suggestBtn setSelected:NO];
    //        [_rightNewBtn setSelected:NO];
    //        [self.forumButton setSelected:YES];
    
    //        if (self.forumIsRefreshed) {
    //            return;
    //        }
    
    //        [self.tableViewRecommand.mj_header endRefreshing];
    //        [self.tableViewRecommand.mj_footer endRefreshing];
    //        [self.collectionViewLastest.mj_header endRefreshing];
    //        [self.collectionViewLastest.mj_footer endRefreshing];
    //
    //        [self.forumTable.mj_header beginRefreshing];
    //    }
    //    [_suggestBtn setSelected:NO];
    //    [_rightNewBtn setSelected:NO];
    //    [self.forumButton setSelected:YES];
}

#pragma mark - SDCycleScrollViewDelegate
- (void)cycleScrollView:(SDCycleScrollView *)cycleScrollView didSelectItemAtIndex:(NSInteger)index {
    
    [MobClick event:[NSString stringWithFormat:@"home_banner%d", index]];
    
    BannerModel *model = self.bannerDataSource[index];
    NSString *url = model.url;
    if (url.length != 0) {
        WebViewController *webVC = [[WebViewController alloc] init];
        webVC.url = [NSURL URLWithString:url];
        [self.navigationController pushViewController:webVC animated:YES];
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
