//
//  SelectSongTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/9/7.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SelectSongTableViewCell.h"
#import "AXGHeader.h"
#import "AXGTools.h"

@implementation SelectSongTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

- (void)initCell {
    self.themeImage = [UIImageView new];
    self.themeImage.layer.cornerRadius = 7;
    self.themeImage.layer.masksToBounds = YES;
    [self addSubview:self.themeImage];
    
    self.maskImage = [UIImageView new];
    self.maskImage.image = [UIImage imageNamed:@"个性推荐模板"];
    self.themeImage.layer.cornerRadius = 5;
    self.themeImage.layer.masksToBounds = YES;
    [self addSubview:self.maskImage];
    
    self.titleLabel = [UILabel new];
    [self addSubview:self.titleLabel];
    self.titleLabel.textColor = HexStringColor(@"#535353");
    self.titleLabel.font = JIACU_FONT(12);
    
    self.nameLabel = [UILabel new];
    [self addSubview:self.nameLabel];
    self.nameLabel.textColor = HexStringColor(@"#535353");
    self.nameLabel.font = NORML_FONT(12);
    
    self.timeLabel = [UILabel new];
    [self addSubview:self.timeLabel];
    self.timeLabel.textColor = HexStringColor(@"#a0a0a0");
    self.timeLabel.font = JIACU_FONT(12);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    
    self.lineView = [UIView new];
    [self addSubview:self.lineView];
    self.lineView.backgroundColor = HexStringColor(@"#eeeeee");
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.themeImage.frame = CGRectMake(16 * WIDTH_NIT, 15 * WIDTH_NIT, 75 * WIDTH_NIT, 75 * WIDTH_NIT);
    
    self.maskImage.frame = self.themeImage.frame;
    
    self.titleLabel.frame = CGRectMake(self.themeImage.right + 10 * WIDTH_NIT, self.themeImage.top, 200 * WIDTH_NIT, 32 * WIDTH_NIT);
    
    self.nameLabel.frame = CGRectMake(self.titleLabel.left, self.themeImage.top + 22 * WIDTH_NIT, 200 * WIDTH_NIT, 42 * WIDTH_NIT);
    
    self.timeLabel.frame = CGRectMake(self.width - 200 * WIDTH_NIT - 16 * WIDTH_NIT, self.titleLabel.top, 200 * WIDTH_NIT, self.titleLabel.height);
    
    self.lineView.frame = CGRectMake(16 * WIDTH_NIT, self.height - 0.5, self.width - 16 * WIDTH_NIT, 0.5);
    
}

- (void)setModel:(SongModel *)model {
    _model = model;
    
    NSString *imgUrl = [NSString stringWithFormat:GET_SONG_IMG, model.code];
    [self.themeImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    self.titleLabel.text = model.title;
    self.nameLabel.text = [NSString stringWithFormat:@"作者：%@", model.user_name];
    self.timeLabel.text = [AXGTools intervalSinceNow:model.create_time];
    
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
