//
//  TalentTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/14.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SongModel.h"

@interface TalentTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UIImageView *genderImage;

@property (nonatomic, strong) UIView *bgView;

@property (nonatomic, strong) UIImageView *workImage;

@property (nonatomic, strong) UIImageView *followImage;

@property (nonatomic, strong) UILabel *signatureLabel;

@property (nonatomic, strong) UILabel *workLabel;

@property (nonatomic, strong) UILabel *followLabel;

@property (nonatomic, strong) SongModel *model;

@end
