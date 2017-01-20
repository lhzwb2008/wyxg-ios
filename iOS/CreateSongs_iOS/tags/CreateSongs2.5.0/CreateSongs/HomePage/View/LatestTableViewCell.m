//
//  LatestTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/15.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "LatestTableViewCell.h"
#import "AXGHeader.h"
#import "NSString+Common.h"
#import "AXGTools.h"
#import "NSString+Emojize.h"

@implementation LatestTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.themeImage.frame = CGRectMake(16 * WIDTH_NIT, 18 * WIDTH_NIT, 95 * WIDTH_NIT, 95 * WIDTH_NIT);
    
    self.titleLabel.frame = CGRectMake(self.themeImage.right + 16 * WIDTH_NIT, 9 * WIDTH_NIT, 200 * WIDTH_NIT, 33 * WIDTH_NIT);
    
    self.nameLabel.frame = CGRectMake(self.titleLabel.left, 31 * WIDTH_NIT, 200 * WIDTH_NIT, 32 * WIDTH_NIT);
    
    self.lyricLabel.frame = CGRectMake(self.nameLabel.left, 55 * WIDTH_NIT, 200 * WIDTH_NIT, 32 * WIDTH_NIT);
    
    self.timeLabel.frame = CGRectMake(self.width - 115 * WIDTH_NIT, self.titleLabel.top, 100 * WIDTH_NIT, self.titleLabel.height);
    
    self.cellPhoneImage.frame = CGRectMake(self.width - 140 * WIDTH_NIT, 0, 15 * WIDTH_NIT, 14.5 * WIDTH_NIT);
    self.cellPhoneImage.center = CGPointMake(self.cellPhoneImage.centerX, self.height - 18 * WIDTH_NIT - 5 * WIDTH_NIT);
    
    self.playCountLabel.frame = CGRectMake(self.cellPhoneImage.right + 5 * WIDTH_NIT, self.cellPhoneImage.top, self.cellPhoneImage.width * 2, self.cellPhoneImage.height);
    
    self.loveImage.frame = CGRectMake(self.playCountLabel.right + 25 * WIDTH_NIT, self.cellPhoneImage.top, self.cellPhoneImage.width, self.cellPhoneImage.height);
    
    self.loveCountLabel.frame = CGRectMake(self.loveImage.right + 5 * WIDTH_NIT, self.loveImage.top, self.loveImage.width * 2, self.loveImage.height);
    
    //    self.bottomLine.frame = CGRectMake(16 * WIDTH_NIT, self.themeImage.bottom + 17.5, self.width - 16 * WIDTH_NIT, 0.5);
    self.bottomLine.frame = CGRectMake(16 * WIDTH_NIT, self.height - 0.5, self.width - 16 * WIDTH_NIT, 0.5);
    
    self.tagImage.frame = CGRectMake(self.width - 75 * WIDTH_NIT - 48 * WIDTH_NIT, 24 * WIDTH_NIT, 48 * WIDTH_NIT, 45 * WIDTH_NIT);
    
}

