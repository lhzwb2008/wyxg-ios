//
//  SearchSongTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/24.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class SongModel;

@interface SearchSongTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *themeImage;

@property (nonatomic, strong) UILabel *mainTitle;

@property (nonatomic, strong) UILabel *subTitle;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) SongModel *songModel;

- (void)initCell;

@end
