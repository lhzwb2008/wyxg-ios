//
//  DrawerView.m
//  CreateSongs
//
//  Created by 爱写歌 on 16/7/15.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "DrawerView.h"
#import "AXGHeader.h"
#import "PersonCenterController.h"
#import "MsgButton.h"

@implementation DrawerView

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self createDrawer];
    }
    return self;
}

- (void)createDrawer {
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(turnToHomePage) name:@"turnToHomePage" object:nil];
    
    self.backgroundColor = RGBColor(255, 255, 255, 0.9);
    
    UIView *headBgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 250 * WIDTH_NIT, 165 * HEIGHT_NIT)];
    [self addSubview:headBgView];
    headBgView.backgroundColor = HexStringColor(@"#FFDC74");
    
    self.themeImage = [[UIImageView alloc] initWithFrame:CGRectMake(75 * WIDTH_NIT, 50 * HEIGHT_NIT, 75 * WIDTH_NIT, 75 * WIDTH_NIT)];
    self.themeImage.center = CGPointMake(19 * WIDTH_NIT + 37.5 * WIDTH_NIT, 45 * HEIGHT_NIT + 37.5 * HEIGHT_NIT);
    self.themeImage.layer.cornerRadius = self.themeImage.width / 2;
    self.themeImage.layer.masksToBounds = YES;
    self.themeImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.themeImage.layer.borderWidth = 0.5;
    [self addSubview:self.themeImage];
    self.themeImage.image = [UIImage imageNamed:@"头像"];
    
    UIButton *themeButton = [UIButton new];
    themeButton.frame = self.themeImage.frame;
    themeButton.backgroundColor = [UIColor clearColor];
    [self addSubview:themeButton];
    themeButton.tag = 105;
    [themeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.themeImage.right + 15 * WIDTH_NIT, self.themeImage.top, self.width - 19 * WIDTH_NIT - 75 * WIDTH_NIT - 15 * WIDTH_NIT, 32 * HEIGHT_NIT)];
    [self addSubview:self.nameLabel];
    self.nameLabel.textColor = HexStringColor(@"#441D11");
    self.nameLabel.font = ZHONGDENG_FONT(12);
    self.nameLabel.text = @"请登录";
    self.nameLabel.textAlignment = NSTextAlignmentLeft;
    
    self.msgButton = [MsgButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.msgButton];
    self.msgButton.frame = CGRectMake(self.themeImage.right, self.themeImage.top + 30 * HEIGHT_NIT, 70 * WIDTH_NIT + 30 * WIDTH_NIT, 30 * WIDTH_NIT + 30 * HEIGHT_NIT);
    [self.msgButton setImage:[UIImage imageNamed:@"站内信"] forState:UIControlStateNormal];
    [self.msgButton setImage:[UIImage imageNamed:@"站内信_消息"] forState:UIControlStateSelected];
    self.msgButton.tag = 108;
    [self.msgButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 首页
//    self.homeImage = [[UIImageView alloc] initWithFrame:CGRectMake(78.5 * WIDTH_NIT, self.nameLabel.bottom + 50 * HEIGHT_NIT - 4 * HEIGHT_NIT, 40 * WIDTH_NIT, 40 * WIDTH_NIT)];
//    [self addSubview:self.homeImage];
////    self.homeImage.image = [UIImage imageNamed:@"首页"];
//    self.homeImage.layer.cornerRadius = self.homeImage.width / 2;
//    self.homeImage.layer.masksToBounds = YES;
//    self.homeImage.center = CGPointMake(self.homeImage.centerX, self.themeImage.centerY + 50 * HEIGHT_NIT + 20 * HEIGHT_NIT + 12 * HEIGHT_NIT + 50 * HEIGHT_NIT);
//    
//    self.homeLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.homeImage.right + 25 * WIDTH_NIT, self.homeImage.top, self.width - self.homeImage.right - 25 * WIDTH_NIT, self.homeImage.height)];
//    [self addSubview:self.homeLabel];
////    self.homeLabel.text = @"首页";
//    self.homeLabel.textColor = HexStringColor(@"#535353");
//    [self.homeLabel setFont:JIACU_FONT(15)];
    
    self.homeButton = [DrawerButton buttonWithType:UIButtonTypeCustom];
    self.homeButton.frame = CGRectMake(0, headBgView.bottom + 35 * HEIGHT_NIT, self.width, 40 * WIDTH_NIT);
    [self addSubview:self.homeButton];
    self.homeButton.backgroundColor = [UIColor clearColor];
    self.homeButton.tag = 100;
    [self.homeButton setImage:[UIImage imageNamed:@"首页"] forState:UIControlStateSelected];
    [self.homeButton setImage:[UIImage imageNamed:@"首页_normal"] forState:UIControlStateNormal];
    [self.homeButton setTitle:@"首页" forState:UIControlStateNormal];
    [self.homeButton setTitle:@"首页" forState:UIControlStateSelected];
//    [self.homeButton setTitleColor:HexStringColor(@"#535353") forState:UIControlStateSelected];
//    [self.homeButton setTitleColor:HexStringColor(@"#879999") forState:UIControlStateNormal];
//    [self.homeButton setTitleColor:HexStringColor(@"#535353") forState:UIControlStateHighlighted];
//    self.homeButton.titleLabel.font = JIACU_FONT(15);
    self.homeButton.selected = YES;
    [self.homeButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 个人
//    self.personImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.homeImage.left, self.nameLabel.bottom + 95 * HEIGHT_NIT, 40 * WIDTH_NIT, 40 * WIDTH_NIT)];
//    [self addSubview:self.personImage];
////    self.personImage.image = [UIImage imageNamed:@"个人_normal"];
//    self.personImage.layer.cornerRadius = self.personImage.width / 2;
//    self.personImage.layer.masksToBounds = YES;
//    self.personImage.center = CGPointMake(self.personImage.centerX, self.homeImage.centerY + 25 * HEIGHT_NIT + 40 * WIDTH_NIT);
//    
//    self.personLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.personImage.right + 25 * WIDTH_NIT, self.personImage.top, self.width - self.personImage.right - 25 * WIDTH_NIT, self.personImage.height)];
//    [self addSubview:self.personLabel];
////    self.personLabel.text = @"个人";
//    self.personLabel.textColor = HexStringColor(@"#879999");
//    [self.personLabel setFont:JIACU_FONT(15)];
    
    self.personButton = [DrawerButton buttonWithType:UIButtonTypeCustom];
    self.personButton.frame = CGRectMake(0, self.homeButton.bottom + 30 * HEIGHT_NIT, self.width, self.homeButton.height);
    [self addSubview:self.personButton];
    self.personButton.backgroundColor = [UIColor clearColor];
    self.personButton.tag = 101;
    [self.personButton setImage:[UIImage imageNamed:@"个人"] forState:UIControlStateSelected];
    [self.personButton setImage:[UIImage imageNamed:@"个人_normal"] forState:UIControlStateNormal];
    [self.personButton setTitle:@"个人中心" forState:UIControlStateNormal];
    [self.personButton setTitle:@"个人中心" forState:UIControlStateSelected];
//    [self.personButton setTitleColor:HexStringColor(@"#535353") forState:UIControlStateSelected];
//    [self.personButton setTitleColor:HexStringColor(@"#879999") forState:UIControlStateNormal];
//    [self.personButton setTitleColor:HexStringColor(@"#535353") forState:UIControlStateHighlighted];
//    self.personButton.titleLabel.font = JIACU_FONT(15);
    self.personButton.selected = NO;
    [self.personButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 草稿
//    self.draftsImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.homeImage.left, self.nameLabel.bottom + 95 * HEIGHT_NIT, 40 * WIDTH_NIT, 40 * WIDTH_NIT)];
//    [self addSubview:self.draftsImage];
////    self.draftsImage.image = [UIImage imageNamed:@"草稿箱_normal"];
//    self.draftsImage.layer.cornerRadius = self.draftsImage.width / 2;
//    self.draftsImage.layer.masksToBounds = YES;
//    self.draftsImage.center = CGPointMake(self.draftsImage.centerX, self.personButton.centerY + 25 * HEIGHT_NIT + 40 * WIDTH_NIT);
//    
//    self.draftsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.draftsImage.right + 25 * WIDTH_NIT, self.draftsImage.top, self.width - self.draftsImage.right - 25 * WIDTH_NIT, self.draftsImage.height)];
//    [self addSubview:self.draftsLabel];
////    self.draftsLabel.text = @"草稿";
//    self.draftsLabel.textColor = HexStringColor(@"#879999");
//    [self.draftsLabel setFont:JIACU_FONT(15)];
    
    self.draftsButton = [DrawerButton buttonWithType:UIButtonTypeCustom];
    self.draftsButton.frame = CGRectMake(0, self.personButton.bottom + 30 * HEIGHT_NIT, self.width, self.personButton.height);
    [self addSubview:self.draftsButton];
    self.draftsButton.backgroundColor = [UIColor clearColor];
    self.draftsButton.tag = 103;
    [self.draftsButton setImage:[UIImage imageNamed:@"草稿箱"] forState:UIControlStateSelected];
    [self.draftsButton setImage:[UIImage imageNamed:@"草稿箱_normal"] forState:UIControlStateNormal];
    [self.draftsButton setTitle:@"草稿箱" forState:UIControlStateNormal];
    [self.draftsButton setTitle:@"草稿箱" forState:UIControlStateSelected];
//    [self.draftsButton setTitleColor:HexStringColor(@"#535353") forState:UIControlStateSelected];
//    [self.draftsButton setTitleColor:HexStringColor(@"#879999") forState:UIControlStateNormal];
//    [self.draftsButton setTitleColor:HexStringColor(@"#535353") forState:UIControlStateHighlighted];
//    self.draftsButton.titleLabel.font = JIACU_FONT(15);
    self.draftsButton.selected = NO;
    [self.draftsButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    // 乐谈
    //    self.forumImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.homeImage.left, self.nameLabel.bottom + 95 * HEIGHT_NIT, 40 * WIDTH_NIT, 40 * WIDTH_NIT)];
    //    [self addSubview:self.forumImage];
    //    //    self.forumImage.image = [UIImage imageNamed:@"乐谈icon"];
    //    self.forumImage.layer.cornerRadius = self.forumImage.width / 2;
    //    self.forumImage.layer.masksToBounds = YES;
    //    self.forumImage.center = CGPointMake(self.forumImage.centerX, self.draftsImage.centerY + 25 * HEIGHT_NIT + 40 * WIDTH_NIT);
    //
    //    self.forumLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.forumImage.right + 25 * WIDTH_NIT, self.forumImage.top, self.width - self.forumImage.right - 25 * WIDTH_NIT, self.forumImage.height)];
    //    [self addSubview:self.forumLabel];
    //    //    self.forumLabel.text = @"乐谈";
    //    self.forumLabel.textColor = HexStringColor(@"#879999");
    //    [self.forumLabel setFont:JIACU_FONT(15)];
    
//    self.forumButton = [DrawerButton buttonWithType:UIButtonTypeCustom];
//    self.forumButton.frame = CGRectMake(0, self.draftsButton.bottom + 30 * HEIGHT_NIT, self.width, self.draftsButton.height);
//    [self addSubview:self.forumButton];
//    self.forumButton.backgroundColor = [UIColor clearColor];
//    self.forumButton.tag = 104;
//    [self.forumButton setImage:[UIImage imageNamed:@"乐谈icon-拷贝"] forState:UIControlStateSelected];
//    [self.forumButton setImage:[UIImage imageNamed:@"乐谈icon"] forState:UIControlStateNormal];
//    [self.forumButton setTitle:@"乐谈" forState:UIControlStateNormal];
//    [self.forumButton setTitle:@"乐谈" forState:UIControlStateSelected];
//    //    [self.forumButton setTitleColor:HexStringColor(@"#535353") forState:UIControlStateSelected];
//    //    [self.forumButton setTitleColor:HexStringColor(@"#879999") forState:UIControlStateNormal];
//    //    [self.forumButton setTitleColor:HexStringColor(@"#535353") forState:UIControlStateHighlighted];
//    //    self.forumButton.titleLabel.font = JIACU_FONT(15);
//    self.forumButton.selected = NO;
//    [self.forumButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    

    // 意见
//    self.suggestionImage = [[UIImageView alloc] initWithFrame:CGRectMake(self.homeImage.left, self.nameLabel.bottom + 95 * HEIGHT_NIT, 40 * WIDTH_NIT, 40 * WIDTH_NIT)];
//    [self addSubview:self.suggestionImage];
////    self.suggestionImage.image = [UIImage imageNamed:@"意见_normal"];
//    self.suggestionImage.layer.cornerRadius = self.suggestionImage.width / 2;
//    self.suggestionImage.layer.masksToBounds = YES;
//    self.suggestionImage.center = CGPointMake(self.suggestionImage.centerX, self.forumImage.centerY + 25 * HEIGHT_NIT + 40 * WIDTH_NIT);
//    
//    self.suggesttionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.suggestionImage.right + 25 * WIDTH_NIT, self.suggestionImage.top, self.width - self.suggestionImage.right - 25 * WIDTH_NIT, self.suggestionImage.height)];
//    [self addSubview:self.suggesttionLabel];
////    self.suggesttionLabel.text = @"建议";
//    self.suggesttionLabel.textColor = HexStringColor(@"#879999");
//    [self.suggesttionLabel setFont:JIACU_FONT(15)];
    
    self.suggestionButton = [DrawerButton buttonWithType:UIButtonTypeCustom];
    self.suggestionButton.frame = CGRectMake(0, self.draftsButton.bottom + 30 * HEIGHT_NIT, self.width, self.draftsButton.height);
    [self addSubview:self.suggestionButton];
    self.suggestionButton.backgroundColor = [UIColor clearColor];
    self.suggestionButton.tag = 102;
    [self.suggestionButton setImage:[UIImage imageNamed:@"意见"] forState:UIControlStateSelected];
    [self.suggestionButton setImage:[UIImage imageNamed:@"意见_normal"] forState:UIControlStateNormal];
    [self.suggestionButton setTitle:@"意见反馈" forState:UIControlStateNormal];
    [self.suggestionButton setTitle:@"意见反馈" forState:UIControlStateSelected];
//    [self.suggestionButton setTitleColor:HexStringColor(@"#535353") forState:UIControlStateSelected];
//    [self.suggestionButton setTitleColor:HexStringColor(@"#879999") forState:UIControlStateNormal];
//    [self.suggestionButton setTitleColor:HexStringColor(@"#535353") forState:UIControlStateHighlighted];
//    self.suggestionButton.titleLabel.font = JIACU_FONT(15);
    self.suggestionButton.selected = NO;
    [self.suggestionButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
#if ALLOW_WALLET
    
    // 钱包
    self.walletButton = [DrawerButton buttonWithType:UIButtonTypeCustom];
    [self addSubview:self.walletButton];
    self.walletButton.frame = CGRectMake(self.suggestionButton.left, self.suggestionButton.bottom + 30 * HEIGHT_NIT, self.suggestionButton.width, self.suggestionButton.height);
    self.walletButton.backgroundColor = [UIColor clearColor];
    [self.walletButton setImage:[UIImage imageNamed:@"钱包"] forState:UIControlStateSelected];
    [self.walletButton setImage:[UIImage imageNamed:@"钱包_normal"] forState:UIControlStateNormal];
    [self.walletButton setTitle:@"我的钱包" forState:UIControlStateNormal];
    [self.walletButton setTitle:@"我的钱包" forState:UIControlStateSelected];
    self.walletButton.selected = NO;
    self.walletButton.tag = 107;
    [self.walletButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
 
#endif
    
    DrawerSettingButton *settingButton = [DrawerSettingButton buttonWithType:UIButtonTypeCustom];
    settingButton.tag = 106;
    [self addSubview:settingButton];
    settingButton.frame = CGRectMake(250 * WIDTH_NIT - 20 * WIDTH_NIT - 26 * WIDTH_NIT - 20 * WIDTH_NIT, self.height - 20 * WIDTH_NIT * 2 - 24.5 * WIDTH_NIT, 20 * WIDTH_NIT + 26 * WIDTH_NIT + 20 * WIDTH_NIT, 20 * WIDTH_NIT * 2 + 24.5 * WIDTH_NIT);
    [settingButton setImage:[UIImage imageNamed:@"抽屉_设置"] forState:UIControlStateNormal];
    [settingButton addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    
}

- (void)turnToHomePage {
    NSString *message = @"";
//    self.homeImage.image = [UIImage imageNamed:@"首页"];
//    self.personImage.image = [UIImage imageNamed:@"个人_normal"];
//    self.draftsImage.image = [UIImage imageNamed:@"草稿箱_normal"];
//    self.suggestionImage.image = [UIImage imageNamed:@"意见_normal"];
//    self.forumImage.image = [UIImage imageNamed:@"乐谈icon"];
//    
//    self.homeLabel.textColor = HexStringColor(@"#535353");
//    self.personLabel.textColor = HexStringColor(@"#879999");
//    self.draftsLabel.textColor = HexStringColor(@"#879999");
//    self.forumLabel.textColor = HexStringColor(@"#879999");
//    self.suggesttionLabel.textColor = HexStringColor(@"#879999");
    
    self.homeButton.selected = YES;
    self.personButton.selected = NO;
    self.draftsButton.selected = NO;
    self.suggestionButton.selected = NO;
    self.forumButton.selected = NO;
    
    message = @"首页";
    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDrawerRoot" object:message];
}

- (void)changeShowState:(NSInteger)index {
    if (index == 0) {
        self.homeButton.selected = YES;
        self.personButton.selected = NO;
        self.draftsButton.selected = NO;
        self.suggestionButton.selected = NO;
        self.forumButton.selected = NO;
        self.walletButton.selected = NO;
    }
}

// 按钮方法
- (void)buttonAction:(UIButton *)sender {
    
    NSString *message = @"";
    
    if (self.drawerSelected) {
        self.drawerSelected(sender.tag - 100);
    }
    
    switch (sender.tag - 100) {
        case 0: {

            self.homeButton.selected = YES;
            self.personButton.selected = NO;
            self.draftsButton.selected = NO;
            self.suggestionButton.selected = NO;
            self.forumButton.selected = NO;
            self.walletButton.selected = NO;
            
            message = @"首页";
        }
            break;
        case 1: {
            // 个人中心
            
            self.homeButton.selected = NO;
            self.personButton.selected = YES;
            self.draftsButton.selected = NO;
            self.suggestionButton.selected = NO;
            self.forumButton.selected = NO;
            self.walletButton.selected = NO;
            
            message = @"个人";
        }
            break;
        case 2: {

            self.homeButton.selected = NO;
            self.personButton.selected = NO;
            self.draftsButton.selected = NO;
            self.suggestionButton.selected = YES;
            self.forumButton.selected = NO;
            self.walletButton.selected = NO;
            
            message = @"建议";
            

        }
            break;
        case 3: {
            
            self.homeButton.selected = NO;
            self.personButton.selected = NO;
            self.draftsButton.selected = YES;
            self.suggestionButton.selected = NO;
            self.forumButton.selected = NO;
            self.walletButton.selected = NO;
            
            message = @"草稿";
            
        }
            break;
        case 4: {
            
            self.homeButton.selected = NO;
            self.personButton.selected = NO;
            self.draftsButton.selected = NO;
            self.suggestionButton.selected = NO;
            self.forumButton.selected = YES;
            self.walletButton.selected = NO;
            
            message = @"乐谈";
            
        }
            break;
        case 5: {
            message = @"头像";
        }
            break;
        case 7: {
            
            self.homeButton.selected = NO;
            self.personButton.selected = NO;
            self.draftsButton.selected = NO;
            self.suggestionButton.selected = NO;
            self.forumButton.selected = NO;
            self.walletButton.selected = YES;
            
        }
            break;
            
        default:
            break;
    }
    
//    [[NSNotificationCenter defaultCenter] postNotificationName:@"changeDrawerRoot" object:message];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
