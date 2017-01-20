//
//  DraftsViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/21.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "DraftsViewController.h"
#import "YTKKeyValueStore.h"
#import "FMDB.h"
#import "XieciViewController.h"
//#import "UIViewController+MMDrawerController.h"
#import "DraftsTableViewCell.h"
#import "AXGTools.h"
#import "DraftsDelegate.h"
#import "CreateSongs-Swift.h"
//#import "KYDrawerController.h"
#import "TianciViewController.h"
#import "VoiceSettingController.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "EMSDK.h"

static NSString *const identifier = @"TableViewIdentifier";
static NSString *const secondIdentifier = @"secondIdentifier";
static NSString *const thirdIdentifier = @"thirdIdentifier";

@interface DraftsViewController ()<UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UITableView *tableView2;

@property (nonatomic, strong) UITableView *tableView3;

@property (nonatomic, strong) DraftsDelegate *delegate;

@property (nonatomic, strong) DraftsDelegate *delegate2;

@property (nonatomic, strong) DraftsDelegate *delegate3;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, strong) NSMutableArray *dataSource2;

@property (nonatomic, strong) NSMutableArray *dataSource3;

@property (nonatomic, strong) UIImageView *noDataImage;

@property (nonatomic, strong) UILabel *noDataLabel;

@property (nonatomic, strong) UILabel *noDataLabel2;

@property (nonatomic, strong) UIImageView *noDataImage2;

@property (nonatomic, strong) UILabel *noDataLabel3;

@property (nonatomic, strong) UIImageView *noDataImage3;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) UIView *lineView2;

@property (nonatomic, strong) UIView *lineView3;

@property (nonatomic, strong) UILabel *selectOneLabel;

@property (nonatomic, strong) UILabel *selectTwoLabel;

@property (nonatomic, strong) UILabel *selectThreeLabel;

@property (nonatomic, strong) UIButton *btnOne;

@property (nonatomic, strong) UIButton *btnTwo;

@property (nonatomic, strong) UIButton *btnThree;

@property (nonatomic, strong) UIView *tagView;

@property (nonatomic, assign) CGFloat leftX;

@property (nonatomic, assign) CGFloat rightX;

@property (nonatomic, assign) CGFloat threeX;

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation DraftsViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = HexStringColor(@"#eeeeee");
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.dataSource2 = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initNavView];
    [self initDelegate];
    [self createTableView];
    [self createSelectView];
    [self getData];
    [self createEdgePanView];
    
    [self reloadMsg];
    
    [self.view bringSubviewToFront:self.navView];
    
}

#pragma mark - 初始化界面

