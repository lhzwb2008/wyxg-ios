//
//  TotalMsgViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/23.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "TotalMsgViewController.h"
#import "AXGHeader.h"
#import "TotalMsgButton.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "MsgModel.h"
#import "MsgViewController.h"
#import "CreateSongs-Swift.h"
#import "AXGTools.h"
#import "EMClient.h"
#import "SixinViewController.h"
#import "LoginViewController.h"

@interface TotalMsgViewController ()

@property (nonatomic, strong) NSMutableArray *commentsNotReadDataSource;

@property (nonatomic, strong) NSMutableArray *commentsReadDataSource;

@property (nonatomic, strong) NSMutableArray *zanNotReadDataSource;

@property (nonatomic, strong) NSMutableArray *zanReadDataSource;

@property (nonatomic, strong) NSMutableArray *giftNotReadDataSource;

@property (nonatomic, strong) NSMutableArray *giftReadDataSource;

@property (nonatomic, strong) NSMutableArray *friendNotReadDataSource;

@property (nonatomic, strong) NSMutableArray *friendReadDataSource;

@property (nonatomic, strong) UILabel *commentsLabel;

@property (nonatomic, strong) UILabel *zanLabel;

@property (nonatomic, strong) UILabel *giftLabel;

@property (nonatomic, strong) UILabel *friendLabel;

@property (nonatomic, strong) UILabel *sixinLabel;

@property (nonatomic, assign) CGRect originRect;

@end

@implementation TotalMsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = HexStringColor(@"#eeeeee");
    
    self.commentsNotReadDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.commentsReadDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.zanNotReadDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.zanNotReadDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.giftNotReadDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.giftReadDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    self.friendNotReadDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.friendReadDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initNavView];
    
    [self initView];
    
    [self createEdgePanView];
    
    [self.view bringSubviewToFront:self.navView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getSixinData) name:@"didReceiveMessage" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self getMsgData];
    [self getSixinData];
}

#pragma mark - 初始化界面

- (void)initNavView {
    [super initNavView];
    
    self.navTitle.text = @"消息";
    [self.navLeftButton setImage:[UIImage imageNamed:@"菜单icon"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"菜单_高亮"] forState:UIControlStateHighlighted];
    [self.navLeftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
}

// 创建打开手势界面
- (void)createEdgePanView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 20, self.view.height - 64)];
    //    view.backgroundColor = [UIColor redColor];
    [self.view addSubview:view];
    
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonAction)];
    edgePan.edges = UIRectEdgeLeft;
    [view addGestureRecognizer:edgePan];
}

