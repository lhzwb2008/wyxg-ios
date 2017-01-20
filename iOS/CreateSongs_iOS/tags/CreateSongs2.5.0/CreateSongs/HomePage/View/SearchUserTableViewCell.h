//
//  SearchUserTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/24.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SearchSongTableViewCell.h"
@class UserModel;

@interface SearchUserTableViewCell : SearchSongTableViewCell

@property (nonatomic, strong) UserModel *userModel;

@property (nonatomic, strong) UIImageView *genderImage;

@end
