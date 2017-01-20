//
//  MsgViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/5/24.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "MsgViewController.h"
#import "AXGHeader.h"
#import "MsgTableViewCell.h"
#import "MsgModel.h"
#import "FMDatabase.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "PlayUserSongViewController.h"
#import "NSString+Emojize.h"
#import "SongModel.h"
#import "AppDelegate.h"
#import "OtherPersonCenterController.h"
#import "MobClick.h"

static NSString *const tableViewIdentifier = @"tableViewIdentifier";

@interface MsgViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UIImageView *noDataImage;

@property (nonatomic, strong) UILabel *noDataLabel;

@end

@implementation MsgViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    self.totalArray = [[NSMutableArray alloc] initWithCapacity:0];
//    self.readArray = [[NSMutableArray alloc] initWithCapacity:0];
//    self.notReadArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self createNoDataView];
    [self initNavView];
    [self createTabelView];
//    [self getData];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self.tableView reloadData];
    // 将所有信息设为已读
    for (MsgModel *msgModel in self.notReadArray) {
        
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:SET_READ, msgModel.nId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

#pragma mark - 初始化界面

- (void)initNavView {
    [super initNavView];
//    self.navLeftImage.image = [UIImage imageNamed:@"返回"];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    self.navTitle.text = @"消息";
}

- (void)createNoDataView {
    self.noDataImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 250 * HEIGHT_NIT, 160, 160)];
    self.noDataImage.center = CGPointMake(self.view.width / 2, self.noDataImage.centerY);
    self.noDataImage.image = [UIImage imageNamed:@"noDataMsg"];
    [self.view addSubview:self.noDataImage];
    
    
    self.noDataLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.noDataImage.left, self.noDataImage.bottom, self.noDataImage.width, 30)];
    self.noDataLabel.text = @"还没有消息哦";
    self.noDataLabel.textColor = HexStringColor(@"#a0a0a0");
    self.noDataLabel.textAlignment = NSTextAlignmentCenter;
    [self.view addSubview:self.noDataLabel];
    
    if (self.totalArray.count == 0) {
        self.noDataImage.hidden = NO;
        self.noDataLabel.hidden = NO;
    } else {
        self.noDataImage.hidden = YES;
        self.noDataLabel.hidden = YES;
    }
    
    
}

- (void)createTabelView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[MsgTableViewCell class] forCellReuseIdentifier:tableViewIdentifier];
//    self.tableView.tableHeaderView = [self getTableHeadView];
    
    [self.tableView reloadData];
}

- (UIView *)getTableHeadView {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 10)];
    view.backgroundColor = HexStringColor(@"#eeeeee");
    return view;
}

