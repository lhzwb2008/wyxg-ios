//
//  SearchViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/25.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SearchViewController.h"
#import "SearchUserTableViewCell.h"
#import "SearchSongTableViewCell.h"
#import "AXGHeader.h"
#import "SongModel.h"
#import "UserModel.h"
#import "PlayUserSongViewController.h"
#import "NSString+Emojize.h"
#import "OtherPersonCenterController.h"
#import "AFNetworking.h"

static NSString *const userIdentifier = @"userIdentifier";
static NSString *const songIdentifier = @"songIdentifier";

@interface SearchViewController ()<UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate, UIScrollViewDelegate>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) UISearchController *searchVC;

@property (nonatomic, strong) NSMutableArray *userDataSource;

@property (nonatomic, strong) NSMutableArray *songDataSource;

@property (nonatomic, strong) UITextField *searchTextField;

@property (nonatomic, strong) UILabel *emptyLabel;

@property (nonatomic, assign) NSInteger inputCount;

@property (nonatomic, strong) NSURLSessionDataTask *requestTask;

@property (nonatomic, strong) AFHTTPSessionManager *manager;


@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    //1获取单例的网络管理对象
    self.manager = [AFHTTPSessionManager manager];
    self.manager.responseSerializer = [AFHTTPResponseSerializer serializer];
    //    self.manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    self.manager.requestSerializer.timeoutInterval = TIMEOUTINTERVAL;
    // Do any additional setup after loading the view.
    
    self.userDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    self.songDataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    [self initTableView];
    
    [self initNavView];
    
//    self.myLock = YES;
    
//    self.timer = [NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(timeAction) userInfo:nil repeats:YES];
//    [self.timer setFireDate:[NSDate distantFuture]];
    
    
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    self.searchVC.searchBar.hidden = NO;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
//    self.searchVC.searchBar.hidden = YES;
}

#pragma mark - 初始化界面

- (void)initNavView {
    [super initNavView];
    
    self.navLeftImage.image = [UIImage imageNamed:@"搜索_高亮"];
    self.navLeftImage.hidden = NO;
    
    self.searchTextField = [[UITextField alloc] initWithFrame:CGRectMake(self.navLeftImage.right + 16 * WIDTH_NIT, self.navLeftImage.top, self.view.width - self.navLeftImage.right * 2 - 32 * WIDTH_NIT, 30 * WIDTH_NIT)];
    self.searchTextField.center = CGPointMake(self.searchTextField.centerX, self.navLeftImage.centerY);
    
    
    self.searchTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"搜索用户或歌曲" attributes:@{NSForegroundColorAttributeName:HexStringColor(@"#ffffff"), NSFontAttributeName:JIACU_FONT(15)}];
    self.searchTextField.textColor = HexStringColor(@"#441D11");
    self.searchTextField.font = JIACU_FONT(15);
    self.searchTextField.returnKeyType = UIReturnKeySearch;
    self.searchTextField.delegate = nil;
    self.searchTextField.delegate = self;
//    [self.searchTextField addTarget:self action:@selector(textDidChange:) forControlEvents:UIControlEventEditingChanged];
    
    [self.navView addSubview:self.searchTextField];
    
    UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(self.searchTextField.left, self.navView.bottom - 7, self.searchTextField.width, 0.5)];
    [self.navView addSubview:lineView];
    lineView.backgroundColor = HexStringColor(@"#441d11");
    
    [self.navRightButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.navRightButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textDidChange:) name:UITextFieldTextDidChangeNotification object:self.searchTextField];
    
    
    
//    // 初始化searchVC
//    self.searchVC = [[UISearchController alloc] initWithSearchResultsController:nil];
//    self.searchVC.searchResultsUpdater = self;
//    self.searchVC.delegate = self;
////    self.searchVC.searchBar.frame = CGRectMake(self.navLeftImage.right + 16 * WIDTH_NIT, self.navLeftImage.top, self.view.width - self.navLeftImage.right * 2 - 32 * WIDTH_NIT, self.navLeftImage.height);
////    [self.navView addSubview:self.searchVC.searchBar];
//    self.searchVC.searchBar.frame = CGRectMake(0, 0, self.view.width, 64);
//    self.tableView.tableHeaderView = self.searchVC.searchBar;
//    [self.searchVC.searchBar sizeToFit];
//    
//    // 设置为NO,可以点击搜索出来的内容
//    self.searchVC.dimsBackgroundDuringPresentation = NO;
    
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