- (void)initDelegate {
    self.delegate = [DraftsDelegate new];
    self.delegate2 = [DraftsDelegate new];
    self.delegate3 = [DraftsDelegate new];
    
    self.delegate.dbFromType = XianciType;
    self.delegate2.dbFromType = XianquType;
    self.delegate3.dbFromType = RECODERTYPE;
    WEAK_SELF;
    self.delegate.seletBlock = ^ (DraftsTableViewCell *cell) {
        STRONG_SELF;
        
        XieciViewController *xieciVC = [[XieciViewController alloc] init];
        xieciVC.lineFromDrafts = cell.lineNumber;
        xieciVC.contentFromDrafts = cell.contentLabel.text;
        xieciVC.titleFromDrafts = cell.titleLabel.text;
        
        NSLog(@"%@", cell.contentLabel.text);
        
        [self.navigationController pushViewController:xieciVC animated:YES];
        
    };
    
    self.delegate.deleteBlock = ^ (NSDictionary *dic) {
        STRONG_SELF;
        [self.dataSource removeObject:dic];
        if (self.dataSource.count == 0) {
            self.noDataLabel.hidden = NO;
            self.noDataImage.hidden = NO;
            self.lineView.hidden = YES;
        }
    };
    
    self.delegate2.seletBlock = ^(DraftsTableViewCell *cell) {
        STRONG_SELF;
        /**
         @"lyricModel":self.finalLyricModelArray,
         @"xuanQuModel": self.xuanQuModel
         */
       
#if XUANQU_FROME_NET
        TianciViewController *tvc = [TianciViewController new];
        tvc.xuanQuModel = cell.xuanquModel;
        tvc.lyricModelArray = cell.tianciLyricModelArr;
        tvc.lyricFormatArray = cell.lyricFormat;
        tvc.itemModel = cell.itemModel;
        tvc.characLocationsArray = cell.characLocations;
        tvc.requestHeadName = cell.requestHeadName;
#elif !XUANQU_FROME_NET
        TianciViewController *tvc = [TianciViewController new];
        tvc.xuanQuModel = cell.xuanquModel;
        tvc.lyricModelArray = cell.tianciLyricModelArr;
        tvc.lyricFormatArray = cell.lyricFormat;
        tvc.characLocationsArray = cell.characLocations;
        tvc.requestHeadName = cell.requestHeadName;
#endif
        
        [self.navigationController pushViewController:tvc animated:YES];
    };
    self.delegate2.deleteBlock = ^(NSDictionary *dic) {
        STRONG_SELF;
        [self.dataSource2 removeObject:dic];
        if (self.dataSource2.count == 0) {
            self.noDataImage2.hidden = NO;
            self.noDataLabel2.hidden = NO;
            self.lineView2.hidden = YES;
        }
    };
    
    /*
     vsc.lrcDataSource = self.lyricDataSource;
     vsc.shareUrl = self.shareWebUrl;
     vsc.mp3Url = self.shareMp3Url;
     vsc.songName =self.songName;
     
     vsc.code = self.changeSingerAPIName;
     vsc.banzouPath = self.finalBanzouPath;
     vsc.recoderPath = self.finalPath;
     
     */
    self.delegate3.seletBlock = ^(DraftsTableViewCell *cell) {
        STRONG_SELF;
        VoiceSettingController *vsc = [VoiceSettingController new];
        vsc.lrcDataSource = cell.voice_DataSource;
        vsc.shareUrl = cell.voice_shareUrl;
        vsc.mp3Url = cell.voice_mp3Url;
        vsc.songName = cell.voice_songName;
        vsc.code = cell.voice_code;
        vsc.banzouPath = cell.voice_banzouPath;
        vsc.recoderPath = cell.voice_recoderPath;
        [self.navigationController pushViewController:vsc animated:YES];
    };
    
    self.delegate3.deleteBlock = ^(NSDictionary *dic) {
        STRONG_SELF;
        [self.dataSource3 removeObject:dic];
        if (self.dataSource3.count == 0) {
            self.noDataImage3.hidden = NO;
            self.noDataLabel3.hidden = NO;
            self.lineView3.hidden = YES;
        }
    };
}

- (void)initNavView {
    [super initNavView];
//    self.navLeftImage.image = [UIImage imageNamed:@"菜单icon"];
    self.navTitle.text = @"草稿";
    
    [self.navLeftButton setImage:[UIImage imageNamed:@"菜单icon"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"菜单_高亮"] forState:UIControlStateHighlighted];
    
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 创建选择栏
- (void)createSelectView {
    UIView *selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 50 * WIDTH_NIT)];
    [self.view addSubview:selectView];
    selectView.backgroundColor = [UIColor clearColor];
    selectView.clipsToBounds = YES;
    
