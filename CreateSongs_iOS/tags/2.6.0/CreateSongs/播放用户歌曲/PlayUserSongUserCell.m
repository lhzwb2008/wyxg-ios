//
//  PlayUserSongUserCell.m
//  CreateSongs
//
//  Created by axg on 16/5/3.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "PlayUserSongUserCell.h"
#import "AXGHeader.h"
#import "UIImageView+WebCache.h"
#import "KeychainItemWrapper.h"
//#import "MessageIdentifyViewController.h"
#import <Security/Security.h>
#import "AppDelegate.h"
#import "LoginViewController.h"

static NSString *const indentifier = @"playUserSongUserIndentifier";

@implementation PlayUserSongUserCell

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

+ (instancetype)customCommentCell:(UITableView *)tableView {
    PlayUserSongUserCell *cell = [tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[PlayUserSongUserCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indentifier];
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [UIColor colorWithHexString:@"#eeeeee"];
        [self initSubViews];
    }
    return self;
}
- (void)initSubViews {
    
//    self.dataSource = [[NSMutableDictionary alloc] initWithCapacity:0];
    
    self.genderImageView = [UIImageView new];
    self.genderImageView.backgroundColor = [UIColor clearColor];
    
    self.userHeadImageView = [UIImageView new];
    self.userNameLabel = [UILabel new];
    self.createTimeLabel = [UILabel new];
    
    self.focusBtn = [FocusButton buttonWithType:UIButtonTypeCustom];
    self.loveBtn = [LoveAndShareBtn buttonWithType:UIButtonTypeCustom];
    self.shareBtn = [LoveAndShareBtn buttonWithType:UIButtonTypeCustom];
    self.moreBtn = [LoveAndShareBtn buttonWithType:UIButtonTypeCustom];
    self.fanchangBtn = [LoveAndShareBtn buttonWithType:UIButtonTypeCustom];
    
    self.bgView = [UIView new];
    self.bgView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:self.bgView];
    

