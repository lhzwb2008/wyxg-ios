//
//  PersonTableDelegate.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/5/5.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PersonTableDelegate.h"
#import "AXGHeader.h"


@implementation PersonTableDelegate

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    FocusTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:self.indentifier];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    if (self.dataSource.count > indexPath.row) {
        cell.userId = self.dataSource[indexPath.row];
    }
    cell.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return (25+22.5+20+35+10)*HEIGHT_NIT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
//    view.backgroundColor = [UIColor redColor];
    
    UIButton *headButton = [UIButton new];//
    headButton.frame = CGRectMake(0, (200-40) * HEIGHT_NIT, 80 * HEIGHT_NIT, 80 * HEIGHT_NIT);
    headButton.center = CGPointMake(SCREEN_W / 2, headButton.centerY);
    [view addSubview:headButton];
    [headButton addTarget:self action:@selector(showHeadImageAction:) forControlEvents:UIControlEventTouchUpInside];
    headButton.backgroundColor = [UIColor clearColor];
    
    UIButton *focusButton = [UIButton new];
    focusButton.frame = CGRectMake(headButton.left - 20 * WIDTH_NIT, (self.head_height)*HEIGHT_NIT-(18+10+15+12+10+30+25)*HEIGHT_NIT, headButton.width + 40 * WIDTH_NIT, 30 * HEIGHT_NIT);
    [view addSubview:focusButton];
    [focusButton addTarget:self action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    focusButton.backgroundColor = [UIColor clearColor];
    
    CGPoint center = focusButton.center;
    focusButton.frame = CGRectMake(0, 0, 85 * WIDTH_NIT, 30 * WIDTH_NIT);
    focusButton.center = CGPointMake(center.x - 12.5 * WIDTH_NIT - 42.5 * WIDTH_NIT, center.y + 12.5 * WIDTH_NIT);
    
    UIButton *sixinButton = [UIButton buttonWithType:UIButtonTypeCustom];
    sixinButton.frame = CGRectMake(focusButton.right + 25 * WIDTH_NIT, focusButton.top, focusButton.width, focusButton.height);
    [view addSubview:sixinButton];
    [sixinButton addTarget:self action:@selector(sixinButtonAction:) forControlEvents:UIControlEventTouchUpInside];
//    focusButton.backgroundColor = [UIColor redColor];
//    sixinButton.backgroundColor = [UIColor greenColor];
    
    if (self.isPersonCenter) {
        [focusButton addTarget:self action:@selector(modifyUserInfoAction:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [focusButton addTarget:self action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    for (int i = 0; i < 4; i++) {
        UIButton *button = [UIButton new];
        
        CGFloat hotBtnHeight = (18+20+20)*HEIGHT_NIT;
        
        button.frame = CGRectMake(0 + SCREEN_W / 4 * i, (self.head_height)*HEIGHT_NIT-hotBtnHeight, SCREEN_W / 4, hotBtnHeight);
//        if (self.isPersonCenter) {
//            button.frame = CGRectMake(0 + SCREEN_W / 4 * i, 200 * HEIGHT_NIT + 180 * HEIGHT_NIT, SCREEN_W / 4, 40 * HEIGHT_NIT);
//        } else {
//            button.frame = CGRectMake(0 + SCREEN_W / 4 * i, 200 * HEIGHT_NIT + 120 * HEIGHT_NIT + 25, SCREEN_W / 4, 64 * HEIGHT_NIT);
//        }
        
        [view addSubview:button];
        button.tag = 100 + i;
                    button.backgroundColor = [UIColor clearColor];
        [button addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return view;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//    if (self.isPersonCenter) {
//        return 200 * HEIGHT_NIT + 120 * HEIGHT_NIT + 40 * HEIGHT_NIT + 10 * HEIGHT_NIT;
//    }
    return self.head_height*HEIGHT_NIT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    FocusTableViewCell *cell = (FocusTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (self.tableSelectBlock) {
        self.tableSelectBlock(indexPath.row, cell);
    }
}

- (void)buttonAction:(UIButton *)sender {
    if (self.tableSelectTypeBlock) {
        self.tableSelectTypeBlock(sender.tag - 100);
    }
}

#pragma mark - UIScrollViewDelegate 

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
//    NSLog(@"%lf", scrollView.contentOffset.y);
    
    if (self.tableContentOffsetBlock) {
        self.tableContentOffsetBlock(scrollView.contentOffset.y);
    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if (self.tableBeginDrag) {
        self.tableBeginDrag();
    }
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    if (self.tableEndDrag) {
        self.tableEndDrag();
    }
}

// 点击头像修改用户信息
- (void)modifyUserInfoAction:(UIButton *)sender {
    if (self.tableModifyUserInfoBlock) {
        self.tableModifyUserInfoBlock();
    }
}

// 私信方法
- (void)sixinButtonAction:(UIButton *)sender {
    
    if (self.sixinButtonBlock) {
        self.sixinButtonBlock();
    }
    
}

// 关注按钮block
- (void)focusButtonAction:(UIButton *)sender {
    if (self.tableFocusBlock) {
        self.tableFocusBlock();
    }
}

// 显示头像大图方法
- (void)showHeadImageAction:(UIButton *)sender {
    if (self.showHeadImageBlock) {
        self.showHeadImageBlock();
    }
}


@end