- (void)initView {
    
    // 私信和评论图标互换
    
    TotalMsgButton *sixinButton = [TotalMsgButton buttonWithType:UIButtonTypeCustom];
    sixinButton.frame = CGRectMake(0, 64 + 15 * WIDTH_NIT, self.view.width, 55 * WIDTH_NIT);
    [sixinButton setImage:[UIImage imageNamed:@"站内信_评论"] forState:UIControlStateNormal];
    [sixinButton setTitle:@"私信" forState:UIControlStateNormal];
    sixinButton.tag = 104;
    [sixinButton addTarget:self action:@selector(msgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:sixinButton];
    
    TotalMsgButton *commentsButton = [TotalMsgButton buttonWithType:UIButtonTypeCustom];
    commentsButton.frame = CGRectMake(0, sixinButton.bottom, sixinButton.width, sixinButton.height);
    [commentsButton setImage:[UIImage imageNamed:@"站内信_私信"] forState:UIControlStateNormal];
    [commentsButton setTitle:@"评论" forState:UIControlStateNormal];
    commentsButton.tag = 101;
    [commentsButton addTarget:self action:@selector(msgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:commentsButton];
    
    TotalMsgButton *zanButton = [TotalMsgButton buttonWithType:UIButtonTypeCustom];
    zanButton.frame = CGRectMake(0, commentsButton.bottom, self.view.width, commentsButton.height);
    [zanButton setImage:[UIImage imageNamed:@"站内信_点赞"] forState:UIControlStateNormal];
    [zanButton setTitle:@"点赞" forState:UIControlStateNormal];
    zanButton.tag = 100;
    [zanButton addTarget:self action:@selector(msgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:zanButton];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, sixinButton.bottom, self.view.width - 16 * WIDTH_NIT, 1)];
    [self.view addSubview:lineView];
    lineView.backgroundColor = HexStringColor(@"#eeeeee");
    
    UIView *lineView1 = [[UIView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, commentsButton.bottom, self.view.width - 16 * WIDTH_NIT, 1)];
    [self.view addSubview:lineView1];
    lineView1.backgroundColor = HexStringColor(@"#eeeeee");
    
    TotalMsgButton *giftButton = [TotalMsgButton buttonWithType:UIButtonTypeCustom];
    giftButton.frame = CGRectMake(0, zanButton.bottom + 15 * WIDTH_NIT, self.view.width, zanButton.height);
    [giftButton setImage:[UIImage imageNamed:@"站内信_礼物"] forState:UIControlStateNormal];
    [giftButton setTitle:@"礼物" forState:UIControlStateNormal];
    giftButton.tag = 103;
    [giftButton addTarget:self action:@selector(msgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:giftButton];
    
    TotalMsgButton *friendButton = [TotalMsgButton buttonWithType:UIButtonTypeCustom];
    friendButton.frame = CGRectMake(0, giftButton.bottom, self.view.width, giftButton.height);
    [friendButton setImage:[UIImage imageNamed:@"站内信_好友"] forState:UIControlStateNormal];
    [friendButton setTitle:@"新的朋友" forState:UIControlStateNormal];
    friendButton.tag = 102;
    [friendButton addTarget:self action:@selector(msgButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:friendButton];
    
    UIView *lineView2 = [[UIView alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, giftButton.bottom, self.view.width - 16 * WIDTH_NIT, 1)];
    [self.view addSubview:lineView2];
    lineView2.backgroundColor = HexStringColor(@"#eeeeee");
    
    self.commentsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 16 * WIDTH_NIT - 20 * WIDTH_NIT, 0, 0, 20 * WIDTH_NIT)];
    self.commentsLabel.center = CGPointMake(self.commentsLabel.centerX, commentsButton.height / 2);
    [commentsButton addSubview:self.commentsLabel];
    self.commentsLabel.textAlignment = NSTextAlignmentCenter;
    self.commentsLabel.backgroundColor = HexStringColor(@"#cc2424");
    self.commentsLabel.textColor = HexStringColor(@"#ffffff");
    self.commentsLabel.font = ZHONGDENG_FONT(12);
    self.commentsLabel.text = @"0";
    self.commentsLabel.layer.cornerRadius = self.commentsLabel.height / 2;
    self.commentsLabel.layer.masksToBounds = YES;
    
    self.zanLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 16 * WIDTH_NIT - 20 * WIDTH_NIT, 0, 0, 20 * WIDTH_NIT)];
    self.zanLabel.center = CGPointMake(self.zanLabel.centerX, zanButton.height / 2);
    [zanButton addSubview:self.zanLabel];
    self.zanLabel.textAlignment = NSTextAlignmentCenter;
    self.zanLabel.backgroundColor = HexStringColor(@"#cc2424");
    self.zanLabel.textColor = HexStringColor(@"#ffffff");
    self.zanLabel.font = ZHONGDENG_FONT(12);
    self.zanLabel.text = @"0";
    self.zanLabel.layer.cornerRadius = self.zanLabel.height / 2;
    self.zanLabel.layer.masksToBounds = YES;
    
    self.originRect = self.zanLabel.frame;
    
    self.giftLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 16 * WIDTH_NIT - 20 * WIDTH_NIT, 0, 0, 20 * WIDTH_NIT)];
    self.giftLabel.center = CGPointMake(self.giftLabel.centerX, giftButton.height / 2);
    [giftButton addSubview:self.giftLabel];
    self.giftLabel.textAlignment = NSTextAlignmentCenter;
    self.giftLabel.backgroundColor = HexStringColor(@"#cc2424");
    self.giftLabel.textColor = HexStringColor(@"#ffffff");
    self.giftLabel.font = ZHONGDENG_FONT(12);
    self.giftLabel.text = @"0";
    self.giftLabel.layer.cornerRadius = self.giftLabel.height / 2;
    self.giftLabel.layer.masksToBounds = YES;
    
    self.friendLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 16 * WIDTH_NIT - 20 * WIDTH_NIT, 0, 0, 20 * WIDTH_NIT)];
    self.friendLabel.center = CGPointMake(self.friendLabel.centerX, friendButton.height / 2);
    [friendButton addSubview:self.friendLabel];
    self.friendLabel.textAlignment = NSTextAlignmentCenter;
    self.friendLabel.backgroundColor = HexStringColor(@"#cc2424");
    self.friendLabel.textColor = HexStringColor(@"#ffffff");
    self.friendLabel.font = ZHONGDENG_FONT(12);
    self.friendLabel.text = @"0";
    self.friendLabel.layer.cornerRadius = self.friendLabel.height / 2;
    self.friendLabel.layer.masksToBounds = YES;
    
    self.sixinLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 16 * WIDTH_NIT - 20 * WIDTH_NIT, 0, 0, 20 * WIDTH_NIT)];
    self.sixinLabel.center = CGPointMake(self.sixinLabel.centerX, sixinButton.height / 2);
    [sixinButton addSubview:self.sixinLabel];
    self.sixinLabel.textAlignment = NSTextAlignmentCenter;
    self.sixinLabel.backgroundColor = HexStringColor(@"#cc2424");
    self.sixinLabel.textColor = HexStringColor(@"#ffffff");
    self.sixinLabel.font = ZHONGDENG_FONT(12);
    self.sixinLabel.text = @"0";
    self.sixinLabel.layer.cornerRadius = self.friendLabel.height / 2;
    self.sixinLabel.layer.masksToBounds = YES;
    
}

