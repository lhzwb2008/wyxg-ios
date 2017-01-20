//
//  SongListTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/15.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SongListTableViewCell.h"
#import "AXGHeader.h"
#import "UIImageView+WebCache.h"
#import "ActivityModel.h"

@implementation SongListTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell {
    
    self.firstImage = [UIImageView new];
    [self.contentView addSubview:self.firstImage];
    self.firstImage.layer.cornerRadius = 5;
    self.firstImage.layer.masksToBounds = YES;
//    self.firstImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.secondImage = [UIImageView new];
    [self.contentView addSubview:self.secondImage];
    self.secondImage.layer.cornerRadius = 5;
    self.secondImage.layer.masksToBounds = YES;
//    self.secondImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.thirdImage = [UIImageView new];
    [self.contentView addSubview:self.thirdImage];
    self.thirdImage.layer.cornerRadius = 5;
    self.thirdImage.layer.masksToBounds = YES;
//    self.thirdImage.contentMode = UIViewContentModeScaleAspectFit;
    
    self.firstButton = [UIButton new];
    self.firstButton.layer.cornerRadius = 5;
    self.firstButton.layer.masksToBounds = YES;
    self.firstButton.tag = 100;
    [self.firstButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.firstButton];
    self.firstButton.backgroundColor = [UIColor clearColor];
    
    self.secondButton = [UIButton new];
    self.secondButton.layer.cornerRadius = 5;
    self.secondButton.layer.masksToBounds = YES;
    self.secondButton.tag = 101;
    [self.secondButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.secondButton];
    self.secondButton.backgroundColor = [UIColor clearColor];
    
    self.thirdButton = [UIButton new];
    self.thirdButton.layer.cornerRadius = 5;
    self.thirdButton.layer.masksToBounds = YES;
    self.thirdButton.tag = 102;
    [self.thirdButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:self.thirdButton];
    self.thirdButton.backgroundColor = [UIColor clearColor];
    
}

- (void)setDataSource:(NSArray *)dataSource {
    _dataSource = dataSource;
    
    ActivityModel *model0 = dataSource[0];
    ActivityModel *model1 = dataSource[1];
    ActivityModel *model2 = dataSource[2];
    
    [self.firstImage sd_setImageWithURL:[NSURL URLWithString:model0.img] placeholderImage:[UIImage imageNamed:@"歌单_纵"]];
    [self.secondImage sd_setImageWithURL:[NSURL URLWithString:model1.img] placeholderImage:[UIImage imageNamed:@"歌单_横"]];
    [self.thirdImage sd_setImageWithURL:[NSURL URLWithString:model2.img] placeholderImage:[UIImage imageNamed:@"歌单_横"]];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.firstButton.frame = CGRectMake(2 * WIDTH_NIT, 0, 130 * WIDTH_NIT, 250 * WIDTH_NIT);
    
    self.secondButton.frame = CGRectMake(self.firstButton.right + 2 * WIDTH_NIT, 0, 239 * WIDTH_NIT, 124 * WIDTH_NIT);
    
    self.thirdButton.frame = CGRectMake(self.secondButton.left, self.secondButton.bottom + 2 * WIDTH_NIT, self.secondButton.width, self.secondButton.height);
    
//    self.thirdButton.backgroundColor = [UIColor redColor];
//    self.secondButton.backgroundColor = [UIColor redColor];
//        self.firstButton.backgroundColor = [UIColor redColor];
    
    self.firstImage.frame = self.firstButton.frame;
    self.secondImage.frame = self.secondButton.frame;
    self.thirdImage.frame = self.thirdButton.frame;
}

- (void)buttonAction:(UIButton *)sender {
    if (self.songlistBlock) {
        self.songlistBlock(sender.tag - 100);
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