// 初始化tableview
- (void)initTableView {
    
    self.emptyLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 64, self.view.width, 64)];
    [self.view addSubview:self.emptyLabel];
    self.emptyLabel.text = @"讨厌，结果找不到啦(▼ヘ▼#)";
    self.emptyLabel.font = JIACU_FONT(15);
    self.emptyLabel.textColor = HexStringColor(@"#a0a0a0");
    self.emptyLabel.textAlignment = NSTextAlignmentCenter;
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.tableView registerClass:[SearchUserTableViewCell class] forCellReuseIdentifier:userIdentifier];
    [self.tableView registerClass:[SearchSongTableViewCell class] forCellReuseIdentifier:songIdentifier];
    self.tableView.backgroundColor = [UIColor clearColor];
    
}

#pragma mark - Action
- (void)backButtonAction {

    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return self.userDataSource.count;
    } else {
        return self.songDataSource.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    
    if (self.userDataSource.count == 0 && self.songDataSource.count == 0) {
        return nil;
    } else if (self.userDataSource.count != 0 && self.songDataSource.count == 0) {
        
        SearchUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userIdentifier];
        if (self.userDataSource.count > indexPath.row) {
            cell.userModel = self.userDataSource[indexPath.row];
        }
        return cell;
        
    } else if (self.userDataSource.count == 0 && self.songDataSource.count != 0) {
        SearchSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:songIdentifier];
        if (self.songDataSource.count > indexPath.row) {
            cell.songModel = self.songDataSource[indexPath.row];
        }
        return cell;
    } else if (self.userDataSource.count != 0 && self.songDataSource.count != 0) {
        if (indexPath.section == 0) {
            SearchUserTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:userIdentifier];
            if (self.userDataSource.count > indexPath.row) {
                cell.userModel = self.userDataSource[indexPath.row];
            }
            return cell;
        } else {
            SearchSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:songIdentifier];
            if (self.songDataSource.count > indexPath.row) {
                cell.songModel = self.songDataSource[indexPath.row];
            }
            return cell;
        }
    }
    
    return nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    if (self.userDataSource.count != 0 && self.songDataSource.count != 0) {
        return 2;
    } else if ((self.userDataSource.count == 0 && self.songDataSource.count != 0) || (self.userDataSource.count != 0 && self.songDataSource.count == 0)) {
        return 1;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    if (section == 0) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 41 * WIDTH_NIT)];
        view.backgroundColor = HexStringColor(@"#ffffff");
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, 10 * WIDTH_NIT, 100, 33 * WIDTH_NIT)];
        [view addSubview:label];
        label.textColor = HexStringColor(@"#a0a0a0");
        label.font = ZHONGDENG_FONT(15);
        if (self.userDataSource != 0) {
            label.text = @"用户";
        } else {
            label.text = @"歌曲";
        }
        return view;
    } else if (section == 1) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 41 * WIDTH_NIT)];
        view.backgroundColor = HexStringColor(@"#ffffff");
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(16 * WIDTH_NIT, 10 * WIDTH_NIT, 100, 33 * WIDTH_NIT)];
        [view addSubview:label];
        label.textColor = HexStringColor(@"#a0a0a0");
        label.font = ZHONGDENG_FONT(15);
        label.text = @"歌曲";
        return view;
    }
    
    return nil;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return 41 * WIDTH_NIT;
    } else if (section == 1) {
        return 51 * WIDTH_NIT;
    }
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10 * WIDTH_NIT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 15 * WIDTH_NIT + 45 * WIDTH_NIT + 15 * WIDTH_NIT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    [[UIResponder currentFirstResponder] resignFirstResponder];
    
    
    if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[SearchUserTableViewCell class]]) {
        
        SearchUserTableViewCell *cell = (SearchUserTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        OtherPersonCenterController *otherVC = [[OtherPersonCenterController alloc] initWIthUserId:cell.userModel.userModelId];
        [self.navigationController pushViewController:otherVC animated:YES];
        
    } else if ([[tableView cellForRowAtIndexPath:indexPath] isKindOfClass:[SearchSongTableViewCell class]]) {
        SearchSongTableViewCell *cell = (SearchSongTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        PlayUserSongViewController *playVC = [[PlayUserSongViewController alloc] init];
        
//        playVC.lyricURL = [NSString stringWithFormat:HOME_LYRIC, cell.songModel.code];
//        playVC.soundURL = [NSString stringWithFormat:HOME_SOUND, cell.songModel.code];
//        playVC.soundName = [cell.mainTitle.text emojizedString];
//        playVC.listenCount = [cell.songModel.play_count integerValue];
//        playVC.user_id = cell.songModel.user_id;
//        playVC.createTimeStr = cell.songModel.create_time;
//        playVC.loveCount = cell.songModel.up_count;
//        playVC.song_id = cell.songModel.dataId;
//        playVC.needReload = YES;
        playVC.songCode = cell.songModel.code;
//        playVC.themeImageView.image = cell.themeImage.image;
//        
//        [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_PLAYCOUNT, playVC.songCode] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//            
//        } failure:^(NSURLSessionDataTask *task, NSError *error) {
//            
//        }];
        
        [self.navigationController pushViewController:playVC animated:YES];
    }
    
    
}

#pragma mark - UITextFiedDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
//    [self timeAction];
    
    [[UIResponder currentFirstResponder] resignFirstResponder];
    return YES;
}