#pragma mark - Action

// 返回按钮方法
- (void)backButtonAction {
    KYDrawerController *drawerVC = (KYDrawerController *)self.navigationController.parentViewController;
    
    [drawerVC setDrawerState:DrawerStateOpened animated:YES];
}

// 站内信按钮方法
- (void)msgButtonAction:(UIButton *)sender {
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        MsgViewController *msgVC = [[MsgViewController alloc] init];
        
        NSMutableArray *notReadArr = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *readArr = [[NSMutableArray alloc] initWithCapacity:0];
        NSMutableArray *mutArray = [[NSMutableArray alloc] initWithCapacity:0];
        
        NSInteger index = sender.tag - 100;
        switch (index) {
            case 0: {
                
                for (MsgModel *model in self.zanNotReadDataSource) {
                    [notReadArr addObject:model];
                    [mutArray addObject:model];
                }
                for (MsgModel *model in self.zanReadDataSource) {
                    [readArr addObject:model];
                    [mutArray addObject:model];
                }
                
                msgVC.notReadArray = notReadArr;
                msgVC.readArray = readArr;
                msgVC.totalArray = mutArray;
                
                [self.navigationController pushViewController:msgVC animated:YES];
                
            }
                break;
            case 1: {
                
                for (MsgModel *model in self.commentsNotReadDataSource) {
                    [notReadArr addObject:model];
                    [mutArray addObject:model];
                }
                for (MsgModel *model in self.commentsReadDataSource) {
                    [readArr addObject:model];
                    [mutArray addObject:model];
                }
                
                msgVC.notReadArray = notReadArr;
                msgVC.readArray = readArr;
                msgVC.totalArray = mutArray;
                
                [self.navigationController pushViewController:msgVC animated:YES];
                
            }
                break;
            case 2: {
                
                for (MsgModel *model in self.friendNotReadDataSource) {
                    [notReadArr addObject:model];
                    [mutArray addObject:model];
                }
                for (MsgModel *model in self.friendReadDataSource) {
                    [readArr addObject:model];
                    [mutArray addObject:model];
                }
                
                msgVC.notReadArray = notReadArr;
                msgVC.readArray = readArr;
                msgVC.totalArray = mutArray;
                
                [self.navigationController pushViewController:msgVC animated:YES];
                
            }
                break;
            case 3: {
                
                for (MsgModel *model in self.giftNotReadDataSource) {
                    [notReadArr addObject:model];
                    [mutArray addObject:model];
                }
                for (MsgModel *model in self.giftReadDataSource) {
                    [readArr addObject:model];
                    [mutArray addObject:model];
                }
                
                msgVC.notReadArray = notReadArr;
                msgVC.readArray = readArr;
                msgVC.totalArray = mutArray;
                
                [self.navigationController pushViewController:msgVC animated:YES];
                
            }
                break;
            case 4: {
                
                SixinViewController *sixinVC = [[SixinViewController alloc] init];
                [self.navigationController pushViewController:sixinVC animated:YES];
                
            }
                break;
                
            default:
                break;
        }
    } else {
        AXG_LOGIN(LOGIN_LOCATION_PERSON_CENTER);
    }
}

