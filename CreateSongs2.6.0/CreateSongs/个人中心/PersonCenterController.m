//
//  PersonCenterController.m
//  CreateSongs
//
//  Created by axg on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PersonCenterController.h"
#import "OtherPersonCenterController.h"
#import "SettingViewController.h"
//#import "UIViewController+MMDrawerController.h"
#import "PlayUserSongViewController.h"
#import "NSString+Common.h"
#import "AppDelegate.h"
#import "NSArray+Common.h"
#import "AXGMessage.h"
#import "CreateSongs-Swift.h"
//#import "KYDrawerController.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "EMSDK.h"


@interface PersonCenterController ()<UINavigationControllerDelegate, UIGestureRecognizerDelegate, UIImagePickerControllerDelegate>

@property (nonatomic, strong) UIImage *avatar;

@property (nonatomic, strong) UIView *editView;

@property (nonatomic, strong) UIView *centerView;

@property (nonatomic, strong) UIImageView *preImageView;

// 记录缩放大小
@property (nonatomic, assign) CGFloat lastScale;

// 记录旋转角度
@property (nonatomic, assign) CGFloat lastRotation;

// 记录X坐标
@property (nonatomic, assign) CGFloat firstX;

// 记录Y坐标
@property (nonatomic, assign) CGFloat firstY;
// 是否去重(去重会导致数组无序 所以只进行一次)
@property (nonatomic, assign) BOOL shouldRemoveSameData;

@property (nonatomic, assign) CGAffineTransform transform;

@property (nonatomic, strong) UIView *msgView;

@end

@implementation PersonCenterController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (instancetype)initWIthUserId:(NSString *)userId {
    self = [super init];
    if (self) {
        self.userId = userId;
        self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        if (kDevice_Is_iPad || kDevice_Is_iPad3 || kDevice_Is_iPhone4) {
            self.height = 60 * HEIGHT_NIT;
        } else {
            self.height = 0;
        }
        self.enterRefresh = NO;
    }
    return self;
}


- (instancetype)init {
    self = [super init];
    if (self) {
        self.view.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        if (kDevice_Is_iPad || kDevice_Is_iPad3 || kDevice_Is_iPhone4) {
            self.height = 60 * HEIGHT_NIT;
        } else {
            self.height = 0;
        }
        self.enterRefresh = NO;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    self.shouldRemoveSameData = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:IS_TEST_NO forKey:IS_TEST];
    
    [self createHeadView];
    [self initDelegate];
    
    self.isFocus = NO;
    self.focusBtn.hidden = YES;
    self.sixinButton.hidden = YES;
    [self createWorkCollection];
    [self createLikeCollection];
    [self createFocusTable];
    [self createFollowTable];
    [self createNavView];
//    [self createNavView2];
//    self.navView2.hidden = YES;
    [self updatePersonInfo];
    [self getDataForCollectionView:self.worksCollectionView
                            withiD:[self getUserId]
                    withDataSource:self.dataSourceWorks];

    [self getDataForLikeFromDataBase];
    [self getDataForTableView:self.focusTableView];
    [self getDataForTableView:self.followTableView];
    
    [self createEditView];
    
    [self createEdgePanView];
    
    [self createMsgView];
    
    [self reloadMsg];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(backButtonAction:)
//                                                 name:@"loginBackToPersonCenter"
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(popPersonCenterAction)
//                                                 name:@"popPersonCenter"
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updatePersonInfo)
//                                                 name:@"updatePersonInfo"
//                                               object:nil];
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(loginAndRefreshInfo:)
//                                                 name:@"loginAndRefreshInfo"
//                                               object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
//    self.xieciImage.hidden = YES;
//    self.xieciLabel.hidden = YES;
//    self.xieciButton.hidden = YES;
    
    self.favorImage.hidden = YES;
    self.favorButton.hidden = YES;
    self.favorLabel.hidden = YES;
    
    self.focusNoLabel.hidden = YES;
    self.focusNoImage.hidden = YES;
    
    self.followNoLabel.hidden = YES;
    self.followNoImage.hidden = YES;
    
    [[NSUserDefaults standardUserDefaults] setObject:@"personCenter" forKey:@"isPersonCenter"];
    // 从前一页进入不用刷新
    if (self.enterRefresh) {
        // 进到该页面刷新页面数据
        [self updatePersonInfo];
        [self getDataForCollectionView:self.worksCollectionView
                                withiD:[self getUserId]
                        withDataSource:self.dataSourceWorks];
        [self getDataForLikeFromDataBase];
        [self getDataForTableView:self.focusTableView];
        [self getDataForTableView:self.followTableView];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [[NSUserDefaults standardUserDefaults] setObject:@"notPersonCenter"
                                              forKey:@"isPersonCenter"];
//    self.shouldRemoveSameData = NO;
    self.enterRefresh = YES;
}
// 跳转到播放页面
- (void)turnToPlayController:(HomePageCollectionViewCell *)cell index:(NSInteger)index{
    
    /**
     self.lyricURL = @"http://service.woyaoxiege.com/music/lrc/f5a13eca90cbe22dd8a3c412e941e61e_6.lrc";
     self.soundURL = @"http://service.woyaoxiege.com/music/mp3/f5a13eca90cbe22dd8a3c412e941e61e_6.mp3";
     
     self.soundName = @"七夕";
     self.user_id = @"20590";
     
     self.listenCount = 1234;
     
     self.createTimeStr = @"2016-07-16 19:14:27";
     
     self.loveCount = @"4321";
     
     self.song_id = @"22958";
     self.needReload = YES;
     self.songCode = @"f5a13eca90cbe22dd8a3c412e941e61e_6";
     */
    
    PlayUserSongViewController *pvc = [PlayUserSongViewController new];
//    pvc.user_id = cell.dataModel.user_id;
//    pvc.soundName = cell.title.text;
//    pvc.listenCount = [cell.dataModel.play_count integerValue];
//    pvc.loveCount = cell.dataModel.up_count;
//    pvc.createTimeStr = cell.dataModel.create_time;
//    pvc.song_id = cell.dataModel.dataId;
    pvc.songCode = cell.dataModel.code;
//    pvc.themeImageView.image = cell.themeImage.image;
//    
//    [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_PLAYCOUNT, pvc.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
    
    [self.navigationController pushViewController:pvc animated:YES];
}
- (void)resetNavView {
    CGRect frame1 = self.navView.frame;
    CGRect frame2 = self.bottomView.frame;
    
    frame1.origin.y = 0;
    frame2.origin.y = 0;
    
    self.navView.frame = frame1;
    self.bottomView.frame = frame2;
}

