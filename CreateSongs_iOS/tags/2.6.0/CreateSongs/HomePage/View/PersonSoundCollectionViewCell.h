//
//  PersonSoundCollectionViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/22.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongModel.h"
@class UserModel;

@interface PersonSoundCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *bgImage;

@property (nonatomic, strong) UIImageView *themeImage;

@property (nonatomic, strong) UIImageView *playImage;

@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong)  UserModel*model;

@end
