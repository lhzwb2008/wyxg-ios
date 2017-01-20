//
//  SelectSongViewController.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/9/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SelectSongViewController.h"
#import "XWAFNetworkTool.h"
#import "KeychainItemWrapper.h"
#import "SongModel.h"
#import "SelectSongTableViewCell.h"

static NSString *const identifier = @"identifier";

@interface SelectSongViewController ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *dataSource;

@end

@implementation SelectSongViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createTableView];
    [self getData];
    
}

#pragma mark - 初始化界面
- (void)initNavView {
    [super initNavView];
    
    [self.navRightButton setTitle:@"取消" forState:UIControlStateNormal];
    [self.navRightButton addTarget:self action:@selector(cancelButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    self.navTitle.text = @"作品";
    
}

- (void)createTableView {
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 64, self.view.width, self.view.height - 64) style:UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[SelectSongTableViewCell class] forCellReuseIdentifier:identifier];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
}

#pragma mark - Action 

// 取消按钮方法
- (void)cancelButtonAction {
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

// 获取数据
- (void)getData {
    
    self.dataSource = [[NSMutableArray alloc] initWithCapacity:0];
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *myId = [wrapper objectForKey:(id)kSecValueData];
    
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_SONGS, myId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            
            NSArray *array = resposeObject[@"songs"];
            for (NSDictionary *dic in array) {
                SongModel *model = [[SongModel alloc] initWithDictionary:dic error:nil];
                [self.dataSource addObject:model];
            }
            
            [self.tableView reloadData];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SelectSongTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    SelectSongTableViewCell *cell = (SelectSongTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    if (self.songSelectBlock) {
        self.songSelectBlock(cell.model);
    }
    
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 105 * WIDTH_NIT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
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
