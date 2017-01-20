//
//  GiftRankViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/26.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "GiftRankViewController.h"
#import "DetailGiftRankTableViewCell.h"
#import "GiftUserModel.h"
#import "OtherPersonCenterController.h"

static NSString *const identifier = @"identifier";

@interface GiftRankViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GiftRankViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initTableView];
    
}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
    
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    [self.navLeftButton addTarget:self action:@selector(backButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navTitle.text = @"礼物榜";
    
}

#pragma mark - Action
- (void)backButtonAction {
    [self.navigationController popViewControllerAnimated:YES];
}

// 创建tableview
- (void)initTableView {
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[DetailGiftRankTableViewCell class] forCellReuseIdentifier:identifier];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    DetailGiftRankTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (indexPath.row < self.dataSource.count) {
        GiftUserModel *model = self.dataSource[indexPath.row];
        cell.model = model;
    }
    
    cell.rankLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    
    if (indexPath.row == 0) {
        cell.goldImage.hidden = NO;
        cell.goldImage.image = [UIImage imageNamed:@"冠军icon"];
    } else if (indexPath.row == 1) {
        cell.goldImage.hidden = NO;
        cell.goldImage.image = [UIImage imageNamed:@"亚军icon"];
    } else if (indexPath.row == 2) {
        cell.goldImage.hidden = NO;
        cell.goldImage.image = [UIImage imageNamed:@"季军icon"];
    } else {
        cell.goldImage.hidden = YES;
    }
    
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 65 * WIDTH_NIT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    DetailGiftRankTableViewCell *cell = (DetailGiftRankTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    OtherPersonCenterController *personCenter = [[OtherPersonCenterController alloc] initWIthUserId:cell.model.user_id];
    [self.navigationController pushViewController:personCenter animated:YES];
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