//    UIButton *firstBtn = [UIButton new];
//    firstBtn.frame = CGRectMake(0, 0, self.view.width / 3, selectView.height);
//    firstBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
//    [firstBtn setTitle:@"先词后曲" forState:UIControlStateNormal];
//    [firstBtn setTitleColor:[UIColor colorWithHexString:@"FFDC74"] forState:UIControlStateNormal];
//    [firstBtn addTarget:selectView action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [selectView addSubview:firstBtn];
//    
//    UIButton *secondBtn = [UIButton new];
//    secondBtn.frame = CGRectMake(0, 0, self.view.width / 3, selectView.height);
//    secondBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
//    [secondBtn setTitle:@"先词后曲" forState:UIControlStateNormal];
//    [secondBtn setTitleColor:[UIColor colorWithHexString:@"FFDC74"] forState:UIControlStateNormal];
//    [secondBtn addTarget:secondBtn action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    [selectView addSubview:secondBtn];
//    
//    UIButton *thirdBtn = [UIButton new];
//    thirdBtn.frame = CGRectMake(0, 0, self.view.width / 3, selectView.height);
//    thirdBtn.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
//    [thirdBtn setTitle:@"先词后曲" forState:UIControlStateNormal];
//    [thirdBtn setTitleColor:[UIColor colorWithHexString:@"FFDC74"] forState:UIControlStateNormal];
//    [selectView addSubview:thirdBtn];
//    
//    self.selectOneLabel = firstBtn.titleLabel;
//    
//    self.selectTwoLabel = secondBtn.titleLabel;
    
    self.tagView = [[UIView alloc] initWithFrame:selectView.bounds];
    [selectView addSubview:self.tagView];
    
    CGFloat width1 = [AXGTools getTextWidth:@"先词后曲" font:JIACU_FONT(15)];
    
    self.selectOneLabel = [[UILabel alloc] initWithFrame:CGRectMake(50 * WIDTH_NIT, 0, width1, selectView.height)];
    [selectView addSubview:self.selectOneLabel];
    self.selectOneLabel.text = @"先词后曲";
    self.selectOneLabel.textColor = HexStringColor(@"#FFDC74");
    self.selectOneLabel.font = JIACU_FONT(15);
    
    self.btnOne = [UIButton new];
    [selectView addSubview:self.btnOne];
    self.btnOne.frame = CGRectMake(0, 0, selectView.width / 3, selectView.height);
    self.btnOne.backgroundColor = [UIColor clearColor];
    [self.btnOne addTarget:self action:@selector(leftButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
    self.leftX = 50 * WIDTH_NIT + width1 / 2;
    
    self.selectTwoLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.selectOneLabel.right + 50*WIDTH_NIT, 0, width1, selectView.height)];
    self.selectTwoLabel.center = CGPointMake(self.view.width / 2, self.selectTwoLabel.centerY);
    [selectView addSubview:self.selectTwoLabel];
    self.selectTwoLabel.text = @"先曲后词";
    self.selectTwoLabel.textColor = HexStringColor(@"#A0A0A0");
    self.selectTwoLabel.font = NORML_FONT(15);
    self.selectTwoLabel.textAlignment = NSTextAlignmentRight;
    
    self.btnTwo = [UIButton new];
    [selectView addSubview:self.btnTwo];
    self.btnTwo.frame = CGRectMake(selectView.width / 3, 0, selectView.width / 3, selectView.height);
    self.btnTwo.backgroundColor = [UIColor clearColor];
    [self.btnTwo addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.rightX = self.selectTwoLabel.centerX;
    
    
    self.selectThreeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - width1 - 50 * WIDTH_NIT, 0, width1, selectView.height)];
    [selectView addSubview:self.selectThreeLabel];
    self.selectThreeLabel.text = @"人声录音";
    self.selectThreeLabel.textColor = HexStringColor(@"#A0A0A0");
    self.selectThreeLabel.font = NORML_FONT(15);
    self.selectThreeLabel.textAlignment = NSTextAlignmentRight;
    
    self.btnThree = [UIButton new];
    [selectView addSubview:self.btnThree];
    self.btnThree.frame = CGRectMake(selectView.width / 3 * 2, 0, selectView.width / 3, selectView.height);
    self.btnThree.backgroundColor = [UIColor clearColor];
    [self.btnThree addTarget:self action:@selector(threeBtnAction:) forControlEvents:UIControlEventTouchUpInside];
    self.threeX = self.selectThreeLabel.centerY;
    
    
    CGFloat halfWidth = self.view.width - self.leftX;
    halfWidth = halfWidth * 3 / 2;
    self.tagView.frame = CGRectMake(0, 0, halfWidth * 2, selectView.height);
    self.tagView.center = CGPointMake(self.leftX, self.tagView.centerY);
    
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
    
}

