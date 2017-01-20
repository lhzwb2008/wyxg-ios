//
//  HotTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/14.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "HotTableViewCell.h"
#import "AXGHeader.h"
#import "UIImageView+WebCache.h"
#import "NSString+Emojize.h"

@implementation HotTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.themeImage.frame = CGRectMake(16 * WIDTH_NIT, 12.5 * WIDTH_NIT, 40 * WIDTH_NIT, 40 * WIDTH_NIT);
    self.themeImage.layer.cornerRadius = self.themeImage.width / 2;
    self.themeImage.layer.masksToBounds = YES;
    
    self.playImage.frame = CGRectMake(0, 0, 14 * WIDTH_NIT, 18 * WIDTH_NIT);
    self.playImage.center = self.themeImage.center;
    
    self.titleLabel.frame = CGRectMake(self.themeImage.right + 8 * WIDTH_NIT, self.themeImage.top, self.width - 104 * WIDTH_NIT, 22 * WIDTH_NIT);
    
    self.hotImage.frame = CGRectMake(self.titleLabel.left, self.titleLabel.bottom, 13 * WIDTH_NIT, 9 * WIDTH_NIT);
    
    self.myNewImage.frame = CGRectMake(self.hotImage.right + 3 * WIDTH_NIT, self.hotImage.top, self.hotImage.width, self.hotImage.height);
    
    self.nameLabel.frame = CGRectMake(self.myNewImage.right + 8 * WIDTH_NIT, 0, self.titleLabel.width - 37 * WIDTH_NIT, 15 * WIDTH_NIT);
    self.nameLabel.center = CGPointMake(self.nameLabel.centerX, self.myNewImage.centerY);
    
    self.moreImage.frame = CGRectMake(self.width - 16 * WIDTH_NIT - 16 * WIDTH_NIT, 0, 16 * WIDTH_NIT, 4 * WIDTH_NIT);
    self.moreImage.center = CGPointMake(self.moreImage.centerX, self.themeImage.centerY);
    
    self.moreButton.frame = CGRectMake(self.width - 40 * WIDTH_NIT, 12.5 * WIDTH_NIT, 40 * WIDTH_NIT, 40 * WIDTH_NIT);
    
}

- (void)setSongModel:(SongModel *)songModel {
    _songModel = songModel;
    
    /**
     *  设置图片文字以及其占位内容
     */
    //    NSArray *array1 = [_dataModel.code componentsSeparatedByString:@"/"];
    //    NSArray *array2 = [[array1 lastObject] componentsSeparatedByString:@"."];
    //    NSString *picName = [array2 firstObject];
    
    NSString *picUrl = [NSString stringWithFormat:GET_SONG_IMG, songModel.code];
    
    [self.themeImage sd_setImageWithURL:[NSURL URLWithString:picUrl] placeholderImage:[UIImage imageNamed:@"homePlaceHolderImg"]];
    WEAK_SELF;
    
    if (songModel.user_name.length != 0) {
        self.nameLabel.text = songModel.user_name;
    } else {
        
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, songModel.user_id] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                self.nameLabel.text = [resposeObject[@"name"] emojizedString];
            }
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }
    
    self.lyricUrl = [NSString stringWithFormat:HOME_LYRIC, songModel.code];
    NSLog(@"_________________%@", self.lyricUrl);
    
    if (songModel.title.length != 0) {
        self.titleLabel.text = songModel.title;
        
        NSString *deCodeOriginalTitle = [songModel.original_title stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
        if (deCodeOriginalTitle.length != 0) {
            self.titleLabel.text = [songModel.title stringByAppendingString:[NSString stringWithFormat:@"(原曲:%@)", deCodeOriginalTitle]];
        } else {
            self.titleLabel.text = songModel.title;
        }
        
    } else {
        
        [XWAFNetworkTool getUrl:self.lyricUrl body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            //        self.title.hidden = NO;
            NSString *lyric = [[NSString alloc] initWithData:resposeObject encoding:NSUTF8StringEncoding];
            self.titleLabel.text = [[lyric componentsSeparatedByString:@":"] firstObject];
            
            if (songModel.original_title.length != 0) {
                self.titleLabel.text = [[[lyric componentsSeparatedByString:@":"] firstObject] stringByAppendingString:[NSString stringWithFormat:@"(原曲:%@)", songModel.original_title]];
            } else {
                self.titleLabel.text = [[lyric componentsSeparatedByString:@":"] firstObject];
            }
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
}

- (void)createCell {
    
    self.backgroundColor = HexStringColor(@"#eeeeee");
    
    self.themeImage = [UIImageView new];
    [self.contentView addSubview:self.themeImage];
    
    self.playImage = [UIImageView new];
    [self.contentView addSubview:self.playImage];
    self.playImage.image = [UIImage imageNamed:@"播放icon"];
    
    self.titleLabel = [UILabel new];
    [self.contentView addSubview:self.titleLabel];
    [self.titleLabel setFont:JIACU_FONT(12)];
    self.titleLabel.textColor = HexStringColor(@"#535353");
    
    self.hotImage = [UIImageView new];
    [self.contentView addSubview:self.hotImage];
    self.hotImage.image = [UIImage imageNamed:@"Hot"];
    
    self.myNewImage = [UIImageView new];
    [self.contentView addSubview:self.myNewImage];
    self.myNewImage.image = [UIImage imageNamed:@"New"];
    
    self.nameLabel = [UILabel new];
    [self.contentView addSubview:self.nameLabel];
    [self.nameLabel setFont:JIACU_FONT(12)];
    self.nameLabel.textColor = HexStringColor(@"#a0a0a0");
    
    self.moreImage = [UIImageView new];
    [self.contentView addSubview:self.moreImage];
    self.moreImage.image = [UIImage imageNamed:@"更多icon"];
    
//    self.moreButton = [UIButton new];
//    [self.contentView addSubview:self.moreButton];
//    self.moreButton.backgroundColor = [UIColor clearColor];
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
