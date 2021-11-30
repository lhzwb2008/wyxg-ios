//
//  SettingViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SettingViewController.h"
#import "AXGHeader.h"
#import "KVNProgress.h"
#import "TYCache.h"
#import "KeychainItemWrapper.h"
//#import "UIViewController+MMDrawerController.h"
#import "ModifyViewController.h"
#import "AboutUsViewController.h"
#import "UserSongShareView.h"
#import "WXApi.h"
#import <UMShare/UMShare.h>
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterfaceObject.h>
#import <TencentOpenAPI/QQApiInterface.h>
#import "WeiboSDK.h"
#import "AXGCache.h"
#import "CreateSongs-Swift.h"
#import "LoginViewController.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
//#import "EMSDK.h"
#import "AXGMediator+MediatorModuleAActions.h"
#import "NSString+Common.h"
#import "AXGMessage.h"

#define SHAREVIEW_HEIGHT ((50 * WIDTH_NIT + 6 * HEIGHT_NIT + 12 * HEIGHT_NIT + 30 * HEIGHT_NIT) * 2 + 10 * HEIGHT_NIT + 33.5 * HEIGHT_NIT)

@interface SettingViewController ()<WXApiDelegate>

//@property (nonatomic, strong) UserSongShareView *shareView;

@property (nonatomic, strong) UserSongShareView *shareView;

@property (nonatomic, strong) UIView *shareMaskView;

@property (nonatomic, strong) UILabel *cacheLabel;

@property (nonatomic, strong) UIButton *logoutButton;

@property (nonatomic, copy) NSString *cachStr;

@end

@implementation SettingViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = HexStringColor(@"#eeeeee");
    
    [self initNavView];
    [self createSettingView];
    
    [self.view bringSubviewToFront:self.navView];
    
    [self createShareView];
    
//    [self getCache];
    
    [self reloadMsg];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeStatus) name:@"changeSettingStatus" object:nil];
}

#pragma mark - 初始化界面

- (void)initNavView {
    [super initNavView];
    self.navTitle.text = @"设置";
//    self.navLeftImage.image = [UIImage imageNamed:@"返回"];
    [self.navLeftButton setImage:[UIImage imageNamed:@"菜单icon"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"菜单_高亮"] forState:UIControlStateHighlighted];
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

// 创建分享界面
- (void)createShareView {
    
    self.shareMaskView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [self.view addSubview:self.shareMaskView];
    self.shareMaskView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.9];
    self.shareMaskView.hidden = YES;
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hideShareView)];
    [self.shareMaskView addGestureRecognizer:tap];
    
    self.shareView = [[UserSongShareView alloc] initWithFrame:CGRectMake(0, self.view.height, self.view.width, SHAREVIEW_HEIGHT)];
    [self.view addSubview:self.shareView];
    
    WEAK_SELF;
    self.shareView.shareButtonBlock = ^ (NSInteger index) {
        STRONG_SELF;
        
        NSLog(@"分享类型为%d", index);
        
        [self shareWithChannle:index];
        
    };
    
    self.shareView.cancelBlock = ^ () {
        STRONG_SELF;
        [self hideShareView];
    };
    
}