- (void)changeNaviOffset:(CGFloat)offset {
    
    
    CGFloat gap = offset - self.tmpOffsetY;
    
    CGRect frame1 = self.navView.frame;
    CGRect frame2 = self.bottomView.frame;
    
    
    frame1.origin.y -= gap;
    frame2.origin.y -= gap;
    
    if (frame1.origin.y > 0) {
        frame1.origin.y = 0;
    }
    if (frame1.origin.y < -self.navView.height) {
        frame1.origin.y = -self.navView.height;
    }
    
    if (frame2.origin.y > 0) {
        frame2.origin.y = 0;
    }
    if (frame2.origin.y < -self.bottomView.height) {
        frame2.origin.y = -self.bottomView.height;
    }
    
    self.navView.frame = frame1;
    self.bottomView.frame = frame2;
}
// 头视图动画
- (void)changeHead:(CGFloat)contentOffsetY {

    self.infoHeadView.frame = CGRectMake(self.infoHeadView.left, -contentOffsetY, self.infoHeadView.width, self.infoHeadView.height);
    
    if (contentOffsetY >= 0) {
        self.wallView.frame = CGRectMake(self.wallView.left, -contentOffsetY, self.wallView.width, self.wallView.height);
    } else {
        self.wallView.frame = CGRectMake(0, 0, self.wallView.width, HEAD_HEIGHT - contentOffsetY);
    }

    CGFloat offsetY = contentOffsetY;

    
    if (offsetY == 0) {
        [self resetNavView];
    } else if (self.shouldHideNav){
        [self changeNaviOffset:offsetY];
    }
    self.tmpOffsetY = offsetY;

    if (contentOffsetY > 200-64) {
        contentOffsetY = 200-64;
    }
    self.bottomView.alpha = (contentOffsetY / (200-64));
}
/**
 *  初始化代理
 */
- (void)initDelegate {
    self.collectionDelegate1 = [PersonCollectionDelegate new];
    self.collectionDelegate1.head_height = self.head_Height;
    
    self.collectionDelegate2 = [PersonCollectionDelegate new];
    self.collectionDelegate2.head_height = self.head_Height;
    
    self.tableDelegate1 = [PersonTableDelegate new];
    self.tableDelegate1.head_height = self.head_Height;
    
    self.tableDelegate2 = [PersonTableDelegate new];
    self.tableDelegate2.head_height = self.head_Height;
    
    WEAK_SELF;
    self.collectionDelegate1.collectionSelectBlock = ^(NSInteger index, HomePageCollectionViewCell *cell) {
        STRONG_SELF;
        [self turnToPlayController:cell index:index];
    };
    
    self.collectionDelegate1.collectionContentOffsetBlock = ^(CGFloat contentOffsetY) {
        STRONG_SELF;
        [self changeHead:contentOffsetY];
    };
    
    
    self.collectionDelegate1.collectionSelectTypeBlock = ^(NSInteger index) {
        STRONG_SELF;
        [self selectPageWithIndex:index];
    };
    
    self.collectionDelegate1.collectionModifyUserInfoBlock = ^ {
//        STRONG_SELF;
        //        [self enterUserInfo];
    };
    
    self.collectionDelegate1.collectionMoreButtonBlock = ^(NSString *code, NSString *title) {
        STRONG_SELF;
        [self moreActionWithCode:code title:title];
    };
    
    self.collectionDelegate2.collectionSelectBlock = ^(NSInteger index, HomePageCollectionViewCell *cell) {
        STRONG_SELF;
        
        [self turnToPlayController:cell index:index];
    };
    
    self.collectionDelegate2.collectionContentOffsetBlock = ^(CGFloat contentOffsetY) {
        STRONG_SELF;
        [self changeHead:contentOffsetY];
    };
    
    self.collectionDelegate2.collectionSelectTypeBlock = ^(NSInteger index) {
        STRONG_SELF;
        [self selectPageWithIndex:index];
    };
    
    self.collectionDelegate2.collectionModifyUserInfoBlock = ^ {
//        STRONG_SELF;
        //        [self enterUserInfo];
    };
    
    self.tableDelegate1.tableSelectBlock = ^(NSInteger index, FocusTableViewCell *cell) {
        STRONG_SELF;
        [self turnToUserPage:cell index:index];
    };
    
    self.tableDelegate1.tableSelectTypeBlock = ^(NSInteger index) {
        STRONG_SELF;
        [self selectPageWithIndex:index];
    };
    
    self.tableDelegate1.tableContentOffsetBlock = ^(CGFloat contentOffsetY) {
        STRONG_SELF;
        [self changeHead:contentOffsetY];
    };
    
       
    self.tableDelegate2.tableSelectBlock = ^(NSInteger index, FocusTableViewCell *cell) {
        STRONG_SELF;
        [self turnToUserPage:cell index:index];
    };
    
    self.tableDelegate2.tableSelectTypeBlock = ^(NSInteger index) {
        STRONG_SELF;
        [self selectPageWithIndex:index];
    };
    
    self.tableDelegate2.tableContentOffsetBlock = ^(CGFloat contentOffsetY) {
        STRONG_SELF;
        [self changeHead:contentOffsetY];
    };
    
    
    self.collectionDelegate1.collectionBeginDrag = ^{
        STRONG_SELF;
        self.shouldHideNav = YES;
    };
    self.collectionDelegate1.collectionEndDrag = ^{
        STRONG_SELF;
        self.shouldHideNav = NO;

    };
    self.collectionDelegate2.collectionBeginDrag = ^{
        STRONG_SELF;
        self.shouldHideNav = YES;
    };
    self.collectionDelegate2.collectionEndDrag = ^{
        STRONG_SELF;
        self.shouldHideNav = NO;

    };
    
    self.tableDelegate1.tableBeginDrag = ^{
        STRONG_SELF;
        self.shouldHideNav = YES;
    };
    self.tableDelegate1.tableEndDrag = ^{
        STRONG_SELF;
        self.shouldHideNav = NO;

    };
    self.tableDelegate2.tableBeginDrag = ^{
        STRONG_SELF;
        self.shouldHideNav = YES;
    };
    self.tableDelegate2.tableEndDrag = ^{
        STRONG_SELF;
        self.shouldHideNav = NO;
    };
    
    self.collectionDelegate1.collectionFocusBlock = ^ {
        STRONG_SELF;
        [self focusButtonAction:nil];
    };
    self.collectionDelegate1.showHeadImageBlock = ^ {
        STRONG_SELF;
        [self clickHeadImage];
    };

    self.collectionDelegate2.collectionFocusBlock = ^ {
        STRONG_SELF;
        [self focusButtonAction:nil];
    };
    self.collectionDelegate2.showHeadImageBlock = ^ {
        STRONG_SELF;
        [self clickHeadImage];
    };


    self.tableDelegate1.showHeadImageBlock = ^ {
        STRONG_SELF;
        [self clickHeadImage];
    };
    self.tableDelegate2.showHeadImageBlock = ^ {
        STRONG_SELF;
        [self clickHeadImage];
    };
    self.tableDelegate1.tableModifyUserInfoBlock = ^ {
        //        STRONG_SELF;
        //        [self enterUserInfo];
    };
    self.tableDelegate2.tableModifyUserInfoBlock = ^ {
        //        STRONG_SELF;
        //        [self enterUserInfo];
    };
    self.tableDelegate1.tableFocusBlock = ^ {
        STRONG_SELF;
        [self focusButtonAction:nil];
    };
    self.tableDelegate2.tableFocusBlock = ^ {
        STRONG_SELF;
        [self focusButtonAction:nil];
    };
    
    self.collectionDelegate1.sixinButtonBlock = ^ {
        STRONG_SELF;
        [self otherSixinButtonAction];
    };
    
    self.collectionDelegate2.sixinButtonBlock = ^ {
        STRONG_SELF;
        [self otherSixinButtonAction];
    };
    
    self.tableDelegate1.sixinButtonBlock = ^ {
        STRONG_SELF;
        [self otherSixinButtonAction];
    };
    
    self.tableDelegate2.sixinButtonBlock = ^ {
        STRONG_SELF;
        [self otherSixinButtonAction];
    };
    
}