// 获取私信数据
- (void)getSixinData {
    
    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
    NSInteger unreadCount = 0;
    for (EMConversation *conversation in conversations) {
        unreadCount += conversation.unreadMessagesCount;
    }
    
    CGFloat width1 = [AXGTools getTextWidth:@"6" font:ZHONGDENG_FONT(12)];
    CGFloat width2 = [AXGTools getTextWidth:@"66" font:ZHONGDENG_FONT(12)];
    CGFloat width3 = [AXGTools getTextWidth:@"99+" font:ZHONGDENG_FONT(12)];
    
    if (unreadCount <= 0) {
        self.sixinLabel.text = @"0";
        self.sixinLabel.frame = CGRectMake(self.originRect.origin.x, self.originRect.origin.y, 0, self.originRect.size.height);
    } else if (unreadCount < 10) {
        self.sixinLabel.text = [NSString stringWithFormat:@"%ld", unreadCount];
        self.sixinLabel.frame = CGRectMake(self.originRect.origin.x, self.originRect.origin.y, 20 * WIDTH_NIT, self.originRect.size.height);
    } else if (unreadCount <= 99) {
        self.sixinLabel.text = [NSString stringWithFormat:@"%ld", unreadCount];
        self.sixinLabel.frame = CGRectMake(self.originRect.origin.x - (width2 - width1), self.originRect.origin.y, 20 * WIDTH_NIT + (width2 - width1), self.originRect.size.height);
    } else {
        self.sixinLabel.text = @"99+";
        self.sixinLabel.frame = CGRectMake(self.originRect.origin.x - (width3 - width1), self.originRect.origin.y, 20 * WIDTH_NIT + (width3 - width1), self.originRect.size.height);
    }
    
}

