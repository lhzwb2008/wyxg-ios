//
//  ForumTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "ForumTableViewCell.h"
#import "AXGHeader.h"
#import "UIImageView+WebCache.h"
#import "NSString+Emojize.h"
#import "AXGTools.h"
#import "ForumAlbumView.h"

@implementation ForumTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

// 创建cell
- (void)createCell {
    
    self.backgroundColor = HexStringColor(@"eeeeee");
    
    self.bgView = [UIView new];
    [self.contentView addSubview:self.bgView];
    self.bgView.backgroundColor = [UIColor whiteColor];
    self.bgView.layer.cornerRadius = 2.5 * WIDTH_NIT;
    self.bgView.layer.masksToBounds = YES;
    
    self.headImage = [UIImageView new];
    [self.contentView addSubview:self.headImage];
    self.headImage.layer.borderColor = HexStringColor(@"#879999").CGColor;
    self.headImage.layer.borderWidth = 1.5;
    
    self.nameLabel = [UILabel new];
    [self.contentView addSubview:self.nameLabel];
    self.nameLabel.textColor = HexStringColor(@"#535353");
    self.nameLabel.font = NORML_FONT(12);
    
    self.genderImage = [UIImageView new];
    [self.contentView addSubview:self.genderImage];
    
    self.contentLabel = [UILabel new];
    [self.contentView addSubview:self.contentLabel];
    self.contentLabel.textColor = HexStringColor(@"#535353");
    self.contentLabel.font = JIACU_FONT(12);
    self.contentLabel.numberOfLines = 2;
    
    self.themeImage = [UIImageView new];
    [self.contentView addSubview:self.themeImage];
    self.themeImage.contentMode = UIViewContentModeScaleAspectFill;
    self.themeImage.clipsToBounds = YES;
    
    self.timeLabel = [UILabel new];
    [self.contentView addSubview:self.timeLabel];
    self.timeLabel.textColor = HexStringColor(@"#a0a0a0");
    self.timeLabel.font = JIACU_FONT(10);
    
    self.replyImage = [UIImageView new];
    [self.contentView addSubview:self.replyImage];
    self.replyImage.image = [UIImage imageNamed:@"评论数icon"];
//    self.replyImage.backgroundColor = [UIColor redColor];
    
    self.replyNumber = [UILabel new];
    [self.contentView addSubview:self.replyNumber];
    self.replyNumber.textColor = [UIColor colorWithHexString:@"a0a0a0"];
    self.replyNumber.font = JIACU_FONT(10);
    
    self.topLabel = [UILabel new];
    [self.contentView addSubview:self.topLabel];
    self.topLabel.text = @"置顶";
    self.topLabel.textColor = [UIColor whiteColor];
    self.topLabel.backgroundColor = HexStringColor(@"#441D11");
    self.topLabel.layer.cornerRadius = 6 * WIDTH_NIT;
    self.topLabel.layer.masksToBounds = YES;
    self.topLabel.hidden = YES;
    self.topLabel.textAlignment = NSTextAlignmentCenter;
    self.topLabel.font = JIACU_FONT(10 * WIDTH_NIT);
    
    self.albumView = [[ForumAlbumView alloc] initWithFrame:CGRectZero];
    [self.contentView addSubview:self.albumView];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.bgView.frame = CGRectMake(16 * WIDTH_NIT, 22.5 * WIDTH_NIT, self.width - 32 * WIDTH_NIT, self.height - 15 * WIDTH_NIT - 22.5 * WIDTH_NIT);
    
    self.headImage.frame = CGRectMake(16 * WIDTH_NIT + 21 * WIDTH_NIT, 0, 45 * WIDTH_NIT, 45 * WIDTH_NIT);
    self.headImage.layer.cornerRadius = self.headImage.width / 2;
    self.headImage.layer.masksToBounds = YES;
    
    self.nameLabel.frame = CGRectMake(self.headImage.right + 15 * WIDTH_NIT, 0, self.width - 10 * WIDTH_NIT * 3 - 36 * WIDTH_NIT, 17 * WIDTH_NIT);
    
    self.genderImage.frame = CGRectMake(self.nameLabel.right + 7 * WIDTH_NIT, 0, 12 * WIDTH_NIT, 12 * WIDTH_NIT);
    self.genderImage.center = CGPointMake(self.genderImage.centerX, self.nameLabel.centerY);
    
    CGFloat width = [AXGTools getTextWidth:self.nameLabel.text font:self.nameLabel.font];
    self.genderImage.frame = CGRectMake(self.headImage.right + 15 * WIDTH_NIT + width + 8 * WIDTH_NIT, self.genderImage.top, self.genderImage.width, self.genderImage.height);
    
    self.topLabel.frame = CGRectMake(self.width - 16 * WIDTH_NIT - 30 * WIDTH_NIT, 9 * WIDTH_NIT, 30 * WIDTH_NIT, 12 * WIDTH_NIT);
    self.topLabel.center = CGPointMake(self.topLabel.centerX, self.nameLabel.centerY);
    self.topLabel.layer.cornerRadius = self.topLabel.height / 2;
    self.topLabel.layer.masksToBounds = YES;
    
    self.contentLabel.frame = CGRectMake(self.nameLabel.left, self.bgView.top + 5 * WIDTH_NIT, self.width - self.nameLabel.left - 11 * WIDTH_NIT - 16 * WIDTH_NIT, 50 * WIDTH_NIT);
    
    if (self.contentType == ImageAndAlbumNone) {
        self.themeImage.frame = CGRectZero;
        self.albumView.frame = CGRectZero;
    } else if (self.contentType == ImageOnly) {
        self.themeImage.frame = CGRectMake(self.contentLabel.left, self.contentLabel.bottom, self.contentLabel.width, self.contentLabel.width);
        self.albumView.frame = CGRectZero;
    } else if (self.contentType == AlbumOnly) {
        self.themeImage.frame = CGRectZero;
        self.albumView.frame = CGRectMake(self.contentLabel.left, self.contentLabel.bottom, self.contentLabel.width, 75 * WIDTH_NIT);
        [self.albumView resetFrame];
    } else {
        self.albumView.frame = CGRectMake(self.contentLabel.left, self.contentLabel.bottom, self.contentLabel.width, 75 * WIDTH_NIT);
        [self.albumView resetFrame];
        self.themeImage.frame = CGRectMake(self.contentLabel.left, self.albumView.bottom + 10 * WIDTH_NIT, self.contentLabel.width, self.contentLabel.width);
    }
    
//    self.themeImage.frame = CGRectMake(self.contentLabel.left, self.contentLabel.bottom, self.contentLabel.width, self.contentLabel.width);
    
    self.timeLabel.frame = CGRectMake(self.contentLabel.left, self.height - 45 * WIDTH_NIT, 70 * WIDTH_NIT, 30 * WIDTH_NIT);
    
    self.replyImage.frame = CGRectMake(self.timeLabel.left + 65 * WIDTH_NIT, 0, 11 * WIDTH_NIT, 11 * WIDTH_NIT);
    self.replyImage.center = CGPointMake(self.replyImage.centerX, self.timeLabel.centerY);
    
    self.replyNumber.frame = CGRectMake(self.replyImage.right + 6 * WIDTH_NIT, self.timeLabel.top, 100, self.timeLabel.height);
}