//    [self.contentView addSubview:self.genderImageView];
//    [self.contentView addSubview:self.userHeadImageView];
//    [self.contentView addSubview:self.userNameLabel];
//    [self.contentView addSubview:self.createTimeLabel];
    
    
//    [self.bgView addSubview:self.focusBtn];
    [self.bgView addSubview:self.loveBtn];
    [self.bgView addSubview:self.shareBtn];
    [self.bgView addSubview:self.moreBtn];
    [self.bgView addSubview:self.fanchangBtn];
    
    self.isFocus = NO;
    self.isLove = NO;
    self.hasSetCheat = NO;
    
    
    self.userHeadImageView.userInteractionEnabled = YES;
    self.userHeadImageView.backgroundColor = [UIColor whiteColor];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickHeadImage)];
    [self.userHeadImageView addGestureRecognizer:tap];
    
    
    
    self.userNameLabel.textColor = [UIColor colorWithHexString:@"#535353"];
    self.userNameLabel.font = TECU_FONT(12*WIDTH_NIT);
    
    self.createTimeLabel.font = NORML_FONT(12*WIDTH_NIT);
    self.createTimeLabel.textColor = [UIColor colorWithHexString:@"#879999"];
    
    
    self.focusBtn.backgroundColor = [UIColor clearColor];
    [self.focusBtn setImage:[UIImage imageNamed:@"加关注"] forState:UIControlStateNormal];
    [self.focusBtn setTitle:@"加关注" forState:UIControlStateNormal];
    [self.focusBtn setTitleColor:[UIColor colorWithHexString:@"#879999"] forState:UIControlStateNormal];
    self.focusBtn.titleLabel.font = NORML_FONT(10*WIDTH_NIT);
    [self.focusBtn addTarget:self action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
//    self.focusBtn.hidden = YES;
//    self.focusLabel.hidden = YES;
    
    if (self.isLove) {
        [self.loveBtn setImage:[UIImage imageNamed:@"playUser喜欢"] forState:UIControlStateNormal];
    } else {
        [self.loveBtn setImage:[UIImage imageNamed:@"playUser不喜欢"] forState:UIControlStateNormal];
    }
    [self.loveBtn setTitle:@"123" forState:UIControlStateNormal];
    [self.loveBtn addTarget:self action:@selector(loveButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.loveBtn setTitleColor:[UIColor colorWithHexString:@"#879999"] forState:UIControlStateNormal];
    self.loveBtn.titleLabel.font = NORML_FONT(10*WIDTH_NIT);
    
    [self.shareBtn setImage:[UIImage imageNamed:@"playUser分享"] forState:UIControlStateNormal];
    [self.shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [self.shareBtn addTarget:self action:@selector(shareButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.shareBtn setTitleColor:[UIColor colorWithHexString:@"#879999"] forState:UIControlStateNormal];
    self.shareBtn.titleLabel.font = NORML_FONT(10*WIDTH_NIT);
    
    
    [self.fanchangBtn setImage:[UIImage imageNamed:@"playUser麦克风"] forState:UIControlStateNormal];
    [self.fanchangBtn setTitle:@"演唱" forState:UIControlStateNormal];
    [self.fanchangBtn addTarget:self action:@selector(fanchangAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.fanchangBtn setTitleColor:[UIColor colorWithHexString:@"#879999"] forState:UIControlStateNormal];
    self.fanchangBtn.titleLabel.font = NORML_FONT(10*WIDTH_NIT);
    
    [self.moreBtn setImage:[UIImage imageNamed:@"playUser更多"] forState:UIControlStateNormal];
    [self.moreBtn setTitle:@"更多" forState:UIControlStateNormal];
    [self.moreBtn addTarget:self action:@selector(moreButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    [self.moreBtn setTitleColor:[UIColor colorWithHexString:@"#879999"] forState:UIControlStateNormal];
    self.moreBtn.titleLabel.font = NORML_FONT(10*WIDTH_NIT);
    
}

- (void)fanchangAction:(LoveAndShareBtn *)btn {
    if (self.fanChangeBlock) {
        self.fanChangeBlock();
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
//    self.bgView.frame = CGRectMake(16*WIDTH_NIT, (15)*WIDTH_NIT, self.contentView.width-32*WIDTH_NIT, self.contentView.height-(15)*WIDTH_NIT);
    
    
    self.bgView.frame = CGRectMake(0, 15 * WIDTH_NIT, self.contentView.width, self.contentView.height - 15 * WIDTH_NIT);
    
//    self.userHeadImageView.frame = CGRectMake(self.bgView.left + 21*WIDTH_NIT, 30*WIDTH_NIT, 45*WIDTH_NIT, 45*WIDTH_NIT);
//    self.userHeadImageView.clipsToBounds = YES;
//    self.userHeadImageView.layer.cornerRadius = self.userHeadImageView.height/2;
//    self.userHeadImageView.layer.borderColor = [UIColor colorWithHexString:@"#879999"].CGColor;
//    self.userHeadImageView.layer.borderWidth = 1.5;
    
//    CGSize userNameSize = [@"我" getWidth:@"我" andFont:self.userNameLabel.font];
    
//    self.userNameLabel.frame = CGRectMake(self.userHeadImageView.right+15*WIDTH_NIT, self.userHeadImageView.top, 100, userNameSize.height);
    
//    CGSize createTimeSize = [@"2011.00.00" getWidth:@"2011.00.00" andFont:self.createTimeLabel.font];
//    self.createTimeLabel.frame = CGRectMake(self.bgView.right-createTimeSize.width, self.userHeadImageView.top, createTimeSize.width, createTimeSize.height);
    
    CGFloat gap = (self.bgView.width - 80*WIDTH_NIT - 30*WIDTH_NIT * 4) / 3;
    
    self.loveBtn.frame = CGRectMake((40)*WIDTH_NIT, 13*WIDTH_NIT, 30*WIDTH_NIT, 55*WIDTH_NIT);
    self.shareBtn.frame = CGRectMake(self.loveBtn.right + gap, self.loveBtn.top, self.loveBtn.width, self.loveBtn.height);
    self.fanchangBtn.frame = CGRectMake(self.shareBtn.right + gap, self.loveBtn.top, self.loveBtn.width, self.loveBtn.height);
    self.moreBtn.frame = CGRectMake(self.fanchangBtn.right + gap, self.shareBtn.top, self.loveBtn.width, self.loveBtn.height);
//    self.focusBtn.frame = CGRectMake(self.bgView.width-(14+25)*WIDTH_NIT, 0, 25*WIDTH_NIT, 25*WIDTH_NIT);
}

- (void)setUserInfoDic:(NSMutableDictionary *)userInfoDic {
    
    _userInfoDic = userInfoDic;
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    
    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    NSLog(@"  userid   %@", userId);
    NSLog(@"  song user id  %@", self.userId);
    
    __weak typeof(self)weakSelf = self;
    
//    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_FOCUS, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
//        NSLog(@"%@", resposeObject);
//        
//        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
//            NSArray *array = resposeObject[@"items"];
//            
//            weakSelf.isFocus = NO;
//            
//            for (NSDictionary *dic in array) {
//                if ([dic[@"focus_id"] isEqualToString:weakSelf.userId]) {
//                    weakSelf.isFocus = YES;
//                    
//                    if (!weakSelf.isFocus) {
//                        
//                        [weakSelf.focusBtn setTitle:@"加关注" forState:UIControlStateNormal];
//                        [weakSelf.focusBtn setImage:[UIImage imageNamed:@"加关注"] forState:UIControlStateNormal];
//                        
//                    } else {
//                        
//                        [weakSelf.focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
//                        [weakSelf.focusBtn setImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
//                    }
//                    
//                }
//            }
//        }
//    } failure:^(NSURLSessionDataTask *task, NSError *error) {
//        
//    }];
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_LIKE, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSArray *array = resposeObject[@"items"];
            weakSelf.isLove = NO;
            for (NSDictionary *dic in array) {
                if ([dic[@"song_id"] isEqualToString:weakSelf.songId]) {
                    weakSelf.isLove = YES;
                    
                    if (weakSelf.isLove) {
                        [weakSelf.loveBtn setImage:[UIImage imageNamed:@"playUser喜欢"] forState:UIControlStateNormal];
                    } else {
                        [weakSelf.loveBtn setImage:[UIImage imageNamed:@"playUser不喜欢"] forState:UIControlStateNormal];
                    }
                    
                }
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    // 获取点赞数
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_SONG_BY_ID, self.songId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        
        NSString *loveCount = resposeObject[@"up_count"];
        if (loveCount.length != 0) {
            [self.loveBtn setTitle:loveCount forState:UIControlStateNormal];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];

//    if (self.userInfoDic.allKeys.count != 0) {
//        
//        NSLog(@"%@", [NSURL URLWithString:[NSString stringWithFormat:GET_USER_HEAD, [NSString stringWithFormat:@"%@", [XWAFNetworkTool md5HexDigest:self.userInfoDic[@"phone"]]]]]);
//        
//        
//        [self.userHeadImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_USER_HEAD, [NSString stringWithFormat:@"%@", [XWAFNetworkTool md5HexDigest:self.userInfoDic[@"phone"]]]]] placeholderImage:[UIImage imageNamed:@"playUser头像"]];
//    
//        self.userNameLabel.text =
////        self.userId
//        self.userInfoDic[@"name"]
//        ;
//        
//        CGSize nameSize = [self.userNameLabel.text getWidth:self.userNameLabel.text andFont:self.userNameLabel.font];
//        
//        if (nameSize.width > 100) nameSize.width = 100;
//        
//        self.genderImageView.frame = CGRectMake(self.userNameLabel.left + nameSize.width + 7*WIDTH_NIT, 0, 12*WIDTH_NIT, 12*WIDTH_NIT);
//        self.genderImageView.centerY = self.userNameLabel.centerY;
//        
//        if ([self.gender isEqualToString:@"1"]) {
//            self.genderImageView.image = [UIImage imageNamed:@"男icon"];
//        } else {
//            self.genderImageView.image = [UIImage imageNamed:@"女icon"];
//        }
//        
//        NSString *createTime = self.userInfoDic[@"createTime"];
//        
//        NSArray *timeArray = [createTime componentsSeparatedByString:@"/"];
//        
//        self.createTimeLabel.text = [NSString stringWithFormat:@"%@.%@.%@", timeArray[0], timeArray[1], timeArray[2]];
//    }
}


// 点赞按钮方法
- (void)loveButtonAction:(UIButton *)sender {
    
    sender.enabled = NO;
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        // 已登录状态
        
//        self.setLikeBlock();
        
        KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
        NSString *userId = [wrapper objectForKey:(id)kSecValueData];
        
        if (!self.isLove) {
            
            [self.loveBtn setImage:[UIImage imageNamed:@"playUser喜欢"] forState:UIControlStateNormal];
            CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            k.values = @[@(0.1),@(1.0),@(1.5)];
            k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
            k.calculationMode = kCAAnimationLinear;
            
            [self.loveBtn.layer addAnimation:k forKey:@"SHOW"];
            
            [self.loveBtn setTitle:[NSString stringWithFormat:@"%ld", self.loveBtn.titleLabel.text.integerValue + 1] forState:UIControlStateNormal];
            self.addOrSubLikeBlock(YES);
            
            __weak typeof(self)weakSelf = self;
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_LIKE, userId, weakSelf.songId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                    NSLog(@"添加收藏成功");
                    weakSelf.isLove = !weakSelf.isLove;
                    sender.enabled = YES;
#if ALLOW_MSG
                    if (![weakSelf.userId isEqualToString:userId]) {
                        /*msg type 0 点赞*/
                        [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, weakSelf.userId, userId, @"0", weakSelf.songId, @"", weakSelf.songName] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                            
                        } failure:^(NSURLSessionDataTask *task, NSError *error) {
                            
                        }];
                    }
                    
#endif
                    
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
            
        } else {
            
            [self.loveBtn setImage:[UIImage imageNamed:@"playUser不喜欢"] forState:UIControlStateNormal];
            CAKeyframeAnimation *k = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
            k.values = @[@(0.1),@(1.0),@(1.5)];
            k.keyTimes = @[@(0.0),@(0.5),@(0.8),@(1.0)];
            k.calculationMode = kCAAnimationLinear;
            
            [self.loveBtn.layer addAnimation:k forKey:@"SHOW"];
            
            
            [self.loveBtn setTitle:[NSString stringWithFormat:@"%ld", self.loveBtn.titleLabel.text.integerValue - 1] forState:UIControlStateNormal];
            self.addOrSubLikeBlock(NO);
            
            __weak typeof(self)weakSelf = self;
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:DEL_LIKE, userId, weakSelf.songId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                    NSLog(@"取消收藏成功");
                    weakSelf.isLove = !weakSelf.isLove;
                    sender.enabled = YES;
                }
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
            
        }
        
    } else {
        // 未登录状态
        
        if (self.pauseBlock) {
            self.pauseBlock();
        }
        sender.enabled = YES;
        NSLog(@"用户没有登录 需要登录");

        AXG_LOGIN(LOGIN_LOCATION_USERSONG_FOCUS);
        
    }
    
}

// 保存喜欢歌曲到本地数据库
- (void)saveToDataBase {
    
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"CreateSongsLove.db"];
    
    NSDate *currentDate = [NSDate date];//获取当前时间，日期
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"YYYY/MM/dd hh:mm:ss SS"];
    NSString *dateString = [dateFormatter stringFromDate:currentDate];
    NSLog(@"dateString:%@",dateString);
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *account = [wrapper objectForKey:(id)kSecAttrAccount];
    
    if (account.length == 0) {
        
        [store createTableWithName:@"woyaoxiegeUnLogin"];
        [store putString:self.code withId:dateString intoTable:@"woyaoxiegeUnLogin"];
        NSLog(@"!!!!!!!!!!!!!%@", [store getAllItemsFromTable:@"woyaoxiegeUnLogin"]);
        
    } else {
        [store createTableWithName:[NSString stringWithFormat:@"woyaoxiege%@", account]];
        [store putString:self.code withId:dateString intoTable:[NSString stringWithFormat:@"woyaoxiege%@", account]];
        NSLog(@"!!!!!!!!!!!!%@", [store getAllItemsFromTable:[NSString stringWithFormat:@"woyaoxiege%@", account]]);
    }
}

// 从本地数据库删除喜欢歌曲
- (void)removeFromDataBase {
    
    YTKKeyValueStore *store = [[YTKKeyValueStore alloc] initDBWithName:@"CreateSongsLove.db"];
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *account = [wrapper objectForKey:(id)kSecAttrAccount];
    
    if (account.length == 0) {
        
        NSArray *array = [store getAllItemsFromTable:@"woyaoxiegeUnLogin"];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
        
        for (YTKKeyValueItem *item in array) {
            NSString *string = [item.itemObject lastObject];
            if ([string isEqualToString:self.code]) {
                [mutableArray addObject:item.itemId];
            }
        }
        
        [store deleteObjectsByIdArray:mutableArray fromTable:@"woyaoxiegeUnLogin"];
        
    } else {
        
        NSArray *array = [store getAllItemsFromTable:[NSString stringWithFormat:@"woyaoxiege%@", account]];
        NSMutableArray *mutableArray = [NSMutableArray arrayWithCapacity:0];
        
        for (YTKKeyValueItem *item in array) {
            NSString *string = [item.itemObject lastObject];
            if ([string isEqualToString:self.code]) {
                [mutableArray addObject:item.itemId];
            }
        }
        
        [store deleteObjectsByIdArray:mutableArray fromTable:[NSString stringWithFormat:@"woyaoxiege%@", account]];
        
    }
}

// 关注按钮方法
- (void)focusButtonAction:(UIButton *)sender {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *userId = [wrapper objectForKey:(id)kSecValueData];
    
    __weak typeof(self)weakSelf = self;
    
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
            // 已登录状态
            
            if (self.isFocus) {
                
                
                [weakSelf.focusBtn setTitle:@"加关注" forState:UIControlStateNormal];
                [weakSelf.focusBtn setImage:[UIImage imageNamed:@"加关注"] forState:UIControlStateNormal];
                
                [XWAFNetworkTool getUrl:[NSString stringWithFormat:DEL_FOCUS, weakSelf.userId, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                    if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                        NSLog(@"取消关注成功");
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
                
            } else {
                [weakSelf.focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
                [weakSelf.focusBtn setImage:[UIImage imageNamed:@"已关注"] forState:UIControlStateNormal];
//                self.focusBtn.backgroundColor = BUTTON_UNABLE_COLOR;
                
                [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_FOCUS, weakSelf.userId, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                    if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                        NSLog(@"添加关注成功");
#if ALLOW_MSG
                        if (![self.userId isEqualToString:userId]) {
                            /*msg type 2 关注*/
                            [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, self.userId, userId, @"2", weakSelf.songId, @"", @""] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                                
                            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                                
                            }];
                        }
                        
#endif
                    }
                } failure:^(NSURLSessionDataTask *task, NSError *error) {
                    
                }];
                
            }
            self.isFocus = !self.isFocus;
            
            //        [[NSNotificationCenter defaultCenter] postNotificationName:@"setFocus" object:nil];
//            if (self.setFocusBlock) {
//                self.setFocusBlock();
//            }
//            
        } else {
            // 未登录状态
            
            if (self.pauseBlock) {
                self.pauseBlock();
            }
            
            NSLog(@"需要登录---001");

            AXG_LOGIN(LOGIN_LOCATION_USERSONG_FOCUS);
            
        }
//    } @catch (NSException *exception) {
//        NSLog(@"%@", exception);
//    } @finally {
//        
//    }
    
}

// 分享按钮方法
- (void)shareButtonAction:(UIButton *)sender {
    
    if (self.pauseBlock) {
        self.pauseBlock();
    }
    
    if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
        // 已登录状态进入分享页面
//        AppDelegate *app = [[UIApplication sharedApplication] delegate];
//        app.shareUserName = self.userNameLabel.text;
//        [[NSNotificationCenter defaultCenter] postNotificationName:@"userSongShare" object:nil];
        
        if (self.shareBlock) {
            self.shareBlock();
        }
        
        
    } else {
        // 未登录状态，先登录再进入分享界面
        
        NSLog(@"需要登录 --002");
        
        AXG_LOGIN(LOGIN_LOCATION_USERSONG_SHARE);
        
    }
}

// 更多按钮方法
- (void)moreButtonAction:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter] postNotificationName:@"popCheatView" object:nil];
}

// 点击头像按钮头像进入用户界面
- (void)clickHeadImage {
    
    self.turnToUserPageBlock(self.userId);
    
}

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
