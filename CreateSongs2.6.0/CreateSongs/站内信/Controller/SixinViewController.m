//
//  SixinViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/31.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SixinViewController.h"
//#import "EMClient.h"
#import "ConversationModel.h"
//#import "EMSDK.h"
#import "SixinTableViewCell.h"
//#import "ChatViewController.h"
#import "KeychainItemWrapper.h"

static NSString *const identifier = @"identifier";

@interface SixinViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) NSMutableArray *conversationDataSource;

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation SixinViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.conversationDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self inittableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getData) name:@"didReceiveMessage" object:nil];
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self getData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
}

#pragma mark - 初始化界面

- (void)initNavView {
    [super initNavView];
    
    self.navTitle.text = @"会话";
    
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 初始化tableView
- (void)inittableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[SixinTableViewCell class] forCellReuseIdentifier:identifier];
}

#pragma mark - Action

// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

// 获取数据
- (void)getData {
    
//    EMError *error = [[EMClient sharedClient] loginWithUsername:@"17707" password:@"000"];
//    if (!error) {
//        NSLog(@"登录成功");
//        [[EMClient sharedClient].options setIsAutoLogin:YES];
//    } else {
//        NSLog(@"登录失败 %@", error.description);
//    }
    
//    NSMutableArray *mutArray = [[NSMutableArray alloc] initWithCapacity:0];
//
//    NSArray *conversations = [[EMClient sharedClient].chatManager getAllConversations];
//    for (EMConversation *conversation in conversations) {
//
////        [[EMClient sharedClient].chatManager deleteConversation:conversation.conversationId isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
////
////        }];
//
//        NSString *unreadCount = @"";
//        NSString *imgUrl = @"";
//        NSString *nickName = @"";
//        NSString *content = @"";
//        NSString *timetamp = @"";
//        NSString *conversationID = @"";
//
//        unreadCount = [NSString stringWithFormat:@"%d", conversation.unreadMessagesCount];
//
//        if (conversation.lastReceivedMessage.ext[@"head_img"] && ([conversation.lastReceivedMessage.ext[@"head_img"] length] != 0)) {
//            imgUrl = conversation.lastReceivedMessage.ext[@"head_img"];
//        } else {
//            imgUrl = conversation.latestMessage.ext[@"other_img"];
//        }
//        if (conversation.lastReceivedMessage.ext[@"nick_name"] && ([conversation.lastReceivedMessage.ext[@"nick_name"] length] != 0)) {
//            nickName = conversation.lastReceivedMessage.ext[@"nick_name"];
//        } else {
//            nickName = conversation.latestMessage.ext[@"other_name"];
//        }
//
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        [formatter setDateStyle:NSDateFormatterMediumStyle];
//        [formatter setTimeStyle:NSDateFormatterShortStyle];
//        [formatter setDateFormat:@"YYYY-MM-dd HH:mm:ss"];
//        NSDate *confromTimesp = nil;
//        if (conversation.lastReceivedMessage) {
//            confromTimesp = [NSDate dateWithTimeIntervalSince1970:conversation.lastReceivedMessage.timestamp / 1000.0];
//        } else {
//            confromTimesp = [NSDate dateWithTimeIntervalSince1970:conversation.latestMessage.timestamp / 1000.0];
//        }
//        timetamp = [formatter stringFromDate:confromTimesp];
//
//        conversationID = conversation.conversationId;
//
//        switch (conversation.lastReceivedMessage.body.type) {
//            case EMMessageBodyTypeText: {
//
//                EMTextMessageBody *messageBody = (EMTextMessageBody *)conversation.lastReceivedMessage.body;
//                content = messageBody.text;
//
//            }
//                break;
//            case EMMessageBodyTypeImage: {
//
//                content = @"[图片]";
//
//            }
//                break;
//            case EMMessageBodyTypeLocation: {
//
//                content = @"[位置]";
//
//            }
//
//            default:
//                break;
//        }
//
//        NSDictionary *dic = @{@"unreadCount":unreadCount, @"imgUrl":imgUrl, @"nickName":nickName, @"content":content, @"timetamp":timetamp, @"conversationID":conversationID};
//        ConversationModel *model = [[ConversationModel alloc] initWithDictionary:dic error:nil];
//
//        if (conversation.unreadMessagesCount != 0) {
//            [mutArray insertObject:model atIndex:0];
//        } else {
//            [mutArray addObject:model];
//        }
//    }
//
//    [self.conversationDataSource removeAllObjects];
//    [self.conversationDataSource addObjectsFromArray:mutArray];
//    [self.tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SixinTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (self.conversationDataSource.count > indexPath.row) {
        cell.model = self.conversationDataSource[indexPath.row];
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.conversationDataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65 * WIDTH_NIT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        SixinTableViewCell *cell = (SixinTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        ConversationModel *model = cell.model;
        
//        [[EMClient sharedClient].chatManager deleteConversation:model.conversationID isDeleteMessages:YES completion:^(NSString *aConversationId, EMError *aError) {
//
//        }];
        
        [self.conversationDataSource removeObject:model];
        
        [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
//    tableView.allowsSelection = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        tableView.allowsSelection = YES;
//    });
//
//    SixinTableViewCell *cell = (SixinTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//
//    NSLog(@"会话id %@", cell.model.conversationID);
//
//    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
//    NSString *phone = [wrapper objectForKey:(id)kSecAttrAccount];
//    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
//    NSString *rightImg = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:phone]];
//
//    if ([[EMClient sharedClient] isLoggedIn]) {
//        ChatViewController *chatView = [[ChatViewController alloc] initWithConversationChatter:cell.model.conversationID conversationType:EMConversationTypeChat];
//        chatView.leftNameFromSuper = cell.model.nickName;
//        chatView.leftHeadImgFromSuper = cell.model.imgUrl;
//        chatView.rightHeadImgFromSuper = rightImg;
//        [self.navigationController pushViewController:chatView animated:YES];
//    } else {
//        EMError *error = [[EMClient sharedClient] loginWithUsername:userId password:@"000"];
//        if (!error) {
//            NSLog(@"登录成功");
//
//            ChatViewController *chatView = [[ChatViewController alloc] initWithConversationChatter:cell.model.conversationID conversationType:EMConversationTypeChat];
//            chatView.leftNameFromSuper = cell.model.nickName;
//            chatView.leftHeadImgFromSuper = cell.model.imgUrl;
//            chatView.rightHeadImgFromSuper = rightImg;
//            [self.navigationController pushViewController:chatView animated:YES];
//
//        } else {
//            NSLog(@"登录失败 %@", error.description);
//        }
//    }
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