// 获取站内信消息
- (void)getMsgData {
    
    [self.commentsNotReadDataSource removeAllObjects];
    [self.commentsReadDataSource removeAllObjects];
    
    [self.zanNotReadDataSource removeAllObjects];
    [self.zanReadDataSource removeAllObjects];
    
    [self.giftNotReadDataSource removeAllObjects];
    [self.giftReadDataSource removeAllObjects];
    
    [self.friendNotReadDataSource removeAllObjects];
    [self.friendReadDataSource removeAllObjects];
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        
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
                    
                    MsgModel *model = [[MsgModel alloc] initWithDictionary:dic error:nil];
                    
                    if ([model.is_read isEqualToString:@"1"]) {
                        
                        if ([model.type isEqualToString:@"0"]) {
                            [self.zanReadDataSource addObject:model];
                        } else if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"3"]) {
                            [self.commentsReadDataSource addObject:model];
                        } else if ([model.type isEqualToString:@"2"]) {
                            [self.friendReadDataSource addObject:model];
                        } else if ([model.type isEqualToString:@"5"]) {
                            [self.giftReadDataSource addObject:model];
                        }
                        
                    } else {
                        
                        if ([model.type isEqualToString:@"0"]) {
                            [self.zanNotReadDataSource addObject:model];
                        } else if ([model.type isEqualToString:@"1"] || [model.type isEqualToString:@"3"]) {
                            [self.commentsNotReadDataSource addObject:model];
                        } else if ([model.type isEqualToString:@"2"]) {
                            [self.friendNotReadDataSource addObject:model];
                        } else if ([model.type isEqualToString:@"5"]) {
                            [self.giftNotReadDataSource addObject:model];
                        }
                        
                    }
                }
                
                CGFloat width1 = [AXGTools getTextWidth:@"6" font:ZHONGDENG_FONT(12)];
                CGFloat width2 = [AXGTools getTextWidth:@"66" font:ZHONGDENG_FONT(12)];
                CGFloat width3 = [AXGTools getTextWidth:@"99+" font:ZHONGDENG_FONT(12)];
                
                if (self.commentsNotReadDataSource.count <= 0) {
                    self.commentsLabel.text = @"0";
                    self.commentsLabel.frame = CGRectMake(self.originRect.origin.x, self.originRect.origin.y, 0, self.originRect.size.height);
                } else if (self.commentsNotReadDataSource.count < 10) {
                    self.commentsLabel.text = [NSString stringWithFormat:@"%ld", self.commentsNotReadDataSource.count];
                    self.commentsLabel.frame = CGRectMake(self.originRect.origin.x, self.originRect.origin.y, 20 * WIDTH_NIT, self.originRect.size.height);
                } else if (self.commentsNotReadDataSource.count <= 99) {
                    self.commentsLabel.text = [NSString stringWithFormat:@"%ld", self.commentsNotReadDataSource.count];
                    self.commentsLabel.frame = CGRectMake(self.originRect.origin.x - (width2 - width1), self.originRect.origin.y, 20 * WIDTH_NIT + (width2 - width1), self.originRect.size.height);
                } else {
                    self.commentsLabel.text = @"99+";
                    self.commentsLabel.frame = CGRectMake(self.originRect.origin.x - (width3 - width1), self.originRect.origin.y, 20 * WIDTH_NIT + (width3 - width1), self.originRect.size.height);
                }
                
                if (self.zanNotReadDataSource.count <= 0) {
                    self.zanLabel.text = @"0";
                    self.zanLabel.frame = CGRectMake(self.originRect.origin.x, self.originRect.origin.y, 0, self.originRect.size.height);
                } else if (self.zanNotReadDataSource.count < 10) {
                    self.zanLabel.text = [NSString stringWithFormat:@"%ld", self.zanNotReadDataSource.count];
                    self.zanLabel.frame = CGRectMake(self.originRect.origin.x, self.originRect.origin.y, 20 * WIDTH_NIT, self.originRect.size.height);
                } else if (self.zanNotReadDataSource.count <= 99) {
                    self.zanLabel.text = [NSString stringWithFormat:@"%ld", self.zanNotReadDataSource.count];
                    self.zanLabel.frame = CGRectMake(self.originRect.origin.x - (width2 - width1), self.originRect.origin.y, 20 * WIDTH_NIT + (width2 - width1), self.originRect.size.height);
                } else {
                    self.zanLabel.text = @"99+";
                    self.zanLabel.frame = CGRectMake(self.originRect.origin.x - (width3 - width1), self.originRect.origin.y, 20 * WIDTH_NIT + (width3 - width1), self.originRect.size.height);
                }
                
                if (self.giftNotReadDataSource.count <= 0) {
                    self.giftLabel.text = @"0";
                    self.giftLabel.frame = CGRectMake(self.originRect.origin.x, self.originRect.origin.y, 0, self.originRect.size.height);
                } else if (self.giftNotReadDataSource.count < 10) {
                    self.giftLabel.text = [NSString stringWithFormat:@"%ld", self.giftNotReadDataSource.count];
                    self.giftLabel.frame = CGRectMake(self.originRect.origin.x, self.originRect.origin.y, 20 * WIDTH_NIT, self.originRect.size.height);
                } else if (self.giftNotReadDataSource.count <= 99) {
                    self.giftLabel.text = [NSString stringWithFormat:@"%ld", self.giftNotReadDataSource.count];
                    self.giftLabel.frame = CGRectMake(self.originRect.origin.x - (width2 - width1), self.originRect.origin.y, 20 * WIDTH_NIT + (width2 - width1), self.originRect.size.height);
                } else {
                    self.giftLabel.text = @"99+";
                    self.giftLabel.frame = CGRectMake(self.originRect.origin.x - (width3 - width1), self.originRect.origin.y, 20 * WIDTH_NIT + (width3 - width1), self.originRect.size.height);
                }
                
                if (self.friendNotReadDataSource.count <= 0) {
                    self.friendLabel.text = @"0";
                    self.friendLabel.frame = CGRectMake(self.originRect.origin.x, self.originRect.origin.y, 0, self.originRect.size.height);
                } else if (self.friendNotReadDataSource.count < 10) {
                    self.friendLabel.text = [NSString stringWithFormat:@"%ld", self.friendNotReadDataSource.count];
                    self.friendLabel.frame = CGRectMake(self.originRect.origin.x, self.originRect.origin.y, 20 * WIDTH_NIT, self.originRect.size.height);
                } else if (self.friendNotReadDataSource.count <= 99) {
                    self.friendLabel.text = [NSString stringWithFormat:@"%ld", self.friendNotReadDataSource.count];
                    self.friendLabel.frame = CGRectMake(self.originRect.origin.x - (width2 - width1), self.originRect.origin.y, 20 * WIDTH_NIT + (width2 - width1), self.originRect.size.height);
                } else {
                    self.friendLabel.text = @"99+";
                    self.friendLabel.frame = CGRectMake(self.originRect.origin.x - (width3 - width1), self.originRect.origin.y, 20 * WIDTH_NIT + (width3 - width1), self.originRect.size.height);
                }
                
