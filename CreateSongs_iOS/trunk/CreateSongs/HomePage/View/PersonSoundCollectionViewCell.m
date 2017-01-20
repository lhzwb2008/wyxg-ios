//
//  PersonSoundCollectionViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/22.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PersonSoundCollectionViewCell.h"
#import "AXGHeader.h"
#import "XWAFNetworkTool.h"
#import "UserModel.h"

@implementation PersonSoundCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)createCell {
    
//    self.backgroundColor = [UIColor redColor];

    self.bgImage = [UIImageView new];
    [self.contentView addSubview:self.bgImage];
    self.bgImage.image = [UIImage imageNamed:@"椭圆-13"];
    
    self.themeImage = [UIImageView new];
    [self.contentView addSubview:self.themeImage];
    
    self.playImage = [UIImageView new];
    [self.contentView addSubview:self.playImage];
//    self.playImage.image = [UIImage imageNamed:@"播放"];
    
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.font = JIACU_FONT(12);
    self.titleLabel.textColor = HexStringColor(@"#535353");
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    
    self.nameLabel = [UILabel new];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.font = NORML_FONT(12);
    self.nameLabel.textColor = HexStringColor(@"#a0a0a0");
    self.nameLabel.textAlignment = NSTextAlignmentCenter;
    
}

- (void)setModel:(UserModel *)model {
    _model = model;
    
    NSString *imgUrl = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:model.phone]];
    
    [self.themeImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.titleLabel.text = @"";
    self.nameLabel.text = model.name;

}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.bgImage.frame = CGRectMake(0, 0, self.width, self.width);
    self.bgImage.layer.cornerRadius = self.bgImage.width / 2;
    self.bgImage.layer.masksToBounds = YES;
    self.bgImage.center = CGPointMake(self.width / 2, self.bgImage.centerY);
    
    self.themeImage.frame = CGRectMake(9 * WIDTH_NIT, 9 * WIDTH_NIT, self.width - 18 * WIDTH_NIT, self.width - 18 * WIDTH_NIT);
    self.themeImage.layer.cornerRadius = self.themeImage.width / 2;
    self.themeImage.layer.masksToBounds = YES;
    self.themeImage.center = self.bgImage.center;
    
    self.playImage.frame = CGRectMake(0, 0, 47.5 * WIDTH_NIT, 52 * WIDTH_NIT);
    self.playImage.center = self.themeImage.center;
    
    self.titleLabel.frame = CGRectMake(0, self.themeImage.bottom + 8 * WIDTH_NIT, self.width, 26 * WIDTH_NIT);
    self.titleLabel.center = CGPointMake(self.width / 2, self.titleLabel.centerY);
    
    self.nameLabel.frame = CGRectMake(0, self.themeImage.bottom + 25 * WIDTH_NIT, self.width, 26 * WIDTH_NIT);
    self.nameLabel.center = CGPointMake(self.width / 2, self.nameLabel.centerY);
}

@end
