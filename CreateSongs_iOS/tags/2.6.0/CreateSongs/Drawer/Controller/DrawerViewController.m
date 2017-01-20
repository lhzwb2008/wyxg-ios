//
//  DrawerViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "DrawerViewController.h"
#import "DrawerView.h"
//#import "UIViewController+MMDrawerController.h"
#import "AXGHeader.h"
#import "PersonCenterController.h"
#import "CustomNaviController.h"
#import "XWAFNetworkTool.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "NSString+Emojize.h"

//#import "KYDrawerController.h"
#import "DraftsViewController.h"
#import "SuggestViewController.h"
#import "KVNProgress.h"
#import "LoginViewController.h"
#import "ForumViewController.h"
#import "ModifyViewController.h"
#import "AppDelegate.h"
#import "SettingViewController.h"
#import "WalletViewController.h"
#import "MsgViewController.h"
#import "TotalMsgViewController.h"
#import "EMSDK.h"

@interface DrawerViewController ()

@property (nonatomic, strong) UIViewController *tmpViewController;

@property (nonatomic, strong) NSMutableArray *msgNotReadArray;


@end

@implementation DrawerViewController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.msgNotReadArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.drawerView = [[DrawerView alloc] initWithFrame:self.view.bounds];
    self.drawerView.frame = CGRectMake(0, 0, 250 * WIDTH_NIT, self.view.height);
    [self.view addSubview:self.drawerView];
    
    WEAK_SELF;
//    self.drawerView.drawerMsgClickBlock = ^ () {
//        STRONG_SELF;
//        [self turnToMsgView];
//    };

    self.drawerView.drawerSelected = ^ (NSInteger index) {
        STRONG_SELF;
        [self drawerSelectedAction:index];
    };
    
    [self getUserData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getUserData) name:REFRESH_DRAWER object:nil];
    
    // 登出监听
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(logoutNotificationAction) name:@"logoutNotification" object:nil];
    
    // 监听回到个人中心
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(backToPersonCenter) name:@"backToPerson" object:nil];
    
    // 监听回到首页最新
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToHomeNew) name:@"turnToHomeFromShare" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self reloadMsg];
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPanGesture" object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"openPanGesture" object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"closePanGesture" object:nil];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"closePanGesture" object:nil];
}

// 登出监听方法
- (void)logoutNotificationAction {
    [self drawerSelectedAction:0];
}

// 回到个人中心监听
- (void)backToPersonCenter {
    [self drawerSelectedAction:1];
}

- (void)changeDrawerState:(NSInteger)index {
    [self.drawerView changeShowState:index];
}

// 回到首页最新
- (void)turnToHomeNew {
    
     KYDrawerController *kyDrawer = self.kyDrawer;
    
    HomeViewController *mainHomeVC = [[HomeViewController alloc] init];
    CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
    [nav setNavigationBarHidden:YES];
    
    kyDrawer.mainViewController = nav;
    
    [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
    
    [mainHomeVC reloadHome];
}

// 获取用户信息
- (void)getUserData {
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
        NSString *userId = [wrapper objectForKey:(id)kSecValueData];
        NSString *phone = [wrapper objectForKey:(id)kSecAttrAccount];
        
        [self.drawerView.themeImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:phone]]] placeholderImage:[UIImage imageNamed:@"头像"]];
        
        WEAK_SELF;
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                self.drawerView.nameLabel.text = [resposeObject[@"name"] emojizedString];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    } else {
        self.drawerView.themeImage.image = [UIImage imageNamed:@"头像"];
        self.drawerView.nameLabel.text = @"请登录";
    }
}

// 手势方法
- (void)gestrueAction:(UIGestureRecognizer *)gesture {
    if (self.kyDrawer.drawerState == DrawerStateOpened) {
        [self.kyDrawer setDrawerState:DrawerStateClosed animated:YES];
    }
}