- (void)setForumModel:(ForumModel *)forumModel {
    _forumModel = forumModel;
    
    self.contentLabel.text = [forumModel.content emojizedString];
    self.replyNumber.text = forumModel.comments_count;
    
    if (forumModel.phone.length != 0) {
        [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_USER_HEAD, [NSString stringWithFormat:@"%@", [XWAFNetworkTool md5HexDigest:forumModel.phone]]]] placeholderImage:[UIImage imageNamed:@"头像"]];
    } else {
        self.headImage.image = [UIImage imageNamed:@"头像"];
    }
    
    self.nameLabel.text = [forumModel.user_name emojizedString];
    
    if ([forumModel.gender isEqualToString:@"1"]) {
        self.genderImage.image = [UIImage imageNamed:@"男icon"];
    } else {
        self.genderImage.image = [UIImage imageNamed:@"女icon"];
    }
    
    if ([forumModel.is_top isEqualToString:@"1"]) {
        self.topLabel.hidden = NO;
    } else {
        self.topLabel.hidden = YES;
    }
    
    if (forumModel.img_url.length != 0) {
        [self.themeImage sd_setImageWithURL:[NSURL URLWithString:forumModel.img_url] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        
        self.themeImage.hidden = NO;
        
    } else {

        self.themeImage.hidden = YES;
        
    }
    
    if (![forumModel.song_id isEqualToString:@"0"]) {
        
        self.albumView.hidden = NO;
        
        NSString *imgUrl = [NSString stringWithFormat:GET_SONG_IMG, forumModel.song.code];
        [self.albumView.themeImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"placeholder"]];
        self.albumView.titleLabel.text = forumModel.song.title;
        self.albumView.code = forumModel.song.code;
        
        NSString *zuociId = @"";
        NSString *zuoquId = @"";
        NSString *yanchangId = @"";
        
        if ([forumModel.song.zuoci_id isEqualToString:@"0"]) {
            zuociId = self.forumModel.song.user_id;
        } else {
            zuociId = self.forumModel.song.zuoci_id;
        }
        
        if ([forumModel.song.zuoqu_id isEqualToString:@"0"]) {
            zuoquId = self.forumModel.song.user_id;
        } else {
            zuoquId = self.forumModel.song.zuoqu_id;
        }
        
        if ([forumModel.song.yanchang_id isEqualToString:@"0"]) {
            yanchangId = self.forumModel.song.user_id;
        } else {
            yanchangId = self.forumModel.song.yanchang_id;
        }
        
        [self getThreeNamezuociId:zuociId zuoquId:zuoquId yanchangId:yanchangId];
        
    } else {
        self.albumView.hidden = YES;
    }
    
    self.timeLabel.text = [AXGTools intervalSinceNow:forumModel.modify_time];
    
}

- (void)getThreeNamezuociId:(NSString *)zuociId zuoquId:(NSString *)zuoquId yanchangId:(NSString *)yanchangId {
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, zuociId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        
        NSString *name = resposeObject[@"name"];
        self.albumView.lyricLabel.text = [NSString stringWithFormat:@"作词：%@", name];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, zuoquId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        
        NSString *name = resposeObject[@"name"];
        self.albumView.songLabel.text = [NSString stringWithFormat:@"作曲：%@", name];
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    if ([yanchangId hasPrefix:@"-"]) {
        
        if ([yanchangId isEqualToString:@"-1"]) {
            self.albumView.singerLabel.text = @"演唱：暖男";
        } else if ([yanchangId isEqualToString:@"-2"]) {
            self.albumView.singerLabel.text = @"演唱：正太";
        } else if ([yanchangId isEqualToString:@"-3"]) {
            self.albumView.singerLabel.text = @"演唱：娃娃";
        } else if ([yanchangId isEqualToString:@"-5"]) {
            self.albumView.singerLabel.text = @"演唱：御姐";
        } else {
            self.albumView.singerLabel.text = @"演唱：萝莉";
        }
        
    } else {
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, yanchangId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            
            NSString *name = resposeObject[@"name"];
            self.albumView.singerLabel.text = [NSString stringWithFormat:@"演唱：%@", name];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
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
