//
//  HomeActivityDelegate.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "HomeActivityDelegate.h"
#import "ActivityTableViewCell.h"
#import "AXGHeader.h"
#import "ActivityDetailViewController.h"

@implementation HomeActivityDelegate

#pragma mark - UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ActivityTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifier];

    cell.overImage.hidden = YES;
    
    if (self.dataSource.count > indexPath.row) {

        cell.model = self.dataSource[indexPath.row];
    }
    return cell;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 195 * WIDTH_NIT;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    tableView.allowsSelection = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        tableView.allowsSelection = YES;
    });
    
    ActivityTableViewCell *cell = (ActivityTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
    
    if (self.activitySelectBlock) {
        self.activitySelectBlock(cell);
    }

}

@end