// 抽屉点击方法
- (void)drawerSelectedAction:(NSInteger)index {
    
    KYDrawerController *kyDrawer = self.kyDrawer;
    
    switch (index) {
        case 0: {
            if ([kyDrawer.mainViewController isKindOfClass:[HomeViewController class]]) {
                // 收回抽屉
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            } else {
//                [self.draftsMainHomeVC.view removeFromSuperview];
                HomeViewController *mainHomeVC = [[HomeViewController alloc] init];
                CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
                [nav setNavigationBarHidden:YES];

                kyDrawer.mainViewController = nav;
                
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
        }
            break;
        case 1: {
            // 个人中心
            [[NSUserDefaults standardUserDefaults] setObject:DRAWER_LOCATION_PERSON forKey:DRAWER_LOCATION];
            
            if (![XWAFNetworkTool checkNetwork]) {
                //            [MBProgressHUD showError:@"网络不给力"];
                [KVNProgress showErrorWithStatus:@"网络不给力"];
                
                return;
            }
            
            if ([kyDrawer.mainViewController isKindOfClass:[PersonCenterController class]]) {
                // 收回抽屉
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            } else {
                
                if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
                    
                    PersonCenterController *mainHomeVC = [[PersonCenterController alloc] init];
                    CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
                    [nav setNavigationBarHidden:YES];
                    kyDrawer.mainViewController = nav;
                    [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
                    
                } else {
                    AXG_LOGIN(LOGIN_LOCATION_PERSON);
                }
            }
        }
            break;
        case 3: {
            
            if ([kyDrawer.mainViewController isKindOfClass:[DraftsViewController class]]) {
                // 收回抽屉
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            } else {
                DraftsViewController *draftsMainHomeVC = [[DraftsViewController alloc] init];
                CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:draftsMainHomeVC];
                [nav setNavigationBarHidden:YES];
                
                kyDrawer.mainViewController = nav;
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
        }
            break;
        case 2: {
            if ([kyDrawer.mainViewController isKindOfClass:[SuggestViewController class]]) {
                // 收回抽屉
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            } else {
                SuggestViewController *mainHomeVC = [[SuggestViewController alloc] init];
                CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
                [nav setNavigationBarHidden:YES];

                kyDrawer.mainViewController = nav;
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
        }
            break;
        case 4: {
            if ([kyDrawer isKindOfClass:[ForumViewController class]]) {
                // 收回抽屉
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            } else {
                ForumViewController *mainHomeVC = [[ForumViewController alloc] init];
                CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
                [nav setNavigationBarHidden:YES];
                kyDrawer.mainViewController = nav;
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
        }
            break;
        case 5: {
            // 头像
            [[NSUserDefaults standardUserDefaults] setObject:DRAWER_LOCATION_HEAD forKey:DRAWER_LOCATION];
            
            if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
                
                ModifyViewController *mainHomeVC = [[ModifyViewController alloc] init];
                mainHomeVC.fromDrawer = YES;
                CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
                [nav setNavigationBarHidden:YES];
                kyDrawer.mainViewController = nav;
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
                
            } else {
                
                AXG_LOGIN(LOGIN_LOCATION_DRAWER);
            }
        }
            break;
        case 6: {
            
            // 设置
            if ([kyDrawer isKindOfClass:[SettingViewController class]]) {
                // 收回抽屉
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            } else {
                SettingViewController *mainHomeVC = [[SettingViewController alloc] init];
                CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
                [nav setNavigationBarHidden:YES];
                kyDrawer.mainViewController = nav;
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
            
        }
            break;
        case 7: {
            // 钱包
            if ([kyDrawer isKindOfClass:[WalletViewController class]]) {
                // 收回抽屉
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            } else {
                WalletViewController *mainHomeVC = [[WalletViewController alloc] init];
                CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
                [nav setNavigationBarHidden:YES];
                kyDrawer.mainViewController = nav;
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
        }
            break;
        case 8: {
            // 站内信
            if ([kyDrawer isKindOfClass:[TotalMsgViewController class]]) {
                // 收回抽屉
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            } else {
                TotalMsgViewController *mainHomeVC = [[TotalMsgViewController alloc] init];
                CustomNaviController *nav = [[CustomNaviController alloc] initWithRootViewController:mainHomeVC];
                [nav setNavigationBarHidden:YES];
                kyDrawer.mainViewController = nav;
                [kyDrawer setDrawerState:DrawerStateClosed animated:YES];
            }
        }
            
        default:
            break;
    }
    
}

#pragma mark - 站内信方法

// 收到新消息
- (void)receiveNewMessage {
    self.drawerView.msgButton.selected = YES;
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
            self.drawerView.msgButton.selected = YES;
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
                        self.drawerView.msgButton.selected = YES;
                    } else {
                        self.drawerView.msgButton.selected = NO;
                    }
                    
                } else {
                    self.drawerView.msgButton.selected = NO;
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                self.drawerView.msgButton.selected = NO;
            }];
        }
        
    } else {
        self.drawerView.msgButton.selected = NO;
    }
    
}

//// 推到消息页
//- (void)turnToMsgView {
//    
//    MsgViewController *msgVC = [[MsgViewController alloc] init];
//    [self.navigationController pushViewController:msgVC animated:YES];
//    
//}

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
