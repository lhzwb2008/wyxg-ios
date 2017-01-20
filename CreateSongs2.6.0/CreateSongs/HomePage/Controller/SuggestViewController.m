//
//  SuggestViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/21.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SuggestViewController.h"
#import "SuggestionView.h"
//#import "UIViewController+MMDrawerController.h"
#import "SKPSMTPMessage.h"
#import <MessageUI/MessageUI.h>
#import "NSData+Base64Additions.h"
#import "XWBaseMethod.h"
#import "AXGMessage.h"
#import "CreateSongs-Swift.h"
//#import "KYDrawerController.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "EMSDK.h"

@interface SuggestViewController ()<SendSuggestionDelegate, SKPSMTPMessageDelegate>

@property (nonatomic, strong) SuggestionView *suggestView;

@end

@implementation SuggestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initNavView];
    [self createSuggestView];
    [self createLeftEdgeView];
    
    [self reloadMsg];
    
    [self.view bringSubviewToFront:self.navView];
    
    
}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
//    self.navLeftImage.image = [UIImage imageNamed:@"菜单icon"];
    [self.navLeftButton setImage:[UIImage imageNamed:@"菜单icon"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"菜单_高亮"] forState:UIControlStateHighlighted];
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navTitle.text = @"建议";
}

// 创建意见反馈界面
- (void)createSuggestView {
    self.suggestView = [[SuggestionView alloc] initWithFrame:self.view.bounds];
    [self.view addSubview:self.suggestView];
    self.suggestView.delegate = self;
}

// 创建左侧滑动界面
- (void)createLeftEdgeView {
    UIView *lefView = [[UIView alloc] initWithFrame:CGRectMake(0, 64, 20, self.view.height - 64)];
    [self.view addSubview:lefView];
    lefView.backgroundColor = [UIColor clearColor];
    
    UIScreenEdgePanGestureRecognizer *edgePan = [[UIScreenEdgePanGestureRecognizer alloc] initWithTarget:self action:@selector(backButtonAction:)];
    edgePan.edges = UIRectEdgeLeft;
    [lefView addGestureRecognizer:edgePan];
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

#pragma mark - SendSuggestionDelegate

- (void)sendMessageToByMail:(NSString *)content {
    [self sendSuggest:content];
}

- (void)sendSuggest:(NSString *)content {
    
    SKPSMTPMessage *testSend = [[SKPSMTPMessage alloc]init];
    testSend.fromEmail = EMAIL_UNAME;
    testSend.toEmail = EMAIL_SEND_TO;
    testSend.relayHost = EMAIL_HOST;
    testSend.requiresAuth = YES;
    testSend.login = EMAIL_UNAME;
    testSend.pass = EMAIL_PASSW;
    testSend.subject = [NSString stringWithCString:"来自“我要写歌(iOS)”用户反馈" encoding:NSUTF8StringEncoding];
    testSend.wantsSecure = YES;
    testSend.delegate = self;
    NSDictionary *plainPart = [NSDictionary dictionaryWithObjectsAndKeys:@"text/plain",kSKPSMTPPartContentTypeKey,
                               content,kSKPSMTPPartMessageKey,@"8bit",kSKPSMTPPartContentTransferEncodingKey,nil];
    testSend.parts = [NSArray arrayWithObjects:plainPart, nil];
    [testSend send];
}

#pragma mark - SKPSMTPMessageDelegate

-(void)messageSent:(SKPSMTPMessage *)message {
    NSLog(@"发送成功");
    self.suggestView.feedback.text = @"";
    self.suggestView.placeholderText.text = SUGEST_TXT;
    self.suggestView.contactText.text = @"";
    self.suggestView.submitButton.enabled = NO;
//    self.suggestView.submitButton.backgroundColor = SUB_UNABLE_COLOR;
    [XWBaseMethod hideHUDAddedTo:self.suggestView animated:YES];
//    [XWBaseMethod showSuccessWithStr:@"已发送" toView:self.suggestView];
    
    [AXGMessage showImageToastOnView:self.view image:[UIImage imageNamed:@"弹出框_提交成功"] type:0];
    
    // 发送成功返回首页
    [self performSelector:@selector(sendSuccess) withObject:nil afterDelay:0.7];
    
}

// 发送成功返回首页
- (void)sendSuccess {
    // 发送成功返回首页
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDrawerRoot" object:@"首页"];
    
}

-(void)messageFailed:(SKPSMTPMessage *)message error:(NSError *)error {
    if (error) {
        [XWBaseMethod hideHUDAddedTo:self.suggestView animated:YES];
        [XWBaseMethod showSuccessWithStr:@"发送超时" toView:self.suggestView];
        NSLog(@"%@", error.description);
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
