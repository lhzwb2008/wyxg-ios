//
//  OtherPersonCenterController.m
//  CreateSongs
//
//  Created by axg on 16/7/18.
//  Copyright © 2016年 AXG. All rights reserved.
//

#import "OtherPersonCenterController.h"
#import "AppDelegate.h"
#import "ImageZoom.h"
#import "NavLeftButton.h"
#import "LoginViewController.h"
#import "ChatViewController.h"
#import "EMSDK.h"

@implementation OtherPersonCenterController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.panView removeFromSuperview];
    
//    self.sixinButton.hidden = NO;
    
//    self.focusBtn.hidden = NO;
}

//- (instancetype)initWIthUserId:(NSString *)userId {
//    self = [super init];
//    if (self) {
//        self.userId = userId;
//    }
//    return self;
//}

- (void)createNavView {
    UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    [self.view addSubview:navView];
    navView.backgroundColor = [UIColor clearColor];
    self.navView = navView;
    
    
    self.bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 64)];
    self.bottomView.alpha = 0.0f;
    self.bottomView.backgroundColor = [UIColor colorWithHexString:@"#FFDC74"];
    [navView addSubview:self.bottomView];
    
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
    [navView addSubview:self.titleLabel];
    self.titleLabel.textColor = HexStringColor(@"#441D11");
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.font = TECU_FONT(18);
    
    UIImageView *backImage = [[UIImageView alloc] initWithFrame:CGRectMake(18 * WIDTH_NIT, 30, 23, 20)];
    backImage.centerY = (44)/2 + 20;
    [navView addSubview:backImage];