//                if (self.commentsNotReadDataSource.count <= 0) {
//                    self.commentsLabel.text = @"0";
//                    self.commentsLabel.frame = CGRectMake(self.originRect.origin.x, self.commentsLabel.origin.y, 0, self.originRect.size.height);
//                } else if (self.commentsNotReadDataSource.count < 10) {
//                    self.commentsLabel.text = [NSString stringWithFormat:@"%ld", self.commentsNotReadDataSource.count];
//                    self.commentsLabel.frame = CGRectMake(self.commentsLabel.origin.x, self.commentsLabel.origin.y, 20 * WIDTH_NIT, self.commentsLabel.size.height);
//                } else if (self.commentsNotReadDataSource.count <= 99) {
//                    self.commentsLabel.text = [NSString stringWithFormat:@"%ld", self.commentsNotReadDataSource.count];
//                    self.commentsLabel.frame = CGRectMake(self.commentsLabel.origin.x - (width2 - width1), self.commentsLabel.origin.y, 20 * WIDTH_NIT + (width2 - width1), self.commentsLabel.size.height);
//                } else {
//                    self.commentsLabel.text = @"99+";
//                    self.commentsLabel.frame = CGRectMake(self.commentsLabel.origin.x - (width3 - width1), self.commentsLabel.origin.y, 20 * WIDTH_NIT + (width3 - width1), self.commentsLabel.size.height);
//                }
//                
//                if (self.zanNotReadDataSource.count <= 0) {
//                    self.zanLabel.text = @"0";
//                    self.zanLabel.frame = CGRectMake(self.zanLabel.origin.x, self.zanLabel.origin.y, 0, self.zanLabel.size.height);
//                } else if (self.zanNotReadDataSource.count < 10) {
//                    self.zanLabel.text = [NSString stringWithFormat:@"%ld", self.zanNotReadDataSource.count];
//                    self.zanLabel.frame = CGRectMake(self.zanLabel.origin.x, self.zanLabel.origin.y, 20 * WIDTH_NIT, self.zanLabel.size.height);
//                } else if (self.zanNotReadDataSource.count <= 99) {
//                    self.zanLabel.text = [NSString stringWithFormat:@"%ld", self.zanNotReadDataSource.count];
//                    self.zanLabel.frame = CGRectMake(self.originRect.origin.x - (width2 - width1), self.zanLabel.origin.y, 20 * WIDTH_NIT + (width2 - width1), self.zanLabel.size.height);
//                } else {
//                    self.zanLabel.text = @"99+";
//                    self.zanLabel.frame = CGRectMake(self.zanLabel.origin.x - (width3 - width1), self.zanLabel.origin.y, 20 * WIDTH_NIT + (width3 - width1), self.zanLabel.size.height);
//                }
//                
//                if (self.giftNotReadDataSource.count <= 0) {
//                    self.giftLabel.text = @"0";
//                    self.giftLabel.frame = CGRectMake(self.giftLabel.origin.x, self.giftLabel.origin.y, 0, self.giftLabel.size.height);
//                } else if (self.giftNotReadDataSource.count < 10) {
//                    self.giftLabel.text = [NSString stringWithFormat:@"%ld", self.giftNotReadDataSource.count];
//                    self.giftLabel.frame = CGRectMake(self.giftLabel.origin.x, self.giftLabel.origin.y, 20 * WIDTH_NIT, self.giftLabel.size.height);
//                } else if (self.giftNotReadDataSource.count <= 99) {
//                    self.giftLabel.text = [NSString stringWithFormat:@"%ld", self.giftNotReadDataSource.count];
//                    self.giftLabel.frame = CGRectMake(self.giftLabel.origin.x - (width2 - width1), self.giftLabel.origin.y, 20 * WIDTH_NIT + (width2 - width1), self.giftLabel.size.height);
//                } else {
//                    self.giftLabel.text = @"99+";
//                    self.giftLabel.frame = CGRectMake(self.giftLabel.origin.x - (width3 - width1), self.giftLabel.origin.y, 20 * WIDTH_NIT + (width3 - width1), self.giftLabel.size.height);
//                }
//                
//                if (self.friendNotReadDataSource.count <= 0) {
//                    self.friendLabel.text = @"0";
//                    self.friendLabel.frame = CGRectMake(self.friendLabel.origin.x, self.friendLabel.origin.y, 0, self.friendLabel.size.height);
//                } else if (self.friendNotReadDataSource.count < 10) {
//                    self.friendLabel.text = [NSString stringWithFormat:@"%ld", self.friendNotReadDataSource.count];
//                    self.friendLabel.frame = CGRectMake(self.friendLabel.origin.x, self.friendLabel.origin.y, 20 * WIDTH_NIT, self.friendLabel.size.height);
//                } else if (self.friendNotReadDataSource.count <= 99) {
//                    self.friendLabel.text = [NSString stringWithFormat:@"%ld", self.friendNotReadDataSource.count];
//                    self.friendLabel.frame = CGRectMake(self.friendLabel.origin.x - (width2 - width1), self.friendLabel.origin.y, 20 * WIDTH_NIT + (width2 - width1), self.friendLabel.size.height);
//                } else {
//                    self.friendLabel.text = @"99+";
//                    self.friendLabel.frame = CGRectMake(self.friendLabel.origin.x - (width3 - width1), self.friendLabel.origin.y, 20 * WIDTH_NIT + (width3 - width1), self.friendLabel.size.height);
//                }
                
                
            } else {

            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {

        }];
    } else {

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