//- (void)textFieldDidBeginEditing:(UITextField *)textField {
//    NSLog(@"begin");
//    
//    [self.timer setFireDate:[NSDate distantPast]];
//    
//}

//- (void)textFieldDidEndEditing:(UITextField *)textField {
//    
//    [self.timer setFireDate:[NSDate distantFuture]];
//    
//}

//- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
//    
//    if (range.location >= 2)
//        return NO; // return NO to not change text
//    return YES;
//    
//    NSString *searchStr = textField.text;
//    
//    [XWAFNetworkTool getUrl:[NSString stringWithFormat:Search_API, searchStr] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
//            
//            
//            NSArray *songs = nil;
//            NSArray *users = nil;
//            
//            if (![resposeObject[@"songs"] isKindOfClass:[NSNull class]]) {
//                songs = resposeObject[@"songs"];
//                
//                [self.songDataSource removeAllObjects];
//                
//                for (NSDictionary *dic in songs) {
//                    SongModel *model = [[SongModel alloc] initWithDictionary:dic error:nil];
//                    [self.songDataSource addObject:model];
//                }
//                
//            }
//            if (![resposeObject[@"users"] isKindOfClass:[NSNull class]]) {
//                users = resposeObject[@"users"];
//                
//                [self.userDataSource removeAllObjects];
//                
//                for (NSDictionary *dic in users) {
//                    UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
//                    [self.userDataSource addObject:model];
//                }
//                
//            }
//            
//            self.emptyLabel.hidden = YES;
//            
//            
//        } else {
//            [self.userDataSource removeAllObjects];
//            [self.songDataSource removeAllObjects];
//            self.emptyLabel.hidden = NO;
//        }
//        
//        [self.tableView reloadData];
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//        [self.userDataSource removeAllObjects];
//        [self.songDataSource removeAllObjects];
//        
//        self.emptyLabel.hidden = NO;
//        
//        [self.tableView reloadData];
//        
//    }];
//    
//    return YES;
//}

