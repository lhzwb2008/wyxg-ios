//
//  MsgTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/5/24.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "MsgTableViewCell.h"
#import "AXGHeader.h"
#import "UIImageView+WebCache.h"
#import "NSString+Emojize.h"

#define LEFT_DISTANCE 30 * WIDTH_NIT

@implementation MsgTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.headImage.frame = CGRectMake(10 * WIDTH_NIT, 16 * HEIGHT_NIT, 35, 35);
    self.headImage.layer.cornerRadius = self.headImage.width / 2;
    self.headImage.layer.masksToBounds = YES;
    
    self.nameLabel.frame = CGRectMake(self.headImage.right + 10 * WIDTH_NIT, self.headImage.top, 200 * WIDTH_NIT, self.headImage.height / 2);
    
#if OLD_MSG
    NSDictionary *attributes = @{NSFontAttributeName:[UIFont systemFontOfSize:14],};
    CGSize textSize = [self.nameLabel.text boundingRectWithSize:CGSizeMake(1000, 1000) options:NSStringDrawingTruncatesLastVisibleLine attributes:attributes context:nil].size;
    
    self.contentNameLabel.frame = CGRectMake(self.headImage.right + 18 * WIDTH_NIT, self.headImage.centerY, textSize.width > (self.width / 2 - LEFT_DISTANCE) ? (self.width / 2 - LEFT_DISTANCE) : textSize.width, self.headImage.height / 2);
    
    self.contentLabel.frame = CGRectMake(self.contentNameLabel.right + 5 * WIDTH_NIT, self.headImage.centerY, 100, self.headImage.height / 2);
#endif
   
#if NEW_MSG
    self.contentLabel.frame = CGRectMake(self.headImage.right + 10 * WIDTH_NIT, self.headImage.centerY, self.width - (self.headImage.right + 10 * WIDTH_NIT) - 10 * WIDTH_NIT, self.headImage.height / 2);
#endif
    
    self.timeLabel.frame = CGRectMake(self.width - 100 * WIDTH_NIT - 18 * WIDTH_NIT, self.nameLabel.top, 100 * WIDTH_NIT, self.headImage.height / 2);
    
    self.lineView.frame = CGRectMake(self.nameLabel.left, self.contentView.bottom - 0.5, self.width - self.nameLabel.left, 0.5);
    
}

- (void)createCell {
    self.headImage = [UIImageView new];
    self.headImage.image = [UIImage imageNamed:@"defaultHeadImage"];
    [self.contentView addSubview:self.headImage];
    
    self.nameLabel = [UILabel new];
//    self.nameLabel.text = @"火车站台";
    self.nameLabel.textColor = HexStringColor(@"#a0a0a0");
    self.nameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.nameLabel];
    
    self.contentNameLabel = [UILabel new];
    self.contentNameLabel.textColor = HexStringColor(@"#535353");
    self.contentNameLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.contentNameLabel];
    
    self.contentLabel = [UILabel new];
//    self.contentLabel.text = @"火车站台关注了你";
    self.contentLabel.textColor = HexStringColor(@"#535353");
    self.contentLabel.font = [UIFont systemFontOfSize:12];
    [self.contentView addSubview:self.contentLabel];
    
//    self.contentLabel.backgroundColor = [UIColor redColor];
    
    self.timeLabel = [UILabel new];
//    self.timeLabel.text = @"两天前";
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    self.timeLabel.textColor = [UIColor colorWithRed:163 / 255.0 green:163 / 255.0 blue:163 / 255.0 alpha:1];;
    self.timeLabel.font = [UIFont systemFontOfSize:10];
    [self.contentView addSubview:self.timeLabel];
    
    self.lineView = [UIView new];
    [self.contentView addSubview:self.lineView];
    self.lineView.backgroundColor = HexStringColor(@"#879999");
    
}