#pragma mark - Action
// 返回按钮方法
- (void)backButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)getData {
    
    NSLog(@"%@", [[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN]);
    
    if (![[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        self.noDataImage.hidden = NO;
        self.noDataLabel.hidden = NO;
        return;
    }
    
    // 获取用户id
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    
    NSMutableArray *readArray = [[NSMutableArray alloc] initWithCapacity:0];
    NSMutableArray *notReadArray = [[NSMutableArray alloc] initWithCapacity:0];
    
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_MESSAGE, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSArray *array = resposeObject[@"items"];
            for (NSDictionary *dic in array) {
                if ([dic[@"is_read"] isEqualToString:@"1"]) {
                    [readArray addObject:dic];
                } else {
                    [notReadArray addObject:dic];
                }
            }
            
            for (NSDictionary *dic in notReadArray) {
                MsgModel *msgModel = [[MsgModel alloc] initWithDictionary:dic error:nil];
                [self.notReadArray addObject:msgModel];
                [self.totalArray addObject:msgModel];
            }
            for (NSDictionary *dic in readArray) {
                MsgModel *msgModel = [[MsgModel alloc] initWithDictionary:dic error:nil];
                [self.readArray addObject:msgModel];
                [self.totalArray addObject:msgModel];
            }
            
            if (self.totalArray.count == 0) {
                self.noDataImage.hidden = NO;
                self.noDataLabel.hidden = NO;
            } else {
                self.noDataImage.hidden = YES;
                self.noDataLabel.hidden = YES;
            }
            
            [self.tableView reloadData];
            
        } else {
            self.noDataImage.hidden = NO;
            self.noDataLabel.hidden = NO;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.noDataImage.hidden = NO;
        self.noDataLabel.hidden = NO;
    }];
}

// 删除服务器的数据
- (void)deleteMsgFromService:(NSString *)dataId {
    NSLog(@"~~~~~~~%@", dataId);
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:DEl_MSG, dataId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSLog(@"删除成功");
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MsgTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:tableViewIdentifier];
    
    if (self.totalArray.count > indexPath.row) {
        
        MsgModel *msgModel = self.totalArray[indexPath.row];
        
        NSLog(@"%@ %@ %@ %@ %@ %@", msgModel.create_time, msgModel.type, msgModel.nId, msgModel.receive_id, msgModel.send_id, msgModel.song_id);
        
        cell.msgModel = msgModel;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.totalArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 32 * HEIGHT_NIT + 35;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        MsgModel *model = self.totalArray[indexPath.row];
        [self deleteMsgFromService:model.nId];
        [self.totalArray removeObjectAtIndex:indexPath.row];
        
        if (self.totalArray.count == 0) {
            self.noDataImage.hidden = NO;
            self.noDataLabel.hidden = NO;
        }
        
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    MsgModel *msgModel = self.totalArray[indexPath.row];
    
    if ([msgModel.type isEqualToString:@"0"] || [msgModel.type isEqualToString:@"1"] || [msgModel.type isEqualToString:@"3"]) {
        
        PlayUserSongViewController *playUserSongVC = [[PlayUserSongViewController alloc] init];
        
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_SONG_BY_ID, msgModel.song_id] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            
            SongModel *model = [[SongModel alloc] initWithDictionary:resposeObject error:nil];
            
//            NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:[NSString stringWithFormat:GET_SONG_IMG, model.code]]];
//            UIImage *image = [[UIImage alloc] initWithData:data];
//            
//            playUserSongVC.lyricURL = [NSString stringWithFormat:HOME_LYRIC, model.code];
//            playUserSongVC.soundURL = [NSString stringWithFormat:HOME_SOUND, model.code];
//            
//            playUserSongVC.soundName = [model.title emojizedString];
//            
//            NSString *deCodeOriginalTitle = [model.original_title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//            if (deCodeOriginalTitle.length != 0) {
//                playUserSongVC.soundName = [[model.title emojizedString] stringByAppendingString:[NSString stringWithFormat:@"(原曲:%@)", deCodeOriginalTitle]];
//            } else {
//                playUserSongVC.soundName = [model.title emojizedString];
//            }
//            
//            playUserSongVC.listenCount = [model.play_count integerValue];
//            playUserSongVC.user_id = model.user_id;
//            playUserSongVC.createTimeStr = model.create_time;
//            playUserSongVC.loveCount = model.up_count;
//            playUserSongVC.song_id = model.dataId;
//            playUserSongVC.needReload = YES;
            playUserSongVC.songCode = model.code;
//            playUserSongVC.themeImageView.image = image;
            
//            [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_PLAYCOUNT, playUserSongVC.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//                
//            } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                
//            }];
            
            [self.navigationController pushViewController:playUserSongVC animated:YES];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    } else if ([msgModel.type isEqualToString:@"2"]) {
        
        OtherPersonCenterController *otherVC = [[OtherPersonCenterController alloc] initWIthUserId:msgModel.send_id];
        [self.navigationController pushViewController:otherVC animated:YES];
        
    } else {
        NSLog(@"这里是系统消息");
    }
    
}

- (BOOL)shouldAutorotate
{
    return NO;
}
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
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
