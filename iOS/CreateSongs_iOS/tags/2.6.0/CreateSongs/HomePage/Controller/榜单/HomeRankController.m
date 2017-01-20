//
//  HomeRankController.m
//  CreateSongs
//
//  Created by axg on 16/7/25.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "HomeRankController.h"
#import "HomeRankCell.h"
#import "HomePageModel.h"
#import "KVNProgress.h"
#import "TYCache.h"
#import "PlayUserSongViewController.h"
#import "AppDelegate.h"

@interface HomeRankController ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *rankTableView;

@property (nonatomic, strong) NSMutableArray *rankDataArray;

@end

@implementation HomeRankController

//- (UIImage *)setLeftBtnImage {
//    return [UIImage imageNamed:@"返回"];
//}
- (NSString *)setTitleTxt {
    return @"榜单";
}

- (NSMutableArray *)rankDataArray {
    if (_rankDataArray == nil) {
        _rankDataArray = [NSMutableArray array];
    }
    return _rankDataArray;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    [self.navLeftButton addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];

    [self createRankTableView];
    [self loadRankDataFromeNet];
    
    [self.view bringSubviewToFront:self.navView];
}

- (void)leftBtnClick:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)createRankTableView {
    self.rankTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, self.view.height-44) style:UITableViewStyleGrouped];
    self.rankTableView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    self.rankTableView.delegate = self;
    self.rankTableView.dataSource = self;
    self.rankTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    [self.view addSubview:self.rankTableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    HomeRankCell *cell = [HomeRankCell customRankCellWithTableView:tableView];
    
    UIView *selectView = [UIView new];

    if (indexPath.section == 0) {
        selectView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    } else {
        selectView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
        cell.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    }
    cell.selectedBackgroundView = selectView;
    NSInteger index = indexPath.row;
    if (indexPath.section == 1) {
        index = index + 10;
    }
    if (index < self.rankDataArray.count) {
        HomePageUserMess *model = self.rankDataArray[index];
        cell.index = index+1;
        cell.dataModel = model;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    HomeRankCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    PlayUserSongViewController *pvc = [PlayUserSongViewController new];
//    pvc.user_id = cell.dataModel.user_id;
//    pvc.soundName = cell.songName.text;
//    pvc.listenCount = [cell.dataModel.play_count integerValue];
//    pvc.loveCount = cell.dataModel.up_count;
//    pvc.createTimeStr = cell.dataModel.create_time;
//    pvc.song_id = cell.dataModel.dataId;
    pvc.songCode = cell.dataModel.code;
//    pvc.themeImageView.image = cell.songPic.image;
    [self.navigationController pushViewController:pvc animated:YES];
    
    [self performSelector:@selector(deselect) withObject:nil afterDelay:0.3f];
}

- (void)deselect{
    [self.rankTableView deselectRowAtIndexPath:[self.rankTableView indexPathForSelectedRow] animated:YES];
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (self.rankDataArray.count > 10) {
        if (section == 0) {
            return 10;
        } else {
            return self.rankDataArray.count - 10;
        }
    }
    return 0;
}

- (UIView *)createHeadView {
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    UILabel *headLabel = [UILabel new];
    
    headLabel.textColor = [UIColor colorWithHexString:@"#535353"];
    headLabel.font = TECU_FONT(15*WIDTH_NIT);
    headLabel.text = @"TOP  10  —";
    
    CGSize headLabelSize = [headLabel.text getWidth:headLabel.text andFont:headLabel.font];
    
    headLabel.frame = CGRectMake(16*WIDTH_NIT, 32*WIDTH_NIT, headLabelSize.width, headLabelSize.height);
    
    [headView addSubview:headLabel];
    
    return headView;
}

- (UIView *)createHeadView2 {
    UIView *headView = [UIView new];
    headView.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    
    UILabel *headLabel = [UILabel new];
    
    headLabel.textColor = [UIColor colorWithHexString:@"#535353"];
    headLabel.font = TECU_FONT(15*WIDTH_NIT);
    headLabel.text = @"Rankings  —";
    
    CGSize headLabelSize = [headLabel.text getWidth:headLabel.text andFont:headLabel.font];
    
    headLabel.frame = CGRectMake(16*WIDTH_NIT, 32*WIDTH_NIT, headLabelSize.width, headLabelSize.height);
    
    [headView addSubview:headLabel];
    
    return headView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
   
    CGSize headLabelSize = [@"TOP 10 -" getWidth:@"TOP 10 -" andFont:TECU_FONT(15*WIDTH_NIT)];
    return 32*WIDTH_NIT + headLabelSize.height + 20*WIDTH_NIT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 0) {
        return [self createHeadView];
    } else if (section == 1) {
        return [self createHeadView2];
    }
    return [self createHeadView];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64*WIDTH_NIT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 0.0001;
}

- (void)loadRankDataFromeNet {
    
    NSString *url = [NSString stringWithFormat:GET_RANK_LIST, 0, 30];
    
    NSData *cacheData = [TYCache objectForKey:MD5Hash(url)];
    
    AppDelegate *app = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    if (cacheData && !app.rankDataShouldRefresh) {
        [self parseData:cacheData];
        return;
    }
    [XWAFNetworkTool getUrl:url body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        app.rankDataShouldRefresh = NO;
        [self parseData:resposeObject];
        [TYCache setObject:resposeObject forKey:MD5Hash(url)];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        [KVNProgress showErrorWithStatus:@"网络错误"];
        NSLog(@"%s -- %@", __func__, error.description);
    }];
}

- (void)parseData:(NSData *)data {
    HomePageModel *model = [[HomePageModel alloc] initWithData:data error:nil];
    if ([model.status isEqualToString:@"0"]) {
        NSArray *songs = model.songs;
        [self.rankDataArray addObjectsFromArray:songs];
        [self.rankTableView reloadData];
    } else {
        [KVNProgress showErrorWithStatus:@"数据请求错误"];
    }
}

- (void)dealloc {
    [NSObject cancelPreviousPerformRequestsWithTarget:self selector:@selector(deselect) object:nil];
}

@end
