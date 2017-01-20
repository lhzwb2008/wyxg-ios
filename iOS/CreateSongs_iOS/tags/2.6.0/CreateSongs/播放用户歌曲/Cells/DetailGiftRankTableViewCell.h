//
//  DetailGiftRankTableViewCell.h
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/26.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import <UIKit/UIKit.h>
@class GiftUserModel;

@interface DetailGiftRankTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView *goldImage;

@property (nonatomic, strong) UIImageView *headImage;

@property (nonatomic, strong) UILabel *nameLabel;

@property (nonatomic, strong) UILabel *rankLabel;

@property (nonatomic, strong) UIImageView *flowerImage;

@property (nonatomic, strong) UILabel *numberLabel;

@property (nonatomic, strong) UIView *lineView;

@property (nonatomic, strong) GiftUserModel *model;

@end
