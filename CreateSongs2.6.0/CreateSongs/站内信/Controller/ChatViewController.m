////
////  ChatViewController.m
////  CreateSongs
////
////  Created by 爱写歌 on 16/8/31.
////  Copyright © 2016年 AXG. All rights reserved.
////
//
//#import "ChatViewController.h"
//#import "AXGHeader.h"
//#import "NavLeftButton.h"
//#import "KeychainItemWrapper.h"
//#import <Security/Security.h>
//#import "XWAFNetworkTool.h"
//#import "SixinViewController.h"
//#import "HYNoticeView.h"
//#import "ChatNavRightButton.h"
//#import "MBProgressHUD.h"
//
//@interface ChatViewController ()<EaseMessageViewControllerDataSource, EaseMessageViewControllerDelegate, UIPopoverPresentationControllerDelegate>
//
//@property (nonatomic, copy) NSString *myName;
//
//@property (nonatomic, strong) HYNoticeView *noticeTop;
//
//@property (nonatomic, strong) UIImageView *pingbiImage;
//
//@property (nonatomic, assign) BOOL isPingbi;
//
//@end
//
//@implementation ChatViewController
//
//- (void)viewDidLoad {
//    [super viewDidLoad];
//    // Do any additional setup after loading the view.
//    
//    [self getMyData];
//    
//    [self createBody];
//    
//    [[EaseBaseMessageCell appearance] setSendBubbleBackgroundImage:[[UIImage imageNamed:@"聊天右气泡"] stretchableImageWithLeftCapWidth:5 topCapHeight:25]];//设置发送气泡
//    [[EaseBaseMessageCell appearance] setRecvBubbleBackgroundImage:[[UIImage imageNamed:@"聊天左气泡"] stretchableImageWithLeftCapWidth:25 topCapHeight:25]];//设置接收气泡
//    
//    [[EaseBaseMessageCell appearance] setAvatarSize:45.f];//设置头像大小
//    [[EaseBaseMessageCell appearance] setAvatarCornerRadius:22.5f];//设置头像圆角
//    
//}
//
//#pragma mark - 界面
//- (void)createBody {
//    
//    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
//    [self.view addSubview:navView];
//    navView.backgroundColor = HexStringColor(@"#FFDC74");
//    
//    //    self.navLeftImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, 23, 18)];
//    UIImageView *navLeftImage = [[UIImageView alloc] initWithFrame:CGRectMake(16, 0, 23, 20)];
//    [navView addSubview:navLeftImage];
//    navLeftImage.center = CGPointMake(navLeftImage.centerX, 42);
//    
//    NavLeftButton *navLeftButton = [NavLeftButton buttonWithType:UIButtonTypeCustom];
//    navLeftButton.frame = CGRectMake(0, 0, 64, 64);
//    [navView addSubview:navLeftButton];
//    navLeftButton.backgroundColor = [UIColor clearColor];
//    
//    [navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
//    [navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
//    [navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    ChatNavRightButton *navRightButton = [ChatNavRightButton new];
//    [navView addSubview:navRightButton];
//    navRightButton.frame = CGRectMake(self.view.width - 64, 0, 64, 64);
//    [navRightButton setImage:[UIImage imageNamed:@"屏蔽"] forState:UIControlStateNormal];
//    [navRightButton setImage:[UIImage imageNamed:@"屏蔽_高亮"] forState:UIControlStateHighlighted];
//    [navRightButton addTarget:self action:@selector(rightButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    
//    UILabel *navTitle = [[UILabel alloc] initWithFrame:CGRectMake(55, 0, self.view.width - 110, 44)];
//    [navView addSubview:navTitle];
//    navTitle.center = CGPointMake(navTitle.centerX, navLeftImage.centerY);
//    navTitle.textColor = HexStringColor(@"#441D11");
//    navTitle.textAlignment = NSTextAlignmentCenter;
//    [navTitle setFont:TECU_FONT(18)];
//    
//    navTitle.text = self.leftNameFromSuper;
//    
//}
//
//#pragma mark - Action
//
//// 获取是否屏蔽
//- (void)Pingbi {
//    
//    self.isPingbi = NO;
//    
//    EMError *error = nil;
//    NSArray *blacklist = [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
//    if (!error) {
//        if ([blacklist containsObject:self.conversation.conversationId]) {
//            self.isPingbi = YES;
//        }
//    }
//}
//
//// 右侧按钮方法
//- (void)rightButtonAction:(UIButton *)sender {
//    
//    
//    if (self.pingbiImage.superview == self.view) {
//        [self.pingbiImage removeFromSuperview];
//    } else {
//        CGFloat navH = kDevice_Is_iPhoneX ? 88 : 64;
//        self.pingbiImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.view.width - 80 * WIDTH_NIT - 16 * WIDTH_NIT, navH + 5 * WIDTH_NIT, 80 * WIDTH_NIT, 34 * WIDTH_NIT)];
//        [self.view addSubview:self.pingbiImage];
//        self.pingbiImage.image = [UIImage imageNamed:@"屏蔽_弹窗"];
//        
//        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(2 * WIDTH_NIT, 6 * WIDTH_NIT, 80 * WIDTH_NIT - 4 * WIDTH_NIT, 30 * WIDTH_NIT - 4 * WIDTH_NIT)];
//        [self.pingbiImage addSubview:label];
//        label.textAlignment = NSTextAlignmentCenter;
//        label.font = JIACU_FONT(12);
//        label.textColor = HexStringColor(@"#441D11");
//        label.backgroundColor = HexStringColor(@"#ffffff");
//        
//        if (self.isPingbi) {
//            label.text = @"取消屏蔽";
////            self.pingbiImage.backgroundColor = [UIColor redColor];
//        } else {
//            label.text = @"屏蔽";
////            self.pingbiImage.backgroundColor = [UIColor clearColor];
//        }
//        
//        
//        self.pingbiImage.userInteractionEnabled = YES;
//        self.pingbiImage.hidden = YES;
//        [self pingbiShowAction:self.pingbiImage];
//        
//        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(pingbiClickAction)];
//        [self.pingbiImage addGestureRecognizer:tap];
//        
//    }
//    
//    
//    
////    if (self.noticeTop.superview == self.view) {
////        [self.noticeTop removeFromSuperview];
////    } else {
////        self.noticeTop = [[HYNoticeView alloc] initWithFrame:CGRectMake(300 * WIDTH_NIT, 66, 60 * WIDTH_NIT, 30 * WIDTH_NIT) text:@"屏蔽" position:HYNoticeViewPositionTop];
////        [self.noticeTop showType:HYNoticeTypeTestTop inView:self.view after:0 duration:0.6 options:UIViewAnimationOptionTransitionFlipFromTop];
////        
////        WEAK_SELF;
////        self.noticeTop.noticeClick = ^() {
////            NSLog(@"noticeClick!!");
////            STRONG_SELF;
////            
////            EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:self.conversation.conversationId relationshipBoth:YES];
////            if (!error) {
////                NSLog(@"发送成功");
////            }
////            
////        };
////    }
//
//}
//
//// 显示屏蔽方法
//- (void)pingbiShowAction:(UIImageView *)imageView {
//    [UIView animateWithDuration:0.25 delay:0 options:UIViewAnimationOptionTransitionFlipFromTop animations:^{
//        imageView.hidden = NO;
//    } completion:^(BOOL finished) {
//        
//    }];
//}
//
//// 点击屏蔽方法
//- (void)pingbiClickAction {
//    [self.pingbiImage removeFromSuperview];
//    
//    if (self.isPingbi) {
//        
//        EMError *error2 = [[EMClient sharedClient].contactManager removeUserFromBlackList:self.conversation.conversationId];
//        if (!error2) {
//            NSLog(@"取消屏蔽成功");
//            [MBProgressHUD showSuccess:@"已取消屏蔽"];
//            self.isPingbi = NO;
//        }
//        
//    } else {
//        EMError *error = [[EMClient sharedClient].contactManager addUserToBlackList:self.conversation.conversationId relationshipBoth:YES];
//        if (!error) {
//            NSLog(@"屏蔽成功");
//            [MBProgressHUD showSuccess:@"已屏蔽"];
//            self.isPingbi = YES;
//        }
//    }
//    
//}
//
//
//// 获取自己的信息
//- (void)getMyData {
//    
//    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
//    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
//    NSString *phone = [wrapper objectForKey:(id)kSecAttrAccount];
//    self.rightHeadImgFromSuper = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:phone]];
//    
//    WEAK_SELF;
//    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//        STRONG_SELF;
//        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
//            self.myName = resposeObject[@"name"];
//        }
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//    
//}
//
//// 返回按钮方法
//- (void)backButtonAction:(UIButton *)sender {
//    [self.navigationController popViewControllerAnimated:YES];
//}
//
//// 重写发送消息方法
//- (void)sendTextMessage:(NSString *)text {
//    
//    NSDictionary *ext = @{@"head_img":self.rightHeadImgFromSuper, @"nick_name":self.myName, @"other_img":self.leftHeadImgFromSuper, @"other_name":self.leftNameFromSuper};
//    [self sendTextMessage:text withExt:ext];
//    
//    EMError *error = nil;
//    NSArray *blacklist = [[EMClient sharedClient].contactManager getBlackListFromServerWithError:&error];
//    if (!error) {
//        if ([blacklist containsObject:self.conversation.conversationId]) {
//            EMError *error2 = [[EMClient sharedClient].contactManager removeUserFromBlackList:self.conversation.conversationId];
//            if (!error2) {
//                NSLog(@"发送成功");
//                [MBProgressHUD showSuccess:@"已取消屏蔽"];
//                self.isPingbi = NO;
//            }
//        }
//    }
//}
//
//- (void)didReceiveMemoryWarning {
//    [super didReceiveMemoryWarning];
//    // Dispose of any resources that can be recreated.
//}
//
///*
//#pragma mark - Navigation
//
//// In a storyboard-based application, you will often want to do a little preparation before navigation
//- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
//    // Get the new view controller using [segue destinationViewController].
//    // Pass the selected object to the new view controller.
//}
//*/
//
//@end
