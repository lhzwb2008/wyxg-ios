//
//  DraftsDelegate.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "DraftsDelegate.h"
#import "DraftsTableViewCell.h"
#import "AXGHeader.h"

@implementation DraftsDelegate

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    DraftsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:_identifier];

    if (self.dataSource.count > indexPath.row) {
        NSDictionary *dic = self.dataSource[indexPath.row];
        if (dic) {
            cell.dataSource = dic;
        }
    }
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 106 * WIDTH_NIT + 15 * WIDTH_NIT;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
//    tableView.allowsSelection = NO;
//    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
//        tableView.allowsSelection = YES;
//    });
    
    DraftsTableViewCell *cell = (DraftsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
//
//    NSLog(@"%@", cell.target);
//    
//    [cell willTransitionToState:UITableViewCellStateShowingDeleteConfirmationMask];
    
    if (self.seletBlock) {
        self.seletBlock(cell);
    }

}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        DraftsTableViewCell *cell = (DraftsTableViewCell *)[tableView cellForRowAtIndexPath:indexPath];
        
        NSDictionary *dic = cell.dataSource;
        
        //        NSDictionary *dic = self.dataSource[indexPath.row];
        
        // 这里要用到block
//        [self.dataSource removeObject:dic];
        
        if (self.deleteBlock) {
            self.deleteBlock(dic);
        }
        
        if (self.dbFromType == XianciType) {
            YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:DB_NAME];
            [store deleteObjectById:dic[@"saveTime"] fromTable:TABLE_NAME];
        } else if (self.dbFromType == XianquType) {
            YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:DB_NAME];
            [store deleteObjectById:dic[@"saveTime"] fromTable:TIANCI_DB];
        } else if (self.dbFromType == RECODERTYPE) {
            YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:DB_NAME];
            [store deleteObjectById:dic[@"saveTime"] fromTable:RECODER_DB];
            
            NSFileManager *fileManager = [NSFileManager defaultManager];
            if ([fileManager fileExistsAtPath:cell.voice_recoderPath] && [fileManager fileExistsAtPath:cell.voice_banzouPath]) {
                [fileManager removeItemAtPath:cell.voice_recoderPath error:nil];
                [fileManager removeItemAtPath:cell.voice_banzouPath error:nil];
            }
        }
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        
        // 这里也用block控制
//        if (self.dataSource.count == 0) {
//            self.noDataLabel.hidden = NO;
//            self.noDataImage.hidden = NO;
//            self.lineView.hidden = YES;
//        }
    }
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath {
    return UITableViewCellEditingStyleDelete;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

@end