// 创建tableview
- (void)createTableView {
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.scrollView];
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.contentSize = CGSizeMake(self.view.width * 3, self.view.height);
    self.scrollView.pagingEnabled = YES;
    self.scrollView.scrollEnabled = NO;
    self.scrollView.delegate = self;
    
    self.lineView = [[UIView alloc] initWithFrame:CGRectMake(20 * WIDTH_NIT, 0, 0.5, 667 * WIDTH_NIT)];
    [self.scrollView addSubview:self.lineView];
    self.lineView.backgroundColor = HexStringColor(@"#ffffff");
    
    self.lineView2 = [[UIView alloc] initWithFrame:CGRectMake(20 * WIDTH_NIT + self.view.width, 0, 0.5, 667 * WIDTH_NIT)];
    [self.scrollView addSubview:self.lineView2];
    self.lineView2.backgroundColor = HexStringColor(@"#ffffff");
    
    [self createNoDataView];
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.tableView];
    self.tableView.delegate = self.delegate;
    self.tableView.dataSource = self.delegate;
    self.delegate.identifier = identifier;
    self.tableView.tableHeaderView = [self getHeadView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[DraftsTableViewCell class] forCellReuseIdentifier:identifier];
    
    self.tableView2 = [[UITableView alloc] initWithFrame:CGRectMake(self.view.width, 64, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView2.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.tableView2];
    self.tableView2.delegate = self.delegate2;
    self.tableView2.dataSource = self.delegate2;
    self.tableView2.tableHeaderView = [self getHeadView];
    self.delegate2.identifier = secondIdentifier;

    self.tableView2.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView2 registerClass:[DraftsTableViewCell class] forCellReuseIdentifier:secondIdentifier];
    
    
    self.tableView3 = [[UITableView alloc] initWithFrame:CGRectMake(self.view.width * 2, 64, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView3.backgroundColor = [UIColor clearColor];
    [self.scrollView addSubview:self.tableView3];
    self.tableView3.delegate = self.delegate3;
    self.tableView3.dataSource = self.delegate3;
    self.tableView3.tableHeaderView = [self getHeadView];
    self.delegate3.identifier = thirdIdentifier;
    
    self.tableView3.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView3 registerClass:[DraftsTableViewCell class] forCellReuseIdentifier:thirdIdentifier];
}

- (UIView *)getHeadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50 * WIDTH_NIT)];
    [self.view addSubview:view];
    view.backgroundColor = [UIColor clearColor];
    
//    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(20 * WIDTH_NIT, 0, 0.5, 20 * WIDTH_NIT)];
//    [view addSubview:lineView];
//    lineView.backgroundColor = HexStringColor(@"#879999");
    
    return view;
}

- (void)createNoDataView {
    
    self.noDataImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 + 105 * HEIGHT_NIT + 50 * WIDTH_NIT, 168.5 * WIDTH_NIT, 216 * WIDTH_NIT)];
    self.noDataImage.center = CGPointMake(self.view.width / 2, self.noDataImage.centerY);
    self.noDataImage.image = [UIImage imageNamed:@"草稿空状态"];
    [self.scrollView addSubview:self.noDataImage];
    
    self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.noDataImage.left, self.noDataImage.bottom + 75 * HEIGHT_NIT, self.noDataImage.width, 30)];
    self.noDataLabel.text = @"还没有草稿哦";
    self.noDataLabel.textColor = HexStringColor(@"#a0a0a0");
    self.noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.noDataLabel];
    
    self.noDataImage.hidden = YES;
    self.noDataLabel.hidden = YES;
    self.lineView.hidden = NO;
    
    self.noDataImage2 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 + 105 * HEIGHT_NIT + 50 * WIDTH_NIT, 168.5 * WIDTH_NIT, 216 * WIDTH_NIT)];
    self.noDataImage2.center = CGPointMake(self.view.width / 2 + self.view.width, self.noDataImage2.centerY);
    self.noDataImage2.image = [UIImage imageNamed:@"草稿空状态"];
    [self.scrollView addSubview:self.noDataImage2];
    
    self.noDataLabel2 = [[UILabel alloc] initWithFrame:CGRectMake(self.noDataImage2.left, self.noDataImage2.bottom + 75 * HEIGHT_NIT, self.noDataImage2.width, 30)];
    self.noDataLabel2.text = @"还没有草稿哦";
    self.noDataLabel2.textColor = HexStringColor(@"#a0a0a0");
    self.noDataLabel2.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.noDataLabel2];
    
    self.noDataImage2.hidden = YES;
    self.noDataLabel2.hidden = YES;
    self.lineView2.hidden = NO;
    
    
    
    self.noDataImage3 = [[UIImageView alloc] initWithFrame:CGRectMake(0, 64 + 105 * HEIGHT_NIT + 50 * WIDTH_NIT, 168.5 * WIDTH_NIT, 216 * WIDTH_NIT)];
    self.noDataImage3.center = CGPointMake(self.view.width / 2 + self.view.width * 2, self.noDataImage2.centerY);
    self.noDataImage3.image = [UIImage imageNamed:@"草稿空状态"];
    [self.scrollView addSubview:self.noDataImage3];
    
    self.noDataLabel3 = [[UILabel alloc] initWithFrame:CGRectMake(self.noDataImage3.left, self.noDataImage3.bottom + 75 * HEIGHT_NIT, self.noDataImage3.width, 30)];
    self.noDataLabel3.text = @"还没有草稿哦";
    self.noDataLabel3.textColor = HexStringColor(@"#a0a0a0");
    self.noDataLabel3.textAlignment = NSTextAlignmentCenter;
    [self.scrollView addSubview:self.noDataLabel3];
    
    self.noDataImage3.hidden = YES;
    self.noDataLabel3.hidden = YES;
    self.lineView3.hidden = NO;

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

