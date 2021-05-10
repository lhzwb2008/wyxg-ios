//
//  PlayUserSongCommentCell.m
//  CreateSongs
//
//  Created by axg on 16/5/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PlayUserSongCommentCell.h"
#import "UIImageView+WebCache.h"
#import "XWAFNetworkTool.h"
#import "AXGHeader.h"
#import "UserModel.h"
#import "UIColor+expanded.h"
#import "NSString+Emojize.h"
#import "TYCache.h"
/**
 @property (nonatomic, assign) CGRect userHeadFrame;
 @property (nonatomic, assign) CGRect userNameFrame;
 @property (nonatomic, assign) CGRect userContentFrame;
 @property (nonatomic, assign) CGRect timeLabelFrame;
 
 @property (nonatomic, assign) CGRect lyricViewFrame;
 
 
 @property (nonatomic, assign) CGRect focusBtnFrame;
 @property (nonatomic, assign) CGRect loveBtnFrame;
 @property (nonatomic, assign) CGRect shareBtnFrame;
 @property (nonatomic, assign) CGRect moreBtnFrame;
 */
static NSString *const indentifier = @"mainTableViewCellIdentifier";

@interface PlayUserSongCommentCell ()

@property (nonatomic, strong) UIImageView *userHeadImageView;
@property (nonatomic, strong) UILabel *userNameLabel;
@property (nonatomic, strong) UILabel *userConnetLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *userNameLabel2;

@end

@implementation PlayUserSongCommentCell

- (instancetype)initWithTableView:(UITableView *)tableView {
    PlayUserSongCommentCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[PlayUserSongCommentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}
+ (instancetype)customCommentCell:(UITableView *)tableView {
    return [[self alloc] initWithTableView:tableView];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initSubViews];
    }
    return self;
}

- (void)initSubViews {
    
    self.thumbView = [UIImageView new];
    self.thumbView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    self.userHeadImageView = [UIImageView new];
    
    UITapGestureRecognizer *tag = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(userHeadTap:)];
    [self.userHeadImageView addGestureRecognizer:tag];
    
    self.userNameLabel = [UILabel new];
    self.userConnetLabel = [UILabel new];
    self.timeLabel = [UILabel new];
    self.userNameLabel2 = [UILabel new];
    self.upBtn = [PlayUserUpBtn buttonWithType:UIButtonTypeCustom];
    self.upBtn.backgroundColor = [UIColor clearColor];
    self.upBtn.titleLabel.font = NORML_FONT(10*WIDTH_NIT);
    self.upBtn.titleLabel.textAlignment = NSTextAlignmentRight;
    [self.upBtn setImage:[UIImage imageNamed:@"playUser点赞"] forState:UIControlStateNormal];
    
    [self.upBtn setTitleColor:[UIColor colorWithHexString:@"a3a3a3"] forState:UIControlStateNormal];
    [self.upBtn addTarget:self action:@selector(upBtnClick:) forControlEvents:UIControlEventTouchUpInside];
//    self.upBtn.enabled = NO;
    
    self.userNameLabel.textColor = THEME_COLOR;
    self.userNameLabel2.textColor = THEME_COLOR;
    self.userConnetLabel.textColor = [UIColor colorWithHexString:@"#666666"];
    self.timeLabel.textColor = [UIColor colorWithHexString:@"#a3a3a3"];
    
    self.userNameLabel.font = NORML_FONT(12*WIDTH_NIT);
    self.userNameLabel2.font = NORML_FONT(12*WIDTH_NIT);
    self.userConnetLabel.font = JIACU_FONT(12*WIDTH_NIT);
    self.userConnetLabel.numberOfLines = 0;
    self.timeLabel.font = NORML_FONT(10*WIDTH_NIT);
    self.timeLabel.textAlignment = NSTextAlignmentRight;
    
    self.commentClickButton = [UIButton new];
    self.commentClickButton.backgroundColor = [UIColor clearColor];
    [self.commentClickButton addTarget:self action:@selector(commentClickButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    self.isUped = NO;
    
    [self.contentView addSubview:self.thumbView];
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.userHeadImageView];
    [self.contentView addSubview:self.userNameLabel];
    [self.contentView addSubview:self.userNameLabel2];
    [self.contentView addSubview:self.userConnetLabel];
    [self.contentView addSubview:self.timeLabel];
    [self.contentView addSubview:self.commentClickButton];
    [self.contentView addSubview:self.upBtn];
}

