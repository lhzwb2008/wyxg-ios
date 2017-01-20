//
//  HomeRankCell.m
//  CreateSongs
//
//  Created by axg on 16/7/25.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "HomeRankCell.h"
#import "UIColor+expanded.h"
#import "AXGHeader.h"

static NSString *const rankIndentifier = @"rankIndentifier";

@implementation HomeRankCell

+ (instancetype)customRankCellWithTableView:(UITableView *)tableView {
    
    HomeRankCell *cell = [tableView dequeueReusableCellWithIdentifier:rankIndentifier];
    
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rankIndentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    self.songPic = [UIImageView new];
    self.sanjiaoPic = [UIImageView new];
    self.leftNumberLabel = [UILabel new];
    self.songName = [UILabel new];
    self.songCreater = [UILabel new];
    self.playCount = [UILabel new];
    self.playCountRight = [UIImageView new];
    self.seperateLine = [UILabel new];
    self.numberTopImg = [UIImageView new];
    
    self.songPic.backgroundColor = [UIColor clearColor];
    self.sanjiaoPic.backgroundColor = [UIColor clearColor];
    self.sanjiaoPic.image = [UIImage imageNamed:@"播放icon"];
    
    self.leftNumberLabel.textColor = [UIColor colorWithHexString:@"#535353"];
    self.leftNumberLabel.font = TECU_FONT(15*WIDTH_NIT);
    self.leftNumberLabel.backgroundColor = [UIColor clearColor];
    
    self.songName.textColor = [UIColor colorWithHexString:@"#535353"];
    self.songName.font = JIACU_FONT(12*WIDTH_NIT);
    self.songName.backgroundColor = [UIColor clearColor];
    
    
    self.songCreater.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    self.songCreater.font = JIACU_FONT(12*WIDTH_NIT);
    self.songCreater.backgroundColor = [UIColor clearColor];
    
    self.playCount.textColor = [UIColor colorWithHexString:@"#441D11"];
    self.playCount.font = [UIFont fontWithName:@"HiraKakuProN-W6" size:24*WIDTH_NIT];
    self.playCount.backgroundColor = [UIColor clearColor];
    self.playCount.textAlignment = NSTextAlignmentRight;
    
//    self.playCountRight.textColor = [UIColor colorWithHexString:@"#535353"];
//    self.playCountRight.font = NORML_FONT(15*WIDTH_NIT);
//    self.playCountRight.backgroundColor = [UIColor clearColor];
//    self.playCountRight.text = @"次";
    self.playCountRight.image = [UIImage imageNamed:@"试听量"];
    self.playCountRight.backgroundColor = [UIColor clearColor];
    
    self.numberTopImg.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.songPic];
    [self.contentView addSubview:self.sanjiaoPic];
    [self.contentView addSubview:self.leftNumberLabel];
    [self.contentView addSubview:self.songName];
    [self.contentView addSubview:self.songCreater];
    [self.contentView addSubview:self.playCount];
    [self.contentView addSubview:self.playCountRight];
    [self.contentView addSubview:self.seperateLine];
    [self.contentView addSubview:self.numberTopImg];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGSize leftNumberSize = [@"1" getWidth:@"1" andFont:self.leftNumberLabel.font];
    
    self.leftNumberLabel.frame = CGRectMake(15*WIDTH_NIT, 0, leftNumberSize.width * 3, leftNumberSize.height);
    self.leftNumberLabel.centerY = self.contentView.height / 2;
    
    CGSize numberImgSize = CGSizeMake(15*WIDTH_NIT, 14*WIDTH_NIT);
    self.numberTopImg.frame = CGRectMake(0, self.leftNumberLabel.top-numberImgSize.height, numberImgSize.width, numberImgSize.height);
    self.numberTopImg.centerX = self.leftNumberLabel.left + leftNumberSize.width/2;
    
    CGFloat songPicHeight = self.contentView.height - 24*WIDTH_NIT;
    self.songPic.frame = CGRectMake(self.leftNumberLabel.left + leftNumberSize.width + 20*WIDTH_NIT, 0, songPicHeight, songPicHeight);
    self.songPic.clipsToBounds = YES;
    self.songPic.layer.cornerRadius = self.songPic.height / 2;
    self.songPic.centerY = self.contentView.height / 2;
    
    self.sanjiaoPic.frame = CGRectMake(0, 0, 14*WIDTH_NIT, 18*WIDTH_NIT);
    self.sanjiaoPic.center = self.songPic.center;
    self.sanjiaoPic.centerX = self.sanjiaoPic.centerX + 2*WIDTH_NIT;
    
    CGSize songNameSize = [@"歌曲名歌曲名的" getWidth:@"歌曲名歌曲名的" andFont:self.songName.font];
    self.songName.frame = CGRectMake(self.songPic.right + 11*WIDTH_NIT, self.songPic.top + 5*WIDTH_NIT, songNameSize.width, songNameSize.height);
    self.songCreater.frame = CGRectMake(self.songName.left, self.songName.bottom + 5*WIDTH_NIT, self.songName.width, self.songName.height);
    
//    CGSize playCountRightSize = [@"次" getWidth:@"次" andFont:self.playCountRight.font];
    CGSize playRightSize = CGSizeMake(15*WIDTH_NIT, 14.5*WIDTH_NIT);
    self.playCountRight.frame = CGRectMake(self.contentView.width - 16*WIDTH_NIT - playRightSize.width, 0, playRightSize.width, playRightSize.height);
    self.playCountRight.centerY = self.contentView.height / 2;
    
    CGSize playCountSize = [@"12345" getWidth:@"12345" andFont:self.playCount.font];
    self.playCount.frame = CGRectMake(self.playCountRight.left - 16*WIDTH_NIT - playCountSize.width, 0, playCountSize.width, playCountSize.height);
    self.playCount.centerY = self.contentView.height / 2;
    
    self.seperateLine.frame = CGRectMake(0, self.contentView.height-1, self.contentView.width, 1);
}

- (void)setDataModel:(HomePageUserMess *)dataModel {
    _dataModel = dataModel;
    
    NSURL *songPicUrl = [NSURL URLWithString:[NSString stringWithFormat:GET_SONG_IMG, _dataModel.code]];
    [self.songPic sd_setImageWithURL:songPicUrl placeholderImage:[UIImage imageNamed:@"placeholder"]];
    
    self.songName.text = _dataModel.title;
    NSString *deCodeOriginalTitle = [dataModel.original_title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    if (deCodeOriginalTitle.length != 0) {
        self.songName.text = [dataModel.title stringByAppendingString:[NSString stringWithFormat:@"(原曲:%@)", deCodeOriginalTitle]];
    } else {
        self.songName.text = dataModel.title;
    }
    
    self.songCreater.text = _dataModel.user_name;
    if ([_dataModel.play_count integerValue] > 99999) {
        self.playCount.text = [NSString stringWithFormat:@"%.1f万", [_dataModel.play_count integerValue] / 100000.0];
    }
    self.playCount.text = _dataModel.play_count;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    self.leftNumberLabel.text = [NSString stringWithFormat:@"%ld", index];
    if (index <= 10) {
        self.seperateLine.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
    } else {
        self.seperateLine.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    }
    if (index == 1) {
        self.numberTopImg.image = [UIImage imageNamed:@"冠军icon"];
    } else if (index == 2) {
        self.numberTopImg.image = [UIImage imageNamed:@"亚军icon"];
    } else if (index == 3) {
        self.numberTopImg.image = [UIImage imageNamed:@"季军icon"];
    } else {
        self.numberTopImg.image = nil;
    }
}


@end