- (void)setMsgModel:(MsgModel *)msgModel {
//    if (!_msgModel) {
        _msgModel = msgModel;
//    }
    
    NSLog(@"%@%@", msgModel.create_time, msgModel.type);
    
    self.timeLabel.text = [self intervalSinceNow:msgModel.create_time];
    
    WEAK_SELF;
    
    if ([msgModel.type isEqualToString:@"4"]) {
        // 系统消息
        self.nameLabel.text = @"我要写歌";
        self.headImage.image = [UIImage imageNamed:@"defaultHeadImage"];
        self.contentLabel.text = [msgModel.content emojizedString];
        
    }
#if NEW_MSG
    else {
        // 获取用户信息
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, msgModel.send_id] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            
            NSLog(@"%@", resposeObject[@"status"]);
            
            STRONG_SELF;
            
            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                self.nameLabel.text = [resposeObject[@"name"] emojizedString];
                self.contentNameLabel.text = self.nameLabel.text;
                NSString *phone = resposeObject[@"phone"];
                [self.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:phone]]] placeholderImage:[UIImage imageNamed:@"defaultHeadImage"]];
                
                
                if ([msgModel.type isEqualToString:@"0"]) {
                    
                    // 赞
                    
                    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_SONG_BY_ID, msgModel.song_id] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                        
                        NSDictionary *dic = resposeObject;
                        
                        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"赞了你的歌曲《%@》", dic[@"title"]]];
                        
                        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1a1a1a"] range:NSMakeRange(0, 6)];
                        
                        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(6, attributeString.length - 6)];
                        
                        self.contentLabel.attributedText = attributeString;

                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        
                    }];

                } else if ([msgModel.type isEqualToString:@"1"]) {
                    
                    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_SONG_BY_ID, msgModel.song_id] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                        
                        NSDictionary *dic = resposeObject;
                        
                        NSString *title = dic[@"title"];
                        
                        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"评论了《%@》%@", title, [msgModel.content emojizedString]]];
                        
                        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1a1a1a"] range:NSMakeRange(0, 3)];
                        
                        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(3, title.length + 2)];
                        
                        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1a1a1a"] range:NSMakeRange(3 + title.length + 2, attributeString.length - 3 - title.length - 2)];
                        
                        self.contentLabel.attributedText = attributeString;
                        
                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
                        
                    }];
                    
                } else if ([msgModel.type isEqualToString:@"2"]) {
                    
                    // 关注
                    NSString *name = [resposeObject[@"name"] emojizedString];
                    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ 关注了你", name]];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#51c4de"] range:NSMakeRange(0, name.length)];
                    [attributedString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1a1a1a"] range:NSMakeRange(name.length, attributedString.length - name.length)];
                    
                    self.contentLabel.attributedText = attributedString;
                    
                } else if ([msgModel.type isEqualToString:@"3"]) {
                    // 回复评论
                    NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"回复了你的评论%@", [msgModel.content emojizedString]]];
                    self.contentLabel.attributedText = attributeString;
                } else if ([msgModel.type isEqualToString:@"5"]) {
                    // 礼物
                    
                    self.contentLabel.text = @"送了你一个礼物";
                    self.contentLabel.textColor = HexStringColor(@"#1a1a1a");
                    
//                    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_SONG_BY_ID, msgModel.song_id] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//                        
//                        NSDictionary *dic = resposeObject;
//                        
//                        NSString *title = dic[@"title"];
//                        
//                        NSMutableAttributedString *attributeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"评论了《%@》%@", title, [msgModel.content emojizedString]]];
//                        
//                        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1a1a1a"] range:NSMakeRange(0, 3)];
//                        
//                        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#999999"] range:NSMakeRange(3, title.length + 2)];
//                        
//                        [attributeString addAttribute:NSForegroundColorAttributeName value:[UIColor colorWithHexString:@"#1a1a1a"] range:NSMakeRange(3 + title.length + 2, attributeString.length - 3 - title.length - 2)];
//                        
//                        self.contentLabel.attributedText = attributeString;
//                        
//                    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//                        
//                    }];
                }
                
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }
    
#endif
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSString *)intervalSinceNow: (NSString *) theDate {
    
    
    NSDateFormatter *date=[[NSDateFormatter alloc] init];
    
    [date setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"]];
    
    [date setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDate *d=[date dateFromString:theDate];
    
    NSTimeInterval late=[d timeIntervalSince1970]*1.0;
    
    NSDate* dat = [NSDate date];
    
    NSTimeInterval now=[dat timeIntervalSince1970]*1.0;
    
    NSString *timeString=@"";
    
    
    NSTimeInterval cha=now-late;
    
    if (cha/3600<1) {
        
        if (cha < 0) {
            timeString=@"刚刚";
        } else {
            timeString = [NSString stringWithFormat:@"%f", cha/60];
            
            timeString = [timeString substringToIndex:timeString.length-7];
            
            timeString=[NSString stringWithFormat:@"%@分钟前", timeString];
        }
    }
    if (cha/3600>1&&cha/86400<1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/3600];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        timeString=[NSString stringWithFormat:@"%@小时前", timeString];
        
    }
    if (cha/86400>1) {
        
        timeString = [NSString stringWithFormat:@"%f", cha/86400];
        
        timeString = [timeString substringToIndex:timeString.length-7];
        
        timeString=[NSString stringWithFormat:@"%@天前", timeString];
    }
    
    return timeString;
}

@end
