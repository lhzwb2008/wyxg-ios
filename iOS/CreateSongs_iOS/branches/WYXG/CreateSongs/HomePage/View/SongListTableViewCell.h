//
//  SongListTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/15.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SongListBlock)(NSInteger index);

@interface SongListTableViewCell : UITableViewCell

@property (nonatomic, strong) UIButton *firstButton;

@property (nonatomic, strong) UIButton *secondButton;

@property (nonatomic, strong) UIButton *thirdButton;

@property (nonatomic, strong) UIImageView *firstImage;

@property (nonatomic, strong) UIImageView *secondImage;

@property (nonatomic, strong) UIImageView *thirdImage;

@property (nonatomic, strong) NSArray *dataSource;

@property (nonatomic, copy) SongListBlock songlistBlock;

@end
