//
//  TYPopView.m
//  CreateSongs
//
//  Created by axg on 16/6/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "TYPopView.h"
#import "UIColor+expanded.h"
#import "TYListCell.h"
#import "UIView+Common.h"
#import "UIView+UIViewAdditions.h"

static NSString *const indentifier = @"indentifier";

@interface TYPopView ()<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *listTableView;

@property (nonatomic, strong) UIImageView *sanjiaoView;

@property (nonatomic, assign) NSInteger listCount;

@property (nonatomic, assign) NSInteger selectedIndex;

@end

@implementation TYPopView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.selectedIndex = 0;
        
        self.dataArray = @[@"第一句", @"第二句", @"第三句", @"第四句", @"第五句", @"第六句", @"第七句", @"第八句", @"第九句", @"第十句", @"第十一句", @"第十二句",@"第十三句", @"第十四句", @"第十五句", @"第十六句", @"第十七句"];
        self.listCount = 8;
        
        self.sanjiaoView = [UIImageView new];
        self.sanjiaoView.image = [UIImage imageNamed:@"ty小三角"];
        self.sanjiaoView.backgroundColor = [UIColor clearColor];
        self.sanjiaoView.frame = CGRectMake(0, 0, 12, 7);
        self.sanjiaoView.center = CGPointMake(self.centerX, self.sanjiaoView.centerY);
        [self addSubview:self.sanjiaoView];
        
        [self initTableView];
    }
    return self;
}

- (void)initTableView {
    self.listTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.sanjiaoView.bottom, self.width, self.height-7)];
    self.listTableView.backgroundColor = [[UIColor colorWithHexString:@"#fefbf3"] colorWithAlphaComponent:0.85];
//    self.listTableView.alpha = 0.9f;
    self.listTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.listTableView.delegate = self;
    self.listTableView.dataSource = self;
    self.listTableView.clipsToBounds = YES;
    self.listTableView.layer.cornerRadius = 3;
    [self addSubview:self.listTableView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.sanjiaoView.frame = CGRectMake(0, 0, 12, 7);
    self.sanjiaoView.center = CGPointMake(self.width*1.0/2, self.sanjiaoView.centerY);
    self.listTableView.frame = CGRectMake(0, self.sanjiaoView.bottom, self.width, self.height-7);
}

- (void)changeSelectedIndex:(NSInteger)index {
    self.selectedIndex = index;
    [self.listTableView reloadData];
}

- (void)showLineWithNumber:(NSInteger)lineNumber {
    self.listCount = lineNumber;
    if (lineNumber < 5) {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.cellHeight*lineNumber+7);
    } else {
        self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, self.cellHeight*4.5+7);
    }
    
    [self.listTableView reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.listCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    TYListCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[TYListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    
    if (indexPath.row == self.selectedIndex) {
        cell.selected = YES;
    } else {
        cell.selected = NO;
    }
    
    cell.backgroundColor = [UIColor clearColor];
//    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.listLabel.text = self.dataArray[indexPath.row];

    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.popSelect) {
        self.popSelect(indexPath.row);
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.cellHeight;
}

@end