#pragma mark - Action
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

- (void)threeBtnAction:(UIButton *)sender {
    self.selectThreeLabel.font = JIACU_FONT(15);
    self.selectThreeLabel.textColor = HexStringColor(@"#FFDC74");
    
    
    
    self.selectOneLabel.font = NORML_FONT(15);
    self.selectOneLabel.textColor = HexStringColor(@"#A0A0A0");
    
    self.selectTwoLabel.font = NORML_FONT(15);
    self.selectTwoLabel.textColor = HexStringColor(@"#A0A0A0");
    
    //    self.tagView.center = CGPointMake(_leftX, self.tagView.centerY);
    
    [self.scrollView setContentOffset:CGPointMake(self.view.width * 2, 0) animated:YES];

}

// 左边按钮方法
- (void)leftButtonAction:(UIButton *)sender {
    
    self.selectOneLabel.font = JIACU_FONT(15);
    self.selectOneLabel.textColor = HexStringColor(@"#FFDC74");
    
    self.selectTwoLabel.font = NORML_FONT(15);
    self.selectTwoLabel.textColor = HexStringColor(@"#A0A0A0");
    
    self.selectThreeLabel.font = NORML_FONT(15);
    self.selectThreeLabel.textColor = HexStringColor(@"#A0A0A0");
//    self.tagView.center = CGPointMake(_leftX, self.tagView.centerY);
    
    [self.scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
    
}

// 右边按钮方法
- (void)rightButtonAction:(UIButton *)sender {
    self.selectOneLabel.font = NORML_FONT(15);
    self.selectOneLabel.textColor = HexStringColor(@"#A0A0A0");
    self.selectTwoLabel.font = JIACU_FONT(15);
    self.selectTwoLabel.textColor = HexStringColor(@"#FFDC74");
    
    self.selectThreeLabel.font = NORML_FONT(15);
    self.selectThreeLabel.textColor = HexStringColor(@"#A0A0A0");
//    self.tagView.center = CGPointMake(_rightX, self.tagView.centerY);
    
    [self.scrollView setContentOffset:CGPointMake(self.view.width, 0) animated:YES];
}

- (void)getData {
    
    [self.dataSource removeAllObjects];
    
        YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:DB_NAME];
        NSArray *dataSource = [store getAllItemsFromTable:TABLE_NAME];
        
        for (int i = (int)dataSource.count - 1; i >= 0; i--) {
            YTKKeyValueItem *item = dataSource[i];
            NSDictionary *dic = item.itemObject;
            //        NSString *preContent = dic[@"content"];
            //        NSString *content = [preContent stringByReplacingOccurrencesOfString:@"/" withString:@","];
            //
            //        NSDictionary *dicc = @{@"title":dic[@"title"], @"content":content, @"saveTime":dic[@"saveTime"], @"line":dic[@"line"]};
            //
            //        NSLog(@"%@", dicc);
            
            [self.dataSource addObject:dic];
        }
        
        self.delegate.dataSource = self.dataSource;
        
        [self.tableView reloadData];
        
        if (dataSource.count != 0) {
            self.noDataImage.hidden = YES;
            self.noDataLabel.hidden = YES;
            self.lineView.hidden = NO;
        } else {
            self.noDataImage.hidden = NO;
            self.noDataLabel.hidden = NO;
            self.lineView.hidden = YES;
        }
        

        
        [self.dataSource2 removeAllObjects];
        
        YTKKeyValueStore *store2 = [[YTKKeyValueStore alloc] initDBWithName:DB_NAME];
        NSArray *dataSource2 = [store2 getAllItemsFromTable:TIANCI_DB];
        
        for (int i = (int)dataSource2.count - 1; i >= 0; i--) {
            YTKKeyValueItem *item = dataSource2[i];
            NSDictionary *dic = item.itemObject;
            [self.dataSource2 addObject:dic];
        }
        
        self.delegate2.dataSource = self.dataSource2;
        
        [self.tableView2 reloadData];
        
        if (dataSource2.count != 0) {
            self.noDataImage2.hidden = YES;
            self.noDataLabel2.hidden = YES;
            self.lineView2.hidden = NO;
        } else {
            self.noDataImage2.hidden = NO;
            self.noDataLabel2.hidden = NO;
            self.lineView2.hidden = YES;
        }
        
        
        
        [self.dataSource3 removeAllObjects];
        YTKKeyValueStore *store3 = [[YTKKeyValueStore alloc] initDBWithName:DB_NAME];
        NSArray *dataSource3 = [store3 getAllItemsFromTable:RECODER_DB];
        for (int i = (int)dataSource3.count - 1; i >= 0; i--) {
            YTKKeyValueItem *item = dataSource3[i];
            NSDictionary *dic = item.itemObject;
            [self.dataSource3 addObject:dic];
        }
        self.delegate3.dataSource = self.dataSource3;
        [self.tableView3 reloadData];
        if (dataSource3.count != 0) {
            self.noDataImage3.hidden = YES;
            self.noDataLabel3.hidden = YES;
            self.lineView3.hidden = NO;
        } else {
            self.noDataImage3.hidden = NO;
            self.noDataLabel3.hidden = NO;
            self.lineView3.hidden = YES;
        }
    if (self.dataSource.count > 0) {
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        [self performSelectorOnMainThread:@selector(cellEditing:) withObject:nil waitUntilDone:NO];
//            [cell setEditing:YES animated:YES];
//        });
    }
}