- (void)setModel:(SongModel *)model {
    _model = model;
    
    NSString *themeImageUrl = [NSString stringWithFormat:GET_SONG_IMG, model.code];
    
    [self.themeImage sd_setImageWithURL:[NSURL URLWithString:themeImageUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.titleLabel.text = [model.title emojizedString];
    
    NSString *deCodeOriginalTitle = [model.original_title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (deCodeOriginalTitle.length != 0) {
        self.titleLabel.text = [[model.title emojizedString] stringByAppendingString:[NSString stringWithFormat:@"(原曲:%@)", deCodeOriginalTitle]];
    } else {
        self.titleLabel.text = [model.title emojizedString];
    }
    
//    NSString *tag = [model.tag stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
//    
//    if (tag.length == 0) {
//        self.tagImage.hidden = YES;
//    } else {
//        self.tagImage.hidden = NO;
//        if ([tag isEqualToString:@"演唱"]) {
//            self.tagImage.image = [UIImage imageNamed:@"人声印章"];
//        } else {
//            self.tagImage.image = [UIImage imageNamed:@"改曲印章"];
//        }
//    }
    
    if (self.shouldShowTagImage) {
        if ([model.gai isEqualToString:@"0"] && [model.sing isEqualToString:@"0"]) {
            
            self.tagImage.hidden = YES;
            
        } else if ([model.gai isEqualToString:@"1"] && [model.sing isEqualToString:@"0"]) {
            
            self.tagImage.hidden = NO;
            self.tagImage.image = [UIImage imageNamed:@"改曲印章"];
        
        } else if (([model.gai isEqualToString:@"0"] && [model.sing isEqualToString:@"1"]) || ([model.gai isEqualToString:@"1"] && [model.sing isEqualToString:@"1"])) {
            
            self.tagImage.hidden = NO;
            self.tagImage.image = [UIImage imageNamed:@"人声印章"];
        }
    } else {
        self.tagImage.hidden = YES;
    }
    
    
    
    self.nameLabel.text = [[NSString stringWithFormat:@"作者：%@", model.user_name] emojizedString];
    
    self.timeLabel.text = [AXGTools intervalSinceNow:model.create_time];
    
    if (self.model.play_count.integerValue >= 10000) {
        float playCount = self.model.play_count.integerValue / 10000.0;
        self.playCountLabel.text = [NSString stringWithFormat:@"%.1f万", playCount];
    } else {
        self.playCountLabel.text = self.model.play_count;
    }
    
    self.loveCountLabel.text = model.up_count;
    
    NSString *lyricUrl = [NSString stringWithFormat:HOME_LYRIC, model.code];
    WEAK_SELF;
    [XWAFNetworkTool getUrl:lyricUrl body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        NSString *lyric = [[NSString alloc] initWithData:resposeObject encoding:NSUTF8StringEncoding];
        self.lyricLabel.text = [[lyric componentsSeparatedByString:@":"] lastObject];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
}

- (void)createCell {
    
    self.backgroundColor = HexStringColor(@"#eeeeee");
    
    self.shouldShowTagImage = YES;
    
    self.themeImage = [UIImageView new];
    [self.contentView addSubview:self.themeImage];
    self.themeImage.layer.cornerRadius = 5;
    self.themeImage.layer.masksToBounds = YES;
    self.themeImage.contentMode = UIViewContentModeScaleAspectFill;
    
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    self.titleLabel.textColor = HexStringColor(@"#535353");
    [self.titleLabel setFont:JIACU_FONT(15)];
    
    self.nameLabel = [UILabel new];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.textColor = HexStringColor(@"#535353");
    self.nameLabel.font = ZHONGDENG_FONT(12);
    
    self.lyricLabel = [UILabel new];
    [self.contentView addSubview:self.lyricLabel];
    self.lyricLabel.textColor = HexStringColor(@"a0a0a0");
    self.lyricLabel.font = NORML_FONT(12);
    
    self.timeLabel = [UILabel new];
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.textColor = HexStringColor(@"#a0a0a0");
    self.timeLabel.font = ZHONGDENG_FONT(12);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    
    self.cellPhoneImage = [UIImageView new];
    [self.contentView addSubview:self.cellPhoneImage];
    self.cellPhoneImage.image = [UIImage imageNamed:@"试听量"];
    
    self.loveImage = [UIImageView new];
    [self.contentView addSubview:self.loveImage];
    self.loveImage.image = [UIImage imageNamed:@"喜欢"];
    
    self.playCountLabel = [UILabel new];
    [self.contentView addSubview:self.playCountLabel];
    self.playCountLabel.font = NORML_FONT(10);
    self.playCountLabel.textColor = HexStringColor(@"#a0a0a0");
    
    self.loveCountLabel = [UILabel new];
    [self.contentView addSubview:self.loveCountLabel];
    self.loveCountLabel.font = NORML_FONT(10);
    self.loveCountLabel.textColor = HexStringColor(@"#a0a0a0");
    
    self.bottomLine = [UIView new];
    [self.contentView addSubview:self.bottomLine];
//    self.bottomLine.backgroundColor = HexStringColor(@"#879999");
    self.bottomLine.backgroundColor = HexStringColor(@"#ffffff");
    
    self.tagImage = [UIImageView new];
    [self.contentView addSubview:self.tagImage];
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
