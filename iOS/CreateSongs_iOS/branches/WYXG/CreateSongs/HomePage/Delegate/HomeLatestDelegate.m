//
//  HomeLatestDelegate.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/15.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "HomeLatestDelegate.h"
#import "LatestTableViewCell.h"
#import "AXGHeader.h"

@implementation HomeLatestDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    LatestTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifier];
    
    if (self.latestType == allType) {
        cell.shouldShowTagImage = YES;
    } else {
        cell.shouldShowTagImage = NO;
    }
    
    if (self.dataSource.count > indexPath.row) {
        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 131 * WIDTH_NIT;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    LatestTableViewCell *cell = (LatestTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];

    if (self.latestSelectBlock) {
        self.latestSelectBlock(cell);
    }
}

@end
