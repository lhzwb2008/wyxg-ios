//
//  HotTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/14.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongModel.h"

@interface HotTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *playImage;

@property (nonatomic, strong) UIImageView *themeImage;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *hotImage;

@property (nonatomic, strong) UIImageView *myNewImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UIImageView *moreImage;

@property (nonatomic, copy) NSString *lyricUrl;

@property (nonatomic, strong) UIButton *moreButton;

@property (nonatomic, strong) SongModel *songModel;

@end