// 创建打开手势界面
- (void)createEdgePanView {
    self.panView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 20, self.view.height - 64)];
    //    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.panView];
    
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(edgePanAction)];
    edgePan.edges = UIRectEdgeLeft;
    [self.panView addGestureRecognizer:edgePan];
}

// 手势打开抽屉
- (void)edgePanAction {
    
    KYDrawerController *drawerVC = (KYDrawerController *)self.navigationController.parentViewController;
    
    [drawerVC setDrawerState:DrawerStateOpened animated:YES];
    
//    [self.mm_drawerController
//     openDrawerSide:MMDrawerSideLeft
//     animated:YES
//     completion:^(BOOL finished) {
//         
//     }];
}

// 创建消息小红点
- (void)createMsgView {
    self.msgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 7.5, 7.5)];
    self.msgView.center = CGPointMake(16 + 23 - 3.75, 42 + 10 - 3.75);
    [self.navView addSubview:self.msgView];
    self.msgView.layer.cornerRadius = self.msgView.height / 2;
    self.msgView.layer.masksToBounds = YES;
    self.msgView.backgroundColor = HexStringColor(@"#cc2424");
    self.msgView.hidden = YES;
}

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

#pragma mark - 切换栏目
// 选择作品或者喜欢
- (void)selectPageWithIndex:(NSInteger)index {
    self.selectedIndex = index;
    CGFloat animatDuration = 0.5;
    // 头部视图回到最初位置
    self.wallView.frame = CGRectMake(0, 0, self.view.width, HEAD_HEIGHT);
    self.infoHeadView.center = self.infoHeadViewPoint;
    [self resetNavView];
    self.navView2.alpha = 0.0f;
    self.navView.alpha = 1.0f;
    if (index == 0) {
        // 隐藏喜欢
        self.likeCollectionView.hidden = YES;
        self.favorLabel.hidden = YES;
        self.favorButton.hidden = YES;
        self.favorImage.hidden = YES;
        
        // 隐藏关注
        self.focusTableView.hidden = YES;
        self.focusNoImage.hidden = YES;
        self.focusNoLabel.hidden = YES;
        
        // 隐藏粉丝
        self.followTableView.hidden = YES;
        self.followNoImage.hidden = YES;
        self.followNoLabel.hidden = YES;
        
        // 展示作品
        self.worksCollectionView.contentOffset = CGPointMake(self.worksCollectionView.contentOffset.x, 0);
        self.worksCollectionView.hidden = NO;
        if (self.collectionDelegate1.dataSource.count == 0) {
            self.xieciButton.hidden = NO;
            self.xieciLabel.hidden = NO;
            self.xieciImage.hidden = NO;
        } else {
            self.xieciButton.hidden = YES;
            self.xieciLabel.hidden = YES;
            self.xieciImage.hidden = YES;
        }
        
        self.worksLabel.font = JIACU_FONT(15);
        self.worksCount.font = JIACU_FONT(12);
        self.likeLabel.font = NORML_FONT(15);
        self.likeCount.font = NORML_FONT(12);
        self.focusLabel.font = NORML_FONT(15);
        self.focusCount.font = NORML_FONT(12);
        self.followLabel.font = NORML_FONT(15);
        self.followCount.font = NORML_FONT(12);
        
        self.worksLabel.textColor = HexStringColor(@"#441D11");
        self.worksCount.textColor = HexStringColor(@"#441D11");
        self.likeLabel.textColor = HexStringColor(@"#A0A0A0");
        self.likeCount.textColor = HexStringColor(@"#A0A0A0");
        self.focusCount.textColor = HexStringColor(@"#A0A0A0");
        self.focusLabel.textColor = HexStringColor(@"#A0A0A0");
        self.followCount.textColor = HexStringColor(@"#A0A0A0");
        self.followLabel.textColor = HexStringColor(@"#A0A0A0");
        
        [UIView animateWithDuration:animatDuration animations:^{
            self.moveLabel.center = CGPointMake(self.worksCount.centerX, self.moveLabel.centerY);
        }];
        
    } else if (index == 1) {
        
        // 展示喜欢
        self.likeCollectionView.contentOffset = CGPointMake(self.likeCollectionView.contentOffset.x, 0);
        self.likeCollectionView.hidden = NO;
        if (self.collectionDelegate2.dataSource.count == 0) {
            self.favorImage.hidden = NO;
            self.favorButton.hidden = NO;
            self.favorLabel.hidden = NO;
        } else {
            self.favorImage.hidden = YES;
            self.favorButton.hidden = YES;
            self.favorLabel.hidden = YES;
        }
        
        // 隐藏作品
        self.worksCollectionView.hidden = YES;
        self.xieciImage.hidden = YES;
        self.xieciLabel.hidden = YES;
        self.xieciButton.hidden = YES;
        
        // 隐藏关注
        self.focusTableView.hidden = YES;
        self.focusNoLabel.hidden = YES;
        self.focusNoImage.hidden = YES;
        
        // 隐藏粉丝
        self.followTableView.hidden = YES;
        self.followNoLabel.hidden = YES;
        self.followNoImage.hidden = YES;

        self.worksLabel.font = NORML_FONT(15);
        self.worksCount.font = NORML_FONT(12);
        self.likeLabel.font = JIACU_FONT(15);
        self.likeCount.font = JIACU_FONT(12);
        self.focusLabel.font = NORML_FONT(15);
        self.focusCount.font = NORML_FONT(12);
        self.followLabel.font = NORML_FONT(15);
        self.followCount.font = NORML_FONT(12);
        
        self.worksLabel.textColor = HexStringColor(@"#A0A0A0");
        self.worksCount.textColor = HexStringColor(@"#A0A0A0");
        self.likeLabel.textColor = HexStringColor(@"#441D11");
        self.likeCount.textColor = HexStringColor(@"#441D11");
        self.focusCount.textColor = HexStringColor(@"#A0A0A0");
        self.focusLabel.textColor = HexStringColor(@"#A0A0A0");
        self.followCount.textColor = HexStringColor(@"#A0A0A0");
        self.followLabel.textColor = HexStringColor(@"#A0A0A0");
        
        [UIView animateWithDuration:animatDuration animations:^{
            self.moveLabel.center = CGPointMake(self.likeCount.centerX, self.moveLabel.centerY);
        }];
    } else if (index == 2) {
        // 隐藏作品
        self.worksCollectionView.hidden = YES;
        self.xieciImage.hidden = YES;
        self.xieciLabel.hidden = YES;
        self.xieciButton.hidden = YES;
        // 隐藏喜欢
        self.likeCollectionView.hidden = YES;
        self.favorLabel.hidden = YES;
        self.favorButton.hidden = YES;
        self.favorImage.hidden = YES;
        
        // 展示关注
        self.focusTableView.hidden = NO;
        
        if (self.tableDelegate1.dataSource.count != 0) {
            self.focusNoImage.hidden = YES;
            self.focusNoLabel.hidden = YES;
        } else {
            self.focusNoLabel.hidden = NO;
            self.focusNoImage.hidden = NO;
        }
        
        self.focusTableView.contentOffset = CGPointMake(self.focusTableView.contentOffset.x, 0);
        
        self.worksLabel.font = NORML_FONT(15);
        self.worksCount.font = NORML_FONT(12);
        self.likeLabel.font = NORML_FONT(15);
        self.likeCount.font = NORML_FONT(12);
        self.focusLabel.font = JIACU_FONT(15);
        self.focusCount.font = JIACU_FONT(12);
        self.followLabel.font = NORML_FONT(15);
        self.followCount.font = NORML_FONT(12);
        
        self.worksLabel.textColor = HexStringColor(@"#A0A0A0");
        self.worksCount.textColor = HexStringColor(@"#A0A0A0");
        self.likeLabel.textColor = HexStringColor(@"#A0A0A0");
        self.likeCount.textColor = HexStringColor(@"#A0A0A0");
        self.focusCount.textColor = HexStringColor(@"#441D11");
        self.focusLabel.textColor = HexStringColor(@"#441D11");
        self.followCount.textColor = HexStringColor(@"#A0A0A0");
        self.followLabel.textColor = HexStringColor(@"#A0A0A0");
        
        // 隐藏粉丝
        self.followTableView.hidden = YES;
        self.followNoImage.hidden = YES;
        self.followNoLabel.hidden = YES;
        
        
        [UIView animateWithDuration:animatDuration animations:^{
            self.moveLabel.center = CGPointMake(self.focusCount.centerX, self.moveLabel.centerY);
        }];
        
    } else {
        
        // 隐藏作品
        self.worksCollectionView.hidden = YES;
        self.xieciImage.hidden = YES;
        self.xieciLabel.hidden = YES;
        self.xieciButton.hidden = YES;
        
        // 隐藏喜欢
        self.likeCollectionView.hidden = YES;
        self.favorLabel.hidden = YES;
        self.favorButton.hidden = YES;
        self.favorImage.hidden = YES;
        
        // 隐藏关注
        self.focusTableView.hidden = YES;
        self.focusNoImage.hidden = YES;
        self.focusNoLabel.hidden = YES;
        
        // 展示粉丝
        self.followTableView.hidden = NO;
        
        if (self.tableDelegate2.dataSource.count != 0) {
            self.followNoLabel.hidden = YES;
            self.followNoImage.hidden = YES;
        } else {
            self.followNoImage.hidden = NO;
            self.followNoLabel.hidden = NO;
        }
        
        self.followTableView.contentOffset = CGPointMake(self.followTableView.contentOffset.x, 0);
    
        self.worksLabel.font = NORML_FONT(15);
        self.worksCount.font = NORML_FONT(12);
        self.likeLabel.font = NORML_FONT(15);
        self.likeCount.font = NORML_FONT(12);
        self.focusLabel.font = NORML_FONT(15);
        self.focusCount.font = NORML_FONT(12);
        self.followLabel.font = JIACU_FONT(15);
        self.followCount.font = JIACU_FONT(12);
        
        self.worksLabel.textColor = HexStringColor(@"#A0A0A0");
        self.worksCount.textColor = HexStringColor(@"#A0A0A0");
        self.likeLabel.textColor = HexStringColor(@"#A0A0A0");
        self.likeCount.textColor = HexStringColor(@"#A0A0A0");
        self.focusCount.textColor = HexStringColor(@"#A0A0A0");
        self.focusLabel.textColor = HexStringColor(@"#A0A0A0");
        self.followCount.textColor = HexStringColor(@"#441D11");
        self.followLabel.textColor = HexStringColor(@"#441D11");
        
        [UIView animateWithDuration:animatDuration animations:^{
            self.moveLabel.center = CGPointMake(self.followCount.centerX, self.moveLabel.centerY);
        }];
    }
}
//更多按钮方法
- (void)moreActionWithCode:(NSString *)code title:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    WEAK_SELF;
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF;
        [self delSongByCode:code title:title];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:delAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
