//
//  LatestTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/15.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongModel.h"

@interface LatestTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *themeImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *lyricLabel;

@property (nonatomic, strong) UILabel *timeLabel;

@property (nonatomic, strong) UIImageView *cellPhoneImage;

@property (nonatomic, strong) UILabel *playCountLabel;

@property (nonatomic, strong) UILabel *loveCountLabel;

@property (nonatomic, strong) UIImageView *loveImage;

@property (nonatomic, strong) SongModel *model;

@property (nonatomic, strong) UIView *bottomLine;

@property (nonatomic, strong) UIImageView *tagImage;

@property (nonatomic, assign) BOOL shouldShowTagImage;

@end
