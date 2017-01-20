//
//  PlayUserSongLyricCell.h
//  CreateSongs
//
//  Created by axg on 16/5/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LyricCellFrameModel.h"

@interface PlayUserSongLyricCell : UITableViewCell

@property (nonatomic, strong) LyricCellFrameModel *lyricFrameModel;

@property (nonatomic, strong) UILabel *songNameLabel;
@property (nonatomic, strong) UILabel *lyricTitleLabel;

@property (nonatomic, strong) UILabel *lineLabel;

@property (nonatomic, strong) NSMutableArray *lyricLabelArray;

+ (instancetype)customCommentCell:(UITableView *)tableView;

@end