// 删除歌曲
- (void)delSongByCode:(NSString *)code title:(NSString *)title {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:[NSString stringWithFormat:@"是否删除歌曲\n%@", title] message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    WEAK_SELF;
    UIAlertAction *delAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF;
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:DEL_BY_CODE, code] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                NSLog(@"删除成功");
                [self getDataForCollectionView:self.worksCollectionView withiD:[self getUserId] withDataSource:self.dataSourceWorks];
                [self.worksCollectionView reloadData];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }];
    
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    
    [alert addAction:delAction];
    [alert addAction:cancelAction];
    
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}
// 获取用户id
- (NSString *)getUserId {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
//    [wrapper setObject:@"2422" forKey:(id)kSecValueData];

    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    return userId;
}
// 获取collectionview数据
- (void)getDataForCollectionView:(UICollectionView *)collectionView withiD:(NSString *)userId withDataSource:(NSMutableArray *)dataSource {
    
    
    __weak typeof(self)weakSelf = self;
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_SONGS, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        
        HomePageModel *homePageModel = [[HomePageModel alloc] initWithDictionary:resposeObject error:nil];
        
        [dataSource removeAllObjects];
        
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            
            for (HomePageUserMess *userMess in homePageModel.songs) {
                [dataSource addObject:userMess];
            }
            NSArray *dataArray = nil;
//            if (self.shouldRemoveSameData) {
//                dataArray = [dataSource removeSameData];
//            } else {
                dataArray = [dataSource copy];
//            }
            if (collectionView == weakSelf.worksCollectionView) {
                self.collectionDelegate1.dataSource = [dataArray copy];
                
                self.worksCount.text = [NSString stringWithFormat:@"%ld", dataArray.count];
                
                if (self.collectionDelegate1.dataSource.count == 0) {
                    self.xieciImage.hidden = NO;
                    self.xieciLabel.hidden = NO;
                    self.xieciButton.hidden = NO;
                } else {
                    self.xieciImage.hidden = YES;
                    self.xieciLabel.hidden = YES;
                    self.xieciButton.hidden = YES;
                }
            }
//            else {
//                self.collectionDelegate2.dataSource = [dataArray copy];
//            }
            // 刷新
            [self.worksCollectionView reloadData];
            
        } else {
            NSLog(@"请求错误");
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"请求失败--%@", error.description);
    }];
}
- (void)turnToUserPage:(FocusTableViewCell *)cell index:(NSInteger)index {

    OtherPersonCenterController *personVC = [[OtherPersonCenterController alloc] initWIthUserId:cell.userId];

    [self.navigationController pushViewController:personVC animated:YES];
}


