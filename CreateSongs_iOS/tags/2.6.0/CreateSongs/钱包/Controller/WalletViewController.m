//
//  WalletViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "WalletViewController.h"
#import "CreateSongs-Swift.h"
#import "CashViewController.h"
#import "XWAFNetworkTool.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "EMSDK.h"

@interface WalletViewController ()

@property (nonatomic, strong) UILabel *money;

@end

@implementation WalletViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavView];
    [self createBody];
    [self createEdgePanView];
    
    [self reloadMsg];
    
    [self.view bringSubviewToFront:self.navView];
    
    [self getMoneyData];
    
}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
    
    [self.navLeftButton setImage:[UIImage imageNamed:@"菜单icon"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"菜单_高亮"] forState:UIControlStateHighlighted];
    self.navTitle.text = @"钱包";
    
    [self.navLeftButton addTarget:self action:@selector(showDrawer) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)createEdgePanView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 20, self.view.height - 64)];
    //    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(showDrawer)];
    edgePan.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:edgePan];
}

- (void)createBody {
    
    
    self.money = [[UILabel alloc] initWithFrame:CGRectMake(0, self.navView.bottom + 230 * HEIGHT_NIT, self.view.width, 36 * HEIGHT_NIT + 30 * HEIGHT_NIT)];
    [self.view addSubview:self.money];
    self.money.textColor = HexStringColor(@"#441D11");
    self.money.font = TECU_FONT(36);
    self.money.textAlignment= NSTextAlignmentCenter;
    self.money.text = @"0";
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.navView.bottom + 245 * HEIGHT_NIT + 36 * HEIGHT_NIT, self.view.width, 30 * HEIGHT_NIT + 15 * HEIGHT_NIT)];
    [self.view addSubview:label];
    label.text = @"可兑换收益(积分)";
    label.textColor = HexStringColor(@"#A0A0A0");
    label.font = NORML_FONT(15);
    label.textAlignment = NSTextAlignmentCenter;
    
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    [self.view addSubview:button];
//    button.frame = CGRectMake((self.view.width - 250 * WIDTH_NIT) / 2, self.view.height - 35 * HEIGHT_NIT - 50 * WIDTH_NIT, 250 * WIDTH_NIT, 50 * WIDTH_NIT);
//    [button setTitle:@"兑换收益" forState:UIControlStateNormal];
//    [button setTitleColor:HexStringColor(@"#441D11") forState:UIControlStateNormal];
//    [button setTitleColor:HexStringColor(@"#ffffff") forState:UIControlStateHighlighted];
//    button.layer.cornerRadius = button.height / 2;
//    button.layer.masksToBounds = YES;
//    [button setBackgroundImage:[UIImage imageNamed:@"按钮背景色"] forState:UIControlStateNormal];
//    [button setBackgroundImage:[UIImage imageNamed:@"按钮背景色高亮"] forState:UIControlStateHighlighted];
//    [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark - Aciton

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

// 展示抽屉
- (void)showDrawer {
    
    KYDrawerController *drawerVC = (KYDrawerController *)self.navigationController.parentViewController;
    
    [drawerVC setDrawerState:DrawerStateOpened animated:YES];
    
}

// 获取余额
- (void)getMoneyData {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
        NSString *userId = [wrapper objectForKey:(id)kSecValueData];
        WEAK_SELF;
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_MONEY, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            
            if ([resposeObject[@"status"] isKindOfClass:[NSNumber class]]) {
                if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                    NSString *money = resposeObject[@"money"];
                    if ([money isEqualToString:@"0"]) {
                        self.money.text = @"0";
                    } else {
                        NSInteger moneyNumber = [money integerValue];
                        self.money.text = [NSString stringWithFormat:@"%ld", moneyNumber];
                    }
                }
            } else if ([resposeObject[@"status"] isKindOfClass:[NSString class]]) {
                if ([resposeObject[@"status"] isEqualToString:@"0"]) {
                    NSString *money = resposeObject[@"money"];
                    if ([money isEqualToString:@"0"]) {
                        self.money.text = @"0";
                    } else {
                        NSInteger moneyNumber = [money integerValue];
                        self.money.text = [NSString stringWithFormat:@"%ld", moneyNumber];
                    }
                }
            } else {
                self.money.text = @"0";
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            self.money.text = @"0";
        }];
    } else {
        self.money.text = @"0";
    }
    
    
}

// 兑换收益按钮方法
- (void)buttonAction:(UIButton *)sender {
    CashViewController *cashVC = [[CashViewController alloc] init];
    [self.navigationController pushViewController:cashVC animated:YES];
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
