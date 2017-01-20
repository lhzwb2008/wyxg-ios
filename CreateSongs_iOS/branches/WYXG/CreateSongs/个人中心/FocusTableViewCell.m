//
//  FocusTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/5/5.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "FocusTableViewCell.h"
#import "AXGHeader.h"
#import "XWAFNetworkTool.h"
#import "UIImageView+WebCache.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>
#import "NSString+Emojize.h"
#import "HomePageModel.h"
#import "UILabel+Common.h"
#import "UserModel.h"

@implementation FocusTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self createCell];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    CGFloat bgViewY = (25+22.5)*HEIGHT_NIT;
    
    self.bgView.frame = CGRectMake(16*WIDTH_NIT, bgViewY, self.contentView.width-32*WIDTH_NIT, self.contentView.height-bgViewY);
    self.headImage.frame = CGRectMake(16*WIDTH_NIT + 18.5*WIDTH_NIT, 25*HEIGHT_NIT, 45*HEIGHT_NIT, 45*HEIGHT_NIT);
    self.headImage.clipsToBounds = YES;
    self.headImage.layer.cornerRadius = self.headImage.width/2;
    self.name.frame = CGRectMake(self.headImage.right + 16*WIDTH_NIT, self.headImage.top + 2 * HEIGHT_NIT, self.contentView.width-self.headImage.right - 16*WIDTH_NIT, 15);
    self.focusButton.frame = CGRectMake(self.bgView.width-24*WIDTH_NIT-25*HEIGHT_NIT, 0, 25*HEIGHT_NIT + 24*WIDTH_NIT, self.bgView.height);
    self.showLyricLabel.frame = CGRectMake(self.name.left, self.bgView.top+20*HEIGHT_NIT, self.bgView.width-82*WIDTH_NIT*2, 35*HEIGHT_NIT);
}