// 更新个人信息
- (void)updatePersonInfo {
    
//    NSString *account = [self getAccount];
    
//    NSString *accountImage = [NSString stringWithFormat:@"%@", [NSString md5HexDigest:account]];
    
    __weak typeof(self)weakSelf = self;
    
    NSString *userId = [self getUserId];
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        //     status 0 正常 -1 用户不存在 -2 查询出错
        NSLog(@" success %@", resposeObject);
        
        NSDictionary *dic = resposeObject;
        
        if ([dic[@"status"] isEqualToNumber:@0]) {
            
            
            NSString *nick = [dic[@"name"] emojizedString];
            
            weakSelf.nickName.text = nick;
            
            NSString *account = dic[@"phone"];
            
            NSString *accountImage = [NSString stringWithFormat:@"%@", [XWAFNetworkTool md5HexDigest:account]];
            //            weakSelf.headImage.image = image.image;
            
            //            NSLog(@"%@", [NSURL URLWithString:[NSString stringWithFormat:GET_USER_HEAD, accountImage]]);
            
            weakSelf.sixinImg = [NSString stringWithFormat:GET_USER_HEAD, accountImage];
            
            [weakSelf.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_USER_HEAD, accountImage]] placeholderImage:[UIImage imageNamed:@"头像"]];
            
            weakSelf.titleLabel.text = nick;
            weakSelf.titleLabel2.text = nick;
            
            weakSelf.sixinName = nick;
            
            if ([dic[@"gender"] isEqualToString:@"1"]) {
                self.genderImage.image = [UIImage imageNamed:@"male"];
            } else {
                self.genderImage.image = [UIImage imageNamed:@"female"];
            }
            
            id signature = resposeObject[@"signature"];
            if ([signature isKindOfClass:[NSNull class]]) {
                self.signature.text = EMPTY_SIGNATRUE;
            } else if ([signature isKindOfClass:[NSString class]]) {
                NSString *string = signature;
                if (string.length != 0) {
                    self.signature.text = string;
                } else {
                    self.signature.text = EMPTY_SIGNATRUE;
                }
            }
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.signature.text];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:15];
            [paragraphStyle setAlignment:NSTextAlignmentCenter];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.signature.text length])];
            self.signature.attributedText = attributedString;
        }

    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s--%@", __func__,error.description);
    }];
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *userId1 = [wrapper objectForKey:(id)kSecValueData];
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_FOCUS, userId1] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSArray *items = resposeObject[@"items"];
            
            [weakSelf isFocus:NO];
            weakSelf.isFocus = NO;
            
            for (NSDictionary *dic in items) {
                if ([dic[@"focus_id"] isEqualToString:userId]) {
                    [weakSelf isFocus:YES];
                    weakSelf.isFocus = YES;
                }
                weakSelf.focusBtn.enabled = YES;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
// 获取喜欢的歌
- (void)getDataForLikeFromDataBase {
    
    NSString *userId = [self getUserId];
    
    NSLog(@"%@", userId);
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_LIKE, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSArray *items = resposeObject[@"items"];
            
            [self.dataSourceLike removeAllObjects];
            for (NSDictionary *dic in items) {
                NSString *songId = dic[@"song_id"];
                
                HomePageUserMess *userMess = [[HomePageUserMess alloc] init];
                userMess.dataId = songId;
                userMess.user_id = dic[@"make_user_id"];
                userMess.code = dic[@"code"];
                userMess.is_recommended = dic[@"is_recommended"];
                userMess.create_time = dic[@"create_time"];
                userMess.modify_time = dic[@"modify_time"];
                userMess.play_count = dic[@"play_count"];
                userMess.cheat_count = dic[@"cheat_count"];
                userMess.up_count = dic[@"up_count"];
                
                if (![userMess.code isKindOfClass:[NSNull class]]) {
                    [self.dataSourceLike addObject:userMess];
                }
            }
            self.likeCount.text = [NSString stringWithFormat:@"%ld", self.dataSourceLike.count];
            
            self.collectionDelegate2.dataSource = self.dataSourceLike;
            
            if (self.collectionDelegate2.dataSource.count == 0 && self.selectedIndex == 1) {
                self.favorImage.hidden = NO;
                self.favorButton.hidden = NO;
                self.favorLabel.hidden = NO;
            } else {
                self.favorImage.hidden = YES;
                self.favorButton.hidden = YES;
                self.favorLabel.hidden = YES;
            }
            
            [self.likeCollectionView reloadData];
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

// 获取tableview数据
- (void)getDataForTableView:(UITableView *)tableView {
    
    NSString *userId = [self getUserId];
    
    if (tableView == self.focusTableView) {
        [self.dataSourceFocus removeAllObjects];
        
        WEAK_SELF;
        
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_FOCUS, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            
            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                NSArray *array = resposeObject[@"items"];
                for (NSDictionary *dic in array) {
                    NSString *focusId = dic[@"focus_id"];
                    [self.dataSourceFocus addObject:focusId];
                }
                NSArray *dataArray = nil;
//                if (self.shouldRemoveSameData) {
                    dataArray = [[self.dataSourceFocus removeSameData] copy];
//                } else {
//                    dataArray = [self.dataSourceFocus copy];
//                }
                [self.dataSourceFocus removeAllObjects];
                [self.dataSourceFocus addObjectsFromArray:dataArray];
                self.tableDelegate1.dataSource = self.dataSourceFocus;
                NSString *focusCount = [NSString stringWithFormat:@"%ld", self.dataSourceFocus.count];
                
                self.focusCount.text = focusCount;
                
                if (self.tableDelegate1.dataSource.count == 0 && self.selectedIndex == 2) {
                    self.focusNoLabel.hidden = NO;
                    self.focusNoImage.hidden = NO;
                } else {
                    self.focusNoImage.hidden = YES;
                    self.focusNoLabel.hidden = YES;
                }
                
                [self.focusTableView reloadData];
                
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    } else {
        [self.dataSourceFollow removeAllObjects];
        WEAK_SELF;
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_FOLLOW, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                NSArray *array = resposeObject[@"items"];
                for (NSDictionary *dic in array) {
                    NSString *followId = dic[@"follow_id"];
                    [self.dataSourceFollow addObject:followId];
                }
                
                NSArray *dataArray = nil;
//                if (self.shouldRemoveSameData) {
                    dataArray = [[self.dataSourceFollow removeSameData] copy];
//                } else {
//                    dataArray = [self.dataSourceFollow copy];
//                }
                
                [self.dataSourceFollow removeAllObjects];
                [self.dataSourceFollow addObjectsFromArray:dataArray];

                self.tableDelegate2.dataSource = self.dataSourceFollow;
                NSString *followCount = [NSString stringWithFormat:@"%ld", self.dataSourceFollow.count];
                self.followCount.text = followCount;
                
                if (self.tableDelegate2.dataSource.count == 0 && self.selectedIndex == 3) {
                    self.followNoLabel.hidden = NO;
                    self.followNoImage.hidden = NO;
                } else {
                    self.followNoImage.hidden = YES;
                    self.followNoLabel.hidden = YES;
                }
                
                [self.followTableView reloadData];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}
// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    
    KYDrawerController *drawerVC = (KYDrawerController *)self.navigationController.parentViewController;
    
    [drawerVC setDrawerState:DrawerStateOpened animated:YES];
    
//    [self.mm_drawerController
//     openDrawerSide:MMDrawerSideLeft
//     animated:YES
//     completion:^(BOOL finished) {
//         
//     }];
}
// 进入设置页面
- (void)enterUserInfo {
    SettingViewController *svc = [SettingViewController new];
    [self.navigationController pushViewController:svc animated:YES];
}
//// 返回按钮方法
//- (void)backButtonAction:(UIButton *)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//- (void)popPersonCenterAction {
//    [self.navigationController popViewControllerAnimated:NO];
//}
// 登陆后刷新信息
- (void)loginAndRefreshInfo:(NSNotification *)message {
    //    [self updatePersonInfo];
    [self getDataForCollectionView:self.worksCollectionView withiD:[self getUserId] withDataSource:self.dataSourceWorks];
    
    
    [self getDataForLikeFromDataBase];
    [self getDataForTableView:self.focusTableView];
    [self getDataForTableView:self.followTableView];
}

// 关注按钮方法
- (void)focusButtonAction:(UIButton *)sender {
    
    
}

// 私信按钮方法
- (void)otherSixinButtonAction {
    
}

// 点击个人头像
- (void)clickHeadImage {
    
    self.centerView.layer.borderColor = [UIColor cyanColor].CGColor;
    
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    
    [AXGMessage showImageSelectMessageOnView:self.view leftImage:[UIImage imageNamed:@"弹出框_拍照"] rightImage:[UIImage imageNamed:@"弹出框_相册"]];
    WEAK_SELF;
    [AXGMessage shareMessageView].leftButtonBlock = ^ () {
        STRONG_SELF;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        [self presentViewController:picker animated:YES completion:NULL];
    };
    [AXGMessage shareMessageView].rightButtonBlock = ^ () {
        STRONG_SELF;
        picker.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        [self presentViewController:picker animated:YES completion:NULL];
    };
    
}

#pragma mark - 选取图片相关

// 取消按钮方法
- (void)cancelButtonAction:(UIButton *)sender {
    self.editView.hidden = YES;
}

// 确定按钮方法
- (void)confirmButtonAction:(UIButton *)sender {
    
    self.centerView.layer.borderColor = [UIColor clearColor].CGColor;
    
    UIImage *snapshot = [self getImage];
    self.avatar = [self getImageFromBigImage:snapshot withRect:CGRectMake(self.centerView.left, self.centerView.top, self.centerView.width, self.centerView.height)];
    self.headImage.image = self.avatar;
    self.editView.hidden = YES;
    
    
    
    if (self.avatar) {
        
        NSData *data = UIImagePNGRepresentation(self.avatar);
        
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
        NSString *phone = [wrapper objectForKey:(id)kSecAttrAccount];
        
        NSString *fileName = [NSString stringWithFormat:@"%@.png", [XWAFNetworkTool md5HexDigest:phone]];
        
        [XWAFNetworkTool postUploadWithUrl:UPDATE_USER_HEAD fileData:data fileUrl:nil paramter:@{@"key":@"value"} fileName:fileName fileType:@"image/png" success:^(id responseObject) {
            NSLog(@"上传成功");
            
            [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_DRAWER object:nil];
            
        } fail:^{
            
        }];
    }
    
}

// 创建编辑页面
- (void)createEditView {
    self.editView = [[UIView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.editView];
    self.editView.backgroundColor = [UIColor blackColor];
    self.editView.hidden = YES;
    
    self.preImageView = [[UIImageView alloc] initWithFrame:self.editView.bounds];
    [self.editView addSubview:self.preImageView];
    self.preImageView.contentMode = UIViewContentModeScaleAspectFit;
    self.preImageView.userInteractionEnabled = YES;
    
    [self createMaskView];
    
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [self.editView addGestureRecognizer:pinchRecognizer];
    
    UIPanGestureRecognizer *panRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(move:)];
    [panRecognizer setMinimumNumberOfTouches:1];
    [panRecognizer setMaximumNumberOfTouches:1];
    [panRecognizer setDelegate:self];
    [self.editView addGestureRecognizer:panRecognizer];
    
}

// 创建遮罩界面
- (void)createMaskView {
    UIView *maskView = [[UIView alloc] initWithFrame:self.editView.bounds];
    [self.editView addSubview:maskView];
    maskView.backgroundColor = [UIColor clearColor];
    
    self.centerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 200, 200)];
    [maskView addSubview:self.centerView];
    self.centerView.frame = CGRectMake(0, 0, self.view.width * 2 / 3, self.view.width * 2 / 3);
    self.centerView.center = maskView.center;
    self.centerView.backgroundColor = [UIColor clearColor];
    self.centerView.layer.borderWidth = 1;
    //    self.centerView.layer.borderColor = THEME_COLOR.CGColor;
    self.centerView.layer.borderColor = [UIColor cyanColor].CGColor;
    
    UIView *mask1 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.centerView.left, maskView.height)];
    [maskView addSubview:mask1];
    mask1.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UIView *mask2 = [[UIView alloc] initWithFrame:CGRectMake(self.centerView.right, 0, maskView.width - self.centerView.right, maskView.height)];
    [maskView addSubview:mask2];
    mask2.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UIView *mask3 = [[UIView alloc] initWithFrame:CGRectMake(self.centerView.left, 0, self.centerView.width, self.centerView.top)];
    [maskView addSubview:mask3];
    mask3.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    UIView *mask4 = [[UIView alloc] initWithFrame:CGRectMake(self.centerView.left, self.centerView.bottom, self.centerView.width, maskView.height - self.centerView.bottom)];
    [maskView addSubview:mask4];
    mask4.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
    
    
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [maskView addSubview:cancelButton];
    cancelButton.frame = CGRectMake(0, self.view.height - 60, 120, 60);
    //    cancelButton.frame = CGRectMake(0, self.view.height - 60 * HEIGHT_NIT, 120 * WIDTH_NIT, 60 * HEIGHT_NIT);
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    cancelButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [cancelButton addTarget:self action:@selector(cancelButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    cancelButton.backgroundColor = [UIColor redColor];
    
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [maskView addSubview:confirmButton];
    confirmButton.frame = CGRectMake(self.view.width - 120, self.view.height - 60, 120, 60);
    //    confirmButton.frame = CGRectMake(self.view.width - 120 * WIDTH_NIT, self.view.height - 60 * HEIGHT_NIT, 120 * WIDTH_NIT, 60 * HEIGHT_NIT);
    [confirmButton setTitle:@"选取" forState:UIControlStateNormal];
    [confirmButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateNormal];
    confirmButton.titleLabel.textAlignment = NSTextAlignmentCenter;
    [confirmButton addTarget:self action:@selector(confirmButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    //    confirmButton.backgroundColor = [UIColor redColor];
    
}

#pragma mark - PickController
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info {
    self.avatar = info[UIImagePickerControllerOriginalImage];
    
    // 处理完毕，回到个人信息页面
    [picker dismissViewControllerAnimated:YES completion:^{
        
    }];
    //    self.shareImage.image = self.avatar;
    self.preImageView.image = self.avatar;
    //    self.personInfoView.headImage.image = self.avatar;
    self.transform = self.preImageView.transform;
    self.editView.hidden = NO;
    
}

// 从view截取
- (UIImage *)getImage {
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(self.view.width, self.view.height), NO, 1.0);  //NO，YES 控制是否透明
    [self.view.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    // 生成后的image
    
    return image;
}

// 根据给定得图片，从其指定区域截取一张新得图片

- (UIImage *)getImageFromBigImage:(UIImage *)bigImage withRect:(CGRect)subRect {
    CGImageRef imageRef = bigImage.CGImage;
    CGImageRef subImageRef = CGImageCreateWithImageInRect(imageRef, subRect);
    CGSize size;
    size.width = subRect.size.width;
    size.height = subRect.size.height;
    UIGraphicsBeginImageContext(size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextDrawImage(context, subRect, subImageRef);
    UIImage *smallImage = [UIImage imageWithCGImage:subImageRef];
    UIGraphicsEndImageContext();
    return smallImage;
}

#pragma mark - 移动缩放操作

// 缩放
-(void)scale:(id)sender {
    
    if([(UIPinchGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _lastScale = 1.0;
    }
    
    CGFloat scale = 1.0 - (_lastScale - [(UIPinchGestureRecognizer*)sender scale]);
    
    CGAffineTransform currentTransform = self.preImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, scale, scale);
    
    [self.preImageView setTransform:newTransform];
    
    _lastScale = [(UIPinchGestureRecognizer*)sender scale];
    //    [self showOverlayWithFrame:photoImage.frame];
}

// 旋转
-(void)rotate:(id)sender {
    
    if([(UIRotationGestureRecognizer*)sender state] == UIGestureRecognizerStateEnded) {
        
        _lastRotation = 0.0;
        return;
    }
    
    CGFloat rotation = 0.0 - (_lastRotation - [(UIRotationGestureRecognizer*)sender rotation]);
    
    CGAffineTransform currentTransform = self.preImageView.transform;
    CGAffineTransform newTransform = CGAffineTransformRotate(currentTransform,rotation);
    
    [self.preImageView setTransform:newTransform];
    
    WEAK_SELF;
    if (self.preImageView.width <= self.view.width) {
        
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            STRONG_SELF;
            [self.preImageView setTransform:self.transform];
        } completion:^(BOOL finished) {
            
        }];
        
    } else if (self.preImageView.width >= self.view.width * 3) {
        [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            STRONG_SELF;
            CGAffineTransform largeTransform = CGAffineTransformScale(self.transform, 3, 3);
            [self.preImageView setTransform:largeTransform];
            
        } completion:^(BOOL finished) {
            
        }];
    }
    
    _lastRotation = [(UIRotationGestureRecognizer*)sender rotation];
    //    [self showOverlayWithFrame:photoImage.frame];
}

// 移动
-(void)move:(id)sender {
    
    CGPoint translatedPoint = [(UIPanGestureRecognizer*)sender translationInView:self.editView];
    
    if([(UIPanGestureRecognizer*)sender state] == UIGestureRecognizerStateBegan) {
        _firstX = [self.preImageView center].x;
        _firstY = [self.preImageView center].y;
    }
    
    translatedPoint = CGPointMake(_firstX+translatedPoint.x, _firstY+translatedPoint.y);
    
    
    if (translatedPoint.x < 0) {
        [self.preImageView setCenter:CGPointMake(0, translatedPoint.y)];
    } else if (translatedPoint.x > self.view.width) {
        [self.preImageView setCenter:CGPointMake(self.view.width, translatedPoint.y)];
    } else if (translatedPoint.y < 64) {
        [self.preImageView setCenter:CGPointMake(translatedPoint.x, 64)];
    } else if (translatedPoint.y > self.view.height) {
        [self.preImageView setCenter:CGPointMake(translatedPoint.x, self.view.height)];
    } else {
        [self.preImageView setCenter:translatedPoint];
    }
    //    [self showOverlayWithFrame:photoImage.frame];
}

@end