- (void)searchByNet{
    
    if (self.requestTask) {
        [self.requestTask cancel];
    }
    
    NSString *searchStr = [self.searchTextField text];
    
    WEAK_SELF;
    self.requestTask = [XWAFNetworkTool getUrl:[NSString stringWithFormat:Search_API, searchStr] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {

        
        STRONG_SELF;
        
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            
            NSArray *songs = nil;
            NSArray *users = nil;
            if (![resposeObject[@"users"] isKindOfClass:[NSNull class]]) {
                users = resposeObject[@"users"];
                
                [self.userDataSource removeAllObjects];
                
                for (NSDictionary *dic in users) {
                    UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                    [self.userDataSource addObject:model];
                }
            }

            NSMutableArray *mutSongs = [[NSMutableArray alloc] initWithCapacity:0];
            NSMutableArray *mutUsers = [[NSMutableArray alloc] initWithCapacity:0];
            
            if (![resposeObject[@"songs"] isKindOfClass:[NSNull class]]) {
                songs = resposeObject[@"songs"];
                
                for (NSDictionary *dic in songs) {
                    SongModel *model = [[SongModel alloc] initWithDictionary:dic error:nil];
                    [mutSongs addObject:model];
                }
                
            }
            if (![resposeObject[@"users"] isKindOfClass:[NSNull class]]) {
                users = resposeObject[@"users"];
                
                for (NSDictionary *dic in users) {
                    UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
                    [mutUsers addObject:model];
                }
                
            }
            
            [self.songDataSource removeAllObjects];
            [self.songDataSource addObjectsFromArray:mutSongs];
            
            [self.userDataSource removeAllObjects];
            [self.userDataSource addObjectsFromArray:mutUsers];
            
            self.emptyLabel.hidden = YES;
            
        } else {
            [self.userDataSource removeAllObjects];
            [self.songDataSource removeAllObjects];
            self.emptyLabel.hidden = NO;
        }
        
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
        [self.userDataSource removeAllObjects];
        [self.songDataSource removeAllObjects];
        
        self.emptyLabel.hidden = NO;
        
        [self.tableView reloadData];
        
    }];
}

- (void)checkIfRequest:(NSNumber *)count {
    if (self.inputCount == [count integerValue]) {
        [self searchByNet];
    }
}

- (void)textDidChange:(id)sender {
    [self searchByNet];
//    self.inputCount ++;
//    [self performSelector:@selector(checkIfRequest:) withObject:@(self.inputCount) afterDelay:0.0f];
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        [[UIResponder currentFirstResponder] resignFirstResponder];
    }
}

//#pragma mark - UISearchControllerDelegate
//// 搜索界面将要出现
//- (void)willPresentSearchController:(UISearchController *)searchController {
//    NSLog(@"将要  开始  搜索时触发的方法");
//}
//
//// 搜索界面将要消失
//- (void)willDismissSearchController:(UISearchController *)searchController {
//    NSLog(@"将要  取消  搜索时触发的方法");
//}
//
//// 搜索界面消失
//- (void)didDismissSearchController:(UISearchController *)searchController {
//    
//}

//#pragma mark -- 搜索方法
//// 搜索时触发的方法
//- (void)updateSearchResultsForSearchController:(UISearchController *)searchController {
//    
//    NSString *searchStr = [self.searchVC.searchBar text];
//    
//    [XWAFNetworkTool getUrl:[NSString stringWithFormat:Search_API, searchStr] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
//
//            
//            NSArray *songs = nil;
//            NSArray *users = nil;
//            
//            if (![resposeObject[@"songs"] isKindOfClass:[NSNull class]]) {
//                songs = resposeObject[@"songs"];
//                
//                [self.songDataSource removeAllObjects];
//                
//                for (NSDictionary *dic in songs) {
//                    SongModel *model = [[SongModel alloc] initWithDictionary:dic error:nil];
//                    [self.songDataSource addObject:model];
//                }
//                
//            }
//            if (![resposeObject[@"users"] isKindOfClass:[NSNull class]]) {
//                users = resposeObject[@"users"];
//                
//                [self.userDataSource removeAllObjects];
//                
//                for (NSDictionary *dic in users) {
//                    UserModel *model = [[UserModel alloc] initWithDictionary:dic error:nil];
//                    [self.userDataSource addObject:model];
//                }
//                
//            }
//            
//            [self.tableView reloadData];
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
//    
//    
////    // 谓词
////    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF CONTAINS %@", searchStr];
////    
////    // 过滤数据
////    NSMutableArray *resultDataArray = [NSMutableArray arrayWithArray:[self.dataArray filteredArrayUsingPredicate:predicate]];
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
