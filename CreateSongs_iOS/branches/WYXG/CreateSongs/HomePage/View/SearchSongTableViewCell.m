//
//  SearchSongTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/8/24.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "SearchSongTableViewCell.h"
#import "AXGHeader.h"
#import "SongModel.h"
#import "NSString+Emojize.h"

@implementation SearchSongTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

- (void)initCell {
    
    self.backgroundColor = HexStringColor(@"#ffffff");
    
    self.themeImage = [UIImageView new];
    [self.contentView addSubview:self.themeImage];
    
    self.mainTitle = [UILabel new];
    [self.contentView addSubview:self.mainTitle];
    self.mainTitle.textColor = HexStringColor(@"#441D11");
    self.mainTitle.font = JIACU_FONT(15);
    self.mainTitle.numberOfLines = 1;
    
    self.subTitle = [UILabel new];
    [self.contentView addSubview:self.subTitle];
    self.subTitle.textColor = HexStringColor(@"#a0a0a0");
    self.subTitle.font = NORML_FONT(12);
    self.subTitle.numberOfLines = 1;
    
    self.lineView = [UIView new];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor = HexStringColor(@"#eeeeee");
}
- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.lineView.frame = CGRectMake(16 * WIDTH_NIT, 0, self.width - 16 * WIDTH_NIT, 0.5);
    
    self.themeImage.frame = CGRectMake(self.lineView.left, self.lineView.bottom + 15 * WIDTH_NIT, 45 * WIDTH_NIT, 45 * WIDTH_NIT);
    self.themeImage.layer.cornerRadius = self.themeImage.height / 2;
    self.themeImage.layer.masksToBounds = YES;
    self.themeImage.layer.borderWidth = 1.5;
    self.themeImage.layer.borderColor = HexStringColor(@"#eeeeee").CGColor;
    
    self.mainTitle.frame = CGRectMake(self.themeImage.right + 10 * WIDTH_NIT, self.lineView.bottom + 6 * WIDTH_NIT, self.width - self.themeImage.right - 10 * WIDTH_NIT, 33 * WIDTH_NIT);
    
    self.subTitle.frame = CGRectMake(self.mainTitle.left, self.lineView.bottom + 15 * WIDTH_NIT + 15 * WIDTH_NIT, self.mainTitle.width, 30 * WIDTH_NIT);
    
}

- (void)setSongModel:(SongModel *)songModel {
    _songModel = songModel;
    
    NSString *url = [NSString stringWithFormat:GET_SONG_IMG, songModel.code];
    
    [self.themeImage sd_setImageWithURL:[NSURL URLWithString:url] placeholderImage:[UIImage imageNamed:@"头像"]];
    
    self.mainTitle.text = songModel.title;
    NSString *deCodeOriginalTitle = [songModel.original_title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (deCodeOriginalTitle.length != 0) {
        self.mainTitle.text = [[songModel.title emojizedString] stringByAppendingString:[NSString stringWithFormat:@"(原曲:%@)", deCodeOriginalTitle]];
    } else {
        self.mainTitle.text = [songModel.title emojizedString];
    }
    
    self.subTitle.text = [NSString stringWithFormat:@"作者:%@", songModel.user_name];
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