- (void)createSettingView {
    
    // 修改资料
    UIButton *modifyButton = [UIButton new];
    [self.view addSubview:modifyButton];
    modifyButton.frame = CGRectMake(0, self.navView.bottom + 35 * WIDTH_NIT, self.view.width, 44 * WIDTH_NIT);
    modifyButton.backgroundColor = [UIColor whiteColor];
    [modifyButton addTarget:self action:@selector(modifyButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *modifyImage = [[UIImageView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, modifyButton.top + 12.5 * WIDTH_NIT, 19.5 * WIDTH_NIT, 19 * WIDTH_NIT)];
    [self.view addSubview:modifyImage];
    modifyImage.image = [UIImage imageNamed:@"修改资料"];
    
    UILabel *modifyLabel = [[UILabel alloc] initWithFrame:CGRectMake(modifyImage.right + 12.5 * WIDTH_NIT, modifyButton.top, 100, 44 * WIDTH_NIT)];
    [self.view addSubview:modifyLabel];
    modifyLabel.text = @"修改资料";
    modifyLabel.textColor = HexStringColor(@"#535353");
    modifyLabel.font = TECU_FONT(15);
    
    UIImageView *arrow0 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 16 * WIDTH_NIT - 8 * WIDTH_NIT, modifyButton.top + 14.25 * WIDTH_NIT, 8 * WIDTH_NIT, 15.5 * WIDTH_NIT)];
    [self.view addSubview:arrow0];
    arrow0.image = [UIImage imageNamed:@"∧"];
    
    UIView *modifyLine0 = [[UIView alloc] initWithFrame:CGRectMake(0, modifyButton.top - 0.5, self.view.width, 0.5)];
    [self.view addSubview:modifyLine0];
    modifyLine0.backgroundColor = HexStringColor(@"#879999");
    
//    UIView *modifyLine1 = [[UIView alloc] initWithFrame:CGRectMake(49.5 * WIDTH_NIT, modifyButton.bottom - 0.5, self.view.width - 49.5 * WIDTH_NIT, 0.5)];
//    [self.view addSubview:modifyLine1];
//    modifyLine1.backgroundColor = modifyLine0.backgroundColor;
    
    // 邀请好友
    UIButton *inviteButton = [UIButton new];
    [self.view addSubview:inviteButton];
    inviteButton.frame = CGRectMake(0, modifyButton.bottom, self.view.width, 44 * WIDTH_NIT);
    //    [inviteButton setTitle:@"邀请好友" forState:UIControlStateNormal];
    inviteButton.backgroundColor = [UIColor whiteColor];
    [inviteButton addTarget:self action:@selector(inviteButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *inviteImage = [[UIImageView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, inviteButton.top + 12.5 * WIDTH_NIT, 19.5 * WIDTH_NIT, 19 * WIDTH_NIT)];
    [self.view addSubview:inviteImage];
    inviteImage.image = [UIImage imageNamed:@"邀请好友"];
    
    UILabel *inviteLabel = [[UILabel alloc] initWithFrame:CGRectMake(inviteImage.right + 12.5 * WIDTH_NIT, inviteButton.top, 100, 44 * WIDTH_NIT)];
    [self.view addSubview:inviteLabel];
    inviteLabel.text = @"邀请好友";
    inviteLabel.textColor = HexStringColor(@"#535353");
    [inviteLabel setFont:TECU_FONT(15)];
    
    UIImageView *arrow1 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 16 * WIDTH_NIT - 8 * WIDTH_NIT, inviteButton.top + 14.25 * WIDTH_NIT, 8 * WIDTH_NIT, 15.5 * WIDTH_NIT)];
    [self.view addSubview:arrow1];
    arrow1.image = [UIImage imageNamed:@"∧"];
    
    UIView *line0 = [[UIView alloc] initWithFrame:CGRectMake(49.5 * WIDTH_NIT, inviteButton.top - 0.5, self.view.width - 49.5 * WIDTH_NIT, 0.5)];
    [self.view addSubview:line0];
    line0.backgroundColor = HexStringColor(@"#879999");
    
    UIView *line1 = [[UIView alloc] initWithFrame:CGRectMake(49.5 * WIDTH_NIT, inviteButton.bottom - 0.5, self.view.width - 49.5 * WIDTH_NIT, 0.5)];
    [self.view addSubview:line1];
    line1.backgroundColor = line0.backgroundColor;
    
//    UIView *inviteLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, inviteButton.width, 0.5)];
//    [inviteButton addSubview:inviteLine];
//    inviteLine.backgroundColor = line1.backgroundColor;
    
    // APP好评
    UIButton *contentsButton = [UIButton new];
    [self.view addSubview:contentsButton];
    contentsButton.frame = CGRectMake(inviteButton.left, inviteButton.bottom, inviteButton.width, inviteButton.height);
    //    [contentsButton setTitle:@"App好评" forState:UIControlStateNormal];
    contentsButton.backgroundColor = [UIColor whiteColor];
    [contentsButton addTarget:self action:@selector(contentButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *contentImage = [[UIImageView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, contentsButton.top + 12.5 * WIDTH_NIT, 19.5 * WIDTH_NIT, 19 * WIDTH_NIT)];
    [self.view addSubview:contentImage];
    contentImage.image = [UIImage imageNamed:@"APP好评"];
    
    UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(inviteLabel.left, contentsButton.top, inviteLabel.width, inviteLabel.height)];
    [self.view addSubview:contentLabel];
    contentLabel.textColor = inviteLabel.textColor;
    contentLabel.text = @"APP好评";
    contentLabel.font = inviteLabel.font;
    
    UIImageView *arrow2 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 16 * WIDTH_NIT - 8 * WIDTH_NIT, contentsButton.top + 14.25 * WIDTH_NIT, 8 * WIDTH_NIT, 15.5 * WIDTH_NIT)];
    [self.view addSubview:arrow2];
    arrow2.image = arrow1.image;;
    
    UIView *line2 = [[UIView alloc] initWithFrame:CGRectMake(49.5 * WIDTH_NIT, contentsButton.bottom - 0.5, line1.width, line1.height)];
    [self.view addSubview:line2];
    line2.backgroundColor = line1.backgroundColor;
    
    // 关于我们
    UIButton *aboutUsButton = [UIButton new];
    [self.view addSubview:aboutUsButton];
    aboutUsButton.frame = CGRectMake(contentsButton.left, contentsButton.bottom, contentsButton.width, contentsButton.height);
    //    [aboutUsButton setTitle:@"关于我们" forState:UIControlStateNormal];
    aboutUsButton.backgroundColor = [UIColor whiteColor];
    [aboutUsButton addTarget:self action:@selector(aboutUsButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIImageView *aboutImage = [[UIImageView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, aboutUsButton.top + 12.5 * WIDTH_NIT, 19.5 * WIDTH_NIT, 19 * WIDTH_NIT)];
    [self.view addSubview:aboutImage];
    aboutImage.image = [UIImage imageNamed:@"关于我们"];
    
    UILabel *aboutLabel = [[UILabel alloc] initWithFrame:CGRectMake(inviteLabel.left, aboutUsButton.top, inviteLabel.width, inviteLabel.height)];
    [self.view addSubview:aboutLabel];
    aboutLabel.textColor = contentLabel.textColor;
    aboutLabel.text = @"关于我们";
    aboutLabel.font = contentLabel.font;
    
    UIImageView *arrow3 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 16 * WIDTH_NIT - 8 * WIDTH_NIT, aboutUsButton.top + 14.25 * WIDTH_NIT, 8 * WIDTH_NIT, 15.5 * WIDTH_NIT)];
    [self.view addSubview:arrow3];
    arrow3.image = arrow1.image;
    
    UIView *line3 = [[UIView alloc] initWithFrame:CGRectMake(0, aboutUsButton.bottom - 0.5, self.view.width, line1.height)];
    [self.view addSubview:line3];
    line3.backgroundColor = line1.backgroundColor;
    
    // 清除缓存
    UIButton *clearButton = [UIButton new];
    [self.view addSubview:clearButton];
    clearButton.frame = CGRectMake(aboutUsButton.left, aboutUsButton.bottom + 35 * WIDTH_NIT, aboutUsButton.width, aboutUsButton.height);
    clearButton.backgroundColor = [UIColor whiteColor];
    [clearButton addTarget:self action:@selector(clearButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    UIView *clearLine1 = [[UIView alloc] initWithFrame:CGRectMake(0, clearButton.top - 0.5, self.view.width, 0.5)];
    [self.view addSubview:clearLine1];
    clearLine1.backgroundColor = line0.backgroundColor;
    
    UIView *clearLine = [[UIView alloc] initWithFrame:CGRectMake(0, clearButton.bottom - 0.5, clearButton.width, 0.5)];
    clearLine.backgroundColor = line1.backgroundColor;
    [self.view addSubview:clearLine];
    
    UIImageView *clearImage = [[UIImageView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, clearButton.top + 12.5 * WIDTH_NIT, 19.5 * WIDTH_NIT, 19 * WIDTH_NIT)];
    [self.view addSubview:clearImage];
    clearImage.image = [UIImage imageNamed:@"清除缓存"];
    
    UILabel *clearLabel = [[UILabel alloc] initWithFrame:CGRectMake(inviteLabel.left, clearButton.top, inviteLabel.width, inviteLabel.height)];
    [self.view addSubview:clearLabel];
    clearLabel.textColor = aboutLabel.textColor;
    clearLabel.font = aboutLabel.font;
    clearLabel.text = @"清除缓存";
    
//    UIImageView *arrow4 = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 16 * WIDTH_NIT - 8 * WIDTH_NIT, clearButton.top + 14.25 * WIDTH_NIT, 8 * WIDTH_NIT, 15.5 * WIDTH_NIT)];
//    [self.view addSubview:arrow4];
//    arrow4.image = arrow1.image;
    
    // 注销
    self.logoutButton = [UIButton new];
    [self.view addSubview:self.logoutButton];
    self.logoutButton.frame = CGRectMake(clearButton.left, clearButton.bottom + 20, 250 * WIDTH_NIT, 50 * WIDTH_NIT);
    self.logoutButton.center = CGPointMake(self.view.width / 2, self.view.height - 60 * HEIGHT_NIT);
    [self.logoutButton setTitle:@"登  出" forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
    [self.logoutButton setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateHighlighted];
    self.logoutButton.titleLabel.font = TECU_FONT(18);
//    self.logoutButton.backgroundColor = HexStringColor(@"#879999");
    [self.logoutButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色"] forState:UIControlStateNormal];
    [self.logoutButton setBackgroundImage:[UIImage imageNamed:@"按钮背景色高亮"] forState:UIControlStateHighlighted];
    [self.logoutButton addTarget:self action:@selector(logoutButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.logoutButton.layer.cornerRadius = self.logoutButton.height / 2;
    self.logoutButton.layer.masksToBounds = YES;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        self.logoutButton.hidden = NO;
    } else {
        self.logoutButton.hidden = YES;
    }
    
    UIImageView *logoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 75 * WIDTH_NIT, 75 * WIDTH_NIT)];
    [self.view addSubview:logoImage];
    logoImage.backgroundColor = [UIColor clearColor];
    logoImage.center = CGPointMake(self.view.width / 2, clearButton.bottom +  (self.logoutButton.top - clearButton.bottom) / 2 - 10);
    logoImage.image = [UIImage imageNamed:@"设置-LOGO"];
    
    UILabel *versionLabel = [[UILabel alloc] initWithFrame:CGRectMake(logoImage.left, logoImage.bottom + 8 * WIDTH_NIT, logoImage.width, 31 * WIDTH_NIT)];
    versionLabel.font = NORML_FONT(15);
    versionLabel.textColor = HexStringColor(@"#535353");
    versionLabel.text = [NSString stringWithFormat:@"V%@", [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]];
    [self.view addSubview:versionLabel];
    versionLabel.textAlignment = NSTextAlignmentCenter;
    

}

#pragma mark - Action

// 刷新站内信数据
- (void)reloadMsg {
    
//    NSMutableArray *mutaArr = [[NSMutableArray alloc] initWithCapacity:0];
//
//    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
//
//        //     获取用户id
//        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
//        NSString *userId = [wrapper objectForKey:(id)kSecValueData];
//
//        WEAK_SELF;
//        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_MESSAGE, userId] body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//            NSDictionary *dic1 = [NSJSONSerialization JSONObjectWithData:resposeObject options:0 error:nil];
//            STRONG_SELF;
//            if ([dic1[@"status"] isEqualToNumber:@0]) {
//                NSArray *array = dic1[@"items"];
//
//                for (NSDictionary *dic in array) {
//                    if ([dic[@"is_read"] isEqualToString:@"1"]) {
//
//                    } else {
//                        [mutaArr addObject:dic];
//                    }
//                }
//
//                if (mutaArr.count != 0) {
//                    self.msgView.hidden = NO;
//                } else {
//                    self.msgView.hidden = YES;
//                }
//
//            } else {
//                self.msgView.hidden = YES;
//            }
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            self.msgView.hidden = YES;
//        }];
//    } else {
        self.msgView.hidden = YES;
//    }
    
}

// 获取缓存大小
- (void)getCache {
    NSLog(@"tycache %lf", [self folderSizeAtPath:[TYCache cacheDirectory]]);
    NSLog(@"axgcache %lf", [self folderSizeAtPath:[AXGCache cacheDirectory]]);
    
    float cacheSize = 0;
    cacheSize += [self folderSizeAtPath:[TYCache cacheDirectory]];
    cacheSize += [self folderSizeAtPath:[AXGCache cacheDirectory]];
    float sdCache = [[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0;
    cacheSize += sdCache;
    
    NSLog(@"total cache  %lf", cacheSize);
    
}

- (void)changeStatus {

    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        self.logoutButton.hidden = NO;
    } else {
        self.logoutButton.hidden = YES;
    }
}

- (void)backButtonAction:(UIButton *)sender {
////    [self.mm_drawerController
////     openDrawerSide:MMDrawerSideLeft
////     animated:YES
////     completion:^(BOOL finished) {
////         
////     }];
//    [self.navigationController popViewControllerAnimated:YES];
    
    KYDrawerController *drawerVC = (KYDrawerController *)self.navigationController.parentViewController;
    
    [drawerVC setDrawerState:DrawerStateOpened animated:YES];
    
}

// 修改资料方法
- (void)modifyButtonAction:(UIButton *)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        ModifyViewController *modiVC = [[ModifyViewController alloc] init];
        modiVC.fromDrawer = NO;
        [self.navigationController pushViewController:modiVC animated:YES];
    } else {
        AXG_LOGIN(LOGIN_LOCATION_SETTING);
    }
    
}

#define MEDIATOR_SHARE_URL @"wyxg://shareView?title=%@&url=%@&description=%@&img=%@"

// 邀请好友按钮方法
- (void)inviteButtonAction:(UIButton *)sender {
//    [self showShareView];
    
     NSString *title = @"我正在玩#我要写歌#，最火写歌app！快来一起写歌吧";
     title = @"";
     NSString *webUrl = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.woyaoxiege.wyxg";
     NSString *songWriter = @"";
     songWriter = @"我正在玩#我要写歌#，最火写歌app！快来一起写歌吧";

    
    [AXGMediator AXGMeidator_showNativiShareViewWithParams:@{
                                                             @"title":title,
                                                             @"url":webUrl,
                                                             @"description":songWriter,
                                                             @"img":@"LOGO"
                                                             }
                                                loadResult:^(id view) {
        
    
                                                }
                                                hideAction:^(NSDictionary *info) {
        
    
                                                }];
}

// APP好评方法
- (void)contentButtonAction:(UIButton *)sender {
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms-apps://itunes.apple.com/WebObjects/MZStore.woa/wa/viewContentsUserReviews?type=Purple+Software&id=1089859708"]];
}

// 关于我们方法
- (void)aboutUsButtonAction:(UIButton *)sender {
    AboutUsViewController *aboutUsVC = [[AboutUsViewController alloc] init];
    [self.navigationController pushViewController:aboutUsVC animated:YES];
}

// 登出按钮方法
- (void)logoutButtonAction:(UIButton *)sender {
    
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"是否注销登录" preferredStyle:UIAlertControllerStyleAlert];
    
    WEAK_SELF;
    UIAlertAction *OKAction = [UIAlertAction actionWithTitle:@"注销" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        STRONG_SELF;
        [self logoutAction];
        [KVNProgress showSuccessWithStatus:@"注销成功"];
//        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
////            [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDrawerRoot" object:@"首页"];
//            [[NSNotificationCenter defaultCenter] postNotificationName:@"logoutNotification" object:nil];
//        });
        self.logoutButton.hidden = YES;
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    [alert addAction:OKAction];
    [alert addAction:cancelAction];
    [self presentViewController:alert animated:YES completion:^{
        
    }];
}

// 登出按钮方法
- (void)logoutAction {
    [[NSUserDefaults standardUserDefaults] setObject:IS_LOGIN_NO forKey:IS_LOGIN];
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    [wrapper resetKeychainItem];
    
//    EMError *error = [[EMClient sharedClient] logout:YES];
//    if (!error) {
//        NSLog(@"退出环信成功");
//    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:REFRESH_DRAWER object:nil];
//    [[NSUserDefaults standardUserDefaults] setObject:LOGIN_LOCATION_DRAWER forKey:LOGIN_LOCATION];
//    [[NSUserDefaults standardUserDefaults] setObject:NULL_USER_ID forKey:INFO_USER_ID];
}

#pragma mark - 清除缓存

// 清除缓存方法
- (void)clearButtonAction:(UIButton *)sender {
    
//    NSString *cachesPath = [TYCache cacheDirectory];
    
    [TYCache resetCache];
    [AXGCache resetCache];
    [[SDImageCache sharedImageCache] cleanDisk];
    [[SDImageCache sharedImageCache] clearDisk];
//    [self clearCache:cachesPath];
    
    [AXGMessage showRotateImageOnView:self.view image:[UIImage imageNamed:@"已清除"]];
    
//    [KVNProgress showSuccessWithStatus:@"清理缓存成功"];
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
}

// 单个文件缓存
- (float)fileSizeAtPath:(NSString *)path{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if([fileManager fileExistsAtPath:path]){
        long long size = [fileManager attributesOfItemAtPath:path error:nil].fileSize;
        return size / 1024.0 / 1024.0;
    }
    return 0;
}

// 文件夹缓存
- (float)folderSizeAtPath:(NSString *)path{
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *cachePath = path;
    long long folderSize = 0;
    
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSArray *childerFiles = [fileManager subpathsAtPath:cachePath];
        
        for (NSString *fileName in childerFiles) {
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            long long size=[self fileSizeAtPath:fileAbsolutePath];
            folderSize += size;
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
        }
        //SDWebImage框架自身计算缓存的实现
//        folderSize += [[SDImageCache sharedImageCache] getSize] / 1024.0 / 1024.0;
        return folderSize / 1024.0 / 1024.0;
    }
//    [KVNProgress dismiss];
    return 0;
}

