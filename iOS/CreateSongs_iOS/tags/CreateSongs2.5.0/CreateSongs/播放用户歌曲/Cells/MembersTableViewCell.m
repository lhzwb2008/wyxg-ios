//
//  MembersTableViewCell.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/9/6.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "MembersTableViewCell.h"
#import "AXGHeader.h"
#import "XWAFNetworkTool.h"
#import "KeychainItemWrapper.h"
#import <Security/Security.h>

// 总高度 123 * width_nit

@implementation MembersTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initCell];
    }
    return self;
}

- (void)initCell {
    
    self.isFocus1 = NO;
    self.isFocus2 = NO;
    self.isFocus3 = NO;
    
    self.firstImage = [UIImageView new];
    [self addSubview:self.firstImage];
    
    self.secondImage = [UIImageView new];
    [self addSubview:self.secondImage];
    
    self.thirdImage = [UIImageView new];
    [self addSubview:self.thirdImage];
    
    self.firstLabel = [UILabel new];
    self.firstLabel.backgroundColor = HexStringColor(@"#a06262");
    self.firstLabel.font = JIACU_FONT(20);
    self.firstLabel.textColor = HexStringColor(@"#ffffff");
    self.firstLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.firstLabel];
    
    self.secondLabel = [UILabel new];
    self.secondLabel.backgroundColor = HexStringColor(@"#7aa0d9");
    self.secondLabel.font = JIACU_FONT(20);
    self.secondLabel.textColor = HexStringColor(@"#ffffff");
    self.secondLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.secondLabel];
    
    self.thirdLabel = [UILabel new];
    self.thirdLabel.backgroundColor = HexStringColor(@"#95b165");
    self.thirdLabel.font = JIACU_FONT(20);
    self.thirdLabel.textColor = HexStringColor(@"#ffffff");
    self.thirdLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.thirdLabel];
    
    self.firstNameLabel = [UILabel new];
    self.firstNameLabel.textColor = HexStringColor(@"#535353");
    self.firstNameLabel.font = JIACU_FONT(12);
    self.firstNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.firstNameLabel];
//    self.firstNameLabel.backgroundColor = [UIColor redColor];
    
    self.secondNameLabel = [UILabel new];
    self.secondNameLabel.textColor = HexStringColor(@"#a0a0a0");
    self.secondNameLabel.font = JIACU_FONT(12);
    self.secondNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.secondNameLabel];
    
    self.thirdNameLabel = [UILabel new];
    self.thirdNameLabel.textColor = HexStringColor(@"#a0a0a0");
    self.thirdNameLabel.font = JIACU_FONT(12);
    self.thirdNameLabel.textAlignment = NSTextAlignmentCenter;
    [self addSubview:self.thirdNameLabel];
    
