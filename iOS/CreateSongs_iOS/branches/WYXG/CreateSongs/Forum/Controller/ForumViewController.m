//
//  ForumViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/22.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ForumViewController.h"
#import "MJRefresh.h"
#import "ForumModel.h"
#import "ForumTableViewCell.h"
//#import "UIViewController+MMDrawerController.h"
#import "ForumContentViewController.h"
#import "SendNoteViewController.h"
#import "MobClick.h"
#import "CreateSongs-Swift.h"
//#import "KYDrawerController.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>

static NSString *const identifier = @"identifier";

@interface ForumViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@property (nonatomic, assign) NSInteger beginIndex;

@property (nonatomic, assign) NSInteger songLength;

@end

@implementation ForumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self createTableView];
    [self refreshForum];
    
    [self initNavView];
    
    [self createWriteBtn];
    
    [self createEdgePanView];
    
//    [self reloadMsg];
}

- (void)createWriteBtn {
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(self.view.width - 73 * WIDTH_NIT - 20 * WIDTH_NIT, self.view.height - 73 * WIDTH_NIT - 25 * HEIGHT_NIT, 73 * WIDTH_NIT, 73 * WIDTH_NIT);
    [btn setImage:[UIImage imageNamed:@"发帖icon"] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(turnToWritepage) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

- (void)turnToWritepage {
    
    [MobClick event:@"home_send_post"];
    
    SendNoteViewController *snc = [SendNoteViewController new];
    [self presentViewController:snc animated:YES completion:^{
        
    }];
}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
    
//    self.navLeftImage.image = [UIImage imageNamed:@"菜单icon"];
    self.navTitle.text = @"乐谈";
    
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

// 创建tableview
- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 20, self.view.width, self.view.height + 44) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = HexStringColor(@"#eeeeee");
    self.tableView.tableHeaderView = [self getForumHead];
    self.tableView.tableFooterView = [self getForumFooter];
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    [self.tableView registerClass:[ForumTableViewCell class] forCellReuseIdentifier:identifier];
    
}

- (UIView *)getForumHead {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44 + 25 * WIDTH_NIT)];
    view.backgroundColor = [UIColor clearColor];
    return view;
}

- (UIView *)getForumFooter {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 44)];
    view.backgroundColor = [UIColor clearColor];
    return view;
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

#pragma mark - 获取数据
// 加载最新数据
- (void)refreshForum {
    MJRefreshNormalHeader *header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        [self.dataSource removeAllObjects];
        [self getForumData:NO];
    }];
    self.tableView.mj_header = header;
    
    [self.tableView.mj_header beginRefreshing];
    
    MJRefreshBackNormalFooter *footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        [self getForumData:YES];
    }];
    self.tableView.mj_footer = footer;
}

// 请求最新数据
- (void)getForumData:(BOOL)isMore {
    if (isMore) {
        [self.tableView.mj_header endRefreshing];
        
        if (self.dataSource.count % 6 == 0) {
            self.beginIndex = 6 * (self.dataSource.count / 6);
            //                self.endIndex = self.endIndex + 6;
        } else {
            [self.tableView.mj_footer endRefreshing];
            
            [MBProgressHUD showError:DATA_DONE];
            return;
        }
        
    } else {
        [self.tableView.mj_footer endRefreshing];
        self.beginIndex = 0;
        self.songLength = 6;
    }
    NSString *url = [NSString stringWithFormat:GET_POST, self.beginIndex, self.songLength];
    
    
    
    [XWAFNetworkTool getUrl:url body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSArray *items = resposeObject[@"items"];
            for (NSDictionary *dic in items) {
                ForumModel *model = [[ForumModel alloc] initWithDictionary:dic error:nil];
                if (model.phone.length != 0) {
                    [self.dataSource addObject:model];
                }
            }
        }
        
        if (!isMore) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }

        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        NSLog(@"首页请求错误%@", error.description);
        
        if (!isMore) {
            [self.tableView.mj_header endRefreshing];
        } else {
            [self.tableView.mj_footer endRefreshing];
        }
        
    }];
}

#pragma mark - Action
- (void)backButtonAction:(UIButton *)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
    
//    KYDrawerController *drawerVC = (KYDrawerController *)self.navigationController.parentViewController;
//    
//    [drawerVC setDrawerState:DrawerStateOpened animated:YES];
    
//    [self.mm_drawerController
//     openDrawerSide:MMDrawerSideLeft
//     animated:YES
//     completion:^(BOOL finished) {
//         
//     }];
}

// 刷新站内信数据
- (void)reloadMsg {
    
    NSMutableArray *mutaArr = [[NSMutableArray alloc] initWithCapacity:0];
    
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
    } else {
        self.msgView.hidden = YES;
    }
    
}

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ForumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    
    if (self.dataSource.count > indexPath.row) {
        ForumModel *model = self.dataSource[indexPath.row];
        
        if (model.img_url.length != 0 && ![model.song_id isEqualToString:@"0"]) {
            cell.contentType = ImageAndAlbum;
        } else if (model.img_url.length != 0 && [model.song_id isEqualToString:@"0"]) {
            cell.contentType = ImageOnly;
        } else if (model.img_url.length == 0 && ![model.song_id isEqualToString:@"0"]) {
            cell.contentType = AlbumOnly;
        } else {
            cell.contentType = ImageAndAlbumNone;
        }
        
        cell.forumModel = model;
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.dataSource.count > indexPath.row) {
        ForumModel *model = self.dataSource[indexPath.row];
        
        CGFloat height1 = 0;
        CGFloat height2 = 0;
        if (model.img_url.length != 0) {
            height1 = 261 * WIDTH_NIT;
        } else {
            height1 = 0;
        }
        if ([model.song_id isEqualToString:@"0"]) {
            height2 = 0;
        } else {
            height2 = 90 * WIDTH_NIT;
        }
        
        return 112.5 * WIDTH_NIT + height1 + height2;
    } else {
        return 112.5 * WIDTH_NIT;
    }
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    [MobClick event:@"home_click_post"];
//
    ForumTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
//
//    if (self.forumSelectBlock) {
//        self.forumSelectBlock(cell);
//    }
//    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    ForumContentViewController *fcv = [[ForumContentViewController alloc] init];
    fcv.name = cell.nameLabel.text;
    fcv.content = cell.contentLabel.text;
    fcv.headImage = cell.headImage.image;
    fcv.contentId = cell.forumModel.dataId;
    fcv.createTime = cell.forumModel.create_time;
    fcv.gender = cell.forumModel.gender;
    fcv.userId = cell.forumModel.user_id;
    fcv.contentType = cell.contentType;
    fcv.code = cell.albumView.code;
    fcv.zuoci = cell.albumView.lyricLabel.text;
    fcv.zuoqu = cell.albumView.songLabel.text;
    fcv.yanchang = cell.albumView.singerLabel.text;
    fcv.songTitle = cell.albumView.titleLabel.text;
    fcv.songImage = cell.albumView.themeImage.image;
    if (cell.forumModel.img_url.length == 0) {
        fcv.hasPic = NO;
        fcv.themeImage = cell.themeImage.image;
    } else {
        fcv.hasPic = YES;
        fcv.themeImage = cell.themeImage.image;
    }
    [self.navigationController pushViewController:fcv animated:YES];
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
