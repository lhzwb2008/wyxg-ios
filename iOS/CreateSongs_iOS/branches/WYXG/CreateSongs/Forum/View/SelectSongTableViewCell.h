//
//  SelectSongTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/9/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongModel.h"

@interface SelectSongTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *themeImage;

@property (nonatomic, strong) UIImageView *maskImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) SongModel *model;

@end