//    self.firstPlus = [UIImageView new];
//    [self addSubview:self.firstPlus];
//    
//    self.secondPlus = [UIImageView new];
//    [self addSubview:self.secondPlus];
    
    self.vertiLine1 = [UIView new];
    self.vertiLine1.backgroundColor = HexStringColor(@"#ffdc74");
    [self addSubview:self.vertiLine1];
    
    self.vertiLine2 = [UIView new];
    self.vertiLine2.backgroundColor = HexStringColor(@"#ffdc74");
    [self addSubview:self.vertiLine2];
    
    self.horLine1 = [UIView new];
    self.horLine1.backgroundColor = HexStringColor(@"#ffdc74");
    [self addSubview:self.horLine1];
    
    self.horLine2 = [UIView new];
    self.horLine2.backgroundColor = HexStringColor(@"#ffdc74");
    [self addSubview:self.horLine2];
    
    self.headButton1 = [UIButton new];
    [self addSubview:self.headButton1];
    self.headButton1.tag = 1000;
    [self.headButton1 addTarget:self action:@selector(headButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headButton2 = [UIButton new];
    [self addSubview:self.headButton2];
    self.headButton2.tag = 1001;
    [self.headButton2 addTarget:self action:@selector(headButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.headButton3 = [UIButton new];
    [self addSubview:self.headButton3];
    self.headButton3.tag = 1002;
    [self.headButton3 addTarget:self action:@selector(headButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.firstButton = [UIButton new];
    self.firstButton.layer.cornerRadius = 9* WIDTH_NIT;
    self.firstButton.layer.masksToBounds = YES;
    [self.firstButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    [self.firstButton setBackgroundImage:[UIImage imageNamed:@"未关注背景"] forState:UIControlStateNormal];
    [self.firstButton setTitle:@"已关注" forState:UIControlStateSelected];
    [self.firstButton setBackgroundImage:[UIImage imageNamed:@"已关注背景"] forState:UIControlStateSelected];
    self.firstButton.titleLabel.font = NORML_FONT(12);
    self.firstButton.tag = 100;
    [self addSubview:self.firstButton];
    [self.firstButton addTarget:self action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.secondButton = [UIButton new];
    self.secondButton.layer.cornerRadius = 9* WIDTH_NIT;
    self.secondButton.layer.masksToBounds = YES;
    [self.secondButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    [self.secondButton setBackgroundImage:[UIImage imageNamed:@"未关注背景"] forState:UIControlStateNormal];
    [self.secondButton setTitle:@"已关注" forState:UIControlStateSelected];
    [self.secondButton setBackgroundImage:[UIImage imageNamed:@"已关注背景"] forState:UIControlStateSelected];
    self.secondButton.titleLabel.font = NORML_FONT(12);
    self.secondButton.tag = 101;
    [self addSubview:self.secondButton];
    [self.secondButton addTarget:self action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.thirdButton = [UIButton new];
    self.thirdButton.layer.cornerRadius = 9* WIDTH_NIT;
    self.thirdButton.layer.masksToBounds = YES;
    [self.thirdButton setTitle:@"+ 关注" forState:UIControlStateNormal];
    [self.thirdButton setBackgroundImage:[UIImage imageNamed:@"未关注背景"] forState:UIControlStateNormal];
    [self.thirdButton setTitle:@"已关注" forState:UIControlStateSelected];
    [self.thirdButton setBackgroundImage:[UIImage imageNamed:@"已关注背景"] forState:UIControlStateSelected];
    self.thirdButton.titleLabel.font = NORML_FONT(12);
    self.thirdButton.tag = 102;
    [self addSubview:self.thirdButton];
    [self.thirdButton addTarget:self action:@selector(focusButtonAction:) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    self.firstImage.frame = CGRectMake(40 * WIDTH_NIT, 15 * WIDTH_NIT, 45 * WIDTH_NIT, 45 * WIDTH_NIT);
    self.firstImage.layer.cornerRadius = self.firstImage.width / 2;
    self.firstImage.layer.masksToBounds = YES;
    self.firstImage.layer.borderColor = HexStringColor(@"#eeeeee").CGColor;
    self.firstImage.layer.borderWidth = 1.5;
    
    self.secondImage.frame = CGRectMake(0, self.firstImage.top, self.firstImage.width, self.firstImage.height);
    self.secondImage.center = CGPointMake(self.width / 2, self.firstImage.centerY);
    self.secondImage.layer.cornerRadius = self.secondImage.width / 2;
    self.secondImage.layer.masksToBounds = YES;
    self.secondImage.layer.borderColor = HexStringColor(@"#eeeeee").CGColor;
    self.secondImage.layer.borderWidth = 1.5;
    
    self.thirdImage.frame = CGRectMake(self.width - 40 * WIDTH_NIT - 45 * WIDTH_NIT, 15 * WIDTH_NIT, self.firstImage.width, self.firstImage.height);
    self.thirdImage.layer.cornerRadius = self.thirdImage.width / 2;
    self.thirdImage.layer.masksToBounds = YES;
    self.thirdImage.layer.borderColor = HexStringColor(@"#eeeeee").CGColor;
    self.thirdImage.layer.borderWidth = 1.5;
    
    CGPoint center1 = CGPointMake((self.secondImage.center.x - self.firstImage.center.x) / 2 + self.firstImage.centerX, self.firstImage.centerY);
    self.vertiLine1.frame = CGRectMake(0, 0, 2, 15);
    self.vertiLine1.center = center1;
    self.horLine1.frame = CGRectMake(0, 0, 15, 2);
    self.horLine1.center = center1;
    
    CGPoint center2 = CGPointMake((self.thirdImage.centerX - self.secondImage.centerX) / 2 + self.secondImage.centerX, self.secondImage.centerY);
    self.vertiLine2.frame = CGRectMake(0, 0, 2, 15);
    self.vertiLine2.center = center2;
    self.horLine2.frame = CGRectMake(0, 0, 15, 2);
    self.horLine2.center = center2;
    
    self.firstLabel.frame = CGRectMake(self.firstImage.right - 15 * WIDTH_NIT, self.firstImage.top, 15 * WIDTH_NIT, 15 * WIDTH_NIT);
    self.firstLabel.layer.cornerRadius = self.firstLabel.width / 2;
    self.firstLabel.layer.masksToBounds = YES;
    self.firstLabel.layer.borderColor = HexStringColor(@"#ffffff").CGColor;
    self.firstLabel.layer.borderWidth = 0.5;
    self.firstLabel.font = JIACU_FONT(10);
    
    self.secondLabel.frame = CGRectMake(self.secondImage.right - 15 * WIDTH_NIT, self.secondImage.top, self.firstLabel.width, self.firstLabel.width);
    self.secondLabel.layer.cornerRadius = self.secondLabel.width / 2;
    self.secondLabel.layer.masksToBounds = YES;
    self.secondLabel.layer.borderColor = HexStringColor(@"#ffffff").CGColor;
    self.secondLabel.layer.borderWidth = 0.5;
    self.secondLabel.font = JIACU_FONT(10);
    
    self.thirdLabel.frame = CGRectMake(self.thirdImage.right - 15 * WIDTH_NIT, self.thirdImage.top, self.secondLabel.width, self.secondLabel.height);
    self.thirdLabel.layer.cornerRadius = self.thirdLabel.width / 2;
    self.thirdLabel.layer.masksToBounds = YES;
    self.thirdLabel.layer.borderColor = HexStringColor(@"#ffffff").CGColor;
    self.thirdLabel.layer.borderWidth = 0.5;
    self.thirdLabel.font = JIACU_FONT(10);
    
    self.firstNameLabel.frame = CGRectMake(0, 0, self.width / 3 - 20 * WIDTH_NIT, 30);
    self.firstNameLabel.center = CGPointMake(self.firstImage.centerX, self.firstImage.bottom + 11 * WIDTH_NIT);
    
    self.secondNameLabel.frame = CGRectMake(0, 0, self.firstNameLabel.width, self.firstNameLabel.height);
    self.secondNameLabel.center = CGPointMake(self.secondImage.centerX, self.secondImage.bottom + 11 * WIDTH_NIT);
    
    self.thirdNameLabel.frame = CGRectMake(0, 0, self.secondNameLabel.width, self.secondNameLabel.height);
    self.thirdNameLabel.center = CGPointMake(self.thirdImage.centerX, self.thirdImage.bottom + 11 * WIDTH_NIT);
    
    self.headButton1.frame = self.firstImage.frame;
    self.headButton2.frame = self.secondImage.frame;
    self.headButton3.frame = self.thirdImage.frame;
    
    self.firstButton.frame = CGRectMake(0, 92 * WIDTH_NIT, 50 * WIDTH_NIT, 18 * WIDTH_NIT);
    self.firstButton.center = CGPointMake(self.firstImage.centerX, self.firstButton.centerY);
    
    self.secondButton.frame = CGRectMake(0, 92 * WIDTH_NIT, 50 * WIDTH_NIT, 18 * WIDTH_NIT);
    self.secondButton.center = CGPointMake(self.secondImage.centerX, self.secondButton.centerY);
    
    self.thirdButton.frame = CGRectMake(0, 92 * WIDTH_NIT, 50 * WIDTH_NIT, 18 * WIDTH_NIT);
    self.thirdButton.center = CGPointMake(self.thirdImage.centerX, self.thirdButton.centerY);

}

- (void)setMemberArray:(NSArray *)memberArray {
    _memberArray = memberArray;
    
    // fisrtId 对应 唱  secondId 对应 词  thirdId 对应 曲
    
    NSString *firstId = memberArray[0];
    NSString *secondId = memberArray[1];
    NSString *thirdId = memberArray[2];
    NSString *fourthId = memberArray[3];
    
    if ([firstId isEqualToString:@"0"]) {
        firstId = fourthId;
    } else {
        firstId = memberArray[0];
    }
    
    if ([secondId isEqualToString:@"0"]) {
        secondId = fourthId;
    } else {
        secondId = memberArray[1];
    }
    
    if ([thirdId isEqualToString:@"0"]) {
        thirdId = fourthId;
    } else {
        thirdId = memberArray[2];
    }
    
    if ([firstId hasPrefix:@"-"]) {
        
        // 机械音，则将唱放到最后
        
        self.firstId = secondId;
        self.secondId = thirdId;
        self.thirdId = firstId;
        
        [self customeSetAction:YES];
        
        
    } else {
        
        // 非机械音，唱放最前面
        
        self.firstId = firstId;
        self.secondId = secondId;
        self.thirdId = thirdId;
        
        [self customeSetAction:NO];
        
    }
    
    self.firstButton.selected = self.isFocus1;
    self.secondButton.selected = self.isFocus2;
    self.thirdButton.selected = self.isFocus3;
    
    [self judgeFocusStatus];
    
}

- (void)customeSetAction:(BOOL)robot {
    
    if (robot) {
        self.firstLabel.text = @"词";
        self.secondLabel.text = @"曲";
        self.thirdLabel.text = @"唱";
        
        self.thirdButton.hidden = YES;
        
    } else {
        self.firstLabel.text = @"唱";
        self.secondLabel.text = @"词";
        self.thirdLabel.text = @"曲";
        
        self.thirdButton.hidden = NO;
    }
    
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, _firstId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            
            NSDictionary *dic = resposeObject;
            self.model1 = [[UserModel alloc] initWithDictionary:dic error:nil];
            
            self.firstNameLabel.text = self.model1.name;
            NSString *imgUrl = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:self.model1.phone]];
            [self.firstImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"头像"]];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, _secondId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            
            NSDictionary *dic = resposeObject;
            self.model2 = [[UserModel alloc] initWithDictionary:dic error:nil];
            
            self.secondNameLabel.text = self.model2.name;
            NSString *imgUrl = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:self.model2.phone]];
            [self.secondImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"头像"]];
            
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
    
    if (robot) {
        if ([self.thirdId isEqualToString:@"-1"]) {
            self.thirdImage.image = [UIImage imageNamed:@"唱_暖男"];
            self.thirdNameLabel.text = @"暖男";
        } else if ([self.thirdId isEqualToString:@"-2"]) {
            self.thirdImage.image = [UIImage imageNamed:@"唱_正太"];
            self.thirdNameLabel.text = @"正太";
        } else if ([self.thirdId isEqualToString:@"-3"]) {
            self.thirdImage.image = [UIImage imageNamed:@"唱_娃娃"];
            self.thirdNameLabel.text = @"娃娃";
        } else if ([self.thirdId isEqualToString:@"-5"]) {
            self.thirdImage.image = [UIImage imageNamed:@"唱_御姐"];
            self.thirdNameLabel.text = @"御姐";
        } else {
            self.thirdImage.image = [UIImage imageNamed:@"唱_萝莉"];
            self.thirdNameLabel.text = @"萝莉";
        }
    } else {
        [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, _thirdId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
            STRONG_SELF;
            
            if ([resposeObject[@"status"] isEqualToNumber:@0]) {
                
                NSDictionary *dic = resposeObject;
                self.model3 = [[UserModel alloc] initWithDictionary:dic error:nil];
                
                self.thirdNameLabel.text = self.model3.name;
                NSString *imgUrl = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:self.model3.phone]];
                
                [self.thirdImage sd_setImageWithURL:[NSURL URLWithString:imgUrl] placeholderImage:[UIImage imageNamed:@"头像"]];
                
            }
            
        } failure:^(NSURLSessionDataTask *task, NSError *error) {
            
        }];
    }
    
}

- (void)judgeFocusStatus {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *myId = [wrapper objectForKey:(id)kSecValueData];
    
    // 获取是否关注此人
    
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_FOCUS, myId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSArray *items = resposeObject[@"items"];
            
            int i = 0;
            for (i = 0; i < items.count; i++) {
                NSDictionary *dic = items[i];
                NSString *focusId = dic[@"focus_id"];
                if ([self.firstId isEqualToString:focusId]) {
                    
                    self.isFocus1 = YES;
                    self.firstButton.selected = YES;
                    break;
                    
                }
            }
            if (i == items.count) {
                self.isFocus1 = NO;
                self.firstButton.selected = NO;
            }
            
        } else {
            
            self.isFocus1 = NO;
            self.firstButton.selected = NO;
            
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.isFocus1 = NO;
        self.firstButton.selected = NO;
    }];
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_FOCUS, myId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSArray *items = resposeObject[@"items"];
            
            int i = 0;
            for (i = 0; i < items.count; i++) {
                NSDictionary *dic = items[i];
                NSString *focusId = dic[@"focus_id"];
                if ([self.secondId isEqualToString:focusId]) {
                    
                    self.isFocus2 = YES;
                    self.secondButton.selected = YES;
                    break;
                    
                }
            }
            if (i == items.count) {
                self.isFocus2 = NO;
                self.secondButton.selected = NO;
            }
            
        } else {
            self.isFocus2 = NO;
            self.secondButton.selected = NO;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.isFocus2 = NO;
        self.secondButton.selected = NO;
    }];
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_FOCUS, myId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSArray *items = resposeObject[@"items"];
            
            int i = 0;
            for (i = 0; i < items.count; i++) {
                NSDictionary *dic = items[i];
                NSString *focusId = dic[@"focus_id"];
                if ([self.thirdId isEqualToString:focusId]) {
                    
                    self.isFocus3 = YES;
                    self.thirdButton.selected = YES;
                    break;
                    
                }
            }
            if (i == items.count) {
                self.isFocus3 = NO;
                self.thirdButton.selected = NO;
            }
            
        } else {
            self.isFocus3 = NO;
            self.thirdButton.selected = NO;
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        self.isFocus3 = NO;
        self.thirdButton.selected = NO;
    }];
    
}