- (void)cellEditing:(DraftsTableViewCell *)cell {
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:0 inSection:0];
    DraftsTableViewCell *cell1 = [self.tableView cellForRowAtIndexPath:indexPath];
    [cell1 setEditing:YES animated:YES];
}

- (NSMutableArray *)dataSource3 {
    if (_dataSource3 == nil) {
        _dataSource3 = [NSMutableArray array];
    }
    return _dataSource3;
}

// 手势打开抽屉
- (void)edgePanAction {
    [self backButtonAction:nil];
}

- (void)backButtonAction:(UIButton *)sender {
    
    [self presentDrawer];
    
}

- (void)presentDrawer {
    
    KYDrawerController *drawerVC = (KYDrawerController *)self.navigationController.parentViewController;
    
    [drawerVC setDrawerState:DrawerStateOpened animated:YES];
    
//    [self.mm_drawerController
//     openDrawerSide:MMDrawerSideLeft
//     animated:YES
//     completion:^(BOOL finished) {
//         
//     }];
}


#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DraftsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (self.dataSource.count > indexPath.row) {
        cell.dataSource = [self.dataSource[indexPath.row] copy];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106 * WIDTH_NIT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    DraftsTableViewCell *cell = (DraftsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    AppDelegate *app = [[UIApplication sharedApplication] delegate];
    app.originSongName = @"";
    
    XieciViewController *xieciVC = [[XieciViewController alloc] init];
    xieciVC.lineFromDrafts = cell.lineNumber;
    xieciVC.contentFromDrafts = cell.contentLabel.text;
    xieciVC.titleFromDrafts = cell.titleLabel.text;
    
    NSLog(@"%@", cell.contentLabel.text);
    
    [self.navigationController pushViewController:xieciVC animated:YES];
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        DraftsTableViewCell *cell = (DraftsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        NSDictionary *dic = cell.dataSource;
        
        [self.dataSource removeObject:dic];
        
        YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:DB_NAME];
        [store deleteObjectById:dic[@"saveTime"] fromTable:TABLE_NAME];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        if (self.dataSource.count == 0) {
            self.noDataLabel.hidden = NO;
            self.noDataImage.hidden = NO;
        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

#pragma mark - UIScrollDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.scrollView) {
        self.tagView.center = CGPointMake(_leftX + (_rightX - _leftX) * scrollView.contentOffset.x / self.view.width, self.tagView.centerY);
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