// 清除缓存
- (void)clearCache:(NSString *)path{
    
    NSString *cachePath=[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject];
    cachePath=[cachePath stringByAppendingPathComponent:path];
    
    NSFileManager *fileManager=[NSFileManager defaultManager];
    if ([fileManager fileExistsAtPath:cachePath]) {
        NSArray *childerFiles=[fileManager subpathsAtPath:cachePath];
        for (NSString *fileName in childerFiles) {
            //如有需要，加入条件，过滤掉不想删除的文件
            NSString *fileAbsolutePath=[cachePath stringByAppendingPathComponent:fileName];
            NSLog(@"fileAbsolutePath=%@",fileAbsolutePath);
            [fileManager removeItemAtPath:fileAbsolutePath error:nil];
        }
    }
    [[SDImageCache sharedImageCache] cleanDisk];
}

#pragma mark - *************分享页相关方法**************

// 弹出分享页
- (void)showShareView {
    WEAK_SELF;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        STRONG_SELF;
        self.shareMaskView.hidden = NO;
        self.shareView.frame = CGRectMake(self.shareView.left, self.view.height - SHAREVIEW_HEIGHT, self.view.width, SHAREVIEW_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

// 收起分享页
- (void)hideShareView {
    WEAK_SELF;
    [UIView animateWithDuration:0.3 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        STRONG_SELF;
        self.shareMaskView.hidden = YES;
        self.shareView.frame = CGRectMake(self.shareView.left, self.view.height, self.view.width, SHAREVIEW_HEIGHT);
    } completion:^(BOOL finished) {
        
    }];
}

/**
 *  分享按钮方法
 *
 *  @param index 分享渠道
 */
- (void)shareWithChannle:(NSInteger)index {
    
    NSString *title = @"我正在玩#我要写歌#，最火写歌app！快来一起写歌吧";
    title = @"";
    NSString *mp3Url = @"";
    NSString *webUrl = @"http://a.app.qq.com/o/simple.jsp?pkgname=com.woyaoxiege.wyxg";
    UIImage *image = [UIImage imageNamed:@"LOGO"];
    NSString *songWriter = @"";
    songWriter = @"我正在玩#我要写歌#，最火写歌app！快来一起写歌吧";
    
    switch (index) {
        case 0:
            [self weChatShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
            break;
        case 1:
            [self friendShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
            break;
        case 2:
            [self QQShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
            break;
        case 3:
            [self QZoneShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
            break;
        case 4:
            [self WeiboShareAction:title mp3Url:mp3Url webUrl:webUrl image:image songWriter:songWriter];
        case 5: {
            UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
            pasteboard.string = webUrl;
            
            [MBProgressHUD showSuccess:@"已复制的剪贴板"];
        }
            break;
            
        default:
            break;
    }
    
}

// 微信分享按钮
- (void)weChatShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    
    // 点击分享微信的按钮统计
    //    [MobClick event:@"play_shareWechat"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = title;
    message.description = writer;
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = web;
    message.mediaObject = ext;
    
    SendMessageToWXReq  *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneSession;
    
//    [WXApi sendReq:req];
    
    //    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    myAppDelegate.ShareType = wxShare;
    
}

// 朋友圈分享按钮
- (void)friendShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    
    // 点击分享朋友圈按钮统计
    //    [MobClick event:@"play_shareFriend"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = writer;
    message.description = title;
    
    [message setThumbImage:image];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = web;
    message.mediaObject = ext;
    
    SendMessageToWXReq *req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    req.scene = WXSceneTimeline;
    
//    [WXApi sendReq:req];
    
    //    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    //    myAppDelegate.ShareType = wxFriend;
    
}

// QQ分享按钮
- (void)QQShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    
    // 点击分享QQ按钮统计
    //    [MobClick event:@"play_shareQQ"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shareIcon" ofType:@"png"]];
    
    if (image != nil) {
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        } else {
            data = UIImagePNGRepresentation(image);
        }
    }
    
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:web] title:writer description:title previewImageData:data];
    
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode sent = [QQApiInterface sendReq:req];
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myAppDelegate.ShareType = QQShare;
    
    NSLog(@"%d", sent);
    if (sent == 0) {
        //        [MobClick event:@"play_shareQQSuccess"];
        //        [KVNProgress showSuccessWithStatus:@"已分享"];
        myAppDelegate.willShowShareToast = YES;
    }
}