//    backImage.image = [UIImage imageNamed:@"返回"];
    
    self.titleLabel.center = CGPointMake(self.view.width / 2, backImage.centerY);
    
    NavLeftButton *leftButton = [NavLeftButton buttonWithType:UIButtonTypeCustom];
    leftButton.frame = CGRectMake(0, 0, 64, 64);
    [leftButton setImage:[UIImage imageNamed:@"返回"] forState:UIControlStateNormal];
    [leftButton setImage:[UIImage imageNamed:@"返回_高亮"] forState:UIControlStateHighlighted];
    [navView addSubview:leftButton];
    [leftButton addTarget:self action:@selector(backButtonAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (NSString *)getUserId {

    return self.userId;
}


- (void)backButtonAction:(UIButton *)btn {

    [self.navigationController popViewControllerAnimated:YES];
}

// 他人个人中心关注
- (void)focusButtonAction:(UIButton *)sender {
    if (self.isFocus) {
        [self cancelFollow];
    } else {
        [self follow];
    }
}

// 私信按钮方法
- (void)otherSixinButtonAction {
    
    if (!self.sixinButton.hidden) {
        NSLog(@"子类私信方法点击");
        
        if ([[[NSUserDefaults standardUserDefaults] objectForKey:IS_LOGIN] isEqualToString:IS_LOGIN_YES]) {
            
            KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
//            NSString *selfUserId = [wrapper objectForKey:(id)kSecValueData];
            NSString *selfPhone = [wrapper objectForKey:(id)kSecAttrAccount];
            NSString *userId = [wrapper objectForKey:(id)kSecValueData];
            NSString *rightImg = [NSString stringWithFormat:GET_USER_HEAD, [XWAFNetworkTool md5HexDigest:selfPhone]];
            NSString *leftName = self.sixinName;
            NSString *leftImg = self.sixinImg;
            
            if ([[EMClient sharedClient] isLoggedIn]) {
                ChatViewController *chatView = [[ChatViewController alloc] initWithConversationChatter:self.userId conversationType:EMConversationTypeChat];
                chatView.leftNameFromSuper = leftName;
                chatView.leftHeadImgFromSuper = leftImg;
                chatView.rightHeadImgFromSuper = rightImg;
                [self.navigationController pushViewController:chatView animated:YES];
            } else {
                EMError *error = [[EMClient sharedClient] loginWithUsername:userId password:@"000"];
                if (!error) {
                    NSLog(@"登录成功");
                    
                    ChatViewController *chatView = [[ChatViewController alloc] initWithConversationChatter:self.userId conversationType:EMConversationTypeChat];
                    chatView.leftNameFromSuper = leftName;
                    chatView.leftHeadImgFromSuper = leftImg;
                    chatView.rightHeadImgFromSuper = rightImg;
                    [self.navigationController pushViewController:chatView animated:YES];
                    
                } else {
                    NSLog(@"登录失败 %@", error.description);
                }
            }
            
        } else {
            
            AXG_LOGIN(LOGIN_LOCATION_PERSON_CENTER);
            
        }
        
    }
}

- (void)changeUserId:(NSString *)userId {
    self.userId = userId;
}

- (void)turnToUserPage:(FocusTableViewCell *)cell index:(NSInteger)index {

    OtherPersonCenterController *personVC = [[OtherPersonCenterController alloc] initWIthUserId:cell.userId];

    [self.navigationController pushViewController:personVC animated:YES];
}

- (void)follow {
    
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *myId = [wrapper objectForKey:(id)kSecValueData];
   
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_FOCUS, self.userId, myId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        /*msg type 2 关注*/
        if (![self.userId isEqualToString:myId]) {
            [XWAFNetworkTool getUrl:[NSString stringWithFormat:ADD_MESSAGE, weakSelf.userId, myId, @"2", @"", @"", @""] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
                
            } failure:^(NSURLSessionDataTask *task, NSError *error) {
                
            }];
        }
        [self isFocus:YES];
//        [self.focusBtn setTitle:@"已关注" forState:UIControlStateNormal];
        self.isFocus = YES;
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

- (void)cancelFollow {
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *myId = [wrapper objectForKey:(id)kSecValueData];
    WEAK_SELF;
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:DEL_FOCUS, self.userId, myId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        STRONG_SELF;
        self.isFocus = NO;
        [self isFocus:NO];
//        [self.focusBtn setTitle:@"关注" forState:UIControlStateNormal];
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}

// 更新个人信息
- (void)updatePersonInfo {
    
    //    NSString *account = [self getAccount];
    
    //    NSString *accountImage = [NSString stringWithFormat:@"%@", [NSString md5HexDigest:account]];
    
    __weak typeof(self)weakSelf = self;
    
    NSString *userId = [self getUserId];
    
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_USER_ID_URL, userId] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        //     status 0 正常 -1 用户不存在 -2 查询出错
        NSLog(@" success %@", resposeObject);
        
        NSDictionary *dic = resposeObject;
        
        if ([dic[@"status"] isEqualToNumber:@0]) {
            
            
            NSString *nick = [dic[@"name"] emojizedString];
            
            weakSelf.nickName.text = nick;
            
            NSString *account = dic[@"phone"];
            
            NSString *accountImage = [NSString stringWithFormat:@"%@", [XWAFNetworkTool md5HexDigest:account]];
            //            weakSelf.headImage.image = image.image;
            
            //            NSLog(@"%@", [NSURL URLWithString:[NSString stringWithFormat:GET_USER_HEAD, accountImage]]);
            [weakSelf.headImage sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:GET_USER_HEAD, accountImage]] placeholderImage:[UIImage imageNamed:@"头像"]];
            
            weakSelf.sixinImg = [NSString stringWithFormat:GET_USER_HEAD, accountImage];
            
            weakSelf.titleLabel.text = nick;
            weakSelf.titleLabel2.text = nick;
            
            weakSelf.sixinName = nick;
            
            if ([dic[@"gender"] isEqualToString:@"1"]) {
                self.genderImage.image = [UIImage imageNamed:@"male"];
            } else {
                self.genderImage.image = [UIImage imageNamed:@"female"];
            }
            
            id signature = resposeObject[@"signature"];
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
            NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:self.signature.text];
            NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
            [paragraphStyle setLineSpacing:15];
            [paragraphStyle setAlignment:NSTextAlignmentCenter];
            [attributedString addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [self.signature.text length])];
            self.signature.attributedText = attributedString;
        }
        
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        NSLog(@"%s--%@", __func__,error.description);
    }];
    KeychainItemWrapper *wrapper = [[KeychainItemWrapper alloc] initWithIdentifier:USER_ACCOUNT accessGroup:nil];
    NSString *userId1 = [wrapper objectForKey:(id)kSecValueData];
    if ([userId1 isEqualToString:self.userId]) {
        self.focusBtn.hidden = YES;
        self.sixinButton.hidden = YES;
    } else {
        self.focusBtn.hidden = NO;
        self.sixinButton.hidden = NO;
    }
    [XWAFNetworkTool getUrl:[NSString stringWithFormat:GET_FOCUS, userId1] body:nil response:XWJSON requestHeadFile:nil success:^(NSURLSessionDataTask *task, id resposeObject) {
        if ([resposeObject[@"status"] isEqualToNumber:@0]) {
            NSArray *items = resposeObject[@"items"];
            
            [weakSelf isFocus:NO];
            weakSelf.isFocus = NO;
            
            for (NSDictionary *dic in items) {
                if ([dic[@"focus_id"] isEqualToString:userId]) {
                    [weakSelf isFocus:YES];
                    weakSelf.isFocus = YES;
                }
                weakSelf.focusBtn.enabled = YES;
            }
        }
    } failure:^(NSURLSessionDataTask *task, NSError *error) {
        
    }];
}
// 他人头像点击方法
- (void)clickHeadImage {
    
    [ImageZoom showImage:self.headImage];
}

- (void)createMsgView {
    
};


@end
