//
//  RecommandCollectionViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/14.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongModel.h"

@interface RecommandCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *themeImage;

@property (nonatomic, strong) UIImageView *maskImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, copy) NSString *lyricUrl;

@property (nonatomic, strong) UIView *maskView;

@property (nonatomic, strong) SongModel *model;

@end