- (void)userHeadTap:(UITapGestureRecognizer *)tap {
    
    self.headClickBlock(self.user_id);
}

- (void)commentClickButtonAction:(UIButton *)sender {
    if (self.commentClickBlock) {
        self.commentClickBlock(self.originName, self.user_id, _userFrameModel.commentModel.id);
    }
    
}

- (void)setUserFrameModel:(CommentUserFrameModel *)userFrameModel {
    _userFrameModel = userFrameModel;
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:MD5Hash(_userFrameModel.commentModel.id)]) {
        self.isUped = YES;
        [self.upBtn setImage:[UIImage imageNamed:@"playUser已点赞"] forState:UIControlStateNormal];
    } else {
        self.isUped = NO;
        [self.upBtn setImage:[UIImage imageNamed:@"playUser点赞"] forState:UIControlStateNormal];
    }
    //http://1.117.109.129/core/home/data/upComment?Comments=21548
    // id 21548
    
    NSInteger upC = [_userFrameModel.commentModel.up_count integerValue];
    if (self.upCount > 0) {
        [self.upBtn setTitle:[NSString stringWithFormat:@"%ld", self.upCount] forState:UIControlStateNormal];
    } else {
        self.upCount = upC;
        [self.upBtn setTitle:[NSString stringWithFormat:@"%ld", upC] forState:UIControlStateNormal];
    }
    self.bgView.frame = _userFrameModel.bgFrame;
    self.userHeadImageView.frame = _userFrameModel.userHeadFrame;
    self.userNameLabel.frame = _userFrameModel.userNameFrame;
    self.userConnetLabel.frame = _userFrameModel.userContentFrame;
    self.timeLabel.frame = _userFrameModel.timeLabelFrame;
    self.upBtn.frame = _userFrameModel.upBtnFrame;
    [self.upBtn setNeedsLayout];
    
    self.commentClickButton.frame = CGRectMake(self.userNameLabel.left, self.userNameLabel.top, self.timeLabel.right - self.userNameLabel.left, self.userConnetLabel.bottom - self.userNameLabel.top);
    
    self.userHeadImageView.clipsToBounds = YES;
    self.userHeadImageView.layer.cornerRadius = _userFrameModel.userHeadFrame.size.width / 2;
    self.userHeadImageView.layer.borderWidth = 1.5;
    self.userHeadImageView.layer.borderColor = [UIColor colorWithHexString:@"#ffffff"].CGColor;
    self.userHeadImageView.userInteractionEnabled = YES;
    self.userHeadImageView.image = [UIImage imageNamed:@"playUser头像"];
    /**
     *  获取用户头像名字时间信息
     */
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL,_userFrameModel.commentModel.user_id] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        UserModel *userModel = [[UserModel alloc] initWithDictionary:resposeObject error:nil];
        
        self.user_id = userModel.userModelId;
        
        if (![userModel.status isEqualToString:@"-1"]) {
            NSString *userHead = [NSString stringWithFormat:GET_USER_HEAD, [NSString stringWithFormat:@"%@", [XWAFNetworkTool md5HexDigest:userModel.phone]]];
            
            [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:userHead] placeholderImage:[UIImage imageNamed:@"playUser头像"]];
            
            self.userNameLabel.text = userModel.name;
            
            self.originName = userModel.name;
            
            if ([userModel.gender isEqualToString:@"1"]) {
                // man
                self.thumbView.image = [UIImage imageNamed:@"男icon"];
            } else {
                self.thumbView.image = [UIImage imageNamed:@"女icon"];
            }
