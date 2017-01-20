//
//  Tianci_ChooseSinger_Controller.m
//  CreateSongs
//
//  Created by axg on 16/9/28.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "Tianci_ChooseSinger_Controller.h"
#import "XianQuShiTingViewController.h"
#import "ChooseSingerCell.h"

@interface Tianci_ChooseSinger_Controller () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) NSArray *singer_id_Array;

@end

@implementation Tianci_ChooseSinger_Controller

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataArray = @[@"暖男", @"正太", @"娃娃",@"御姐", @"萝莉"];
    self.singer_id_Array = @[@"1", @"2" ,@"3", @"5", @"6"];
    [self.view addSubview:self.tableView];
    [self.view bringSubviewToFront:self.navView];
}


- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 44, self.view.width, self.view.height - 44) style:UITableViewStylePlain];
        _tableView.backgroundColor = [UIColor whiteColor];
        _tableView.dataSource = self;
        _tableView.delegate = self;
    }
    return _tableView;
}

- (void)initNavView {
    [super initNavView];

    self.navTitle.text = @"歌手";
    
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [self.navLeftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    
    [self.navLeftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)backButtonAction:(UIButton *)btn {
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ChooseSingerCell *cell = [tableView dequeueReusableCellWithIdentifier:@"indentifier"];
    if (cell == nil) {
        cell = [[ChooseSingerCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"indentifier"];
    }
    cell.singer_name = self.dataArray[indexPath.row];
    cell.singer_id = self.singer_id_Array[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ChooseSingerCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    XianQuShiTingViewController *xqc = [XianQuShiTingViewController new];
    xqc.lyricDataSource = [self.lyricDataSource mutableCopy];
    xqc.isFirstPlay = self.isFirstPlay;
    xqc.isFromPlayView = self.isFromPlayView;
    xqc.isFromTianciPage = self.isFromTianciPage;
    xqc.isFirstGetZouyinMp3 = self.isFirstGetZouyinMp3;
    xqc.titleStr = self.titleStr;
    xqc.songName = self.songName;
    xqc.requestHeadName = self.requestHeadName;
    xqc.zouyin_banzouUrl = self.zouyin_banzouUrl;
    xqc.requestSongName = self.requestSongName;
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] initWithDictionary:self.zouyinUrl];
    [dic setObject:cell.singer_id forKey:@"singer"];
    xqc.zouyinUrl = [dic copy];
//    xqc.zouyinUrl = self.zouyinUrl;
//        xqc.zouyinUrl = @{@"title":self.tianciName,
//                          @"content":content,
//                          @"id":self.itemModel.id,
//                          @"singer":self.itemModel.singer,
//                          };
    [self.navigationController pushViewController:xqc animated:YES];

}
@end