- (void)createCell {
    
//    self.backgroundColor = [UIColor whiteColor];
    
    self.topView = [UIView new];
    self.headImage = [UIImageView new];
    self.headImage.image = [UIImage imageNamed:@"头像"];
    self.name = [UILabel new];
    self.focusButton = [FocusButton new];
    self.signature = [UILabel new];
    self.bgView = [UIView new];
    self.thumbView = [UIImageView new];
    self.showLyricLabel = [UILabel new];
    
    self.headImage.layer.borderColor = [UIColor colorWithHexString:@"#879999"].CGColor;
    self.headImage.layer.borderWidth = 1.5;
    self.bgView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    self.bgView.layer.cornerRadius = 5;
    
    
    self.name.textColor = [UIColor colorWithHexString:@"#535353"];
    self.name.font = JIACU_FONT(12);
    
    self.thumbView.backgroundColor = [UIColor colorWithHexString:@"#ffffff"];
    
    self.showLyricLabel.numberOfLines = 2;
    self.showLyricLabel.backgroundColor = [UIColor clearColor];
    self.showLyricLabel.textColor = [UIColor colorWithHexString:@"#a0a0a0"];
    self.showLyricLabel.font = NORML_FONT(12);
    self.showLyricLabel.textAlignment = NSTextAlignmentLeft;
    
    
    [self.contentView addSubview:self.bgView];
    [self.contentView addSubview:self.headImage];
    [self.contentView addSubview:self.name];
    [self.contentView addSubview:self.thumbView];
    [self.bgView addSubview:self.focusButton];
    [self.contentView addSubview:self.showLyricLabel];
    
    self.topView.backgroundColor = [UIColor colorWithRed:204 / 255.0 green:204 / 255.0 blue:204 / 255.0 alpha:1];

    
    
    self.signature.font = [UIFont systemFontOfSize:10];
    self.signature.textColor = [UIColor colorWithHexString:@"#808080"];
    
    self.isFocus = NO;
    
    self.focusButton.backgroundColor = [UIColor clearColor];
    [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
    [self.focusButton setImage:[UIImage imageNamed:@"加关注"] forState:UIControlStateNormal];
    self.focusButton.titleLabel.font = [UIFont systemFontOfSize:10];
    [self.focusButton setTitleColor:[UIColor colorWithHexString:@"#879999"] forState:UIControlStateNormal];
    
    [self.focusButton addTarget:self action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
//    self.name.backgroundColor = [UIColor redColor];
//    self.signature.backgroundColor = [UIColor greenColor];
    
}

- (void)setUserId:(NSString *)userId {
    _userId = userId;
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *myId = [wrapper objectForKey:(id)kSecValueData];
    
    WEAK_SELF;
    
    // 获取昵称及头像
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            UserModel *userModel = [[UserModel alloc] initWithDictionary:resposeObject error:nil];
            
            if (userModel.signature.length > 0) {
                self.showLyricLabel.text = userModel.signature;
            } else {
                self.showLyricLabel.text = @"这个家伙很懒，什么也没留下";
            }
            //GET_USER_ID_URL
            NSString *gender = userModel.gender;

            NSString *phone = userModel.phone;
            
            [weakSelf.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_USER_HEAD, [NSString stringWithFormat:@"%@", [NSString md5HexDigest:phone]]]] placeholderImage:[UIImage imageNamed:@"头像"]];
            weakSelf.name.text = [userModel.name emojizedString];
            CGSize nameSize = [weakSelf.name.text getWidth:weakSelf.name.text andFont:weakSelf.name.font];
            weakSelf.thumbView.frame = CGRectMake(weakSelf.name.left + nameSize.width + 7*WIDTH_NIT, weakSelf.name.top, 12*WIDTH_NIT, 12*WIDTH_NIT);
            weakSelf.thumbView.centerY = weakSelf.name.centerY;
            if ([gender isEqualToString:@"1"]) {
                weakSelf.thumbView.image = [UIImage imageNamed:@"男icon"];
            } else {
                 weakSelf.thumbView.image = [UIImage imageNamed:@"女icon"];
            }
            id signature = userModel.signature;
            if ([signature isKindOfClass:[NSNull class]]) {
                self.signature.text = EMPTY_SIGNATRUE;
            } else if ([signature isKindOfClass:[NSString class]]) {
                NSString *string = signature;
                if (string.length != 0) {
                    self.signature.text = string;
                } else {
                    self.signature.text = EMPTY_SIGNATRUE;
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    // 获取是否关注此人
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_FOCUS, myId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSArray *items = resposeObject[@"items"];
            for (NSDictionary *dic in items) {
                NSString *focusId = dic[@"focus_id"];
                if ([userId isEqualToString:focusId]) {
                    weakSelf.isFocus = YES;
//                    self.focusButton.backgroundColor = BUTTON_UNABLE_COLOR;
                    [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
                    [self.focusButton setImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
                    
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    
    
//    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_SONGS, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//        
//        STRONG_SELF;
//        
//        HomePageModel *homePageModel = [[HomePageModel alloc] initWithDictionary:resposeObject error:nil];
//        
//        NSArray *songs = homePageModel.songs;
//
//        
//        HomePageUserMess *songMess = [songs firstObject];
//        
//        NSString *code = songMess.code;
//        
//        
//        NSString *lyricUrl = [NSString stringWithFormat:HOME_LYRIC, code];
//        
//        if (code.length > 0) {
//            [self getLyricWithUrl:lyricUrl];
//        } else {
//            self.showLyricLabel.text = @"这个家伙很懒，什么也没留下";
//        }
//        
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        NSLog(@"请求失败%@", error.description);
//    }];
}

- (void)getLyricWithUrl:(NSString *)url {
    
    if (url != nil && url.length > 0) {
        
        WEAK_SELF;
        [XWAFNetworkTool getUrl:url body:nil response:XWData requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            //        NSLog(@"%@", resposeObject);
            
            NSString *lyric = [[NSString alloc] initWithData:resposeObject encoding:NSUTF8StringEncoding];
            
            lyric = [lyric stringByReplacingOccurrencesOfString:@"-" withString:@"～"];
            
            NSArray *array1 = [lyric componentsSeparatedByString:@":"];
            
            self.showLyricLabel.text = [array1 lastObject];
            
            [self.showLyricLabel setLineSpace:10];
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            NSLog(@"%@", error);
        }];
    
    }
}

- (void)focusButtonAction:(UIButton *)sender {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *myId = [wrapper objectForKey:(id)kSecValueData];
    
    __weak typeof(self)weakSelf = self;
    
    if (self.isFocus) {
//        self.focusButton.backgroundColor = THEME_COLOR;
        [self.focusButton setTitle:@"关注" forState:UIControlStateNormal];
        [self.focusButton setImage:[UIImage imageNamed:@"加关注"] forState:UIControlStateNormal];
        self.focusButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:DEL_FOCUS, weakSelf.userId, myId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    } else {
//        self.focusButton.backgroundColor = BUTTON_UNABLE_COLOR;
        [self.focusButton setTitle:@"已关注" forState:UIControlStateNormal];
        [self.focusButton setImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
        self.focusButton.titleLabel.font = [UIFont systemFontOfSize:12];
        
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_FOCUS, weakSelf.userId, myId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            
            /*msg type 2 关注*/
            if (![weakSelf.userId isEqualToString:myId]) {
                [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, weakSelf.userId, myId, @"2", @"", @"", @""] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                    
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
            }
            
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
        
    }
    
    self.isFocus = !self.isFocus;
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