// QZone分享按钮
- (void)QZoneShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    // 点击分享到QQ空间按钮
    //    [MobClick event:@"play_shareQZone"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    
    NSData *data = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"shareIcon" ofType:@"png"]];
    
    if (image != nil) {
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1);
        } else {
            data = UIImagePNGRepresentation(image);
        }
    }
    
    QQApiNewsObject *newsObj = [QQApiNewsObject objectWithURL:[NSURL URLWithString:web] title:writer description:title previewImageData:data];
    SendMessageToQQReq *req = [SendMessageToQQReq reqWithContent:newsObj];
    QQApiSendResultCode sent = [QQApiInterface SendReqToQZone:req];
    
    NSLog(@"%d", sent);
    
    AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
    myAppDelegate.ShareType = QZoneShare;
    
    if (sent == 0) {
        //        [MobClick event:@"play_shareQZoneSuccess"];
        myAppDelegate.willShowShareToast = YES;
    }
    
}


- (void)WeiboShareAction:(NSString *)title mp3Url:(NSString *)mp3 webUrl:(NSString *)web image:(UIImage *)image songWriter:(NSString *)writer {
    
    
    //    [MobClick event:@"play_weiboShare"];
    
    if (![XWAFNetworkTool checkNetwork]) {
        //        [MBProgressHUD showError:@"网络不给力"];
        [KVNProgress showErrorWithStatus:@"网络不给力"];
        return;
    }
    UMSocialMessageObject *messageObject =[UMSocialMessageObject messageObject];
    UMShareWebpageObject *shareObject = [UMShareWebpageObject shareObjectWithTitle:title descr:writer thumImage:[UIImage imageNamed:@"shareIcon"]];
    shareObject.webpageUrl = web;
    messageObject.shareObject = shareObject;
    [[UMSocialManager defaultManager] shareToPlatform:UMSocialPlatformType_Sina messageObject:messageObject currentViewController:self completion:^(id result, NSError *error) {
        NSLog(@"分享成功");
        AppDelegate *myAppDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
        myAppDelegate.willShowShareToast = YES;
//        [MobClick event:@"play_weiboShareSuccess"];
    }];
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