//             如果评论有回复人，加上回复人
            if (_userFrameModel.commentModel.parent.length != 0) {
                self.userNameLabel.text = userModel.name;
                self.userNameLabel2.text = [[NSString stringWithFormat:@"回复:%@", _userFrameModel.commentModel.parent] emojizedString];
                
                CGSize nameSize = [self.userNameLabel.text getWidth:self.userNameLabel.text andFont:self.userNameLabel.font];
                if (nameSize.width > self.userNameLabel.width) nameSize.width = self.userNameLabel.width;
                self.thumbView.frame = CGRectMake(self.userNameLabel.left + nameSize.width + 7*WIDTH_NIT, 0, 12*WIDTH_NIT, 12*WIDTH_NIT);
                self.thumbView.centerY = self.userNameLabel.centerY;
                
                CGFloat nameLabelW = self.timeLabel.left - self.thumbView.right - 10*WIDTH_NIT;
                self.userNameLabel2.frame = CGRectMake(self.thumbView.right + 10*WIDTH_NIT, 0, nameLabelW, self.userNameLabel.height);
                self.userNameLabel2.centerY = self.thumbView.centerY;
            } else {
                self.userNameLabel.text = userModel.name;
                
                CGSize nameSize = [self.userNameLabel.text getWidth:self.userNameLabel.text andFont:self.userNameLabel.font];
                if (nameSize.width > self.userNameLabel.width) nameSize.width = self.userNameLabel.width;
                self.thumbView.frame = CGRectMake(self.userNameLabel.left + nameSize.width + 7*WIDTH_NIT, 0, 12*WIDTH_NIT, 12*WIDTH_NIT);
//                self.thumbView.clipsToBounds = YES;
//                self.thumbView.layer.cornerRadius = self.thumbView.height / 2;
                self.thumbView.centerY = self.userNameLabel.centerY;
                
                self.userNameLabel2.frame = CGRectZero;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%@", error.description);
    }];
    NSString* timeStr = _userFrameModel.commentModel.create_time;
    
    self.timeLabel.text = [self intervalSinceNow:timeStr];
    
    // 收到服务器的emoji数据进行处理
    
//    NSLog(@"emoji化得评论%@", [_userFrameModel.commentModel.content emojizedString]);
    
//    self.userConnetLabel.text = [_userFrameModel.commentModel.content emojizedString];
    self.userConnetLabel.text = _userFrameModel.commentModel.content;
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

- (void)upBtnClick:(PlayUserUpBtn *)sender {
    sender.enabled = NO;
    NSString *title = self.upBtn.titleLabel.text;;
    NSString *upTitle = nil;
    if (self.isUped) {
        if (self.upCount > 0) {
            self.upCount --;
        }
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:MD5Hash(_userFrameModel.commentModel.id)];
        [self.upBtn setImage:[UIImage imageNamed:@"playUser点赞"] forState:UIControlStateNormal];
        if ([title integerValue] >= 1) {
           upTitle = [NSString stringWithFormat:@"%ld", [title integerValue]-1];
        } else {
            upTitle = [NSString stringWithFormat:@"%d", 0];
        }
        self.isUped  = NO;
        sender.enabled = YES;
    } else {
        self.upCount++;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:MD5Hash(_userFrameModel.commentModel.id)];
        [self.upBtn setImage:[UIImage imageNamed:@"playUser已点赞"] forState:UIControlStateNormal];
        upTitle = [NSString stringWithFormat:@"%ld", [title integerValue]+1];
        self.isUped = YES;
        
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:UP_COMMENTS, self.userFrameModel.commentModel.id] body:nil response:XWData requestHeadFile:nil progress:^(NSProgress * _Nonnull downloadProgress) {
            
        } success:^(NSURLSessionDataTask *task, id resposeObjects) {
            sender.enabled = YES;
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"点赞发生错误%@", error.description);
            sender.enabled = YES;
        }];
    }
    [self.upBtn setTitle:upTitle forState:UIControlStateNormal];
    // 2s后按钮恢复点击

  
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