- (void)focusButtonAction:(UIButton *)sender {
    
    sender.enabled = NO;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        sender.enabled = YES;
    });
    
    if (sender.selected) {
        
        switch (sender.tag - 100) {
            case 0: {
                [self cancelById:self.firstId];
                self.isFocus1 = NO;
            }
                break;
            case 1: {
                [self cancelById:self.secondId];
                self.isFocus2 = NO;
            }
                break;
            case 2: {
                [self cancelById:self.thirdId];
                self.isFocus3 = NO;
            }
                break;
                
            default:
                break;
        }
        
    } else {
        
        switch (sender.tag - 100) {
            case 0: {
                [self focusById:self.firstId];
                self.isFocus1 = YES;
            }
                break;
            case 1: {
                [self focusById:self.secondId];
                self.isFocus2 = YES;
            }
                break;
            case 2: {
                [self focusById:self.thirdId];
                self.isFocus3 = YES;
            }
                break;
                
            default:
                break;
        }
        
    }
    
    sender.selected = !sender.selected;

}

// 关注
- (void)focusById:(NSString *)focusId {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *myId = [wrapper objectForKey:(id)kSecValueData];
    
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_FOCUS, focusId, myId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        
        STRONG_SELF;
        
        if (self.refreshFocusBlock) {
            self.refreshFocusBlock();
        }
        
        /*msg type 2 关注*/
        if (![focusId isEqualToString:myId]) {
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, focusId, myId, @"2", @"", @"", @""] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

// 取消关注
- (void)cancelById:(NSString *)focusId {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *myId = [wrapper objectForKey:(id)kSecValueData];
    
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:DEL_FOCUS, focusId, myId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        
        STRONG_SELF;
        if (self.refreshFocusBlock) {
            self.refreshFocusBlock();
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)headButtonAction:(UIButton *)sender {
    
    
    switch (sender.tag - 1000) {
        case 0: {
            if (self.memberToUserCenterBlock) {
                self.memberToUserCenterBlock(self.firstId);
            }
        }
            break;
        case 1: {
            if (self.memberToUserCenterBlock) {
                self.memberToUserCenterBlock(self.secondId);
            }
        }
            break;
        case 2: {
            if (self.memberToUserCenterBlock) {
                self.memberToUserCenterBlock(self.thirdId);
            }
        }
            break;
            
        default:
            break;
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
